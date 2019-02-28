using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Runtime.Serialization.Formatters.Binary;
using System.Web;
using ZhClass;

namespace STU
{
    /// <summary>
    /// Config 的摘要说明
    /// </summary>
    public class Config
    {
        public static STU.FolderConfig folder = ConfigurationManager.GetSection("folder") as STU.FolderConfig;
        public static string fileHost = ConfigurationManager.AppSettings["fileHost"];
        public static string AppID = "";

        #region 后台用户信息
        public static ManageUser ManageUser
        {
            get
            {
                try
                {
                    if (System.Web.HttpContext.Current.Request.Cookies[ManageUser.cookieName] != null)
                    {
                        string str = System.Web.HttpContext.Current.Request.Cookies[ManageUser.cookieName].Value;
                        if (!str.IsNullOrEmpty())
                        {
                            byte[] bytes = Convert.FromBase64String(str);
                            using (MemoryStream stream = new MemoryStream(bytes.UnZip()))
                            {
                                return (ManageUser)new BinaryFormatter().Deserialize(stream);
                            }
                        }
                    }
                    return null;
                }
                catch { return null; }
            }
        }
        #endregion

        //后台管理员菜单配置
        #region 管理者菜单
        /// <summary>
        /// 管理者菜单
        /// </summary>
        public static List<ManageUserMenu> ManageMenu
        {
            get
            {
                string currentdate = DateTime.Now.ToString("yyyy-MM-dd");
                List<ManageUserMenu> m = new List<ManageUserMenu>();
                m.Add(new ManageUserMenu() { f_name = "管理人员", name = "管理员管理", href = "Manage_Users.aspx", flag = "Manage_Users,Manage_Users_Design" });
               
                m.Add(new ManageUserMenu() { f_name = "用户管理", name = "用户管理", href = "User.aspx", flag = "User,User_Design" });
                m.Add(new ManageUserMenu() { f_name = "活动管理", name = "活动管理", href = "Activity.aspx", flag = "Activity,Activity_Design,Activity_SignUp" });
                m.Add(new ManageUserMenu() { f_name = "活动管理", name = "报名管理", href = "Activity_SignUp.aspx", flag = "Activity,Activity_Design,Activity_SignUp" });

                m.Add(new ManageUserMenu() { f_name = "场地管理", name = "场地管理", href = "Site.aspx", flag = "Site,Site_Design" });

                m.Add(new ManageUserMenu() { f_name = "积分管理", name = "积分管理", href = "Intergral.aspx", flag = "Intergral" });

                m.Add(new ManageUserMenu() { f_name = "验证码管理", name = "验证码管理", href = "Er_Code.aspx", flag = "Er_Code" });

                m.Add(new ManageUserMenu() { f_name = "版本管理", name = "版本管理", href = "Version.aspx", flag = "Version" });
                return m;
            }
        }
        #endregion

        #region 管理员菜单类
        public class ManageUserMenu
        {
            public string f_name { get; set; }
            public string name { get; set; }
            public string href { get; set; }
            public string flag { get; set; }
            public int value { get; set; }

        }
        #endregion

        public static void setCookie(string cookieName, string cookieValue)
        {
            HttpCookie cookie = System.Web.HttpContext.Current.Request.Cookies[cookieName];
            if (cookie == null)
                cookie = new HttpCookie(cookieName);
            //else
            //    cookie.Expires = DateTime.Now.Add(new TimeSpan(-1, 0, 0, 0));//删除整个Cookie，只要把过期时间设置为
            cookie.Domain = string.Join(".", System.Web.HttpContext.Current.Request.Url.DnsSafeHost.Split('.').Reverse().Take(2).Reverse());
            cookie.Value = cookieValue;
            System.Web.HttpContext.Current.Response.SetCookie(cookie);
        }
        public static Tuple<string, string> access_token()
        {
            SqlPar par = SqlXml.GetSql("Index", "获取微信JSAPI");
            var ary = DB.GetRow(par);
            if (ary.IsValue)
            {
                return Tuple.Create(ary[0].toString(), ary[1].toString());
            }
            return Tuple.Create("", "");
        }
    }
}