USE sql_portfolio;

-- Step 1: Insert Departments Data
INSERT INTO departments VALUES
(1, 'Service Desk'),
(2, 'Network Team'),
(3, 'Application Support'),
(4, 'Infrastructure Team');


-- Step 2: Insert Agents Data
INSERT INTO agents VALUES
(101, 'Aiman', 1),
(102, 'Siti', 1),
(103, 'Daniel', 2),
(104, 'Mei Lin', 3),
(105, 'Farah', 4);


-- Step 3: Insert Users Data
INSERT INTO users VALUES
(201, 'Hana', 'Finance'),
(202, 'Imran', 'Human Resource'),
(203, 'Kavitha', 'Sales'),
(204, 'Jason', 'Operations'),
(205, 'Nadia', 'Marketing'),
(206, 'Rafiq', 'IT'),
(207, 'Amelia', 'Procurement'),
(208, 'Yusof', 'Legal');


-- Step 4: Insert Tickets Data
INSERT INTO tickets VALUES
(1001, 201, 101, 'Password Reset', 'Low', 'Resolved', '2026-01-03', '2026-01-03', 1.50, 5),
(1002, 202, 102, 'Email Issue', 'Medium', 'Resolved', '2026-01-04', '2026-01-04', 4.00, 4),
(1003, 203, 103, 'Network Down', 'High', 'Resolved', '2026-01-05', '2026-01-05', 6.50, 3),
(1004, 204, 104, 'System Error', 'High', 'Resolved', '2026-01-06', '2026-01-07', 10.00, 2),
(1005, 205, 101, 'Password Reset', 'Low', 'Resolved', '2026-01-07', '2026-01-07', 2.00, 5),
(1006, 206, 105, 'Server Issue', 'High', 'Resolved', '2026-01-08', '2026-01-09', 12.00, 3),
(1007, 207, 102, 'Laptop Issue', 'Medium', 'Resolved', '2026-01-09', '2026-01-10', 7.00, 4),
(1008, 208, 103, 'VPN Issue', 'Medium', 'Resolved', '2026-01-10', '2026-01-10', 3.50, 5),
(1009, 201, 104, 'System Error', 'High', 'Resolved', '2026-01-11', '2026-01-12', 15.00, 2),
(1010, 202, 105, 'Server Issue', 'High', 'Open', '2026-01-12', NULL, NULL, NULL),
(1011, 203, 101, 'Email Issue', 'Medium', 'Resolved', '2026-01-13', '2026-01-13', 5.00, 4),
(1012, 204, 102, 'Password Reset', 'Low', 'Resolved', '2026-01-14', '2026-01-14', 1.00, 5),
(1013, 205, 103, 'Network Down', 'High', 'Resolved', '2026-01-15', '2026-01-16', 9.50, 3),
(1014, 206, 104, 'System Error', 'Medium', 'Resolved', '2026-01-16', '2026-01-16', 6.00, 3),
(1015, 207, 105, 'Server Issue', 'High', 'Resolved', '2026-01-17', '2026-01-18', 14.00, 2);


-- Step 5: Check Tables Created
SHOW TABLES;


-- Step 6: Check Row Count for Each Table
SELECT 'departments' AS table_name, COUNT(*) AS total_rows FROM departments
UNION ALL
SELECT 'agents', COUNT(*) FROM agents
UNION ALL
SELECT 'users', COUNT(*) FROM users
UNION ALL
SELECT 'tickets', COUNT(*) FROM tickets;


-- Step 7: View All Departments Data
SELECT * 
FROM departments;


-- Step 8: View All Agents Data
SELECT * 
FROM agents;


-- Step 9: View All Users Data
SELECT * 
FROM users;

