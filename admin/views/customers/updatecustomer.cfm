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
		<cfif isDefined("URL.PerformAction")>
			<cfswitch expression="#URL.PerformAction#">
				<cfcase value="Delete">
					<div class="panel-heading"><h1>Deactivate Customer</h1></div>
					<cfform action="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers.updatecustomer&PerformAction=#URL.PerformAction#" method="post" id="UpdateExistingCustomer" class="form-horizontal">
						<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
						<cfinput type="hidden" name="formSubmit" value="true">
						<cfinput type="hidden" name="CustomerRecID" value="#URL.RecNo#">
						<div class="panel-body">
							<cfif isDefined("URL.UserAction")>
								<div class="well">
									<cfswitch expression="#URL.UserAction#">
										<cfcase value="UpdatedClient">
											<cfif isDefined("URL.Successful")>
												<div class="well well-lg">
													You have successfully updated the client record in the database
												</div>
											</cfif>
										</cfcase>
									</cfswitch>
								</div>
							</cfif>
							<div class="well">Please verify that you will want to deactivate this customer from the database.</div>
							<div class="well"><h2>Client Information</h2></div>
							<div class="form-group">
								<label for="BusinessName" class="control-label col-xs-2">Business Name:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessName" value="#Session.getBusiness.BusinessName#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessAddress" class="control-label col-xs-2">Business Address:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessAddress" value="#Session.getBusiness.PhysicalAddress#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessCity" class="control-label col-xs-2">Address City:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="BusinessCity" value="#Session.getBusiness.PhysicalCity#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessState" class="control-label col-xs-2">Address State:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="BusinessState" value="#Session.getBusiness.PhysicalState#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessZipCode" class="control-label col-xs-2">Address ZipCode:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" validate="zipcode" size="10" class="form-control form-control-inline" name="BusinessZipCode" value="#Session.getBusiness.PhysicalZipCode#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessVoice" class="control-label col-xs-2">Business Voice:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" validate="telephone" size="20" class="form-control" name="BusinessVoice" value="#Session.getBusiness.PrimaryVoiceNumber#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessFax" class="control-label col-xs-2">Business Fax:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" validate="telephone" size="20" class="form-control" name="BusinessFax" value="#Session.getBusiness.BusinessFax#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessWebsite" class="control-label col-xs-2">Business Website:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessWebsite" value="#Session.getBusiness.BusinessWebsite#" disabled="yes"></div>
							</div>
							<br /><br />
							<div class="well"><h2>Contact Information</h2></div>

						</div>
						<div class="panel-footer">
							<div class="pull-right"><cfinput type="Submit" name="DeleteCustomer" class="btn btn-primary" value="Delete Client"></div>
						</div>
					</cfform>
				</cfcase>
				<cfcase value="Edit">
					<div class="panel-heading"><h1>Update Existing Customer</h1></div>
					<cfform action="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers.updatecustomer&PerformAction=#URL.PerformAction#" method="post" id="UpdateExistingCustomer" class="form-horizontal">
						<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
						<cfinput type="hidden" name="formSubmit" value="true">
						<cfinput type="hidden" name="CustomerRecID" value="#URL.RecNo#">
						<div class="panel-body">
							<cfif isDefined("URL.UserAction")>
								<div class="well">
									<cfswitch expression="#URL.UserAction#">
										<cfcase value="UpdatedClient">
											<cfif isDefined("URL.Successful")>
												<div class="well well-lg">
													You have successfully updated the client record in the database
												</div>
											</cfif>
										</cfcase>
									</cfswitch>
								</div>
							</cfif>
							<div class="well">Please update any information that is not correct for this customer</div>
							<div class="well"><h2>Client Information</h2></div>
							<div class="form-group">
								<label for="BusinessName" class="control-label col-xs-2">Business Name:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessName" value="#Session.getBusiness.BusinessName#" required="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessAddress" class="control-label col-xs-2">Business Address:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessAddress" value="#Session.getBusiness.PhysicalAddress#" required="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessCity" class="control-label col-xs-2">Address City:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="BusinessCity" value="#Session.getBusiness.PhysicalCity#" required="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessState" class="control-label col-xs-2">Address State:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="BusinessState" value="#Session.getBusiness.PhysicalState#" required="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessZipCode" class="control-label col-xs-2">Address ZipCode:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" validate="zipcode" size="10" class="form-control form-control-inline" name="BusinessZipCode" value="#Session.getBusiness.PhysicalZipCode#" required="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessVoice" class="control-label col-xs-2">Business Voice:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" validate="telephone" size="20" class="form-control" name="BusinessVoice" value="#Session.getBusiness.PrimaryVoiceNumber#" required="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessFax" class="control-label col-xs-2">Business Fax:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" validate="telephone" size="20" class="form-control" name="BusinessFax" value="#Session.getBusiness.BusinessFax#" required="no"></div>
							</div>
							<div class="form-group">
								<label for="BusinessWebsite" class="control-label col-xs-2">Business Website:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessWebsite" value="#Session.getBusiness.BusinessWebsite#" required="no"></div>
							</div>
							<br /><br />
							<div class="well"><h2>Contact Information</h2></div>

						</div>
						<div class="panel-footer">
							<div class="pull-right"><cfinput type="Submit" name="UpdateClient" class="btn btn-primary" value="Update Client"></div>
						</div>
					</cfform>
				</cfcase>
			</cfswitch>
		</cfif>
	</div>
</cfoutput>