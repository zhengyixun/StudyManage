<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Error.aspx.cs" Inherits="Error" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<link rel="stylesheet" type="text/css" href="Css/Public.css"/>
		<style type="text/css">
			div { font-size: 16px; padding: 30px 0 0 50px; }
			div strong:before { content: '\e789'; font-family: iconfont; font-size: 36px; color: #C62B26; padding-right: 15px; }
			div span { display: block; padding: 20px; }
			div i { font-size: 12px; padding-left: 20px; }
		</style>
		<title></title>
	</head>
<body>
    <div>
        <strong><%=System.Web.HttpContext.Current.Items["T"].toString()%></strong>
        <span><%=System.Web.HttpContext.Current.Items["M"].toString()%></span>
        <i>如果您的浏览器没有自动跳转，<a href="<%=u%>" target="_<%=g%>">请点这里</a>。</i>
    </div>
    <script type="text/javascript">
        setTimeout(function(){
        	<%=g%>.location.href = "<%=u%>";
        },<%=System.Web.HttpContext.Current.Items["S"].toString(2)%> * 1000);
    </script>
</body>
</html>
