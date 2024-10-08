
select *
from layoff_staging2;

-- company with highest total_laid_off(on a single date)
select max(total_laid_off)
from layoff_staging2;


select *
from layoff_staging2
order by total_laid_off desc
limit 1 ;

select max(percentage_laid_off)
from layoff_staging2;

-- company with 100% laid off people
select company,percentage_laid_off
from layoff_staging2
where percentage_laid_off = 1 ;

-- highest laid off for 100% laid off company
select *
from layoff_staging2
where percentage_laid_off = 1 
order by total_laid_off desc;

-- highest funds for 100% laid off companies
select *
from layoff_staging2
where percentage_laid_off = 1 
order by funds_raised_millions desc;

-- finding out whether the layoffs are at the same time
select count(company)
from layoff_staging2;

select count(distinct(company))
from layoff_staging2;

-- using group by to find the company with highest total laid off(layofss at different dates)
SELECT company, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY company
ORDER BY 2 DESC;

-- exploring amazon layoffs
select *
from layoff_staging2
where company = 'amazon';

-- country that had highest layoffs
SELECT country, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY country
ORDER BY 2 DESC;

-- exploring the date range of our layoffs
select min(date),max(date)
from layoff_staging2;

-- total layoffs each year
SELECT YEAR(date), SUM(total_laid_off)
FROM layoff_staging2
GROUP BY YEAR(date)
ORDER BY 1 ASC;

 -- most affected industry by layoff wave
SELECT industry, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- stage of the company and how it affects the layoffs
SELECT stage, SUM(total_laid_off)
FROM layoff_staging2
GROUP BY stage
ORDER BY 2 DESC;


-- Rolling Total of Layoffs Per Month
SELECT SUBSTRING(date,1,7) as month, SUM(total_laid_off) AS total
FROM layoff_staging2
where SUBSTRING(date,1,7) is not null
GROUP BY month
order by month;

WITH Rolling_total AS 
(
SELECT SUBSTRING(date,1,7) as month, SUM(total_laid_off) AS total
FROM layoff_staging2
where SUBSTRING(date,1,7) is not null
GROUP BY month
ORDER BY month ASC
)
SELECT month ,total, SUM(total) OVER (ORDER BY month) as rolling_total
FROM rolling_total;


select company , year(date), sum(total_laid_off) as total
from layoff_staging2
group by company , year(date)
order by 2;

-- ranking the compaies according to their layoffs for each year
with company_year as
( select company , year(date) as year, sum(total_laid_off) as total
from layoff_staging2
where year(date) is not null
group by company , year(date)
order by 2
) , layoff_ranking as
(select * ,dense_rank() over(partition by year order by total desc) as ranking
from company_year)

select *
from layoff_ranking
where ranking <= 5




