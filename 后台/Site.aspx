<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Site.aspx.cs" Inherits="Site" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
<script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
	<link rel="stylesheet" type="text/css" href="Css/Public.css"/>
    <title>场地管理</title>
</head>
<body>
    <div id="head">
        首页 > 场地管理  > 场地管理
        <a class="rbtn" href="javascript:location.reload();">&#xe6a4;</a>
    </div>
    <div id="search">
        <input type="text" id="key" placeholder="场地管理" />
        <span class="btn g btn_search">搜索</span>
        <a class="btn b btn_right btn_add" href="Site_Design.aspx">添加</a>
    </div>
    <div id="list">			
		<table cellpadding="1" cellspacing="1">
			<thead>
				<tr>
                    <td>编号</td>
					<td>场地名称</td>
					<td>场地面积</td>
                    <td>场地图片</td>
                    <td>可用时间段</td>
                    <td>已用时间段</td>
                    <td>操作</td>
				</tr>
			</thead>
			<tbody></tbody>
		</table>
		<div id="pager"></div>
	</div>
     <script>
        $(function () {
            //获取活动信息
            function GetSiteList(currentpage, pagesize, key) {
                $("tbody").empty();
                $("#pager").empty();
                $.ajax_({
                    method: "GetSiteList",
                    data: { currentpage, pagesize, key },
                    success: function (e) {
                        var data = JSON.parse(e.d);
                        var d_count = Math.ceil(data.count / pagesize);
                        for (var i = 0; i < d_count; i++) {
                            $("<span>").text(i + 1).appendTo($("#pager"))
                        }
                        data.list.forEach(function (item, index) {
                            console.log(item);
                            $("<tr>").html(`
                                <td>${data.count - index}</td>
                                <td>${$.Base64Decode(item.site_name)}</td>
					            <td>${$.Base64Decode(item.site_area)}</td>
                                <td>
                                    <img src="${item.site_img}" alt="暂无"/>
                                </td>
                                <td>${item.site_using_time_total}</td>
                                <td>${item.site_used_time}</td>
                                <td>
                                    <a class="btn b btn_edit" href="Site_Design.aspx?site_id=${item.site_id}&site_name=${item.site_name}&site_area=${item.site_area}&site_img=${item.site_img}&site_using_time_total=${item.site_using_time_total}">编辑</a>
                                    <a class="btn b btn_del" href="#" site_id="${item.site_id}">删除</a>    
                                </td>
                            `).appendTo($("tbody"))
                        });
                    },
                    error: function (e) {
                        console.log("错误信息" + e)
                    }
                })
            }
            GetSiteList(1, 10, "");
            //翻页
            $("#pager").on("click", "span", function () {
                GetSiteList($(this).text(), 10, "");
            })
            //删除单挑----场地信息
            $("tbody").on("click", ".btn_del", function () {
                var that = this;
                $.ajax_({
                    method: "DelSite",
                    data: { site_id: $(that).attr("site_id") },
                    success: function (e) {
                        if (e.d == true) {
                            alert("删除成功")
                            $(that).parent().parent().remove()
                        }
                    },
                    error: function (e) {
                        alert("错误信息：" + e);
                    }
                })
            })
        })
    </script>
</body>
</html>
