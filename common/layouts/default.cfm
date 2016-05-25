<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
<cfif not StructKeyExists(request, 'mfw1cssexists') or not request.mfw1cssexists>
  <cfset pluginPath =
    rc.$.globalConfig('context')
    & '/plugins/'
    & rc.pluginConfig.getPackage() />
	<cfsavecontent variable="htmlhead"><cfoutput>
		<link rel="stylesheet" href="#pluginPath#/library/bootstrap/css/bootstrap.css">
		<link rel="stylesheet" href="#pluginPath#/library/bootstrap/css/bootstrap-theme.css">
	    <link rel="stylesheet" href="#pluginPath#/library/jqGrid_5.1.0/css/ui.jqgrid-bootstrap.css" />
		<link rel="stylesheet" href="#pluginPath#/includes/assets/css/murafw1.css">
		<script type="text/ecmascript" src="#pluginPath#/library/jqGrid_5.1.0/js/i18n/grid.locale-en.js"></script>
	    <script type="text/ecmascript" src="#pluginPath#/library/jqGrid_5.1.0/js/jquery.jqGrid.min.js"></script>
	</cfoutput></cfsavecontent>
	<cfhtmlhead text="#htmlhead#" />
	<cfset request.mfw1cssexists = true>
</cfif>
</cfsilent>
<cfoutput>#body#</cfoutput>