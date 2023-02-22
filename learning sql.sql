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

--Case IIF
--CASE
--.
--.
--END
--NULL is the default or use in else

select p.ProductID,p.ProductName,p.UnitPrice
	, case 
	when p.UnitPrice < 20 then 1
	when p.UnitPrice < 50 then 2
	when p.UnitPrice < 100 then 3
	else 4
	END
from Products p

select p.ProductID,p.ProductName,p.UnitPrice
	, case 
	when p.UnitPrice < 20 then format(p.UnitPrice*0.95,'N2')
	when p.UnitPrice < 50 then format(p.UnitPrice*0.90,'N2')
	when p.UnitPrice < 100 then format(p.UnitPrice*0.85,'N2')
	else format(p.UnitPrice*0.80,'N2')
	END as afterDiscount
from Products p
--print only 2 number after . without round the number
select format(10.2345,'N2') as formatint

--IIF(condition,if true,if false)
select p.ProductID,p.ProductName,p.UnitPrice
	,IIF(p.UnitPrice < 20,1,2)
from Products p

select p.ProductID,p.ProductName,p.UnitPrice
	,IIF(p.UnitPrice < 20,format(p.UnitPrice*0.95,'N2')
	,IIF( p.UnitPrice < 50,format(p.UnitPrice*0.90,'N2')
	,IIF( p.UnitPrice < 100,format(p.UnitPrice*0.85,'N2'),format(p.UnitPrice*0.805,'N2'))))
from Products p

--JOIN
--inner join - all the match cells
select c.CustomerID , c.ContactName , o.OrderID from 
Customers as c
join Orders as o on c.CustomerID=o.CustomerID

--return all customers with 2 customers that dont have order
select c.CustomerID , c.ContactName , o.OrderID 
from Customers as c
left join Orders as o on c.CustomerID=o.CustomerID
order by o.OrderID



















