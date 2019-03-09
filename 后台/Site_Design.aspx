<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Site_Design.aspx.cs" Inherits="User_Design" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
    <script src="Js/UpFile.js"></script>
	<link rel="stylesheet" type="text/css" href="Css/Public.css" />
    <link href="Css/UpFile.css" rel="stylesheet" />
    <title>场地</title>
    <style type="text/css">
	    
	    select { min-width: auto;margin-right: 5px; }
	    #flag div { border: 1px solid #999; float: left; padding: 5px; margin: 10px 10px 10px 0px; position: relative; clear: both; min-width: 150px; }
	        #flag div strong { display: block; position: absolute; top: -8px; left: 10px; }
	    #flag label { float: left; margin: 8px 5px 0px 5px; white-space: nowrap; }
	    #flag label.head { margin: 0px; background-color: #FFF; padding: 0px 5px; }
	    #areaTd i { color: red; }
        td{position:relative}
        h6.right { left: 210px; margin-top: 6px;}
        #up > span{display:block;width:200px;height:60px;line-height:60px;border:1px dashed #ccc;box-sizing:border-box;text-align:center}
        #up{
            position:relative;
        }
        #up > img{
            width:50px;height:50px;
            position:absolute;right:230px;top:1px;
        }
	</style>
</head>
<body>
    <div id="head">
		首页 > 场地管理  > 场地管理 > <%="site_id".getRequest().IsNullOrEmpty()?"添加":"修改"%>场地
		<a class="rbtn" href="javascript:location.reload();">&#xe6a4;</a>
		<a class="rbtn" href="<%=this.Context.Url()%>" id="back"><span>&#xe679;</span></a>
	</div>
    <div id="form">
        <table cellpadding="1" cellspacing="1">
            <tr>
				<td class="left" width="200">场地名称</td>
				<td><input type="text" id="site_name" /><h6 class="right" for="site_name">*</h6></td>
			</tr>
            <tr>
				<td class="left" width="200">场地面积</td>
				<td><input type="text" id="site_area" /><h6 class="right" for="site_area">*</h6></td>
			</tr>
            <tr style="display:none">
				<td class="left" width="200">可用时间段</td>
				<td><input type="text" id="site_using_time_total" /><h6 class="right" for="site_using_time_total">*</h6></td>
			</tr>
            <tr>
				<td class="left" width="200">备注</td>
				<td><textarea rows='5' cols="50" id="site_desc"></textarea></td>
			</tr>
            <tr>
				<td class="left top">上传图片</td>
				<td id="up" class="top">
                    <h6 class="right" for="up" style="z-index:999;left:310px"></h6>
                    <img src="#"/>
				</td>
			</tr>
            <tr>
				<td class="left"></td>
				<td><span id="save" class="btn b">提交</span></td>
			</tr>
        </table>
    </div>
    <%-- 上传的js --%>
    <script>
        $(function () {
            //上传的js
            var up = $.upfile({ el: $("#up"), accept: "image/jpeg,image/jpg,image/png", btn: $("#save"), mw: 270, mh: 190 });
            var imgFileName;
            $("input").focus(function () { $(this).siblings(".right").css("display","none")});
            $("#save").click(function () {
                console.log("++++" + JSON.stringify(up));
                imgFileName = up.value;//图片的文件名
                
                if ($("#site_name").val() == "") {
                    $("#site_name").siblings(".right").css("display", "block").text("请输入场地名称");
                    return
                }
                if ($("#site_area").val() == "") {
                    $("#site_area").siblings(".right").css("display", "block").text("请输入场地面积");
                    return
                }
               
                <%="site_id".getRequest().IsNullOrEmpty()?"add":"upd"%>(); //判断 执行哪个方法
            });
            function upd() {  //编辑的方法
                $.ajax_({
                    method: "UpdateSite",
                    data: {
                        site_name: $("#site_name").val(),
                        site_area: $("#site_area").val(),
                        site_img: imgFileName==""?$.getRequest("site_img"):imgFileName, //如果imgFileName为空，代表不修改，不为空代表已修改
                        site_using_time_total: $("#site_using_time_total").val(),
                        site_desc:$("#site_desc").val(),///备注
                        site_id:$.getRequest("site_id")
                    },
                    success: function (e) {
                        if (e.d == true) {
                            alert("修改成功");
                            location.href = "Site.aspx";
                            imgFileName = "";
                        }
                    },
                    error: function (e) {
                        console.log("错误信息：" +e)
                    }
                })
            }
            function add() {  //添加的方法
                if (imgFileName == "") { //添加的时候  图片必须上传
                    $("#up").children(".right").css("display", "block").text("请上传图片");
                    return
                }
                $.ajax_({
                    method: "AddSite",
                    data: {
                        site_name: $("#site_name").val(),
                        site_area: $("#site_area").val(),
                        site_img: imgFileName,
                        site_using_time_total: $("#site_using_time_total").val(),
                        site_desc:$("#site_desc").val()
                    },
                    success: function (e) {
                        console.log(e.d)
                        if (e.d == true) {
                            alert("添加成功");
                            imgFileName = "";
                            location.href = "Site.aspx";
                        }
                    },
                    error: function (e) {
                        console.log("错误信息" + e)
                    }
                })
            }

            $("#site_name").val($.Base64Decode($.getRequest("site_name") ));
            $("#site_area").val($.Base64Decode($.getRequest("site_area")));
            
            $("#site_using_time_total").val($.getRequest("site_using_time_total"));
            $("#site_desc").val($.Base64Decode($.getRequest("site_desc")));//备注
            if ($.getRequest("site_img") === "") {
                $("#up img").css("display","none")
            } else {
                $("#up img").css("display","block")
                $("#up img").prop({ src:"/UpLoad/"+ $.getRequest("site_img") });
            }
            
        })
    </script>
</body>
</html>
