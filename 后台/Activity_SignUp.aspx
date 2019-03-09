<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Activity_SignUp.aspx.cs" Inherits="Activity_SignUp" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
	<link rel="stylesheet" type="text/css" href="Css/Public.css"/>
    <title>报名管理</title>
</head>
<body>
    <div id="head">
        首页 > 活动管理  > 报名管理
        <a class="rbtn" href="javascript:location.reload();">&#xe6a4;</a>
    </div>
    <div id="search">
        <input type="text" id="key" placeholder="报名" />
        <span class="btn g btn_search">搜索</span>
    </div>
    <div id="list">			
		<table cellpadding="1" cellspacing="1">
			<thead>
				<tr>
					<td>编号</td>
					<td>报名者</td>
                    <td>报名角色</td>
                    <td>活动名称</td>
                    <td>活动时间</td>
                    <td>活动场地</td>
                    <td>签到时间</td>
                    <td>签退时间</td>
                    <td>获得积分</td>
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
            function GetActivitySignUpList(currentpage, pagesize, key) {
                $("tbody").empty();
                $("#pager").empty();
                $.ajax_({
                    method: "GetActivitySignUpList",
                    data: { currentpage, pagesize, key },
                    success: function (e) {
                        var data = JSON.parse(e.d);
                        var d_count = Math.ceil(data.count / 10);
                        for (var i = 0; i < d_count; i++) {
                            $("<span>").text(i + 1).appendTo($("#pager"))
                        };
                        data.list.forEach(function (item, index) {
                            console.log(item);

                            $("<tr>").html(`
                                <td>${d_count-index}</td>
                                <td signup_user_id="${item.signup_user_id}">${$.Base64Decode(item.signup_user_name)}</td>
                                <td>${item.signup_user_type=="0"?"志愿者":"参与者"}</td>
                                <td signup_activity_id="${item.signup_activity_id}">${item.activity_name}</td>
                                <td>${item.activity_start_time}/${item.activity_end_time}</td>
                                <td>${item.activity_address}</td>
                                <td>${item.signup_in_time==""?"未签到":item.signup_in_time}</td>
                                <td>${item.signup_out_time == "" ? "未签退" : item.signup_out_time}</td>
                                <td>0</td>
                                <td>${item.signup_create_time}</td>
                            `).attr("signup_id",item.signup_id).appendTo($("table tbody"))
                        })
                    },
                    error: function (e) {
                        console.log("错误信息" + e)
                    }
                })
            }
            GetActivitySignUpList(1, 10, "");
            $("#pager").on("click", "span", function () {
                GetActivitySignUpList($(this).text(), 10, '')
            })
        })
    </script>
</body>
</html>
