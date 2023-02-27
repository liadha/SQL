--CTE - Common Table Expression
--הכרה בשם עמודה ושימוש בה ללא תת שאילתה

/*select p.ProductID,p.ProductName,p.UnitPrice,
cast(ROUND(p.UnitPrice*1.17,2)as float)as Total
from Products p
where Total>30*/

--S.Q in from
use Northwind
select * from(
select p.ProductID,p.ProductName,p.UnitPrice,
cast(ROUND(p.UnitPrice*1.17,2)as float)as Total
from Products p)Total
where Total.Total>30

--with CTE
--with ____new_name___
--as(query)
--select * from  ____new_name___
--where __col_name__ ><<>=...

with CTE_Prodact
as
(select p.ProductID,p.ProductName,p.UnitPrice,p.CategoryID,
cast(ROUND(p.UnitPrice*1.17,2)as float)as Total
from Products p)
select ct.*,c.CategoryName from CTE_Prodact ct
join Categories c on c.CategoryID=ct.CategoryID
where Total>30

--Complex CTE 
--יצירת 2 טבלאות זמניות ולאחד אותן וכו

With cte1as (select e.Country  as country from Employees e), cte2As(select o.ShipCountry as country from Orders o)select country from cte1where country in('USA' , 'UK')unionselect country from cte2where country in('USA' , 'UK')

with cte1(name)
as
(select 'ori')
,cte2(name)
as
(select 'Elad')
select * from cte1
union 
select * from cte2




use AdventureWorks2019
WITH cteT
AS
(
select Category ,
AVG(DiscountPct)as avgD
,rank()over(order by AVG(DiscountPct) desc) as "RK"
from Sales.SpecialOffer
group by Category
)
select avgD as maxD
from cteT
where RK=1

WITH cte1
AS
(
select  st.Name as Territory,
year(so.OrderDate) as "year",
count(so.SalesOrderID) as "NumOfOrder",
sum(so.TotalDue) as "Sales"
from Sales.SalesTerritory st
join Sales.SalesOrderHeader so on so.TerritoryID=st.TerritoryID
where year(so.OrderDate)=2013
group by st.Name,year(so.OrderDate)
),cte2
as
(select  st.Name  as Territory,
year(so.OrderDate) as "year",
count(so.SalesOrderID) as NumOfOrder,
sum(so.TotalDue) as "Sales"
from Sales.SalesTerritory st
join Sales.SalesOrderHeader so on so.TerritoryID=st.TerritoryID
where year(so.OrderDate)=2014
group by st.Name,year(so.OrderDate))
select ct1.Territory,ct1.year,format(ct1.NumOfOrder,'N') as NumOfOrder,concat('$',format(ct1.Sales,'N')) as "Sales",
ct2.year,format(ct2.NumOfOrder,'N') as NumOfOrder,concat('$',format(ct2.Sales,'N')) as "Sales",
format(((ct2.NumOfOrder)-(ct1.NumOfOrder)),'N') diffYear ,
format(((ct2.Sales)-(ct1.Sales)) ,'N')diffSales 
from cte1 ct1
join cte2 ct2 on ct1.Territory=ct2.Territory

--DDL - Data Definition Language
-- CREATE , ALTER , DROP


--DB - use in ram and contain 2 files : MDF,LDF
--LDF write to log file
--Mdf contain all data 
-- Create new Database
use master 
create database new_db
-- delete the Database
drop database new_db

use new_db
-- Create new Table
create table tbl
(id int)
-- ADD column
alter table tbl
add lname varchar(20)
-- Delete column
alter table tbl drop column lname
-- Insert values into column
insert into tbl values(1),(null)

-- Constraints
--תנאים על שדות

-- NOT NULL
drop table tbl

create table tbl
(id int not null)

insert into tbl values(1),(null)

-- Primary key 
drop table tbl

create table tbl
(id int Primary key,
lname varchar(20))

insert into tbl values (null,'a')

-- Change Name to constraint 
drop table tbl

create table tbl
(id int constraint tbl_id_pk Primary key,
lname varchar(20))

insert into tbl values (1,'a')
insert into tbl values (1,'a')

--Check constraint

drop table tbl

create table tbl
(id int constraint tbl_id_pk Primary key,
lname varchar(20) constraint tbl_lname_ck check(len(lname)>=2))

insert into tbl values (1,'a')
insert into tbl values (1,'ab')

select * from tbl

-- Table constraint level

drop table tbl

