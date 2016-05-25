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
		<div class="panel-heading"><h1>Customer Payment Terms</h1></div>
		<div class="panel-body">
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
			<table id="jqGrid"></table>
			<div id="jqGridPager"></div>
			<div id="dialog" title="Feature not supported" style="display:none">
				<p>That feature is not supported.</p>
			</div>
			<script type="text/javascript">
				$(document).ready(function () {
					var selectedRow = 0;
					$("##jqGrid").jqGrid({
						url: "/plugins/MuraInvoicing/admin/controllers/settings.cfc?method=getAllPaymentTerms",
						// we set the changes to be made at client side using predefined word clientArray
						datatype: "json",
						colNames: ["Rec No","Position Name","Created","Updated","Update By","Active"],
						colModel: [
							{ label: 'Rec ##', name: 'TContent_ID', width: 75, key: true },
							{ label: 'Position Title', name: 'PositionTitle' },
							{ label: 'Created', name: 'dateCreated', width: 100, editable: true },
							{ label: 'Updated', name: 'lastUpdated', width: 75, editable: true },
							{ label: 'Update By', name: 'lastUpdateby', width: 50, editable: true },
							{ label: 'Active', name: 'Active', width: 50 }
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
								var urlToGo = "http://" + window.location.hostname + "/plugins/MuraInvoicing/index.cfm?MuraInvoicingaction=admin:settings.addpaymentterms";
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
								if (selectedRow == 0) {
									alert("Please Select a Row to edit a Business in the database");
								} else {
									var urlToGo = "http://" + window.location.hostname + "/plugins/MuraInvoicing/index.cfm?MuraInvoicingaction=admin:settings.updatepaymentterms&RecNo=" + selectedRow;
									window.open(urlToGo,"_self");
								}

							},
							position: "last"
						}
					)
				});
			</script>
		</div>
		<div class="panbel-footer">&nbsp;</div>
	</div>
</cfoutput>