SELECT TOP (1000) [iso_code]
      ,[continent]
      ,[location]
      ,[date]
      ,[population]
      ,[total_cases]
      ,[new_cases]
      ,[new_cases_smoothed]
      ,[total_deaths]
      ,[new_deaths]
      ,[new_deaths_smoothed]
      ,[total_cases_per_million]
      ,[new_cases_per_million]
      ,[new_cases_smoothed_per_million]
      ,[total_deaths_per_million]
      ,[new_deaths_per_million]
      ,[new_deaths_smoothed_per_million]
      ,[reproduction_rate]
      ,[icu_patients]
      ,[icu_patients_per_million]
      ,[hosp_patients]
      ,[hosp_patients_per_million]
      ,[weekly_icu_admissions]
      ,[weekly_icu_admissions_per_million]
      ,[weekly_hosp_admissions]
      ,[weekly_hosp_admissions_per_million]
  FROM [portfolioproject&].[dbo].[covid_deaths]
  
  SELECT COUNT(*)  FROM [portfolioproject&].[dbo].[covid_deaths]

 
  select * 
  from [portfolioproject&]..covid_deaths
  order by 1, 2

  select * 
  from [portfolioproject&]..covid_vaccinations
  order by 1, 2

  select location, date, total_cases, total_deaths, cast (total_deaths/total_cases as int)*100 as totaldeathpercentage
  from [portfolioproject&]..covid_deaths
  where location like '%nigeria%'
  order by 1, 2

  select location, date, population, total_cases,  (total_cases/population)*100 as totalcasespercentage 
  from [portfolioproject&]..covid_deaths
  where location like '%nigeria%'
  order by 1, 2

 select location, population, MAX(total_cases) as highestinfectioncount, MAX((total_cases/population))*100 as totalcasespercentage 
  from [portfolioproject&]..covid_deaths
  --where location like '%nigeria%'
  group by location, population
  order by 4 desc

  select location, MAX(cast(total_deaths as int)) as totaldeathcount
  from [portfolioproject&]..covid_deaths
  --where location like '%nigeria%'
  where continent is not null
  group by location
  order by totaldeathcount desc

   select location, MAX(cast(total_deaths as int)) as totaldeathcount
  from [portfolioproject&]..covid_deaths
  --where location like '%nigeria%'
  where continent is null
  group by location
  order by totaldeathcount desc

  
 
 select date, SUM(new_cases), SUM(cast(new_deaths as int))
 from [portfolioproject&]..covid_deaths
 where continent is not null
 group by date
 order by 1, 2

 select *
 from [portfolioproject&]..covid_vaccinations

 select *
 from [portfolioproject&]..covid_deaths dea
 join [portfolioproject&]..covid_vaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date

 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM (cast (vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as peoplevaccinated
 from [portfolioproject&]..covid_deaths dea
 join [portfolioproject&]..covid_vaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2, 3

 with popvsvac (continent, location, date, population, new_vaccinations, peoplevaccinated)
 as
 (
 select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM (cast (vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as peoplevaccinated
 from [portfolioproject&]..covid_deaths dea
 join [portfolioproject&]..covid_vaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 )
 select *, (peoplevaccinated/population)*100
 from popvsvac


 drop table if exists #percentpopulationvaccinated
 create table #percentpopulationvaccinated
 (continent nvarchar(255), location nvarchar(255), date datetime, population numeric, new_vaccinations numeric, peoplevaccinated numeric)

 insert into #percentpopulationvaccinated
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM (cast (vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as peoplevaccinated
 from [portfolioproject&]..covid_deaths dea
 join [portfolioproject&]..covid_vaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null
 order by 2, 3

 select * , (peoplevaccinated/population)*100
 from #percentpopulationvaccinated



 create view percentpopulationvaccinated as
  select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM (cast (vac.new_vaccinations as bigint)) OVER (partition by dea.location order by dea.location, dea.date) as peoplevaccinated
 from [portfolioproject&]..covid_deaths dea
 join [portfolioproject&]..covid_vaccinations vac
 on dea.location = vac.location
 and dea.date = vac.date
 where dea.continent is not null


 select * 
 from percentpopulationvaccinated
 

