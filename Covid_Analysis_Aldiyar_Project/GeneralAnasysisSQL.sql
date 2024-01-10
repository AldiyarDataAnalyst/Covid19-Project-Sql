--Select * 
--from [dbo].[CovidVaccinations]

--Select * 
--from dbo.CovidDeaths

--Select location, date, total_cases, new_cases, total_deaths, population 
--from dbo.CovidDeaths
--order by 1,2

--Total Cases vs Total Death 

Select Location, date, total_cases, total_deaths, (CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0))*100 as DeathPercentage
From [dbo].[CovidDeaths]
Where location like '%turkey%' and total_cases is not Null
order by 1,2

    --Total Cases vs Population 
	-- What percentage of population got Covid

Select Location, date, Population, total_cases, (total_cases/population) *100 as InfectionRate
From [dbo].[CovidDeaths]
Where location like '%turkey%' and total_cases is not Null
order by 1,2
 

     -- Looking at Countries with highest Infection rate cs population 

Select Location, Population, Max(total_cases) AS HighestInfectionCount , (Max(total_cases)/population) *100 as PercentPopulationInfected
From [dbo].[CovidDeaths]
Group by Location, Population
order by PercentPopulationInfected desc


    -- Showing Countries with Highest Death Count per Population 

Select Location, Max(cast(total_deaths as int)) AS MaxDeathPerCountry 
From [dbo].[CovidDeaths]
Group by Location, Population
order by MaxDeathPerCountry desc




      --By continents total death 
	  
Select continent, Max(cast(total_deaths as int)) AS TotalDeatchByContinents 
from [dbo].[CovidDeaths]
Where continent is not null
Group by continent
order by TotalDeatchByContinents desc


       --Showing continents with the highest death count per population 

Select continent,Max(population) as TotalPopulationbycontinent, Max(cast(total_deaths as int)) as DeathperContinent
From [dbo].[CovidDeaths]
Where continent is not null
Group by continent


         -- Per day,total cases, total death,  percentage of death 

Select Sum(new_cases) as NewcasesPerday, Sum(new_deaths) as NewdeathsPerDay, Sum(new_deaths)/ Sum(new_cases) * 100 as Percentage
From [dbo].[CovidDeaths]
Where new_cases != 0
--group by date
order by 1,2


                   --Total Population vs Total VAccination 

Select dea.continent, dea.location , dea.date , dea.population, vac.new_vaccinations, 
Sum(Convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
From PortfolioProjectAldiyar..CovidDeaths dea
join PortfolioProjectAldiyar..CovidVaccinations vac
    on dea.location= vac.location
    and dea.date= vac.date
where dea.continent is not null 
order by 2,3



--                     Still      Trying to find percentage of vaccinated people

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjectAldiyar..CovidDeaths dea
Join PortfolioProjectAldiyar..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select Continent, Max(RollingPeopleVaccinated/Population)*100 as PercentVaccinated
From PopvsVac
Group by Continent

                -- Creating View 
Create View PercentagePeopleVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date ROWS UNBOUNDED PRECEDING) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProjectAldiyar..CovidDeaths dea
Join PortfolioProjectAldiyar..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3








          


 





