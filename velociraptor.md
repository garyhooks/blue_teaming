

# Stage 1: Create EC2 instance on AWS

This instance will act as the platform and server for the Velociraptor instance. Follow the steps below.

1. Go to https://myapplications.microsoft.com and authenticate if required

2. Click on the icon like the one below, titled "AWS Single Sign-on (Legacy)" which will take you to the AWS web console.

![image](https://github.com/user-attachments/assets/7736c2ff-64b5-4823-b514-a614864290e2)

3. Ensure the region shown in the top right corner, is suitable for the deployment. If not you can change this to a different region.

![image](https://github.com/user-attachments/assets/349ddea5-5012-4968-8a42-c7921e707679)

4. Go to the EC2 section by searching in the taskbar:#

   ![image](https://github.com/user-attachments/assets/adc6ec8f-2a12-45e5-9c24-1a8ed95eec70)

5. Click "Instances" from the menu on the left side.

6. Click "Launch Instances" from the right hand side
   
7. Complete the details required, as follows:

    * Name: Include your initials or name, as well as the client, and something which clearly identifies its purpose. Such as: Velociraptor-GH-ClientName
    * Operating System: Select Ubuntu - do not use Amazon Linux
    * Instance Type:  For smaller deployments, t2.micro may be suitable, although is subject to consideration
    * Key Pair: Select DFIR-SFTP (note: you will need this key file to connect to the server later on)
    * Network Settings: Click Edit in the top right of this part of the form. Change Type from SSH to "All Traffic". Change Soure type to "My IP" (**DO NOT** leave this as Anywhere, as this will mean any one on the internet can access the portal)
    * Storage: Choose storage volumer required. During testing, the basic installation is about 8gb. A good starting point may be 50-100gb.
        
8. Click "Launch Instance" on the right side

# Stage 2: Velociraptor Installation

1. Retrieve the Public IP address for the instance from the EC2 instance. You can obtain this by clicking/selecting the instance you just created and it's listed in the details tab below.

   ![image](https://github.com/user-attachments/assets/eb95b0d6-79b0-45b2-a768-3cc409544d80)

2. Login to the server using Putty, entering the following details:
   
     * IP Address: Enter "ubuntu@" followed by the IP address copied from the previous step (for example: ubuntu@12.34.56.78)
     * In the left menu, expand "SSH", then expand "Auth".
     * Select Credentials, and in the right side, select the Browse button, which is labelled "Private Key file for authentication
     * Select the DFIR-SFTP.ppk file
     * Click Open
  
3. Go to the GitHub release page (https://github.com/Velocidex/velociraptor/releases) in order to view the latest versions. You can expand to see all latest releases. Right click on the one titled: "velociraptor-vXXXXX-linux-amd64" and select "Copy Link Address"

4. In the Linux terminal window, enter: wget followed by the URL you have just copied.
   
5. Enter commands:

    * chmod a+x velociraptor-v0.73.3-linux-amd64 (or whatever your version is). This command will enable execution of the file.
    * sudo mkdir /opt/velociraptor
    * sudo ./velociraptor-v0.73.3-linux-amd64 config generate -i
  
9. This will enter the installation of Velociraptor, choose the following options:
    * Operating system: linux
    * Path: leave blank which defaults to /opt/velociraptor
    * Self Signed SSL:
    * Public DNS Name - Copy this from AWS EC2 instance. This is shown in the Details of the EC2 Instance as shown below:

      ![image](https://github.com/user-attachments/assets/d07c2541-4492-44f2-8e62-26b02eeaa310)

    * Front end port: leave blank which defaults to 8000
    * Gui port: leave blank which deafults to 8889
    * Choose no when asked about experimental websocket comms
    * No to registry to store writeback files
    * Select "none" in relation to DynDNS providers
    * Enter username and password which will be used to login to the Admin panel for the installation
    * When asked again, leave blank which moves on to the final stages
    * Logs: leave as default which is /opt/velociraptor/logs
    * Restrict VQL functionality, choose No
    * Where should I write server config file: /opt/velociraptor/server.config.yaml
    * Where should I write client config file: /opt/velociraptor/client.config.yaml


# Stage 3: Configuration of installation

At this point the Velociraptor application is installed. Prior to creating our server, we need to change the configuration very slightly.

1. sudo nano /opt/velociraptor/server.config.yaml
   
2. Scroll down to GUI Bind Address. Delete the current entry which is likely to be 127.0.0.1 and enter the Public DNS which you copied from before (for example: ec2-1-15-21-218.eu-west-2.compute.amazonaws.com)

3. Write the changes to file by holding Ctrl+O

4. Exit by holding Ctrl+X

# Stage 4: Creation and Launching of Velociraptor Server

The server is now ready to be created as we've completed the configuration steps.

1. In the terminal window, enter the following to create the server package file
   
   ```
   sudo /home/ubuntu/velociraptor-v0.73.3-linux-amd64 --config /opt/velociraptor/server.config.yaml debian server --binary /home/ubuntu/velociraptor-v0.73.3-linux-amd64
   ```
  
2. Enter command: sudo dpkg -i velociraptor_server_0.73.3_amd64.deb

3. To check this was successful, enter command: systemctl status velociraptor_server.service. You should see it states the service is Active, similar to the screenshot below.
   
![image](https://github.com/user-attachments/assets/ef9d5014-20be-4337-b797-6e6231215986)

4. To test this has all worked, open a web browser on your local machine, and enter:

      * https:// followed by the public DNS from before, followed by :8889
      * https://ec2-1-15-21-218.eu-west-2.compute.amazonaws.com:8889
      * Ignore any warnings relating to insecure connections and continue.
   
5. When prompted, enter the username and password you entered in the installation steps.
  
6. You should now have access to the admin panel. Click the magnifying glass to view connected clients, which at this point will be entirely empty. However, later, this will populate with clients who have installed the velociraptor agent.
