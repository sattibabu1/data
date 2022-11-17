use IBANK
go
Go

/******Object : Stored Procedere [dbo].[usp_CostomerMonthlyBankStatement]
SET ANSI_NULLS ON
GO
SET QUOTED _INDENTFIER ON 
GO

/****************************************************************
SP NAME : CoustomerMonthlyBankStatement
DB		: IBank
Author	: Sattibabu
Date	: Oct 11 2022
Purpose	: It given MonthlyBank statement 

History 

-----------------------------------------------------------------------
SL.NO			Dese				Done By		When
-----------------------------------------------------------------------
1.		New SP				Sattibabu			Oct 11 , 2022
**********************************************************************/),/

alter proc usp_CustMonthlyBankStatement
(
	@acid int 
)
as
begin 
	declare @custName varchar(40)
	declare @PID	Char(2)
	declare @cbal	Money 
	declare @BRID	Char(3)

	declare @DOT datetime 
	declare @TYPE Char(3)
	declare @Amount money
	declare @CHQ_NO int 

	declare @date datetime 
	set @date = dateAdd(mm,-1,getdate())
	 ----print@date---
	declare @MonthNm varchar(20)
	set @MonthNm = datename(mm,@date)

	declare @LastDate datetime 
	set @LastDate = EOMONTH(@date)

	declare @LastDayNo int 
	set @LastDayNo = Datepart(dd,@LastDate)

	declare @YNo int 
	set @YNo = datepart (yy, @LastDate)

	print '-------------------------------------------------------------------------------------------------------------------'
	print                                           'INDIAN BANK'
	print'List of Trasation from '+ @MonthNm + '1st to '+ cast(@LastDayNo as varchar) +',  '+ cast(@YNo as varchar)+'report'
	print '---------------------------------------------------------------------------------------------------------------------'


	----Step 1  : Get the Customer Info
		select @CustName = Name, @PID = PID, @CBAL = CBAL, @BRID = BRID from Amaster where acid = @acid

		
------Step 2 : Display /print 
			 
	  print'Product Name	:'+@PID
	  print'Account No		:'+ cast(@acid as varchar)+space(30)+'Branch: '+ @BRID
	  print'Customer Name	:'+@CustName+space(10)+'Cleared Balance  : INR '+cast(@cbal as varchar)

	  print'--------------------------------------------------------------------------------------------'
	  print'SLNO         DATE    TXN_TYPE       CHEQUE_NO     AMOUNT          RUNINGBALANCE'
	  print'-------------------------------------------------------------------------------------------'

----------	Step 3 : Get the Transation Info  
	select DOT,TXNTYPE,TXNAMT,CHQNO, Row_Number() OVER(Order by DOT ASC) as RNo into #TxnTmp from Tmaster
	where acid = @acid and Datediff(mm,DOT,getdate())=1


	select ACID from Tmaster

	-------LOOP
		declare @x int 
		SET @x = 1

		declare @cnt int 
		select @cnt = count(*) from #TxnTmp

	---- select * from #TxnTmp where RNo = 2

		WHILE (@x <=@cnt)
		begin 

		--- Read the data from temp
		select @DOT = DOT, @Type = TXN_TYPE, @AMOUNT = TXN_AMOUNT, @CHQ_NO = isNull(CHQ_NO,0) from #TxnTmp where RNo = @x

		----Print 

		print cast(@x as varchar) + space(10)+ convert(varchar,@DOT,107)+space(10)+ @Type + space(10)+cast (@CHQ_NO as varchar)

		--Incr
		set @x = @x + 1
		end 
		print '---------------------------------------------------------------------------------'

		declare @CDcnt int 
		select @CDcnt = count(*) from #TxnTmp where TXN_TYPE = 'CD'

		declare @CWcnt int 
		select @CWcnt = count(*) from #TxnTmp where TXN_TYPE = 'CW'

		declare @CQDcnt int 
		select @CQDcnt = count(*) from #TxnTmp where TXN_TYPE = 'CQD'

		print'Total Number of Transation :'+cast(@cnt as varchar)
		print'Total cash deposited		 :' + cast(@CDcnt as varchar)
		print'Total cash withdraw		  :' +cast(@CWcnt as varchar)
		print'Total Cheque Deposited	  :' +cast(@CQDcnt as varchar)
		print'--------------------------------------------------------------------------------'
		print'Thanking for Banking With us .... Call customer care for more help 1800 123 4455'
		print'--------------------------------------------------------------------------------'
end

exec usp_CustMonthlyBankStatement 101