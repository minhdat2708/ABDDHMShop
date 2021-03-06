USE [WebBanHangBTL]
GO
/****** Object:  Table [dbo].[Administrator]    Script Date: 11/04/2022 9:39:14 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Administrator](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Catalog]    Script Date: 11/04/2022 9:39:14 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Catalog](
	[id] [int] NOT NULL,
	[name] [nvarchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 11/04/2022 9:39:14 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[quantity] [int] NOT NULL,
	[amount] [int] NOT NULL,
	[data] [varchar](50) NOT NULL,
	[status] [int] NOT NULL,
	[transaction_id] [int] NOT NULL,
	[product_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Product]    Script Date: 11/04/2022 9:39:14 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Product](
	[id] [int] NOT NULL,
	[name] [varchar](50) NOT NULL,
	[price] [money] NOT NULL,
	[content] [varchar](50) NULL,
	[discount] [int] NULL,
	[image_link] [varchar](50) NOT NULL,
	[time_created] [date] NULL,
	[views] [int] NOT NULL,
	[catalog_id] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 11/04/2022 9:39:14 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[status] [varchar](10) NOT NULL,
	[user_name] [varchar](50) NOT NULL,
	[user_email] [varchar](50) NOT NULL,
	[amount] [int] NOT NULL,
	[payment] [varchar](30) NULL,
	[payment_info] [varchar](50) NULL,
	[message] [varchar](200) NULL,
	[security] [int] NULL,
	[time_created] [date] NULL,
	[user_id] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 11/04/2022 9:39:14 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](50) NULL,
	[email] [varchar](100) NULL,
	[username] [nvarchar](50) NULL,
	[password] [varchar](100) NULL,
	[address] [nvarchar](100) NULL,
	[time_created] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [time_created]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([product_id])
REFERENCES [dbo].[Product] ([id])
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD FOREIGN KEY([transaction_id])
REFERENCES [dbo].[Transactions] ([id])
GO
ALTER TABLE [dbo].[Product]  WITH CHECK ADD FOREIGN KEY([catalog_id])
REFERENCES [dbo].[Catalog] ([id])
GO
ALTER TABLE [dbo].[Transactions]  WITH CHECK ADD FOREIGN KEY([user_id])
REFERENCES [dbo].[Users] ([id])
GO
/****** Object:  StoredProcedure [dbo].[SP_ADMIN_LOGIN]    Script Date: 11/04/2022 9:39:14 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [dbo].[SP_ADMIN_LOGIN] @userName varchar(50), @password varchar(20)
AS
BEGIN
	DECLARE @count int
	DECLARE @res bit
	SELECT @count = COUNT(*) FROM Admin WHERE username = @userName AND password = @password
	IF @count > 0
		SET @res = 1
	ELSE
		SET @res = 0
	SELECT @res
END
GO
/****** Object:  StoredProcedure [dbo].[SP_CATALOG_LISTALL]    Script Date: 11/04/2022 9:39:14 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [dbo].[SP_CATALOG_LISTALL]
AS
SELECT * FROM Catalog
ORDER BY [name] ASC
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_ADMIN]    Script Date: 11/04/2022 9:39:14 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [dbo].[SP_INSERT_ADMIN] @id INT, @name VARCHAR(100), @username VARCHAR(50), @password VARCHAR(12)
AS
BEGIN 
	INSERT INTO Administrator(id, [name], username, [password])
	VALUES (@id, @name, @username, @password)
END
GO
/****** Object:  StoredProcedure [dbo].[SP_INSERT_CATEGORY]    Script Date: 11/04/2022 9:39:14 CH ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   PROC [dbo].[SP_INSERT_CATEGORY] @id INT, @name NVARCHAR(100)
AS
BEGIN 
	INSERT INTO Catalog(id, [name])
	VALUES (@id, @name)
END
GO

INSERT INTO Catalog (id,name) VALUES (1, 'Fashion')
GO
INSERT INTO Catalog (id,name) VALUES (2, 'Electric Devive')
GO
INSERT INTO Catalog (id,name) VALUES (3, 'Life')
GO
INSERT INTO Catalog (id,name) VALUES (4, 'Sport')
GO
INSERT INTO Catalog (id,name) VALUES (5, 'Jewels');
GO

INSERT INTO Product (id, name, price, image_link, time_created, views, catalog_id) VALUES (11, 'Thermos', 200, 'product-img-1.jpg', '2022-04-11' , 102, 2);
GO
INSERT INTO Product (id,name,price,image_link, time_created, views, catalog_id) VALUES (12, 'Camera', 2400, 'product-img-2.jpg', '2022-04-11', 111, 2);
GO
INSERT INTO Product (id,name,price,image_link, time_created, views,catalog_id) VALUES (13,'Bag',15,'product-img-3.jpg', '2022-04-11',89,3);
GO
INSERT INTO Product (id,name,price,image_link, time_created, views,catalog_id) VALUES (4,'Perfume',300,'product-img-4.jpg', '2022-04-11',100,3);
GO
INSERT INTO Product (id,name,price,image_link, time_created,views,catalog_id) VALUES (5,'Helmet',200,'product-img-5.jpg', '2022-04-11',200,4);
GO
INSERT INTO Product (id,name,price,image_link, time_created,views,catalog_id) VALUES (6,'Bottle',100,'product-img-6.jpg', '2022-04-11',150,3);
GO
INSERT INTO Product (id,name,price,image_link, time_created,views,catalog_id) VALUES (7,'Shoes',200,'product-img-8.jpg', '2022-04-11',2000,4);
GO
INSERT INTO Product (id,name,price,image_link, time_created,views,catalog_id) VALUES (8,'T-Shirt',100,'product-img-9.jpg', '2022-04-11',134,1);
GO
INSERT INTO Product (id,name,price,image_link, time_created,views,catalog_id) VALUES (9,'Comb',10,'product-img-10.jpg', '2022-04-11', 11, 3);
GO
INSERT INTO Product (id,name,price,image_link, time_created,views,catalog_id) VALUES (10,'Jeans',200,'product-img-14.jpg',56,1);
GO

ALTER TABLE [dbo].[Product] DROP 
   CONSTRAINT FK__Product__catalog__3C69FB99;

ALTER TABLE [dbo].[Product] ADD 
   CONSTRAINT FK__Product__catalog__3C69FB99 
      FOREIGN KEY (catalog_id)
      REFERENCES Catalog (id)
      ON DELETE CASCADE;

ALTER TABLE [dbo].[Orders] DROP 
   CONSTRAINT [FK__Orders__product___2A164134];

ALTER TABLE [dbo].[Orders] ADD 
   CONSTRAINT [FK__Orders__product___2A164134] 
      FOREIGN KEY (product_id)
      REFERENCES Product (id)
      ON DELETE CASCADE;

ALTER TABLE [dbo].[Orders] DROP 
   CONSTRAINT [FK__Orders__transact__29221CFB];

ALTER TABLE [dbo].[Orders] ADD 
   CONSTRAINT [FK__Orders__transact__29221CFB] 
      FOREIGN KEY (transaction_id)
      REFERENCES Transactions (id)
      ON DELETE CASCADE;