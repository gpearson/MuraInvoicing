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

	<cffunction name="getAllPositionTitles" access="remote" returnformat="json">
		<cfargument name="page" required="no" default="1" hint="Page user is on">
		<cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
		<cfargument name="sidx" required="no" default="" hint="Sort Column">
		<cfargument name="sord" required="no" default="ASC" hint="Sort Order">

		<cfset var arrPositions = ArrayNew(1)>
		<cfquery name="getPositions" dbtype="Query">
			Select TContent_ID, Site_ID, PositionTitle, dateCreated, lastUpdated, lastUpdateby, Active
			From Session.getPositionTitles
			<cfif Arguments.sidx NEQ "">
				Order By #Arguments.sidx# #Arguments.sord#
			<cfelse>
				Order by BusinessName #Arguments.sord#
			</cfif>
		</cfquery>

		<!--- Calculate the Start Position for the loop query. So, if you are on 1st page and want to display 4 rows per page, for first page you start at: (1-1)*4+1 = 1.
				If you go to page 2, you start at (2-)1*4+1 = 5 --->
		<cfset start = ((arguments.page-1)*arguments.rows)+1>

		<!--- Calculate the end row for the query. So on the first page you go from row 1 to row 4. --->
		<cfset end = (start-1) + arguments.rows>

		<!--- When building the array --->
		<cfset i = 1>

		<cfloop query="getPositions" startrow="#start#" endrow="#end#">
			<!--- Array that will be passed back needed by jqGrid JSON implementation --->
			<cfif #Active# EQ 1>
				<cfset strActive = "Yes">
			<cfelse>
				<cfset strActive = "No">
			</cfif>
			<cfset arrPositions[i] = [#TContent_ID#,#PositionTitle#,#dateCreated#,#lastUpdated#,#lastUpdateby#,#strActive#]>
			<cfset i = i + 1>
		</cfloop>

		<!--- Calculate the Total Number of Pages for your records. --->
		<cfset totalPages = Ceiling(getPositions.recordcount/arguments.rows)>

		<!--- The JSON return.
			Total - Total Number of Pages we will have calculated above
			Page - Current page user is on
			Records - Total number of records
			rows = our data
		--->
		<cfset stcReturn = {total=#totalPages#,page=#Arguments.page#,records=#getPositions.recordcount#,rows=arrPositions}>
		<cfreturn stcReturn>
	</cffunction>

	<cffunction name="getAllPaymentTerms" access="remote" returnformat="json">
		<cfargument name="page" required="no" default="1" hint="Page user is on">
		<cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
		<cfargument name="sidx" required="no" default="" hint="Sort Column">
		<cfargument name="sord" required="no" default="ASC" hint="Sort Order">

		<cfset var arrPaymentTerms = ArrayNew(1)>
		<cfquery name="getPaymentTerms" dbtype="Query">
			Select TContent_ID, Site_ID, PaymentTerms, Active, dateCreated, lastUpdated, lastUpdateBy
			From Session.getPaymentTerms
			<cfif Arguments.sidx NEQ "">
				Order By #Arguments.sidx# #Arguments.sord#
			<cfelse>
				Order by BusinessName #Arguments.sord#
			</cfif>
		</cfquery>

		<!--- Calculate the Start Position for the loop query. So, if you are on 1st page and want to display 4 rows per page, for first page you start at: (1-1)*4+1 = 1.
				If you go to page 2, you start at (2-)1*4+1 = 5 --->
		<cfset start = ((arguments.page-1)*arguments.rows)+1>

		<!--- Calculate the end row for the query. So on the first page you go from row 1 to row 4. --->
		<cfset end = (start-1) + arguments.rows>

		<!--- When building the array --->
		<cfset i = 1>

		<cfloop query="getPaymentTerms" startrow="#start#" endrow="#end#">
			<!--- Array that will be passed back needed by jqGrid JSON implementation --->
			<cfif #Active# EQ 1>
				<cfset strActive = "Yes">
			<cfelse>
				<cfset strActive = "No">
			</cfif>
			<cfset arrPaymentTerms[i] = [#TContent_ID#,#PaymentTerms#,#dateCreated#,#lastUpdated#,#lastUpdateby#,#strActive#]>
			<cfset i = i + 1>
		</cfloop>

		<!--- Calculate the Total Number of Pages for your records. --->
		<cfset totalPages = Ceiling(getPaymentTerms.recordcount/arguments.rows)>

		<!--- The JSON return.
			Total - Total Number of Pages we will have calculated above
			Page - Current page user is on
			Records - Total number of records
			rows = our data
		--->
		<cfset stcReturn = {total=#totalPages#,page=#Arguments.page#,records=#getPaymentTerms.recordcount#,rows=arrPaymentTerms}>
		<cfreturn stcReturn>
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
					Select TContent_ID, Site_ID, PaymentTerms, Active, dateCreated, lastUpdated, lastUpdateBy
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
			<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:settings.positions&UserAction=AddedPosition&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
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
			<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:settings.paymentterms&UserAction=AddedPaymentTerms&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
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
			<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:settings.positions&UserAction=UpdatedPosition&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
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
			<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:settings.paymentterms&UserAction=UpdatedPaymentTerms&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
		</cfif>
	</cffunction>

</cfcomponent>
