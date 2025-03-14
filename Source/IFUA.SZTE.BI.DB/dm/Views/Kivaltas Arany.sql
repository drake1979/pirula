CREATE view  [dm].[Kivaltas Arany] AS 

WITH CTE_Transactions AS

(
	SELECT pt.Kulcs, COUNT(pt.Kulcs) AS darab
		,SUM(pt.Mennyiség) AS menny
	FROM dm.[Pharmacy Transactions] pt
	GROUP BY pt.Kulcs
),

CTE_Prescriptions AS
(
	SELECT CASE WHEN CAST(PrescriptionID AS nvarchar) IS NOT NULL THEN CAST(PrescriptionID AS nvarchar)
		ELSE CAST(CONCAT(LEFT(PrescriptionDate, 6), DoctorID, sol.ProductTTTID) AS nvarchar) END AS [Kulcs]
		--ELSE CAST(CONCAT(LEFT(PrescriptionDate, 6), DoctorID, sol.ProductTTTID) as decimal(32,0)) END AS [Kulcs]
	,COUNT(CASE WHEN CAST(PrescriptionID AS nvarchar) IS NOT NULL THEN CAST(PrescriptionID AS nvarchar)
		ELSE CAST(CONCAT(LEFT(PrescriptionDate, 6), DoctorID, sol.ProductTTTID) AS nvarchar) END) AS darab
		--ELSE CAST(CONCAT(LEFT(PrescriptionDate, 6), DoctorID, sol.ProductTTTID) as decimal(32,0)) END) AS darab
	,SUM(cp.Quantity) AS menny
	FROM dm.[FactClinicPrescriptions] cp
		LEFT JOIN [dm].[DimDoctor] d on cp.DoctorKey = d.DoctorKey
		LEFT JOIN dm.DimProductMedsol sol ON cp.PharmacyProductKey = sol.ProductMedsolKey
	GROUP BY CASE WHEN CAST(PrescriptionID AS nvarchar) IS NOT NULL THEN CAST(PrescriptionID AS nvarchar)
		ELSE CAST(CONCAT(LEFT(PrescriptionDate, 6), DoctorID, sol.ProductTTTID) AS nvarchar) END
		--ELSE CAST(CONCAT(LEFT(PrescriptionDate, 6), DoctorID, sol.ProductTTTID) as decimal(32,0)) END
),

Agg_ClinicPresction_CTE AS
(	
	SELECT CAST(cp.PrescriptionID AS nvarchar) as [eRecept / eVény azonosító]
		,sol.ProductTTTID as [Patikai cikk kulcs]
		,DOC.[DoctorID] [Orvosi pecsétszám]
		,LEFT(CP.[PrescriptionDate], 6) AS [Év hónapja]
		,CASE WHEN pck.darab is not null then pck.darab else 0 end as [db_kiv]
		,CASE WHEN cck.darab is not null then cck.darab else 0 end as [db_felirt]
		,pck.menny as [menny_kiv]
		,cck.menny as [menny_felirt]
		,CASE WHEN CAST(cp.PrescriptionID AS nvarchar) IS NOT NULL THEN CAST(cp.PrescriptionID AS nvarchar)
		ELSE CAST(CONCAT(LEFT(cp.PrescriptionDate, 6), doc.DoctorID, sol.ProductTTTID) AS nvarchar) END AS Kulcs
	FROM dm.FactClinicPrescriptions cp
		LEFT JOIN [dm].[DimDoctor] doc on cp.DoctorKey = doc.DoctorKey
		INNER JOIN dm.DimProductMedsol sol ON cp.PharmacyProductKey = sol.ProductMedsolKey
		LEFT JOIN CTE_Transactions pck on CASE WHEN CAST(cp.PrescriptionID AS nvarchar) IS NOT NULL THEN CAST(cp.PrescriptionID AS nvarchar)
		ELSE CAST(CONCAT(LEFT(cp.PrescriptionDate, 6), doc.DoctorID, sol.ProductTTTID) AS nvarchar) END = pck.Kulcs
		LEFT JOIN CTE_Prescriptions cck on CASE WHEN CAST(cp.PrescriptionID AS nvarchar) IS NOT NULL THEN CAST(cp.PrescriptionID AS nvarchar)
		ELSE CAST(CONCAT(LEFT(cp.PrescriptionDate, 6), doc.DoctorID, sol.ProductTTTID) AS nvarchar) END = cck.Kulcs
		INNER JOIN dm.Dátum as D on CP.[PrescriptionDate] = D.[Dátum kulcs]
)

SELECT CAST(CASE WHEN Kulcs = [eRecept / eVény azonosító] then [eRecept / eVény azonosító]
		ELSE CONCAT(t.[Év hónapja], t.[Orvosi pecsétszám], t.[Patikai cikk kulcs]) END AS varchar) AS [Kulcs]
	,t.db_kiv as no_kivaltas
	,t.db_felirt as no_feliras
	,t.menny_kiv as sum_kivaltas
	,t.menny_felirt as sum_feliras
	,CASE WHEN CONVERT(decimal(32,10), t.menny_kiv) / CONVERT(decimal(32,10), t.menny_felirt) > 1
		THEN 1
		ELSE CONVERT(decimal(32,10), t.menny_kiv) / CONVERT(decimal(32,10), t.menny_felirt) END AS kivaltas_arany
	,CONVERT(decimal(32,10), t.db_kiv) / CONVERT(decimal(32,10), t.db_felirt) as kivaltas_arany_regi
FROM Agg_ClinicPresction_CTE AS t
GROUP BY 
	CASE WHEN Kulcs = [eRecept / eVény azonosító] THEN [eRecept / eVény azonosító] ELSE
		CONCAT(t.[Év hónapja], t.[Orvosi pecsétszám], t.[Patikai cikk kulcs]) END
	,t.menny_kiv
	,t.menny_felirt
	,t.db_kiv
	,t.db_felirt

