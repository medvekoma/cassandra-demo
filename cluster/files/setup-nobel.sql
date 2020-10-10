-- create keyspace
CREATE KEYSPACE nobel
WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 2};

-- create table
CREATE TABLE nobel.laureates
(
  year int,
  category text,
  laureateid int,
  firstname text,
  surname text,
  borncountrycode text,
  borncity text,
  PRIMARY KEY (year, laureateid)
);

COPY nobel.laureates (year, category, laureateid, firstname, surname, borncountrycode, borncity)
FROM 'files/nobel-laureates.csv';
