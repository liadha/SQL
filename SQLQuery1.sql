--window function
--over()-���� ����� ����� ����� ����
--over  ��� ���� �����

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
--��� ���� �����
--���� ����� ���� ���� �����

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
--���� �� ���� ��� �� ����� �����
--�� �� �������� ���� ���� ����

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
--���� �� ���� �� �� �� ������
select p.CategoryID,p.ProductID,p.UnitPrice,
sum(p.UnitPrice)over(order by p.UnitPrice rows between unbounded preceding and current row) as avgbycat
from Products p
where  p.CategoryID in (1)

select p.CategoryID ,p.ProductID, p.UnitPrice