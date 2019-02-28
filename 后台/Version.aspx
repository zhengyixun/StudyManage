<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Version.aspx.cs" Inherits="Er_Code" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
	<link rel="stylesheet" type="text/css" href="Css/Public.css"/>
    <title>版本管理</title>
</head>
<body>
   <div id="head">
        首页 > 版本管理  > 版本管理
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
					<td>编号</td>
					<td>版本号</td>
                    <td>更新内容</td>
                    <td>创建时间</td>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
		<div id="pager"></div>
	</div>
    <script>
        $(function () {
            function GetVersionList(currentpage, pagesize, key) {
                $("tbody").empty();
                 $("#pager").empty();
                $.ajax_({
                    method: "GetVersionList",
                    data: {currentpage,pagesize,key},
                    success: function (e) {
                        var data = JSON.parse(e.d);
                        var d_count = Math.ceil(data.count / 10);
                        for (var i = 0; i < d_count; i++) {
                            $("<span>").text(i + 1).appendTo($("#pager"))
                        }
                        data.list.forEach(function (item, index) {
                            console.log(item);
                            $("<tr>").html(`
                                <td>${d_count-index}</td>
					            <td>${item.version_num}</td>
                                <td>${item.version_update_con}</td>
                                <td>${item.version_update_time}</td>
                            `).appendTo($("tbody"))
                        })
                    },
                    error: function (e) {
                        console.log("错误信息" + e)
                    }
                })
            }
            GetVersionList(1, 10, "");
            $("#pager").on("click", "span", function () {
                GetVersionList($(this).text(), 10, '')
            })
        })
    </script>
</body>
</html>
