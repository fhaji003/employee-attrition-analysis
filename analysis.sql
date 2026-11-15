USE hr_analytics;

-- Calculate the percentage of employees who left
-- Result: 16.1% of employees left the company
SELECT ROUND(
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100,
    1
) AS attrition_rate
FROM employees;


-- Calculate attrition rate for each department 
-- Result: Sales has the highest attrition (20.6%), then HR (19.0%), then R&D (13.8%).
-- HR's rate is high but only 12 people left, because it is a small department.
SELECT 
    Department, 
    COUNT(*) AS total_employees, 
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left, 
    ROUND(
        AVG(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) * 100, 1
    ) AS attrition_rate
FROM employees
GROUP BY Department
ORDER BY attrition_rate DESC;


-- Does working overtime make people more likely to leave?
-- Result: Employees who work overtime leave about 3x as often (30.5% vs 10.4%).
-- Overtime is the strongest attrition signal found so far.
SELECT 
    OverTime, 
    COUNT(*) AS total_employees, 
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left, 
    ROUND(
        AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 1
    ) AS attrition_rate
FROM employees
GROUP BY OverTime
ORDER BY attrition_rate DESC;


-- Rank job roles from highest to lowest attrition
-- Result: Sales Representatives leave the most (39.8%), Research Directors the least (2.5%)
-- Entry-level roles have much higher attrition than senior roles
WITH role_stats AS (
    SELECT 
        JobRole, 
        COUNT(*) AS total_employees,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
        ROUND(
            AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100, 1
        ) AS attrition_rate
    FROM employees
    GROUP BY JobRole
)
SELECT 
    *,
    RANK() OVER (ORDER BY attrition_rate DESC) AS rank_num
FROM role_stats;


-- Compare attrition rates across years at the company
-- Result: Employees in their first 2 years leave the most (29.8%)
-- Attrition drops sharply after year 2 and keeps falling with tenure
SELECT 
    CASE 
        WHEN YearsAtCompany <= 2 THEN '0-2'
        WHEN YearsAtCompany <= 5 THEN '3-5'
        WHEN YearsAtCompany <= 10 THEN '6-10'
        ELSE '10+'
    END As tenure_band,

    COUNT(*) AS total_employees, 

    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,

    ROUND(
        AVG(CASE WHEN Attrition='Yes' THEN 1 ELSE 0 END) * 100, 1
    ) AS attrition_rate

FROM employees
GROUP BY tenure_band
ORDER BY attrition_rate DESC;


-- Compare average monthly income between employees who left and stayed
-- Result: Employees who left earned about $2,046/month less on average ($4,787 vs $6,833)
-- Lower pay is linked to higher attrition
SELECT 
    Attrition, 
    ROUND(AVG(MonthlyIncome), 0) AS avg_monthly_income
FROM employees
GROUP BY Attrition;

-- Save department attrition analysis as a view
CREATE OR REPLACE VIEW dept_attrition AS
SELECT
    Department,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    ROUND(
        AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100,
        1
    ) AS attrition_rate
FROM employees
GROUP BY Department;

SELECT *
FROM dept_attrition
ORDER BY attrition_rate DESC;