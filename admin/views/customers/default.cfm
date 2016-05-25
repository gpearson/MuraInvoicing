<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2014 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>

<cfoutput>
	<script>
		$.jgrid.defaults.width = 800;
		$.jgrid.defaults.responsive = true;
		$.jgrid.defaults.styleUI = 'Bootstrap';
	</script>
	<div class="panel panel-default">
		<div class="panel-heading"><h1>Customer Menu</h1></div>
		<div class="panel-body">
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="AddedCustomer">
						<cfif isDefined("URL.Successful")>
							<cfif URL.Successful EQ "true">
								<div class="alert alert-success">
									You have successfully added a new customer record to the database.
								</div>
							<cfelse>
								<div class="alert alert-danger">
									An error has occurred and the customer record was not added to the database.
								</div>
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="UpdatedCustomer">
						<cfif isDefined("URL.Successful")>
							<cfif URL.Successful EQ "true">
								<div class="alert alert-success">
									You have successfully updated the selected customer record in the database.
								</div>
							<cfelse>
								<div class="alert alert-danger">
									An error has occurred and the customer record was not updated in the database.
								</div>
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="DeletedCustomer">
						<cfif isDefined("URL.Successful")>
							<cfif URL.Successful EQ "true">
								<div class="alert alert-success">
									You have successfully deactivated the selected customer record in the database.
								</div>
							<cfelse>
								<div class="alert alert-danger">
									An error has occurred and the customer record was not deactivated in the database.
								</div>
							</cfif>
						</cfif>
					</cfcase>
				</cfswitch>
			</cfif>
			<table id="jqGrid"></table>
			<div id="jqGridPager"></div>
			<div id="dialog" title="Feature not supported" style="display:none">
				<p>That feature is not supported.</p>
			</div>
			<script type="text/javascript">
				$(document).ready(function () {
					var selectedRow = 0;
					$("##jqGrid").jqGrid({
						url: "/plugins/MuraInvoicing/admin/controllers/customers.cfc?method=getAllCustomers&Datasource=#rc.$.globalConfig('datasource')#&DataUsername=#rc.$.globalConfig('dbusername')#&DataPassword=#rc.$.globalConfig('dbpassword')#&SiteID=#rc.$.siteConfig('siteID')#",
						editurl: "/plugins/MuraInvoicing/admin/controllers/customers.cfc?method=updateCustomer&Datasource=#rc.$.globalConfig('datasource')#&DataUsername=#rc.$.globalConfig('dbusername')#&DataPassword=#rc.$.globalConfig('dbpassword')#&SiteID=#rc.$.siteConfig('siteID')#",
						// we set the changes to be made at client side using predefined word clientArray
						datatype: "json",
						colNames: ["Rec No","Business Name","Address","City","State","Zip Code","Active"],
						colModel: [
							{ label: 'Rec ##', name: 'TContent_ID', width: 75, key: true, editable: false },
							{ label: 'Business Name', name: 'BusinessName', editable: true },
							{ label: 'Physical Address', name: 'PhysicalAddress', width: 100, editable: true },
							{ label: 'City', name: 'PhysicalCity', width: 75, editable: true },
							{ label: 'State', name: 'PhysicalState', width: 50, editable: true },
							{ label: 'Zip Code', name: 'PhysicalZipCode', width: 100, editable: true },
							{ label: 'Active', name: 'Active', width: 50, editable: true, edittype: "select", editoptions: { value: "1:Yes;0:No"}}
						],
						sortname: 'TContent_ID',
						sortorder : 'asc',
						viewrecords: true,
						height: 500,
						rowNum: 30,
						pgText: " of ",
						pager: "##jqGridPager",
						jsonReader: {
							root: "ROWS",
							page: "PAGE",
							total: "TOTAL",
							records: "RECORDS",
							cell: "",
							id: "0"
						},
						onSelectRow: function(id){
							//We verify a valid new row selection
							if(id && id!==selectedRow) {
								//If a previous row was selected, but the values were not saved, we restore it to the original data.
								$('##jqGrid').restoreRow(selectedRow);
								selectedRow=id;
							}
						}
					});
					$('##jqGrid').navGrid('##jqGridPager', {edit: false, add: false, del:false, search:false});
					$('##jqGrid').navButtonAdd('##jqGridPager',
						{
							caption: "",
							buttonicon: "glyphicon-plus",
							onClickButton: function() {
								var urlToGo = "http://" + window.location.hostname + "/plugins/MuraInvoicing/index.cfm?MuraInvoicingaction=admin:customers.newcustomer";
								window.open(urlToGo,"_self");
							},
							position: "last"
						}
					)
					$('##jqGrid').navButtonAdd('##jqGridPager',
						{
							caption: "",
							buttonicon: "glyphicon-pencil",
							onClickButton: function(id) {
								var urlToGo = "http://" + window.location.hostname + "/plugins/MuraInvoicing/index.cfm?MuraInvoicingaction=admin:customers.updatecustomer&PerformAction=Edit&RecNo=" + selectedRow;
								window.open(urlToGo,"_self");
							},
							position: "last"
						}
					)
					$('##jqGrid').navButtonAdd('##jqGridPager',
						{
							caption: "",
							buttonicon: "glyphicon-remove",
							onClickButton: function(id) {
								var urlToGo = "http://" + window.location.hostname + "/plugins/MuraInvoicing/index.cfm?MuraInvoicingaction=admin:customers.updatecustomer&PerformAction=Delete&RecNo=" + selectedRow;
								window.open(urlToGo,"_self");
							},
							position: "last"
						}
					)

				});
			</script>
		</div>
	</div>
</cfoutput>