<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Index.aspx.cs" Inherits="Index" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
    <script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
    <link rel="stylesheet" type="text/css" href="Css/Public.css" />
    <title>登录</title>
    <style type="text/css">
        #main { width: 413px; height: 300px; margin: 50px auto 0 auto; padding-top: 168px; background-image: url(background.png); }
            #main div { text-align: center; position: relative; width: 270px; margin: 10px auto; }
            #main span { font-family: iconfont; position: absolute; display: block; width: 50px; border-right: 1px solid #C7C7C7; line-height: 22px; font-size: 18px; font-weight: bold; color: #148CF1; margin-top: 6px; }
        #uname, #pass, #vcode { width: 210px; height: 28px; border: 1px solid #BEBEBE; border-radius: 5px; padding-left: 60px; }
        #vcodediv samp { font-size: 14px; }
        #vcodediv { text-align: left !important; }
            #vcode { width: 100px; padding-left: 5px; }
        #main p { background-color: #1782E5; padding: 0; margin: 30px auto 0 auto; text-align: center; color: #FFFFFF; font-size: 14px; width: 260px; height: 40px; line-height: 40px; border-radius: 5px; }
        
	    h6.right { margin-left: 10px; margin-top: 3px; }
	    h6.bottom { left: 60px; }
	    h6.bottom:after { margin-left: -50%; }
	    i { display: block; text-align: center; line-height: 20px; }
    </style>
</head>
<body>
    <div id="main">
        <div>
            <span>&#xe736;</span>
            <input type="text" id="uname" placeholder="登录名" />
            <h6 class="right" for="uname">请输入登录名</h6>
        </div>
        <div>
            <span>&#xe6c0;</span>
            <input type="password" id="pass" placeholder="密码" />
            <h6 class="right" for="pass">请输入密码</h6>
        </div>
        <div id="vcodediv">
            <samp>验证码</samp>
            <input type="text" id="vcode" value="1" />
            <h6 class="bottom" style="left: 48px;" for="vcode">请输入验证码</h6>
            <img src="http://studyServer.study.com/VerifyCode.ashx?L=4&amp;W=60&amp;H=22&amp;BG=FFFFFF&amp;S=14&amp;B=True&amp;X=3&amp;Y=1&amp;C=" align="absmiddle" alt="如果看不清楚,请点击重新获取" />
        </div>
        <p>登录</p>
        <i></i>
        <a href="Main.aspx" id="to"><span></span></a>
    </div>
    <script type="text/javascript">
    	window.document.onkeydown = function (event) {
            e = event ? event : (window.event ? window.event : null);
            if (e.keyCode == 13)
                $("#main p").trigger("click");
        }
    	$(document).keyup(function(event){
    		if(event.keyCode == 13)
		    	$("#main p").trigger("click");
		});
        $.submitform([
        	{id:"uname", empty:"请输入登录名"},
        	{id:"pass", empty:"请输入密码"},
        	{id:"vcode", empty:"请输入验证码"}
        ], function(ret){
			$("#main p").click(function(){
				if(!ret()) return;
        		$.ajax_({
        			method:"Login",
        			data:{
        				uname:$("#uname").val().trim(),
        				pass:$("#pass").val().trim(),
        				vcode:$("#vcode").val().trim()
        			},
        			before: function(hr){
        				$("i").html("正在登录，请稍候...");
        			},
        			success:function(data){
        				if(data.d == "")
        					$("i").html("登录成功，正在跳转，请稍候...").delay(1000).queue(function(){
        						$("#to span").trigger("click");
        					});
        				else
        					alert(data.d);
        			},
        			error:function(err){
        				$("i").html("登录失败");
        				//alert(err.responseText);
        			}
        		});
        		return false;
        	});
        });
	</script>
</body>
</html>
