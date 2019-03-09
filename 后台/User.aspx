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
<style type="text/css">
    .account_state{
        background:#5EB95E;padding:5px;color:#fff;
    }
    .account_state_1{
        background:#ccc;padding:5px;color:#fff;
    }
</style>
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
                        <td class="li1">性别</td>
						<td class="li2">微信昵称</td>
                        <td>头像</td>
						<td class="li3">手机号</td>
						<td class="li6">openid</td>
                        <td>微信状态</td>
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
                            //console.log(item)
                            $("<tr>").html(`
                                <td>${$.Base64Decode(item.user_name)}</td>
                                <td>${item.user_sex}</td>
                                <td>${item.user_wx_name}</td>
                                <td>${item.user_wx_img}</td>
                                <td>${item.user_phone}</td>
                                <td>${item.openid}</td>
                                <td>${item.user_state == "0" ? "未激活" : "已激活"}</td>
                                <td><span user_id="${item.user_id}" user_account_state="${item.user_account_state}" class="account ${item.user_account_state == 0 ? "account_state_1" : "account_state"}">${item.user_account_state == 0 ? "停用" : "正常"}</span></td>
                                <td>${item.user_create_time}</td>
                                <td>
                                    <a class="btn b btn_edit" href="User_Design.aspx?user_id=${item.user_id}&user_name=${$.Base64Decode(item.user_name)}&user_wx_num=${item.user_wx_num}&user_phone=${item.user_phone}">编辑</a>
                                    <a class="btn b btn_del" href="#">删除</a>
                                </td>
                            `).attr("user_id",item.user_id).appendTo($("table tbody"))
                        })
                    }
                })
            }
            GetUserData(1, 10, '')
            $("#pager").on("click", "span", function () {
                GetUserData($(this).text(), 10, '')
            })
            //确定删除的方法
            function makeSureDel(this_) {
                var oldstr = this_.parent("td").html();
                this_.parent().empty().html(`
                    <a class="btn b makesure" href="#">确定</a>
                    <a class="btn b cancels" style="background:#ccc" href="#" >取消</a>
                `);
                $(".cancels").click(function () {
                    $(this).parent().empty().html(oldstr);
                });
                $(".makesure").click(function () {
                    var that = this;
                    $.ajax_({
                        method: "DelUser",
                        data: {
                            user_id: $(this).parent().parent().attr("user_id")
                        },
                        success: function (e) {
                            console.log(e.d)
                            if (e.d == true) {
                                alert("删除成功")
                                $(that).parent().parent().remove()
                            }
                        },
                        error: function (e) {
                            console.log("错误信息" + e)
                        }
                    })
                })
            }
            
            //删除单挑用户数据
            $("tbody").on("click", ".btn_del", function () {
                makeSureDel($(this));
            });
            //变更用户状态
            $("tbody").on("click", ".account", function () {
                var that = this;
                $.ajax_({
                    method: "UserSetState",
                    data: {
                        user_account_state:$(that).attr("user_account_state"),
                        user_id:$(that).attr("user_id")
                    },
                    success: function (e) {
                        console.log(e.d);
                        if (e.d == true) {
                            alert("修改成功");
                            if ($(that).attr("user_account_state") == 1) {
                                $(that).removeClass("account_state").addClass("account_state_1").text("停用");
                                $(that).attr("user_account_state","0")
                            } else if ($(that).attr("user_account_state") == 0) {
                                $(that).removeClass("account_state_1").addClass("account_state").text("正常")
                                $(that).attr("user_account_state","1")
                            }
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
