using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;

namespace STU
{
    /// <summary>
    /// ManageCheckFlag 的摘要说明
    /// </summary>
    public class ManageCheckFlag : IHttpModule
    {
        public ManageCheckFlag() { }
        public void Dispose() { }

        string[] CheckList = new string[]
                    {
                        "Index",
                        "EditPass",
                        "VerifyCode",
                        "Test",
                        "Test1",
                        "Error"
                    };
        public void Init(HttpApplication context)
        {
            context.AcquireRequestState += context_AcquireRequestState;
            context.Error += Context_Error;
        }
        private void Context_Error(object sender, EventArgs e)
        {
            ZhClass.ZH.SaveErr("Error:" + HttpContext.Current.Server.GetLastError().toString());
        }

        void context_AcquireRequestState(object sender, EventArgs e)
        {
            HttpApplication app = (HttpApplication)sender;
            Match m = Regex.Match(app.Request.Url.AbsolutePath, "/(.*?).aspx(.*)", RegexOptions.IgnoreCase);
            if (m != Match.Empty)
            {
                //if (!CS.ManageUser.UInfo.flag.ToLower().Split(',').Contains(m.Result("$1").ToLower()))
                //    CS.Config.GoToBackError("验证权限失败", "您没有此项权限", false);
                if (!CheckList.Contains(m.Result("$1")))
                {
                    STU.ManageUser.CheckLogin();
                    if (!STU.Config.ManageUser.flag.ToLower().Split(',').Contains(m.Result("$1").ToLower()))
                        STU.ManageUser.GoToError("验证权限失败", "您没有此项权限");
                }
            }
        }
    }
}