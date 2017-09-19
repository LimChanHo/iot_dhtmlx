<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page session="false"%>
<%@ include file="/WEB-INF/views/common/header.jsp"%>
<title>DB Manager</title>
</head>
<script>
var alert = dhtmlx.alert;
var myLayout;
var myToolbar;
var myTreeView;
var myTabbar;
var myEditor;
var grid_a;
var grid_b;
var grid_c;
var grid_d;
var treeId;
var grid_query;

function clickEvent(btn) {
	
	if(btn=="addNewConnection") {
		alert("addNewConnection");
		
	} else if(btn=="connectionBtn") {
		var au = new AjaxUtil("db/connecte");
		var diNum = grid_a.getSelectedRowId();
		
		
		if(diNum==null) {
			alert("접속하실 데이터베이스를 선택해주세요");
			return;
		}
		
		var param = {};
		param["diNum"] = diNum;
		au.param = JSON.stringify(param);
		au.setCallbackSuccess(ConnectionSuccess);
		au.send();
		
	} else if(btn=="disConnect") {
		var onAndOff = confirm("DB연결을 종료하시겠습니까?");
		if (onAndOff == true) {
			myToolbar.hideItem("disConnect");
			myToolbar.showItem("connectionBtn");
			location.href = "${rootPath}/db/iot_sql";	
		} else if(onAndOff==false) {
			myToolbar.hideItem("connectionBtn");
			myToolbar.showItem("disConnect");
		}
	} else if(btn=="run") {
		var query = $("textarea").val();
		//alert(query);
	}
} 

