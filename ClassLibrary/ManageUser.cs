using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.Serialization.Formatters.Binary;
using System.Web;
using ZhClass;

namespace STU
{
    [Serializable]
    /// <summary>
    /// 所有后台用户
    /// </summary>
    public class ManageUser
    {
        public const string cookieName = "Manage";
        #region 字段
        /// <summary>
        /// 用户ID
        /// </summary>
        public int id { get; set; }
        /// <summary>
        /// 用户登录名
        /// </summary>
        public string uname { get; set; }
        /// <summary>
        /// 登录密码
        /// </summary>
        public string pass { get; set; }
        /// <summary>
        /// 用户姓名
        /// </summary>
        public string name { get; set; }
        /// <summary>
        /// 用户手机号
        /// </summary>
        public string mobile { get; set; }
        /// <summary>
        /// 状态
        /// </summary>
        public int state { get; set; }
        /// <summary>
        /// 管理员权限
        /// </summary>
        public string flag { get; set; }
        #endregion
        #region 构造
        //public ManageUser() { }
        //public ManageUser(bool iscookie)
        //{
        //    try
        //    {
        //        if (iscookie && System.Web.HttpContext.Current.Request.Cookies[cookieName] != null)
        //        {
        //            string str = System.Web.HttpContext.Current.Request.Cookies[cookieName].Value;
        //            if (!str.IsNullOrEmpty())
        //            {
        //                byte[] bytes = Convert.FromBase64String(str);
        //                using (MemoryStream stream = new MemoryStream(bytes))
        //                {
        //                    ManageUser p = (ManageUser)new BinaryFormatter().Deserialize(stream);
        //                    this.id = p.id;
        //                    this.uname = p.uname;
        //                    this.pass = p.pass;
        //                    this.name = p.name;
        //                    this.mobile = p.mobile;
        //                    this.company = p.company;
        //                    this.area = p.area;
        //                    this.state = p.state;
        //                    this.flag = p.flag;
        //                }
        //            }
        //        }
        //    }
        //    catch { }
        //}
        #endregion

        #region 转到后台出错页
        /// <summary>
        /// 转到后台出错页
        /// </summary>
        /// <param name="title">标题</param>
        /// <param name="msg">内容</param>
        /// <param name="target">跳转框架，不传则为本页跳转</param>
        /// <param name="url">地址，不传则为返回前页</param>
        /// <param name="time">返回时间，默认为2秒</param>
        public static void GoToError(string title, string msg, string target = null, string url = null, double time = 2)
        {
            System.Web.HttpContext.Current.Items["T"] = title;
            System.Web.HttpContext.Current.Items["M"] = msg;
            System.Web.HttpContext.Current.Items["G"] = target.IsNullOrEmpty() ? "self" : target;
            System.Web.HttpContext.Current.Items["S"] = time;
            System.Web.HttpContext.Current.Items["U"] = url.IsNullOrEmpty() ? "javascript:history.go(-1);" : url;
            System.Web.HttpContext.Current.Server.Transfer("/Error.aspx");
            return;
        }
        #endregion
        #region 检查用户是否登录
        public static void CheckLogin()
        {
            if (System.Web.HttpContext.Current.Request.Cookies[cookieName] == null)
                System.Web.HttpContext.Current.Response.Redirect("/");
        }
        #endregion
        #region 列表后台用户
        public static string List(int currentpage, int pagesize, string key)
        {
            SqlPar par = SqlXml.GetSearchSqlPage("ManageUser", "管理员列表", 0,
                !key.IsNullOrEmpty()
                );
            par.SetParValues(
                key.IsNullOrEmpty() ? null : key
                );
            return ZH.getPageArray(par, currentpage, pagesize).toJson();
        }
        #endregion

        //实例方法
        public string Login(string vcode)
        {
            //if (vcode.ToLower() != System.Web.HttpContext.Current.Session["VerifyCode"].toString().ToLower())
            //    CS.Config.GoToBackError("登录失败", "验证码输入不正确", false);
            var tmp = DB.GetArraysForSqlSaving("dbo.ManageLogin", "", this.uname, this.pass);
            if (tmp.Item1[0].toString(0) == 0)
                return tmp.Item1[1].toString();
            var obj = tmp.Item2[0][0];
            //id,name,mobile,flag
            this.id = obj[0].toString(0);
            this.uname = uname;
            this.name = obj[1].toString();
            this.mobile = obj[2].toString();
            this.flag = obj[3].toString();

            using (var memoryStream = new MemoryStream())
            {
                new BinaryFormatter().Serialize(memoryStream, this);
                STU.Config.setCookie(cookieName, Convert.ToBase64String(memoryStream.ToArray().Zip()));
            }
            return "";
        }

        public bool EditPass(string newpass)
        {
            SqlPar par = SqlXml.GetSql("ManageUser", "修改密码");
            par.SetParValues(newpass, this.uname, this.pass);
            return DB.ExeSql(par) > 0;
        }
        public bool Add()
        {
            SqlPar par = SqlXml.GetSql("ManageUser", "添加管理员");
            par.SetParValues(this.uname, this.pass, this.name, this.mobile, "Main,EditPass,welcome," + this.flag);
            //par.Debug();
            return DB.ExeSql(par) > 0;
        }
        public bool Update()
        {
            SqlPar par = SqlXml.GetSearchSql("ManageUser", "修改管理员", 0, !this.pass.IsNullOrEmpty(), true);
            par.SetParValues(this.uname, this.id,
                this.pass.IsNullOrEmpty() ? null : this.pass,
                this.name, this.mobile, "Main,EditPass,welcome," + this.flag);
            return DB.ExeSql(par) > 0;
        }
        public int SetState(int me)
        {
            SqlPar par = SqlXml.GetSql("ManageUser", "变更管理员状态");
            par.SetParValues(this.id, me);
            return DB.GetScalar(par).toString(-1);
        }
        public bool Get()
        {
            SqlPar par = SqlXml.GetSql("ManageUser", "获取管理员");
            par.SetParValues(this.id);
            var obj = DB.GetRow(par);
            if (!obj.IsValue)
                return false;

            this.uname = obj["uname"].toString();
            this.pass = obj["pwd"].toString();
            this.name = obj["name"].toString();
            this.mobile = obj["mobile"].toString();
            this.state = obj["state"].toString(0);
            this.flag = obj["flag"].toString();
            return true;
        }

    }
}