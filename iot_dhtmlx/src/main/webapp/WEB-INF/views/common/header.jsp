<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page trimDirectiveWhitespaces="true" %>
<c:set var="rootPath" value="${pageContext.request.contextPath}"/>
<!DOCTYPE>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>

<!-- dhtmlx 
	codebase
	../dhtmlx/samples/dhtmlxToolbar/common/grid.xml
 -->
<link rel="stylesheet" href="<c:url value ='/resources/dhtmlx/codebase/dhtmlx.css'/>"/>
<script src="<c:url value = '/resources/dhtmlx/codebase/dhtmlx.js'/>"></script>
<link rel="stylesheet" href="<c:url value ='/resources/dhtmlx/codebase/fonts/font_roboto/roboto.css'/>"/>
<link rel="stylesheet" href="<c:url value ='/resources/dhtmlx/skins/web/dhtmlx.css'/>"/>
<link rel="stylesheet" href="<c:url value ='/resources/dhtmlx/skins/terrace/dhtmlx.css'/>"/>
<link rel="stylesheet" href="<c:url value ='/resources/dhtmlx/skins/skyblue/dhtmlx.css'/>"/>
<script src ="<c:url value='/resources/js/jquery-3.2.1.js' />"></script>
<script src="<c:url value="/resources/ui/common.js"/>"></script>
<script src="<c:url value="/resources/js/jquery-ui-1.9.2.custom.js"/>"></script>
<script src="<c:url value="/resources/js/jquery.fileupload.js"/>"></script>
<script src="<c:url value="/resources/js/jquery.iframe-transport.js"/>"></script>
<script>
var AjaxUtil = function (url, params, type, dataType){
	if(!url){
		alert("url정보가 없습니다.");
		return null;
	}
	this.url = "${rootPath}/" + url;
	
	var generateJSON = function(params){
		if(!params) return "";
		var paramArr = params.split(",");
		var data = {};
		for(var i=0,max=paramArr.length;i<max;i++){
			var key = paramArr[i]
			if($("#" + key).length>1){
				throw new JSException("동일 ID값이 존재함.");
			}else if($("#" + key).length==0){
				throw new JSException(key+"에 해당하는 ID가 존재하지 않음.");
			}
			data[key] = $("#" + key).val();
		}
		return  JSON.stringify(data);
	}
	this.type = type?type:"POST";
	this.dataType = dataType?dataType:"json";
	this.param = generateJSON(params);
	this.callbackSuccess = function(json){
    	var url = json.url;
    	var msg = json.msg;
    	if(msg){
    		alert(msg);
    	}
    	if(url){
        	pageMove(url);
    	}
	}
	
	this.setCallbackSuccess = function(callback){
		this.callbackSuccess = callback;
	}
	
	this.send = function(){
		$.ajax({ 
	        type     : this.type
	    ,   url      : this.url
	    ,   dataType : this.dataType 
	    ,   beforeSend: function(xhr) {
	        xhr.setRequestHeader("Accept", "application/json");
	        xhr.setRequestHeader("Content-Type", "application/json");
	    }
	    ,   data     : this.param
	    ,   success : this.callbackSuccess
	    ,   error : function(xhr, status, e) {
		    	alert("에러 : "+e);
		},
		complete : function(e) {
		}
		});
	}
}
	
    </script>