--window function
--over()-ברמת הטבלה מחזיר חישוב כללי
--over  אין צורך בגרופ

select p.CategoryID,p.ProductName,p.UnitPrice,
avg(p.UnitPrice) over() as avg,
sum(p.UnitPrice) over() as sum,
count(p.UnitPrice) over() as count
from Products p
--group by p.CategoryID


select p.CategoryID,p.ProductName,p.UnitPrice,
avg(p.UnitPrice) over() as avg,
avg(p.UnitPrice) over() - p.UnitPrice as diff
from Products p

select p.CategoryID,p.ProductName,p.UnitPrice,
avg(p.UnitPrice) over() as avg,
((avg(p.UnitPrice) over() - p.UnitPrice)/avg(p.UnitPrice) over())*100 as pct
from Products p

select p.CategoryID,p.ProductName,p.UnitPrice,
avg(p.UnitPrice) over() as avg,
concat(((avg(p.UnitPrice) over() - p.UnitPrice)/avg(p.UnitPrice) over())*100 ,'%')as pct
from Products p

--over(partition by  _____col name____)
--אין צורך בגרופ
--עושה חישוב כללי לשדה מבוקש

select od.OrderID,od.ProductID,sum(od.UnitPrice*od.Quantity*(1-od.Discount))over(partition by  od.OrderID),
sum(od.UnitPrice*od.Quantity*(1-od.Discount)) over() as sum
from [Order Details] od

select  p.CategoryID,p.ProductName,p.UnitPrice,
avg(p.UnitPrice) over(partition by p.CategoryID) as avgByCategory,
avg(p.UnitPrice) over() as avgAll,
sum(p.UnitPrice)over(partition by p.CategoryID) as sumByCategory,
sum(p.UnitPrice)over() as sumAll
from Products p

select * from
(select p.CategoryID,p.UnitPrice,avg(p.UnitPrice)over(partition by p.CategoryID) as avgbycat
from Products p) p 
where p.UnitPrice>p.avgbycat

--over(order by  _____col name____)
--order by
--סוכם את עצמו ואת כל השדות לפניו
--אם יש כפילויות סוכם אותן בסוף

select p.CategoryID,p.ProductID,p.UnitPrice,
sum(p.UnitPrice)over(order by p.UnitPrice) as avgbycat
from Products p
where  p.CategoryID in (1)

select year(o.OrderDate),month(o.OrderDate),o.OrderID,
sum(od.UnitPrice*od.Quantity*(1-od.Discount))over(partition by month(o.OrderDate))as sumPerM,
sum(od.UnitPrice*od.Quantity*(1-od.Discount))over(order by month(o.OrderDate))as sumallM,
sum(od.UnitPrice*od.Quantity*(1-od.Discount))over(partition by year(o.OrderDate))as sum
from Orders o
join [Order Details] od on od.OrderID=o.OrderID
where year(o.OrderDate)=1996

--rows between unbounded preceding and current row
--מחשב כל שורה גם אם יש כפולים
select p.CategoryID,p.ProductID,p.UnitPrice,
sum(p.UnitPrice)over(order by p.UnitPrice rows between unbounded preceding and current row) as avgbycat
from Products p
where  p.CategoryID in (1)

select p.CategoryID ,p.ProductID, p.UnitPrice
,sum(p.UnitPrice) over(order by  p.unitprice) as sumwithnocalc
, sum(p.UnitPrice) over( partition by CategoryID order by  p.unitprice
rows between unbounded preceding and current row)
as sumunitprice
from Products p
where CategoryID in (1,7)

--row number
select p.CategoryID ,p.ProductID, p.UnitPrice,
ROW_NUMBER()over(partition by CategoryID order by UnitPrice ) as rownumber
from Products p
where CategoryID in (1,7)

select p.CategoryID ,p.ProductID, p.UnitPrice,
ROW_NUMBER()over(order by UnitPrice ) as rownumber
from Products p
where CategoryID in (1,7)


select * from (
select p.CategoryID ,p.ProductID, p.UnitPrice,
ROW_NUMBER()over(partition by CategoryID order by UnitPrice desc) as rownumber
from Products p
where CategoryID in (1,7)
)p
where p.rownumber=1

select  p.CategoryID , max(p.UnitPrice)
from Products p
where CategoryID in (1,7)
group by  p.CategoryID 

select p.CategoryID ,p.ProductID, p.UnitPrice, max(p.UnitPrice)
from Products p
where  p.UnitPrice=any(select  max(p.UnitPrice)
from Products p where CategoryID in (1,7) group by  p.CategoryID )
group by  p.CategoryID ,p.ProductID, p.UnitPrice



--rank
--דירוג בתוך קבוצה 
select p.ProductID,p.CategoryID,p.UnitPrice,
RANK()over(partition by  p.CategoryID order by p.UnitPrice )as rank
from Products p
where p.CategoryID=1

select p.ProductID,p.CategoryID,p.UnitPrice,
dense_RANK()over(partition by  p.CategoryID order by p.UnitPrice )as rank
from Products p
where p.CategoryID=1


select p.ProductID,p.CategoryID,p.UnitPrice,
RANK()over(partition by  p.CategoryID order by p.UnitPrice )as rank,
dense_RANK()over(partition by  p.CategoryID order by p.UnitPrice )as dense,
row_number()over(partition by  p.CategoryID order by p.UnitPrice )as rownum
from Products p
where p.CategoryID=1


----------------------------------------------------

select SH.SalesPersonID,SH.OrderDate,SH.TotalDue,
ROW_NUMBER()over(partition by SalesPersonID order by TotalDue desc) rownum
from Sales.SalesOrderHeader SH
where SalesPersonID is not null

select * from (select SH.SalesPersonID,SH.OrderDate,SH.TotalDue,
ROW_NUMBER()over(partition by SalesPersonID order by TotalDue desc) rownum
from Sales.SalesOrderHeader SH
where SalesPersonID is not null)s
where s.rownum=1
order by s.TotalDue





select  ROW_NUMBER()over(order by SH.SalesOrderID) as rownumber,
SH.SalesOrderID , SH.RevisionNumber ,SH.OrderDate , SH.DueDate , SH.ShipDate
from  Sales.SalesOrderHeader SH
where ROW_NUMBER()over(order by SH.SalesOrderID)  between 60 and 80

select *
from (select *,ROW_NUMBER()over(order by SalesOrderID) rownum
from Sales.SalesOrderHeader) as t
where t.rownum between 60 and 80


select *
from (select CustomerID, 
	   SalesOrderID, 
	   OrderDate,
	   ROW_NUMBER()over(partition by CustomerID order by OrderDate desc) rownum
from Sales.SalesOrderHeader) as t
where t.rownum in (1)


select pp.BusinessEntityID,concat(pp.FirstName,' ',pp.LastName) as employeeName,
format(sp.SalesLastYear,'N'),
rank()over(order by sp.SalesLastYear desc) as RK
from Sales.SalesPerson sp
join Person.Person pp on pp.BusinessEntityID=sp.BusinessEntityID
where sp.SalesLastYear >0



select * from(
select so.CustomerID ,concat(pp.FirstName,' ',pp.LastName) as employeeName,
count(*)as num,
dense_rank()over(order by count(so.CustomerID)desc) as RK
from Sales.SalesOrderHeader so
join Sales.Customer sc on sc.CustomerID=so.CustomerID
join Person.Person pp on pp.BusinessEntityID=sc.PersonID
group by  so.CustomerID ,concat(pp.FirstName,' ',pp.LastName)
)rk
where rk<=5
