<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Activity_Design.aspx.cs" Inherits="Activity" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <script src="Js/jquery-1.11.1.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="Js/Extensions.js" type="text/javascript" charset="utf-8"></script>
	<link rel="stylesheet" type="text/css" href="Css/Public.css" />
    <%-- 引入时间选择器的控件 --%>
    <link rel="stylesheet" href="Css/borain-timeChoice.css"/>
    <link rel="stylesheet" type="text/css" href="http://www.jq22.com/jquery/font-awesome.4.6.0.css"/>
    <script src="Js/borain-timeChoice.js"></script>

    <title>审核活动</title>
</head>
<body>
   <div id="head">
		首页 > 活动管理  > 活动管理 > <%="activity_id".getRequest().IsNullOrEmpty()?"添加":"修改 / 审核"%>活动
		<a class="rbtn" href="javascript:location.reload();">&#xe6a4;</a>
		<a class="rbtn" href="<%=this.Context.Url()%>" id="back"><span>&#xe679;</span></a>
	</div>
    <div id="form">
        <table cellpadding="1" cellspacing="1">
            <tr>
				<td class="left" width="200">申请人</td>
				<td><input type="text" id="activity_creater_name" /><h6 class="right" for="activity_creater_name">*</h6></td>
			</tr>
            <tr>
				<td class="left" width="200">活动名称</td>
				<td><input type="text" id="activity_name" /><h6 class="right" for="activity_name">*</h6></td>
			</tr>
            <tr>
				<td class="left" width="200">活动场馆</td>
				<td>
                    <select id="activity_address" >
                        <option value="">请选择场地</option>
                    </select>
				</td>
			</tr>
            <tr>
				<td class="left" width="200">场馆地址</td>
				<td>
                    <select name="province" id="province">
		                <option value="请选择">请选择</option>
	                </select>
	                <select name="city" id="city">
		                <option value="请选择">请选择</option>
	                </select>
	                <select name="town" id="town">
		                <option value="请选择">请选择</option>
	                </select>

				</td>
			</tr>
            <tr>
				<td class="left" width="200">场馆地址详细</td>
				<td>
                    <textarea rows="5" cols="40" id="activity_address_info"></textarea>
				</td>
			</tr>
            <tr>
				<td class="left" width="200">活动开始时间</td>
				<td><input type="text" id="activity_start_time" /><h6 class="right" for="activity_start_time">*</h6></td>
			</tr>
            <tr>
				<td class="left" width="200">活动结束时间</td>
				<td><input type="text" id="activity_end_time" /><h6 class="right" for="activity_end_time">*</h6></td>
			</tr>
            <tr>
				<td class="left" width="200">报名结束时间</td>
				<td><input type="text" id="activity_signup_end_time" /><h6 class="right" for="activity_signup_end_time">*</h6></td>
			</tr>
            <tr>
				<td class="left" width="200">活动类型</td>
				<td><input type="text" id="activity_type" /><h6 class="right" for="activity_type">*</h6></td>
			</tr>
            <tr>
				<td class="left" width="200">最少人数</td>
				<td><input type="text" id="activity_min_people" /><h6 class="right" for="activity_min_people">*</h6></td>
			</tr>
            <tr>
				<td class="left" width="200">最大人数</td>
				<td><input type="text" id="activity_max_people" /><h6 class="right" for="activity_max_people">*</h6></td>
			</tr>
            <tr>
				<td class="left" width="200">活动内容</td>
				<td>
                    <textarea rows="5" cols="40" id="activity_content"></textarea>
				</td>
			</tr>
            <tr>
				<td class="left" width="200">活动准备工作</td>
				<td>
                    <textarea rows="5" cols="40" id="activity_work_con"></textarea>
				</td>
			</tr>
            <tr>
				<td class="left" width="200">活动记录</td>
				<td>
                    <textarea rows="5" cols="40" id="activity_img_video_url"></textarea>
				</td>
			</tr>
            
            <tr>
				<td class="left" width="200">活动状态</td>
				<td>
                    <select id="activity_state">
                        <option value="0">待审核</option>
                        <option value="1">已通过</option>
                        <option value="2">未通过</option>
                        <option value="3">已作废</option>
                        <option value="4">举办成功</option>
                        <option value="5">举办失败</option>
                        <option value="6">错误</option>
                    </select>
				</td>
			</tr>
            <tr>
				<td class="left"></td>
				<td><span id="save" class="btn b">提交</span></td>
			</tr>
        </table>
    </div>
    <%-- 三级联动的js --%>
    <script src="Js/address.js"></script>
    <script src="Js/select.js"></script>
    <script>
        $(function () {
            //获取场地列表
            $.ajax_({
                method: "GetSiteList",
                data: { currentpage: 1, pagesize: 50, key: "" },
                success: function (e) {
                    $("#activity_address").empty();
                    let datas = JSON.parse(e.d);
                    datas.list.forEach(function (item, index) {
                        $("<option>").prop("value", item.site_id).text($.Base64Decode(item.site_name)).appendTo($("#activity_address"))
                    });
                    if (!<%="activity_id".getRequest().IsNullOrEmpty()?"true":"false"%>) { //代表是编辑
                        var data = JSON.parse($.Base64Decode($.getRequest("item")));
                        $("#activity_creater_name").val(data.activity_creater_name);//申请人
                        $("#activity_name").val($.Base64Decode(data.activity_name));//活动名称
                        $("#activity_address").val(data.activity_site_id);//活动场地
                        $("#activity_start_time").val(data.activity_start_time); //活动开始时间
                        $("#activity_end_time").val(data.activity_end_time);//活动结束时间
                        $("#activity_signup_end_time").val(data.activity_signup_end_time);//报名截止时间
                        $("#activity_type").val(data.activity_type); //活动类型
                        $("#activity_min_people").val(data.activity_min_people);//最少人数
                        $("#activity_max_people").val(data.activity_max_people);//最大人数
                        $("#activity_content").val($.Base64Decode(data.activity_con)); //活动内容
                        $("#activity_work_con").val($.Base64Decode(data.activity_work_con)); //活动准备内容
                        $("#activity_img_video_url").val(data.activity_img_vedio_url);//活动记录
                        console.log(data)
                        if (data.activity_state == "待审核") {
                            data.activity_state = 0
                        } else if (data.activity_state == "已通过") {
                            data.activity_state = 1
                        } else if (data.activity_state == "未通过") {
                            data.activity_state = 2
                        } else if (data.activity_state == "已作废") {
                            data.activity_state = 3
                        } else if (data.activity_state == "举办成功") {
                            data.activity_state = 4
                        } else if (data.activity_state == "举办失败") {
                            data.activity_state = 5
                        } 
                        $("#activity_state").val(data.activity_state); //活动状态
                        //场地的地址  上海-县-崇明县
                        var areas = (data.activity_address).split("-");
                        $("#province").val(areas[0])
                        $("#city").html("<option value='"+areas[1]+"'>"+areas[1]+"</option>").val(areas[1]);
                        $("#town").html("<option value='" + areas[2] + "'>" + areas[2] + "</option>").val(areas[2]);
                        //地址i详情
                        $("#activity_address_info").val(areas[3])
                    }
                }
            })
            
            //实例化时间选择插件
            //  level分为 YM YMD H HM 四个有效值，分别表示年月 年月日 年月日时 年月日时分,less表示是否不可小于当前时间。年-月-日 时:分 时为24小时制
            //  为确保控件结构只出现一次，在有需要的时候进行一次调用。
                onLoadTimeChoiceDemo();
                borainTimeChoice({
                    start:"#activity_start_time",
                    end:"",
                    level:"HM",
                    less:false
                });
                borainTimeChoice({
                    start:"#activity_signup_end_time",
                    end:"",
                    level:"HM",
                    less:false
                });
                borainTimeChoice({
                    start:"#activity_end_time",
                    end:"",
                    level:"HM",
                    less:false
                });
            $("#save").click(function () {
                 <%="activity_id".getRequest().IsNullOrEmpty()?"add":"upd"%>(); //判断 执行哪个方法
            });
            function checks(name, text) {
                 $(name).siblings(".right").css("display", "none")
                if ($(name).val() == "") {
                    $(name).siblings(".right").css("display", "block").text(text);
                    return true;
                }
            }
            function add() {
                if (checks("#activity_creater_name", "请输入申请人姓名")||checks("#activity_name","请输入活动名称")||checks("#activity_start_time","请选择开始时间")||checks("#activity_end_time","请选择结束时间")||checks("#activity_signup_end_time","请选择报名结束时间")) {
                    return;
                }
                //console.log($("#city").val());
                //console.log($("#province").val());
                //console.log($("#town").val());
                $.ajax_({
                    method: "AddActivity",
                    data: {
                        activity_creater_name :$("#activity_creater_name").val(),
                        activity_name: $("#activity_name").val(),
                        activity_site_id: $("#activity_address").val(),//场地id
                        activity_type :$("#activity_type").val(),
                        activity_min_people :$("#activity_min_people").val(),
                        activity_max_people :$("#activity_max_people").val(),
                        activity_con :$("#activity_content").val(),
                        activity_work_con :$("#activity_work_con").val(),
                        activity_img_vedio_url :$("#activity_img_video_url").val(),
                        activity_address :$("#province").val() + "-"+ $("#city").val()+"-" + $("#town").val()+ "-"+$("#activity_address_info").val(),//省市区-详细
                        activity_start_time :$("#activity_start_time").val(),
                        activity_end_time :$("#activity_end_time").val(),
                        activity_signup_end_time :$("#activity_signup_end_time").val(),
                        activity_state :$("#activity_state").val()==""?"0":$("#activity_state").val(),
                    },
                    success: function (e) {
                        console.log(e.d)
                        if (e.d == true) {
                            alert("添加成功");
                            location.href = "Activity.aspx";
                        }
                    },
                    error: function (e) {
                        console.log("错误信息：" + JSON.stringify(e))
                    }
                })
            }
            function upd() {
                $.ajax_({
                    method: "UpdateActivity",
                    data: {
                        activity_creater_name :$("#activity_creater_name").val(),
                        activity_name: $("#activity_name").val(),
                        activity_site_id: $("#activity_address").val(),//场地id
                        activity_type :$("#activity_type").val(),
                        activity_min_people :$("#activity_min_people").val(),
                        activity_max_people :$("#activity_max_people").val(),
                        activity_con :$("#activity_content").val(),
                        activity_work_con :$("#activity_work_con").val(),
                        activity_img_vedio_url :$("#activity_img_video_url").val(),
                        activity_address :$("#province").val() + "-"+ $("#city").val()+"-" + $("#town").val()+ "-"+$("#activity_address_info").val(),//省市区
                        activity_start_time :$("#activity_start_time").val(),
                        activity_end_time :$("#activity_end_time").val(),
                        activity_signup_end_time :$("#activity_signup_end_time").val(),
                        activity_state :$("#activity_state").val(),
                        activity_id:$.getRequest("activity_id"),
                    },
                    success: function (e) {
                        console.log(e.d)
                        if (e.d == true) {
                            alert("修改成功");
                            location.href = "Activity.aspx";
                        }
                    },
                    error: function (e) {
                        console.log("错误信息：" + JSON.stringify(e))
                    }
                })

            }
        })
    </script>
</body>
</html>
