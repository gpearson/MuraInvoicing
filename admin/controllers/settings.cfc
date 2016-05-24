/*

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

	</cffunction>

	<cffunction name="positions" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("URL.RecNo")>
			<cfquery name="Session.getPositionTitles" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, Site_ID, PositionTitle, dateCreated, lastUpdated, lastUpdateby, Active
				From p_inv_Positions
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
				Order by PositionTitle
			</cfquery>
		<cfelse>
			<cfquery name="Session.getPositionTitles" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, Site_ID, PositionTitle, dateCreated, lastUpdated, lastUpdateby, Active
				From p_inv_Positions
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
					TContent_ID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_integer">
				Order by PositionTitle
			</cfquery>
		</cfif>

	</cffunction>

	<cffunction name="paymentterms" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>

				<cfquery name="Session.getPaymentTerms" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, Site_ID, PaymentTerms, Active
					From p_inv_PaymentTerms
					Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
					Order by PaymentTerms
				</cfquery>
			</cflock>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
			</cflock>

		</cfif>
	</cffunction>

	<cffunction name="addpositions" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
			</cflock>
			<cfquery name="insertNewPosition" result="insertNewPosition" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Insert into p_inv_Positions(Site_ID, PositionTitle, dateCreated, Active, lastUpdateBy)
				Values(
				<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#FORM.PositionName#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="#FORM.PositionActive#" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
			<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers.positions&UserAction=AddedPosition&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="addpaymentterms" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
			</cflock>
			<cfquery name="insertNewPaymentTerms" result="insertNewPaymentTerms" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Insert into p_inv_PaymentTerms(Site_ID, PaymentTerms, dateCreated, Active, lastUpdateBy)
				Values(
				<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#FORM.PaymentTermName#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
				<cfqueryparam value="#FORM.PaymentTermActive#" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
				)
			</cfquery>
			<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers.paymentterms&UserAction=AddedPaymentTerms&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="updatepositions" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>

				<cfquery name="Session.getPositionTitles" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, Site_ID, PositionTitle, dateCreated, lastUpdated, lastUpdateby, Active
					From p_inv_Positions
					Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
						TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.RecNo#">
				</cfquery>
			</cflock>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
			</cflock>
			<cfquery name="updatePosition" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Update p_inv_Positions
				Set PositionTitle = <cfqueryparam value="#FORM.PositionName#" cfsqltype="cf_sql_varchar">,
					Active = <cfqueryparam value="#FORM.PositionActive#" cfsqltype="cf_sql_bit">,
					lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
				Where TContent_ID = <cfqueryparam value="#FORM.PositionRecNo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers.positions&UserAction=UpdatedPosition&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="updatepaymentterms" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>

				<cfquery name="Session.getPaymentTerms" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, Site_ID, PaymentTerms, dateCreated, lastUpdated, lastUpdateby, Active
					From p_inv_PaymentTerms
					Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
						TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.RecNo#">
				</cfquery>
			</cflock>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="SESSION" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
			</cflock>
			<cfquery name="updatePosition" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Update p_inv_PaymentTerms
				Set PaymentTerms = <cfqueryparam value="#FORM.PaymentTermName#" cfsqltype="cf_sql_varchar">,
					Active = <cfqueryparam value="#FORM.PaymentTermActive#" cfsqltype="cf_sql_bit">,
					lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					lastUpdateBy = <cfqueryparam value="#rc.$.currentUser('userName')#" cfsqltype="cf_sql_varchar">
				Where TContent_ID = <cfqueryparam value="#FORM.PositionRecNo#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers.paymentterms&UserAction=UpdatedPaymentTerms&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
		</cfif>
	</cffunction>

</cfcomponent>
