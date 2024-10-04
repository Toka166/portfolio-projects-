select *
from layoffs ;

-- remove duplicates
-- standarize data
-- null values 
-- remove unused columns

create table layoff_staging 
like layoffs ;
Select *
from layoff_staging ;
insert layoff_staging
select *
from layoffs;

with cte_layoff as
( select * , row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions)
as row_num
from layoff_staging )

select *
from cte_layoff
where row_num > 1;


CREATE TABLE `layoff_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoff_staging2
select * , row_number() over(partition by company,location,industry,total_laid_off,percentage_laid_off,date,stage,country,funds_raised_millions)
as row_num
from layoff_staging ;

Delete
from layoff_staging2
where row_num > 1 ;

select *
from layoff_staging2
where row_num > 1 ;

select company, trim(company)
from layoff_staging2 ;


update layoff_staging2
set company = Trim(company);

select *
from layoff_staging2;

select distinct(industry)
from layoff_staging2
order by 1;

select *
from layoff_staging2
where industry like '%crypto%'; 

update layoff_staging2
set industry = 'Crypto'
where industry like '%crypto%';

select distinct(country)
from layoff_staging2
order by 1;

update layoff_staging2
set country = 'United States'
where country like '%States%';

update layoff_staging2
set country = trim(trailing '.'from country)
where country like '%States%';

select date , str_to_date(date,'%m/%d/%Y')
from layoff_staging2;

update layoff_staging2
set date = str_to_date(date,'%m/%d/%Y');

alter table layoff_staging2
modify column date date;

select *
from layoff_staging2
where industry is null
or industry ='';


update layoff_staging2
set industry = null
where industry = '';

select * 
from layoff_staging2 tb1
join layoff_staging2 tb2
on tb1.company = tb2.company
and tb1.location = tb2.location
where tb1.industry is null 
and tb2.industry is not null;

update layoff_staging2 tb1
join layoff_staging2 tb2
on tb1.company = tb2.company
and tb1.location = tb2.location
set tb1.industry = tb2.industry
where tb1.industry is null 
and tb2.industry is not null;

select * 
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null ;

delete 
from layoff_staging2
where total_laid_off is null
and percentage_laid_off is null ;

alter table layoff_staging2
drop column `row_num` 





