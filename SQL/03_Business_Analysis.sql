-- 1) The company is reviewing its organizational hierarchy. Identify the highest-ranking employee who leads the organization and occupies the most senior position in the 
-- management structure.
SELECT
first_name,
last_name,
title
FROM employee
ORDER BY levels DESC
LIMIT 1;
-- Interpretation:
-- Andrew Adams is the senior-most employee in the organization. He holds the position of General Manager and has the highest hierarchy level (L6), indicating the top managerial role within the company.

DESCRIBE invoice;
-- Q2. The company wants to identify its most active markets. Determine which countries generate the highest number of customer transactions and invoices.
SELECT
billing_country,
COUNT(*) AS total_invoices
FROM invoice
GROUP BY billing_country
ORDER BY total_invoices DESC;
-- Interpretation:
-- The USA generated the highest number of invoices (131), indicating that it is the most active market for the music store. This suggests a larger customer base and higher transaction frequency compared to other countries.

-- Q3. Management wants to understand the spending behavior of premium customers. Identify the top three highest-value purchases ever made in the music store.
SELECT
invoice_id, total
FROM invoice
ORDER BY total desc
LIMIT 3;
-- Interpretation:
-- The highest invoice amount recorded was $23.76, followed by two invoices worth $19.80 each. These invoices represent customers with the highest single-purchase spending.

-- Q4. The company is planning international expansion and wants to focus on its strongest market. Identify the country contributing the highest overall revenue to the business.
SELECT
billing_city, 
SUM(total) as city_total_revenue
FROM invoice
GROUP BY billing_city
ORDER BY city_total_revenue desc;
-- Interpretation:
-- Prague generated the highest revenue ($273.24) among all cities. This indicates that customers in Prague contributed the most monetary value to the business, 
-- making it the most profitable city despite not necessarily having the highest number of invoices.

-- Q5. The marketing team plans to host a promotional music festival in the city's most profitable market. Identify the city that generates the highest revenue and 
-- would provide the greatest return on promotional investment.
SELECT
billing_country, 
SUM(total) as country_total_revenue
FROM invoice
GROUP BY billing_country
ORDER BY country_total_revenue desc;
-- Interpretation:
-- The USA generated the highest total revenue ($1040.49), making it the most profitable market for the music store. Interestingly, although Prague (Czech Republic) is the single highest revenue-generating city, the Czech Republic ranks lower overall at the country level. This suggests that revenue in the USA is distributed across multiple cities, while Prague contributes a disproportionately large share of revenue within its country.

-- Q6. The company wants to recognize and retain its most valuable customer. Identify the customer who has contributed the highest total revenue through purchases.
SELECT
c.customer_id,
c.first_name,
c.last_name,
SUM(i.total) AS total_spent
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 1;
-- Interpretation:
-- František Wichterlová is the highest-value customer of the music store, with a total spending of $144.54. This indicates that the customer has made the largest overall contribution to the company's revenue and can be considered the most valuable customer based on purchase history.

-- Q7 The content acquisition team wants to understand customer music preferences. Identify the genre that contributes the highest revenue and serves as the primary driver of sales.
SELECT
g.name AS genre_name,
SUM(il.unit_price * il.quantity) AS revenue
FROM genre g
JOIN track t
ON g.genre_id = t.genre_id
JOIN invoiceline il
ON t.track_id = il.track_id
GROUP BY genre_name
ORDER BY revenue desc
LIMIT 5;
-- Interpretation:
-- Rock is the highest revenue-generating genre, contributing $2608.65 in sales. Its revenue is significantly higher than every other genre, indicating that Rock music is the primary driver of
-- customer purchases and overall business revenue. This suggests that customer demand is heavily concentrated in Rock-related tracks and artists.

-- Q8. The company is considering exclusive partnerships with artists. Identify the artists who generate the highest revenue and contribute most significantly to overall sales.
SELECT
a.name AS artist_name,
SUM(il.unit_price * il.quantity) AS revenue
FROM artist a
JOIN album al
ON a.artist_id = al.artist_id
JOIN track t
ON al.album_id = t.album_id
JOIN invoiceline il
ON t.track_id = il.track_id
GROUP BY artist_name
ORDER BY revenue DESC;
-- Interpretation:
-- Queen is the highest revenue-generating artist, contributing $190.08 in sales, closely followed by Jimi Hendrix at $185.13. The relatively small difference between 
-- the top artists indicates that revenue is distributed among several popular artists rather than being dominated by a single performer. This suggests a diverse customer preference across multiple artists.

