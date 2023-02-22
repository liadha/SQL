--Northwind DB

select DATEDIFF(DD,OrderDate,ShippedDate) 
from Orders 
where  DATEDIFF(DD,OrderDate,ShippedDate) >6

select *, DATEDIFF(YY,e.BirthDate,GETDATE()) 
from Employees e 
WHERE DATEDIFF(YY,e.BirthDate,GETDATE()) +3 =63

select *, DATEDIFF(YY,dateadd(yy,3,e.BirthDate),GETDATE()) 
from Employees e 
WHERE DATEDIFF(YY,dateadd(yy,3,e.BirthDate),GETDATE())  >66

--show the last day date of mount
select EOMONTH(e.BirthDate) from Employees e 

--Cast,Convert

select cast(2 as varchar)+'3a' as cast_column


select cast(e.EmployeeID as varchar) + ' MR. '  + e.FirstName + e.LastName  as fullName_column
from Employees e 

select CONCAT(e.EmployeeID ,e.FirstName,e.LastName)  as fullName_column
from Employees e 


--convert date according country 
select convert(varchar , GETDATE(), 108 ) as time

--integer
--CEILING()-> get number and round up
--FLOOR()-> get number and round down
--ROUND()-> get number and 0/1/2 and round :
--0 full number
--1 one digit after .
--2 two digit after .

select p.UnitPrice , CEILING(p.UnitPrice*1.17) as Ceiling
from Products p
select p.UnitPrice , FLOOR(p.UnitPrice*1.17) as floor
from Products p
select p.UnitPrice , ROUND(p.UnitPrice*1.17,0) as [round-0]
from Products p

select p.UnitPrice ,
CEILING(p.UnitPrice*1.17) as Ceiling,
FLOOR(p.UnitPrice*1.17) as floor,
ROUND(p.UnitPrice*1.17,0) as [round-0]
from Products p

--Try_cast
--TRY_CAST(what i eant to cast , as .....)-> try do do casting 
--if not sucsses to cast return null
select TRY_CAST('31/02/2023' as datetime)

select cast('31/02/2023' as datetime)














