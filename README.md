# Cassandra Demo

This repository contains the example code for the Cassandra demo.

## Preparations

The demo relies on Docker and Docker Compose. 

```bash
# Go to the `cluster` folder
cd cluster

# Create cluster
./01-start.sh

# Open an interactive shell inside one of the nodes
./node1-shell.sh

# Cassandra cluster status (execute it until all three nodes lines start with `UN`)
nodetool status

# Prepare example keyspace and table
cqlsh -f files/setup-nobel.sql

# Check table
cqlsh -e "SELECT * FROM nobel.laureates"
```

## Cluster topology

* 3 Nodes
* Keyspace `nobel` with replication factor of 2
* Table `laureates` with partition key `year`

## Demos

### Partitioning

```bash
# Check the nodes that hold the data for a specific partition
nodetool getendpoints nobel laureates 2002
nodetool getendpoints nobel laureates 2003

# Check it for a non-existent partition
nodetool getendpoints nobel laureates 3000

# Open the interactive CQL shell
cqlsh
```
```sql
-- switch to keyspace
USE nobel;

-- Nobel laureates of 2002
SELECT * FROM laureates WHERE year = 2002;

-- Nobel laureates born in Hungary
SELECT * FROM laureates WHERE borncountrycode = 'HU';

-- Nobel laureates born in Hungary (force table scan - not recommended)
SELECT * FROM laureates WHERE borncountrycode = 'HU' ALLOW FILTERING;

-- Create index
CREATE INDEX ON laureates(borncountrycode);

-- Nobel laureates born in Hungary again!
SELECT * FROM laureates WHERE borncountrycode = 'HU';

-- quit to the container, and then to the local machine
-- Press Ctrl+D twice
```

### Replication

```bash
# terminate one of the nodes
docker stop cluster_node3_1

# Shell inside node1
./node1-shell.sh

# Cassandra cluster status
nodetool status

# CQL Shell
cqlsh
```

```sql
use nobel;

-- The database is still operational
SELECT * FROM laureates;
```

### Consistency

```sql
-- Tunable consistency
CONSISTENCY TWO;

-- Cannot list all records
SELECT * FROM laureates;

-- Some years might still work (change year to a few values if needed)
SELECT * FROM laureates WHERE year = 2002;
```

## Cleanup

```bash
# Quit all interactive shells by pressing Ctrl+D a few times

# Terminate cluster
./99-stop.sh
```
