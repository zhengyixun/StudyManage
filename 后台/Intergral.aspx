<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Intergral.aspx.cs" Inherits="Activity_SignUp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
	<link rel="stylesheet" type="text/css" href="Css/Public.css"/>
    <title>积分管理</title>
</head>
<body>
    <div id="head">
        首页 > 积分管理  > 积分管理
        <a class="rbtn" href="javascript:location.reload();">&#xe6a4;</a>
    </div>
    <div id="search">
        <input type="text" id="key" placeholder="积分" />
        <span class="btn g btn_search">搜索</span>
    </div>
    <div id="list">			
		<table cellpadding="1" cellspacing="1">
			<thead>
				<tr>
					<td>积分管理</td>
					<td>积分管理</td>
                    <td>用户创建时间</td>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
		<div id="pager"></div>
	</div>
    <script>
        $(function () {
            //获取活动信息
            function GetIntergral(currentpage, pagesize, key) {
                $.ajax_({
                    method: "GetIntergral",
                    data: { currentpage, pagesize, key },
                    success: function (e) {
                        console.log(e.d);
                        var data = JSON.parse(e.d);
                    },
                    error: function (e) {
                        console.log("错误信息" + e)
                    }
                })
            }
            GetIntergral(1,10,"")
        })
    </script>
</body>
</html>
