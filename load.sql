-- load sql files
USE hr_analytics;

TRUNCATE TABLE employees; -- empty the table first, so that running it twice won't double the rows

LOAD DATA LOCAL INFILE 'hr_attrition.csv'
INTO TABLE employees
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES; 