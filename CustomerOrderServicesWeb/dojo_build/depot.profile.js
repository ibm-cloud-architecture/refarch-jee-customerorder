dependencies = {
	layers : [
			{
				name :"dojo.js",
				dependencies : [ "dojo.*", "dojo.parser", "dijit.dijit",
				                 "dijit._Widget","dijit._Templated",
				             	"dijit.Declaration", "dojox.layout.ContentPane","dijit.dijit",
				            	"dijit.layout.BorderContainer", "dijit.layout._LayoutWidget.js",
				            	"dijit.layout.ContentPane", "dojox.layout.ContentPane",
				            	"dijit.layout.TabContainer","dojo.data.ItemFileReadStore",
				            	"dojox.grid.DataGrid","dojo.back" ,"dojo.DeferredList",
				            	"depot.NavigationController","depot.AccountController"
				            	]
			},
			{
				name :"depot_product.js",
				layerDependencies : [ "dojo.js" ],
				dependencies : ["depot.ProductController","dijit.Menu","dijit.MenuItem","dijit.PopupMenuItem",
				                "dojox.data.JsonRestStore", "dijit.Tree", "dojo.dnd.common" ,"dojo.dnd.Source",
				                "dijit.Dialog","dojo.data.ItemFileWriteStore"             
				]
			},
			{
				name :"depot_orderHistory.js",
				layerDependencies : [ "dojo.js" ],
				dependencies : ["depot.OrderHistoryController", "dojox.dtl.tag.logic"            
				]
			},
			{
				name :"depot_account.js",
				layerDependencies : [ "dojo.js" ],
				dependencies : ["depot.AddressController", "depot.AccountTypeFormController","dijit.form.Form",  "dijit.TitlePane",
				                "dijit.form.FilteringSelect","dojox.form.BusyButton","dijit.form.TextBox","dijit.form.ValidationTextBox",
				                "dijit.form.Textarea","dijit.form.NumberSpinner","dojox.dtl._Templated","depot.widget.DynamicForm"
				                
				]
			}
			],
			prefixes : [ [ "dijit", "../dijit" ], [ "dojox", "../dojox" ], ["product", "../../product" ],
			             ["theme", "../../theme" ],["depot","../../dojo_depot/depot"],["images", "../../images" ],
			             ["orderHistory","../../orderHistory"],["account","../../account"]
			           ]
};