<%@ Page Language="C#" AutoEventWireup="true" CodeFile="User.aspx.cs" Inherits="User" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
	<link rel="stylesheet" type="text/css" href="Css/Public.css"/>
    <title>用户管理</title>
</head>
<body>
    <div id="head">
			首页 > 用户管理  > 用户管理
			<a class="rbtn" href="javascript:location.reload();">&#xe6a4;</a>
		</div>
		<div id="search">
			<input type="text" id="key" placeholder="登录名" />
			<span class="btn g btn_search">搜索</span>
			<a class="btn b btn_right btn_add" href="User_Design.aspx">添加</a>
		</div>
		<div id="list">			
			<table cellpadding="1" cellspacing="1">
				<thead>
					<tr>
						<td class="li1">姓名</td>
						<td class="li2">微信昵称</td>
						<td class="li3">手机号</td>
						<td class="li6">微信号</td>
						<td class="li6">openid</td>
                        <td>用户状态</td>
                        <td class="li7">用户创建时间</td>
                        <td class="">操作</td>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
			<div id="pager"></div>
		</div>
    <script>
        $(function () {
            
            //获取用户数据的方法
            function GetUserData(currentpage, pagesize, key) {
                $("table tbody").empty();
                $("#pager").empty();
                $.ajax_({
                    method: "GetUserLists",
                    data: { 'currentpage': currentpage,'pagesize': pagesize,'key':key},
                    success: function (e) {
                        var data = JSON.parse(e.d);
                        var d_count = Math.ceil(data.count / 10);
                        for (var i = 0; i < d_count; i++) {
                            $("<span>").text(i + 1).appendTo($("#pager"))
                        }
                        data.list.forEach(function (item, index) {
                            console.log(item)
                            $("<tr>").html(`
                                <td>${$.Base64Decode(item.user_name)}</td>
                                <td>${item.user_wx_name}</td>
                                <td>${item.user_phone}</td>
                                <td>${item.user_wx_num}</td>
                                <td>${item.openid}</td>
                                <td>${item.user_state=="0"?"未激活":"已激活"}</td>
                                <td>${item.user_create_time}</td>
                                <td>
                                    <a class="btn b btn_edit" href="User_Design.aspx?user_id=${item.user_id}&user_name=${$.Base64Decode(item.user_name)}&user_wx_num=${item.user_wx_num}&user_phone=${item.user_phone}">编辑</a>
                                    <a class="btn b btn_del" href="#" user_id="${item.user_id}">删除</a>
                                </td>
                            `).appendTo($("table tbody"))
                        })
                    }
                })
            }
            GetUserData(1, 10, '')
            $("#pager").on("click", "span", function () {
                GetUserData($(this).text(), 10, '')
            })



            //删除单挑用户数据
            $("tbody").on("click", ".btn_del", function () {
                var that = this;
                $.ajax_({
                    method: "DelUser",
                    data: {
                        user_id:$(this).attr("user_id")
                    },
                    success: function (e) {
                        console.log(e.d)
                        if (e.d == true) {
                            $(that).parent().parent().remove()
                        }
                    },
                    error: function (e) {
                        console.log("错误信息" + e)
                    }
                })
                
            })
        })
    </script>
</body>
</html>
