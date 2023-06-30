 lund excyte

--SQL Advance Case Study
select*from DIM_CUSTOMER
select*from DIM_DATE
select*from DIM_LOCATION
select*from DIM_MANUFACTURER
select*from DIM_MODEL
select*from FACT_TRANSACTIONS

--Q1--BEGIN 
select state
from FACT_TRANSACTIONS as x
left join DIM_LOCATION as y
on x.IDLocation=y.IDLocation
left join DIM_MODEL as z
on x.IDModel=z.IDModel
where Date between '2005' and GETDATE()




--Q1--END

--Q2--BEGIN
	select top 1 state
	from DIM_LOCATION as x 
	left join FACT_TRANSACTIONS as y
	on x.IDLocation=y.IDLocation
	left join DIM_MODEL as z 
	on y.IDModel=z.IDModel
	left join DIM_MANUFACTURER as a
	on z.IDManufacturer=a.IDManufacturer
	where Manufacturer_Name ='samsung'
	group by State
	order by SUM (Quantity) desc








--Q2--END

--Q3--BEGIN      
	select Model_Name, ZipCode, State, COUNT(idcustomer) as no_of_tran  
	from DIM_LOCATION as x
	left join FACT_TRANSACTIONS as y 
	on x.IDLocation=y.IDLocation
	left join DIM_MODEL as z on z.IDModel=y.IDModel
	group by Model_Name, ZipCode, State










--Q3--END

--Q4--BEGIN
select top 1
IDModel,Model_Name
from DIM_MODEL
order by Unit_price






--Q4--END

--Q5--BEGIN
select top 2
Manufacturer_Name, model_name, AVG(TotalPrice) as avg_price
from FACT_TRANSACTIONS as x
left join DIM_MODEL as y on x.IDModel=y.IDModel
left join DIM_MANUFACTURER as z on y.IDManufacturer=z.IDManufacturer
 group by Manufacturer_Name, model_name
 order by avg_price desc











--Q5--END

--Q6--BEGIN
select Customer_Name,AVG(TotalPrice) as avg_count
from DIM_CUSTOMER as x
left join FACT_TRANSACTIONS as y 
on x.IDCustomer=y.IDCustomer
where YEAR (date ) = 2009
group by Customer_Name
having AVG(TotalPrice)>500











--Q6--END
	
--Q7--BEGIN  
SELECT * FROM (
SELECT * FROM (
SELECT TOP 5 MODEL_NAME FROM DIM_MODEL
LEFT JOIN (
SELECT  IDModel , SUM(QUANTITY) AS SUMQTY  FROM DIM_DATE
LEFT JOIN FACT_TRANSACTIONS
ON DIM_DATE.DATE=FACT_TRANSACTIONS.Date
WHERE YEAR = 2008
GROUP BY IDModel) AS P
ON DIM_MODEL.IDModel=P.IDModel
ORDER BY SUMQTY DESC

INTERSECT

SELECT TOP 5 MODEL_NAME FROM DIM_MODEL
LEFT JOIN (
SELECT  IDModel , SUM(QUANTITY) AS SUMQTY  FROM DIM_DATE
LEFT JOIN FACT_TRANSACTIONS
ON DIM_DATE.DATE=FACT_TRANSACTIONS.Date
WHERE YEAR = 2009
GROUP BY IDModel) AS P
ON DIM_MODEL.IDModel=P.IDModel
ORDER BY SUMQTY DESC ) AS Y


INTERSECT 
SELECT TOP 5 MODEL_NAME FROM DIM_MODEL
LEFT JOIN (
SELECT  IDModel , SUM(QUANTITY) AS SUMQTY  FROM DIM_DATE
LEFT JOIN FACT_TRANSACTIONS
ON DIM_DATE.DATE=FACT_TRANSACTIONS.Date
WHERE YEAR = 2010
GROUP BY IDModel) AS P
ON DIM_MODEL.IDModel=P.IDModel
ORDER BY SUMQTY DESC ) AS K




--Q7--END	
--Q8--BEGIN
SELECT '2009' AS YEARS, Manufacturer_Name FROM (
SELECT (DENSE_RANK() OVER ( ORDER BY SUMQTY DESC)) AS RANKS ,Manufacturer_Name 
FROM 
(SELECT Manufacturer_Name, SUM(TotalPrice) AS SUMQTY FROM (
SELECT   Model_Name , Manufacturer_Name , IDModel FROM DIM_MODEL
LEFT JOIN DIM_MANUFACTURER
ON DIM_MODEL.IDManufacturer=DIM_MANUFACTURER.IDManufacturer) AS U
LEFT JOIN FACT_TRANSACTIONS
ON U.IDModel =FACT_TRANSACTIONS.IDModel
WHERE Date > '2008-12-31' AND DATE < '2010-01-01'
GROUP BY Manufacturer_Name) AS Y) AS D
WHERE RANKS =2

UNION 
 
SELECT '2010' AS YEARS, Manufacturer_Name FROM (
SELECT (DENSE_RANK() OVER ( ORDER BY SUMQTY DESC)) AS RANKS ,Manufacturer_Name 
FROM 
(SELECT Manufacturer_Name, SUM(TotalPrice) AS SUMQTY FROM (
SELECT   Model_Name , Manufacturer_Name , IDModel FROM DIM_MODEL
LEFT JOIN DIM_MANUFACTURER
ON DIM_MODEL.IDManufacturer=DIM_MANUFACTURER.IDManufacturer) AS U
LEFT JOIN FACT_TRANSACTIONS
ON U.IDModel =FACT_TRANSACTIONS.IDModel
WHERE Date > '2009-12-31' AND DATE < '2011-01-01'
GROUP BY Manufacturer_Name) AS Y) AS D
WHERE RANKS =2


--Q8--END
--Q9--BEGIN
select Manufacturer_Name
from DIM_MANUFACTURER as x
left join DIM_MODEL as y on x.IDManufacturer= y.IDManufacturer
left join FACT_TRANSACTIONS as z on y.IDModel=z.IDModel 
where YEAR (date) = 2010

except

select Manufacturer_Name
from DIM_MANUFACTURER as x
left join DIM_MODEL as y on x.IDManufacturer= y.IDManufacturer
left join FACT_TRANSACTIONS as z on y.IDModel=z.IDModel 
where YEAR (date) = 2009















--Q9--END

--Q10--BEGIN

SELECT IDCUSTOMER ,YEARS , AVG_QTY , AVG_SPEDD , (( AVG_SPEDD - PREV)/PREV *100) AS PERCENTCHANGE
FROM 
      (
SELECT IDCustomer, YEARS,AVG_QTY , AVG_SPEDD ,
LAG(AVG_SPEDD,1) OVER(PARTITION BY IDCUSTOMER  ORDER BY IDCUSTOMER ASC , YEARS ASC) AS PREV
FROM 
(SELECT X.IDCustomer, AVG_SPEDD,AVG_QTY, YEARS FROM
       
	     ( SELECT TOP 10 IDCustomer, AVG(TotalPrice) AS AVG_SPEND FROM FACT_TRANSACTIONS
	      GROUP BY IDCustomer
	      ORDER BY AVG_SPEND DESC) AS X
          
	LEFT JOIN

	(SELECT IDCustomer , YEAR(DATE) AS YEARS  , AVG(TotalPrice) AS AVG_SPEDD , AVG(QUANTITY) AS AVG_QTY
	FROM FACT_TRANSACTIONS
	GROUP BY IDCustomer, YEAR(DATE)) 
AS Y
ON X.IDCustomer=Y.IDCustomer) AS F) AS C











--Q10--END
	