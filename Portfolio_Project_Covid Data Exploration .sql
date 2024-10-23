-- Crossing checking with data 
/* SELECT *
FROM Project_Portfolio..CovidDeaths
WHERE continent IS NOT NULL 
ORDER BY 3,4

SELECT *
FROM Project_Portfolio..CovidVaccinations
*/

-- SELECT THE DATA WE ARE GOING TO BE USING 
SELECT 
location, Date, total_cases, new_cases, total_deaths, population
FROM Project_Portfolio..CovidDeaths
ORDER BY 1,2

-- TOTAL CASES VS TOTAL DEATHS in INDIA

SELECT 
location, Date, total_cases, total_deaths,
(total_deaths/total_cases)*100 AS Deathpercent
FROM Project_Portfolio..CovidDeaths
WHERE location LIKE '%India%'
ORDER BY 1,2

-- SHOWS WHAT PERCENTAGE OF POPULATION GOT COVID in INDIA 
SELECT 
location, Date, total_cases,Population,
(total_cases/population)*100 AS PercentPopulationInfected 
FROM Project_Portfolio..CovidDeaths
WHERE location LIKE '%India%'
ORDER BY 1,2

-- looking at countries with highest infection rate compared to population 

SELECT 
location, population, MAX(total_cases)AS HighestInfectionCount,
MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM Project_Portfolio..CovidDeaths
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC


-- showing Countries with High Death Count per population 
SELECT 
location, MAX(total_deaths) AS TotalDeathCount
FROM Project_Portfolio..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY Location
ORDER BY TotalDeathCount DESC

--LETS break things down by Continent 
SELECT 
location, MAX(total_deaths) AS TotalDeathCount
FROM Project_Portfolio..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY location
ORDER BY TotalDeathCount DESC


-- showing the continent with highest death count 
SELECT 
continent, MAX(total_deaths) AS TotalDeathCount
FROM Project_Portfolio..CovidDeaths
WHERE continent IS NOT NULL 
GROUP BY continent
ORDER BY TotalDeathCount DESC


-- Global numbers 
SELECT 
SUM(new_cases) AS total_cases,
SUM(new_deaths) AS total_deaths,
SUM(new_deaths)/SUM(new_cases)*100 AS Deathpercentage
FROM Project_Portfolio..CovidDeaths
WHERE continent is not null
order by 1,2


-- Looking for Total Population VS Vaccinations

SELECT 
dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated,
FROM Project_Portfolio..CovidDeaths dea
JOIN Project_Portfolio..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not NULL
order by 2,3


-- USE CTE 

WITH PopvsVac (Continent,Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
AS 
(
SELECT 
dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (partition by dea.location order by dea.location, 
dea.date) as RollingPeopleVaccinated
FROM Project_Portfolio..CovidDeaths dea
JOIN Project_Portfolio..CovidVaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not NULL
)
SELECT *, (RollingPeopleVaccinated/population)*100
FROM PopvsVac


-- Creating Views
