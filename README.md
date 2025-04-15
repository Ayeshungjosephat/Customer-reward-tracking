# 🪙 Customer Reward Analytics Report

A SQL-based analytics report designed to track and monitor users' gold coin earnings and usage across the platform.

## 🧾 Project Overview

This project is a **Gold Coin Loyalty Analytics Report**, developed to track and analyze how users earn and use digital loyalty coins (Gold Coins) through various platform activities. The objective is to provide transparency into coin-related transactions, uncover user engagement trends, and assess the impact of reward-based incentives on customer behavior.

By leveraging SQL to join earnings, usage, and transaction records, this analysis captures not only the raw coin activity, but also:

- The running **balance** of Gold Coins per user at every point in time  
- The **total earned** and **used coins** from the beginning of each user’s journey  
- **Usage behavior** by activity type and transaction  
- Insights into which activities drive the most engagement and value for both the business and the user  

This report can be integrated into dashboards (e.g., **Metabase**, **Power BI**) to support real-time monitoring or used offline for deep-dive audits and strategic planning.

---

## 🛠 Tools Used

- **MySQL** — Data querying and aggregation  
- **Metabase** — Dashboard integration and visualization  
- **Excel/Power BI** *(optional)* — Deeper analysis and report formatting

---

## 📊 Key Features

- User-level tracking of coin activities  
- Cumulative coins earned and used  
- Coin balance at every point of activity  
- Filter by time, user, and activity type  
- Supports real-time data querying  

---

## 🧠 Insights Use Cases

- Understanding loyalty program performance  
- Identifying high-engagement activities  
- Detecting coin burn patterns and balance thresholds  
- Optimizing coin reward strategies

---

## 💻 SQL Query

```sql
SELECT 
    gold_coin_earnings.user_id,
    CONCAT(users.firstname, ' ', users.lastname) as customer_name,
    users.email,
    gold_coin_earnings.created_at,
    gold_coin_earning_opportunities.label AS opportunity_label,
    transactions.type as transaction_type,
    gold_coin_earnings.coins_earned,
    
    -- Total Coins Earned as at the time of activity
    (
        SELECT SUM(ge_inner.coins_earned)
        FROM gold_coin_earnings ge_inner
        WHERE ge_inner.user_id = gold_coin_earnings.user_id 
          AND ge_inner.created_at <= gold_coin_earnings.created_at
    ) AS total_coins_earned_at_time,
    
    -- Total Coins Used by the User
    COALESCE((
        SELECT SUM(gold_coin_usages.coins_used)
        FROM gold_coin_usages 
        LEFT JOIN gold_coin_usage_breakdowns gub ON gub.usage_id = gold_coin_usages.id
        WHERE gub.earning_id = gold_coin_earnings.id
    ), 0) AS coins_used,

    -- Balance at the time of activity
    (
        (
            SELECT SUM(ge_inner.coins_earned)
            FROM gold_coin_earnings ge_inner
            WHERE ge_inner.user_id = gold_coin_earnings.user_id 
              AND ge_inner.created_at <= gold_coin_earnings.created_at
        ) - 
        COALESCE((
            SELECT SUM(gold_coin_usages.coins_used)
            FROM gold_coin_usages 
            LEFT JOIN gold_coin_usage_breakdowns gub ON gub.usage_id = gold_coin_usages.id
            WHERE gub.earning_id = gold_coin_earnings.id
        ), 0)
    ) AS balance_at_time

FROM 
    gold_coin_earnings 
LEFT JOIN 
    gold_coin_earning_opportunities ON gold_coin_earning_opportunities.id = gold_coin_earnings.opportunity_id
LEFT JOIN users ON users.id = gold_coin_earnings.user_id
LEFT JOIN transactions ON transactions.id = gold_coin_earnings.source_transaction_id

WHERE {{created_at}} AND {{email}} AND {{activity}}
ORDER BY 
    gold_coin_earnings.user_id,
    gold_coin_earnings.created_at DESC;


