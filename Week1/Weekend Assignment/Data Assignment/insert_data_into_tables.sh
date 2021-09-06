#! /bin/bash


# Running python script to convert EXCEL sheets to respective CSVs.
python sheets_to_CSV.py

# Change '1.0' like floating formats in CSVs to '1' int format. 
sed -i -e 's/\.0//g' *.csv

#command to insert from .csv file to respective tabls from sql file.
psql postgres -h 127.0.0.1 -d hospital -f insert_Queries_from_CSV.sql

