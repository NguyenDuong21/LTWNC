USE [master]
GO
/****** Object:  Database [QuanLyQuanCafe]    Script Date: 07/15/2023 9:58:32 PM ******/
CREATE DATABASE [QuanLyQuanCafe]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'QuanLyQuanCafe', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\QuanLyQuanCafe.mdf' , SIZE = 3136KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'QuanLyQuanCafe_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\QuanLyQuanCafe_log.ldf' , SIZE = 784KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
use [QuanLyQuanCafe]
GO
ALTER DATABASE [QuanLyQuanCafe] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [QuanLyQuanCafe].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [QuanLyQuanCafe] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET ARITHABORT OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [QuanLyQuanCafe] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [QuanLyQuanCafe] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [QuanLyQuanCafe] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [QuanLyQuanCafe] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET  ENABLE_BROKER 
GO
ALTER DATABASE [QuanLyQuanCafe] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [QuanLyQuanCafe] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [QuanLyQuanCafe] SET  MULTI_USER 
GO
ALTER DATABASE [QuanLyQuanCafe] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [QuanLyQuanCafe] SET DB_CHAINING OFF 
GO
ALTER DATABASE [QuanLyQuanCafe] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [QuanLyQuanCafe] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [QuanLyQuanCafe]
GO
/****** Object:  StoredProcedure [dbo].[sp_chuyenban]    Script Date: 07/15/2023 9:58:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_chuyenban] @old_tableid int, @new_tableid int
as
begin
	declare @idbillold int = (select id from bill where idTable = @old_tableid AND status = 0);
	declare @idbillnew int = (select id from bill where idTable = @new_tableid AND status = 0);
	if ISNUMERIC(@idbillold) = 0
		update TableFood
		set status = N'Trống'
		where id = @new_tableid
	if ISNUMERIC(@idbillnew) = 0
		update TableFood
		set status = N'Trống'
		where id = @old_tableid
	update bill 
	set idTable = @new_tableid
	where id = @idbillold AND status = 0

	update bill 
	set idTable = @old_tableid
	where id = @idbillnew AND status = 0
end

GO
/****** Object:  StoredProcedure [dbo].[sp_update_account]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[sp_update_account] @username nvarchar(100), @password nvarchar(100), @displayname nvarchar(100)
as
begin
	update Account
	set PassWord  = @password, DisplayName = @displayname
	where UserName = @username
end
GO
/****** Object:  StoredProcedure [dbo].[spBill]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spBill] @idtable int
as 
begin
	insert into bill(DateCheckIn, DateCheckOut, idTable, status, discount, totalPrice)
	values (GETDATE(),NULL, @idtable, 0, NULL, NULL)
end

GO
/****** Object:  StoredProcedure [dbo].[spBillInfor]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[spBillInfor] @idbill int, @idFood int, @count int
as
begin
	Declare @numrow int;
	set @numrow = (select count(id) from BillInfo where idBill = @idbill and idFood = @idFood);
	if @numrow > 0
	begin
		declare @totalcount int = (Select @count+count from BillInfo where idBill = @idbill and idFood = @idFood);
		if @totalcount > 0
			update BillInfo set count = @count+count where idBill = @idbill and idFood = @idFood;
		else
			delete from BillInfo where idBill = @idbill and idFood = @idFood;
	end
	else
		insert into BillInfo(idBill, idFood, count) values (@idbill, @idFood, @count);
end
GO
/****** Object:  StoredProcedure [dbo].[USP_GetAccountByUserName]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetAccountByUserName]
@userName nvarchar(100)
AS 
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @userName
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetListBillByDate]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetListBillByDate]
@checkIn date, @checkOut date
AS 
BEGIN
	SELECT t.name AS [Tên bàn], b.totalPrice AS [Tổng tiền], DateCheckIn AS [Ngày vào], DateCheckOut AS [Ngày ra], discount AS [Giảm giá]
	FROM dbo.Bill AS b,dbo.TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.status = 1
	AND t.id = b.idTable
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetListBillByDateAndPage]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetListBillByDateAndPage]
@checkIn date, @checkOut date, @page int
AS 
BEGIN
	DECLARE @pageRows INT = 10
	DECLARE @selectRows INT = @pageRows
	DECLARE @exceptRows INT = (@page - 1) * @pageRows
	
	;WITH BillShow AS( SELECT b.ID, t.name AS [Tên bàn], b.totalPrice AS [Tổng tiền], DateCheckIn AS [Ngày vào], DateCheckOut AS [Ngày ra], discount AS [Giảm giá]
	FROM dbo.Bill AS b,dbo.TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.status = 1
	AND t.id = b.idTable)
	
	SELECT TOP (@selectRows) * FROM BillShow WHERE id NOT IN (SELECT TOP (@exceptRows) id FROM BillShow)
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetListBillByDateForReport]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetListBillByDateForReport]
@checkIn date, @checkOut date
AS 
BEGIN
	SELECT t.name, b.totalPrice, DateCheckIn, DateCheckOut, discount
	FROM dbo.Bill AS b,dbo.TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.status = 1
	AND t.id = b.idTable
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetNumBillByDate]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetNumBillByDate]
@checkIn date, @checkOut date
AS 
BEGIN
	SELECT COUNT(*)
	FROM dbo.Bill AS b,dbo.TableFood AS t
	WHERE DateCheckIn >= @checkIn AND DateCheckOut <= @checkOut AND b.status = 1
	AND t.id = b.idTable
END

GO
/****** Object:  StoredProcedure [dbo].[USP_GetTableList]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_GetTableList]
AS SELECT * FROM dbo.TableFood

GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBill]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertBill]
@idTable INT
AS
BEGIN
	INSERT dbo.Bill 
	        ( DateCheckIn ,
	          DateCheckOut ,
	          idTable ,
	          status,
	          discount
	        )
	VALUES  ( GETDATE() , -- DateCheckIn - date
	          NULL , -- DateCheckOut - date
	          @idTable , -- idTable - int
	          0,  -- status - int
	          0
	        )
END

GO
/****** Object:  StoredProcedure [dbo].[USP_InsertBillInfo]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_InsertBillInfo]
@idBill INT, @idFood INT, @count INT
AS
BEGIN

	DECLARE @isExitsBillInfo INT
	DECLARE @foodCount INT = 1
	
	SELECT @isExitsBillInfo = id, @foodCount = b.count 
	FROM dbo.BillInfo AS b 
	WHERE idBill = @idBill AND idFood = @idFood

	IF (@isExitsBillInfo > 0)
	BEGIN
		DECLARE @newCount INT = @foodCount + @count
		IF (@newCount > 0)
			UPDATE dbo.BillInfo	SET count = @foodCount + @count WHERE idFood = @idFood
		ELSE
			DELETE dbo.BillInfo WHERE idBill = @idBill AND idFood = @idFood
	END
	ELSE
	BEGIN
		INSERT	dbo.BillInfo
        ( idBill, idFood, count )
		VALUES  ( @idBill, -- idBill - int
          @idFood, -- idFood - int
          @count  -- count - int
          )
	END
END

GO
/****** Object:  StoredProcedure [dbo].[USP_Login]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_Login]
@userName nvarchar(100), @passWord nvarchar(100)
AS
BEGIN
	SELECT * FROM dbo.Account WHERE UserName = @userName AND PassWord = @passWord
END

GO
/****** Object:  StoredProcedure [dbo].[USP_SwitchTabel]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_SwitchTabel]
@idTable1 INT, @idTable2 int
AS BEGIN

	DECLARE @idFirstBill int
	DECLARE @idSeconrdBill INT
	
	DECLARE @isFirstTablEmty INT = 1
	DECLARE @isSecondTablEmty INT = 1
	
	
	SELECT @idSeconrdBill = id FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
	SELECT @idFirstBill = id FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'
	
	IF (@idFirstBill IS NULL)
	BEGIN
		PRINT '0000001'
		INSERT dbo.Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          idTable ,
		          status
		        )
		VALUES  ( GETDATE() , -- DateCheckIn - date
		          NULL , -- DateCheckOut - date
		          @idTable1 , -- idTable - int
		          0  -- status - int
		        )
		        
		SELECT @idFirstBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0
		
	END
	
	SELECT @isFirstTablEmty = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idFirstBill
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'
	
	IF (@idSeconrdBill IS NULL)
	BEGIN
		PRINT '0000002'
		INSERT dbo.Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          idTable ,
		          status
		        )
		VALUES  ( GETDATE() , -- DateCheckIn - date
		          NULL , -- DateCheckOut - date
		          @idTable2 , -- idTable - int
		          0  -- status - int
		        )
		SELECT @idSeconrdBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
		
	END
	
	SELECT @isSecondTablEmty = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idSeconrdBill
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'

	SELECT id INTO IDBillInfoTable FROM dbo.BillInfo WHERE idBill = @idSeconrdBill
	
	UPDATE dbo.BillInfo SET idBill = @idSeconrdBill WHERE idBill = @idFirstBill
	
	UPDATE dbo.BillInfo SET idBill = @idFirstBill WHERE id IN (SELECT * FROM IDBillInfoTable)
	
	DROP TABLE IDBillInfoTable
	
	IF (@isFirstTablEmty = 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable2
		
	IF (@isSecondTablEmty= 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable1
END

GO
/****** Object:  StoredProcedure [dbo].[USP_UpdateAccount]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROC [dbo].[USP_UpdateAccount]
@userName NVARCHAR(100), @displayName NVARCHAR(100), @password NVARCHAR(100), @newPassword NVARCHAR(100)
AS
BEGIN
	DECLARE @isRightPass INT = 0
	
	SELECT @isRightPass = COUNT(*) FROM dbo.Account WHERE USERName = @userName AND PassWord = @password
	
	IF (@isRightPass = 1)
	BEGIN
		IF (@newPassword = NULL OR @newPassword = '')
		BEGIN
			UPDATE dbo.Account SET DisplayName = @displayName WHERE UserName = @userName
		END		
		ELSE
			UPDATE dbo.Account SET DisplayName = @displayName, PassWord = @newPassword WHERE UserName = @userName
	end
END

GO
/****** Object:  UserDefinedFunction [dbo].[fuConvertToUnsign1]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fuConvertToUnsign1] ( @strInput NVARCHAR(4000) ) RETURNS NVARCHAR(4000) AS BEGIN IF @strInput IS NULL RETURN @strInput IF @strInput = '' RETURN @strInput DECLARE @RT NVARCHAR(4000) DECLARE @SIGN_CHARS NCHAR(136) DECLARE @UNSIGN_CHARS NCHAR (136) SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' DECLARE @COUNTER int DECLARE @COUNTER1 int SET @COUNTER = 1 WHILE (@COUNTER <=LEN(@strInput)) BEGIN SET @COUNTER1 = 1 WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) BEGIN IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) BEGIN IF @COUNTER=1 SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) ELSE SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) BREAK END SET @COUNTER1 = @COUNTER1 +1 END SET @COUNTER = @COUNTER +1 END SET @strInput = replace(@strInput,' ','-') RETURN @strInput END

GO
/****** Object:  Table [dbo].[Account]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Account](
	[id] [INT] PRIMARY KEY  IDENTITY(1,1),
	[email] [nvarchar](100) UNIQUE NOT NULL,
	[name] [nvarchar](100) NOT NULL DEFAULT (N'Kter'),
	[password] [nvarchar](1000) NOT NULL DEFAULT ((0)),
	[type] [int] NOT NULL DEFAULT ((0)),
);
GO
/****** Object:  Table [dbo].[Bill]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bill](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[DateCheckIn] [date] NOT NULL DEFAULT (getdate()),
	[DateCheckOut] [date] NULL,
	[idTable] [int] NOT NULL,
	[status] [int] NOT NULL DEFAULT ((0)),
	[discount] [int] NULL,
	[totalPrice] [float] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[BillInfo]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BillInfo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idBill] [int] NOT NULL,
	[idFood] [int] NOT NULL,
	[count] [int] NOT NULL DEFAULT ((0)),
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Food]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Food](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL DEFAULT (N'Chưa đặt tên'),
	[idCategory] [int] NOT NULL,
	[price] [float] NOT NULL DEFAULT ((0)),
	[image] [nchar](100) NULL,
	[dateAdd] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FoodCategory]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FoodCategory](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL DEFAULT (N'Chưa đặt tên'),
	[image] [nchar](100) NULL,
	[dateAdd] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TableFood]    Script Date: 07/15/2023 9:58:33 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TableFood](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [nvarchar](100) NOT NULL DEFAULT (N'Bàn chưa có tên'),
	[status] [nvarchar](100) NOT NULL DEFAULT (N'Trống'),
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
INSERT [dbo].[Account] ([email], [name], [password], [type]) VALUES (N'admin@admin.com', N'Admin', N'fc0iUkg331qk3V8HY6MWvQ==', 0)
SET IDENTITY_INSERT [dbo].[Bill] ON 

INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (110, CAST(N'2021-08-10' AS Date), CAST(N'2021-08-10' AS Date), 1, 1, 10, NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (111, CAST(N'2021-08-10' AS Date), CAST(N'2021-08-10' AS Date), 1, 1, 10, NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (112, CAST(N'2021-08-10' AS Date), CAST(N'2021-08-10' AS Date), 3, 1, 10, NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (113, CAST(N'2021-08-10' AS Date), CAST(N'2021-08-10' AS Date), 4, 1, 10, NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (114, CAST(N'2021-08-10' AS Date), CAST(N'2021-08-10' AS Date), 7, 1, 10, NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (115, CAST(N'2021-08-10' AS Date), NULL, 1, 0, NULL, NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (116, CAST(N'2021-08-10' AS Date), NULL, 3, 0, NULL, NULL)
INSERT [dbo].[Bill] ([id], [DateCheckIn], [DateCheckOut], [idTable], [status], [discount], [totalPrice]) VALUES (117, CAST(N'2021-08-12' AS Date), NULL, 7, 0, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Bill] OFF
SET IDENTITY_INSERT [dbo].[BillInfo] ON 

INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (735, 110, 1, 3)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (736, 110, 2, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (737, 111, 1, 3)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (738, 111, 2, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (739, 112, 1, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (740, 112, 4, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (741, 112, 5, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (742, 113, 3, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (743, 113, 5, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (744, 113, 6, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (745, 113, 7, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (746, 114, 4, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (747, 114, 5, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (748, 115, 1, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (749, 115, 4, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (750, 116, 4, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (751, 116, 5, 2)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (752, 117, 5, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (753, 117, 4, 1)
INSERT [dbo].[BillInfo] ([id], [idBill], [idFood], [count]) VALUES (754, 117, 17, 1)
SET IDENTITY_INSERT [dbo].[BillInfo] OFF
SET IDENTITY_INSERT [dbo].[Food] ON 

INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (1, N'TRÀ TUYẾT PHÚC BỒN TỬ', 4, 59000, N'Granita-Avatarpsd4.png                                                                              ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (2, N'TRÀ THẠCH ĐÀO', 4, 45000, N'TRA_THANH_DAO-09.jpg                                                                                ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (3, N'TRÀ XANH ĐẬU ĐỎ', 4, 45000, N'TRA_XANH_DAU_DO.jpg                                                                                 ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (4, N'TRÀ SEN VÀNG (CỦ NĂNG)', 4, 45000, N'TRA_SEN_VANG_CU_NANG.jpg                                                                            ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (5, N'PHIN SỮA ĐÁ', 2, 29000, N'HLC_New_logo_5.1_Products__PHIN_SUADA.jpg                                                           ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (6, N'PHIN ĐEN ĐÁ', 2, 29000, N'HLC_New_logo_5.1_Products__PHIN_DEN_DA.jpg                                                          ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (7, N'BÁNH MOUSSE ĐÀO', 1, 35000, N'MOUSSEDAO.png                                                                                       ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (8, N'BÁNH CARAMEL PHÔ MAI', 1, 35000, N'CARAMELPHOMAI.jpg                                                                                   ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (12, N'BÁNH PHÔ MAI TRÀ XANH', 1, 35000, N'PHOMAITRAXANH.jpg                                                                                   ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (13, N'BÁNH PHÔ MAI CÀ PHÊ', 1, 29000, N'PHOMAICAPHE.jpg                                                                                     ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (14, N'BÁNH PHÔ MAI CHANH DÂY', 1, 29000, N'PHOMAICHANHDAY.jpg                                                                                  ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (15, N'BÁNH TIRAMISU', 1, 35000, N'TIRAMISU.jpg                                                                                        ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (16, N'Coca', 3, 15000, N'coca.webp                                                                                           ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (17, N'Mirinda', 3, 15000, N'mirinda.jpg                                                                                         ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
INSERT [dbo].[Food] ([id], [name], [idCategory], [price], [image], [dateAdd]) VALUES (18, N'7Up', 3, 15000, N'7-up-lon-cao-1.webp                                                                                 ', CAST(N'2023-05-12 00:00:00.000' AS DateTime))
SET IDENTITY_INSERT [dbo].[Food] OFF
SET IDENTITY_INSERT [dbo].[FoodCategory] ON 

INSERT [dbo].[FoodCategory] ([id], [name], [image], [dateAdd]) VALUES (1, N'Bánh ngọt', N'banhngot230310064.jpg                                                                               ', CAST(N'2023-07-15 18:03:10.067' AS DateTime))
INSERT [dbo].[FoodCategory] ([id], [name], [image], [dateAdd]) VALUES (2, N'Cafe', N'cf.jpg                                                                                              ', CAST(N'2023-06-25 00:00:00.000' AS DateTime))
INSERT [dbo].[FoodCategory] ([id], [name], [image], [dateAdd]) VALUES (3, N'Nước ngọt', N'nuocngot.jpg                                                                                        ', CAST(N'2023-04-11 00:00:00.000' AS DateTime))
INSERT [dbo].[FoodCategory] ([id], [name], [image], [dateAdd]) VALUES (4, N'Trà', N'tra.jpg                                                                                             ', CAST(N'2022-12-21 00:00:00.000' AS DateTime))
INSERT [dbo].[FoodCategory] ([id], [name], [image], [dateAdd]) VALUES (5, N'Đồ ăn nhẹ', N'doannhe.jpg                                                                                         ', CAST(N'2022-09-21 00:00:00.000' AS DateTime))
INSERT [dbo].[FoodCategory] ([id], [name], [image], [dateAdd]) VALUES (11, N'Ăn vặt', N'anvat233601188.jpg                                                                                  ', CAST(N'2023-07-15 15:36:01.190' AS DateTime))
SET IDENTITY_INSERT [dbo].[FoodCategory] OFF
SET IDENTITY_INSERT [dbo].[TableFood] ON 

INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (1, N'Bàn 0', N'Có người')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (2, N'Bàn 1', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (3, N'Bàn 2', N'Có người')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (4, N'Bàn 3', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (5, N'Bàn 4', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (6, N'Bàn 5', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (7, N'Bàn 6', N'Có người')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (8, N'Bàn 7', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (9, N'Bàn 8', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (10, N'Bàn 9', N'Trống')
INSERT [dbo].[TableFood] ([id], [name], [status]) VALUES (11, N'Bàn 10', N'Trống')
SET IDENTITY_INSERT [dbo].[TableFood] OFF
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD FOREIGN KEY([idTable])
REFERENCES [dbo].[TableFood] ([id])
GO
ALTER TABLE [dbo].[Bill]  WITH CHECK ADD FOREIGN KEY([idTable])
REFERENCES [dbo].[TableFood] ([id])
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([idBill])
REFERENCES [dbo].[Bill] ([id])
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([idBill])
REFERENCES [dbo].[Bill] ([id])
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([idFood])
REFERENCES [dbo].[Food] ([id])
GO
ALTER TABLE [dbo].[BillInfo]  WITH CHECK ADD FOREIGN KEY([idFood])
REFERENCES [dbo].[Food] ([id])
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD FOREIGN KEY([idCategory])
REFERENCES [dbo].[FoodCategory] ([id])
GO
ALTER TABLE [dbo].[Food]  WITH CHECK ADD FOREIGN KEY([idCategory])
REFERENCES [dbo].[FoodCategory] ([id])
GO
USE [master]
GO
ALTER DATABASE [QuanLyQuanCafe] SET  READ_WRITE 
GO
