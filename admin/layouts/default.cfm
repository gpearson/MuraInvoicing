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
				<nav class="navbar navbar-murafw1">
					<div class="navbar-inner">
						<div class="navbar-header">
							<a class="navbar-brand">#HTMLEditFormat(rc.pc.getPackage())#</a>
						</div>
						<ul class="nav navbar-nav">
							<li class="<cfif rc.action eq 'admin:main.default'>active</cfif>"><a href="#buildURL('admin:main')#">Home</a></li>
							<li class="<cfif rc.action eq 'admin:customers'>active</cfif> dropdown">
								<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('admin:customers')#">Customers <span class="caret"></span></a>
								<ul class="dropdown-menu">
									<li class="<cfif rc.action eq 'admin:customers.default'>active</cfif>">
										<a href="#buildURL('admin:customers.default')#"><i class="icon-home"></i> List Customers</a>
									</li>
									<li class="<cfif rc.action eq 'admin:customers.newcustomer'>active</cfif>">
										<a href="#buildURL('admin:customers.newcustomer')#"><i class="icon-home"></i> New Customer</a>
									</li>
									<li class="<cfif rc.action eq 'admin:customers.contacts'>active</cfif>">
										<a href="#buildURL('admin:customers.contacts')#"><i class="icon-leaf"></i> Contacts</a>
									</li>
								</ul>
							</li>
							<li class="<cfif rc.action eq 'admin:customers'>active</cfif> dropdown">
								<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('admin:inventory')#">Inventory <span class="caret"></span></a>
								<ul class="dropdown-menu">
									<li class="<cfif rc.action eq 'admin:customers.newcustomer'>active</cfif>">
										<a href="#buildURL('admin:customers.default')#"><i class="icon-home"></i> New Customer</a>
									</li>
								</ul>
							</li>
							<li class="<cfif rc.action eq 'admin:customers'>active</cfif> dropdown">
								<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('admin:invoices')#">Invoices <span class="caret"></span></a>
								<ul class="dropdown-menu">
									<li class="<cfif rc.action eq 'admin:customers.newcustomer'>active</cfif>">
										<a href="#buildURL('admin:invoices.default')#"><i class="icon-home"></i> New Invoice</a>
									</li>
								</ul>
							</li>
							<li class="<cfif rc.action eq 'admin:customers'>active</cfif> dropdown">
								<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('admin:services')#">Services <span class="caret"></span></a>
								<ul class="dropdown-menu">
									<li class="<cfif rc.action eq 'admin:customers.newcustomer'>active</cfif>">
										<a href="#buildURL('admin:customers.default')#"><i class="icon-home"></i> New Customer</a>
									</li>
								</ul>
							</li>
							<li class="<cfif rc.action eq 'admin:reports'>active</cfif> dropdown">
								<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('admin:reports')#">Reports <span class="caret"></span></a>
								<ul class="dropdown-menu">
									<li class="<cfif rc.action eq 'admin:customers.newcustomer'>active</cfif>">
										<a href="#buildURL('admin:customers.default')#"><i class="icon-home"></i> New Customer</a>
									</li>
								</ul>
							</li>
							<li class="<cfif rc.action eq 'admin:settings'>active</cfif> dropdown">
								<a class="dropdown-toggle" data-toggle="dropdown" href="#buildURL('admin:settings')#">Settings <span class="caret"></span></a>
								<ul class="dropdown-menu">
									<li class="<cfif rc.action eq 'admin:settings.positions'>active</cfif>">
										<a href="#buildURL('admin:settings.positions')#"><i class="icon-leaf"></i> Positions</a>
									</li>
									<li class="<cfif rc.action eq 'admin:settings.paymentterms'>active</cfif>">
										<a href="#buildURL('admin:settings.paymentterms')#"><i class="icon-leaf"></i> Payment Terms</a>
									</li>
								</ul>
							</li>
						</ul>
						<ul class="nav navbar-nav navbar-right">
							<li class="<cfif rc.action contains 'admin:license'>active</cfif>">
								<a href="#buildURL('admin:license')#"><i class="icon-book"></i> License</a>
							</li>
							<li class="<cfif rc.action contains 'admin:instructions'>active</cfif>">
								<a href="#buildURL('admin:instructions')#"><i class="icon-info-sign"></i> Instructions</a>
							</li>
						</ul>
					</div>
				</nav>

			</div><!--- /.row --->

			<!--- MAIN CONTENT AREA --->
			<div class="row-fluid">
				<cfif rc.action contains 'admin:customers'>
					<!--- SUB-NAV --->
					<div class="span3">
						<ul class="nav nav-list">
							<li><A href="#buildURL('admin:customers')#">Customers</a></li>
							<li class="<cfif rc.action eq 'admin:customers.newcustomer'>active</cfif>">
								<a href="#buildURL('admin:customers.newcustomer')#"><i class="icon-leaf"></i> New Customer</a>
							</li>

							<li class="<cfif rc.action eq 'admin:customers.contacts'>active</cfif>">
								<a href="#buildURL('admin:customers.contacts')#"><i class="icon-leaf"></i> Contacts</a>
							</li>
						</ul>
					</div>

					<!--- BODY --->
					<div class="span9">
						#body#
					</div>
				<cfelseif rc.action contains 'admin:inventory'>
					<!--- SUB-NAV --->
					<div class="span3">
						<ul class="nav nav-list">
							<li><A href="#buildURL('admin:products')#">Products</a>
								<ul class="nav nav-list tree">
									<li class="<cfif rc.action eq 'admin:customers.newcustomer'>active</cfif>">
										<a href="#buildURL('admin:customers.newcustomer')#"><i class="icon-leaf"></i> New Customer</a>
									</li>
								</ul>
							</li>
							<li class="<cfif rc.action eq 'admin:customers.contacts'>active</cfif>">
								<a href="#buildURL('admin:customers.contacts')#"><i class="icon-leaf"></i> Contacts</a>
							</li>
							<li class="<cfif rc.action eq 'admin:customers.positions'>active</cfif>">
								<a href="#buildURL('admin:customers.positions')#"><i class="icon-leaf"></i> Positions</a>
								<ul class="nav nav-list tree">
									<a href="#buildURL('admin:customers.addpositions')#"><i class="icon-leaf"></i> Add Position</a>
								</ul>
							</li>
							<li class="<cfif rc.action eq 'admin:customers.paymentterms'>active</cfif>">
								<a href="#buildURL('admin:customers.paymentterms')#"><i class="icon-leaf"></i> Payment Terms</a>
								<ul class="nav nav-list tree">
									<a href="#buildURL('admin:customers.addpaymentterms')#"><i class="icon-leaf"></i> Add Payment Term</a>
								</ul>
							</li>
						</ul>
					</div>

					<!--- BODY --->
					<div class="span9">
						#body#
					</div>
				<cfelseif rc.action contains 'admin:invoices'>
				<cfelseif rc.action contains 'admin:services'>
				<cfelseif rc.action contains 'admin:reports'>
				<cfelseif rc.action contains 'admin:settings'>
					<div class="span3">
						<ul class="nav nav-list">
							<li><A href="#buildURL('admin:settings')#">Settings</a></li>
							<li class="<cfif rc.action eq 'admin:settings.positions'>active</cfif>">
								<a href="#buildURL('admin:settings.positions')#"><i class="icon-leaf"></i> Positions</a>
							</li>
							<li class="<cfif rc.action eq 'admin:settings.paymentterms'>active</cfif>">
								<a href="#buildURL('admin:settings.paymentterms')#"><i class="icon-leaf"></i> Payment Terms</a>
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