<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EditPass.aspx.cs" Inherits="EditPass" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
		<link rel="stylesheet" type="text/css" href="Css/Public.css" />
		<style type="text/css">
	    	h6.right { left: 210px; margin-top: 6px; }
		</style>
		<title></title>
	</head>

	<body>
		<div id="head">
			首页 > 管理中心 > 修改密码
			<a class="rbtn" href="javascript:location.reload();">&#xe6a4;</a>
		</div>
		<div id="form">
			<table cellpadding="1" cellspacing="1">
				<tr>
					<td class="left" width="200">原密码</td>
					<td><input type="password" id="oldpass" /><h6 class="right" for="oldpass"></h6></td>
				</tr>
				<tr>
					<td class="left">新密码</td>
					<td><input type="password" id="newpass" /><h6 class="right" for="newpass"></h6></td>
				</tr>
				<tr>
					<td class="left">确认密码</td>
					<td><input type="password" id="newpass1" /><h6 class="right" for="newpass1"></h6></td>
				</tr>
				<tr>
					<td class="left"></td>
					<td><span id="save" class="btn b">提交</span></td>
				</tr>
			</table>
		</div>
		<script type="text/javascript">
			$.submitform([
	        	{id:"oldpass", empty:"请输入原密码"},
	        	{id:"newpass", empty:"请输入新密码"},
	        	{id:"newpass1", empty:"请输入确认密码"}
	        ], function(ret){
				$("#save").click(function(){
					if(!ret()) return;
					if($("#newpass").val() != $("#newpass1").val()){
						$("h6[for='newpass1']").html("两次输入密码不一致").show();
						$("#newpass").focus();
						return;
					}
	        		$.ajax_({
	        			btn: $("#save"),
	        			method:"EditPass",
	        			data:{
	        				oldpass:$("#oldpass").val().trim(),
	        				newpass:$("#newpass").val().trim()
	        			},
	        			form:"正在提交，请稍候...",
	        			success:function(data){
	        				if(data.d)
	        					$.setLoadingSuccess("修改成功");
	        				else
	    						$.setLoadingFailed("修改失败");
	        			},
	        			error:function(err){
	    					$.setLoadingFailed("操作失败");
	        			}
	        		})
	        	});
	        });
		</script>
	</body>

</html>