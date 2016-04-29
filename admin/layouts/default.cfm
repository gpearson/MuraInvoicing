<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
	<cfsavecontent variable="local.errors">
		<cfif StructKeyExists(rc, 'errors') and IsArray(rc.errors) and ArrayLen(rc.errors)>
			<div class="alert alert-error">
				<button type="button" class="close" data-dismiss="alert"><i class="icon-remove-sign"></i></button>
				<h2>Alert!</h2>
				<h3>Please note the following message<cfif ArrayLen(rc.errors) gt 1>s</cfif>:</h3>
				<ul>
					<cfloop from="1" to="#ArrayLen(rc.errors)#" index="local.e">
						<li>
							<cfif IsSimpleValue(rc.errors[local.e])>
								<cfoutput>#rc.errors[local.e]#</cfoutput>
							<cfelse>
								<cfdump var="#rc.errors[local.e]#" />
							</cfif>
						</li>
					</cfloop>
				</ul>
			</div><!--- /.alert --->
		</cfif>
	</cfsavecontent>
	<cfscript>
		param name="rc.compactDisplay" default="false";
		body = local.errors & body;
	</cfscript>
</cfsilent>
<cfsavecontent variable="local.newBody">
	<cfoutput>
		<link rel="stylesheet" href="/plugins/MuraInvoicing/library/bootstrap/css/bootstrap-theme.min.css" crossorigin="anonymous">
		<div class="container-murafw1">

			<!--- PRIMARY NAV --->
			<div class="row-fluid">
				<div class="navbar navbar-murafw1">
					<div class="navbar-inner">

						<a class="plugin-brand" href="#buildURL('admin:main')#">#HTMLEditFormat(rc.pc.getPackage())#</a>

						<ul class="nav">
							<li class="<cfif rc.action contains 'admin:main'>active</cfif>">
								<a href="##" class="dropdown-toggle" data-toggle="dropdown">Main <b class="caret"></b></a>
								<ul class="dropdown-menu">
									<li class="<cfif rc.action eq 'admin:customers.default'>active</cfif>">
										<a href="#buildURL('admin:customers.default')#"><i class="icon-home"></i> Customers</a>
									</li>
									<li class="<cfif rc.action contains 'admin:products'>active</cfif>">
										<a href="#buildURL('admin:products')#"><i class="icon-leaf"></i> Products</a>
									</li>
									<li class="<cfif rc.action contains 'admin:services'>active</cfif>">
										<a href="#buildURL('admin:services')#"><i class="icon-leaf"></i> Services</a>
									</li>
									<li class="<cfif rc.action contains 'admin:users'>active</cfif>">
										<a href="#buildURL('admin:users')#"><i class="icon-leaf"></i> Users</a>
									</li>
								</ul>
							</li>
							<li class="<cfif rc.action contains 'admin:license'>active</cfif>">
								<a href="#buildURL('admin:license')#"><i class="icon-book"></i> License</a>
							</li>
							<li class="<cfif rc.action contains 'admin:instructions'>active</cfif>">
								<a href="#buildURL('admin:instructions')#"><i class="icon-info-sign"></i> Instructions</a>
							</li>
						</ul><!--- /.nav --->

					</div><!--- /.navbar-inner --->
				</div><!--- /.navbar --->
			</div><!--- /.row --->

			<!--- MAIN CONTENT AREA --->
			<div class="row-fluid">
				<cfif rc.action contains 'admin:customers'>
					<!--- SUB-NAV --->
					<div class="span3">
						<ul class="nav nav-list murafw1-sidenav">
							<li class="<cfif rc.action eq 'admin:custoemrs.default'>active</cfif>">
								<a href="#buildURL('admin:main')#"><i class="icon-home"></i> Home</a>
							</li>
							<li class="<cfif rc.action eq 'admin:customers.newcustomer'>active</cfif>">
								<a href="#buildURL('admin:customers.newcustomer')#"><i class="icon-leaf"></i> New Customer</a>
							</li>
							<li class="<cfif rc.action eq 'admin:customers.contacts'>active</cfif>">
								<a href="#buildURL('admin:customers.contacts')#"><i class="icon-leaf"></i> Contacts</a>
							</li>
							<li class="<cfif rc.action eq 'admin:customers.positions'>active</cfif>">
								<a href="#buildURL('admin:customers.positions')#"><i class="icon-leaf"></i> Positions</a>
							</li>
							<li class="<cfif rc.action eq 'admin:customers.paymentterms'>active</cfif>">
								<a href="#buildURL('admin:customers.paymentterms')#"><i class="icon-leaf"></i> Payment Terms</a>
							</li>
						</ul>
					</div>

					<!--- BODY --->
					<div class="span9">
						#body#
					</div>

				<cfelse>

					<!--- BODY --->
					<div class="span12">
						#body#
					</div>

				</cfif>
			</div><!--- /.row --->
		</div><!--- /.container-murafw1 --->
	</cfoutput>
</cfsavecontent>
<cfoutput>
	#application.pluginManager.renderAdminTemplate(
		body=local.newBody
		,pageTitle=rc.pc.getName()
		,compactDisplay=rc.compactDisplay
	)#
</cfoutput>