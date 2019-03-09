<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Activity.aspx.cs" Inherits="Activity" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
	<link rel="stylesheet" type="text/css" href="Css/Public.css"/>
    <title>活动管理</title>
</head>
<body>
   <div id="head">
        首页 > 活动管理  > 活动管理
        <a class="rbtn" href="javascript:location.reload();">&#xe6a4;</a>
    </div>
    <div id="search">
        <input type="text" id="key" placeholder="活动名称" />
        <span class="btn g btn_search">搜索</span>
        <a class="btn b btn_right btn_add" href="Activity_Design.aspx">添加</a>
    </div>
    <div id="list">			
		<table cellpadding="1" cellspacing="1">
			<thead>
				<tr>
					<td>编号</td>
					<td>申请人姓名</td>
                    <td>活动名称</td>
                    <td>活动类型</td>
                    <td>人数限制</td>
					<td>活动场馆</td>
                    <td>场馆地址</td>
                    <td>活动时间</td>
                    <td>报名截止时间</td>
                    <td>活动状态</td>
					<td>申请时间</td>
                    <td>操作</td>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
		<div id="pager"></div>
	</div>
    <script>
        $(function () {
            function GetActivityList(currentpage, pagesize, key) {
                $.ajax_({
                    method: "GetActivityList",
                    data: { currentpage, pagesize, key },
                    success: function (e) {
                        var data = JSON.parse(e.d);
                        var d_count = Math.ceil(data.count / 10);
                        for (var i = 0; i < d_count; i++) {
                            $("<span>").text(i + 1).appendTo($("#pager"))
                        }
                        
                        data.list.forEach(function (item, index) {
                            var ds = item
                            if (item.activity_state == "0") {
                                item.activity_state = "待审核 "
                            } else if (item.activity_state == "1") {
                                item.activity_state = "已通过"
                            } else if (item.activity_state == "2") {
                                item.activity_state = "未通过"
                            } else if (item.activity_state == "3") {
                                item.activity_state = "已作废"
                            } else if (item.activity_state == "4") {
                                item.activity_state = "举办成功"
                            } else if (item.activity_state == "5") {
                                item.activity_state = "举办失败"
                            } else {
                                item.activity_state = "错误"
                            }
                            console.log(item)
                            $("<tr>").html(`
                                <td>${data.count - index}</td>
					            <td>${item.activity_creater_name}</td>
                                <td>${$.Base64Decode(item.activity_name)}</td>
                                <td>${item.activity_type}</td>
                                <td>${item.activity_min_people}/${item.activity_max_people}</td>
					            <td>${item.site_name}</td>
                                <td>${item.activity_address}</td>
                                <td>${item.activity_start_time}/${item.activity_end_time}</td>
                                <td>${item.activity_signup_end_time}</td>
                                <td>${item.activity_state}</td>
					            <td>${item.activity_create_time}</td>
                                <td>
                                    <a class="btn b btn_edit edit_apply" href="Activity_Design.aspx?activity_id=${item.activity_id}&item=${$.Base64Encode(JSON.stringify(ds))}">编辑/审核</a>
                                    <a class="btn b btn_del" href="#">删除</a>
                                </td>
                            `).attr("activity_id", item.activity_id).appendTo($("tbody"));
                        })
                    },
                    error: function (e) {
                        console.log("错误信息" + e)
                    }
                })
            }
            GetActivityList(1, 10, "");
            //翻页
            $("#pager").on("click", "span", function () {
                GetActivityList($(this).text(), 10, "");
            });
            //删除
            $("tbody").on("click", ".btn_del", function () {
                makeSureDelActivity($(this))
            })
            ////确定删除的方法
            function makeSureDelActivity(this_) {
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
                        method: "DelActivity",
                        data: {
                            activity_id: $(this).parent().parent().attr("activity_id")
                        },
                        success: function (e) {
                            console.log(e.d)
                            if (e.d == true) {
                                alert("删除成功")
                                $(that).parent().parent().remove()
                            }
                        },
                        error: function (e) {
                            console.log("错误信息" + JSON.stringify(e))
                        }
                    })
                })
            }
        })
    </script>
</body>
</html>
