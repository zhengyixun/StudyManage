using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using ZhClass;

namespace STU
{
    /// <summary>
    /// wxAPI 的摘要说明
    /// </summary>
    public class wxAPI : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/javascript";
            context.Response.AddHeader("Cache-Control", "no-cache");

            string jsapi_ticket = STU.Config.access_token().Item2;
            int timestamp = (int)(DateTime.Now - TimeZone.CurrentTimeZone.ToLocalTime(new System.DateTime(1970, 1, 1))).TotalSeconds;
            //ZH.SaveErr(System.Web.HttpContext.Current.Request.Url.ToString());
            string signature = string.Format(@"jsapi_ticket={0}&noncestr={1}&timestamp={2}&url=http://wx.meitianjin.com/{3}", jsapi_ticket, "meitianjin", timestamp, "page".getRequest()).GetHashString(); //"http://wx.zh8848.com/Teacher.html"不写这个就有错，认的是当前地址
            //onVoiceRecordEnd,onVoicePlayEnd这两个在IOS中是支持的，但是检测会报false
            context.Response.Write(string.Format(@"wx.config({{
    debug: false,
    appId: '{0}',
    timestamp: {1},
    nonceStr: '{2}',
    signature: '{3}',
    jsApiList: ['previewImage','chooseImage','uploadImage','hideMenuItems','onMenuShareQZone','onMenuShareTimeline','onMenuShareAppMessage']
}});
wx.ready(function(){{
    wx.checkJsApi({{
        jsApiList: ['chooseImage','uploadImage'], // 需要检测的JS接口列表
        success: function (res){{
            if(typeof(res.checkResult)==""string"")
                res.checkResult=JSON.parse(res.checkResult);
            if (!res.checkResult.chooseImage || !res.checkResult.uploadImage)
                alert(""提示:"" + JSON.stringify(res));
        }}
    }});
    wx.error(function (res){{
        alert(""错误:"" + JSON.stringify(res));
    }});
    wx.onMenuShareTimeline({{
		title: ""{4}"", // 分享标题
		link: ""{5}"", // 分享链接
		success: function () {{
			alert(""分享成功""); //用户确认分享后执行的回调函数
		}}
	}});
    wx.onMenuShareQZone({{
		title: ""{4}"", // 分享标题
		link: ""{5}"", // 分享链接
		success: function () {{
			alert(""分享成功""); //用户确认分享后执行的回调函数
		}}
	}});
    wx.onMenuShareAppMessage({{
		title: ""{4}"", // 分享标题
		link: ""{5}"", // 分享链接
		success: function () {{
			alert(""分享成功""); //用户确认分享后执行的回调函数
		}}
	}});
    //wx.hideMenuItems({{
    //    menuList: [""menuItem:share:appMessage"", ""menuItem:share:timeline"", ""menuItem:share:qq"", ""menuItem:share:weiboApp"", ""menuItem:share:facebook"", ""menuItem:share:QZone"", ""menuItem:copyUrl"",""menuItem:openWithSafari"",""menuItem:share:email""]
    //}});
}});", Config.AppID, timestamp, "meitianjin", signature, "title".getRequest(), "url".getRequest()));
        }

        public bool IsReusable { get { return false; } }
    }
}