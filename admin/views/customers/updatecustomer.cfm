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
							<div class="panel-heading"><h2>Customer Information</h2></div>
							<div class="form-group">
								<label for="BusinessName" class="control-label col-xs-2">Business Name:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessName" value="#Session.getBusiness.BusinessName#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessVoice" class="control-label col-xs-2">Business Voice:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" validate="telephone" size="20" class="form-control" value="#Session.getBusiness.PrimaryVoiceNumber#" name="BusinessVoice" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessFax" class="control-label col-xs-2">Business Fax:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" validate="telephone" size="20" class="form-control" name="BusinessFax" value="#Session.getBusiness.BusinessFax#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessWebsite" class="control-label col-xs-2">Business Website:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessWebsite" value="#Session.getBusiness.BusinessWebsite#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessWebsite" class="control-label col-xs-2">Payment Terms:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="PaymentTerms" disabled="yes"></div>
							</div>
							<br /><br />
							<div class="panel-heading"><h2>Customer Physical Address</h2></div>
							<div class="form-group">
								<label for="BusinessAddress" class="control-label col-xs-2">Physical Address:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessAddress" value="#Session.getBusiness.PhysicalAddress#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessCity" class="control-label col-xs-2">Physical City:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="BusinessCity" value="#Session.getBusiness.PhysicalCity#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessState" class="control-label col-xs-2">Physical State:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="BusinessState" value="#Session.getBusiness.PhysicalState#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessZipCode" class="control-label col-xs-2">Physical ZipCode:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" validate="zipcode" size="10" class="form-control form-control-inline" name="BusinessZipCode" value="#Session.getBusiness.PhysicalZipCode#" disabled="yes"></div>
							</div>
							<br /><br />
							<div class="panel-heading"><h2>Customer Mailing Address</h2></div>
							<div class="form-group">
								<label for="BusinessAddress" class="control-label col-xs-2">Mailing Address:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="MailingAddress" value="#Session.getBusiness.MailingAddress#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessCity" class="control-label col-xs-2">Mailing City:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="MailingCity" value="#Session.getBusiness.MailingCity#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessState" class="control-label col-xs-2">Mailing State:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="MailingState" value="#Session.getBusiness.MailingState#" disabled="yes"></div>
							</div>
							<div class="form-group">
								<label for="BusinessZipCode" class="control-label col-xs-2">Mailing ZipCode:&nbsp;</label>
								<div class="col-xs-10"><cfinput type="text" validate="zipcode" size="10" class="form-control form-control-inline" name="MailingZipCode" value="#Session.getBusiness.MailingZipCode#" disabled="yes"></div>
							</div>
						</div>
						<div class="panel-footer">
							<div class="pull-right"><cfinput type="Submit" name="DeleteCustomer" class="btn btn-primary" value="Delete Client"></div>
						</div>
					</cfform>
				</cfcase>
				<cfcase value="Edit">
					<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
					<cfset temp = QueryAddRow(YesNoQuery, 1)>
					<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
					<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
					<cfset temp = QueryAddRow(YesNoQuery, 1)>
					<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
					<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
					<div class="panel-heading"><h1>Update Existing Customer</h1></div>
					<CFIF not isDefined("URL.ActionItem")>
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
								<div class="panel-heading"><h2>Customer Information</h2></div>
								<div class="form-group">
									<label for="BusinessName" class="control-label col-xs-2">Business Name:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessName" value="#Session.getBusiness.BusinessName#" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="BusinessVoice" class="control-label col-xs-2">Business Voice:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" validate="telephone" size="20" class="form-control" value="#Session.getBusiness.PrimaryVoiceNumber#" name="BusinessVoice" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="BusinessFax" class="control-label col-xs-2">Business Fax:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" validate="telephone" size="20" class="form-control" name="BusinessFax" value="#Session.getBusiness.BusinessFax#" required="no"></div>
								</div>
								<div class="form-group">
									<label for="BusinessWebsite" class="control-label col-xs-2">Business Website:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessWebsite" value="#Session.getBusiness.BusinessWebsite#" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="PaymentTerms" class="control-label col-xs-2">Payment Terms:&nbsp;</label>
									<div class="col-xs-10"><cfselect name="PaymentTerms" Required="Yes" Multiple="No" query="Session.getPaymentTerms" selected="#Session.getBusiness.PaymentTerms#" value="TContent_ID" Display="PaymentTerms" queryposition="below">
										<option value="----">Select Business Payment Terms</option></cfselect></div>
								</div>
								<div class="form-group">
									<label for="Active" class="control-label col-xs-2 required">Active Status:&nbsp;</label>
									<div class="col-xs-10">
										<cfselect name="Active" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getBusiness.Active#" Display="OptionName"  queryposition="below">
											<option value="----">Select Business Active</option>
										</cfselect>
									</div>
								</div>
								<br /><br />
								<div class="panel-heading"><h2>Customer Physical Address</h2></div>
								<div class="form-group">
									<label for="BusinessAddress" class="control-label col-xs-2">Physical Address:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessAddress" value="#Session.getBusiness.PhysicalAddress#" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="BusinessCity" class="control-label col-xs-2">Physical City:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="BusinessCity" value="#Session.getBusiness.PhysicalCity#" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="BusinessState" class="control-label col-xs-2">Physical State:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="BusinessState" value="#Session.getBusiness.PhysicalState#" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="BusinessZipCode" class="control-label col-xs-2">Physical ZipCode:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" validate="zipcode" size="10" class="form-control form-control-inline" name="BusinessZipCode" value="#Session.getBusiness.PhysicalZipCode#" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="GeoCode_Latitude" class="control-label col-xs-2">Address Latitude:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="GeoCode_Latitude" value="#Session.getBusiness.GeoCode_Latitude#" disabled="yes"></div>
								</div>
								<div class="form-group">
									<label for="GeoCode_Longitude" class="control-label col-xs-2">Address Longitude:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="GeoCode_Longitude" value="#Session.getBusiness.GeoCode_Longitude#" disabled="yes"></div>
								</div>
								<div class="form-group">
									<label for="geoCode_Township" class="control-label col-xs-2">Address Township:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="geoCode_Township" value="#Session.getBusiness.GeoCode_Township#" disabled="yes"></div>
								</div>
								<div class="form-group">
									<label for="geoCode_CountyName" class="control-label col-xs-2">Address County:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="geoCode_CountyName" value="#Session.getBusiness.GeoCode_CountyName#" disabled="yes"></div>
								</div>
								<br /><br />
								<div class="panel-heading"><h2>Customer Mailing Address</h2></div>
								<div class="form-group">
									<label for="BusinessAddress" class="control-label col-xs-2">Mailing Address:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="MailingAddress" value="#Session.getBusiness.MailingAddress#" required="no"></div>
								</div>
								<div class="form-group">
									<label for="BusinessCity" class="control-label col-xs-2">Mailing City:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="MailingCity" value="#Session.getBusiness.MailingCity#" required="no"></div>
								</div>
								<div class="form-group">
									<label for="BusinessState" class="control-label col-xs-2">Mailing State:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="MailingState" value="#Session.getBusiness.MailingState#" required="no"></div>
								</div>
								<div class="form-group">
									<label for="BusinessZipCode" class="control-label col-xs-2">Mailing ZipCode:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" validate="zipcode" size="10" class="form-control form-control-inline" name="MailingZipCode" value="#Session.getBusiness.MailingZipCode#" required="no"></div>
								</div>
								<br /><br />
								<div class="panel-heading"><h2>Customer History</h2></div>
								<div class="form-group">
									<label for="DateCreated" class="control-label col-xs-2">Date Created:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="DateCreated" value="#DateFormat(Session.getBusiness.dateCreated, 'FULL')# at #TimeFormat(Session.getBusiness.dateCreated, 'HH:MM tt')#" disabled="yes"></div>
								</div>
								<div class="form-group">
									<label for="DateUpdated" class="control-label col-xs-2">Date Last Updated:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="DateUpdated" value="#DateFormat(Session.getBusiness.lastUpdated, 'Full')# at #TimeFormat(Session.getBusiness.lastUpdated, 'HH:MM tt')#" disabled="yes"></div>
								</div>
								<div class="form-group">
									<label for="LastUpdateBy" class="control-label col-xs-2">Updated By:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="LastUpdateBy" value="#Session.getBusiness.lastUpdateBy#" disabled="yes"></div>
								</div>
							</div>
							<div class="panel-footer">
								<div class="pull-right"><cfinput type="Submit" name="UpdateClient" class="btn btn-primary" value="Update Client"></div>
							</div>
						</cfform>
					<cfelseif isDefined("URL.ActionItem")>
						<cfform action="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:customers.updatecustomer&PerformAction=#URL.PerformAction#" method="post" id="UpdateExistingCustomer" class="form-horizontal">
							<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
							<cfinput type="hidden" name="formSubmit" value="true">
							<cfinput type="hidden" name="CustomerRecID" value="#URL.RecNo#">
							<div class="panel-body">
								<cfif isDefined("Session.FormErrors")>
									<cfif ArrayLen(Session.FormErrors) GTE 1>
										<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
									</cfif>
								</cfif>
								<div class="well">Please update any information that is not correct for this customer</div>
								<div class="panel-heading"><h2>Customer Information</h2></div>
								<div class="form-group">
									<label for="BusinessName" class="control-label col-xs-2">Business Name:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessName" value="#Session.getBusiness.BusinessName#" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="BusinessVoice" class="control-label col-xs-2">Business Voice:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" validate="telephone" size="20" class="form-control" value="#Session.getBusiness.PrimaryVoiceNumber#" name="BusinessVoice" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="BusinessFax" class="control-label col-xs-2">Business Fax:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" validate="telephone" size="20" class="form-control" name="BusinessFax" value="#Session.getBusiness.BusinessFax#" required="no"></div>
								</div>
								<div class="form-group">
									<label for="BusinessWebsite" class="control-label col-xs-2">Business Website:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessWebsite" value="#Session.getBusiness.BusinessWebsite#" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="PaymentTerms" class="control-label col-xs-2">Payment Terms:&nbsp;</label>
									<div class="col-xs-10"><cfselect name="PaymentTerms" Required="Yes" Multiple="No" query="Session.getPaymentTerms" selected="#Session.getBusiness.PaymentTerms#" value="TContent_ID" Display="PaymentTerms" queryposition="below">
										<option value="----">Select Business Payment Terms</option></cfselect></div>
								</div>
								<div class="form-group">
									<label for="Active" class="control-label col-xs-2 required">Active Status:&nbsp;</label>
									<div class="col-xs-10">
										<cfselect name="Active" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getBusiness.Active#" Display="OptionName"  queryposition="below">
											<option value="----">Select Business Active</option>
										</cfselect>
									</div>
								</div>
								<br /><br />
								<div class="panel-heading"><h2>Customer Physical Address</h2></div>
								<div class="form-group">
									<label for="BusinessAddress" class="control-label col-xs-2">Physical Address:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="BusinessAddress" value="#Session.getBusiness.PhysicalAddress#" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="BusinessCity" class="control-label col-xs-2">Physical City:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="BusinessCity" value="#Session.getBusiness.PhysicalCity#" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="BusinessState" class="control-label col-xs-2">Physical State:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="BusinessState" value="#Session.getBusiness.PhysicalState#" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="BusinessZipCode" class="control-label col-xs-2">Physical ZipCode:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" validate="zipcode" size="10" class="form-control form-control-inline" name="BusinessZipCode" value="#Session.getBusiness.PhysicalZipCode#" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="GeoCode_Latitude" class="control-label col-xs-2">Address Latitude:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="GeoCode_Latitude" value="#Session.getBusiness.GeoCode_Latitude#" disabled="yes"></div>
								</div>
								<div class="form-group">
									<label for="GeoCode_Longitude" class="control-label col-xs-2">Address Longitude:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="GeoCode_Longitude" value="#Session.getBusiness.GeoCode_Longitude#" disabled="yes"></div>
								</div>
								<div class="form-group">
									<label for="geoCode_Township" class="control-label col-xs-2">Address Township:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="geoCode_Township" value="#Session.getBusiness.GeoCode_Township#" disabled="yes"></div>
								</div>
								<div class="form-group">
									<label for="geoCode_CountyName" class="control-label col-xs-2">Address County:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="geoCode_CountyName" value="#Session.getBusiness.GeoCode_CountyName#" disabled="yes"></div>
								</div>
								<br /><br />
								<div class="panel-heading"><h2>Customer Mailing Address</h2></div>
								<div class="form-group">
									<label for="BusinessAddress" class="control-label col-xs-2">Mailing Address:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="20" class="form-control" name="MailingAddress" value="#Session.getBusiness.MailingAddress#" required="no"></div>
								</div>
								<div class="form-group">
									<label for="BusinessCity" class="control-label col-xs-2">Mailing City:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="MailingCity" value="#Session.getBusiness.MailingCity#" required="no"></div>
								</div>
								<div class="form-group">
									<label for="BusinessState" class="control-label col-xs-2">Mailing State:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="MailingState" value="#Session.getBusiness.MailingState#" required="no"></div>
								</div>
								<div class="form-group">
									<label for="BusinessZipCode" class="control-label col-xs-2">Mailing ZipCode:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" validate="zipcode" size="10" class="form-control form-control-inline" name="MailingZipCode" value="#Session.getBusiness.MailingZipCode#" required="no"></div>
								</div>
								<br /><br />
								<div class="panel-heading"><h2>Customer History</h2></div>
								<div class="form-group">
									<label for="DateCreated" class="control-label col-xs-2">Date Created:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="DateCreated" value="#DateFormat(Session.getBusiness.dateCreated, 'FULL')# at #TimeFormat(Session.getBusiness.dateCreated, 'HH:MM tt')#" disabled="yes"></div>
								</div>
								<div class="form-group">
									<label for="DateUpdated" class="control-label col-xs-2">Date Last Updated:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="DateUpdated" value="#DateFormat(Session.getBusiness.lastUpdated, 'Full')# at #TimeFormat(Session.getBusiness.lastUpdated, 'HH:MM tt')#" disabled="yes"></div>
								</div>
								<div class="form-group">
									<label for="LastUpdateBy" class="control-label col-xs-2">Updated By:&nbsp;</label>
									<div class="col-xs-10"><cfinput type="text" size="10" class="form-control form-control-inline" name="LastUpdateBy" value="#Session.getBusiness.lastUpdateBy#" disabled="yes"></div>
								</div>
							</div>
							<div class="panel-footer">
								<div class="pull-right"><cfinput type="Submit" name="UpdateClient" class="btn btn-primary" value="Update Client"></div>
							</div>
						</cfform>
					</cfif>
				</cfcase>
			</cfswitch>
		</cfif>
	</div>
</cfoutput>