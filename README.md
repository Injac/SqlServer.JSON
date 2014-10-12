Experiment testing how to handle JSON within SQL-Server 2014
============================================================

The library will add JSON if is valild (it will be parsed) and it will query the current jsondocument for string-atrributes. Currently strings are supported. Later, maybe more.

Two things are important. You need to download he JSON .NET binaries and a add a reference to the JSON .NET 2.0 binary dll. The Newtonsoft.Json DLL (from the 2.0 folder) needs to be added to the database Programmability=>Assemblies before you deploy the project.

Then open the project in VS and execute it on a database you can play with. Check the pre and post-deployment SQL scripts within the solution.

Godd luck!
