/*
A comparison of CTEs vs table subqueries vs temp tables
*/

-- Temp tables

drop table if exists #PatientsByDate

SELECT
    ps.AdmittedDate    
    , COUNT(*) AS NumberOfPatientsEachDay
    , SUM(ps.Tariff) AS TotalTariffEachDay
into #PatientsByDate
FROM PatientStay ps
GROUP BY ps.AdmittedDate;

select *
from #PatientsByDate;

SELECT
    pbd.AdmittedDate
    , pbd.NumberOfPatientsEachDay
    , pbd.TotalTariffEachDay
    , SUM(pbd.TotalTariffEachDay) OVER (ORDER BY pbd.AdmittedDate) AS RunningTariff
    , SUM(pbd.NumberOfPatientsEachDay) OVER (ORDER BY pbd.AdmittedDate) AS CumulativePatients
FROM #PatientsByDate pbd
ORDER BY pbd.AdmittedDate;


-- Table subqueries

select
    pbd.AdmittedDate
    , pbd.NumberOfPatientsEachDay
    , pbd.TotalTariffEachDay
    , SUM(pbd.TotalTariffEachDay) OVER (ORDER BY pbd.AdmittedDate) AS RunningTariff
    , SUM(pbd.NumberOfPatientsEachDay) OVER (ORDER BY pbd.AdmittedDate) AS CumulativePatients
FROM (
    SELECT
        ps.AdmittedDate    
        , COUNT(*) AS NumberOfPatientsEachDay
        , SUM(ps.Tariff) AS TotalTariffEachDay
    FROM PatientStay ps
    GROUP BY ps.AdmittedDate
    ) as pbd

-- CTEs

;
WITH
    cte
    AS
    (
        SELECT
            ps.AdmittedDate    
        , COUNT(*) AS NumberOfPatientsEachDay
        , SUM(ps.Tariff) AS TotalTariffEachDay
        FROM PatientStay ps
        GROUP BY ps.AdmittedDate
    )

SELECT
    cte.AdmittedDate
    , cte.NumberOfPatientsEachDay
    , cte.TotalTariffEachDay
    , SUM(cte.TotalTariffEachDay) OVER (ORDER BY cte.AdmittedDate) AS RunningTariff
    , SUM(cte.NumberOfPatientsEachDay) OVER (ORDER BY cte.AdmittedDate) AS CumulativePatients
FROM cte
ORDER BY cte.AdmittedDate;



-- alternative CTE column syntax - more funtional, makes it clear just from the cte name what columns will be returned, without having to dive into their definitions:

WITH
cte (AdmittedDate, NumberOfPatientsEachDay, TotalTariffEachDay) as (
        SELECT
            ps.AdmittedDate    
        , COUNT(*)          --AS NumberOfPatientsEachDay
        , SUM(ps.Tariff)    --AS TotalTariffEachDay
        FROM PatientStay ps
        GROUP BY ps.AdmittedDate
    )

SELECT
    cte.AdmittedDate
    , cte.NumberOfPatientsEachDay
    , cte.TotalTariffEachDay
    , SUM(cte.TotalTariffEachDay) OVER (ORDER BY cte.AdmittedDate) AS RunningTariff
    , SUM(cte.NumberOfPatientsEachDay) OVER (ORDER BY cte.AdmittedDate) AS CumulativePatients
FROM cte
ORDER BY cte.AdmittedDate;