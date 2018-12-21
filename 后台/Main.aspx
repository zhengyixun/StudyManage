<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Main.aspx.cs" Inherits="Main" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
    <title>测绘局绘画大赛管理后台</title>
    <style type="text/css">
        @font-face { font-family: 'iconfont'; src: url('css/iconfont.ttf') format('truetype'); }
        .iconfont { font-family: "iconfont" !important; font-size: 16px; font-style: normal; -webkit-font-smoothing: antialiased; -webkit-text-stroke-width: 0.2px; -moz-osx-font-smoothing: grayscale; }
        html, body { padding: 0; margin: 0; font-size: 12px; width: 100%; height: 100%; font-family: "微软雅黑"; background-color: #E6E6E6; }
        #head { width: 100%; height: 70px; background-color: #609FE9; display: flex; justify-content: flex-end; align-items: center; }
            #head * { display: block; padding: 10px 15px; margin: 5px 8px; float: left; color: #FFF; font-size: 16px; text-decoration: none; }
            #head p { position: absolute; left: 0; font-size: 24px; top: 0; }
            #head a:hover { background-color: rgba(255,255,255,0.3); }
        #left { position: absolute; top: 70px; bottom: 0; width: 200px; border-right: 1px solid #BEBEBE; background-color: #EEE; padding-top: 10px; }
            #left div { height: 0; overflow: hidden; }
            #left span { color: #0B61C1; font-size: 16px; display: block; border-bottom: 1px solid #BEBEBE; height: 40px; line-height: 40px; padding-left: 50px; cursor: pointer; }
                #left span:after { font-family: iconfont; content: '\e661'; display: block; float: right; margin-right: 10px; color: #BEBEBE; }
                #left span.selected:after { -webkit-animation: up 300ms linear 0s 1 normal forwards; /*线性渐变，延时0秒，只动一次，不逆向播放，停在最后一帧*/ }
                #left span.unselected:after { -webkit-animation: down 300ms linear 0s 1 normal forwards; /*线性渐变，延时0秒，只动一次，不逆向播放，停在最后一帧*/ }

        @-webkit-keyframes up {
            0% { -webkit-transform: rotate(0deg); }
            100% { -webkit-transform: rotate(180deg); }
        }

        @-webkit-keyframes down {
            0% { -webkit-transform: rotate(180deg); }
            100% { -webkit-transform: rotate(0deg); }
        }

        #left a { display: block; font-size: 14px; color: #666; height: 30px; line-height: 30px; padding-left: 30px; text-decoration: none; }
            #left a:hover { background-color: rgba(255,255,255,0.5); color: #148CF1; }
        #go { display: block; position: absolute;right: 5px; top: 75px; list-style: none; padding: 0; margin: 0; font-family: iconfont; color: #353535; font-size: 14px;}
        #go li { -webkit-transition:all 1s; cursor: pointer; display: block;float: left; list-style: none;text-align: center; width: 35px; height: 30px;line-height: 30px; }
        #go li#goright { border-top-left-radius: 5px; border-bottom-left-radius: 5px; }
        #go li#goleft { border-top-right-radius: 5px; border-bottom-right-radius: 5px;}
        #go li:hover { background-color: #C7C7C7;}
        #innerhead { position: absolute; top: 70px; left: 200px; height: 50px; right: 100px; display: flex; align-items: flex-end; overflow: hidden; }
            #innerhead div { display: block; float: left; cursor: pointer; height: 40px; line-height: 45px; padding: 0 30px 0 10px; font-size: 14px; color: #666; border-top: 1px solid #BEBEBE; border-right: 1px solid #BEBEBE; }
                #innerhead div.selected { background-color: #FFF; color: #000; border-top: 2px solid #0B61C1; }
                #innerhead div:hover { background-color: #F3F3F3; }
                #innerhead div * { display: block; float: left; }
                #innerhead div span { white-space: nowrap; }
            #innerhead i { font-style: normal; }
                #innerhead i:after { font-family: iconfont; content: '\e646'; font-size: 14px; position: absolute; margin-left: 9px; margin-top: 1px; }
                #innerhead i:hover:after { content: '\e658'; color: #F17570; font-size: 22px; margin-left: 5px; }
        #fm { position: absolute; top: 120px; left: 201px; right: 0; bottom: 0; overflow: hidden; }
            #fm iframe { position: absolute; border: 0px; overflow: hidden; width: 100%; height: 100%; z-index: 0; background-color: #FFFFFF; }
                #fm iframe.selected { z-index: 1 !important; }
        @keyframes rotate {
		    0% { -webkit-transform: rotate(0deg); }
		    100% { -webkit-transform: rotate(360deg); }
		}
        #fm > span { display: inline-block; font-size: 14px; position: absolute; top: 50px; left: 50px; }
    		#fm > span:before { display: inline-block; font-family: iconfont; font-size: 26px; vertical-align: sub; margin:0 5px; content: "\e64f"; -webkit-animation: rotate 3000ms linear 0s infinite normal; }
    </style>
</head>
<body>
    <div id="head">
    	<p>---------管理后台</p>
        <span>欢迎： <% =STU.Config.ManageUser.name%></span><a id="refresh" href="javascript:;">刷新</a> <a href="/Exit.ashx">退出</a>
    </div>
    <div id="left">
        <span>管理中心</span>
        <div>
            <a href="index.aspx">首页</a>
            <a href="EditPass.aspx">修改密码</a>
        </div>
        <% =str %>
    </div>
    <div id="innerhead">
        <div class="selected" style="padding-right: 10px;" data-href="welcome_aspx"><span>首页</span></div>
    </div>
    <ul id="go">
    	<li id="goright">&#xe679;</li>
    	<li id="goleft">&#xe6a3;</li>
    </ul>
    <div id="fm">
    	<span class="loading">请稍候......</span>
        <iframe id="welcome_aspx" src="welcome.aspx" class="selected"></iframe>
    </div>

    <script type="text/javascript">
        //折叠
        $("#left span").click(function () {
            if ($(this).hasClass("selected")) {
                $(this).removeClass("selected").addClass("unselected").next().animate({ "height": 0 }, 200);
            }
            else {
                $("#left span.selected").removeClass("selected").addClass("unselected").next().animate({ "height": 0 }, 200);
                $(this).removeClass("unselected").addClass("selected").next().animate({ "height": $(this).next().get(0).scrollHeight }, 200);
            }
        })
        //左边菜单点击
        $("#left a").click(function () {
            var name = $(this).html(), href = $(this).attr("href");
            var dhref = href.replace(/\.|\?|\=|\&/g,'_');
            var el = $("#innerhead span:contains('" + name + "')");
            var ifa = $("#" + dhref);
            if (el.length <= 0) {
                el = $("<div>").attr("data-href", dhref).append('<span>' + name + '</span><i></i>').appendTo($("#innerhead")); //.click();
                ifa = $("<iframe>").attr({ "id": dhref, "src": href }).addClass("selected");
                ifa.load(function(){
                	$("#fm > span").css("z-index", 0);
//              }).unload(function(){
//              	$("#fm > span").css("z-index", 100);
//              	console.log("换页面发")
                }).appendTo($("#fm"));
                $("#fm > span").css("z-index", 100);
            } 
            el.trigger("click");
            ifa.attr("src", href);
            return false;
        });
        $("#refresh").click(function(){
        	$("iframe.selected")[0].contentWindow.location.reload();
        });
        //顶部标签页切换
        $("#innerhead").delegate("div", "click", function (e) {
            if (e.target.tagName == "I") {
                var p = $(this).hasClass("selected");
                $(this).remove();
                $("#fm iframe#" + $(this).attr("data-href")).remove();
                if (p) $("#innerhead div:last").trigger("click"); //最后一项激活
            } else {
                $("#innerhead div").removeClass("selected");
                $(this).addClass("selected");
                $("#fm iframe").removeClass("selected");
                $("#fm iframe#" + $(this).attr("data-href")).addClass("selected");
            }
        })
        //标签的左右移动
        $("#go li").click(function(){
        	var nleft =$("#innerhead").scrollLeft();
        	switch($(this).attr("id")){
        		case "goleft":
        			var left = $("#innerhead").get(0).scrollWidth - $("#innerhead").width() - nleft;
        			if(left > 0){
        				if(left > 50)
        					$("#innerhead").scrollLeft(nleft + 50);
        				else
        					$("#innerhead").scrollLeft(nleft + left);
        			}
        			break;
        		case "goright":
        			if(nleft > 0){
        				nleft -= 50;
        				if(nleft < 0) nleft = 0;
        				$("#innerhead").scrollLeft(nleft);
        			}
        			break;
        	}
        });
	</script>
</body>
</html>