-- Q9. The product team wants to identify premium long-duration content within the catalog. Find all tracks whose duration exceeds the average track length and 
-- highlight the longest recordings available.
SELECT AVG(milliseconds) AS avg_track_length
FROM track;

SELECT
name,
milliseconds
FROM track
WHERE milliseconds >
(
    SELECT AVG(milliseconds)
    FROM track
)
order by milliseconds desc;
-- Interpretation:
-- Several tracks significantly exceed the average duration of 393,599 milliseconds (6.56 minutes). The longest track, "Occupation / Precipice", has a duration of approximately 88 minutes. 
-- These exceptionally long tracks are likely extended recordings, TV episodes, live performances, or special content rather than traditional music tracks.

-- Q10. The marketing team plans to launch a targeted Rock Music promotion campaign. Identify all customers who have purchased Rock tracks so that personalized offers can be 
-- sent to the most relevant audience.
SELECT DISTINCT
c.email,
c.first_name,
c.last_name,
g.name 
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
JOIN invoiceline il
ON i.invoice_id = il.invoice_id
JOIN track t
ON il.track_id = t.track_id
JOIN genre g
ON t.genre_id = g.genre_id
WHERE g.name = 'rock'
ORDER BY c.email;

-- Q11. The company plans to organize a Rock Music Festival and wants to invite artists with the strongest Rock music catalog. Identify the artists who have
--  written the highest number of Rock tracks.
SELECT
a.name,
COUNT(t.track_id) AS rock_track_count
FROM artist a
JOIN album al
ON a.artist_id = al.artist_id
JOIN track t
ON al.album_id = t.album_id
JOIN genre g
ON t.genre_id = g.genre_id
WHERE g.name = 'Rock'
GROUP BY a.artist_id, a.name
ORDER BY rock_track_count DESC;
-- Interpretation:
-- Led Zeppelin has the largest Rock music catalog in the database with 114 Rock tracks, closely followed by U2 with 112 tracks. However, having the largest catalog does not
-- necessarily translate into the highest revenue, highlighting the difference between content volume and customer purchasing behavior. This insight can help the company select artists with extensive Rock portfolios for music festivals and promotional events.

-- Q12. The company is planning a large-scale music festival and wants to identify artists with the broadest audience reach. Determine which artists have been purchased by the
-- highest number of unique customers to identify performers with the strongest fanbase.
SELECT
a.name AS artist_name,
COUNT(DISTINCT c.customer_id) AS unique_customers
FROM customer c
JOIN invoice i
ON c.customer_id = i.customer_id
JOIN invoiceline il
ON i.invoice_id = il.invoice_id
JOIN track t
ON il.track_id = t.track_id
JOIN album al
ON t.album_id = al.album_id
JOIN artist a
ON al.artist_id = a.artist_id
GROUP BY a.artist_id, a.name
ORDER BY unique_customers DESC;
-- Interpretation:
-- The Rolling Stones have the largest audience reach, with 47 unique customers purchasing their music. Interestingly, the artist with the broadest customer base is different 
-- from both the highest revenue-generating artist (Queen) and the artist with the largest Rock catalog (Led Zeppelin). This demonstrates that revenue, catalog size, and 
-- audience reach represent different dimensions of artist performance and should be evaluated together when making strategic business decisions.

-- Q13. Analyze customer spending on individual artists.
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    a.name AS artist_name,
    SUM(il.unit_price * il.quantity) AS total_spent
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
JOIN invoiceline il
    ON i.invoice_id = il.invoice_id
JOIN track t
    ON il.track_id = t.track_id
JOIN album al
    ON t.album_id = al.album_id
JOIN artist a
    ON al.artist_id = a.artist_id
GROUP BY
    c.customer_id,
    customer_name,
    a.artist_id,
    a.name
ORDER BY total_spent DESC;
-- Interpretation:
-- The analysis reveals the strongest customer-artist spending relationships in the music store. Hugh O'Reilly spent the most on a single artist, contributing $27.72
--  to Queen's catalog. Interestingly, the highest-spending customer overall is different from the customer with the highest spending on an individual artist, suggesting that
--  some customers focus heavily on specific artists while others distribute their spending across a broader range of music.

