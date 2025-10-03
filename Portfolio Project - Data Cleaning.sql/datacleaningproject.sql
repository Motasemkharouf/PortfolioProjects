--  Removing Duplicates
select 
* from layoffs;

create table layoff2
Like layoffs;

select * from layoff2;

insert into layoff2 
select 
* from layoffs;
select * from layoff2;

select * ,
row_number() OVER (
partition by company , location , industry , total_laid_off ,percentage_laid_off, `date`) As row_num_dub
from layoff2;

with remov_dub AS
(
select * ,
row_number() OVER (
partition by company , location , industry , total_laid_off ,percentage_laid_off, `date`) As row_num_dub
from layoff2



)
select * from remov_dub 
where row_num_dub > 1;

CREATE TABLE `layoff3` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num_dup` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select * from layoff3;

insert into layoff3 
select * ,
row_number() OVER (
partition by company , location , industry , total_laid_off ,percentage_laid_off, `date`) As row_num_dup
from layoff2;

select * from layoff3
where row_num_dup >1 ;

delete from layoff3 
where row_num_dup > 1 ;
select * from layoff3
where row_num_dup >1 ;



-- Standardizing Data


select company, trim(company) from layoff3 ;
update layoff3
set company = trim(company);

select  distinct industry from layoff3
order by 1;

update layoff3 set industry = 'crypto'
where industry Like 'crypto%';

select  distinct country from layoff3 order by 1;

update layoff3 
set country = trim(trailing '.' from country )
where country like 'united states%';

select `date` 
from layoff3;

update layoff3 
set `date` = str_to_date(`date` ,'%m/%d/%Y');

alter table layoff3 
modify column `date` date;


-- Null/Blank Values


update layoff3 
set industry =null
where industry = ''; 

select * from layoff3
where industry is null or industry ='';

select st1.industry , st2.industry
from layoff3 st1
join layoff3 st2
on st1.company=st2.company 
and st1.location = st2.location
where (st1.industry is null or st1.industry= '') and st2.industry is not null;

update layoff3 st1 
join layoff3 st2 
on st1.company=st2.company 
and st1.location = st2.location
set st1.industry = st2.industry 
where (st1.industry is null or st1.industry= '') and st2.industry is not null;


-- Remove Unnecessary Columns/Rows: 

select * from layoff3 
where total_laid_off is null
and percentage_laid_off is null;


delete from layoff3 
where total_laid_off is null
and percentage_laid_off is null;

select * from layoff3; 

alter table layoff3  drop column row_num_dup;

