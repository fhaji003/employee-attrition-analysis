# Employee Attrition Analysis & Prediction

I built this project to figure out why employees leave a company and whether I could predict who might leave next.

Try the app here: https://employee-attrition-fawaz-haji.streamlit.app

## Why I made this

Losing employees costs companies a lot of time and money. I wanted to do a full data project from start to finish, from loading raw data into a database all the way to building an app that anyone can use.

I used the IBM HR Attrition dataset from Kaggle, which has 1,470 employees and 35 columns.

## What I found

About 16% of employees left the company.

Overtime was the biggest factor. People who worked overtime left about 3 times as often as people who didn't (30.5% vs 10.4%).

The first 2 years are the riskiest. Almost 30% of newer employees left, and it drops a lot after that.

Junior roles had much higher turnover. Around 40% of Sales Representatives left, compared to only 2.5% of Research Directors.

People who left were making about $2,000 less per month on average.

## The model

I trained two models, logistic regression and random forest, and compared them.

The random forest had higher accuracy (84%), but it only caught 4 out of the 47 people who actually left in the test data. Since only 16% of employees left, a model can look accurate just by guessing that everyone stays. I tried lowering its threshold and it got better (caught 18), but logistic regression still did better and caught 29 out of 47.

For HR, missing someone who is about to quit is worse than a false alarm, so I went with logistic regression.

I also looked at which factors the model cared about most. Overtime, travelling a lot for work, and roles like Lab Technician and Sales Rep raised the risk. More work experience, more years with the same manager, and being happier with the work environment lowered it.

## How I built it

First I loaded the data into MySQL, checked that it loaded properly, and answered some HR questions with SQL (CASE, GROUP BY, CTEs, window functions and a view).

Then I cleaned the data in Python with pandas and made charts with seaborn to see the patterns.

After that I used scikit-learn to prepare the data, train both models, and compare them.

Finally I built a Streamlit app where you can enter an employee's details and see their attrition risk, and deployed it online.

## Files

- create_table.sql, load.sql, checks.sql: set up the database, load the data and check it
- analysis.sql: the SQL analysis
- analysis.ipynb: cleaning and charts
- model.ipynb: training and comparing the models
- app.py: the Streamlit app

## Running it

    pip install -r requirements.txt
    streamlit run app.py

## What I would do next

I'd like to try more models and tune them properly, add more inputs to the app, and show which factors are behind each person's prediction.

Made by Fawaz Haji, BCIS student at Mount Royal University