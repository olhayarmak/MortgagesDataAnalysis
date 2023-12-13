SELECT  [Category]
      ,sum([Number Of Sales]) as "Number Of Sales"
	 ,DATEADD(month, DATEDIFF(month, 0, cast(concat(REPLACE( [Account Open Date], '-', ' ' ), ', 2020') as date)), 0) as "Account Opened Month"
								into #prep
  FROM [master].[dbo].['Sales by type of borrower$']

  group by Category
  ,DATEADD(month, DATEDIFF(month, 0, cast(concat(REPLACE( [Account Open Date], '-', ' ' ), ', 2020') as date)), 0)


  select

  Category,
  cast([Account Opened Month] as date) as "Account Opened Month",
  concat(datename(month,[Account Opened Month]),' ',datepart(year,[Account Opened Month])) as "Month Name",
  [Number Of Sales],
   LAG([Number Of Sales], 1) OVER (PARTITION BY Category
                                ORDER BY [Account Opened Month])  as "Previous Month # of Sales",

 [Number Of Sales]-(LAG([Number Of Sales], 1) OVER (PARTITION BY Category
                                ORDER BY [Account Opened Month])) as "Difference",
 ([Number Of Sales]-(LAG([Number Of Sales], 1) OVER (PARTITION BY Category
                                ORDER BY [Account Opened Month])))/   LAG([Number Of Sales], 1) OVER (PARTITION BY Category
                                ORDER BY [Account Opened Month]) as "Percentage Growth"
  from #prep


  drop table #prep