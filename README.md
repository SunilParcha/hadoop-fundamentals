# hadoop-fundamentals
This is repo for hadoop fundamentals: Hive code

# Introduction:
We will learn:-
1. How to create Cluster on EMR.
2. Upload Data in HDFC.
3. Create S3 Bucket.
4. Hive Basics.
5. Insert dataset and Json into Hive Table.
6. Partition, buckets, and ORC.

# Tech Stack
➔ Language: HQL

➔ Services: AWS EMR, Hive, HDFS, AWS S3

# Basics of Hadoop:
I have alreay explained basics of Hadoop in this video and PPT: [PPT](https://shorthillstech-my.sharepoint.com/:p:/p/kapil_jain/EYnMSDFv3URAkOqftIvC2pABE668Ws1nCf7NWain1Tx5SQ?e=NHcSqn) & [Video](https://shorthillstech-my.sharepoint.com/:v:/p/kapil_jain/ET_9mNvLkOVCmLyzn82WxmwBKZkcI-hRfvuj2WSEejWrSg?e=xwgAB8)


![image](https://user-images.githubusercontent.com/72372922/205267941-3e9bbbc2-6288-4949-bc64-6bc246661c1d.png)
![image](https://user-images.githubusercontent.com/72372922/205268022-5011262e-64b6-4467-a17b-44a3830eb22b.png)
! SSH command: ssh -i key.pem ec2-user@master_public_dns
![image](https://user-images.githubusercontent.com/72372922/205268092-f109a1bc-83a1-4777-bc3b-bd1e5045e329.png)
! Transer data command: scp -i key.pem Path of file ec2-user@master_public_dns:~/data/

# How to Launch Hive:
➔ You just need to type hive on you EC2 Console.
➔ Now you will be able to write SQL queries in hive.
➔ You can check hadoop_fundamental.hql file. I have given Example Queries on that.

