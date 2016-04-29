/*

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfquery name="Session.getBusiness" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, BusinessName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, dateCreated, lastUpdated, lastUpdateBy, Site_ID, Active
			From p_inv_Customers
			Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
			Order by BusinessName
		</cfquery>
	</cffunction>

	<cffunction name="GeoCodeAddress" ReturnType="Array" Output="False">
		<cfargument name="Address" type="String" required="True">
		<cfargument name="City" type="String" required="True">
		<cfargument name="State" type="String" required="True">
		<cfargument name="ZipCode" type="String" required="True">

		<cfset GeoCodeStreetAddress = #Replace(Trim(Arguments.Address), " ", "+", "ALL")#>
		<cfset GeoCodeCity = #Replace(Trim(Arguments.City), " ", "+", "ALL")#>
		<cfset GeoCodeState = #Replace(Trim(Arguments.State), " ", "+", "ALL")#>
		<cfset GeoCodeZipCode = #Trim(Arguments.ZipCode)#>

		<cfset GeoCodeAddress = ArrayNew(1)>
		<cfset Temp = StructNew()>

		<cfhttp URL="http://maps.google.com/maps/api/geocode/xml?address=#Variables.GeoCodeStreetAddress#,+#Variables.GeoCodeCity#,+#Variables.GeoCodeState#,+#Variables.GeoCodeZipCode#&sensor=false" method="Get" result="GetCodePageContent" resolveurl="true"></cfhttp>

		<cfif GetCodePageContent.FileContent Contains "REQUEST_DENIED">
			<cfset Temp.ErrorMessage = "Google Request Denied">
			<cfset Temp.AddressStreetNumber = "">
			<cfset Temp.AddressStreetName = "">
			<cfset Temp.AddressCityName = "">
			<cfset Temp.AddressStateNameLong = "">
			<cfset Temp.AddressStateNameShort = "">
			<cfset Temp.AddressZipCode = "">
			<cfset Temp.AddressTownshipName = "">
			<cfset Temp.AddressNeighborhoodName = "">
			<cfset Temp.AddressCountyName = "">
			<cfset Temp.AddressCountryNameLong = "">
			<cfset Temp.AddressCountryNameShort = "">
			<cfset Temp.AddressLatitude = "">
			<cfset Temp.AddressLongitude = "">
			<cfset #arrayAppend(GeoCodeAddress, Temp)#>
		</cfif>

		<cfset XMLDocument = #XMLParse(GetCodePageContent.FileContent)#>
		<cfset GeoCodeResponseStatus = #XMLSearch(Variables.XMLDocument, "/GeocodeResponse/status")#>
		<cfset GeoCodeResultFormattedAddressType = #XmlSearch(Variables.XMLDocument, "/GeocodeResponse/result/type")#>
		<cfset GeoCodeResultFormattedAddress = #XmlSearch(Variables.XMLDocument, "/GeocodeResponse/result/formatted_address")#>
		<cfset GeoCodeResultAddressComponent = #XMLSearch(Variables.XMLDocument, "/GeocodeResponse/result/address_component")#>
		<cfset GeoCodeResultGeometryComponent = #XMLSearch(XMLDocument, "/GeocodeResponse/result/geometry")#>

		<cfswitch expression="#GeoCodeResponseStatus[1].XMLText#">
			<cfcase value="ZERO_RESULTS">
				<!--- Indicates that the geocode was successful but returned no results. This may occur if the geocode was passed a non-existent address
						or latlng in a remote location --->
			</cfcase>
			<cfcase value="OVER_QUERY_LIMIT">
				<!--- Indicates that you are over your quota --->
			</cfcase>
			<cfcase value="REQUEST_DENIED">
				<!--- Indicates that your request was denied, generally becasue of lack of a sensor parameter --->
			</cfcase>
			<cfcase value="INVALID_REQUEST">
				<!--- generally indicates that the query (address or latlng) is missing --->
			</cfcase>
			<cfcase value="UNKNOWN_ERROR">
				<!--- Indicates that the request could not be processed do to a server error. The request may sicceed if you try again --->
			</cfcase>
			<cfcase value="OK">
				<cfswitch expression="#GeoCodeResultFormattedAddressType[1].XMLText#">
					<cfcase value="route">
						<cfset Temp.ErrorMessage = "Unable Locate Address">
						<cfset Temp.ErrorMessageText = "Unable to locate the address you entered as a valid address.">
						<cfset Temp.Address = #Arguments.Address#>
						<cfset Temp.City = #Arguments.City#>
						<cfset Temp.State = #Arguments.State#>
						<cfset Temp.ZipCode = #Arguments.ZipCode#>
						<cfset #arrayAppend(GeoCodeAddress, Temp)#>
						<cfreturn GeoCodeAddress>
					</cfcase>
					<cfcase value="street_address">
						<cfswitch expression="#ArrayLen(GeoCodeResultAddressComponent)#">
							<cfcase value="10">
								<!--- Address Example: 57405 Horseshoe Court, Goshen, IN 46528 --->
								<cfscript>
									GeoCodeResultStreetNumber = GeoCodeResultAddressComponent[1].XmlChildren;
									GeoCodeResultStreetName = GeoCodeResultAddressComponent[2].XmlChildren;
									GeoCodeResultNeighborhoodName = GeoCodeResultAddressComponent[3].XmlChildren;
									GeoCodeResultCityName = GeoCodeResultAddressComponent[4].XmlChildren;
									GeoCodeResultTownshipName = GeoCodeResultAddressComponent[5].XmlChildren;
									GeoCodeResultCountyName = GeoCodeResultAddressComponent[6].XmlChildren;
									GeoCodeResultStateName = GeoCodeResultAddressComponent[7].XmlChildren;
									GeoCodeResultCountryName = GeoCodeResultAddressComponent[8].XmlChildren;
									GeoCodeResultZipCode = GeoCodeResultAddressComponent[9].XmlChildren;
									GeoCodeResultZipCodeSuffix = GeoCodeResultAddressComponent[10].XmlChildren;
									GeoCodeAddressLocation = GeoCodeResultGeometryComponent[1].XmlChildren;
									GeoCodeFormattedAddress = GeoCodeResultFormattedAddress[1].XmlText;
								</cfscript>
								<cfset Temp.RawInformation = StructNew()>
								<cfset Temp.RawInformation.XMLDocument = #Variables.XMLDocument#>
								<cfset Temp.RawInformation.ResponseStatus = #Variables.GeoCodeResponseStatus#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddressType = #Variables.GeoCodeResultFormattedAddressType#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddress = #Variables.GeoCodeResultFormattedAddress#>
								<cfset Temp.RawInformation.GeoCodeResultAddressComponent = #Variables.GeoCodeResultAddressComponent#>
								<cfset Temp.RawInformation.GeoCodeResultGeometryComponent = #Variables.GeoCodeResultGeometryComponent#>
								<cfset Temp.ErrorMessage = #GeoCodeResponseStatus[1].XMLText#>
								<cfset Temp.AddressStreetNumber = #GeoCodeResultStreetNumber[1].XMLText#>
								<cfset Temp.AddressStreetNameLong = #GeoCodeResultStreetName[1].XMLText#>
								<cfset Temp.AddressStreetNameShort = #GeoCodeResultStreetName[2].XMLText#>
								<cfset Temp.AddressStreetNameType = #GeoCodeResultStreetName[3].XMLText#>
								<cfset Temp.AddressCityName = #GeoCodeResultCityName[1].XMLText#>
								<cfset Temp.AddressCountyNameLong = #GeoCodeResultCountyName[1].XMLText#>
								<cfset Temp.AddressCountyNameShort = #GeoCodeResultCountyName[2].XMLText#>
								<cfset Temp.AddressStateNameLong = #GeoCodeResultStateName[1].XMLText#>
								<cfset Temp.AddressStateNameShort = #GeoCodeResultStateName[2].XMLText#>
								<cfset Temp.AddressCountryNameLong = #GeoCodeResultCountryName[1].XMLText#>
								<cfset Temp.AddressCountryNameShort = #GeoCodeResultCountryName[2].XMLText#>
								<cfset Temp.AddressZipCode = #GeoCodeResultZipCode[1].XMLText#>
								<cfset Temp.AddressZipCodeFour = #GeoCodeResultZipCodeSuffix[1].XMLText#>
								<cfset Temp.AddressLocation = #GeoCodeAddressLocation[1].XMLChildren#>
								<cfset Temp.AddressLatitude = #Temp.AddressLocation[1].XMLText#>
								<cfset Temp.AddressLongitude = #Temp.AddressLocation[2].XMLText#>
								<cfset Temp.AddressTownshipNameLong = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.AddressTownshipNameShort = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.NeighborhoodNameLong = #GeoCodeResultNeighborhoodName[1].XMLText#>
								<cfset Temp.NeighborhoodNameShort = #GeoCodeResultNeighborhoodName[2].XMLText#>
								<cfset #arrayAppend(GeoCodeAddress, Temp)#>
							</cfcase>
							<cfcase value="9">
								<!--- Address Example: 56535 Magnetic Drive, Mishwaka, IN 46545 --->
								<!--- Address Example: 2307 Edison Road, South Bend, IN 46615 --->
								<cfscript>
									GeoCodeResultStreetNumber = GeoCodeResultAddressComponent[1].XmlChildren;
									GeoCodeResultStreetName = GeoCodeResultAddressComponent[2].XmlChildren;
									GeoCodeResultCityName = GeoCodeResultAddressComponent[3].XmlChildren;
									GeoCodeResultTownshipName = GeoCodeResultAddressComponent[4].XmlChildren;
									GeoCodeResultCountyName = GeoCodeResultAddressComponent[5].XmlChildren;
									GeoCodeResultStateName = GeoCodeResultAddressComponent[6].XmlChildren;
									GeoCodeResultCountryName = GeoCodeResultAddressComponent[7].XmlChildren;
									GeoCodeResultZipCode = GeoCodeResultAddressComponent[8].XmlChildren;
									GeoCodeResultZipCodeSuffix = GeoCodeResultAddressComponent[9].XmlChildren;
									GeoCodeAddressLocation = GeoCodeResultGeometryComponent[1].XmlChildren;
									GeoCodeFormattedAddress = GeoCodeResultFormattedAddress[1].XmlText;
								</cfscript>

								<cfset Temp.RawInformation = StructNew()>
								<cfset Temp.RawInformation.XMLDocument = #Variables.XMLDocument#>
								<cfset Temp.RawInformation.ResponseStatus = #Variables.GeoCodeResponseStatus#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddressType = #Variables.GeoCodeResultFormattedAddressType#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddress = #Variables.GeoCodeResultFormattedAddress#>
								<cfset Temp.RawInformation.GeoCodeResultAddressComponent = #Variables.GeoCodeResultAddressComponent#>
								<cfset Temp.RawInformation.GeoCodeResultGeometryComponent = #Variables.GeoCodeResultGeometryComponent#>
								<cfset Temp.ErrorMessage = #GeoCodeResponseStatus[1].XMLText#>
								<cfset Temp.AddressStreetNumber = #GeoCodeResultStreetNumber[1].XMLText#>
								<cfset Temp.AddressStreetNameLong = #GeoCodeResultStreetName[1].XMLText#>
								<cfset Temp.AddressStreetNameShort = #GeoCodeResultStreetName[2].XMLText#>
								<cfset Temp.AddressStreetNameType = #GeoCodeResultStreetName[3].XMLText#>
								<cfset Temp.AddressCityName = #GeoCodeResultCityName[1].XMLText#>
								<cfset Temp.AddressTownshipNameLong = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.AddressTownshipNameShort = #GeoCodeResultTownshipName[2].XMLText#>
								<cfset Temp.AddressCountyNameLong = #GeoCodeResultCountyName[1].XMLText#>
								<cfset Temp.AddressCountyNameShort = #GeoCodeResultCountyName[2].XMLText#>
								<cfset Temp.AddressStateNameLong = #GeoCodeResultStateName[1].XMLText#>
								<cfset Temp.AddressStateNameShort = #GeoCodeResultStateName[2].XMLText#>
								<cfset Temp.AddressCountryNameLong = #GeoCodeResultCountryName[1].XMLText#>
								<cfset Temp.AddressCountryNameShort = #GeoCodeResultCountryName[2].XMLText#>
								<cfset Temp.AddressZipCode = #GeoCodeResultZipCode[1].XMLText#>
								<cfset Temp.AddressZipCodeFour = #GeoCodeResultZipCodeSuffix[1].XMLText#>
								<cfset Temp.AddressLocation = #GeoCodeAddressLocation[1].XMLChildren#>
								<cfset Temp.AddressLatitude = #Temp.AddressLocation[1].XMLText#>
								<cfset Temp.AddressLongitude = #Temp.AddressLocation[2].XMLText#>
								<cfset #arrayAppend(GeoCodeAddress, Temp)#>
							</cfcase>
							<cfcase value="8">
								<!--- Address Example: 410 N First St, Argos IN 46501 --->
								<cfscript>
									GeoCodeResultStreetNumber = GeoCodeResultAddressComponent[1].XmlChildren;
									GeoCodeResultStreetName = GeoCodeResultAddressComponent[2].XmlChildren;
									GeoCodeResultCityName = GeoCodeResultAddressComponent[3].XmlChildren;
									GeoCodeResultTownshipName = GeoCodeResultAddressComponent[4].XmlChildren;
									GeoCodeResultCountyName = GeoCodeResultAddressComponent[5].XmlChildren;
									GeoCodeResultStateName = GeoCodeResultAddressComponent[6].XmlChildren;
									GeoCodeResultCountryName = GeoCodeResultAddressComponent[7].XmlChildren;
									GeoCodeResultZipCode = GeoCodeResultAddressComponent[8].XmlChildren;
									GeoCodeAddressLocation = GeoCodeResultGeometryComponent[1].XmlChildren;
									GeoCodeFormattedAddress = GeoCodeResultFormattedAddress[1].XmlText;
								</cfscript>
								<cfset Temp.RawInformation = StructNew()>
								<cfset Temp.RawInformation.XMLDocument = #Variables.XMLDocument#>
								<cfset Temp.RawInformation.ResponseStatus = #Variables.GeoCodeResponseStatus#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddressType = #Variables.GeoCodeResultFormattedAddressType#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddress = #Variables.GeoCodeResultFormattedAddress#>
								<cfset Temp.RawInformation.GeoCodeResultAddressComponent = #Variables.GeoCodeResultAddressComponent#>
								<cfset Temp.RawInformation.GeoCodeResultGeometryComponent = #Variables.GeoCodeResultGeometryComponent#>
								<cfset Temp.ErrorMessage = #GeoCodeResponseStatus[1].XMLText#>
								<cfset Temp.AddressStreetNumber = #GeoCodeResultStreetNumber[1].XMLText#>
								<cfset Temp.AddressStreetNameLong = #GeoCodeResultStreetName[1].XMLText#>
								<cfset Temp.AddressStreetNameShort = #GeoCodeResultStreetName[2].XMLText#>
								<cfset Temp.AddressStreetNameType = #GeoCodeResultStreetName[3].XMLText#>
								<cfset Temp.AddressCityName = #GeoCodeResultCityName[1].XMLText#>
								<cfset Temp.AddressTownshipNameLong = #GeoCodeResultTownshipName[1].XMLText#>
								<cfset Temp.AddressTownshipNameShort = #GeoCodeResultTownshipName[2].XMLText#>
								<cfset Temp.AddressCountyNameLong = #GeoCodeResultCountyName[1].XMLText#>
								<cfset Temp.AddressCountyNameShort = #GeoCodeResultCountyName[2].XMLText#>
								<cfset Temp.AddressStateNameLong = #GeoCodeResultStateName[1].XMLText#>
								<cfset Temp.AddressStateNameShort = #GeoCodeResultStateName[2].XMLText#>
								<cfset Temp.AddressCountryNameLong = #GeoCodeResultCountryName[1].XMLText#>
								<cfset Temp.AddressCountryNameShort = #GeoCodeResultCountryName[2].XMLText#>
								<cfset Temp.AddressZipCode = #GeoCodeResultZipCode[1].XMLText#>
								<cfset Temp.AddressZipCodeFour = "">
								<cfset Temp.AddressLocation = #GeoCodeAddressLocation[1].XMLChildren#>
								<cfset Temp.AddressLatitude = #Temp.AddressLocation[1].XMLText#>
								<cfset Temp.AddressLongitude = #Temp.AddressLocation[2].XMLText#>
								<cfset #arrayAppend(GeoCodeAddress, Temp)#>
							</cfcase>
							<cfdefaultcase>
								<cfscript>
									GeoCodeResultStreetNumber = GeoCodeResultAddressComponent[1].XmlChildren;
									GeoCodeResultStreetName = GeoCodeResultAddressComponent[2].XmlChildren;
									GeoCodeResultCityName = GeoCodeResultAddressComponent[3].XmlChildren;
									GeoCodeResultCountyName = GeoCodeResultAddressComponent[4].XmlChildren;
									GeoCodeResultStateName = GeoCodeResultAddressComponent[5].XmlChildren;
									GeoCodeResultCountryName = GeoCodeResultAddressComponent[6].XmlChildren;
									GeoCodeResultZipCode = GeoCodeResultAddressComponent[7].XmlChildren;
									GeoCodeAddressLocation = GeoCodeResultGeometryComponent[1].XmlChildren;
									GeoCodeFormattedAddress = GeoCodeResultFormattedAddress[1].XmlText;
								</cfscript>

								<cfset Temp.RawInformation = StructNew()>
								<cfset Temp.RawInformation.XMLDocument = #Variables.XMLDocument#>
								<cfset Temp.RawInformation.ResponseStatus = #Variables.GeoCodeResponseStatus#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddressType = #Variables.GeoCodeResultFormattedAddressType#>
								<cfset Temp.RawInformation.GeoCodeResultFormattedAddress = #Variables.GeoCodeResultFormattedAddress#>
								<cfset Temp.RawInformation.GeoCodeResultAddressComponent = #Variables.GeoCodeResultAddressComponent#>
								<cfset Temp.RawInformation.GeoCodeResultGeometryComponent = #Variables.GeoCodeResultGeometryComponent#>
								<cfset Temp.ErrorMessage = #GeoCodeResponseStatus[1].XMLText#>
								<cfset Temp.AddressStreetNumber = #GeoCodeResultStreetNumber[1].XMLText#>
								<cfset Temp.AddressStreetNameLong = #GeoCodeResultStreetName[1].XMLText#>
								<cfset Temp.AddressStreetNameShort = #GeoCodeResultStreetName[2].XMLText#>
								<cfset Temp.AddressStreetNameType = #GeoCodeResultStreetName[3].XMLText#>
								<cfset Temp.AddressCityName = #GeoCodeResultCityName[1].XMLText#>
								<cfset Temp.AddressCountyNameLong = #GeoCodeResultCountyName[1].XMLText#>
								<cfset Temp.AddressCountyNameShort = #GeoCodeResultCountyName[2].XMLText#>
								<cfset Temp.AddressStateNameLong = #GeoCodeResultStateName[1].XMLText#>
								<cfset Temp.AddressStateNameShort = #GeoCodeResultStateName[2].XMLText#>
								<cfset Temp.AddressCountryNameLong = #GeoCodeResultCountryName[1].XMLText#>
								<cfset Temp.AddressCountryNameShort = #GeoCodeResultCountryName[2].XMLText#>
								<cfset Temp.AddressZipCode = #GeoCodeResultZipCode[1].XMLText#>
								<cfset Temp.AddressLocation = #GeoCodeAddressLocation[1].XMLChildren#>
								<cfset Temp.AddressLatitude = #Temp.AddressLocation[1].XMLText#>
								<cfset Temp.AddressLongitude = #Temp.AddressLocation[2].XMLText#>
								<cfset Temp.AddressTownshipNameLong = "">
								<cfset Temp.AddressTownshipNameShort = "">
								<cfset Temp.NeighborhoodNameLong = "">
								<cfset Temp.NeighborhoodNameShort = "">
								<cfset #arrayAppend(GeoCodeAddress, Temp)#>
							</cfdefaultcase>
						</cfswitch>
					</cfcase>
					<cfcase value="postal_code">
						<cfset Temp.ErrorMessage = "Unable Locate Address">
						<cfset Temp.ErrorMessageText = "Unable to locate the address you entered as a valid address.">
						<cfset Temp.Address = #Arguments.Address#>
						<cfset Temp.City = #Arguments.City#>
						<cfset Temp.State = #Arguments.State#>
						<cfset Temp.ZipCode = #Arguments.ZipCode#>
						<cfset #arrayAppend(GeoCodeAddress, Temp)#>
						<cfreturn GeoCodeAddress>
					</cfcase>
					<cfdefaultcase>
						<cfoutput>#GeoCodeResultFormattedAddressType[1].XMLText#</cfoutput><hr>
						<cfdump var="#XMLDocument#">
						<cfdump var="#GeoCodeResponseStatus#">
						<cfdump var="#GeoCodeResultFormattedAddressType#">
						<cfdump var="#GeoCodeResultFormattedAddress#">
						<cfabort>
					</cfdefaultcase>
				</cfswitch>
			</cfcase>
		</cfswitch>
		<cfreturn GeoCodeAddress>
	</cffunction>

	<cffunction name="newcustomer" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
			</cflock>
			<cfset AddressGeoCoded = #GeoCodeAddress(Form.BusinessAddress, FORM.BusinessCity, FORM.BusinessState, FORM.BusinessZipCode)#>
			<cfif AddressGeoCoded[1].ErrorMessage NEQ "OK">
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
						arrayAppend(Session.FormErrors, address);
					</cfscript>
				</cflock>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers.newcustomer&PerformAction=ReEnterAddress&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			<cfelse>
				<cfset CombinedPhysicalAddress = #AddressGeoCoded[1].AddressStreetNumber# & " " & #AddressGeoCoded[1].AddressStreetNameShort#>
				<cfquery name="insertNewBusiness" result="insertNewBusiness" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into p_inv_Customers(BusinessName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, dateCreated, lastUpdated, lastUpdateBy, Site_ID)
					Values("#FORM.BusinessName#", "#Variables.CombinedPhysicalAddress#", "#Trim(Variables.AddressGeoCoded[1].AddressCityName)#", "#Trim(Variables.AddressGeoCoded[1].AddressStateNameShort)#", "#Trim(Variables.AddressGeoCoded[1].AddressZipCode)#", "#Trim(Variables.AddressGeoCoded[1].AddressZipCodeFour)#", #Now()#, #Now()#, "#rc.$.currentUser('userName')#", "#rc.$.siteConfig('siteID')#")
				</cfquery>
				<cfset newRecordID = insertNewBusiness.generatedkey>
				<cfquery name="updateFacilityGeoCode" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_inv_Customers
					Set GeoCode_Latitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLatitude)#" cfsqltype="cf_sql_varchar">,
						GeoCode_Longitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLongitude)#" cfsqltype="cf_sql_varchar">,
						<cfif isDefined("Variables.AddressGeoCoded[1].AddressTownshipNameLong")>
							GeoCode_Township = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressTownshipNameLong)#" cfsqltype="cf_sql_varchar">,
						</cfif>
						<cfif isDefined("Variables.AddressGeoCoded[1].NeighborhoodNameLong")>
							GeoCode_Neighborhood = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].NeighborhoodNameLong)#" cfsqltype="cf_sql_varchar">,
						</cfif>
						GeoCode_StateLongName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameLong)#" cfsqltype="cf_sql_varchar">,
						GeoCode_CountryShortName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressCountryNameShort)#" cfsqltype="cf_sql_varchar">,
						isAddressVerified = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
						Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
						lastUpdated = #Now()#, lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
					Where TContent_ID = <cfqueryparam value="#variables.newRecordID#" cfsqltype="cf_sql_integer"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif LEN(FORM.BusinessVoice)>
					<cfquery name="updateVendorPrimaryNumber" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_inv_Customers
						Set PrimaryVoiceNumber = <cfqueryparam value="#FORM.BusinessVoice#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#variables.newRecordID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.BusinessFax)>
					<cfquery name="updateVendorPrimaryNumber" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_inv_Customers
						Set BusinessFax = <cfqueryparam value="#FORM.BusinessFax#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#variables.newRecordID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.BusinessWebsite)>
					<cfquery name="updateVendorBusinessWebsite" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_inv_Customers
						Set BusinessWebsite = <cfqueryparam value="#FORM.BusinessWebsite#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#variables.newRecordID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.MailingAddress)>
					<cfquery name="updateBusinessMailingAddress" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_inv_Customers
						Set MailingAddress = <cfqueryparam value="#FORM.MailingAddress#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#variables.newRecordID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.MailingCity)>
					<cfquery name="updateBusinessMailingCity" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_inv_Customers
						Set MailingCity = <cfqueryparam value="#FORM.MailingCity#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#variables.newRecordID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.MailingState)>
					<cfquery name="updateBusinessMailingState" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_inv_Customers
						Set MailingState = <cfqueryparam value="#FORM.MailingState#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#variables.newRecordID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cfif LEN(FORM.MailingZipCode)>
					<cfquery name="updateBusinessMailingZipCode" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_inv_Customers
						Set MailingZipCode = <cfqueryparam value="#FORM.MailingZipCode#" cfsqltype="cf_sql_varchar">
						Where TContent_ID = <cfqueryparam value="#variables.newRecordID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers&UserAction=AddedCustomer&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updatecustomer" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfif not isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif not isDefined("Session.FormErrors")>
					<cfset Session.FormErrors = #ArrayNew()#>
				</cfif>
			</cflock>
			<cfquery name="Session.getBusiness" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, BusinessName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, MailingAddress, MailingCity, MailingState, MailingZipCode, dateCreated, PrimaryVoiceNumber, BusinessWebsite, BusinessFax, lastUpdated, lastUpdateBy, Site_ID, Active, PaymentTerms, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_CountyName
				From p_inv_Customers
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.RecNo#">
				Order by BusinessName
			</cfquery>

			<cfquery name="Session.getPaymentTerms" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, PaymentTerms, dateCreated, lastUpdated, lastUpdateBy, Active
				From p_inv_PaymentTerms
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
					Active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
				Order by PaymentTerms
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfif isDefined("URL.PerformAction")>
				<cfswitch expression="#URL.PerformAction#">
					<cfcase value="Delete">
						<cfif isDefined("form.formSubmit") and isDefined("FORM.CustomerRecID")>
							<cfquery name="DeactivateCustomer" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_inv_Customers
								Set Active = 0
								Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
									TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.CustomerRecID#">
							</cfquery>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers&UserAction=DeletedCustomer&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
						</cfif>
					</cfcase>
					<cfcase value="Edit">
						<cfquery name="Session.getSelectedClient" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select TContent_ID, BusinessName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, MailingAddress, MailingCity, MailingState, MailingZipCode, dateCreated, PrimaryVoiceNumber, BusinessWebsite, BusinessFax, lastUpdated, lastUpdateBy, Site_ID, Active, PaymentTerms
							From p_inv_Customers
							Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
								TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.CustomerRecID#">
							Order by BusinessName
						</cfquery>

						<cfif FORM.PaymentTerms EQ "----">
							<cflock timeout="60" scope="SESSION" type="Exclusive">
								<cfset Session.FormErrors = #ArrayNew()#>
								<cfscript>
									address = {property="PaymentTerms",message="Please Select Payment Terms for this Customer"};
									arrayAppend(Session.FormErrors, address);
								</cfscript>
							</cflock>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers.updatecustomer&PerformAction=Edit&ActionItem=MissingInfo&SiteID=#rc.$.siteConfig('siteID')#&RecNo=#FORM.CustomerRecID#" addtoken="true">
						</cfif>

						<cfif FORM.Active EQ "----">
							<cflock timeout="60" scope="SESSION" type="Exclusive">
								<cfset Session.FormErrors = #ArrayNew()#>
								<cfscript>
									address = {property="Active",message="Please Select if Business is Active or Not"};
									arrayAppend(Session.FormErrors, address);
								</cfscript>
							</cflock>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers.updatecustomer&PerformAction=Edit&ActionItem=MissingInfo&SiteID=#rc.$.siteConfig('siteID')#&RecNo=#FORM.CustomerRecID#" addtoken="true">
						</cfif>

						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfset Session.FormData = #StructCopy(FORM)#>
						</cflock>
						<cfset UpdateInfo = #StructNew()#>
						<cfparam name="UpdateInfo.NameUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.AddressUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.CityUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.StateUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.ZipCodeUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.VoiceNumberUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.BusinessFaxUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.WebsiteUpdated" type="boolean" default="0">
						<cfparam name="UpdateInfo.BusinessActive" type="boolean" default="0">
						<cfparam name="UpdateInfo.PaymentTerms" type="boolean" default="0">
						<cfparam name="UpdateInfo.MailingAddress" type="boolean" default="0">
						<cfparam name="UpdateInfo.MailingCity" type="boolean" default="0">
						<cfparam name="UpdateInfo.MailingState" type="boolean" default="0">
						<cfparam name="UpdateInfo.MailingZipCode" type="boolean" default="0">

						<cfif Session.getSelectedClient.BusinessName NEQ Form.BusinessName><cfset UpdateInfo.NameUpdated = 1></cfif>
						<cfif Session.getSelectedClient.PhysicalAddress NEQ Form.BusinessAddress><cfset UpdateInfo.AddressUpdated = 1></cfif>
						<cfif Session.getSelectedClient.PhysicalCity NEQ Form.BusinessCity><cfset UpdateInfo.CityUpdated = 1></cfif>
						<cfif Session.getSelectedClient.PhysicalState NEQ Form.BusinessState><cfset UpdateInfo.StateUpdated = 1></cfif>
						<cfif Session.getSelectedClient.PhysicalZipCode NEQ Form.BusinessZipCode><cfset UpdateInfo.ZipCodeUpdated = 1></cfif>
						<cfif Session.getSelectedClient.PrimaryVoiceNumber NEQ Form.BusinessVoice><cfset UpdateInfo.VoiceNumberUpdated = 1></cfif>
						<cfif Session.getSelectedClient.BusinessWebsite NEQ Form.BusinessWebsite><cfset UpdateInfo.WebsiteUpdated = 1></cfif>
						<cfif Session.getSelectedClient.BusinessFax NEQ Form.BusinessFax><cfset UpdateInfo.BusinessFaxUpdated = 1></cfif>
						<cfif Session.getSelectedClient.Active NEQ Form.Active><cfset UpdateInfo.BusinessActive = 1></cfif>
						<cfif Session.getSelectedClient.PaymentTerms NEQ Form.PaymentTerms><cfset UpdateInfo.PaymentTerms = 1></cfif>
						<cfif Session.getSelectedClient.MailingAddress NEQ Form.MailingAddress><cfset UpdateInfo.MailingAddress = 1></cfif>
						<cfif Session.getSelectedClient.MailingCity NEQ Form.MailingCity><cfset UpdateInfo.MailingCity = 1></cfif>
						<cfif Session.getSelectedClient.MailingState NEQ Form.MailingState><cfset UpdateInfo.MailingState = 1></cfif>
						<cfif Session.getSelectedClient.MailingZipCode NEQ Form.MailingZipCode><cfset UpdateInfo.MailingZipCode = 1></cfif>

						<cfif UpdateInfo.AddressUpdated EQ 1 OR UpdateInfo.CityUpdated EQ 1 OR UpdateInfo.StateUpdated EQ 1 OR UpdateInfo.ZipCodeUpdated EQ 1>
							<cfset AddressGeoCoded = #GeoCodeAddress(Form.BusinessAddress, FORM.BusinessCity, FORM.BusinessState, FORM.BusinessZipCode)#>
							<cfif AddressGeoCoded[1].ErrorMessage NEQ "OK">
								<cflock timeout="60" scope="SESSION" type="Exclusive">
									<cfscript>
										address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
										arrayAppend(Session.FormErrors, address);
									</cfscript>
								</cflock>
								<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers.updatecustomer&PerformAction=ReEnterAddress&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
							<cfelse>
								<cfset CombinedPhysicalAddress = #AddressGeoCoded[1].AddressStreetNumber# & " " & #AddressGeoCoded[1].AddressStreetNameShort#>
								<cfquery name="updateFacilityAddress" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_inv_Customers
									Set PhysicalAddress = <cfqueryparam value="#Trim(Variables.CombinedPhysicalAddress)#" cfsqltype="cf_sql_varchar">,
										PhysicalCity = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressCityName)#" cfsqltype="cf_sql_varchar">,
										PhysicalState = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameShort)#" cfsqltype="cf_sql_varchar">,
										PhysicalZipCode = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressZipCode)#" cfsqltype="cf_sql_varchar">
										, lastUpdated = #Now()#, lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										TContent_ID = <cfqueryparam value="#Session.getSelectedClient.TContent_ID#" cfsqltype="cf_sql_integer">
								</cfquery>

								<cfquery name="updateFacilityAddress" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_inv_Customers
									Set GeoCode_Latitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLatitude)#" cfsqltype="cf_sql_varchar">,
										GeoCode_Longitude = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressLongitude)#" cfsqltype="cf_sql_varchar">,
										GeoCode_StateLongName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressStateNameLong)#" cfsqltype="cf_sql_varchar">,
										GeoCode_CountryShortName = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressCountryNameShort)#" cfsqltype="cf_sql_varchar">,
										isAddressVerified = <cfqueryparam value="1" cfsqltype="cf_sql_varchar">,
										PhysicalLocationCountry = <cfqueryparam value="#Trim(AddressGeoCoded[1].AddressCountryNameLong)#" cfsqltype="cf_sql_varchar">
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#Session.getSelectedClient.TContent_ID#" cfsqltype="cf_sql_integer">
								</cfquery>

								<cfif isDefined("Variables.AddressGeoCoded[1].AddressTownshipNameLong")>
									<cfquery name="updateFacilityAddress" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_inv_Customers
										Set GeoCode_Township = <cfqueryparam value="#Trim(Variables.AddressGeoCoded[1].AddressTownshipNameLong)#" cfsqltype="cf_sql_varchar">
										Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#Session.getSelectedClient.TContent_ID#" cfsqltype="cf_sql_integer">
									</cfquery>
								</cfif>
							</cfif>
						</cfif>

						<cfif UpdateInfo.MailingAddress EQ 1 OR UpdateInfo.MailingCity EQ 1 OR UpdateInfo.MailingState EQ 1 OR UpdateInfo.MailingZipCode EQ 1>
							<cfset MailingAddressGeoCoded = #GeoCodeAddress(Form.MailingAddress, FORM.MailingCity, FORM.MailingState, FORM.MailingZipCode)#>
							<cfset CombinedPhysicalAddress = #MailingAddressGeoCoded[1].AddressStreetNumber# & " " & #MailingAddressGeoCoded[1].AddressStreetNameShort#>
							<cfquery name="updateMailingAddress" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_inv_Customers
								Set MailingAddress = <cfqueryparam value="#Trim(Variables.CombinedPhysicalAddress)#" cfsqltype="cf_sql_varchar">,
									MailingCity = <cfqueryparam value="#Trim(Variables.MailingAddressGeoCoded[1].AddressCityName)#" cfsqltype="cf_sql_varchar">,
									MailingState = <cfqueryparam value="#Trim(Variables.MailingAddressGeoCoded[1].AddressStateNameShort)#" cfsqltype="cf_sql_varchar">,
									MailingZipCode = <cfqueryparam value="#Trim(Variables.MailingAddressGeoCoded[1].AddressZipCode)#" cfsqltype="cf_sql_varchar">
									, lastUpdated = #Now()#, lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									TContent_ID = <cfqueryparam value="#Session.getSelectedClient.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>

						<cfif UpdateInfo.BusinessActive EQ 1>
							<cfquery name="updateBusinessActive" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_inv_Customers
								Set Active = <cfqueryparam value="#Trim(Form.Active)#" cfsqltype="cf_sql_bit">,
									lastUpdated = #Now()#,
									lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									TContent_ID = <cfqueryparam value="#Session.getSelectedClient.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>

						<cfif UpdateInfo.PaymentTerms EQ 1>
							<cfquery name="updateFacilityName" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_inv_Customers
								Set PaymentTerms = <cfqueryparam value="#Trim(Form.PaymentTerms)#" cfsqltype="cf_sql_integer">,
									lastUpdated = #Now()#,
									lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									TContent_ID = <cfqueryparam value="#Session.getSelectedClient.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>

						<cfif UpdateInfo.NameUpdated EQ 1>
							<cfquery name="updateFacilityName" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_inv_Customers
								Set BusinessName = <cfqueryparam value="#Trim(Form.BusinessName)#" cfsqltype="cf_sql_varchar">,
									lastUpdated = #Now()#,
									lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									TContent_ID = <cfqueryparam value="#Session.getSelectedClient.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>

						<cfif UpdateInfo.VoiceNumberUpdated EQ 1>
							<cfquery name="updateBusinessPhone" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_inv_Customers
								Set PrimaryVoiceNumber = <cfqueryparam value="#Trim(Form.BusinessVoice)#" cfsqltype="cf_sql_varchar">,
									lastUpdated = #Now()#,
									lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									TContent_ID = <cfqueryparam value="#Session.getSelectedClient.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>

						<cfif UpdateInfo.WebsiteUpdated EQ 1>
							<cfquery name="updateBusinessPhone" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update p_inv_Customers
								Set BusinessWebsite = <cfqueryparam value="#Trim(Form.BusinessWebsite)#" cfsqltype="cf_sql_varchar">,
									lastUpdated = #Now()#,
									lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									TContent_ID = <cfqueryparam value="#Session.getSelectedClient.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
						</cfif>

						<cfif UpdateInfo.AddressUpdated EQ 0 AND UpdateInfo.CityUpdated EQ 0 AND UpdateInfo.StateUpdated EQ 0 AND UpdateInfo.ZipCodeUpdated EQ 0 AND UpdateInfo.NameUpdated EQ 0 AND UpdateInfo.VoiceNumberUpdated EQ 0 AND UpdateInfo.WebsiteUpdated EQ 0 AND UpdateInfo.BusinessFaxUpdated EQ 0 and UpdateInfo.BusinessActive EQ 0 and UpdateInfo.PaymentTerms EQ 0 and UpdateInfo.MailingAddress EQ 1 AND UpdateInfo.MailingCity EQ 1 AND UpdateInfo.MailingState EQ 1 AND UpdateInfo.MailingZipCode EQ 1>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers" addtoken="false">
						<cfelse>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers&UserAction=UpdatedCustomer&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
						</cfif>
					</cfcase>
				</cfswitch>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="contacts" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("URL.RecNo")>
			<cfquery name="Session.getBusiness" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, BusinessName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, dateCreated, lastUpdated, lastUpdateBy, Site_ID, Active
				From p_inv_Customers
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
				Order by BusinessName
			</cfquery>
		<cfelse>
			<cfquery name="Session.getBusiness" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, BusinessName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, dateCreated, lastUpdated, lastUpdateBy, Site_ID, Active
				From p_inv_Customers
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
					TContent_ID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_integer">
				Order by BusinessName
			</cfquery>
		</cfif>


	</cffunction>

	<cffunction name="positions" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("URL.RecNo")>
			<cfquery name="Session.getBusiness" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, BusinessName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, dateCreated, lastUpdated, lastUpdateBy, Site_ID, Active
				From p_inv_Customers
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
				Order by BusinessName
			</cfquery>
		<cfelse>
			<cfquery name="Session.getBusiness" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, BusinessName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, dateCreated, lastUpdated, lastUpdateBy, Site_ID, Active
				From p_inv_Customers
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
					TContent_ID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_integer">
				Order by BusinessName
			</cfquery>
		</cfif>

	</cffunction>

	<cffunction name="paymentterms" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">



	</cffunction>

</cfcomponent>
