# Platform
* Ubuntu 16.04.2 or later (anything with kernel 4.4+)
* BIRD 1.6.3 or later
* strongSwan 5.5.1 or later
* Python 2.7
* Boto3
* xmljson 0.1.7

# Design
```
          +---------------+                 +---------------+                              
          |               |                 |               |                              
          |   some VPC    |                 |   some other  |                              
          |               |                 |      VPC      |                              
          +-----+---+-----+                 +-----+---+-----+                              
                |VGW|                             |VGW|                                    
                |---\                             |---\                                    
               /     \                           /     \                                   
              /       \                         /       \                                  
              |        \                        |        \                                 
+------------/       +------------+  +---------/--+      +------------+                    
|   VPN #1   |       |   VPN #2   |  |   VPN #3   |      |   VPN #4   |                    
+------------+\      +------------\  +--/---------+      +--/---------+                    
               \                   \   /                   /                               
                \                   \ /                   /                                
                 \                   /                   /                                 
                  \                /- \                /-                                  
                   \              /    \              /                                    
                    \            /      \            /                                     
               +-----\----------/--------\----------/----+                                 
               |      \        /          \        /     |                                 
               |   +-------------+     +-------------+   |                                 
               |   |VPN server #1|     |VPN server #2|   |                                 
               |   +------|------+     +---|---------+   |                                 
               |          |                |             |                                 
               +----------|----------------|-------------+                                 
                          |                |                                               
                          |                |                                               
                          |                |                                               
                    +-----|------+   +-----|------+                                        
                    | VPN DC #1  |   | VPN DC #2  |                                        
                    +-----\------+   +--/---------+                                        
                           \           /                                                   
                            \         /                                                    
                             |      /-                                                     
                             \     /                                                       
                              \   /                                                        
                               \ /                                                         
                                ----+-----------+                                          
                                |VGW|  Direct   |                                          
                                +---|  Connect  |                                          
                                    +-----------+ 
```
To simplify this diagram CGW were removed. In reality VPN servers talk to CGWs, which talks to AWS hardware VPN, then VPN talks to VGW which is attached to VPC.

# Terraform
Tags used for VPN identification:
* bird = True (static)
* id =  puiblic ip of VPN server [Elastic IP] (dynamic)

## VPN server module
Deploys one or more linux based EC2 instances with IAM role attached, to allow describe regions and describe VPN connection. IAM role is required download VPN configuration from AWS API and elastic IP attached to keep CGW configuration consistent all the time. To provide HA, deploy at least two instances in two different AZs.
  
## Direct Connect module
Creates one or more VPN connections with proper tags to designated VGW (eg. VGW used by Direct Connect).

## Satellite module
Creates VPN with one more public subnets and one or more sets of CGW, VGW and VPN connection, all with proper tags. 

## Probe module
Deploys t2.nano instance in designated VPC and subnet.

#Ansible
Ansible playbook has to be deployed and executed manually on each VPN server.
 
## Common
Fixes DNS to standard AWS server, disables AppArmor and upgrades all packages in the system.

## VPN config generator
Installs necessary Python libraries and executes Python script to download VPN configuration from related VPN connection and generate configuration file used in next steps.   

## strongSwan
Add custom strongSwan repo, consumes configuration file generated in previous step, deploys strongSwan and proper configuration

## BIRD
Add custom BIRD repo, consumes configuration file generated in previous step, deploys BIRD and proper configuration
