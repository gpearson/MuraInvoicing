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
		<div class="panel-heading"><h1>Customer Positions Held Screen</h1></div>
		<div class="panbel-body">
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="AddedPosition">
						<cfif isDefined("URL.Successful")>
							<cfif URL.Successful EQ "true">
								<div class="well well-lg">
									You have successfully added a new position record in the database
								</div>
							<cfelse>
								<div class="well well-lg">
									An Error has occurred and the customer record was not added to the database.
								</div>
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="UpdatedPosition">
						<cfif isDefined("URL.Successful")>
							<cfif URL.Successful EQ "true">
								<div class="well well-lg">
									You have successfully updated the position record in the database
								</div>
							<cfelse>
								<div class="well well-lg">
									An Error has occurred and the customer record was not updated in the database.
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
							<th>Position Title</th>
							<th>Active</th>
							<th width="100">Actions</th>
						</tr>
					</thead>
					<cfif Session.getPositionTitles.RecordCount>
						<tfoot>
							<tr>
								<td colspan="6"><div class="text-center">To add additional position titles to this system, <A href="#buildURL('admin:customers.addpositions')#">Click Here</A></div></td>
							</tr>
						</tfoot>
						<tbody>
							<cfloop query="Session.getPositionTitles">
								<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
									<td>#Session.getPositionTitles.PositionTitle#</td>
									<td><cfswitch expression="#Session.getPositionTitles.Active#"><cfcase value="1">Yes</cfcase><cfdefaultcase>No</cfdefaultcase></cfswitch></td>
									<td><a href="#buildURL('admin:customers.updatepositions')#&RecNo=#Session.getBusiness.TContent_ID#" class="btn btn-warning btn-small">U</a></td>
								</tr>
							</cfloop>
						</tbody>
					<cfelse>
						<tbody>
							<tr>
								<td colspan="3"><div class="text-center">No Position Titles have been added to this site.</div></td>
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