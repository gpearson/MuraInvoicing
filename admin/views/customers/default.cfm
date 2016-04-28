<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>

<cfoutput>
	<div class="panel panel-default">
		<div class="panel-heading"><h1>Customer Administration Screen</h1></div>
		<div class="panbel-body">
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="AddedCustomer">
						<cfif isDefined("URL.Successful")>
							<cfif URL.Successful EQ "true">
								<div class="well well-lg">
									You have successfully added a new customer record in the database
								</div>
							<cfelse>
								<div class="well well-lg">
									An Error has occurred and the customer record was not added to the database.
								</div>
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="UpdatedCustomer">
						<cfif isDefined("URL.Successful")>
							<cfif URL.Successful EQ "true">
								<div class="well well-lg">
									You have successfully updated the customer record in the database
								</div>
							<cfelse>
								<div class="well well-lg">
									An Error has occurred and the customer record was not updated in the database.
								</div>
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="DeletedCustomer">
						<cfif isDefined("URL.Successful")>
							<cfif URL.Successful EQ "true">
								<div class="well well-lg">
									You have successfully deleted the customer record in the database
								</div>
							<cfelse>
								<div class="well well-lg">
									An Error has occurred and the customer record was not deleted from the database.
								</div>
							</cfif>
						</cfif>
					</cfcase>
				</cfswitch>
			</cfif>
			<div class="well">
			<table class="table table-striped table-bordered" cellspacing="0" width="100%">
				<thead>
					<tr>
						<th>Business Name</th>
						<th>Address</th>
						<th>City</th>
						<th>State</th>
						<th>Zip Code</th>
						<th>Active</th>
						<th width="100">Actions</th>
					</tr>
				</thead>
				<cfif Session.getBusiness.RecordCount>
					<tfoot>
						<tr>
							<td colspan="7"><div class="text-center"></div></td>
						</tr>
					</tfoot>
					<tbody>
						<cfloop query="Session.getBusiness">
							<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
								<td>#Session.getBusiness.BusinessName#</td>
								<td>#Session.getBusiness.PhysicalAddress#</td>
								<td>#Session.getBusiness.PhysicalCity#</td>
								<td>#Session.getBusiness.PhysicalState#</td>
								<td>#Session.getBusiness.PhysicalZipCode#</td>
								<td><cfswitch expression="#Session.getBusiness.Active#"><cfcase value="1">Yes</cfcase><cfdefaultcase>No</cfdefaultcase></cfswitch></td>
								<td><a href="#buildURL('admin:customers.updatecustomer')#&PerformAction=Edit&RecNo=#Session.getBusiness.TContent_ID#" class="btn btn-warning btn-small">U</a><cfif Session.getBusiness.Active EQ 1>&nbsp;<a href="#buildURL('admin:customers.updatecustomer')#&PerformAction=Delete&RecNo=#Session.getBusiness.TContent_ID#" class="btn btn-danger btn-small">D</a></cfif></td>
							</tr>
						</cfloop>
					</tbody>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="7"><div class="text-center">No Clients have been added to this site.</div></td>
						</tr>
					</tbody>
				</cfif>
			</table>
		</div>
		<div class="panbel-footer">&nbsp;</div>
	</div>
</cfoutput>