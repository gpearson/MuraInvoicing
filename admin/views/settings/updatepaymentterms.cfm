<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
</cfsilent>

<cfoutput>
	<div class="panel panel-default">
		<cfif not isDefined("URL.PerformAction")>
			<div class="panel-heading"><h1>Update Customer Payment Terms</h1></div>
			<cfform action="" method="post" id="UpdateCustomerPositionTitles" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="PositionRecNo" value="#URL.RecNo#">
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
					<div class="well">Please complete the following information to update payment terms</div>
					<div class="panel-heading"><h2>Position Information</h2></div>
					<div class="form-group">
						<label for="PaymentTermName" class="control-label col-sm-2">Term Name:&nbsp;</label>
						<div class="col-sm-9"><cfinput type="text" size="20" class="form-control" name="PaymentTermName" value="#Session.getPaymentTerms.PaymentTerms#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PaymentTermActive" class="control-label col-sm-2">Term Active:&nbsp;</label>
						<div class="col-sm-9">
							<cfselect name="PaymentTermActive" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getPaymentTerms.Active#" Display="OptionName"  queryposition="below">
								<option value="----">Select Active Status</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">&nbsp;</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddClient" class="btn btn-primary pull-right" value="Update Payment Terms"><br /><br />
				</div>
			</cfform>
		<cfelseif isDefined("URL.PerformAction")>


		</cfif>
	</div>
</cfoutput>