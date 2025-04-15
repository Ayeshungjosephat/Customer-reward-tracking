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
    gold_coin_earning_opportunities  ON gold_coin_earning_opportunities.id = gold_coin_earnings.opportunity_id
    LEFT JOIN users  ON users.id = gold_coin_earnings.user_id
    LEFT JOIN transactions  ON transactions.id = gold_coin_earnings.source_transaction_id
    
 where {{created_at}} and {{email}} and {{activity}}

ORDER BY 
    gold_coin_earnings.user_id,
    gold_coin_earnings.created_at desc;
