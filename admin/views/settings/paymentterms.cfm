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
		<div class="panel-heading"><h1>Customer Payment Terms</h1></div>
		<div class="panbel-body">
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="AddedPaymentTerms">
						<cfif isDefined("URL.Successful")>
							<cfif URL.Successful EQ "true">
								<div class="well well-lg">
									You have successfully added a new paynment term record in the database
								</div>
							<cfelse>
								<div class="well well-lg">
									An Error has occurred and the customer record was not added to the database.
								</div>
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="UpdatedPaymentTerms">
						<cfif isDefined("URL.Successful")>
							<cfif URL.Successful EQ "true">
								<div class="well well-lg">
									You have successfully updated the payment term record in the database
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
			<cfif not isDefined("URL.RecNo")>
				<table class="table table-striped table-bordered" cellspacing="0" width="100%">
					<thead>
						<tr>
							<th>Payment Terms</th>
							<th>Active</th>
							<th width="100">Actions</th>
						</tr>
					</thead>
					<cfif Session.getPaymentTerms.RecordCount>
						<tfoot>
							<tr>
								<td colspan="6"><div class="text-center">To add additional payment terms for active clients, <A href="#buildURL('admin:customers.addpaymentterms')#">Click Here</A></div></td>
							</tr>
						</tfoot>
						<tbody>
							<cfloop query="Session.getPaymentTerms">
								<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
									<td>#Session.getPaymentTerms.PaymentTerms#</td>
									<td><cfswitch expression="#Session.getPaymentTerms.Active#"><cfcase value="1">Yes</cfcase><cfdefaultcase>No</cfdefaultcase></cfswitch></td>
									<td><a href="#buildURL('admin:customers.updatepaymentterms')#&RecNo=#Session.getPaymentTerms.TContent_ID#" class="btn btn-success btn-small">U</a></td>
								</tr>
							</cfloop>
						</tbody>
					<cfelse>
						<tbody>
							<tr>
								<td colspan="7"><div class="text-center">No Payment Terms have been added to this site.</div></td>
							</tr>
						</tbody>
					</cfif>
				</table>
			<cfelseif isDefined("URL.RecNo")>

			</cfif>

		</div>
		<div class="panbel-footer">&nbsp;</div>
	</div>
</cfoutput>