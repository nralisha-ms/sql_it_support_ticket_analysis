USE sql_portfolio;

-- Step 1: View All Tickets Data
SELECT * 
FROM tickets;

-----------------------------------------------------------------------------------------------------------------------------
-- Step 1: Basic Ticket Overview
-----------------------------------------------------------------------------------------------------------------------------

-- Query 1: Total Number of Tickets
SELECT 
    COUNT(*) AS total_tickets
FROM tickets;

-- Explanation:
-- This query counts the total number of support tickets in the dataset.
-- The dataset contains 15 support tickets. This gives an overview of total support demand during the analysis period.


-- Query 2: Total Resolved vs Open Tickets
SELECT
    status,
    COUNT(*) AS total_tickets
FROM tickets
GROUP BY status;

-- Explanation:
-- This query groups tickets by status and counts how many tickets are resolved or open.
-- This helps the IT support team monitor ticket backlog and understand how many tickets still require follow-up.


-- Query 3: Tickets by Priority
SELECT
    priority,
    COUNT(*) AS total_tickets
FROM tickets
GROUP BY priority
ORDER BY total_tickets DESC;

-- Explanation:
-- This query groups tickets by priority level and counts the number of tickets in each priority.
-- Priority analysis helps identify whether the support team is handling mostly low, medium, or high-priority issues.


-- Query 4: Tickets by Category
SELECT
    category,
    COUNT(*) AS total_tickets
FROM tickets
GROUP BY category
ORDER BY total_tickets DESC;

-- Explanation:
-- This query groups tickets by issue category and counts how many tickets belong to each category.
-- The most frequent ticket categories highlight recurring operational issues. These categories should be prioritized for automation, root cause analysis, or user training.


-- Query 5: Average Resolution Time
SELECT
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours
FROM tickets
WHERE resolution_time_hours IS NOT NULL;

-- Explanation:
-- This query calculates the average resolution time for tickets that have already been resolved.
-- The average resolution time provides a baseline for support team performance. Open tickets are excluded because they do not have completed resolution times.


-- Query 6: Average Resolution Time by Priority
SELECT
    priority,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours
FROM tickets
WHERE resolution_time_hours IS NOT NULL
GROUP BY priority
ORDER BY avg_resolution_hours DESC;

-- Explanation:
-- This query calculates the average resolution time for each priority level.
-- This helps compare resolution performance between low, medium, and high-priority tickets. Longer resolution times may indicate issue complexity or escalation bottlenecks.


-- Query 7: Average Satisfaction Score by Category
SELECT
    category,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction_score
FROM tickets
WHERE satisfaction_score IS NOT NULL
GROUP BY category
ORDER BY avg_satisfaction_score ASC;

-- Explanation:
-- This query calculates the average satisfaction score for each ticket category.
-- Categories with lower satisfaction scores should be reviewed because they may indicate poor resolution quality, slow response time, or recurring user frustration.


-- Query 8: Ticket Details with User and Agent Names
SELECT
    t.ticket_id,
    u.user_name,
    u.business_unit,
    a.agent_name,
    t.category,
    t.priority,
    t.status,
    t.resolution_time_hours,
    t.satisfaction_score
FROM tickets t
JOIN users u
    ON t.user_id = u.user_id
JOIN agents a
    ON t.agent_id = a.agent_id;

-- Explanation:
-- This query joins ticket records with user and agent information.
-- This provides a complete operational view of who raised each ticket, which business unit was affected, who handled the ticket, and how the ticket was resolved.


-- Query 9: Tickets Handled by Each Agent
SELECT
    a.agent_name,
    COUNT(t.ticket_id) AS total_tickets_handled
FROM tickets t
JOIN agents a
    ON t.agent_id = a.agent_id
GROUP BY a.agent_name
ORDER BY total_tickets_handled DESC;

-- Explanation:
-- This query counts how many tickets were handled by each support agent.
-- Agent workload analysis helps identify ticket distribution across the support team. If one agent handles significantly more tickets, workload balancing may be required.


-- Query 10: Tickets by Department
SELECT
    d.department_name,
    COUNT(t.ticket_id) AS total_tickets
FROM tickets t
JOIN agents a
    ON t.agent_id = a.agent_id
JOIN departments d
    ON a.department_id = d.department_id
GROUP BY d.department_name
ORDER BY total_tickets DESC;

-- Explanation:
-- This query joins tickets, agents, and departments to count how many tickets were handled by each department.
-- This analysis helps management understand which IT department receives the highest support demand and may need additional staffing, process improvement, or escalation support.

-----------------------------------------------------------------------------------------------------------------------------
-- Step 2: CASE WHEN query
-----------------------------------------------------------------------------------------------------------------------------

-- Query 11: SLA status for each ticket
SELECT
    ticket_id,
    priority,
    resolution_time_hours,
    CASE
        WHEN status = 'Open' THEN 'Still Open'
        WHEN priority = 'High' AND resolution_time_hours > 8 THEN 'Breached'
        WHEN priority = 'Medium' AND resolution_time_hours > 6 THEN 'Breached'
        WHEN priority = 'Low' AND resolution_time_hours > 3 THEN 'Breached'
        ELSE 'Within SLA'
    END AS sla_status
FROM tickets;

-- This allow us to check which solved tickets have exceeded the SLA limits.
-- This query uses business rules to classify ticket SLA performance. SLA tracking helps the IT team identify delayed resolutions and improve service reliability.

