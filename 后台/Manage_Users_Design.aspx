<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Manage_Users_Design.aspx.cs" Inherits="Manage_Users_Design" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
		<link rel="stylesheet" type="text/css" href="Css/Public.css" />
		<title></title>
		<style type="text/css">
	    	h6.right { left: 210px; margin-top: 6px; }
	    	select { min-width: auto;margin-right: 5px; }
	        #flag div { border: 1px solid #999; float: left; padding: 5px; margin: 10px 10px 10px 0px; position: relative; clear: both; min-width: 150px; }
	            #flag div strong { display: block; position: absolute; top: -8px; left: 10px; }
	        #flag label { float: left; margin: 8px 5px 0px 5px; white-space: nowrap; }
	        #flag label.head { margin: 0px; background-color: #FFF; padding: 0px 5px; }
	    	#areaTd i { color: red; }
		</style>
	</head>

	<body>
		<div id="head">
			首页 > 管理人员  > 管理员管理 > <%="id".getRequest().IsNullOrEmpty()?"添加":"修改"%>管理员
			<a class="rbtn" href="javascript:location.reload();">&#xe6a4;</a>
			<a class="rbtn" href="<%=this.Context.Url()%>" id="back"><span>&#xe679;</span></a>
		</div>
		<div id="form">
			<table cellpadding="1" cellspacing="1">
				<tr>
					<td class="left" width="200">管理员名称</td>
					<td><input type="text" id="x_uname" /><h6 class="right" for="x_uname"></h6></td>
				</tr>
				<tr>
					<td class="left">密码</td>
					<td><input type="password" id="x_pass" /><h6 class="right" for="x_pass"></h6></td>
				</tr>
				<tr>
					<td class="left">管理员姓名</td>
					<td><input type="text" id="name" /><h6 class="right" for="name"></h6></td>
				</tr>
				<tr>
					<td class="left">手机号</td>
					<td><input type="text" id="mobile" /><h6 class="right" for="mobile"></h6></td>
				</tr>
				<tr>
					<td class="left">权限</td>
					<td id="flag"><%=flag%></td>
				</tr>
				<tr>
					<td class="left"></td>
					<td><span id="save" class="btn b">提交</span></td>
				</tr>
			</table>
		</div>
		<script type="text/javascript">
            $(".head input[type='checkbox']").click(function () {
                $(this).parents("div.menu").find(".item input[type='checkbox']").prop("checked", $(this).prop("checked"));
            });
            $(".item input[type='checkbox']").click(function () {
                $(this).parents("div.menu").find(".head input[type='checkbox']").prop("checked",
                    $(this).parents("div.menu").find(".item input[type='checkbox']").length ==
                    $(this).parents("div.menu").find(".item input[type='checkbox']:checked").length
                    );
            });
			if($.getRequest("id") != "")
	        	$.ajax_({
	    			method:"ManageUserGet",
	    			data:{
	    				id:"<%="id".getRequest()%>"
	    			},
	    			form: "正在获取数据，请稍候...",
	    			success:function(data){
	    				//console.log(data)
	    				$("span.loading").remove();
	    				if(data.d == "")
	    					return;
	    			
	    				var js = JSON.parse(data.d);
	    				var myflag = js.flag.split(",");
			            $.checkin = function (inary) {
			                for(var i=0; i<inary.length; i++)
			                	if (jQuery.inArray(inary[i], myflag) < 0) //有一个不在就返回false
			                		return false;
			                return true;
			            }
			            $.each($(".item input[type='checkbox']"), function (i, val) { //选中所有的子项
			                if ($.checkin($(val).val().split(',')))
			                	$(val).trigger("click");
			            });
	    				$("#x_uname").val(js.uname);
	    				$("#name").val(js.name);
                        $("#mobile").val(js.mobile);
	    			},
	    			error:function(err){
		    			$.setLoadingFailed("获取数据失败");
	    			}
	    		});
            	
			$.submitform([
	        	{id:"x_uname", empty:"请输入管理员名称"},
	        	{id:"name", empty:"请输入管理员姓名"},
	        	{id:"mobile", empty:"请输入手机号"},
	        	<%="id".getRequest().IsNullOrEmpty()?@"{id:""x_pass"",empty:""请输入密码""}":""%>
	        ], function(ret){
				$("#save").click(function(){
					if(!ret()) return;
	        		$.ajax_({
	        			btn: $("#save"),
	        			method:"<%="id".getRequest().IsNullOrEmpty()?"ManageUserAdd":"ManageUserEdit"%>",
	        			data:{
	        				id:"<%="id".getRequest()%>",
	        				uname:$("#x_uname").val().trim(),
	        				pass:$("#x_pass").val().trim(),
	        				name:$("#name").val().trim(),
	        				mobile:$("#mobile").val().trim(),
                            flag: $("#flag .item input[type=checkbox]:checked").map(function () { return $(this).val(); }).get().join(",")
	        			},
	        			form:"正在提交，请稍候...",
	        			success:function(data){
	        				if(data.d){
	        					$.setLoadingSuccess("操作成功，1秒后即将跳转");
	        					setTimeout(function(){
	        						if(<%="id".jsRequest()%>)
	        							location.href = "Manage_Users.aspx?state=1";
	        						else
	        							$("#head #back span").trigger("click");
	        					},1000);
	        				}
	        				else
	    						$.setLoadingFailed("操作失败");
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