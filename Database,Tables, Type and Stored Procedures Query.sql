CREATE DATABASE Foodie
USE [Foodie]

CREATE TABLE [dbo].[Contact](
	[ContactId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[Subject] [varchar](200) NULL,
	[Message] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL
)

CREATE TABLE [dbo].[Users](
	[UserId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Username] [varchar](50) NULL UNIQUE,
	[Mobile] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[Address] [varchar](max) NULL,
	[PostCode] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[ImageUrl] [varchar](max) NULL,
	[CreatedDate] [datetime] NULL
)


CREATE TABLE [dbo].[Categories](
	[CategoryId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[ImageUrl] [varchar](max) NULL,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL
)

CREATE TABLE [dbo].[Products](
	[ProductId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[Description] [varchar](max) NULL,
	[Price] [decimal](18, 2) NULL,
	[Quantity] [int] NULL,
	[ImageUrl] [varchar](max) NULL,
	[CategoryId] [int] NULL FOREIGN KEY REFERENCES Categories(CategoryId) ON DELETE CASCADE,
	[IsActive] [bit] NULL,
	[CreatedDate] [datetime] NULL
)


CREATE TABLE [dbo].[Carts](
	[CartId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[ProductId] [int] NULL FOREIGN KEY REFERENCES Products(ProductId) ON DELETE CASCADE,
	[Quantity] [int] NULL,
	[UserId] [int] NULL FOREIGN KEY REFERENCES Users(UserId) ON DELETE CASCADE
)

CREATE TABLE [dbo].[Payment](
	[PaymentId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[Name] [varchar](50) NULL,
	[CardNo] [varchar](50) NULL,
	[ExpiryDate] [varchar](50) NULL,
	[CvvNo] [int] NULL,
	[Address] [varchar](max) NULL,
	[PaymentMode] [varchar](50) NULL
 )

CREATE TABLE [dbo].[Orders](
	[OrderDetailsId] [int] PRIMARY KEY IDENTITY(1,1) NOT NULL,
	[OrderNo] [varchar](max) NULL,
	[ProductId] [int] NULL FOREIGN KEY REFERENCES Products(ProductId) ON DELETE CASCADE,
	[Quantity] [int] NULL,
	[UserId] [int] NULL FOREIGN KEY REFERENCES Users(UserId) ON DELETE CASCADE,
	[Status] [varchar](50) NULL,
	[PaymentId] [int] NULL FOREIGN KEY REFERENCES Payment(PaymentId) ON DELETE CASCADE,
	[OrderDate] [datetime] NULL
)


CREATE TYPE [dbo].[OrderDetails] AS TABLE(
	[OrderNo] [varchar](max) NULL,
	[ProductId] [int] NULL ,
	[Quantity] [int] NULL,
	[UserId] [int] NULL ,
	[Status] [varchar](50) NULL,
	[PaymentId] [int] NULL,
	[OrderDate] [datetime] NULL
)





CREATE PROCEDURE [dbo].[Cart_Crud]
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(10),
	@ProductId INT = NULL,
	@Quantity INT = NULL,
	@UserId INT = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --SELECT
    IF @Action = 'SELECT'
      BEGIN
			SELECT c.ProductId,p.Name,p.ImageUrl,p.Price,c.Quantity,c.Quantity as Qty,p.Quantity as PrdQty FROM dbo.Carts c
			INNER JOIN dbo.Products p ON p.ProductId = c.ProductId
			WHERE c.UserId = @UserId
      END
 
    --INSERT
    IF @Action = 'INSERT'
      BEGIN
            INSERT INTO dbo.Carts(ProductId, Quantity, UserId)
            VALUES (@ProductId, @Quantity, @UserId)
      END
 
    --UPDATE
    IF @Action = 'UPDATE'
      BEGIN		
			UPDATE dbo.Carts
			SET Quantity = @Quantity
			WHERE ProductId = @ProductId and UserId = @UserId		
      END
 
    --DELETE
    IF @Action = 'DELETE'
      BEGIN
            DELETE FROM dbo.Carts WHERE ProductId = @ProductId and UserId = @UserId
      END

	--GETBYID
    IF @Action = 'GETBYID'
      BEGIN
			SELECT * FROM dbo.Carts WHERE ProductId = @ProductId and UserId = @UserId
      END

END



CREATE PROCEDURE [dbo].[Category_Crud]
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(10),
	@CategoryId INT = NULL,
	@Name VARCHAR(100) = NULL,
	@IsActive BIT = false,
	@ImageUrl VARCHAR(MAX) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --SELECT
    IF @Action = 'SELECT'
      BEGIN
            SELECT * FROM dbo.Categories ORDER BY CreatedDate DESC
      END
 
    --INSERT
    IF @Action = 'INSERT'
      BEGIN
            INSERT INTO dbo.Categories(Name, ImageUrl, IsActive, CreatedDate)
            VALUES (@Name, @ImageUrl, @IsActive, GETDATE())
      END
 
    --UPDATE
    IF @Action = 'UPDATE'
      BEGIN
		DECLARE @UPDATE_IMAGE VARCHAR(20)
		SELECT @UPDATE_IMAGE = (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)
		IF @UPDATE_IMAGE = 'NO'
			BEGIN
				UPDATE dbo.Categories
				SET Name = @Name, IsActive = @IsActive
				WHERE CategoryId = @CategoryId
			END
		ELSE
			BEGIN
				UPDATE dbo.Categories
				SET Name = @Name, ImageUrl = @ImageUrl, IsActive = @IsActive
				WHERE CategoryId = @CategoryId
			END
      END
 
    --DELETE
    IF @Action = 'DELETE'
      BEGIN
            DELETE FROM dbo.Categories WHERE CategoryId = @CategoryId
      END

	--GETBYID
    IF @Action = 'GETBYID'
      BEGIN
            SELECT * FROM dbo.Categories WHERE CategoryId = @CategoryId
      END

END




CREATE PROCEDURE [dbo].[ContactSp]
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(10),
	@ContactId INT = NULL,
	@Name VARCHAR(50) = NULL,
	@Email VARCHAR(50) = NULL,
	@Subject VARCHAR(200) = NULL,
	@Message VARCHAR(MAX) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --INSERT
	IF @Action = 'INSERT'
      BEGIN
            INSERT INTO dbo.Contact(Name, Email, Subject, Message, CreatedDate)
            VALUES (@Name, @Email, @Subject, @Message, GETDATE())
      END

	--SELECT
    IF @Action = 'SELECT'
      BEGIN
            SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS [SrNo],* FROM dbo.Contact
      END

	--DELETE BY ADMIN
    IF @Action = 'DELETE'
      BEGIN
            DELETE FROM dbo.Contact WHERE ContactId = @ContactId
      END

END





CREATE PROCEDURE [dbo].[Dashboard]
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(20) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --1.Categories
	IF @Action = 'CATEGORY'
	BEGIN
		SELECT COUNT(*) FROM dbo.Categories
	END

	--2.Products
	IF @Action = 'PRODUCT'
	BEGIN
		SELECT COUNT(*) FROM dbo.Products
	END

	--3.Orders
	IF @Action = 'ORDER'
	BEGIN
		SELECT COUNT(*) FROM dbo.Orders
	END

	--4.Orders Delivered
	IF @Action = 'DELIVERED'
	BEGIN
		SELECT COUNT(*) FROM dbo.Orders 
		WHERE Status = 'Delivered'
	END

	--5.Orders Pending
	IF @Action = 'PENDING'
	BEGIN
		SELECT COUNT(*) FROM dbo.Orders 
		WHERE Status IN ('Pending','Dispatched')
	END

	--6.Users
	IF @Action = 'USER'
	BEGIN
		SELECT COUNT(*) FROM dbo.Users
	END

	--Sold Item Cost
	IF @Action = 'SOLDAMOUNT'
	BEGIN
		SELECT SUM(o.Quantity * p.Price) FROM Orders o
		INNER JOIN Products p ON p.ProductId = o.ProductId
	END

	--Contact
	IF @Action = 'CONTACT'
	BEGIN
		SELECT COUNT(*) FROM dbo.Contact
	END

END




CREATE PROCEDURE [dbo].[Invoice]
	@Action VARCHAR(10),
	@PaymentId INT = NULL,
	@UserId INT = NULL,
	@OrderDetailsId INT = NULL,
	@Status VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--GET INVOICE BY ID
    IF @Action = 'INVOICBYID'
      BEGIN
			SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS [SrNo], o.OrderNo, p.Name, p.Price, o.Quantity,
			(p.Price * o.Quantity) as TotalPrice, o.OrderDate,o.Status FROM Orders o
			INNER JOIN Products p ON p.ProductId = o.ProductId
			WHERE o.PaymentId = @PaymentId AND o.UserId = @UserId
	  END

	--SELECT ORDER HISTORY
    IF @Action = 'ODRHISTORY'
      BEGIN
			SELECT DISTINCT o.PaymentId,p.PaymentMode,p.CardNo FROM Orders o
            INNER JOIN Payment p on p.PaymentId = o.PaymentId
            WHERE o.UserId = @UserId
	  END

	--GET ORDER STATUS
	IF @Action = 'GETSTATUS'
      BEGIN
			SELECT o.OrderDetailsId, o.OrderNo, (pr.Price * o.Quantity) as TotalPrice, o.Status,
			o.OrderDate, p.PaymentMode, pr.Name FROM Orders o
			INNER JOIN Payment p ON p.PaymentId = o.PaymentId
			INNER JOIN Products pr ON pr.ProductId = o.ProductId
	  END

	--GET ORDER STATUS BY ID
	IF @Action = 'STATUSBYID'
      BEGIN
			SELECT OrderDetailsId, Status FROM Orders
            WHERE OrderDetailsId = @OrderDetailsId
	  END

	--UPDATE ORDER STATUS
    IF @Action = 'UPDTSTATUS'
      BEGIN
			UPDATE dbo.Orders
			SET Status = @Status WHERE OrderDetailsId = @OrderDetailsId
	  END
END





CREATE PROCEDURE [dbo].[Product_Crud]
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(10),
	@ProductId INT = NULL,
	@Name VARCHAR(100) = NULL,
	@Description VARCHAR(MAX) = NULL,
	@Price DECIMAL(18,2) = 0,
	@Quantity INT = NULL,
	@ImageUrl VARCHAR(MAX) = NULL,
	@CategoryId INT = NULL,
	@IsActive BIT = false
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    --SELECT
    IF @Action = 'SELECT'
      BEGIN
            SELECT p.*,c.Name AS CategoryName FROM dbo.Products p
			INNER JOIN dbo.Categories c ON c.CategoryId = p.CategoryId ORDER BY p.CreatedDate DESC
      END
	
    --INSERT
    IF @Action = 'INSERT'
      BEGIN
            INSERT INTO dbo.Products(Name, Description, Price, Quantity, ImageUrl, CategoryId, IsActive, CreatedDate)
            VALUES (@Name, @Description, @Price, @Quantity, @ImageUrl, @CategoryId, @IsActive, GETDATE())
      END
 
    --UPDATE
    IF @Action = 'UPDATE'
      BEGIN
		DECLARE @UPDATE_IMAGE VARCHAR(20)
		SELECT @UPDATE_IMAGE = (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)
		IF @UPDATE_IMAGE = 'NO'
			BEGIN
				UPDATE dbo.Products
				SET Name = @Name, Description = @Description, Price = @Price, Quantity = @Quantity,
				CategoryId = @CategoryId, IsActive = @IsActive
				WHERE ProductId = @ProductId
			END
		ELSE
			BEGIN
				UPDATE dbo.Products
				SET Name = @Name, Description = @Description, Price = @Price, Quantity = @Quantity,
				ImageUrl = @ImageUrl, CategoryId = @CategoryId, IsActive = @IsActive
				WHERE ProductId = @ProductId
			END
      END

	--UPDATE QUANTITY
    IF @Action = 'QTYUPDATE'
	BEGIN
		UPDATE dbo.Products SET Quantity = @Quantity
		WHERE ProductId = @ProductId
	END
 
    --DELETE
    IF @Action = 'DELETE'
      BEGIN
            DELETE FROM dbo.Products WHERE ProductId = @ProductId
      END
	  
	--GETBYID
    IF @Action = 'GETBYID'
      BEGIN
            SELECT * FROM dbo.Products WHERE ProductId = @ProductId
      END

END





CREATE PROCEDURE [dbo].[Save_Orders] @tblOrders OrderDetails READONLY
AS
BEGIN
      SET NOCOUNT ON;
     
      INSERT INTO Orders(OrderNo, ProductId, Quantity, UserId, Status, PaymentId, OrderDate)
      SELECT OrderNo, ProductId, Quantity, UserId, Status, PaymentId, OrderDate FROM @tblOrders
END




CREATE PROCEDURE [dbo].[Save_Payment] 
	@Name VARCHAR(100) = NULL,
	@CardNo VARCHAR(50) = NULL,
	@ExpiryDate VARCHAR(50) = NULL,
	@Cvv INT = NULL,
	@Address VARCHAR(MAX) = NULL,
	@PaymentMode VARCHAR(10) = 'card',
	@InsertedId int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--INSERT
      BEGIN
            INSERT INTO dbo.Payment(Name, CardNo, ExpiryDate, CvvNo, Address, PaymentMode)
            VALUES (@Name, @CardNo, @ExpiryDate, @Cvv, @Address, @PaymentMode)

			SELECT @InsertedId = SCOPE_IDENTITY();
      END
END






CREATE PROCEDURE [dbo].[SellingReport]
	-- Add the parameters for the stored procedure here
	@FromDate DATE = NULL,
	@ToDate DATE = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	Print @FromDate
	Print @ToDate

	SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS [SrNo],u.Name,u.Email,
		SUM(o.Quantity) AS TotalOrders, SUM(o.Quantity * p.Price) AS TotalPrice 
		FROM Orders o
		INNER JOIN Products p ON p.ProductId = o.ProductId
		INNER JOIN Users u ON u.UserId = o.UserId
		WHERE CAST(o.OrderDate AS DATE) BETWEEN @FromDate AND @ToDate
		GROUP BY u.Name, u.Email;	
END





CREATE PROCEDURE [dbo].[User_Crud] 
	-- Add the parameters for the stored procedure here
	@Action VARCHAR(20),
	@UserId INT = NULL,
	@Name varchar(50) = null,
	@Username varchar(50) = null,
	@Mobile varchar(50) = null,
	@Email varchar(50) = null,
	@Address varchar(max) = null,
	@PostCode varchar(50) = null,
	@Password varchar(50) = null,
	@ImageUrl varchar(max) = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--SELECT FOR LOGIN
    IF @Action = 'SELECT4LOGIN'
      BEGIN
            SELECT * FROM dbo.Users WHERE Username = @Username and Password = @Password
      END

	--SELECT FOR USER PROFILE
    IF @Action = 'SELECT4PROFILE'
      BEGIN
            SELECT * FROM dbo.Users WHERE UserId = @UserId
      END

    -- Insert (REGISTRATION)
	IF @Action = 'INSERT'
		BEGIN
			Insert into dbo.Users(Name,Username,Mobile,Email,Address,PostCode,Password,ImageUrl,CreatedDate) 
			values (@Name,@Username,@Mobile,@Email,@Address,@PostCode,@Password,@ImageUrl,GETDATE())
		END

	--UPDATE USER PROFILE
    IF @Action = 'UPDATE'
      BEGIN
		DECLARE @UPDATE_IMAGE VARCHAR(20)
		SELECT @UPDATE_IMAGE = (CASE WHEN @ImageUrl IS NULL THEN 'NO' ELSE 'YES' END)
		IF @UPDATE_IMAGE = 'NO'
			BEGIN
				UPDATE dbo.Users
				SET Name = @Name, Username = @Username, Mobile = @Mobile, Email = @Email, Address = @Address,
				PostCode = @PostCode
				WHERE UserId = @UserId
			END
		ELSE
			BEGIN
				UPDATE dbo.Users
				SET Name = @Name, Username = @Username, Mobile = @Mobile, Email = @Email, Address = @Address,
				PostCode = @PostCode, ImageUrl = @ImageUrl
				WHERE UserId = @UserId
			END
      END

	--SELECT FOR ADMIN
	IF @Action = 'SELECT4ADMIN'
		BEGIN
			SELECT ROW_NUMBER() OVER(ORDER BY (SELECT 1)) AS [SrNo],UserId, Name, 
			Username, Email, CreatedDate
			FROM Users
		END
	--DELETE BY ADMIN
    IF @Action = 'DELETE'
      BEGIN
            DELETE FROM dbo.Users WHERE UserId = @UserId
      END
END
