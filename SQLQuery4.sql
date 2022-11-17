use IBANK
go

------------------------------

use IBANK

select DOT, TXNTYPE, TXNAMT, CHQNO from TMASTER where acid = 101 and DATEDIFF(mm, DOT,GETDATE()) = 1

Update TMASTER
SET DOT = '2022/10/22'
where TNO = 1104


----------------------------------------





select * from AMASTER where acid =720

select * from TMASTER where acid = 102 and Datediff(mm,DOT,getdate()) = 0

select * from TMASTER

Update TMASTER
SET DOT = '2022/11/5'
WHERE TNO = 101

-----------------------------------

alter proc usp_MonthlyBankStatement
(
	@acid int 
)
as
Begin 

declare @CustName varchar(40)
declare @PID Char(2)
declare @CBAL Money
declare @BRID char(3)

declare @DOT datetime
declare @TYPE char(3)
declare @AMT Money 
declare @CHQNO int 


declare @date datetime
set @date = DATEADD(mm,-1,GETDATE())
---print @date   prives month

declare @MonthNm varchar(20)
set @MonthNm = DATENAME(mm,	@date)

declare @LastDate datetime
set @LastDate = EOMONTH(@date)

declare @LastDayNo int
Set @LastDayNo = DATEPART(dd,@LastDate)

declare @YNo int 
Set @YNo = DATEPART(yy,@LastDayNo)

print'-----------------------------------------------------------------------------------------------'
print'												INDIAN BANK'
print'List of the Transation from ' + @MonthNm +' 1st to '+ cast (@LastDayNo as varchar) +' ' +cast(@YNo as varchar)+' report'
print'------------------------------------------------------------------------------------------------'

	---step1 : Get the customer Info
select @CustName = NAME, @PID = PID, @CBAL = CBAL , @BRID = BRID from AMASTER where acid = @acid

--- Step2 : Display /Print 
	print'Product Name :'+@PID
	print'Account No   :'+cast(@acid as varchar)+space(40)+'Branch: '+@BRID
	print'Customer Name:'+@CustName+space(34)+'Cleared Balance   :INR '+cast(@cbal as varchar)
	
	
	print'----------------------------------------------------------------------------------------'
	print'SL.NO		DATE         TXN TYPE        CHEQUE NO            AMOUNT     RUNNINGBALANCE'
	print'-----------------------------------------------------------------------------------------'

	--- step 3 : Get Customer Txn Info
	select DOT, TXNTYPE, TXNAMT, CHQNO, ROW_NUMBER() OVER(Order By DOT ASC) as RNo  into #TxnTmp
	from TMASTER where ACID = @acid and DATEDIFF(mm, DOT,GETDATE()) = 1


	---- Loop
	declare @x int 
	SET @x = 1

	declare @cnt int 

	select @cnt = count(*) from #TxnTmp

	----select * from #TxnTmp where RNo = 1

	WHILE (@x <= @cnt)
	Begin 
---- Read the data from temp
    select @DOT = DOT, @TYPE = TXNTYPE, @AMT = TXNAMT, @CHQNO = isnull(CHQNO,0) from #TxnTmp where RNo = @x

	---- print 
	print cast(@x as varchar) + space(10)+ convert(varchar, @DOT, 107) + Space(10) + @TYPE + Space(10)+cast (@CHQNO as varchar)+space(10)+cast(@AMT as varchar)

	--- Incr
	set @x = @x + 1
  end
   print '---------------------------------------------------------------------------------------------------'
end


---- Call 
exec usp_MonthlyBankStatement 102





-----------------------------
Create table sales
(
	OrderID  int,
	Orderdate datetime,
	SalesAmt Money

)
go
use IBANK
select * from sales

Insert into sales vlaue(101,)


---Current Month 
	select * from Sales1
	where DATEDIFF(DD,OrderDate,GETDATE())=0


-----Last 10 Days sales
	
	select * from AMASTER
	where DATEDIFF(MM,doo,GETDATE())>=10

------First week of Last Month 
	select * from AMASTER
	where DOO = DATEADD(MM,-1,GETDATE())

select * from sys.tables


select * from Sales1
where DOO = Eomonth (DATEADD(mm,-1,getdate()))



use Amazon
go
drop table orders
CREATE TABLE Orders(
   OrderNumber INT,
   OrderDate DATE NOT NULL,
   ShippedDate DATE NOT NULL,
   DeliveryDate  DATE NOT NULL,
   PRIMARY KEY(OrderNumber )
);
go

INSERT INTO 
Orders(OrderNumber , OrderDate , ShippedDate  , DeliveryDate )
VALUES 
(1001, '2019-12-21', '2004-12-22', '2019-12-26'),
(1002, '2020-01-21', '2020-01-21', '2020-01-22'),
(1003, '2022-10-01', '2020-10-03', '2020-10-10'),
(1004, '2022-11-14', '2022-11-15', '2022-11-20');


select * from Orders
where DATEDIFF(MM,OrderDate,GETDATE())=1

----Last 4 month sales
   select * from Orders
   where Datediff(MM,OrderDate,GETDATE())<=4

--- Fist week of last month 
	
   select * from Orders
   where Datediff(MM,OrderDate,GETDATE())= -1 and DATEPART(WW,OrderDate)=1,3

Create table Sales1
(
	OrderID int,
	OrderDate varchar(40) Not Null,
	SalesAmt  Char(40)

)
go

select * from Sales1

insert into Sales1 values(101,'Apr-08-2022',1000);
insert into Sales1 values(102,'Aug-09-2022',2000);
insert into Sales1 values(103,'sep-10-2022',3000);
insert into Sales1 values(104,'Oct-11-2022',4000);
insert into Sales1 values(105,'Nov-14-2022',5000);
insert into Sales1 values(106,'Nov-15-2022',6000);
insert into Sales1 values(107,'Nov-16-2022',7000);



















