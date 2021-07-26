--select *
--from COVIDPROJ..CovidDeaths
--order by 3,4

--select *
--from COVIDPROJ..CovidVaccinations
--order by 5
---------------------------------------------------------------------
/* CLEANING */

Select *
From COVIDPROJ..CovidDeaths
Where continent is not null
Order By 3,4

----------------------------------------------------------------------
/* SELECTING DATA TO USE */

Select Location, date, total_cases, new_cases, total_deaths, population
From COVIDPROJ..CovidDeaths
Where continent is not null
Order By 1, 2

-- TOTAL CASES VS TOTAL DEATHS (REPORTED CASE TO DEATH PERCENTAGE each day "in ukraine")

Select Location, date, cast(total_cases as int), cast(total_deaths as int),
(total_deaths/total_cases)*100 as DeathPercentage
From COVIDPROJ..CovidDeaths
Where location like '%UKRAINE%' and continent is not null
Order By 4 desc

-- TOTAL CASES VS POPULATION (Percentage of population has been tested positive)

Select Location, date, population, total_cases, (total_cases/population)*100 as InfectedPercentage
From COVIDPROJ..CovidDeaths
Where location like '%UKRAINE%' and continent is not null
Order By 1, 2

-- WHICH COUNTRIES HAVE HIGHEST INFECTION RATE COMPARED TO POPULATION

Select Location, population, MAX(total_cases) as HighestInfectionCount,
Max((total_cases)/population)*100 as MaxInfectedratio
From COVIDPROJ..CovidDeaths
Where continent is not null
GROUP BY location, population
Order By 4 desc

-- COUNTRIES WITH THE HIGHEST DEATH COUNT PER POPULATION (Max Death percentage per countries)

Select Location, population, MAX(cast(total_deaths as int)) as TotalDeathCount, 
MAX(total_deaths/population)*100 as MaxDeathPercentage
From COVIDPROJ..CovidDeaths
Where continent is not null
Group by Location, population
Order By 4 desc

-- BY CONTINENT
-- CONTINENT WITH THE HIGHEST DEATH COUNT PER POPULATION (Max Death percentage per CONTINENT)

Select location, MAX(cast(total_deaths as int)) as TotalDeathCount, Population,
MAX(total_deaths/population)*100 as MaxDeathPercentage
From COVIDPROJ..CovidDeaths
Where continent is null
Group by location, population
Order By 2 DESC

/* BELOW SHOULD BE THE CORRECT SYNTAX BUT IN OUR TABLE SUMMARIZED VALUE FOR CONTINENTS
HAVE BEEN SAVED UNDER THE LOCATIONS TAB, AND THE BELOW SYNTAX JUST PICKS THE MAX COUNTRY
IN EACH CONTINENT e.g USA in NORTH AMERICA. SO WE USE THE ABOVE SYNTAX INSTEAD BECAUSE 
CONTINENT SAVED UNDER LOCATION

------Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount, 
------MAX(total_deaths/population)*100 as MaxDeathPercentage
------From COVIDPROJ..CovidDeaths
------Where continent is not null
------Group by continent
------Order By 2 DESC
*/

--- WHICH CONTINENTS HAVE HIGHEST INFECTION RATE COMPARED TO POPULATION

Select Location, population, MAX(total_cases) as HighestInfectionCount,
Max((total_cases)/population)*100 as MaxInfectedratio
From COVIDPROJ..CovidDeaths
Where continent is null AND population is not null
GROUP BY location, population
Order By 3 desc

-- TOTAL CASES PER DAY in EACH CONTINENT VS POPULATION (Percentage of population has been tested positive)

Select Location, date, population, total_cases, (total_cases/population)*100 as InfectedPercentage
From COVIDPROJ..CovidDeaths
Where continent is null
Order By 1, 2


---- GLOBAL NUMBERS

----TOTAL DEATH PERCENTAGE GLOBALLY (summed up each day from day 1) ALL CASES SUMMED FROM
----FIRST DAY IN TABLE TILL DATE ON EACH ROW

Select date, cast(total_cases as int) as TotalCases,
	   cast(total_deaths as int) as TotalDeaths,
	   (total_deaths/total_cases)*100 as GlobalDeathPercentage
From COVIDPROJ..CovidDeaths
Where continent is null and location like '%world%'
Order By 1

---TOTAL DEATH TILL THE LAST DATE IN THE TABLE
Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths,
(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as 'GlobalDeath%'
From COVIDPROJ..CovidDeaths
Where new_cases <> 0 and  location like'%world%'
Order By 1


----OVERALL DEATH PERCENTAGE DAILY CHANGES (NEW CASES AND NEW DEATH FOR EACH DAY)
Select date, SUM(new_cases) as DailyCases, SUM(cast(new_deaths as int)) as DailyDeaths,
(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as 'GlobalDailyDeath%'
From COVIDPROJ..CovidDeaths
Where new_cases <> 0 and  location like'%world%'
Group By date
Order By 1


----------COVID VACCINATIONS TABLE------------

Select *
From COVIDPROJ..CovidVaccinations

-----------------------------------------------

/* JOINING THE TABLE COVID DEATH  AND VACCINATION TABLE*/

Select*
From COVIDPROJ..CovidDeaths as CoDeaths
JOIN COVIDPROJ..CovidVaccinations as CoVac
	 ON CoDeaths.date = CoVac.date 
	 and CoDeaths.location = CoVac.location


----LOOKING AT TOTAL PEOPLE VACCINATED IN EACH COUNTRY EACH DAY
--USING A TEMP table

DROP Table if exists #PercentPopulatedVaccinated
Create Table #PercentPopulatedVaccinated
(continent nvarchar(50),
location nvarchar(50),
date datetime,
population numeric,
new_vaccinations numeric,
SummingPeopleVac numeric
)
Insert into #PercentPopulatedVaccinated
Select CoDeaths.continent, CoDeaths.location, CoDeaths.date,
CoDeaths.population, CoVac.new_vaccinations,
SUM(CONVERT(int, Covac.new_vaccinations)) 
OVER (Partition by CoDeaths.location Order By CoDeaths.location, CoDeaths.date)
as SummingPeopleVac --(SummingPeopleVac/population)*100
From COVIDPROJ..CovidDeaths as CoDeaths
JOIN COVIDPROJ..CovidVaccinations as CoVac
	 ON CoDeaths.date = CoVac.date 
	 and CoDeaths.location = CoVac.location
Where CoDeaths.continent is not null and CoVac.new_vaccinations is not null

---table call
Select*, (SummingPeopleVac/population)*100 AS PercentageVaccinated
From #PercentPopulatedVaccinated
Order by 1,2,3

  
  ----------CREATING VIEW to store data FOR VISUALIZATIONS------

--Create View PercentPopulatedVaccinated as
--Select CoDeaths.continent, CoDeaths.location, CoDeaths.date,
--CoDeaths.population, CoVac.new_vaccinations,
--SUM(CONVERT(int, Covac.new_vaccinations)) 
--OVER (Partition by CoDeaths.location Order By CoDeaths.location, CoDeaths.date)
--as SummingPeopleVac --(SummingPeopleVac/population)*100
--From COVIDPROJ..CovidDeaths as CoDeaths
--JOIN COVIDPROJ..CovidVaccinations as CoVac
--	 ON CoDeaths.date = CoVac.date 
--	 and CoDeaths.location = CoVac.location
--Where CoDeaths.continent is not null and CoVac.new_vaccinations is not null

--Select *
--From PercentPopulatedVaccinated
--Order by 1,2,3