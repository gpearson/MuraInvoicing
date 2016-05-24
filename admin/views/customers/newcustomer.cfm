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
			<div class="panel-heading"><h1>Add new Customer</h1></div>
			<cfform action="" method="post" id="AddMediaFile" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
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
					<div class="well">Please complete the following information to add a new client to this portal</div>
					<div class="panel-heading"><h2>Customer Information</h2></div>
					<div class="form-group">
						<label for="BusinessName" class="control-label col-xs-2">Business Name:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="BusinessVoice" class="control-label col-xs-2">Business Voice:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" validate="telephone" size="20" class="form-control" name="BusinessVoice" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="BusinessFax" class="control-label col-xs-2">Business Fax:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" validate="telephone" size="20" class="form-control" name="BusinessFax" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="control-label col-xs-2">Business Website:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessWebsite" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="control-label col-xs-2">Payment Terms:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="PaymentTerms" required="no"></div>
					</div>
					<br /><br />
					<div class="panel-heading"><h2>Customer Physical Address</h2></div>
					<div class="form-group">
						<label for="BusinessAddress" class="control-label col-xs-2">Physical Address:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessAddress" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="BusinessCity" class="control-label col-xs-2">Physical City:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="BusinessCity" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="BusinessState" class="control-label col-xs-2">Physical State:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="BusinessState" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="BusinessZipCode" class="control-label col-xs-2">Physical ZipCode:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" validate="zipcode" size="10" class="form-control form-control-inline" name="BusinessZipCode" required="yes"></div>
					</div>
					<br /><br />
					<div class="panel-heading"><h2>Customer Mailing Address</h2></div>
					<div class="form-group">
						<label for="BusinessAddress" class="control-label col-xs-2">Mailing Address:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="MailingAddress" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessCity" class="control-label col-xs-2">Mailing City:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="MailingCity" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessState" class="control-label col-xs-2">Mailing State:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="MailingState" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessZipCode" class="control-label col-xs-2">Mailing ZipCode:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" validate="zipcode" size="10" class="form-control form-control-inline" name="MailingZipCode" required="no"></div>
					</div>
					<br /><br />
					<div class="panel-heading"><h2>Membership Information</h2></div>
					<div class="form-group">
						<label for="StudentADM" class="control-label col-xs-2">Current ADM:&nbsp;</label>
						<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="StudentADM" required="no"></div>
					</div>
				</div>
				<div class="panel-footer">
					<div class="pull-right"><cfinput type="Submit" name="AddClient" class="btn btn-primary" value="Add New Client"></div>
				</div>
			</cfform>
		<cfelseif isDefined("URL.PerformAction")>


		</cfif>
	</div>
</cfoutput>