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
