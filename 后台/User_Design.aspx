<%@ Page Language="C#" AutoEventWireup="true" CodeFile="User_Design.aspx.cs" Inherits="User_Design" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
	<link rel="stylesheet" type="text/css" href="Css/Public.css" />
    <title></title>
    <style type="text/css">
	    
	    select { min-width: auto;margin-right: 5px; }
	    #flag div { border: 1px solid #999; float: left; padding: 5px; margin: 10px 10px 10px 0px; position: relative; clear: both; min-width: 150px; }
	        #flag div strong { display: block; position: absolute; top: -8px; left: 10px; }
	    #flag label { float: left; margin: 8px 5px 0px 5px; white-space: nowrap; }
	    #flag label.head { margin: 0px; background-color: #FFF; padding: 0px 5px; }
	    #areaTd i { color: red; }
        td{position:relative}
        h6.right { left: 210px; margin-top: 6px;}

	</style>
</head>
<body>
    <div id="head">
		首页 > 用户管理  > 用户管理 > <%="user_id".getRequest().IsNullOrEmpty()?"添加":"修改"%>管理员
		<a class="rbtn" href="javascript:location.reload();">&#xe6a4;</a>
		<a class="rbtn" href="<%=this.Context.Url()%>" id="back"><span>&#xe679;</span></a>
	</div>
    <div id="form">
        <table cellpadding="1" cellspacing="1">
            <tr>
				<td class="left" width="200">用户名称</td>
				<td><input type="text" id="wxuser_name" /><h6 class="right" for="wxuser_name">*</h6></td>
			</tr>
            
            <tr>
				<td class="left" width="200">手机号</td>
				<td><input type="text" id="wxuser_phone" /><h6 class="right" for="wxuser_phone">*</h6></td>
			</tr>
            <tr>
				<td class="left"></td>
				<td><span id="save" class="btn b">提交</span></td>
			</tr>
        </table>
    </div>
    <script>
        $(function () {
            $("input").focus(function () { $(this).siblings(".right").css("display","none")});
            $("#wxuser_phone").blur(function () {
                if ($.checkString("wx_phone", $(this).val()) == false) {
                    $(this).val("");
                    $(this).siblings(".right").css("display","block").text("手机号格式错误");
                }
            })
            
            $("#save").click(function () {
                if ($("#wxuser_name").val() == "") {
                    $("#wxuser_name").siblings(".right").css("display", "block").text("请输入用户名");
                    return
                }
                if ($("#wxuser_phone").val() == "") {
                    $("#wxuser_phone").siblings(".right").css("display", "block").text("请输入手机号");
                    return
                }
                <%="user_id".getRequest().IsNullOrEmpty()?"add":"upd"%>(); //判断 执行哪个方法
                
            });
            function upd() {  //编辑的方法
                $.ajax_({
                    method: "UpdateUser",
                    data: {
                        user_name: $("#wxuser_name").val(),
                       
                        user_phone: $("#wxuser_phone").val(),
                        user_id: $.getRequest("user_id")
                    },
                    success: function (e) {
                        console.log(e.d)
                        if (e.d == true) {
                            alert("修改成功");
                            location.href = "User.aspx";
                        } else {
                            alert("手机号已存在,修改失败");
                        }
                    },
                    error: function (e) {
                        console.log("错误信息：" +e)
                    }
                })

            }
            function add() {  //添加的方法
                $.ajax_({
                    method: "AddUser",
                    data: {
                        user_name: $("#wxuser_name").val(),
                        
                        user_phone: $("#wxuser_phone").val()
                    },
                    success: function (e) {
                        console.log(e.d)
                        if (e.d == true) {
                            $("#wxuser_name").val("");
                            $("#wxuser_wx_num").val('');
                            $("#wxuser_phone").val("");
                            alert("添加成功");
                            location.href = "User.aspx";
                        }
                    },
                    error: function (e) {
                        console.log("错误信息" + JSON.stringify(e))
                    }
                })
            }

            //console.log($.getRequest("user_id") + "------" + $.getRequest("user_wx_num") + "------" + $.getRequest("user_phone") + "------" + $.getRequest("user_name"))
            $("#wxuser_name").val($.getRequest("user_name"));
            $("#wxuser_phone").val($.getRequest("user_phone"));
        })
    </script>
</body>
</html>
