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
		<cfif not isDefined("URL.PerformAction")>
			<div class="panel-heading"><h1>Update Customer Contact</h1></div>
			<cfform action="" method="post" id="AddCustomerPositionTitles" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="CustomerID" value="#URL.ClientID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="panel-heading"><h2>Client Information</h2></div>
					<div class="form-group">
						<label for="BusinessName" class="control-label col-sm-2">Client Name:&nbsp;</label>
						<div class="col-sm-9">
							<cfinput type="text" size="20" class="form-control" name="BusinessName" value="#Session.getSelectedClient.BusinessName#" disabled="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="PhysicalAddress" class="control-label col-sm-2">Physical Address:&nbsp;</label>
						<div class="col-sm-9">
							<cfinput type="text" size="20" class="form-control" name="PhysicalAddress" value="#Session.getSelectedClient.PhysicalAddress#" disabled="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="PhysicalCityStateZip" class="control-label col-sm-2">Physical City State Zip:&nbsp;</label>
						<div class="col-sm-9">
							<cfinput type="text" size="20" class="form-control" name="PhysicalCityStateZip" value="#Session.getSelectedClient.PhysicalCity#, #Session.getSelectedClient.PhysicalState# #Session.getSelectedClient.PhysicalZipCode#" disabled="yes">
						</div>
					</div>
					<div class="form-group">&nbsp;</div>
					<div class="form-group">&nbsp;</div>
					<div class="panel-heading"><h2>Contact Information</h2></div>
					<div class="form-group">
						<label for="ContactFirstName" class="control-label col-sm-2">Contact First Name:&nbsp;</label>
						<div class="col-sm-9">
							<cfinput type="text" size="20" class="form-control" name="ContactFirstName" value="#Session.getSelectedContact.Contact_FirstName#" required="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactLastName" class="control-label col-sm-2">Contact Last Name:&nbsp;</label>
						<div class="col-sm-9">
							<cfinput type="text" size="20" class="form-control" name="ContactLastName" value="#Session.getSelectedContact.Contact_LastName#" required="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactEmail" class="control-label col-sm-2">Contact Email Address:&nbsp;</label>
						<div class="col-sm-9">
							<cfinput type="text" size="20" class="form-control" name="ContactEmail"  value="#Session.getSelectedContact.Contact_Email#" required="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactPhone" class="control-label col-sm-2">Contact Phone Number:&nbsp;</label>
						<div class="col-sm-9">
							<cfinput type="text" size="20" class="form-control" name="ContactPhone" required="yes"  value="#Session.getSelectedContact.Contact_PhoneNumber#" mask="999-999-9999">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactPhoneExtension" class="control-label col-sm-2">Contact Extension:&nbsp;</label>
						<div class="col-sm-9">
							<cfinput type="text" size="20" class="form-control" name="ContactPhoneExtension" value="#Session.getSelectedContact.Contact_PhoneExtension#" required="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactPosition" class="control-label col-sm-2">Contact Position Title:&nbsp;</label>
						<div class="col-sm-9">
							<cfselect name="ContactPosition" Required="Yes" Multiple="No" query="Session.getPositions" selected="#Session.getSelectedContact.PositionHeld#" value="TContent_ID" Display="PositionTitle"  queryposition="below">
								<option value="----">Select Contact's Position</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">&nbsp;</div>
					<div class="form-group">&nbsp;</div>

				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddClient" class="btn btn-primary pull0-right" value="Update Client Contact"><br /><br />
				</div>
			</cfform>
		</cfif>
	</div>
</cfoutput>