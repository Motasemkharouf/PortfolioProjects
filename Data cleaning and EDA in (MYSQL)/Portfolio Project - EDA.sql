

SELECT * 
FROM layoff3;

--  QUERIES

SELECT MAX(total_laid_off)
FROM layoff3;



-- Looking at Percentage to see how big these layoffs were
SELECT MAX(percentage_laid_off),  MIN(percentage_laid_off)
FROM layoff3
WHERE  percentage_laid_off IS NOT NULL;

-- Which companies had 1 which is basically 100 percent of they company laid off
SELECT *
FROM layoff3
WHERE  percentage_laid_off = 1;
-- these are mostly startups it looks like who all went out of business during this time

-- if we order by funcs_raised_millions we can see how big some of these companies were
SELECT *
FROM layoff3
WHERE  percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;
-- BritishVolt looks like an EV company, Quibi! I recognize that company - wow raised like 2 billion dollars and went under - ouch







-- Companies with the biggest single Layoff

SELECT company, total_laid_off
FROM layoff3
ORDER BY 2 DESC
LIMIT 5;

-- Companies with the most Total Layoffs
SELECT company, SUM(total_laid_off)
FROM layoff3
GROUP BY company
ORDER BY 2 DESC
LIMIT 10;



-- by location
SELECT location, SUM(total_laid_off)
FROM layoff3
GROUP BY location
ORDER BY 2 DESC
LIMIT 10;

-- this it total in the past 3 years or in the dataset

SELECT country, SUM(total_laid_off)
FROM layoff3
GROUP BY country
ORDER BY 2 DESC;

SELECT YEAR(date), SUM(total_laid_off)
FROM layoff3
GROUP BY YEAR(date)
ORDER BY 1 ASC;


SELECT industry, SUM(total_laid_off)
FROM layoff3
GROUP BY industry
ORDER BY 2 DESC;


SELECT stage, SUM(total_laid_off)
FROM layoff3
GROUP BY stage
ORDER BY 2 DESC;






-- TOUGHER QUERIES-------------------------------------------


-- Companies with the most Layoffs at that per year

with company_y AS 
(
select company, year(date) as years, sum(total_laid_off) as total_l_off
from layoff3
group by company ,year(date)

)
, comp_rank as
(
select company, years, total_l_off , 
dense_rank() Over(partition by years order by total_l_off desc) as totall
from company_y
)
select  company, years, total_l_off , totall 
from comp_rank 
where totall <=3
and years is not null
order by years asc, total_l_off desc;


-- Rolling Total of Layoffs Per Month



SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoff3
GROUP BY dates
ORDER BY dates ASC;

-- now use it in a CTE so we can query off of it
WITH DATE_CTE AS 
(
SELECT SUBSTRING(date,1,7) as dates, SUM(total_laid_off) AS total_laid_off
FROM layoff3
GROUP BY dates
ORDER BY dates ASC
)
SELECT dates, SUM(total_laid_off) OVER (ORDER BY dates ASC) as rolling_total_layoffs
FROM DATE_CTE
ORDER BY dates ASC;