create table tbl
(id int constraint tbl_id_pk Primary key,
lname varchar(20) not null,
constraint tbl_lname_ck check(len(lname)>=2))

insert into tbl values (1,'a')
insert into tbl values (1,null)

-- UNIQUE
-- אין כפילויות כלומר אין אותו שם משפחה ל 2 עובדים

drop table tbl

create table tbl
(id int constraint tbl_id_pk Primary key,
lname varchar(20) not null,
constraint tbl_lname_ck check(len(lname)>=2),
constraint tbl_lname_UQ UNIQUE(lname)
)
--Faield (lname short)
insert into tbl values (1,'a')
--Faield (lname null)
insert into tbl values (1,null)
--Pass
insert into tbl values (1,'ab')
--Faield (lname exsist)
insert into tbl values (2,'ab')

select * from tbl

drop table tbl

create table tbl
(id int constraint tbl_id_pk Primary key,
lname varchar(20) not null,
email varchar(40) not null,
constraint tbl_lname_ck check(len(lname)>=2),
constraint tbl_lname_UQ UNIQUE(lname),
constraint tbl_email_ck check(email like '%@%.%')
)
--Faield (missing . in email )
insert into tbl values (1,'aa','elad@com')
--Pass
insert into tbl values (1,'aa','elad@gmail.com')

-- Constraint Foreign key

create table emp
(
empId int constraint emp_empId_pk Primary key,
tblId int not null,
constraint emp_tblId_FK foreign key(tblId) references tbl(id)
)
-- Faield (id=3 not exsist in tbl)
insert into emp values(1,3)
-- Pass 
insert into emp values(1,1)

select * from tbl
select * from emp

drop table emp
drop table tbl

-- 2 Primary key

create table tbl
(id int constraint tbl_id_pk not null,
lname varchar(20) not null,
email varchar(40) not null,
constraint tbl_lname_ck check(len(lname)>=2),
constraint tbl_lname_UQ UNIQUE(lname),
constraint tbl_email_ck check(email like '%@%.%'),
constraint tbl_PK  Primary key(id,lname)
)

insert into tbl values(1,'aa','ee@gmail.com'),(1,'bb','ee@gmail.com')
select * from tbl

-- Copy table
-- not copy the constraint just the struct of table and data

select * into temp_products
from Northwind.dbo.Products

-- DML - Data Manipolation Languge
-- INSERT , UPDATE , DELETE TRUNCATE
-- TRUNCATE only data DONT write to log
-- DELETE only data and write to log
-- DROP table structure and data
drop table employ

create table employ
(
employId int identity(1,1) ,
firstName  varchar(20) not null,
lastName  varchar(20) not null,
email varchar(50) not null,
birthday date ,
hiredate datetime DEFAULT getdate(),
departmentID int  not null,
constraint emp_empId_pk Primary key(employId),
constraint emp_fname_ck check(len(firstName)>=2),
constraint emp_lname_ck check(len(lastName)>=2),
constraint emp_email_ck check(email like '%@%.%'),
constraint emp_email_UQ UNIQUE(email),
constraint emp_departmentID_FK foreign key(departmentID) references department(Id)
)
create table department
(
Id int constraint department_Id_pk Primary key,
deptName varchar(20) not null
)

insert into department values (1,'HR'),(2,'IT'),(3,'QA'),(4,'DEV')

insert into employ (firstName,lastName,email,birthday,departmentID)values('liad','ohana','liad@gmail.com','1996-04-11',4)
insert into employ (firstName,lastName,email,birthday,departmentID)values('osher','ohana','osher@walla.com','1996-05-11',3)
insert into employ (firstName,lastName,email,birthday,departmentID)values('moti','herz','mo@.com','1991-04-11',2)
insert into employ (firstName,lastName,email,birthday,departmentID)values('avi','avi','a@.com','1992-04-11',1)
insert into employ (firstName,lastName,email,birthday,departmentID)values('lior','ab','ab@gmail.com','1994-04-11',4)
insert into employ (firstName,lastName,email,birthday,departmentID)values('hen','ncjsd','ncjsd@gmail.com','1994-04-11',2)
insert into employ (firstName,lastName,email,birthday,departmentID)values('rom','r','r@gmail.com','1995-04-11',1)
insert into employ (firstName,lastName,email,birthday,departmentID)values('plony','almoni','pp@walla.com','1990-04-11',3)

select * from employ

insert into department values (5,'DEVOPS')

UPDATE employ
SET departmentID =5
WHERE departmentID = 2

delete  from  department 
where Id=2

select * from department

