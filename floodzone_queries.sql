--looking up all floodzone locations
select * from volusia.fl_volusia_floodzones

--select * from volusia.fl_volusia_floodzones where gid=10621
--select * from volusia.fl_volusia_floodzones where fld_zone='A'

--looking up all parcels in volusia
select * from volusia.parcel 

--organizing them all by zone type
select count(*) from volusia.fl_volusia_floodzones group by fld_zone

--locating the closest bodies of water to a given parcel
select p.gid, p.fld_zone, ST_Distance(p.geom,(select p2.geom from volusia.parcel p2 where parid=2016523))/5280
from volusia.fl_volusia_floodzones p
order by p.geom <-> (select p2.geom from volusia.parcel p2 where parid=2016523)
limit 5;

--select p.objectid, p.hyd_code, p.hyd_name, ST_Distance(p.geom,(select p2.geom from volusia.parcel p2 where parid=3565215))/5280
--from volusia.gis_hydrology p
--order by p.geom <-> (select p2.geom from volusia.parcel p2 where parid=3565215)
--limit 5;

--closest body of water to a random parcel
select p.gid, p.fld_zone, ST_Distance(p.geom,(select p2.geom from volusia.parcel p2 where p2.parid=2016523))/5280
from volusia.fl_volusia_floodzones p
order by p.geom <->(select p2.geom from volusia.parcel p2 where p2.parid=2016523)
limit 1;

--select p.hyd_code, p.hyd_name, p.geom, ST_Distance(p.geom, (select p2.geom from volusia.parcel p2 where p2.parid=2004291))/5280
--from volusia.gis_hydrology p
--order by p.geom <->(select p2.geom from volusia.parcel p2 where p2.parid=2004291)
--limit 1;

--adding a colum to the parcel table to measure distance between the parcel from a body of water
alter table volusia.parcel add column fzdistance double precision;
alter table volusia.parcel add column fzid text;
                                                                                            

--moving geometry from the gis_parcels to the parcels table
SELECT AddGeometryColumn ('volusia','parcel','geom',2236,'MULTIPOLYGON',2);
update volusia.parcel a set geom = p.geom from volusia.gis_parcels p where a.parid=p.altkey;

--Updating the distance between a given parcel and the closest floodzone, as well as giving the parcel it's floodzone id
update volusia.parcel p1 set fzdistance = ST_Distance(p1.geom, p2.geom)/5280 from volusia.fl_volusia_floodzones p2 where p1.parid=3324188
update volusia.parcel p1 set fzid =(p2.fld_zone) from volusia.fl_volusia_floodzones p2 where p1.parid=3324188 and p2.fld_zone='VE'

--testing some specific parcels to see if they were updated correctly
select * from volusia.parcel where parid=3324188
select * from volusia.parcel where parid=2014369
select * from volusia.parcel where parid=2527854
select parid, fzdistance, fzid from volusia.parcel
select fzdistance from volusia.parcel
select parid from volusia.parcel p where geom is not null

--Creating indexes for said parcel
create index idx_parcel on volusia.parcel (parid);
create index idx_parcel_fzid on volusia.parcel(fzid);
create index idx_parcel_fzdistance on volusia.parcel(fzdistance);

CREATE INDEX parcel_geom_idx
  ON volusia.parcel
  USING GIST (geom);

vacuum analyze volusia.parcel;

--testing parcels as a whole to see if they were updated
select count(*) from volusia.parcel where fzdistance > 1;
select * from volusia.parcel where fzdistance >1;
select * from volusia.parcel where fzdistance is null;
select * from volusia.parcel where fzdistance is not null;

--SELECT count(*)
--FROM information_schema.columns
--WHERE table_name = 'parcel';
