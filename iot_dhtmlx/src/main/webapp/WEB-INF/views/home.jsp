<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="<c:url value="/resources/ui/common.js"/>"></script>
<script src ="<c:url value='/resources/js/jquery-3.2.1.js' />"></script>
<!DOCTYPE>
<html>
<head>
	<title>Home</title>
</head>
<script>
	$(document).ready(function(){
		var pParams = {};
		alert(pParams);
		movePageWithAjax(pParams, "/test/test", callback);
	});
	
	function callback(result) {
		alert(1);
	}
</script>
<body>
<h1>
	Hello world!  
</h1>

<P>  The time on the server is ${serverTime}. </P>
</body>
</html>
