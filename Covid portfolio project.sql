select *
from CovidDeaths$
where continent is null
order by 3 ,4 

--select *
--from CovidVaccinations$
--order by 3 ,4 


select location , date , total_cases , new_cases , total_deaths , population
from CovidDeaths$
order by 1,2



-- Total Cases vs Total Deaths

select location , date , total_cases , total_deaths , (total_deaths/total_cases)*100 as deathpercentage
from CovidDeaths$
where location like '%egypt%'
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

select location , date , population , total_cases ,(total_cases/population)*100 as infectedpercentage
from CovidDeaths$
--where location = 'Egypt'
order by 1 ,2 

-- Countries with Highest Infection Rate compared to Population

select location , population , max(total_cases) as highestinfectioncount ,max(total_cases/population)*100 as infectedpercentage
from CovidDeaths$
group by location , population
order by 4 desc

-- Countries with Highest Death Count per Population

select location , max(cast(total_deaths as int)) as totaldeathcount 
from CovidDeaths$
where continent is not null
group by location  
order by 2 desc



--global numbers

select date , sum(new_cases) as totalcases , sum(cast(new_deaths as int)) as totaldeaths , sum(cast(new_deaths as int))/sum(new_cases) as deathpercentage
from CovidDeaths$
where continent is not null
group by date
order by 1,2 

select *
from CovidVaccinations$


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select dea.continent , dea.location , dea.date , population , vac.new_vaccinations ,sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as rollingpeoplevaccinated
from CovidDeaths$  dea
join CovidVaccinations$  vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2 , 3

 -- use CTE

with pop_vsvac as

(select dea.continent , dea.location , dea.date , population , vac.new_vaccinations ,sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as rollingpeoplevaccinated
from CovidDeaths$  dea
join CovidVaccinations$  vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
)
select * , rollingpeoplevaccinated/population *100
from pop_vsvac


-- use temp table

drop table if exists #percentpopvaccinated
create table #percentpopvaccinated
(continent nvarchar(225),
location nvarchar(225),
date datetime ,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

insert into #percentpopvaccinated
select dea.continent , dea.location , dea.date , population , vac.new_vaccinations ,sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as rollingpeoplevaccinated
from CovidDeaths$  dea
join CovidVaccinations$  vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select * , rollingpeoplevaccinated/population *100
from #percentpopvaccinated


--create view to store data for later visualisations

create view percentpopvaccinated as
select dea.continent , dea.location , dea.date , population , vac.new_vaccinations ,sum(cast(new_vaccinations as int)) over (partition by dea.location order by dea.location , dea.date) as rollingpeoplevaccinated
from CovidDeaths$  dea
join CovidVaccinations$  vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null

select *
from percentpopvaccinated