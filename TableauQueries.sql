
-- Queries for tableau project

-- 1. 

SELECT SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_deaths)/SUM(New_Cases)*100 as DeathPercentage
FROM CovidCases.coviddeaths
WHERE continent is not null 
ORDER BY 1,2;


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









