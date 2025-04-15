# Customer-reward-tracking

SQL script to analyze user gold coin earnings, usage, and balance over time.

## 📂 Script Overview

**Script:** [`scripts/customer_reward.sql`](https://github.com/Ayeshungjosephat/Customer-reward-tracking/blob/main/customer%20reward.sql)

This query provides:

- Coins earned per user and the activity being rewarded for
- Running total of coins earned at the time of each activity
- Coins used per earning entry
- Balance snapshot after each activity
- Joined metadata: transaction type, user details, and opportunity label

### 💡 Use Cases
- Loyalty or gamification reporting
- User reward program analysis
- Customer behavior tracking

### 🧰 Tools
- MySQL 
- Visualization tools: Metabase, Power BI

### 📊 Sample Filters (in Metabase):
- `{{created_at}}` — Filter activities by date
- `{{email}}` — Drill down to individual users
- `{{activity}}` — Filter by opportunity type

## 🧠 Insights Enabled
- Track reward engagement over time
- Monitor top-earning opportunities
- Understand user redemption behavior
- Detect imbalances or reward misuse


