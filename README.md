# Informatica - Informatica HDInsight Solution Template
<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2Ftrend-chef-splunk-security%2Fazuredeploy.json" target="_blank">
<img src="http://azuredeploy.net/deploybutton.png"/>
</a>
<a href="http://armviz.io/#/?load=https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2Ftrend-chef-splunk-security%2Fazuredeploy.json" target="_blank">
<img src="http://armviz.io/visualizebutton.png"/>
</a>

## Solution Template Overview
***Solution Templates*** provide customers with a highly automated process to launch enterprise ready first and 3rd party ISV solution stacks on Azure in a pre-production environment. The **Solution Template** effort is complimentary to the [Azure Marketplace test drive program](https://azure.microsoft.com/en-us/marketplace/test-drives/). These fully baked stacks enable customers to quickly stand up a PoC or Piloting environments and also integrate it with their systems and customization.

Customers benefit greatly from solution templates because of the ease with which they can stand up enterprise-grade, fully integrated stacks on Azure. The extensive automation and testing of these solutions will allow them to spin up pre-production environments with minimal manual steps and customization.  Most importantly, customers now have the confidence to transition the solution into a fully production-ready environment with confidence.

**Informatica HDInsight Solution Template** launches a bigdata solution stack that provides an automated provisioning, configuration and integration of Informatica Cloud and [Informatica CSA]https://azure.microsoft.com/en-us/marketplace/partners/informatica-cloud/informatica-cloud/) product on Azure. Combined with Azure Data Factory with ondemand HDInsight and SQL Datawarehouse products makes this solution ready for pre-production environments. These are intended as pilot solutions and not production ready.
Please [contact us](azuremarketplace@sysgain.com) if you need further info or support on this solution.

##Licenses & Costs
In its current state, solution templates come with licenses built-in for Cloudbees Jenkins and Docker Datacenter needs a license( 30 day trial is available). The solution template will be deployed in the Customer’s Azure subscription, and the Customer will incur Azure usage charges associated with running the solution stack.

##Target Audience
The target audience for these solution templates are IT professionals who need to stand-up and/or deploy infrastructure stacks.

## Prerequisites
* Azure Subscription - if you want to test drive individual ISV products, please check out the [Azure Marketplace Test Drive Program ](https://azure.microsoft.com/en-us/marketplace/test-drives/)
* Azure user account with Contributor/Admin Role
* Sufficient Quota - At least 14 Cores( with default VM Sizes)
 
##Solution Summary
The goal of this P2P is to build an automated big data solution stack ready for pre-production deployments. This will allow customers to bring in their own data sources and ingest them into a managed Hadoop cluster for processing and store the results in Enterprise grade Data warehouse. This can be used for near real time visualization of data to gain actionable insights using Power BI.
![](images/azure-trend-splunk-chef.png)

The core component of this stack is Docker Datacenter, is an integrated solution including open source and commercial software, the integrations between them, full Docker API support, validated configurations and commercial support for your Docker Datacenter environment. A pluggable architecture allows flexibility in compute, networking and storage providers used in your CaaS infrastructure without disrupting the application code. Enterprises can leverage existing technology investments with Docker Datacenter. The open APIs allow Docker Datacenter CaaS to easily integrate into your existing systems like LDAP/AD, monitoring, logging and more.

You can find more information here: https://www.docker.com/products/docker-datacenter

Docker Datacenter consists of 3 components:

1. **Informatica Cloud :** UCP is an enterprise-grade cluster management solution from Docker that helps you manage your cluster using a single plane of glass. It is architected on top of swarm that comes with Docker engine. The UCP cluster consists of controllers ( masters) and nodes (workers).
2. **Azure Data Factory :** DTR is the enterprise-grade image storage solution from Docker that helps you can securely store and manage the Docker images you use in your applications. DTR is made of DTR replicas only that are deployed on UCP nodes.
3. **Azure HDInsight :** The CS engine adds support to the existing Docker engine. This becomes very useful when patches and fixes will have to be backported to engines running in production instead of updating the entire engine.
4. **Azure SQL Datawarehouse :** Sql DW
5. **Power BI :** Power BI

![]( images/DDC-Azure-Arch.png)

TrendMicro DSM is an agents based security control platform. The agents need to be deployed and configured to integrate with the Master server. As new VM's are launched in the cloud, there needs to be an automated way of bootstrapping these agents to the master. This is a typical problem in many cloud deployments. This solution stack provides two ways of deploying the agents in a dynamic manner

1. **TrendMicro Azure Extension:** Azure provides an extension to deploy and configure the agent on a VM.
2. **TrendMicro Chef Cookbooks:** Configuration Management is a key aspect in configuring servers, its applications and handling security. Chef, which is a very popular configuration management solution, can be used to install and configure TrendMicro agents. Further Chef recipes can be used to manage configuration of the application and servers to ensure they fall in line with the security policies defined in Trend Micro DSM. 

This solution stack implements the second option (with Chef). It deploys a Chef Server and an automated framework that allows any new VM's to bootstrap to chef Server as and when they get provisioned. Additionally, in order to integrate Chef Server with Chef Nodes in an automated way, additional microservices are deployed as a set of two Docker Containers (a Node.js app and a database).

Cloud security monitoring is another critical aspect of enabling security at scale. The logs and data that is generated on the VMs can be monitored using Splunk's intelligence platform service, part of Splunk Enterprise. This solution stack also deploys the Splunk Enterprise solution and automatically integrates it with TrendMicro DSM to collect all logs and event data from the VMs.
 
##Reference Architecture Diagram
We are going to create an environment from which demos of the Docker CICD use case along with using DTR and UCP can be done. Jenkins will run as a container and handle the building of Docker images. 
![[](images/CI-CD.png)](images/CI-CD.png)

The diagram above provides the overall deployment architecture for this solution template.
As a part of deployment, the template launches the following:

1. A storage account in the resource group.
2. A virtual network , a public IP, Network security group(NSG) is assigned to Network Interface (NIC) which is attached to Informatica VM.
3. Deploys a custom script extension on Informatica VM which enables the Informatica Cloud Security Agent.
4. Deploys SQL Data Warehouse with 100DWUs performance tier with collation “SQL_Latin1_General_CP1_CI_AS” and maximum size of 10 Terabytes.
5. Deploys Automation Job with an automation account which creates a table in the SQL Data Warehouse
6. Deploys Data Factory with three data sets, three Linked Services( two Storage linked services and one HDInsight on demand service) and one Pipeline which contains two activities one for running Hive script and one for Copy the data from Azure Blob to Azure Data Warehouse.
7. Deploys VM with Power BI for data analysis.
 
## Deployment Steps
You can click the "deploy to Azure" button at the beginning of this document or follow the instructions for command line deployment using the scripts in the root of this repo.

***Please refer to parameter descriptions if you need more information on what needs to be provided as an input.***
The deployment takes about 30-45 mins.
##Usage
#### Connect
Login to Informatica Virtual machine with the provided output URL & Credentials. We can also login to the SQL Data Warehouse with the provided output URL to check the table. We can check the Data Factory from the portal to see the Pipeline and the linked services from the Azure Portal in the deployed resource group.

By logging into the Power BI VM with the provided output URL & Credentials we can see the different kinds of reports.
You can use the [this guide](images/xxx.pdf).

##Support
For any support-related issues or questions, please contact azuremarketplace@sysgain.com for assistance.

