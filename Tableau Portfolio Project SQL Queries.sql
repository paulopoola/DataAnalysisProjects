/*
Queries OPTIMIZED for Tableau COVID Project
*/

-- 1.  TOTAL DEATH VS REPORTED CASES GLOBALLY AS OF JULY 24 2021

Select SUM(new_cases) as TotalCases, SUM(cast(new_deaths as int)) as TotalDeaths,
(SUM(cast(new_deaths as int))/SUM(new_cases))*100 as 'GlobalDeath%'
From COVIDPROJ..CovidDeaths
Where new_cases <> 0 and  location like'%world%'


-- 2. TOTAL DEATH COUNT IN EACH CONTINENT 

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From COVIDPROJ..CovidDeaths
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc


-- 3. THE TOTAL REPORTED INFECTED COVID CASES IN EACH COUNTRY. AS OF 24/07/21

Select Location, population, MAX(total_cases) as HighestInfectionCount,
Max((total_cases)/population)*100 as MaxInfectedpercent
From COVIDPROJ..CovidDeaths
Where continent is not null AND population is not null
GROUP BY location, population
Order By 4 desc

-- 4.

Select Location, date, population, MAX(total_cases) as HighestInfectionCount,
Max((total_cases)/population)*100 as MaxInfectedpercent
From COVIDPROJ..CovidDeaths
Where continent is not null AND population is not null
GROUP BY location, date, population
Order By 5 desc

