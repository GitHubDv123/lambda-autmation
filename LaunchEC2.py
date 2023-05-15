import json
import boto3
import os

from datetime import datetime, timedelta, timezone

ec2 = boto3.client('ec2')

# Define the userdata script
userdata_script = '''#!/bin/bash
echo "Hello, world!" >> /tmp/hello.txt
aws s3 cp s3://ami-automation-sre/userdata.sh /tmp/
cd /tmp
chmod 755 userdata.sh
sh userdata.sh
'''

def lambda_handler(event, context):
    
    # Fetching AMI value as input from other Lamda
    try:
       ami = json.loads(event["body"])
       print ("AMI ID " , ami)
    except Exception as e:
       print ("No AMI retured" , str(e))
        
    # Launching EC2 instance with the fetched AMI
    try:    
        response = ec2.run_instances(
            ImageId = ami,
            #ImageId = 'ami-09ef086482da557d8',
            InstanceType='t2.medium',
            KeyName='digitalx-co-uk-non-prod-2020-02-24',
            SubnetId = 'subnet-0be977aecc05d94ab',
            SecurityGroupIds = ['sg-059cd8448770f3bd8'],
            IamInstanceProfile={
            'Arn': 'arn:aws:iam::855389350164:instance-profile/co-uk-dev-ecare-EcareInstanceProfile-1G9HHHIL7VYVS'
            },
            UserData=userdata_script,
            MinCount=1,
            MaxCount=1,
            TagSpecifications=[
            {
                'ResourceType': 'instance',
                'Tags': [
                    {
                        'Key': 'Confidentiality',
                        'Value': 'C2'
                    },
                    {
                        'Key': 'Name',
                        'Value': 'co-uk-sre-configchanges-instance'
                    },
                    {
                        'Key': 'Environment',
                        'Value': 'TEST'
                    },
                    {
                        'Key': 'Project',
                        'Value': 'Ecare'
                    },
                    {
                        'Key': 'ManagedBy',
                        'Value': 'monika.bhargava@vodafone.com'
                    },
                    {
                        'Key': 'Domain',
                        'Value': 'co-uk'
                    },
                    {
                        'Key': 'SecurityZone',
                        'Value': 'TEST'
                    },
    
                ],
            },
        ],  
        )   
    
        instance_id = response['Instances'][0]['InstanceId']
        print("Successfully created instance",instance_id)
        
        # Waiting for instance to be in running and pass status check
        waiter = ec2.get_waiter('instance_running')
        waiter.wait(InstanceIds=[instance_id])
    
        waiter = ec2.get_waiter('instance_status_ok')
        waiter.wait(InstanceIds=[instance_id])
        print('Instance is running and passed both status checks.')
        
    except Exception as err:
        print("Error occured while launching EC2 instance.." , str(err))
        
    try:
        # Create image from above created EC2 instance containing config and user , group 
        response = ec2.create_image(
            InstanceId=instance_id ,
            Name='co-uk-ConfigChanges-AMI', 
            Description='Contains Firewall and Userdata chnages',
            TagSpecifications=[
                {
                    'ResourceType': 'image',
                    'Tags': [
                        {'Key': 'Confidentiality','Value': 'C2'},
                        {'Key': 'Name', 'Value': 'co-uk-ConfigChanges-AMI'},
                        {'Key': 'Environment','Value': 'TEST'},
                        {'Key': 'Project','Value': 'Ecare'},
                        {'Key': 'ManagedBy','Value': 'aditya.dhar@vodafone.com'},
                        {'Key': 'Domain','Value': 'co-uk'},
                        {'Key': 'SecurityZone','Value': 'TEST'},
                    ],
                }, ]
        )
        print('Successfully created image with ID: ', response['ImageId'])
		
    except Exception as e:
        print('Error creating image: ', e)
    
        
        

   
    return {
        'statusCode': 200,
        'body': json.dumps('Image created successfully!!!')
    }