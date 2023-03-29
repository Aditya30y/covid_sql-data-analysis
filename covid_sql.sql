--TOTAL CASES vs TOTAL DEATHS IN INDIA

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercent
from [portfolio project]..covid_deaths$
where location = 'India'
order by date desc

--TOTAL CASES vs TOTAL DEATHS
select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as deathpercent
from [portfolio project]..covid_deaths$
order by date desc

-- COUNTRIES WITH HIGHEST INFECTION RATE
select location, population, MAX(total_cases) AS HIGHEST_INFECTION, MAX(total_cases/population)*100 as PercentPopnInfected
from [portfolio project]..covid_deaths$
group by location,population
order by PercentPopnInfected desc


--COUNTRIES WITH HIGHEST DEATH PER POPULATION
select location,MAX(cast(total_deaths AS bigint)) as deaths
from [portfolio project]..covid_deaths$
where continent is not null
group by location 
order by deaths desc

--continent with most covid deaths 
select continent, MAX(cast(total_deaths as bigint)) as totaldeathcount
from [portfolio project]..covid_deaths$
where continent is not null
group by continent
order by totaldeathcount desc

--joining two tables --
Select *
from [portfolio project]..covid_deaths$ as dea
join [portfolio project]..covid_vaccination$ as vac
    On dea.location = vac.location
	and dea.date = vac.date


	--global death precentage
select date,sum(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths,
SUM(cast(new_deaths as bigint))/sum(new_cases)*100 as GlobalDeathpercent
from [portfolio project]..covid_deaths$
where continent is not null
group by date
order by date

--TotalGlobalDeath
select sum(new_cases) as total_cases, SUM(cast(new_deaths as bigint)) as total_deaths,
SUM(cast(new_deaths as bigint))/sum(new_cases)*100 as GlobalDeath
from [portfolio project]..covid_deaths$
where continent is not null 


--total populatios vs vaccination
Select distinct dea.continent,dea.location, dea.date,dea.population,vac.new_vaccinations
,SUM(CONVERT(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) AS TOTALVACCINATION
from [portfolio project]..covid_deaths$ dea
inner join [portfolio project]..covid_vaccination$ vac
    On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by dea.location,dea.date


--to find daily no. of  vaccinations and daily reading of totaal vaccinated population, CTE is used

Select *,(DailyVaccinations/population)*100 as PercentVaccinated
from PopnvsVacn
with PopnvsVacn(population,location,continent,date,new_vaccinations,DailyVaccinations)
AS
(
Select distinct dea.population,dea.location,dea.continent,dea.date,vac.new_vaccinations
,SUM(convert(bigint,vac.new_vaccinations)) OVER (partition by dea.location  order by dea.location,
dea.date) as DailyVaccinations
from [portfolio project]..covid_deaths$ dea
join [portfolio project]..covid_vaccination$ vac
    On dea.location = vac.location
	and dea.date = vac.date
	where dea.continent is not null 
	--order by dea.CONTINENT
)






