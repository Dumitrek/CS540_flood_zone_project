import psycopg2
import re
import matplotlib.pyplot as plt
import os
import pandas as pd
import csv

# connection to database:
try:
    conn = psycopg2.connect("dbname='spatial' user='postgres' host='localhost' password='Zubaz11234'")
except:
    print("cant connect to the database")

cur = conn.cursor()
cur2 = conn.cursor()
cur3 = conn.cursor()
cur4 = conn.cursor()
cur5 = conn.cursor()
#input_altkey = 3565215

fout = open('e:\CS540_flood_zone_report.txt','w') 
print("Opended the file")
fout.write('parid \t\t flood_zone_distance \t flood_zone_id \n')
print("Writing header to the file")

sql = "select parid from volusia.parcel p where geom is not null limit 342930"

print('SQL: ', sql)
cur.execute(sql)

i=0
row = cur.fetchone()
while row is not None:
    i = i + 1
    parid = str(row[0])#str(3324188)
    sql2 = "select p.gid, p.fld_zone, p.geom, ST_Distance(p.geom,(select p2.geom from volusia.parcel p2 where p2.parid="+ parid +"))/5280 from volusia.fl_volusia_floodzones p order by p.geom <->(select p2.geom from volusia.parcel p2 where p2.parid="+ parid +") limit 1;"
    cur2.execute(sql2)
    print(sql2)
    #print("I'm running and updating")
    row2 = cur2.fetchone()
    fld_distance = row2[2]
    gid = str(row2[0])
    sql3 = "update volusia.parcel p1 set fzdistance = ST_Distance(p1.geom, p2.geom)/5280 from volusia.fl_volusia_floodzones p2 where p1.parid="+ parid +";"
    cur3.execute(sql3)
    print(sql3)
    # #print("I'm running and updating")
    fld_zone = row2[1]
    sql4 ="update volusia.parcel p1 set fzid = (p2.fld_zone) from volusia.fl_volusia_floodzones p2 where p1.parid=" +parid + ";"
    cur4.execute(sql4)
    print(sql4)
    #print("I'm running and updating")
    fld_zone_distance = cur5.execute("select fzdistance from volusia.parcel where parid ="+parid+";")
    fld_zone_distance = cur5.fetchone()
    fout.write("%s \t"% parid)    #printing parid
    fout.write("%s \t\t"% fld_zone_distance) #printing distance
    fout.write("%s \t\t\n"% fld_zone) #printing zone id

    if i%10000 == 0:
        print(i)
        conn.commit()    
    row = cur.fetchone() 
    print("done")

#df = pd.
conn.commit()
conn.close()
fout.close()


