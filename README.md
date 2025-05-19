# Machine Learning-Based DDoS (Distributed Denial of Service) Detection System


## Project title
Machine Learning-Based DDoS (Distributed Denial of Service) Detection System

## Description
Final year computer science project which will incorporate elements of both research and engineering. 
The research side of things will test the creation of an ensamble ML model to detect DDoS attacks on the CIC dataset.
The engineering side of things created a real-time system for detecting generated attacks in a virtual networking enviroment.

## Folder structure
**code** - contains all the code used for this project (both research and engineering)
- **networking-code**
    - **Benign-Traffic** - BASH Scripts for generating 'normal' traffic across the network
    - **DDoS-Scripts** - BASH scripts for generating several types of DDoS attacks
    - **Data-Processing** - Contains the dataApp.py file, used to convert network packets into csv data
    - **Real-Time-Application** - Contains the complete code and file structure to run the real-time application
    - **SDN-Scripts** - Contains the BASH commands needed to setup the Mininet virtual network

- **jupiter-notebooks** - All the jupiter notebooks created for this project, early testing notebooks, as well as the CICDDoS-2019 and custom dataset notebooks



**data** - contains all the datasets researched and used for this project
- **CIC-DDOS2019** - The pre-made dataset used for the inital data science and machine learning experiments
- **CustomDataset** - The custom dataset created using the virtual enviroment and dataApp.py
- **NSL-KDD** - The NSL-KDD intrusion detection dataset (researched but not used for this project)

**documentation** - Contains the project report, as well as important information and the weekly diary
- **Report** - The location of the written report included as part of this project
- **Research notes** - Images and written notes of important discoveries or events in the project
- **Weekly diary** - Weekly diaries of what was acomplised that week along with time taken. All kept in .txt files
- **networkimages** - Images of important networking tests

## How to run the research code

Take the DDoS_data_manipulation.ipynb file and open it in a Google colab workspace. 
Download the entire contents of the data->CIC-DDOS2019 folder and then upload the files to your Google drive's default directory.
Run the jupiter notbook and agree to it accessing your Google drive
Enjoy!

## How to run the engineering code (real-time detection)

Given the setup surrounding the Ubuntu virtual machine and Mininet virtual network, running this locally will prove quite the challenge. 
If you REALLY want to run this yourself, I've uploaded my VM with all its settings and packages here - REMOVED

Double click on this file on a machine with VirtualBox installed


**THE PASSWORD IS ->** mininet


Once fully setup and installed, navigate to the sFlow-RT folder and run:
sudo mn --nat --custom extras/sflow.py --link tc,bw=10 --topo tree,depth=2,fanout=4

This will create the network topology

 Next navigate to Documents/machine-learning-based-ddos-detection-system/code/networking-code/Real-Time-Application/

NOTE! if this does not exsist then git clone this repository and then navigate to the same folder.

Then run ./realTimeController.sh (you may have to enter the root password)
It will then run continusly until finished or interrupted
Enjoy!

## Location of SSH key pair on VM (used for when I would ssh into my virtual machine)
/home/mininet/.ssh

### Types of DDoS attacks that were tested
- Syn: SYN flood attack
- Benign: Normal, non-attack traffic
- Portmap: Portmapper-based DDoS attack
- UDP: Generic UDP flood attack
- UDPLag: UDP-based DDoS with lag
- MSSQL: MSSQL-specific DDoS attack
- NetBIOS: NetBIOS-related DDoS attack
- LDAP: Lightweight Directory Access Protocol-based attack

## Authors and acknowledgment
Thomas Roethenbaugh (tpr3)

I would also like to acknowledge my supervisor Dr Muhamud Aslam, whom without which this project
would not have been possible. Thank you for putting up with all my questions.

I also would like to thank my friends and family for helping me throughout these 4 years

## License
Aberystwth university

## Project status
Complete
