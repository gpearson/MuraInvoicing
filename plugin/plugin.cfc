/*

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="mura.plugin.plugincfc" {

	property name="config" type="any" default="";

	public any function init(any config='') {
		setConfig(arguments.config);
	}

	public void function install() {
		// triggered by the pluginManager when the plugin is INSTALLED.
		application.appInitialized = false;

		var dbCheckTables = new query();
		dbCheckTables.setDatasource("#application.configBean.getDatasource()#");
		dbCheckTables.setSQL("Show Tables LIKE 'p_inv_Customers'");
		var dbCheckTablesResults = dbCheckTables.execute();

		if (dbCheckTablesResults.getResult().recordcount eq 0) {
			// Since the Database Table does not exists, Lets Create it
			var dbCreateTable = new query();
			dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
			dbCreateTable.setSQL("CREATE TABLE `p_inv_Customers` ( `TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `BusinessName` tinytext NOT NULL, `PhysicalAddress` tinytext NOT NULL, `PhysicalCity` tinytext NOT NULL, `PhysicalState` varchar(2) NOT NULL DEFAULT '', `PhysicalZipCode` varchar(5) NOT NULL DEFAULT '', `PhysicalZip4` varchar(4) DEFAULT '', `MailingAddress` tinytext, `MailingCity` tinytext, `MailingState` tinytext, `MailingZipCode` tinytext, `MailingZip4` tinytext, `PrimaryVoiceNumber` varchar(14) DEFAULT '', `BusinessWebsite` tinytext, `ContactName` tinytext, `ContactPhoneNumber` tinytext, `ContactEmail` tinytext, `dateCreated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdateBy` varchar(50) NOT NULL DEFAULT '', `isAddressVerified` char(1) NOT NULL DEFAULT '0', `FIPS_StateCode` char(2) DEFAULT NULL, `GeoCode_Latitude` varchar(20) DEFAULT NULL, `GeoCode_Longitude` varchar(20) DEFAULT NULL, `GeoCode_Township` varchar(40) DEFAULT NULL, `GeoCode_StateLongName` varchar(40) DEFAULT NULL, `GeoCode_CountryShortName` varchar(40) DEFAULT NULL, `GeoCode_CountyName` tinytext, `GeoCode_CountyNumber` char(5) DEFAULT NULL, `GeoCode_Neighborhood` varchar(40) DEFAULT NULL, `USPS_CarrierRoute` varchar(20) DEFAULT NULL, `USPS_CheckDigit` varchar(20) DEFAULT NULL, `USPS_DeliveryPoint` varchar(20) DEFAULT NULL, `PhysicalLocationCountry` varchar(20) DEFAULT NULL, `PhysicalCountry` varchar(20) DEFAULT NULL, `Active` char(1) NOT NULL DEFAULT '1', `CountyName` tinytext, `CountyNumber` tinytext, `ContactPhoneExt` tinytext, `BusinessFax` tinytext, PRIMARY KEY (`TContent_ID`,`Site_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;");
			var dbCreateTableResults = dbCreateTable.execute();
		} else {
			// Database Table Exists, We must Drop it to create it again
			var dbDropTable = new query();
			dbDropTable.setDatasource("#application.configBean.getDatasource()#");
			dbDropTable.setSQL("DROP TABLE p_inv_Customers");
			var dbDropTableResults = dbDropTable.execute();

			if (len(dbDropTableResults.getResult()) eq 0) {
				var dbCreateTable = new query();
				dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTable.setSQL("CREATE TABLE `p_inv_Customers` ( `TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `BusinessName` tinytext NOT NULL, `PhysicalAddress` tinytext NOT NULL, `PhysicalCity` tinytext NOT NULL, `PhysicalState` varchar(2) NOT NULL DEFAULT '', `PhysicalZipCode` varchar(5) NOT NULL DEFAULT '', `PhysicalZip4` varchar(4) DEFAULT '', `MailingAddress` tinytext, `MailingCity` tinytext, `MailingState` tinytext, `MailingZipCode` tinytext, `MailingZip4` tinytext, `PrimaryVoiceNumber` varchar(14) DEFAULT '', `BusinessWebsite` tinytext, `ContactName` tinytext, `ContactPhoneNumber` tinytext, `ContactEmail` tinytext, `dateCreated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdateBy` varchar(50) NOT NULL DEFAULT '', `isAddressVerified` char(1) NOT NULL DEFAULT '0', `FIPS_StateCode` char(2) DEFAULT NULL, `GeoCode_Latitude` varchar(20) DEFAULT NULL, `GeoCode_Longitude` varchar(20) DEFAULT NULL, `GeoCode_Township` varchar(40) DEFAULT NULL, `GeoCode_StateLongName` varchar(40) DEFAULT NULL, `GeoCode_CountryShortName` varchar(40) DEFAULT NULL, `GeoCode_CountyName` tinytext, `GeoCode_CountyNumber` char(5) DEFAULT NULL, `GeoCode_Neighborhood` varchar(40) DEFAULT NULL, `USPS_CarrierRoute` varchar(20) DEFAULT NULL, `USPS_CheckDigit` varchar(20) DEFAULT NULL, `USPS_DeliveryPoint` varchar(20) DEFAULT NULL, `PhysicalLocationCountry` varchar(20) DEFAULT NULL, `PhysicalCountry` varchar(20) DEFAULT NULL, `Active` char(1) NOT NULL DEFAULT '1', `CountyName` tinytext, `CountyNumber` tinytext, `ContactPhoneExt` tinytext, `BusinessFax` tinytext, PRIMARY KEY (`TContent_ID`,`Site_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;");
				var dbCreateTableResults = dbCreateTable.execute();
			} else {
				 writedump(dbDropTableResults.getResult());
				 abort;
			}
		}

		var dbCheckTables = new query();
		dbCheckTables.setDatasource("#application.configBean.getDatasource()#");
		dbCheckTables.setSQL("Show Tables LIKE 'p_inv_CustomerContacts'");
		var dbCheckTablesResults = dbCheckTables.execute();

		if (dbCheckTablesResults.getResult().recordcount eq 0) {
			// Since the Database Table does not exists, Lets Create it
			var dbCreateTable = new query();
			dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
			dbCreateTable.setSQL("CREATE TABLE `p_inv_CustomerContacts` ( `TContent_ID` int(11) NOT NULL, `Site_ID` varchar(20) NOT NULL, `Customer_ID` int(11) NOT NULL, `Contact_FirstName` tinytext NOT NULL, `Contact_LastName` tinytext NOT NULL, `Contact_Email` tinytext NOT NULL, `Contact_PhoneNumber` tinytext NOT NULL, `Contact_PhoneExtension` tinytext, `PositionHeld` int(11) NOT NULL, PRIMARY KEY (`TContent_ID`,`Site_ID`) ) ENGINE=MyISAM DEFAULT CHARSET=latin1;");
			var dbCreateTableResults = dbCreateTable.execute();
		} else {
			// Database Table Exists, We must Drop it to create it again
			var dbDropTable = new query();
			dbDropTable.setDatasource("#application.configBean.getDatasource()#");
			dbDropTable.setSQL("DROP TABLE p_inv_CustomerContacts");
			var dbDropTableResults = dbDropTable.execute();

			if (len(dbDropTableResults.getResult()) eq 0) {
				var dbCreateTable = new query();
				dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTable.setSQL("CREATE TABLE `p_inv_CustomerContacts` ( `TContent_ID` int(11) NOT NULL, `Site_ID` varchar(20) NOT NULL, `Customer_ID` int(11) NOT NULL, `Contact_FirstName` tinytext NOT NULL, `Contact_LastName` tinytext NOT NULL, `Contact_Email` tinytext NOT NULL, `Contact_PhoneNumber` tinytext NOT NULL, `Contact_PhoneExtension` tinytext, `PositionHeld` int(11) NOT NULL, PRIMARY KEY (`TContent_ID`,`Site_ID`) ) ENGINE=MyISAM DEFAULT CHARSET=latin1;");
				var dbCreateTableResults = dbCreateTable.execute();
			} else {
				 writedump(dbDropTableResults.getResult());
				 abort;
			}
		}

		var dbCheckTables = new query();
		dbCheckTables.setDatasource("#application.configBean.getDatasource()#");
		dbCheckTables.setSQL("Show Tables LIKE 'p_inv_Positions'");
		var dbCheckTablesResults = dbCheckTables.execute();

		if (dbCheckTablesResults.getResult().recordcount eq 0) {
			// Since the Database Table does not exists, Lets Create it
			var dbCreateTable = new query();
			dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
			dbCreateTable.setSQL("CREATE TABLE `p_inv_Positions` ( `TContent_ID` int(11) NOT NULL, `Site_ID` varchar(20) NOT NULL, `PositionHeld` tinytext NOT NULL, `dateCreated` datetime NOT NULL, `lastUpdated` datetime DEFAULT NULL, `lastUpdateBy` tinytext, PRIMARY KEY (`TContent_ID`) ) ENGINE=MyISAM DEFAULT CHARSET=latin1;");
			var dbCreateTableResults = dbCreateTable.execute();
		} else {
			// Database Table Exists, We must Drop it to create it again
			var dbDropTable = new query();
			dbDropTable.setDatasource("#application.configBean.getDatasource()#");
			dbDropTable.setSQL("DROP TABLE p_inv_Positions");
			var dbDropTableResults = dbDropTable.execute();

			if (len(dbDropTableResults.getResult()) eq 0) {
				var dbCreateTable = new query();
				dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTable.setSQL("CREATE TABLE `p_inv_Positions` ( `TContent_ID` int(11) NOT NULL, `Site_ID` varchar(20) NOT NULL, `PositionHeld` tinytext NOT NULL, `dateCreated` datetime NOT NULL, `lastUpdated` datetime DEFAULT NULL, `lastUpdateBy` tinytext, PRIMARY KEY (`TContent_ID`) ) ENGINE=MyISAM DEFAULT CHARSET=latin1;");
				var dbCreateTableResults = dbCreateTable.execute();
			} else {
				 writedump(dbDropTableResults.getResult());
				 abort;
			}
		}
	}

	public void function update() {
		// triggered by the pluginManager when the plugin is UPDATED.
		application.appInitialized = false;
	}

	public void function delete() {
		// triggered by the pluginManager when the plugin is DELETED.
		application.appInitialized = false;

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE pClients");
		var dbDropTableResults = dbDropTable.execute();

		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}
	}

}