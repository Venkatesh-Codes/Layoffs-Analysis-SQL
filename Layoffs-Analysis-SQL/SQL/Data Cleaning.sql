
-- Data Cleaning Project

-- 1) Remove Duplicates
-- 2) Standardize the Data
-- 3) Handle NUll Values or Blank Values
-- 4) Remove Unnecesarsary Columns


-- 1) Remove Duplicates

select * from layoffs;

-- create Duplicate Table for Raw data safety

create table layoffs_staging1
like layoffs;

insert into layoffs_staging1
select * from layoffs;

select * from layoffs_staging1;

-- Find Duplicates

select * from layoffs_staging1;

with cte_ex as
(
	select *,
    row_number() over(partition by company, location, 
    industry, total_laid_off, percentage_laid_off, `date`,
    stage, country, funds_raised_millions) row_num
    from layoffs_staging1
)
select * from cte_ex
where row_num>1;

CREATE TABLE `layoffs_staging2` (
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

select * from layoffs_staging2;

insert into layoffs_staging2
select *,
    row_number() over(partition by company, location, 
    industry, total_laid_off, percentage_laid_off, `date`,
    stage, country, funds_raised_millions) row_num
    from layoffs_staging1;

select * from layoffs_staging2;

-- Remove Duplicates

select * from layoffs_staging2
where row_num>1;

delete from layoffs_staging2
where row_num>1;

select * from layoffs_staging2;

-- 2) Standardize the Data(Working on Sapces and spellings)

select * from layoffs_staging2;

select distinct company
from layoffs_staging2
order by 1;

-- Remove Spaces Anything

update layoffs_staging2
set company=trim(company);

select * from layoffs_staging2;

-- Working on industry Column

 select * from layoffs_staging2;
 
 select distinct  industry
 from layoffs_staging2
 order by 1;

select industry
from layoffs_staging2
where industry like'crypto%';

update layoffs_staging2
set industry='Crypto'
where industry like 'Crypto%';

-- Working on Country Column

select * from layoffs_staging2;

select distinct country
from layoffs_staging2
order by 1;


update layoffs_staging2
set country='United States'
where country like 'United States%';

select * from layoffs_staging2
where country like 'United States%';

select * from layoffs_staging2;


-- Working on Date Column

select * from layoffs_staging2;

update layoffs_staging2
set `date`=str_to_date(`date`,'%m/%d/%Y');

alter table layoffs_staging2
modify column `date`date;

select * from layoffs_staging2;


-- 3) Handle NUll Values or Blank Values

select * from layoffs_staging2;

select * from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;


delete from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null;

select * from layoffs_staging2;

select * from layoffs_staging2
where industry is null or industry='';

select * from layoffs_staging2
where company = 'Airbnb';

update layoffs_staging2
set industry=null
where industry='';

select t1.industry,t2.industry
from layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company=t2.company and t1.location=t2.location
where t1.industry is null
and t2.industry is not null;


update layoffs_staging2 t1
join layoffs_staging2 t2
on t1.company=t2.company and t1.location=t2.location
set t1.industry=t2.industry
where t1.industry is null
and t2.industry is not null;


-- 4) Remove Unwanted columns

select * from layoffs_staging2;

alter table layoffs_staging2
drop column row_num;

select * from layoffs_staging2;