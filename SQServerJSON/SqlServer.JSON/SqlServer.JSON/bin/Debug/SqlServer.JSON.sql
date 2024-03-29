﻿/*
Deployment script for SQLJSON

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "SQLJSON"
:setvar DefaultFilePrefix "SQLJSON"
:setvar DefaultDataPath "G:\Program Files\Microsoft SQL Server\MSSQL12.IRONMAN\MSSQL\DATA\"
:setvar DefaultLogPath "G:\Program Files\Microsoft SQL Server\MSSQL12.IRONMAN\MSSQL\DATA\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
IF IS_SRVROLEMEMBER(N'sysadmin') = 1
    BEGIN
        IF EXISTS (SELECT 1
                   FROM   [master].[dbo].[sysdatabases]
                   WHERE  [name] = N'$(DatabaseName)')
            BEGIN
                EXECUTE sp_executesql N'ALTER DATABASE [$(DatabaseName)]
    SET TRUSTWORTHY OFF 
    WITH ROLLBACK IMMEDIATE';
            END
    END
ELSE
    BEGIN
        PRINT N'The database settings cannot be modified. You must be a SysAdmin to apply these settings.';
    END


GO
USE [$(DatabaseName)];


GO
/*
 Pre-Deployment Script Template                            
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be executed before the build script.    
 Use SQLCMD syntax to include a file in the pre-deployment script.            
 Example:      :r .\myfile.sql                                
 Use SQLCMD syntax to reference a variable in the pre-deployment script.        
 Example:      :setvar TableName MyTable                            
               SELECT * FROM [$(TableName)]                    
--------------------------------------------------------------------------------------
*/

alter database SQLJSON set trustworthy on;

EXEC dbo.sp_changedbowner @loginame = N'sa', @map = false

--CREATE ASSEMBLY systemruntime
--FROM 'C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.5.1\System.Runtime.Serialization.dll'
--WITH PERMISSION_SET=UNSAFE

--use sqljson
--go

--CREATE ASSEMBLY diagnostics 
--FROM 'C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.0\System.ComponentModel.Composition.dll'
--WITH PERMISSION_SET=safe

--go

--CREATE ASSEMBLY systemruntime
--FROM 'C:\Windows\Microsoft.NET\assembly\GAC_MSIL\System.Runtime\v4.0_4.0.0.0__b03f5f7f11d50a3a\System.Runtime.dll'
--WITH PERMISSION_SET=safe

--go

--CREATE ASSEMBLY newtonsoftjson
--FROM 'D:\devlibs\DOTNET\JSON.NET\Bin\Portable\Newtonsoft.Json.dll'
--WITH PERMISSION_SET=safe
--go
GO

GO
/*
Post-Deployment Script Template                            
--------------------------------------------------------------------------------------
 This file contains SQL statements that will be appended to the build script.        
 Use SQLCMD syntax to include a file in the post-deployment script.            
 Example:      :r .\myfile.sql                                
 Use SQLCMD syntax to reference a variable in the post-deployment script.        
 Example:      :setvar TableName MyTable                            
               SELECT * FROM [$(TableName)]                    
--------------------------------------------------------------------------------------
*/
IF OBJECT_ID('dbo.jsontest') IS NOT NULL -- this statement check if given table name exists (is not null = exists)

    DROP TABLE dbo.jsontest -- if yes then drop

GO


create table jsontest (jsonvalue dbo.JSON);
GO

insert into jsontest (jsonvalue) values ('{
    "glossary": {
        "workingtitle": "trash",
		"GlossDiv": {
            "title": "Some trash here",
			"GlossList": {
                "GlossEntry": {
                    "ID": "sucks",
					"SortAs": "XML",
					"GlossTerm": "Standard Generalized Markup Language",
					"Acronym": "XML",
					"Abbrev": "ISO 8879:1986",
					"GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
						"GlossSeeAlso": ["GML", "XML"]
                    },
					"GlossSee": "markup"
                }
            }
        }
    }
}');
GO
 insert into jsontest (jsonvalue) values ('{
    "glossary": {
        "workingtitle": "superb",
		"GlossDiv": {
            "title": "Iron Man 2",
			"GlossList": {
                "GlossEntry": {
                    "ID": "fun",
					"SortAs": "SGML",
					"GlossTerm": "Standard Generalized Markup Language",
					"Acronym": "SGML",
					"Abbrev": "ISO 8879:1986",
					"GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
						"GlossSeeAlso": ["GML", "XML"]
                    },
					"GlossSee": "markup"
                }
            }
        }
    }
}');
GO

SELECT [jsonvalue].GetDocumentByAttributeValue('workingtitle','trash') 
  FROM [SQLJSON].[dbo].[jsontest]
  where  jsonvalue.ToString() is not null
GO

select jsontest.jsonvalue.ToString() from jsontest;
GO

GO
PRINT N'Update complete.';


GO
