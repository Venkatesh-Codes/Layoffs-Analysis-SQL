
 -- Exploratory Data Analysis Project
 
select * from layoffs_staging2;

select company, max(percentage_laid_off)
from layoffs_staging2
group by company;


select company, min(percentage_laid_off)
from layoffs_staging2
group by company;

select * from layoffs_staging2;

select country,max(percentage_laid_off)
from layoffs_staging2
group by(country)
order by 1;

select  country,sum(total_laid_off) 
from layoffs_staging2
group by(country)
order by 2 desc;

select max(date),min(date)
from layoffslayoffs_staging2_staging2;

select date,sum(total_laid_off) 
from layoffs_staging2
group by date ;

select year(date),sum(total_laid_off) 
from layoffs_staging2
group by year(date) 
order by 1 desc;

select stage,sum(total_laid_off) 
from layoffs_staging2
group by stage 
order by 2 desc;

select substring(`date`,1,7) Month, sum(total_laid_off) total_off
from layoffs_staging2
group by(month)
having Month is not null
order by 1 desc;

with Rolling_total as
(
	select substring(`date`,1,7) Month, sum(total_laid_off) total_off
	from layoffs_staging2
	group by(month)
	having Month is not null
	order by 1 desc
)
	select Month,total_off,sum(total_off) over(order by Month) Rolling_total
	from Rolling_total;

select company,year(`date`),sum(total_laid_off)
from layoffs_staging2
group by company,year(`date`)
order by 3 desc;

with Company_Year (Company,Years,total_off) as
(
	select company,year(`date`),sum(total_laid_off) 
	from layoffs_staging2
	group by company,year(`date`)
	order by 3 desc

),
Ranker as
(
	select *,
	dense_rank() over(partition by Years order by total_off desc) Ranking
	from Company_Year
	where (Years is not null) 
	order by Ranking asc
)
select * from Ranker
 where Ranking <=5
 order by Years;


