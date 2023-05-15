import json
import boto3
import os
from datetime import datetime, timedelta, timezone

client = boto3.client('ec2')


def lambda_handler(event, context):
    # Function for filtering image based on acount and search parameter
    
    def FilterImage(owner, searchparameter):
        print("Owner value " , owner)
        if owner == '193158486465':
            imageList = client.describe_images(ExecutableUsers=['self'],
                Filters=[{'Name': 'owner-id', 'Values': [owner]},
                {'Name': 'name', 'Values': [searchparameter]}])
        else:
             print("In else")
            #imageList = client.describe_images(Owners=['self'],
            #    Filters=[{'Name': 'owner-id', 'Values': [owner]},
            #   {'Name': 'name', 'Values': [searchparameter]}])        
            
        return imageList
        

    pcsImageList = FilterImage(os.environ['owneraccount'], os.environ['searchparameter'])

    filteredImageList = []
    todaydate = datetime.now()
    try:
        for ami in pcsImageList['Images']:
            if "-sap-" in ami['Name'] :
                print ("This is SAP AMI not required", ami['Name'])
            else :
                ami_creation_date = datetime.strptime(ami['CreationDate'], "%Y-%m-%dT%H:%M:%S.%fZ")
                diffs = todaydate - ami_creation_date
                if diffs <= timedelta(days=7) :
                    filteredImageList.append(ami)
                    
            filteredImageDict = dict({"Images": filteredImageList})
            
        try:
            pcs_images = sorted(filteredImageDict['Images'], key=lambda x: x['CreationDate'], reverse=True)
            print("Latest AMI released from GDCPCMS is - {} {}".format(pcs_images[0]['ImageId'], pcs_images[0]['Name'] ))
            
            # Copying GDCPCMS filtered image to own account
            copy_pcs_image = client.copy_image(
            #Name=pcs_images[0]['Name'],
            Name='co-uk-gdcpcms-AMI',
            SourceImageId=pcs_images[0]['ImageId'],
            SourceRegion='eu-west-1',
            Encrypted=True,
            KmsKeyId='2886f00e-e9ef-4987-ac82-a2a8d69eb456',
            )
            
            print ("Copying AMI from GDCPCMS to Own account ",copy_pcs_image['ImageId'] )
            copy_image_id = copy_pcs_image['ImageId']
            
            # Waiting for AMI to be in Availabe State
            waiter = client.get_waiter('image_available')
            try:
                waiter.wait(ImageIds=[copy_image_id])
               # print ("Image copy task completed successfully for AMI - ",copy_pcs_image['ImageId'] )
            except Exception as waitException:
                print("Error occurred while waiting for image copy task to complete:", str(waitException))
            
            # Adding Tags to copied     
            response = client.create_tags(
                Resources=[
                copy_pcs_image['ImageId'],
                ],
                Tags=[
                        {
                        'Key': 'Name',
                        'Value': 'co-uk-gdcpcms-AMI',
                        },
                     ],
            )
            
        except KeyError as ke :
                print("No images released from GDCPCMS in last 7 days " , str(ke))
        except Exception as copyException:
                print ("Error occured while copy images or no images present",str(copyException))
            
    except  Exception as e:
        print ("Error occured while filtering the Images", str(e))
        
    

    return {
    'statusCode': 200, 
    'body': json.dumps(copy_pcs_image['ImageId'])
    
    }