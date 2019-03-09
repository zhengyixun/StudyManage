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
                    <td>编号</td>
					<td>姓名</td>
					<td>总积分</td>
					<td>变化积分</td>
                    <td>变化原因</td>
                    <td>使用时间</td>
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
                $("tbody").empty();
                $("#pager").empty();
                $.ajax_({
                    method: "GetIntergral",
                    data: { currentpage, pagesize, key },
                    success: function (e) {
                        var data = JSON.parse(e.d);
                        var d_count = Math.ceil(data.count / 10);
                        for (var i = 0; i < d_count; i++) {
                            $("<span>").text(i + 1).appendTo($("#pager"))
                        };
                        data.list.forEach(function (item, index) {
                            $("<tr>").html(`
                                <td>${d_count-index}</td>
                                <td>${item.user_name}</td>
                                <td>${item.intergral_total}</td>
                                <td>${item.intergral_change_num}</td>
                                <td>${$.Base64Decode(item.intergral_change_why)}</td>
                                <td>${item.intergral_using_time}</td>
                               
                            `).attr("intergral_id",item.intergral_id).appendTo($("table tbody"))
                        })
                    },
                    error: function (e) {
                        console.log("错误信息" + e)
                    }
                })
            }
            GetIntergral(1, 10, "");
            $("#pager").on("click", "span", function () {
                GetIntergral($(this).text(), 10, '')
            })
        })
    </script>
</body>
</html>
