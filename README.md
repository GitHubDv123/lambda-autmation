# Notes on release.yaml file
This file points the releae to the release framework designed by release-engineering team. Below are the updates that are required before deploying this service
- The key word "replacethis" should be replaced with serviceName where the Servicename is the name of the repo without "prefix" and "-lambda"
- For example: repo Name is dal-myservicename-lambda (prefix-ServiceName-lambda), replacethis should be replaced with "myservicename"
    source: \new-world\automated\lambda\dx-replacethis >> becomes >> source: \new-world\automated\lambda\dx-myservicename
    serviceName: myservicename

More details on release framework can be found at - https://vfuk-digital.visualstudio.com/Digital/_wiki/wikis/Digital%20X.wiki/12399/Release-Framework-explained

# Notes on release-variables.yaml file
variables Domain, Division, Program, Team are just examples and you need to change it to match your real values
variables:
  Domain: 'dx'
  Division: 'replacethiswithDivision'
  Program: 'replacethiswithProgram'
  Team: 'replacethiswithTeam'
For more details visit this Wiki https://dev.azure.com/vfuk-digital/Digital/_wiki/wikis/Digital%20X.wiki/14878/How-to-replace-release-variables-in-repos-created-by-slack-pipeline-command

# Introduction 
TODO: Give a short introduction of your project. Let this section explain the objectives or the motivation behind this project. 

# Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation process
2.	Software dependencies
3.	Latest releases
4.	API references

# Build and Test
TODO: Describe and show how to build your code and run the tests. 

# Contribute
TODO: Explain how other users and developers can contribute to make your code better. 

If you want to learn more about creating good readme files then refer the following [guidelines](https://www.visualstudio.com/en-us/docs/git/create-a-readme). You can also seek inspiration from the below readme files:
- [ASP.NET Core](https://github.com/aspnet/Home)
- [Visual Studio Code](https://github.com/Microsoft/vscode)
- [Chakra Core](https://github.com/Microsoft/ChakraCore)