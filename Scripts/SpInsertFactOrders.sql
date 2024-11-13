


CREATE OR ALTER PROCEDURE dbo.SpInsertFactOrders
AS 

BEGIN 

	IF OBJECT_ID ('tempdb..#CustomerOrder', 'U') IS NOT NULL 
		DROP TABLE #CustomerOrder

	SELECT	DISTINCT O.* 
	INTO	#CustomerOrder
	FROM	[stg].[Customer] C
	JOIN	stg.Orders O ON C.Customer_id = O.customer_id 


	IF OBJECT_ID ('tempdb..#CustomerPayment', 'U') IS NOT NULL 
		DROP TABLE #CustomerPayment

	SELECT	DISTINCT C.*,P.payment_type,P.payment_value
	INTO	#CustomerPayment
	FROM	#CustomerOrder C
	JOIN	stg.payments P ON C.Order_id = P.Order_id 


	IF OBJECT_ID ('tempdb..#CustomerStaging', 'U') IS NOT NULL 
		DROP TABLE #CustomerStaging

	SELECT	DISTINCT 
			P.*, 
			PR.[product_category_name],
			OD.Product_id ,OD.price, od.shipping_charges
	INTO	#CustomerStaging
	FROM	#CustomerPayment P 
	JOIN	stg.orderdetail	OD ON OD.Order_id = P.Order_id
	JOIN	stg.product		pR ON OD.product_id = PR.product_id 


	
	--================================================================================
	--Preparing data to inset in FactOrder
	--================================================================================

	IF OBJECT_ID ('tempdb..#InsertCustomers', 'U') IS NOT NULL 
		DROP TABLE #InsertCustomers

	SELECT	DISTINCT  NEWID() UNID,
			DC.Customerkey ,O.Orderkey, DP.ProductKey ,PC.[ProductCategorykey], PT. [PaymentTypeKey], 
			PD.Datekey as PurchaseDateKey , DD.Datekey as DeliveredDateKey,
			C.payment_value AS InvoicePayment , C.Price , c.shipping_charges as Logistics,
			GETUTCDATE() as CreatedDate , ORIGINAL_LOGIN() AS CreatedBY , GETUTCDATE() AS ModifiedDate,
			ORIGINAL_LOGIN() AS ModifiedBY
	INTO	#InsertCustomers
	FROM	#CustomerStaging C
	JOIN	dbo.DimCustomer DC ON DC.customerid = C.Customer_id 
	JOIN	dbo.Dimproduct DP ON DP.[product_id] = C.[product_id] 
	JOIN	[dbo].[DimPaymentType] PT ON PT.[payment_type] = C.[payment_type] 
	JOIN	[dbo].[Dimdate] PD ON CONVERT(DATE,PD.[date]) = CONVERT(DATE,C.order_purchase_timestamp)
	JOIN	[dbo].[Dimdate] DD ON CONVERT(DATE,DD.[date]) = CONVERT(DATE,C.order_delivered_timestamp)
	JOIN	[dbo].[Dimorder] O ON O.order_id = C.order_id 
	JOIN	[dbo].[DimProductcategory] PC ON PC.[product_category_name] = C.[product_category_name]


	
	--================================================================================
	--Getting all those records that are new to insert
	--================================================================================

	IF OBJECT_ID ('tempdb..#InsertFactOrder', 'U') IS NOT NULL 
		DROP TABLE #InsertFactOrder

	SELECT	DISTINCT C.*
	INTO	#InsertFactOrder
	FROM	#InsertCustomers C
	LEFT	JOIN dbo.factorder F	ON 	C.[Customerkey]			=	ISNULL(F.[Customerkey],'')
									AND C.[Orderkey]			=	ISNULL(F.[Orderkey]	  ,'')
									AND C.[ProductKey]			=	ISNULL(F.[ProductKey] ,'')
									AND C.[ProductCategorykey]	=	ISNULL(F.[ProductCategorykey],'')
									AND C.[PaymentTypeKey]		=	ISNULL(F.[PaymentTypeKey]	  ,'')
									AND C.[PurchaseDateKey]		=	ISNULL(F.[PurchaseDateKey]	  ,'')
									AND C.[DeliveredDateKey]	=	ISNULL(F.[DeliveredDateKey]  ,'')
	WHERE	 F.Customerkey IS NULL



	--================================================================================
	--INSERT in batch of 100000 FactOrder
	--================================================================================


	--SELECT COUNT(*) FROM #InsertFactOrder
	DECLARE @i INT = 0;
    DECLARE @batchSize INT = 100000;
    DECLARE @totalCount INT;
	SELECT  @totalCount = COUNT(1)FROM #InsertFactOrder

	WHILE (@i < @totalCount)
	BEGIN 
		Print 'Batch Starts'
		
		INSERT INTO [dbo].[FactOrder](
									  [Customerkey], [Orderkey], [ProductKey]
									, [ProductCategorykey], [PaymentTypeKey]
									, [PurchaseDateKey], [DeliveredDateKey], [InvoicePayment]
									, [Price], [Logistics]
									)
		SELECT	 ISNULL([Customerkey],00) AS  [Customerkey], ISNULL([Orderkey],00)AS [Orderkey]
				,ISNULL([ProductKey],00)AS [ProductKey], ISNULL([ProductCategorykey],00) AS [ProductCategorykey]
				,ISNULL([PaymentTypeKey],00) AS [PaymentTypeKey],ISNULL([PurchaseDateKey],9999999) AS [PurchaseDateKey]
				,ISNULL([DeliveredDateKey],9999999) AS [DeliveredDateKey], ISNULL([InvoicePayment],00) AS [InvoicePayment]
				,ISNULL([Price],00) AS [Price], ISNULL([Logistics],00) AS [Logistics]
		FROM #InsertFactOrder
	  	ORDER BY UNID
		OFFSET @i ROWS
		FETCH NEXT @batchSize ROWS ONLY
							
        SET @i = @i + @batchSize;
	END --End of While loop


END 






