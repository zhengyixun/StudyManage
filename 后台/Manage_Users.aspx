<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Manage_Users.aspx.cs" Inherits="Manage_Users" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
		<link rel="stylesheet" type="text/css" href="Css/Public.css"/>
		<title></title>
	</head>

	<body>
		<div id="head">
			首页 > 管理人员  > 管理员管理
			<a class="rbtn" href="javascript:location.reload();">&#xe6a4;</a>
		</div>
		<div id="search">
			<input type="text" id="key" placeholder="登录名" />
			<span class="btn g btn_search">搜索</span>
			<a class="btn b btn_right btn_add" href="Manage_Users_Design.aspx">添加</a>
		</div>
		<div id="list">			
			<table cellpadding="1" cellspacing="1">
				<thead>
					<tr>
						<td class="li1">登录名</td>
						<td class="li2">姓名</td>
						<td class="li3">手机号</td>
						<td class="li6">状态</td>
						<td class="li7">编辑</td>
					</tr>
				</thead>
				<tbody></tbody>
			</table>
			<div id="pager"></div>
		</div>
		<script type="text/javascript">
            

			$("#search .btn_search").click(function(){
				location.href = $.setRequest({
					page: 1,
					key: $("#key").val().trim()
				});
			});
            $("#key").val($.getRequest("key"));
                        
			var states = ['停用','正常'];
			$.pageData({
				method: "ManageUserList", 
				data:{
					"currentpage":<%="page".getRequest(0)%>, 
					"pagesize":15,
					"key":$.getRequest("key")
				},
				pageDiv: $("#pager"), 
				setBody: function (count,list) {
					//id, uname, name, mobile, company,[state], last_login_time
					$.each(list, function(i,val){
						$("<tr>").html('<td class="li1">' + val.uname + '</td>'+
						'<td class="li2">' + $.Base64Decode(val.name) + '</td>'+
                        '<td class="li3">' + val.mobile + '</td>' +
						'<td class="li6"><span data-id="' + val.id + '" class="state s' + val.state + '">' + states[val.state] + '</span></td>'+
						'<td class="li7"><a class="btn b btn_edit" href="Manage_Users_Design.aspx?id=' + val.id + '">编辑</a></td>').appendTo($('#list tbody'));
					})
				}
			});
			$("#list").delegate(".state","click", function(){
				var self = $(this);
				$.ajax_({
        			method:"ManageUserSetState",
        			data:{
        				id:self.attr("data-id")
        			},
        			success:function(data){
        				if(data.d == -1)
        					alert("修改失败");
        				else
        					self.removeClass("s0 s1 s2").addClass("s" + data.d).html(states[data.d]);
        			}
        		});
			});
		</script>
	</body>

</html>