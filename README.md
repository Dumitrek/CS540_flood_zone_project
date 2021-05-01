# CS540_flood_zone_project
Kevin Dumitrescu

For Professor Lehr, ERAU Daytona Beach Spring 2021

[Youtube Project video](https://youtu.be/27Hg6B8ZE5o)

[PDF file](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/CS540%20Project%20Presentation-Kevin%20Dumitrescu.pdf)

# Project problem

The CS540 project problem is essentially calculating the distance to the nearest flood zone and assigning the nearest flood zone id to a parcel id/altkey within Volusia county, as well as updating the sales analysis table and parcel table and upload it onto an AWS server database.

# Solution

The solution I found was first to download/install the floodzone .shp file from Volusia county website and then begin writing some sql commands showcased in the [floodzone_queries.sql file](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/floodzone_queries.sql). The first was to simply preview the volusia floodzone table. Afterwards, I then went and created a command to locate the nearest 5 floodzones and then the nearest floodzone when given a parcel id that would then return the distance to said floodzone and then the id of that floodzone. Once that worked, I then went and created indexes for the parcel table, so that the process of now updating each parcel wouldn't take to long. Once created, I then ran two update commands within pgAdmin, one for distance and the other for id, for a given parcel. When proven successful, I then created a python script that would automatically check for the closest distance and then do the updates for each pracel within the table, showcased in [update_flood_zone_distances.py](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/update_flood_zones_distances.py). 

# Step 1: Acquiring the data set *Subject to change*

In order to first download the dataset, you must already have pgAdmin, a server that you can run it on, and a database already made. To actually download and install it, first you must download the [CS540_floodszone_data.zip file](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/CS540_floodszone_data.zip) and unzip it into the folder of your choice (if you are a CS540 student, you can just unzip it into your CS540 folder). Once unzipped, head into pgAdmin and from here you can either create two new tables and import the parcel and sales analysis table into them or create the columns for your tables themselves and copy the data over. 

# Step 2: Using the data set via queries *Subject to change*

This data sets use is to locate or pick a piece of property and check what flood zone the property is located in and how far it reaches said flood zone. This can be used when trying to move to a different location within the county and determining a rough estimate as to whether to obtain flood insurance and how much it can cost depending on how close the property is to a specific flood zone. On how to actually use it within pgAdmin, you first start by downloading the [floodzone_queries.sql file](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/floodzone_queries.sql) from 

# Step 3: Visual within QGIS *subject to change*


