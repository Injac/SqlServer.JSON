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
go

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
go
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
go

 insert into jsontest (jsonvalue) values ('{
    "glossary": {
        "workingtitle": "lala",
		"GlossDiv": {
            "title": "Banana Joe",
			"GlossList": {
                "GlossEntry": {
                    "ID": "cool",
					"SortAs": "SGML",
					"GlossTerm": "Standard Generalized Markup Language",
					"Acronym": "SGML",
					"Abbrev": "ISO 8879:1986",
					"GlossDef": {
                        "para": "A meta-markup language, used to create markup languages such as DocBook.",
						"GlossSeeAlso": ["Buddy", "XML"]
                    },
					"GlossSee": "markup"
                }
            }
        }
    }
}');
go

SELECT [jsonvalue].GetDocumentByAttributeValue('GlossSeeAlso','GML') 
  FROM [SQLJSON].[dbo].[jsontest]
  where  jsonvalue.ToString() is not null
go

select jsontest.jsonvalue.ToString() from jsontest;