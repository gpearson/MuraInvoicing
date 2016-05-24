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
			<div class="panel-heading"><h1>Add Customer Contact</h1></div>
			<cfform action="" method="post" id="AddCustomerPositionTitles" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="CustomerID" value="#URL.RecNo#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="panel-heading"><h2>Client Information</h2></div>
					<div class="form-group">
						<label for="BusinessName" class="control-label col-xs-2">client Name:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="BusinessName" value="#Session.getSelectedClient.BusinessName#" disabled="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="PhysicalAddress" class="control-label col-xs-2">Physical Address:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="PhysicalAddress" value="#Session.getSelectedClient.PhysicalAddress#" disabled="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="PhysicalCityStateZip" class="control-label col-xs-2">Physical City State Zip:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="PhysicalCityStateZip" value="#Session.getSelectedClient.PhysicalCity#, #Session.getSelectedClient.PhysicalState# #Session.getSelectedClient.PhysicalZipCode#" disabled="yes">
						</div>
					</div>
					<div class="form-group">&nbsp;</div>
					<div class="form-group">&nbsp;</div>
					<div class="panel-heading"><h2>Contact Information</h2></div>
					<div class="form-group">
						<label for="ContactFirstName" class="control-label col-xs-2">Contact First Name:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="ContactFirstName" required="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactLastName" class="control-label col-xs-2">Contact Last Name:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="ContactLastName" required="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactEmail" class="control-label col-xs-2">Contact Email Address:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="ContactEmail" required="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactPhone" class="control-label col-xs-2">Contact Phone Number:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="ContactPhone" required="yes" mask="999-999-9999">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactPhoneExtension" class="control-label col-xs-2">Contact Extension:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="ContactPhoneExtension" required="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactPosition" class="control-label col-xs-2">Contact Position Title:&nbsp;</label>
						<div class="col-xs-10">
							<cfselect name="ContactPosition" Required="Yes" Multiple="No" query="Session.getPositions" value="TContent_ID" Display="PositionTitle"  queryposition="below">
								<option value="----">Select Contact's Position</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">&nbsp;</div>
					<div class="form-group">&nbsp;</div>
				</div>
				<div class="panel-footer">
					<div class="pull-right"><cfinput type="Submit" name="AddClient" class="btn btn-primary" value="Add New Client Contact"></div>
				</div>
			</cfform>
		<cfelseif isDefined("URL.PerformAction")>
			<div class="panel-heading"><h1>Add Customer Contact</h1></div>
			<cfform action="" method="post" id="AddCustomerPositionTitles" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="CustomerID" value="#URL.RecNo#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<cfif isDefined("Session.FormErrors")>
						<cfif ArrayLen(Session.FormErrors) GTE 1>
							<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
						</cfif>
					</cfif>
					<div class="panel-heading"><h2>Client Information</h2></div>
					<div class="form-group">
						<label for="BusinessName" class="control-label col-xs-2">client Name:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="BusinessName" value="#Session.getSelectedClient.BusinessName#" disabled="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="PhysicalAddress" class="control-label col-xs-2">Physical Address:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="PhysicalAddress" value="#Session.getSelectedClient.PhysicalAddress#" disabled="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="PhysicalCityStateZip" class="control-label col-xs-2">Physical City State Zip:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="PhysicalCityStateZip" value="#Session.getSelectedClient.PhysicalCity#, #Session.getSelectedClient.PhysicalState# #Session.getSelectedClient.PhysicalZipCode#" disabled="yes">
						</div>
					</div>
					<div class="form-group">&nbsp;</div>
					<div class="form-group">&nbsp;</div>
					<div class="panel-heading"><h2>Contact Information</h2></div>
					<div class="form-group">
						<label for="ContactFirstName" class="control-label col-xs-2">Contact First Name:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="ContactFirstName" value="#Session.FormData.ContactFirstName#" required="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactLastName" class="control-label col-xs-2">Contact Last Name:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="ContactLastName" value="#Session.FormData.ContactLastName#" required="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactEmail" class="control-label col-xs-2">Contact Email Address:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="ContactEmail" value="#Session.FormData.ContactEmail#" required="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactPhone" class="control-label col-xs-2">Contact Phone Number:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="ContactPhone" value="#Session.FormData.ContactPhone#" required="yes" mask="999-999-9999">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactPhoneExtension" class="control-label col-xs-2">Contact Extension:&nbsp;</label>
						<div class="col-xs-10">
							<cfinput type="text" size="20" class="form-control" name="ContactPhoneExtension" value="#Session.FormData.ContactPhoneExtension#" required="yes">
						</div>
					</div>
					<div class="form-group">
						<label for="ContactPosition" class="control-label col-xs-2">Contact Position Title:&nbsp;</label>
						<div class="col-xs-10">
							<cfselect name="ContactPosition" Required="Yes" Multiple="No" query="Session.getPositions" selected="#Session.FormData.ContactPosition#" value="TContent_ID" Display="PositionTitle"  queryposition="below">
								<option value="----">Select Contact's Position</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">&nbsp;</div>
					<div class="form-group">&nbsp;</div>
				</div>
				<div class="panel-footer">
					<div class="pull-right"><cfinput type="Submit" name="AddClient" class="btn btn-primary" value="Add New Client Contact"></div>
				</div>
			</cfform>
		</cfif>
	</div>
</cfoutput>