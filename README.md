# Deploying a VPC Interface Endpoint to connect to SQS
Deploying a VPC Interface Endpoint to connect to SQS

A VPC endpoint enables customers to privately connect to supported AWS services and VPC endpoint services powered by AWS PrivateLink. Amazon VPC instances do not require public IP addresses to communicate with resources of the service. Traffic between an Amazon VPC and a service does not leave the Amazon network.

There are two types of VPC endpoints:
1. interface endpoints
2. gateway endpoints

### Interface endpoints
Interface endpoints enable connectivity to services over AWS PrivateLink. An interface endpoint is a collection of one or more elastic network interfaces with a private IP address that serves as an entry point for traffic destined to a supported service. Interface endpoints support many AWS managed services. 

### Architecture Diagram:

![alt text](/images/diagram.png)

Step 1: Create a VPC

Step 2: Create IAM role with policy and instance profile for sqs access

Step 3: Create Bastion and Private host with instance profile.

Step 4: Create SQS Queue

Step 5: Create VPC Interface Endpoint connected to private subnet.

Terraform Apply Output:
```
Apply complete! Resources: 19 added, 0 changed, 0 destroyed.

Outputs:

sqs_url = "https://sqs.us-east-1.amazonaws.com/197317184204/SQS-Queue-CT"
vpc_a_bastion_host_IP = "54.89.142.51"
vpc_interface_endpoint_dns_entry = [
  tolist([
    {
      "dns_name" = "vpce-0724f06ffa900d501-tlboufch.sqs.us-east-1.vpce.amazonaws.com"
      "hosted_zone_id" = "Z7HUB22UULQXV"
    },
    {
      "dns_name" = "vpce-0724f06ffa900d501-tlboufch-us-east-1a.sqs.us-east-1.vpce.amazonaws.com"
      "hosted_zone_id" = "Z7HUB22UULQXV"
    },
    {
      "dns_name" = "sqs.us-east-1.amazonaws.com"
      "hosted_zone_id" = "Z04430242JIZLP89ADN4P"
    },
  ]),
]
```

### Testing:
VPC Interface Endpoint:

![alt text](/images/interface_endpoint.png)

Listing SQS queues via Interface Endpoint
![alt text](/images/listsqs.png)

Send a message to SQS:
```
[ec2-user@ip-10-1-2-238 ~]$ aws sqs send-message --queue-url https://sqs.us-east-1.amazonaws.com/197317184204/SQS-Queue-CT --message-body "AWS VPC Interface Endpoint via Terraform" --region us-east-1 --endpoint-url https://sqs.us-east-1.amazonaws.com
{
    "MD5OfMessageBody": "866fda719233ddb5c4cee060c8f35cf1", 
    "MessageId": "cbb41ab2-4c9d-4251-8b04-39520d148eb3"
}
```
![alt text](/images/sendmsg.png)

Message in SQS:

![alt text](/images/sqs1.png)

![alt text](/images/sqs2.png)

Receive Message from SQS:
```
[ec2-user@ip-10-1-2-238 ~]$ aws sqs receive-message --queue-url https://sqs.us-east-1.amazonaws.com/197317184204/SQS-Queue-CT --region us-east-1 --endpoint-url https://sqs.us-east-1.amazonaws.com
{
    "Messages": [
        {
            "Body": "AWS VPC Interface Endpoint via Terraform", 
            "ReceiptHandle": "AQEBpulyP6NtbDrTpcYsaFEhq8EGEBtoJZNfuOg0ypGSJ4T5NmaIXuYUoEttEIygMO3vgJne/5bnXLbjU7XkGxwz68dv4sh9HIsX30JRyjaS9mjFpnyqR3vs4XdS9jo6mahmQMdk2td3ei8Wzf/NL1Y/lwYCBkfzGEutMAWH3Zddf093c1cWndMhLQiCJQ0MdTWrRVgCy7vL2VZZcYseOHnSYxMdYCP5TQlJFjYRbJWA5NW+PhPGDH7CEHgIMrUgTHqYrTGaUyF96J2lREJCxY828Wgzv+QB+o/fAgZhQl7J84DeInSwvi01LBmC/3ns/I5XN/opKxB6owWQxXdY7RAu3gJ7dyCO/MgKPcBVj1tsVIvf4uAq/ki31PbLwiA9oyN0YWGtjGubwsf/J7MNCTBB7A==", 
            "MD5OfBody": "866fda719233ddb5c4cee060c8f35cf1", 
            "MessageId": "cbb41ab2-4c9d-4251-8b04-39520d148eb3"
        }
    ]
}
```
![alt text](/images/recvmsg.png)


Terraform Destroy Output:
```
Destroy complete! Resources: 19 destroyed.
```