function ConnectionSuccess(result) {
	if(result.error){
		alert(result.error);
		return;
	}
	
	myToolbar.hideItem("connectionBtn");
	myToolbar.showItem("disConnect");
	
	var databaseList = result.databaseList;
	var str = "<?xml version='1.0' encoding='utf-8'?>";
		str += "<tree id = '0' radio='1'>";
	for (var i=0; i<databaseList.length;i++) {
		var db = databaseList[i].database;
		str += "<item text='"+db+"' id='"+db+"'>";
		str += "</item>";
	}
	str += "</tree>"
	myTreeView = myLayout.cells("a").attachTree();
	myTreeView.setImagePath("${rootPath}/resources/dhtmlx/skins/material/imgs/dhxtree_material/");
	myTreeView.parse(str, "xml");
	myTreeView.setOnClickHandler(clickTree);
} 

	function clickTree(e) {
		treeId = myTreeView.getSelectedItemId(e);
		myTreeView.deleteChildItems(treeId);
		var param = {};
		var au = new AjaxUtil("db/table/list");
		param["database"] = treeId;
		au.param = JSON.stringify(param);
		au.setCallbackSuccess(tableListView);
		au.send();
	}
	
	function tableListView(result) {
			if(result.error){
				return;
			}
			treeId = myTreeView.getSelectedItemId(0);	
			
			var tableList = result.tableList;
			for (var i = 0; i < tableList.length; i++) {
				var table = tableList[i];
				myTreeView.insertNewItem(treeId, table.tableName, table.tableName);
				myTreeView.setImagePath("${rootPath}/resources/dhtmlx/skins/terrace/imgs/dhxtree_terrace/");
			}
			myTreeView.setOnClickHandler(tableInfoList);
		}
	
	function tableInfoList() {
		
		treeId = myTreeView.getSelectedItemId(0);	
		var param = {};
		var au = new AjaxUtil("db/table/info");
		param["tableName"] = treeId;
		au.param = JSON.stringify(param);
		au.setCallbackSuccess(tableInfoView);
		au.send();
	}
	
	function tableInfoView(result) {
		var result = result.tableInfo;
		var rows = [];
		$.each(result, function(index, value) {
			var array = new Array();
			array.push(value.columnName);
			array.push(value.dataType);
			array.push(value.characterMaximumLength);
			array.push(value.isNullable);
			var row = {	id : index + 1,	data : array };
			rows.push(row);
		});
		var str = {
			rows : rows
		};
		grid_b.clearAll();
		grid_b.parse(str, "json");
	}
	
	function callback(result) { // db_info select allback
		var result = result.list;
		var rows = [];
		$.each(result, function(index, value) {
			var array = new Array();
			array.push(value.diNum);
			array.push(value.dbTitle);
			var row = {	id : index + 1,	data : array };
			rows.push(row);
		});
		var str = {
			rows : rows
		};
		grid_a.parse(str, "json");

	};
	function callbackSql(result) {
		
		var key;
      if(result.resultMap) {
         key = result.resultMap;
         console.log(key.columns);
         $("#logs").html("<br/>/* Your SQL syntax... " + $("textarea").val());
         $("#logs").append("<br/>/* Select columns... " + key.columns);
         $("#logs").append("<br/>/* Select columns_length... " + key.columns.length+"<p>");
      } else {
         $("#logs").html("<br/>/*" + result.error+"<p>");
      }

    	grid_c.clearAll(true); 
		var headerStr = "";
		var headerAligns = new Array();
		var colTypesStr = "";
		var colAlignStr = "";
		var colSortingStr ="";
		$.each(key.columns, function(index, value) {
			headerAligns[headerAligns.length] = "text-align:center;";
			colTypesStr += "ro,";
			colAlignStr += "center,";
			colSortingStr +="str,";
		});
		var rows = [];
		$.each(result.resultMap.list, function(index, value) {
			var array = new Array();
			$.each(key.columns, function(idx,val){
				array.push(value[val]);
			});
			var row = {	id : index + 1,	data : array };
			rows.push(row);
		});
		grid_c.setHeader(key.columns,"", headerAligns);
		grid_c.setColTypes(colTypesStr); 
		grid_c.setColAlign(colAlignStr); 
		grid_c.setColSorting(colSortingStr);
		grid_c.setColumnIds(key.columns.toString());

		var str = {
			rows : rows
		};
		
		grid_c.init();
		grid_c.parse(str, "json");
	} 
	
	
	
	
	$(document).ready(function() {
		
		myLayout = new dhtmlXLayoutObject({ // layout
			parent : document.body,
			pattern : "4C",
			skin : "material",
			cells : [ {	id : "a", text : "IOT_SQL"}, 
					{id : "b"}, 
					{id : "c", text : "LIST"}, 
					{id : "d",	header : false} ]
		});

		myTabbar = myLayout.cells("b").attachTabbar({
			//close_button: true,
			tabs : [ {id : "table_info", text : "테이블 정보", active : true}, 
					{id : "query",text : "쿼리"}
			]
			// { id: "b2", text: "<span class='tab_timeline'>쿼리</span>"}
			
		});
		grid_b = myTabbar.tabs("table_info").attachGrid();
		grid_b.setHeader(
						"컬럼명(columnName), 데이터타입(dataType), 길이(MaximumLength), 널 허용여부(isNullable)",
						"", [ "text-align:center;",
								"text-align:center;",
								"text-align:center;",
								"text-align:center" ]);
		grid_b.setColTypes("ro,ro,ro,ro");
		//grid_b.setInitWidths("200,200,200,200");
		grid_b.setColAlign("center,center,center,center");
		grid_b.setColSorting("str,str,int,str");
		grid_b.enableResizing("true,true,true,true");
		grid_b.init();

		
		tabToolbar = myTabbar.tabs("query").attachToolbar({
			icons_path: "${rootPath}/resources/dhtmlx/samples/dhtmlxToolbar/common/imgs/",
			xml: "${rootPath}/resources/dhtmlx/dhxtoolbar_button.xml" //id = run;
		});
		
		tabToolbar.attachEvent("onClick", clickEvent);
		grid_query = myTabbar.tabs("query").attachGrid();
		grid_query.setHeader("<textarea style = 'width: 100%; height: 175px; '></textarea>")
		grid_query.setInitWidths("*")
		grid_query.init();
		
		myToolbar = myLayout.cells("a").attachToolbar({
							icons_path : "${rootPath}/resources/dhtmlx/samples/dhtmlxToolbar/common/imgs/",
							xml : "${rootPath}/resources/dhtmlx/connection_button.xml" // id = addNewConnection, connectionBtn
		});
		myToolbar.hideItem("disConnect");
		myToolbar.attachEvent("onClick", clickEvent);
	
		grid_a = myLayout.cells("a").attachGrid();
		grid_a.setImagePath("${rootPath}/resources/dhtmlx/skins/material/imgs");
		grid_a.setHeader("No., DB Name", "", ["text-align:center;", "text-align:center;" ]);
		grid_a.setColTypes("ro,ro"); //sets the types of columns
		grid_a.setColAlign("center,center"); //sets the x alignment
		grid_a.setColSorting("int,str");
		grid_a.setColumnIds("diNum,dbTitle");
		grid_a.init();

		myLayout.cells("a").setWidth(300);
		myLayout.cells("b").setHeight(300);
		myLayout.cells("c").setHeight(400);
		grid_c = myLayout.cells("c").attachGrid();
		grid_c.setImagePath("${rootPath}/resources/dhtmlx/skins/material/imgs");
		grid_c.init();
		
		myLayout.cells("b").attachStatusBar({
			text : ""
		});
		grid_d = myLayout.cells("d").attachHTMLString("<div id= 'logs'><u>logs...</u><div>");
		var param = {}; 
		var au = new AjaxUtil("db/list/tree");
		au.param = JSON.stringify(param);
		au.setCallbackSuccess(callback);
		au.send();
		
		var cnt = 0;
		$( "textarea" ).keydown(function(e) {
			var keyCode = e.keyCode || e.which;
			if(keyCode==120){
				cnt++;
				console.log(cnt);
				var sql;
				var sqls;
				if(e.ctrlKey && keyCode==120 && e.shiftKey){
					sql = this.value;
					var cursor = this.selectionStart;
					var startSql = sql.substr(0,cursor);
					var startSap = startSql.lastIndexOf(";")
					startSql = startSql.substr(startSap+1);
					var endSql = sql.substr(cursor);
					var endSap = endSql.indexOf(";");
					if(endSap==-1) {
						endSap=sql.length;
					}
					endSql = endSql.substr(0,endSap);
					sql = startSql + endSql;
				}else if(e.ctrlKey && keyCode==120){
					sql = this.value.substr(this.selectionStart, this.selectionEnd - this.selectionStart);
				}else if(keyCode==120){
					sql = this.value;
				}
				if(sql){
					sql = sql.trim();
					sqls = sql.split(";");
					if(sqls.length==1){
						var au = new AjaxUtil("db/run/sql");
						var param = {};
						param["sql"] = sql;
						au.param = JSON.stringify(param);
						au.setCallbackSuccess(callbackSql);
						au.send();
						return;
					}else if(sqls){
						
						return;
					}
				}
				
			}
		});
	});
</script>
<body>
</body>
<style>
html, body {
	position: relative;
	overflow: hidden;
	font-family: Roboto, Arial, Helvetica;
	margin: 0px;
	font-size: 15px;
}

textarea {
	font-family: monospace;
	border-color: rgb(169, 169, 169);
}

textarea {
	-webkit-appearance: textarea;
	background-color: white;
	-webkit-rtl-ordering: logical;
	user-select: text;
	flex-direction: column;
	resize: auto;
	cursor: auto;
	white-space: pre-wrap;
	word-wrap: break-word;
	border-width: 1px;
	border-style: solid;
	border-color: initial;
	border-image: initial;
	padding: 2px;
}
</style>
</html>