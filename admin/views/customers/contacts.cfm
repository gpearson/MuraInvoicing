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
		<div class="panel-heading"><h1>Customer Contact Information Screen</h1></div>
		<div class="panel-body">
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="UpdatedContact">
						<cfif isDefined("URL.Successful")>
							<cfif URL.Successful EQ "true">
								<div class="well well-lg">
									You have successfully updated a contact for this client in the database
								</div>
							<cfelse>
								<div class="well well-lg">
									An Error has occurred and the customer record was not added to the database.
								</div>
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="DeletedContact">
						<cfif isDefined("URL.Successful")>
							<cfif URL.Successful EQ "true">
								<div class="well well-lg">
									You have successfully deleted a contact from this client in the database
								</div>
							<cfelse>
								<div class="well well-lg">
									An Error has occurred and the customer record was not added to the database.
								</div>
							</cfif>
						</cfif>
					</cfcase>
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
			<cfif isDefined("URL.RecNo")>
				<table class="table table-striped table-bordered" cellspacing="0" width="100%">
					<thead>
						<tr>
							<th>Business Name</th>
							<th>Address</th>
							<th>City</th>
							<th>State</th>
							<th>Zip Code</th>
							<th>Active</th>
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
				<br>
				<table class="table table-striped table-bordered" cellspacing="0" width="100%">
					<thead>
						<tr>
							<th>Contact Name</th>
							<th>Contact Email</th>
							<th>Contact Phone</th>
							<th>Contact Extension</th>
							<th>Contact Position</th>
							<th width="100">Actions</th>
						</tr>
					</thead>
					<cfif Session.getClientContacts.RecordCount>
						<tfoot>
							<tr>
								<td colspan="6"><div class="text-center">To add additional contacts to this Customer, <A href="#buildURL('admin:customers.addclientcontacts')#&RecNo=#Session.getBusiness.TContent_ID#">Click Here</A></div></td>
							</tr>
						</tfoot>
						<tbody>
							<cfloop query="Session.getClientContacts">
								<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
									<td>#Session.getClientContacts.Contact_LastName#, #Session.getClientContacts.Contact_FirstName#</td>
									<td>#Session.getClientContacts.Contact_Email#</td>
									<td>#Session.getClientContacts.Contact_PhoneNumber#</td>
									<td>#Session.getClientContacts.Contact_PhoneExtension#</td>
									<td>#Session.getClientContacts.PositionTitle#</td>
									<td><a href="#buildURL('admin:customers.updateclientcontacts')#&RecNo=#Session.getClientContacts.TContent_ID#&UserAction=EditContact&ClientID=#URL.RecNo#" class="btn btn-success btn-small">U</a>&nbsp;<a href="#buildURL('admin:customers.updateclientcontacts')#&RecNo=#Session.getClientContacts.TContent_ID#&UserAction=DeleteContact&ClientID=#URL.RecNo#" class="btn btn-success btn-small">D</a></td>
								</tr>
							</cfloop>
						</tbody>
					<cfelse>
						<tbody>
							<tr>
								<td colspan="7"><div class="text-center">No Contacts have been added to this site. To add a new contact to this Customer, Please <a href="#buildURL('admin:customers.addclientcontacts')#&RecNo=#Session.getBusiness.TContent_ID#">Click Here</a></div></td>
							</tr>
						</tbody>
					</cfif>
				</table>
			</cfif>
		</div>
		<div class="panbel-footer">&nbsp;</div>
	</div>
</cfoutput>