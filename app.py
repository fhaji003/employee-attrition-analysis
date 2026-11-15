import streamlit as st
import pandas as pd
import joblib

model = joblib.load("model.pkl")
scaler = joblib.load("scaler.pkl")
columns = joblib.load("columns.pkl")

st.title("Employee Attrition Risk Predictor")
st.write("Enter an employee's details to estimate their risk of leaving: ")

# Typical employee 
data = pd.read_csv("hr_clean.csv").drop(columns=["Attrition", "AttritionFlag"])
employee = data.mode().iloc[[0]].copy()

# 2. Inputs
age = st.slider("Age", 18, 60, 30)
overtime = st.selectbox("Works overtime?", ["Yes", "No"])
income = st.number_input("Monthly income: ", 1000, 20000, 5000, step=500)
job_role = st.selectbox("Job Role", sorted(data["JobRole"].unique()))
travel = st.selectbox("Business Travel", sorted(data["BusinessTravel"].unique()))
job_level = st.slider("Job Level", 1, 5, 2)
total_years = st.slider("Total Working Years", 0, 40, 10)
years_manager = st.slider("Years With Current Manager", 0, 17, 3)

# Put the inputs into the employee (AFTER the inputs)
employee["Age"] = age
employee["OverTime"] = overtime
employee["MonthlyIncome"] = income
employee["JobRole"] = job_role
employee["BusinessTravel"] = travel
employee["JobLevel"] = job_level
employee["TotalWorkingYears"] = total_years
employee["YearsWithCurrManager"] = years_manager
    
    
if st.button("Predict"):
    input_df = pd.get_dummies(employee)
    input_df = input_df.reindex(columns=columns, fill_value=0)
    input_scaled = scaler.transform(input_df)
    risk = model.predict_proba(input_scaled)[0, 1]
    st.metric("Attrition risk", f"{risk:.0%}")
    if risk >= 0.5:
        st.error("High risk: consider a check-in")
    elif risk >= 0.25:
        st.warning("Medium risk: monitor")
    else:
        st.success("Low risk")