-- Q14. The global marketing team wants to understand regional music preferences before launching country-specific promotional campaigns. By identifying the most popular genre 
-- in each country, the company can tailor recommendations, advertisements, and future content acquisitions to match local customer tastes.
-- Identify the most popular genre in each country based on the number of purchases.
WITH genre_popularity AS
(
    SELECT
        c.country,
        g.name AS genre_name,
        COUNT(*) AS purchases,
        ROW_NUMBER() OVER(
            PARTITION BY c.country
            ORDER BY COUNT(*) DESC
        ) AS rn
    FROM customer c
    JOIN invoice i
        ON c.customer_id = i.customer_id
    JOIN invoiceline il
        ON i.invoice_id = il.invoice_id
    JOIN track t
        ON il.track_id = t.track_id
    JOIN genre g
        ON t.genre_id = g.genre_id
    GROUP BY
        c.country,
        g.name
)

SELECT
    country,
    genre_name,
    purchases
FROM genre_popularity
WHERE rn = 1
ORDER BY purchases desc;
-- Interpretation:
-- Rock is the most popular genre in nearly every country represented in the dataset, indicating a strong global preference for Rock music among customers. The United States
 -- leads all countries with 561 Rock track purchases, making it the largest market for the genre. Interestingly, Argentina stands out as the only country where Alternative & Punk surpasses Rock,
--  suggesting a unique regional music preference that could benefit from specialized marketing campaigns and localized content recommendations.


-- Q15. The company wants to recognize its most valuable customer in every country. Identify the highest-spending customer within each country to support loyalty programs and
--  customer retention initiatives.
WITH customer_spending AS
(
    SELECT
        c.country,
        c.customer_id,
        CONCAT(c.first_name,' ',c.last_name) AS customer_name,
        SUM(i.total) AS total_spent,
        RANK() OVER(
            PARTITION BY c.country
            ORDER BY SUM(i.total) DESC
        ) AS rnk
    FROM customer c
    JOIN invoice i
        ON c.customer_id = i.customer_id
    GROUP BY
        c.country,
        c.customer_id,
        customer_name
)

SELECT
    country,
    customer_name,
    total_spent
FROM customer_spending
WHERE rnk = 1
ORDER BY total_spent desc;
-- Interpretation:
-- The analysis identifies the highest-spending customer within each country, allowing the company to recognize and reward its most valuable customers at a regional level. 
-- František Wichterlová from the Czech Republic is not only the top customer in the country but also the highest-spending customer across the entire music store, contributing $144.54 in revenue. 

-- P1. Identify the artists with the highest purchase volume based on track quantities purchased.
SELECT
    a.name AS artist_name,
    SUM(il.quantity) AS purchase_volume
FROM artist a
JOIN album al
    ON a.artist_id = al.artist_id
JOIN track t
    ON al.album_id = t.album_id
JOIN invoiceline il
    ON t.track_id = il.track_id
GROUP BY
    a.artist_id,
    a.name
ORDER BY purchase_volume DESC;
-- Interpretation:
-- Queen has the highest purchase volume with 192 track purchases, indicating strong and repeated customer demand. Interestingly, Queen also ranks first in revenue generation,
 -- reinforcing its position as the most commercially successful artist in the music store. In contrast, The Rolling Stones lead in audience reach but not purchase volume,
 -- suggesting that while more customers purchase their music, Queen's customers tend to make more frequent purchases.
 
 
--  -- P2. Identify the most frequently purchased tracks in the music store.
SELECT
    t.track_id as track_id,
    t.name AS track_name,
    SUM(il.quantity) AS purchase_volume
FROM track t
JOIN invoiceline il
    ON t.track_id = il.track_id
GROUP BY
    t.track_id,
    t.name
ORDER BY purchase_volume DESC;

-- P3. Calculate genre market share based on purchase volume.
-- P3. Calculate genre market share based on purchase volume.

SELECT
    g.name AS genre_name,
    SUM(il.quantity) AS purchase_volume,
    ROUND(
        SUM(il.quantity) * 100.0 /
        (SELECT SUM(quantity) FROM invoiceline),
        2
    ) AS market_share_pct
FROM genre g
JOIN track t
    ON g.genre_id = t.genre_id
JOIN invoiceline il
    ON t.track_id = il.track_id
GROUP BY
    g.genre_id,
    g.name
ORDER BY market_share_pct DESC;
-- Interpretation:
-- Rock dominates the music store with a market share of 55.39% of all purchases, making it the clear driver of customer demand. 


SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    ROUND(SUM(i.total),2) AS total_spent
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
GROUP BY
    c.customer_id,
    customer_name
