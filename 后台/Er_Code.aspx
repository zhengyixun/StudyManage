<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Er_Code.aspx.cs" Inherits="Er_Code" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
	<link rel="stylesheet" type="text/css" href="Css/Public.css"/>
    <title>验证码管理</title>
</head>
<body>
   <div id="head">
        首页 > 验证码管理  > 验证码管理
        <a class="rbtn" href="javascript:location.reload();">&#xe6a4;</a>
    </div>
    <div id="search">
        <input type="text" id="key" placeholder="验证码管理" />
        <span class="btn g btn_search">搜索</span>
    </div>
    <div id="list">			
		<table cellpadding="1" cellspacing="1">
			<thead>
				<tr>
					<td>手机号</td>
					<td>验证码</td>
                    <td>用户创建时间</td>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
		<div id="pager"></div>
	</div>
    <script>
        $(function () {
            function GetErCode(currentpage,pagesize,key) {
                $.ajax_({
                    method: "GetErCodeList",
                    data: {currentpage,pagesize,key},
                    success: function (e) {
                        console.log(e.d);
                        var data = JSON.parse(e.d);
                        var d_count = Math.ceil(data.count / 10);
                        for (var i = 0; i < d_count; i++) {
                            $("<span>").text(i + 1).appendTo($("#pager"))
                        }
                        data.list.forEach(function (item, index) {
                            console.log(item)
                            $("<tr>").html(`
                                <td>${item.code_phone}</td>
                                <td>${item.code_num}</td>
                                <td>${item.code_create_time}</td>
                            `).appendTo($("table tbody"))
                        })
                    },
                    error: function (e) {
                        console.log("错误信息" + e)
                    }
                })
            }
            GetErCode(1, 10, "");
            $("#pager").on("click", "span", function () {
                GetErCode($(this).text(), 10, '')
            })
        })
    </script>
</body>
</html>
