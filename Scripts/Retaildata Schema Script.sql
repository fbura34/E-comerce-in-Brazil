
--Retail DataSet 
--=========================================================================================================
-- Staging layers schema 
--=========================================================================================================
 --Orders 
 CREATE TABLE stg.Orders
                        (    order_id	VARCHAR(512),
    customer_id	VARCHAR(512),
    order_status	VARCHAR(512),
    order_purchase_timestamp	VARCHAR(50),
    order_approved_at	VARCHAR(50),
    order_delivered_timestamp	VARCHAR(50),
    order_estimated_delivery_date	VARCHAR(50)
);
--OrderDetail 
CREATE TABLE Stg.OrderDetail
                        (    order_id	VARCHAR(512),
    order_item_id	VARCHAR(512),
    product_id	VARCHAR(512),
    seller_id	VARCHAR(512),
    price	DECIMAL(18,2),
    shipping_charges	DECIMAL(18,2)
);

--Customers 

CREATE TABLE stg.Customer
                        (    customer_id	VARCHAR(512),
    customer_zip_code_prefix	INT,
    customer_city	VARCHAR(512),
    customer_state	VARCHAR(512)
);

-- Payments 
CREATE TABLE stg.Payments
                        (    order_id	VARCHAR(512),
    payment_sequential	VARCHAR(512),
    payment_type	VARCHAR(512),
    payment_installments	VARCHAR(512),
    payment_value	DECIMAL(18,2)
);

--products 
CREATE TABLE stg.Product
                        (    product_id	VARCHAR(512),
    product_category_name	VARCHAR(512),
    product_weight_g	VARCHAR(50),
    product_length_cm	VARCHAR(50),
    product_height_cm	VARCHAR(50),
    product_width_cm	VARCHAR(50)
);
--TRUNCATE TABLE stg.Product
--TRUNCATE TABLE stg.Payments
--TRUNCATE TABLE stg.Customer
--TRUNCATE TABLE stg.Orders
--===================================================================================================
--Dimensions
--===================================================================================================
--DimCUstomer

CREATE TABLE dbo.DimCustomer(    
	Customerkey	INT IDENTITY(1,1),
    CustomerID	VARCHAR(512),
	CustomerCity VARCHAR(512),
	CustomerZipCode VARCHAR(512),
	CustomerState VARCHAR(512)
    
);
--Product
CREATE TABLE dbo.DimProduct(    
	Productkey INT IDENTITY (1,1),
	product_id	VARCHAR(512),
    product_weight_g	INT,
    product_length_cm	INT,
    product_height_cm	INT,
    product_width_cm	INT,
	CreateDate DATETIME DEFAULT GETUTCDATE(),
	CreateBy DATETIME DEFAULT ORIGINAL_LOGIN(),
	ModifiedDate DATETIME DEFAULT GETUTCDATE(),
	ModifiedDateBy DATETIME DEFAULT ORIGINAL_LOGIN()
);
--DimProductcategory

CREATE TABLE dbo.DimProductcategory(    
	Productcategorykey INT IDENTITY (1,1),
    product_category_name	VARCHAR(512),
	CreateDate DATETIME DEFAULT GETUTCDATE(),
	CreateBy DATETIME DEFAULT ORIGINAL_LOGIN(),
	ModifiedDate DATETIME DEFAULT GETUTCDATE(),
	ModifiedDateBy DATETIME DEFAULT ORIGINAL_LOGIN()
);

--DimPaymentType

CREATE TABLE dbo.DimPaymentType(    
	PaymentTypekey INT IDENTITY (1,1),
    payment_type	VARCHAR(512),
	CreateDate DATETIME DEFAULT GETUTCDATE(),
	CreateBy DATETIME DEFAULT ORIGINAL_LOGIN(),
	ModifiedDate DATETIME DEFAULT GETUTCDATE(),
	ModifiedDateBy DATETIME DEFAULT ORIGINAL_LOGIN()
);

--DimOrder
CREATE TABLE dbo.DimOrder(    
	Orderkey INT IDENTITY (1,1),
	order_id	VARCHAR(512),
    order_status	VARCHAR(512),
	CreateDate DATETIME DEFAULT GETUTCDATE(),
	CreateBy DATETIME DEFAULT ORIGINAL_LOGIN(),
	ModifiedDate DATETIME DEFAULT GETUTCDATE(),
	ModifiedDateBy DATETIME DEFAULT ORIGINAL_LOGIN()
);
--==========================DimDate======================================
CREATE TABLE dbo.DimDate (
    DateKey INT PRIMARY KEY,
    date DATE,
    year INT,
    month INT,
    day INT,
    quarter INT,
    week INT,
    day_of_week INT,
    is_weekend INT
);
/*

--Execute this script one time and populate the dimension Date 

DECLARE @startDate DATE = '2015-01-01';
DECLARE @endDate DATE = GETDATE();
DECLARE @currentDate DATE = @startDate;

WHILE @currentDate <= @endDate
BEGIN
    INSERT INTO dimDate (DateKey, date, year, month, day, quarter, week, day_of_week, is_weekend)
    VALUES (
        CONVERT(INT, FORMAT(@currentDate, 'yyyyMMdd')),
        @currentDate,
        YEAR(@currentDate),
        MONTH(@currentDate),
        DAY(@currentDate),
        DATEPART(QUARTER, @currentDate),
        DATEPART(WEEK, @currentDate),
        DATEPART(WEEKDAY, @currentDate),
        CASE WHEN DATEPART(WEEKDAY, @currentDate) IN (1, 7) THEN 1 ELSE 0 END
    );
    
    SET @currentDate = DATEADD(DAY, 1, @currentDate);
END

--SELECT * FROM dbo.dimDate
*/




--==============================================================================================
--Fact Table
--==============================================================================================

CREATE TABLE [dbo].[FactOrder](
	[FactOrderKey] [int] IDENTITY(1,1) NOT NULL,
	[Customerkey] [int] NOT NULL,
	[Orderkey] [int] NOT NULL,
	[ProductKey] [int] NOT NULL,
	[ProductCategorykey] [int] NOT NULL,
	[PaymentTypeKey] [int] NOT NULL,
	[PurchaseDateKey] [int] NOT NULL,
	[DeliveredDateKey] [int] NOT NULL,
	[InvoicePayment] [decimal](18, 2) NULL,
	[Price] [decimal](18, 2) NULL,
	[Logistics] [decimal](18, 2) NULL,
	[CreatedDate] [datetime] DEFAULT GETUTCDATE() NOT NULL,
	[CreatedBY] [nvarchar](4000) DEFAULT ORIGINAL_LOGIN() NOT NULL,
	[ModifiedDate] [datetime] DEFAULT GETUTCDATE() NOT NULL,
	[ModifiedBY] [nvarchar](4000) DEFAULT ORIGINAL_LOGIN() NOT NULL,
 CONSTRAINT [PK_FactOrder] PRIMARY KEY CLUSTERED 
(
	[FactOrderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

