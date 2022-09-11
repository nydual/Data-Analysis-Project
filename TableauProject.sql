SELECT * FROM CovidCases.coviddeaths
WHERE continent is not null
ORDER BY 3,4;


SELECT location, date,  total_cases, new_cases, total_deaths, population
FROM CovidCases.coviddeaths
WHERE continent is not null
ORDER BY 1,2;

-- looking at total_cases vs total_deaths

SELECT location, date,  total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM CovidCases.coviddeaths
WHERE location like '%Africa%'
AND continent is not null
ORDER BY 1,2;

-- Looking at  total cases vs population
-- shows the percentages of covid that got covid-19
SELECT location, date,  population, total_cases,(total_cases/population)*100 as PopulationInfectedpercent
FROM CovidCases.coviddeaths
WHERE location like '%Africa%'
AND continent is not null
ORDER BY 1,2;

-- looking at the countries with highest infection rates compared by population
SELECT location,  population, MAX(total_cases) as HighestInfectionRate,MAX((total_cases/population))*100 as PopulationInfectedpercent
FROM CovidCases.coviddeaths
WHERE continent is not null
GROUP BY continent
ORDER BY PopulationInfectedpercent DESC;

-- countries with the highest death rate per population
SELECT location, MAX(total_deaths) as TotalDeathRate 
FROM CovidCases.coviddeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathRate DESC;

-- Looking at the death rate per continent
SELECT location, MAX(total_deaths) as TotalDeathRate 
FROM CovidCases.coviddeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathRate DESC;

--  global numbers
SELECT date,SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM CovidCases.coviddeaths
WHERE continent is not null
-- GROUP BY date
ORDER BY 1,2;

-- looking at total population vs total vacination
SELECT DEA.continent,DEA.location, DEA.date, DEA.population, VAC.new_vaccinations,SUM(VAC.new_vaccinations) OVER (partition by DEA.location ORDER BY DEA.location, DEA.date) as RollingVacinatedpeople
FROM CovidCases.coviddeaths DEA
JOIN CovidCases.covidvaccinations VAC
ON DEA.Location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent is not null
ORDER BY 2,3;

-- Use the CTE
with Popvsvac (continent, location, date, population, new_vaccination,RollingVacinatedpeople) as
(
SELECT DEA.continent,DEA.location, DEA.date, DEA.population, VAC.new_vaccinations,SUM(VAC.new_vaccinations) OVER (partition by DEA.location ORDER BY DEA.location, DEA.date) as RollingVacinatedpeople
FROM CovidCases.coviddeaths DEA
JOIN CovidCases.covidvaccinations VAC
ON DEA.Location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent is not null
)
SELECT *,  (RollingVacinatedpeople/population)*100
FROM  Popvsvac;


-- Creating a temp table
DROP TABLE if exists vacinatedPerecentage;
CREATE TABLE vacinatedPerecentage
(
 continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingVacinatedpeople numeric
)
;

INSERT INTO vacinatedPerecentage
SELECT DEA.continent,DEA.location, DEA.date, DEA.population, VAC.new_vaccinations,SUM(VAC.new_vaccinations) OVER (partition by DEA.location ORDER BY DEA.location, DEA.date) as RollingVacinatedpeople
FROM CovidCases.coviddeaths DEA
JOIN CovidCases.covidvaccinations VAC
ON DEA.Location = VAC.location
AND DEA.date = VAC.date;
-- WHERE DEA.continent is not null
-- ORDER BY 2,3;

SELECT *,  (RollingVacinatedpeople/population)*100
FROM  vacinatedPerecentage;

-- creating views for virtualization
CREATE VIEW RollingVacinatedpeople AS 
SELECT DEA.continent,DEA.location, DEA.date, DEA.population, VAC.new_vaccinations,SUM(VAC.new_vaccinations) OVER (partition by DEA.location ORDER BY DEA.location, DEA.date) as RollingVacinatedpeople
FROM CovidCases.coviddeaths DEA
JOIN CovidCases.covidvaccinations VAC
ON DEA.Location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent is not null;
-- ORDER BY 2,3;

SELECT *
FROM RollingVacinatedpeople;


CREATE VIEW TotalDeathRate AS
SELECT location, MAX(total_deaths) as TotalDeathRate 
FROM CovidCases.coviddeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathRate DESC;

SELECT *
FROM TotalDeathRate
;

-- Queries for tableau project

-- 1. 

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
FROM CovidCases.coviddeaths
WHERE continent is not null 
ORDER BY 1,2;

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location

-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

SELECT location, SUM(new_deaths) as TotalDeathRate 
FROM CovidCases.coviddeaths
WHERE continent IS NULL 
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathRate DESC;


-- 3.

SELECT Location, Population, MAX(total_cases) as HighestInfectionRate,  Max((total_cases/population))*100 as PopulationInfectedpercent
FROM CovidCases.coviddeaths
GROUP BY Location, Population
ORDER BY PopulationInfectedpercent DESC;


-- 4.


SELECT  Location, Population,date, MAX(total_cases) as HighestInfectionRate,  Max((total_cases/population))*100 as PopulationInfectedpercent
FROM  CovidCases.coviddeaths
GROUP BY Location, Population, date
ORDER BY PopulationInfectedpercent DESC;



-- 5.

SELECT DEA.continent,DEA.location, DEA.date, DEA.population, MAX(VAC.total_vaccinations)as RollingVacinatedpeople, ( RollingVacinatedpeople/population)*100
FROM CovidCases.coviddeaths DEA
JOIN CovidCases.covidvaccinations VAC
ON DEA.Location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent is not null
ORDER BY 1, 2, 3;



-- 6.
SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
FROM CovidCases.coviddeaths DEA
WHERE continent is not null 
ORDER BY  1,2;



-- 7.

SELECT  location, SUM(new_deaths) as TotalDeathRate 
FROM CovidCases.coviddeaths 
WHERE  continent IS NULL
AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;


-- 8.

SELECT location, Population, MAX(total_cases) as HighestInfectionRate,  Max((total_cases/population))*100 as PopulationInfectedpercent
FROM  CovidCases.coviddeaths 
GROUP BY Location, Population
ORDER BY PopulationInfectedpercent DESC;


-- took the above query and added population
SELECT location, date, population, total_cases, total_deaths
FROM CovidCases.coviddeaths 
WHERE continent IS NOT NULL
ORDER BY 1,2;


-- 9. 


-- Use the CTE
with Popvsvac (continent, location, date, population, new_vaccination,RollingVacinatedpeople) as
(
SELECT DEA.continent,DEA.location, DEA.date, DEA.population, VAC.new_vaccinations,SUM(VAC.new_vaccinations) OVER (partition by DEA.location ORDER BY DEA.location, DEA.date) as RollingVacinatedpeople, (RollingVacinatedpeople/population)*100
FROM CovidCases.coviddeaths DEA
JOIN CovidCases.covidvaccinations VAC
ON DEA.Location = VAC.location
AND DEA.date = VAC.date
WHERE DEA.continent is not null
)
SELECT *,  (RollingVacinatedpeople/population)*100
FROM  Popvsvac;


-- 10. 

Select location, Population,date, MAX(total_cases) as HighestInfectionRate,  Max((total_cases/population))*100 as PopulationInfectedpercent
FROM CovidCases.coviddeaths
GROUP BY location, Population, date
ORDER BY PopulationInfectedpercent DESC;