ORDER BY total_spent DESC;

-- P5A. Calculate revenue generated by each customer.
SELECT
    c.customer_id,
    CONCAT(c.first_name,' ',c.last_name) AS customer_name,
    ROUND(SUM(i.total),2) AS total_revenue
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
GROUP BY
    c.customer_id,
    customer_name
ORDER BY total_revenue DESC;

SELECT
ROUND(SUM(total),2) AS total_company_revenue
FROM invoice;

-- Top 10 Customer Revenue = $1116.72

-- Total company Revenue = $4709.43

-- Revenue Contribution =
-- (1116.72 / 4709.43) × 100
-- = 23.71%

-- Interpretation:
-- The Top 10 customers generate approximately 23.71% of the company's total revenue, suggesting a diversified and stable customer base. Revenue is not heavily concentrated 
-- among a small number of customers, reducing business risk and increasing resilience against customer churn. This indicates that the company benefits from broad customer participation
--  rather than relying on a few high-value customers for financial performance.


-- P7. Measure genre loyalty using average purchases per customer.
SELECT
    g.name AS genre_name,
    SUM(il.quantity) AS total_purchases,
    COUNT(DISTINCT c.customer_id) AS unique_customers,
    ROUND(
        SUM(il.quantity) /
        COUNT(DISTINCT c.customer_id),
        2
    ) AS purchases_per_customer
FROM customer c
JOIN invoice i
    ON c.customer_id = i.customer_id
JOIN invoiceline il
    ON i.invoice_id = il.invoice_id
JOIN track t
    ON il.track_id = t.track_id
JOIN genre g
    ON t.genre_id = g.genre_id
GROUP BY
    g.genre_id,
    g.name
ORDER BY purchases_per_customer DESC;
-- Interpretation:
-- Rock demonstrates the strongest customer loyalty in the music store, generating an average of 44.66 purchases per customer. Interestingly, Rock and Metal attract the 
-- same number of unique customers (59), yet Rock generates more than four times the purchase volume. This indicates that Rock's market leadership is driven not only by
--  customer reach but also by exceptionally strong repeat-purchase behavior.


-- P8. Executive Dashboard Summary: Key business metrics and insights.

-- Revenue Metrics
-- Metric	                                Value
-- Total Revenue                            $4709.43
-- Top Customer     	                    František Wichterlová ($144.54)
-- Top Revenue Country   	                USA ($1040.49)
-- Top Revenue City	                        Prague ($273.24)
-- Top 10 Customer Revenue Contribution	    23.71%

-- Artist Performance
-- Metric	                         Winner

-- Highest Revenue Artist        	 Queen ($190.08)
-- Highest Purchase Volume Artist	 Queen (192 Purchases)
-- Largest Audience Reach	         The Rolling Stones (47 Customers)
-- Largest Rock Catalog	             Led Zeppelin (114 Rock Tracks)

-- Genre Performance
-- Metric	                    Winner

-- Highest Revenue Genre     	Rock ($2608.65)
-- Largest Market Share	        Rock (55.39%)
-- Strongest Customer Loyalty 	Rock (44.66 Purchases/Customer)

-- Track Performance
-- Metric                         	Winner
-- Most Purchased Track	          War Pigs - Cake (31 Purchases)

-- Customer Insights
-- Metric                                	Value
-- Best Customer Overall	                František Wichterlová
-- Highest Spending Customer-Artist Pair	Hugh O'Reilly → Queen ($27.72)
-- Revenue Distribution	                    Well Diversified
-- Business Risk	                        Low

-- Finding 1 

-- Rock dominates the business.
-- It leads:
	-- 	Revenue
	-- 	Purchase Volume
	-- 	Market Share
	-- 	Customer Loyalty
    
-- Finding 2
-- Queen is the commercial king.
-- Queen leads:
-- 		Revenue
-- 		Purchase Volume

-- Finding 3
-- Audience Reach and Revenue are different.
-- The Rolling Stones attract the largest audience,
-- but Queen generates more revenue.
-- This demonstrates that:
--         Popularity ≠ Revenue


-- Finding 4
-- Revenue is diversified.
-- Top 10 customers contribute only: 24% 
-- of total revenue 
-- This reduces dependence on a few customers.


-- Finding 5
-- Rock customers are exceptionally loyal.
-- Rock and Metal have the same number of customers: 59
-- Yet Rock generates: 2635 purchases
-- compared to: 619 purchases for metal