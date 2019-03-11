USE [master]
GO
/****** Object:  Database [CGP]    Script Date: 11/03/2019 22:46:27 ******/
CREATE DATABASE [CGP]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CGP', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\CGP.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CGP_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\CGP_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CGP].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CGP] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CGP] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CGP] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CGP] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CGP] SET ARITHABORT OFF 
GO
ALTER DATABASE [CGP] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [CGP] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CGP] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CGP] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CGP] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CGP] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CGP] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CGP] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CGP] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CGP] SET  DISABLE_BROKER 
GO
ALTER DATABASE [CGP] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CGP] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CGP] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CGP] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CGP] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CGP] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [CGP] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CGP] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CGP] SET  MULTI_USER 
GO
ALTER DATABASE [CGP] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CGP] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CGP] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CGP] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
USE [CGP]
GO
/****** Object:  UserDefinedFunction [dbo].[func_getHoSo]    Script Date: 11/03/2019 22:46:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Thái Thiên Vu>
-- Create date: <10/03/2019>
-- Description:	<L?y h? so t?t c? thành viên>
-- =============================================
CREATE FUNCTION [dbo].[func_getHoSo]()
RETURNS 
@rs TABLE 
(
	-- Add the column definitions for the TABLE variable here
	id INT,
	hoTen NVARCHAR(50),
	gioiTinh NVARCHAR(50),
	ngayGioSinh NVARCHAR(50),
	queQuan NVARCHAR(MAX),
	ngheNghiep NVARCHAR(50),
	diaChi NVARCHAR(50)
)
AS
BEGIN
	
	INSERT INTO @rs
	SELECT ThanhVien.id, ThanhVien.hoTen, ThanhVien.gioiTinh, CONVERT(NVARCHAR(50), ThanhVien.ngaySinh, 103) as ngaySinh, QueQuan.queQuan, NgheNghiep.ngheNghiep, ThanhVien.diaChi
	FROM ThanhVien JOIN QueQuan ON ThanhVien.id = QueQuan.idThanhVien JOIN NgheNghiep ON ThanhVien.id = NgheNghiep.idThanhVien
					
	RETURN;
END
GO
/****** Object:  Table [dbo].[NgheNghiep]    Script Date: 11/03/2019 22:46:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NgheNghiep](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idThanhVien] [int] NOT NULL,
	[ngheNghiep] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_NgheNghiep] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QuanHe]    Script Date: 11/03/2019 22:46:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QuanHe](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idNguoiThuNhat] [int] NOT NULL,
	[idNguoiThuHai] [int] NOT NULL,
	[loaiQuanHe] [nvarchar](50) NOT NULL,
	[ngayPhatSinh] [date] NOT NULL,
 CONSTRAINT [PK_QuanHe] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[QueQuan]    Script Date: 11/03/2019 22:46:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[QueQuan](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[idThanhVien] [int] NOT NULL,
	[queQuan] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_QueQuan] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ThanhVien]    Script Date: 11/03/2019 22:46:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ThanhVien](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[hoTen] [nvarchar](50) NOT NULL,
	[gioiTinh] [nvarchar](50) NOT NULL,
	[ngaySinh] [datetime] NOT NULL,
	[doi] [int] NOT NULL,
	[diaChi] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_ThanhVien] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[NgheNghiep] ON 

INSERT [dbo].[NgheNghiep] ([id], [idThanhVien], [ngheNghiep]) VALUES (8, 11, N'Làm ruộng')
INSERT [dbo].[NgheNghiep] ([id], [idThanhVien], [ngheNghiep]) VALUES (9, 12, N'Làm ruộng')
INSERT [dbo].[NgheNghiep] ([id], [idThanhVien], [ngheNghiep]) VALUES (10, 13, N'Làm ruộng')
INSERT [dbo].[NgheNghiep] ([id], [idThanhVien], [ngheNghiep]) VALUES (11, 14, N'Sinh viên')
SET IDENTITY_INSERT [dbo].[NgheNghiep] OFF
SET IDENTITY_INSERT [dbo].[QuanHe] ON 

INSERT [dbo].[QuanHe] ([id], [idNguoiThuNhat], [idNguoiThuHai], [loaiQuanHe], [ngayPhatSinh]) VALUES (8, 11, 12, N'Vợ/Chồng', CAST(N'2018-02-18' AS Date))
INSERT [dbo].[QuanHe] ([id], [idNguoiThuNhat], [idNguoiThuHai], [loaiQuanHe], [ngayPhatSinh]) VALUES (9, 11, 13, N'Con', CAST(N'2018-03-01' AS Date))
INSERT [dbo].[QuanHe] ([id], [idNguoiThuNhat], [idNguoiThuHai], [loaiQuanHe], [ngayPhatSinh]) VALUES (10, 13, 14, N'Vợ/Chồng', CAST(N'2019-03-04' AS Date))
SET IDENTITY_INSERT [dbo].[QuanHe] OFF
SET IDENTITY_INSERT [dbo].[QueQuan] ON 

INSERT [dbo].[QueQuan] ([id], [idThanhVien], [queQuan]) VALUES (23, 11, N'Tiền Giang')
INSERT [dbo].[QueQuan] ([id], [idThanhVien], [queQuan]) VALUES (24, 12, N'Tiền Giang')
INSERT [dbo].[QueQuan] ([id], [idThanhVien], [queQuan]) VALUES (25, 13, N'Tiền Giang')
INSERT [dbo].[QueQuan] ([id], [idThanhVien], [queQuan]) VALUES (26, 14, N'Lâm Đồng')
SET IDENTITY_INSERT [dbo].[QueQuan] OFF
SET IDENTITY_INSERT [dbo].[ThanhVien] ON 

INSERT [dbo].[ThanhVien] ([id], [hoTen], [gioiTinh], [ngaySinh], [doi], [diaChi]) VALUES (11, N'Nguyễn Văn A', N'Nam', CAST(N'1974-03-01T00:00:00.000' AS DateTime), 1, N'Tiền Giang')
INSERT [dbo].[ThanhVien] ([id], [hoTen], [gioiTinh], [ngaySinh], [doi], [diaChi]) VALUES (12, N'Nguyễn Thị B', N'Nữ', CAST(N'1987-05-03T00:00:00.000' AS DateTime), 1, N'Tiền Giang')
INSERT [dbo].[ThanhVien] ([id], [hoTen], [gioiTinh], [ngaySinh], [doi], [diaChi]) VALUES (13, N'Nguyễn Thị A B', N'Nữ', CAST(N'2018-03-01T00:00:00.000' AS DateTime), 2, N'Tiền Giang')
INSERT [dbo].[ThanhVien] ([id], [hoTen], [gioiTinh], [ngaySinh], [doi], [diaChi]) VALUES (14, N'Trần Văn B A', N'Nam', CAST(N'2019-03-04T00:00:00.000' AS DateTime), 2, N'Thủ Đức')
SET IDENTITY_INSERT [dbo].[ThanhVien] OFF
ALTER TABLE [dbo].[ThanhVien] ADD  CONSTRAINT [DF_ThanhVien_doi]  DEFAULT ((1)) FOR [doi]
GO
ALTER TABLE [dbo].[ThanhVien] ADD  CONSTRAINT [DF_ThanhVien_diaChi]  DEFAULT ('') FOR [diaChi]
GO
ALTER TABLE [dbo].[NgheNghiep]  WITH CHECK ADD  CONSTRAINT [FK_NgheNghiep_ThanhVien] FOREIGN KEY([idThanhVien])
REFERENCES [dbo].[ThanhVien] ([id])
GO
ALTER TABLE [dbo].[NgheNghiep] CHECK CONSTRAINT [FK_NgheNghiep_ThanhVien]
GO
ALTER TABLE [dbo].[QuanHe]  WITH CHECK ADD  CONSTRAINT [FK_QuanHe_ThanhVien1] FOREIGN KEY([idNguoiThuNhat])
REFERENCES [dbo].[ThanhVien] ([id])
GO
ALTER TABLE [dbo].[QuanHe] CHECK CONSTRAINT [FK_QuanHe_ThanhVien1]
GO
ALTER TABLE [dbo].[QuanHe]  WITH CHECK ADD  CONSTRAINT [FK_QuanHe_ThanhVien2] FOREIGN KEY([idNguoiThuHai])
REFERENCES [dbo].[ThanhVien] ([id])
GO
ALTER TABLE [dbo].[QuanHe] CHECK CONSTRAINT [FK_QuanHe_ThanhVien2]
GO
ALTER TABLE [dbo].[QueQuan]  WITH CHECK ADD  CONSTRAINT [FK_QueQuan_ThanhVien] FOREIGN KEY([idThanhVien])
REFERENCES [dbo].[ThanhVien] ([id])
GO
ALTER TABLE [dbo].[QueQuan] CHECK CONSTRAINT [FK_QueQuan_ThanhVien]
GO
/****** Object:  StoredProcedure [dbo].[proc_addMember]    Script Date: 11/03/2019 22:46:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Thái Thiên Vu>
-- Create date: <10/03/2019>
-- Description:	<Thêm thành viên m?i>
-- =============================================
CREATE PROCEDURE [dbo].[proc_addMember] 
	-- Add the parameters for the stored procedure here
	@idThanhVienCu  int = -1, 
	@loaiQuanHe nvarchar(50),
	@ngayPhatSinh date = '1970-01-01',
	@hoTen nvarchar(50),
	@gioiTinh nvarchar(50),
	@ngayGioSinh datetime,
	@queQuan nvarchar(max) = N'',
	@ngheNghiep nvarchar(50) = N'',
	@diaChi nvarchar(max)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF @idThanhVienCu != -1 AND @loaiQuanHe != N'Con' AND @loaiQuanHe != N'Vợ/Chồng' RETURN -1;

	IF @ngayPhatSinh > GETDATE() OR @ngayGioSinh > GETDATE() RETURN -2;

	DECLARE @doi INT;
	IF @idThanhVienCu != -1
		BEGIN
			IF NOT EXISTS (SELECT * FROM ThanhVien WHERE id = @idThanhVienCu) RETURN -3;

			SELECT @doi = ThanhVien.doi FROM ThanhVien WHERE id = @idThanhVienCu;
			IF @loaiQuanHe = N'Con' SET @doi = @doi + 1;
		END
	ELSE SET @doi = 1;

	BEGIN TRANSACTION
		DECLARE @insertedId INT;

		INSERT INTO ThanhVien (hoTen, gioiTinh, ngaySinh, doi, diaChi) VALUES (@hoTen, @gioiTinh, @ngayGioSinh, @doi, @diaChi);
		SET @insertedId = @@Identity;
		IF @idThanhVienCu != -1 INSERT INTO QuanHe (idNguoiThuNhat, idNguoiThuHai, loaiQuanHe, ngayPhatSinh) VALUES (@idThanhVienCu, @insertedId, @loaiQuanHe, @ngayPhatSinh);
		IF @queQuan != N'' INSERT INTO QueQuan (idThanhVien, queQuan) VALUES (@insertedId, @queQuan);
		IF @ngheNghiep != N'' INSERT INTO NgheNghiep (idThanhVien, ngheNghiep) VALUES (@insertedId, @ngheNghiep);
	COMMIT

	RETURN 0;
END
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'''Con hoặc Vợ/Chồng''' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuanHe', @level2type=N'COLUMN',@level2name=N'loaiQuanHe'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Đời thứ mấy trong dòng dọ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ThanhVien', @level2type=N'COLUMN',@level2name=N'doi'
GO
USE [master]
GO
ALTER DATABASE [CGP] SET  READ_WRITE 
GO
