use IBANK
go

alter proc usp_LoanEmiAmount
(
	@LoanAmt money,
	@TenureInYrs TinyInt,
	@ROI	TinyInt
)
as
Begin 
	declare @LoanDate datetime
	set @LoanDate = getdate()

------1st Step : Calculate IntAmt 
------PNR/100
	 declare @InterestAmt money 
	 set @InterestAmt = (@LoanAmt *@TenureInYrs * @ROI)/100

----- 2 st Step : Calculate Total Amount	
	  declare @TotalAmt Money 
	  set @TotalAmt=@LoanAmt+@InterestAmt

-----3 rd Step : Calculate Emi Amount  
	 declare @EMIAmount money
	 SET @EMIAmount =@TotalAmt /(@TenureInYrs * 12)
	 print @InterestAmt 
	 print @TotalAmt 
	 print @EMIAmount 
---- 4th Step : Display Loan Statement 
	print '..............................................................'
	print 'MNO            Date                                    EMIAMT '
	print '--------------------------------------------------------------'
----Loops 
----Initalazation
	declare @x int 
	set @x = 1

While(@x< =(@TenureInYrs * 12))

Begin 
---Action 
	print cast (@x as varchar) + space (10) + convert (varchar,dateAdd(mm,@x,@LoanDate),107 )+ space (15)+ cast (@EmiAmount as varchar)

---- Incr
	set @x = @x+1

end 
	print '------------------------------------------------------------'
	print '@InterestAmt Paid in INR = '+cast (@InterestAmt as varchar)
	print '------------------------------------------------------------'

end 
go



----Exec 

Exec usp_LoanBankStatement 100000, 1,6