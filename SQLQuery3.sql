-- Views
-- שמירת שאילתות שחוזרות על עצמן
-- שומר את הדתר בזיכרון קאש ושולף משם ולכן יותר יעיל ומהיר
create VIEW v_Customers_Orders
as
select o.OrderID,o.ProductID,p.ProductName ,p.UnitPrice,c.CompanyName
from [Order Details] o
left join Orders on Orders.OrderID=o.OrderID
left join Customers c on c.CustomerID=Orders.CustomerID
left join Products p on p.ProductID=o.ProductID

select * from v_Customers_Orders

create VIEW v_AllCustomers_Orders
as
select od.OrderID,od.ProductID,p.ProductName ,p.UnitPrice,c.CompanyName
from Customers c
left join Orders o on o.CustomerID=c.CustomerID
left join [Order Details] od on od.OrderID=o.OrderID
left join Products p on p.ProductID=od.ProductID

select * from v_AllCustomers_Orders

-- Change view

alter VIEW v_AllCustomers_Orders
as
select od.OrderID,od.ProductID,p.ProductName ,p.UnitPrice,c.CompanyName,o.EmployeeID
from Customers c
left join Orders o on o.CustomerID=c.CustomerID
left join [Order Details] od on od.OrderID=o.OrderID
left join Products p on p.ProductID=od.ProductID
where c.Country in ('UK','USA')

select * from v_AllCustomers_Orders

select v.* ,concat(e.LastName,' ', e.FirstName)
from v_AllCustomers_Orders v
join Employees e on e.EmployeeID=v.EmployeeID

-- Simple view
--מחזיר נתונים מטבלה אחת
--ניתן לשנות דרגו נתונים בטבלה המקורית
--ניתן למחוק נתונים

create VIEW v_Products_cat1
as
select * from Products 
where CategoryID=1


select *
from v_Products_cat1

update v_Products_cat1
set UnitsOnOrder = 1
where UnitsOnOrder=0

select *
from v_Products_cat1

select * from Products 
where CategoryID=1

--טרנזקציה היא סט פקודות במידה ואחד נכשל כולם נכשלים במידה ולא כולן מבוצעות יחד

begin tran
update v_Products_cat1
set UnitsOnOrder = 0
where UnitsOnOrder=1

select *
from v_Products_cat1

commit

select *
from v_Products_cat1

/*try:
set UnitsOnOrder = 0
where UnitsOnOrder=1
commit
catch:
rollback*/

-- Complex view

select * from v_AllCustomers_Orders

begin tran
update v_AllCustomers_Orders 
set UnitPrice=5.0
where ProductID in(24,25,26)

select * from v_AllCustomers_Orders
where ProductID in(24,25,26)

--לא ניתן לשנות נתונים שנעשו עליהם חישובים

create view v_cat_unitprice
as
select p.CategoryID, avg(p.UnitPrice) avg_unitprice
from Products p 
group by p.CategoryID

begin tran
update v_cat_unitprice
set avg_unitprice =50
commit


-- T SQL 
-- החלק התכנותי של SQL

--הגדרת משתנה
declare @var varchar(20)
--הכנסת ערך למשתנה
set @var=20
--הדפסת משתנה
print @var
--הצגת משתנה בעמודה 
select @var

declare
@a int,@b int,@c int

set @a=4
set @b=6
set @c=@a+@b
print @c
print (concat(@a , '+',@b , '=', @c))

declare
@BD date = '11/4/96'
print year(getdate())-year(@BD)

declare
@avg_unitprice money
set @avg_unitprice=(select avg(UnitPrice) from Products)
print @avg_unitprice

select * from Products
where UnitPrice>@avg_unitprice
--הדרך הנכונה יותר
go
declare
@avg_unitprice money
select @avg_unitprice= avg(UnitPrice) from Products

select * from Products
where UnitPrice>@avg_unitprice

declare
@fname varchar(20),
@lname varchar(20),
@BD date,
@empID int =1

select @fname=e.firstName,@lname=e.LastName,@BD=e.BirthDate
from Employees e
where e.EmployeeID=@empID

print concat(@fname,' ',@lname,' was born on : ',@BD)

-- procedure

create procedure test
@prodID int as
select * from Products p
where p.ProductID=@prodID

exec test 1

create procedure my_proc
as
declare @catid int =1
select * from Products p
where p.CategoryID = @catid

exec my_proc 

alter procedure my_proc
@catid int
as
select * from Products p
where p.CategoryID = @catid

exec my_proc 1
exec my_proc 2



create procedure my_print
@empID int
as
declare
@fname varchar(20),
@lname varchar(20),
@BD date
select @fname=e.firstName,@lname=e.LastName,@BD=e.BirthDate
from Employees e
where e.EmployeeID=@empID
select concat(@fname,' ',@lname,' was born on : ',@BD)


exec my_print 1

create procedure get_discount
@prodID int
as
declare
	@unitprice money
	select @unitprice=p.UnitPrice from Products p
	where p.ProductID=@prodID

if @unitprice < 20 
	set @unitprice= @unitprice*0.90
else if @unitprice<50 
	set @unitprice= @unitprice*0.85
else
	set @unitprice= @unitprice*0.80
select @unitprice as "afterdiscount"


exec get_discount 1

select * from sys.messages
where message_id = 208

create table Log
(
DateError datetime,
error_number int,
error_severity int,
error_message varchar(250)
)

select * into temp_category 
from Categories


select * from temp_category c
		where c.CategoryID=1


create procedure del_category
	@categoryID int
as
	begin try
		begin tran 
		delete from temp_category 
		where CategoryID= @categoryID
		commit
	end try
	begin catch
		rollback
		insert into Log values(GETDATE(),ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_MESSAGE())
	end catch

exec del_category 1

select * from Log

select * into temp_Products
from Products

alter procedure abc
@prodID int
as
declare @CategoryID int,
@ErrorMessage varchar(20),
@ErrorSeverity varchar(20),
@ErrorState varchar(20)
	begin try
		begin tran 
		select @CategoryID=CategoryID from Products
		where Products.ProductID=@prodID

		insert into A values(@CategoryID)
		if @@ROWCOUNT = 0 
			   set @ErrorMessage='@@ROWCOUNT = 0'
			   set @ErrorSeverity=16
			   set @ErrorState=1
			   RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState)

		delete from temp_Products 
		where ProductID= @prodID

		commit

	end try
	begin catch
		rollback
		insert into Log values(GETDATE(),ERROR_NUMBER(),ERROR_SEVERITY(),ERROR_MESSAGE())
	end catch

exec abc 5

select *  from temp_Products
where ProductID=5

select * from A

-- Switch case 

create procedure get_discount2
@prodID int
as
declare
	@unitprice money,
	@discount float
	select @unitprice=p.UnitPrice from Products p
	where p.ProductID=@prodID
	set @discount = case when @unitprice<20 then 0.9
						 when @unitprice<50 then 0.85
						 else 0.8
					end
	select @unitprice*@discount as afterdiscount




exec get_discount2 1
