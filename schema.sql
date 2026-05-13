CREATE DATABASE sql_portfolio;
USE sql_portfolio;

-- Step 1: Create Departments Table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);


-- Step 2: Create Agents Table
CREATE TABLE agents (
    agent_id INT PRIMARY KEY,
    agent_name VARCHAR(100),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);


-- Step 3: Create Users Table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100),
    business_unit VARCHAR(100)
);


-- Step 4: Create Tickets Table
CREATE TABLE tickets (
    ticket_id INT PRIMARY KEY,
    user_id INT,
    agent_id INT,
    category VARCHAR(100),
    priority VARCHAR(20),
    status VARCHAR(50),
    created_date DATE,
    resolved_date DATE,
    resolution_time_hours DECIMAL(5,2),
    satisfaction_score INT,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);


