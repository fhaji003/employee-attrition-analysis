-- checks.sql: makes sure the data loaded correctly before analysis

-- 1. Check that all the employee rows were loaded (expect 1470)
SELECT COUNT(*) AS total_rows
FROM employees;

-- 2. Check for duplicate EmployeeNumber values (expect no rows)
SELECT EmployeeNumber, COUNT(*) AS times_seen
FROM employees
GROUP BY EmployeeNumber
HAVING COUNT(*) > 1;

-- 3. Check that YearsWithCurrManager (the last column) loaded correctly
SELECT MIN(YearsWithCurrManager) AS min_years,
       MAX(YearsWithCurrManager) AS max_years
FROM employees;

-- 4. Check which columns have the same value for every employee (expect 1 for each)
SELECT COUNT(DISTINCT EmployeeCount) AS distinct_employee_count,
       COUNT(DISTINCT Over18)        AS distinct_over18,
       COUNT(DISTINCT StandardHours) AS distinct_standard_hours
FROM employees;