-- Query 12: SLA breach count by priority
SELECT
	priority,
    CASE
        WHEN status = 'Open' THEN 'Still Open'
        WHEN priority = 'High' AND resolution_time_hours > 8 THEN 'Breached'
        WHEN priority = 'Medium' AND resolution_time_hours > 6 THEN 'Breached'
        WHEN priority = 'Low' AND resolution_time_hours > 3 THEN 'Breached'
        ELSE 'Within SLA'
    END AS sla_status,
    COUNT(*) AS total_tickets
FROM tickets
GROUP BY
	priority,
	CASE
        WHEN status = 'Open' THEN 'Still Open'
        WHEN priority = 'High' AND resolution_time_hours > 8 THEN 'Breached'
        WHEN priority = 'Medium' AND resolution_time_hours > 6 THEN 'Breached'
        WHEN priority = 'Low' AND resolution_time_hours > 3 THEN 'Breached'
        ELSE 'Within SLA'
    END
ORDER BY priority, sla_status;
-- This allow us to see the total ticket of each sla status according to the priority
-- This analysis helps management analyse which priority breach SLA 

-----------------------------------------------------------------------------------------------------------------------------
-- Step 3: CTE query
-----------------------------------------------------------------------------------------------------------------------------

-- Query 13: Cleaner SLA analysis using CTE
WITH sla_analysis AS (
	SELECT
		ticket_id,
		priority,
        status,
		resolution_time_per_hours,
		CASE
			WHEN status = 'Open' THEN 'Still Open'
			WHEN priority = 'High' AND resolution_time_hours > 8 THEN 'Breached'
			WHEN priority = 'Medium' AND resolution_time_hours > 6 THEN 'Breached'
			WHEN priority = 'Low' AND resolution_time_hours > 3 THEN 'Breached'
			ELSE 'Within SLA'
		END AS sla_status,
		COUNT(*) AS total_tickets
	FROM tickets
    )
SELECT
	priority,
    sla_status,
    COUNT(*) AS total_tickets
FROM tickets
GROUP BY priority, sla_status
ORDER BY priority, sla_status;
-- This is the cleaner version of SLA breach count by priority by using CTE.
-- A CTE was used to separate the SLA classification logic from the final aggregation. This makes the query easier to read, maintain, and reuse.

-----------------------------------------------------------------------------------------------------------------------------
-- Step 4: Window Function Query
-----------------------------------------------------------------------------------------------------------------------------

-- Query 14: Rank Agents by Number of Tickets Handled
SELECT
    agent_name,
    total_tickets_handled,
    RANK() OVER (ORDER BY total_tickets_handled DESC) AS agent_rank
FROM (
    SELECT
        a.agent_name,
        COUNT(t.ticket_id) AS total_tickets_handled
    FROM tickets t
    JOIN agents a
        ON t.agent_id = a.agent_id
    GROUP BY a.agent_name
) agent_summary;
-- This ranks agents based on workload.
-- A window function was used to rank agents by ticket volume. This helps identify workload concentration and support capacity distribution.

-- Query 15: Rank Categories by Average Resolution Time
SELECT
	category,
    avg_resolution_hours,
    RANK() OVER (ORDER BY avg_resolution_hours DESC) AS resolution_rank
FROM (
	SELECT
		category,
        ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours
	FROM tickets
    WHERE resolution_time_hours IS NOT NULL
    GROUP BY category
    ) category_summary;
-- This tells you which issue categories take the longest to resolve.
-- The ranking shows which ticket categories consume the most resolution effort. These categories should be reviewed for process bottlenecks or technical root causes.

-----------------------------------------------------------------------------------------------------------------------------
-- Step 5: Monthly Trend Analysis
-----------------------------------------------------------------------------------------------------------------------------

-- Query 16: Ticket Volume by Month
SELECT
	DATE_FORMAT (created_date, '%Y-%m') AS month,
	COUNT(ticket_id) AS total_tickets
FROM tickets
GROUP BY DATE_FORMAT(created_date, '%Y-%m')
ORDER BY month;
-- This tracks ticket volume over time.
-- Monthly ticket trend analysis helps identify support demand patterns. If ticket volume increases over time, the IT team may need to investigate recurring issues or capacity constraints.

-----------------------------------------------------------------------------------------------------------------------------
-- Step 6: Final Business Insight Query
-----------------------------------------------------------------------------------------------------------------------------    
    
 -- Query 17: Full Ticket Performance Summary by Category
 WITH ticket_sla AS (
    SELECT
        ticket_id,
        category,
        priority,
        status,
        resolution_time_hours,
        satisfaction_score,
        CASE
            WHEN status = 'Open' THEN 'Still Open'
            WHEN priority = 'High' AND resolution_time_hours > 8 THEN 'Breached'
            WHEN priority = 'Medium' AND resolution_time_hours > 6 THEN 'Breached'
            WHEN priority = 'Low' AND resolution_time_hours > 3 THEN 'Breached'
            ELSE 'Within SLA'
        END AS sla_status
    FROM tickets
)
SELECT
    category,
    COUNT(ticket_id) AS total_tickets,
    ROUND(AVG(resolution_time_hours), 2) AS avg_resolution_hours,
    ROUND(AVG(satisfaction_score), 2) AS avg_satisfaction_score,
    SUM(CASE WHEN sla_status = 'Breached' THEN 1 ELSE 0 END) AS breached_tickets,
    SUM(CASE WHEN sla_status = 'Within SLA' THEN 1 ELSE 0 END) AS within_sla_tickets
FROM ticket_sla
GROUP BY category
ORDER BY breached_tickets DESC, avg_resolution_hours DESC;
-- This query summarizes ticket performance by category, including ticket volume, average resolution time, satisfaction score, and SLA breach count. The result helps identify which support categories create the most operational risk and should be prioritized for improvement.
