﻿CREATE DATABASE HousePlanner;

GO

USE Project;

GO


CREATE TABLE [dbo].[Users]
(
    [UserId] UNIQUEIDENTIFIER NOT NULL PRIMARY KEY, 
	[Name] VARCHAR(25) not null,
    [UserName] VARCHAR(MAX) NOT NULL, 
    [PasswordHash] VARCHAR(MAX) NULL, 
    [SecurityStamp] VARCHAR(MAX) NULL
);

CREATE TABLE [dbo].[UserRoles]
(
	[UserId] UNIQUEIDENTIFIER NOT NULL,
	[Role] VARCHAR(100) NOT NULL,

	CONSTRAINT pk_UserRoles PRIMARY KEY (UserId, Role),
	CONSTRAINT fk_UserRoles_Users FOREIGN KEY (UserId) REFERENCES Users(UserId)
);
 

 CREATE TABLE House
 (
	HouseId int identity(1, 1),
	UserId UNIQUEIDENTIFIER, 
	HouseName varchar(50) not null, 
	Basement bit not null, 
	Floors int not null,
	[Length] int not null,
	[Width] int not null,
	SquareFootage float not null, 
	BaseCost decimal not null,
	Region varchar(50), 
	Budget decimal not null, 

	CONSTRAINT pk_HouseId PRIMARY KEY(HouseId),
	CONSTRAINT fk_House_Users FOREIGN KEY(UserId) REFERENCES Users(UserId),

 );

 CREATE TABLE [Floor]
 (
	FloorId int identity(1, 1),
	HouseId int,
	FloorNumber int not null,
	FloorPlan varchar(max), --JSON was recognized as a column data type here. Assuming this will work?
	
	CONSTRAINT pk_FloorId PRIMARY KEY(FloorId),
	CONSTRAINT fk_Floor_House FOREIGN Key(HouseId) REFERENCES House(HouseId),
 );

 CREATE TABLE Materials
 (
	MaterialId int identity(1, 1),
	Material_Type_Item varchar(50) not null, 
	IsMaterial bit, 
	LowPrice decimal (7, 2) not null, 
	MidPrice decimal (7, 2) not null, 
	HighPrice decimal (7, 2) not null,
	ImageSource varchar(75) not null,
	
	CONSTRAINT pk_MaterialId PRIMARY KEY(MaterialId),

 );

INSERT INTO Materials VALUES ('Wood', 1, 1.00, 3.00, 10.00, 'wood.png')
INSERT INTO Materials VALUES ('Carpet (Dark)', 1, 0.50, 2.00, 8.00, 'CARPET-DARK.png')
INSERT INTO Materials VALUES ('Carpet (Light)', 1, 0.50, 2.00, 8.00, 'CARPET-LIGHT.png')
INSERT INTO Materials VALUES ('Tile', 1, 0.80, 2.50, 7.00, 'tile.png')
INSERT INTO Materials VALUES ('Concrete', 1, 1.00, 3.00, 10.00, 'concrete.png')
INSERT INTO Materials VALUES ('Concrete (Light)', 1, 1.00, 3.00, 10.00, 'lighter-concrete.png')
INSERT INTO Materials VALUES ('Plywood', 1, 0.50, 2.00, 8.00, 'plywood.jpg')
INSERT INTO Materials VALUES ('Marble', 1, 3.80, 7.50, 20.00, 'marble.png')

INSERT INTO Materials VALUES ('Couch', 0, 3.80, 7.50, 20.00, 'couch.png')
INSERT INTO Materials VALUES ('Toilet', 0, 3.80, 7.50, 20.00, 'TOILET.png')
INSERT INTO Materials VALUES ('Table', 0, 3.80, 7.50, 20.00, 'COFFEE-table.png')
INSERT INTO Materials VALUES ('Couch (L)', 0, 3.80, 7.50, 20.00, 'SECTIONAL-L.png')
INSERT INTO Materials VALUES ('Couch (R)', 0, 3.80, 7.50, 20.00, 'SECTIONAL-R.png')
INSERT INTO Materials VALUES ('Bathtub', 0, 3.80, 7.50, 20.00, 'tub.png')
INSERT INTO Materials VALUES ('Bed', 0, 3.80, 7.50, 20.00, 'bed.png')

INSERT INTO Materials VALUES ('Tree', 0, 3.80, 7.50, 20.00, 'TREE-1.png')
INSERT INTO Materials VALUES ('Large Tree', 0, 3.80, 7.50, 20.00, 'TREE-2.png')
INSERT INTO Materials VALUES ('Bush', 0, 3.80, 7.50, 20.00, 'BUSH-1.png')



