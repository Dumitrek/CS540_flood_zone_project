# CS540_flood_zone_project
Kevin Dumitrescu

For Professor Lehr, ERAU Daytona Beach Spring 2021

[Youtube Project video](https://youtu.be/27Hg6B8ZE5o)

[PDF file](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/CS540%20Project%20Presentation-Kevin%20Dumitrescu.pdf)

# Project problem

The CS540 project problem is essentially calculating the distance to the nearest flood zone and assigning the nearest flood zone id to a parcel id/altkey within Volusia county, as well as updating the sales analysis table and parcel table and upload it onto an AWS server database.

# Solution

The solution I found was first to download/install the floodzone .shp file from Volusia county website and then begin writing some sql commands showcased in the [floodzone_queries.sql file](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/floodzone_queries.sql). The first was to simply preview the volusia floodzone table. Afterwards, I then went and created a command to locate the nearest 5 floodzones and then the nearest floodzone when given a parcel id that would then return the distance to said floodzone and then the id of that floodzone. Once that worked, I then went and created indexes for the parcel table, so that the process of now updating each parcel wouldn't take to long. Once created, I then ran two update commands within pgAdmin, one for distance and the other for id, for a given parcel. When proven successful, I then created a python script that would automatically check for the closest distance and then do the updates for each pracel within the table, showcased in [update_flood_zone_distances.py](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/update_flood_zones_distances.py). 

# Step 1: Acquiring the data set 

In order to first download the dataset, you must already have pgAdmin, a server that you can run it on, and a database already made. To actually download and install it, first you must download the [CS540_floodszone_data.zip file](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/CS540_floodszone_data.zip) and unzip it into the folder of your choice (if you are a CS540 student, you can just unzip it into your CS540 folder). Once unzipped, head into pgAdmin and from here you can either create two new tables and import the parcel, as well as sales analysis table into them or create the columns for your tables themselves and copy the data over. In terms of creating the columns, the commands are provided in the in the floodzone_queries.sql file in Step 2, where you can run the alter table queries, as well as the SELECT AddGeomolumn query to create the columns yourself. Images shown below.

![alter table for parcel](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/Project%20Pictures/alter%20table%20for%20parcel.png)
![alter geom for parcel](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/Project%20Pictures/alter%20geom%20for%20parcel.PNG)

If you want to have a QGIS layer of just the regular Volusia county floodzone data, here's the link to the [Volusia county shape files](http://maps.vcgov.org/gis/download/shapes.htm) where you can scroll down or CTRL+F till you see FEMA(Flood Insurance Rate Map) and download the firmvc.zip file. From there you can unzip the folder into your cs540 folder and then open QGIS and add a new layer using the firmvc_poly.shp file. From there you can change your properties to a Categorized view with the value set to FLD_ZONE to showcase the multiple flood zones within the county in a color gradient scale.

# Step 2: Using the data set via queries 

This data sets use is to locate or pick a piece of property and check what flood zone the property is located in and how far it reaches said flood zone. This can be used when trying to move to a different location within the county and determining a rough estimate as to whether to obtain flood insurance, how much it can cost depending on how close the property is to a specific flood zone, and determining property value as a whole (which will be done in the next part of the assignment when comparing prices using Zillow). On how to actually use it within pgAdmin, you first start by downloading the [floodzone_queries.sql file](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/floodzone_queries.sql) from there you can open the file within a query tool in pgAdmin. The queries were created as a means of testing for the python script in future, so that I can update my parcel table for each parcel. You can run the queries to see the outcome within pgAdmin yourself of determing the nearest floodzone for a given parcel inputted in the query. 

# Step 2.1: Using the python script

The python script requires you to first have downloaded the Volusia floodzone data to pgAdmin, so if you haven't done so then download and unzip the firmvc.zip file and run these two commands in your command prompt to add the table into your pgAdmin:

“c:\School\Postgres\bin\shp2pgsql.exe” -d -I -s 2236 -W “latin1” -g geom firmvc_poly.shp volusia.flood_zones > create_volusia_flood_zones.sql

“c:\School\Postgres\bin\psql.exe” -U postgres -d spatial -f create_volusia_flood_zones.sql

Two other prerequisites include that you would have to create a geom column within your volusia.parcel table and to index your parcel table. The process to add the geom column is mentioned back in Step 1, while the commands to index the parcel are showcased below and within the floodzone_queries.sql file as well.

![Index parcel](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/Project%20Pictures/create%20index%20for%20parcel.png)

![Index parcel geom](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/Project%20Pictures/create%20index%20for%20geom%20parcel.png)

The use of the python script itself is to automatically calculate and update the parcel table with distance to the nearest flood zone and pass its flood zone id as well for a parcel. Since I have provided you with the data neccessary, this is entirely optional for you to do. 

Once you have created the floodzone table, you can then open the python script and run the program to see that the script will just do the work for you (pretty nifty).

# Step 3: Visualizing the parcel data within QGIS

Once adding the geom column to your parcel table, as well as having each parcel contain a distance to a nearby flood zone and it being represented by the flood zone's id, you can then move back to QGIS and add a new layer using the "Add a PostGIS layer" option. From there you can connect to the spatial database and pull your new or modified parcel table as a layer. Afterwards go into its Properties and change its Symbology to Graduated and value to fzdistance. After apply those and selecting a color gardient scale of your choice, you would find an image similar to that below

![QGIS map](https://github.com/Dumitrek/CS540_flood_zone_project/blob/main/Project%20Pictures/QGIS%20map.png)
