using System;
using System.Web;
using System.Web.Services;
using System.Web.SessionState;
using ZhClass;
using STU;

//[Aop]
[System.Web.Script.Services.ScriptService]
[WebService]
public class Manage : ZHAop, IHttpHandler, IRequiresSessionState
{

    public void ProcessRequest(HttpContext context) { }
    public bool IsReusable { get { return false; } }

    #region 登录
    [WebMethod(EnableSession = true)]
    public string Login(string uname, string pass, string vcode)
    {
        return new STU.ManageUser() { uname = uname, pass = pass }.Login(vcode);
    }
    #endregion
    #region 修改密码
    [WebMethod(EnableSession = true)]
    public bool EditPass(string oldpass, string newpass)
    {
        return new STU.ManageUser() { uname = STU.Config.ManageUser.uname, pass = oldpass }.EditPass(newpass);
    }
    #endregion
    #region 添加管理员
    [WebMethod(EnableSession = true)]
    public bool ManageUserAdd(string id, string uname, string pass, string name, string mobile, string flag)
    {
        return new STU.ManageUser()
        {
            uname = uname,
            pass = pass,
            name = name,
            mobile = mobile,
            flag = flag
        }.Add();
    }
    #endregion
    #region 修改管理员
    [WebMethod(EnableSession = true)]
    public bool ManageUserEdit(string id, string uname, string pass, string name, string mobile, string flag)
    {
        return new STU.ManageUser()
        {
            id = id.toString(0),
            uname = uname,
            pass = pass,
            name = name,
            mobile = mobile,
            flag = flag
        }.Update();
    }
    #endregion
    #region 列表管理员
    [WebMethod(EnableSession = true)]
    public string ManageUserList(int currentpage, int pagesize, string key)
    {
        return STU.ManageUser.List(currentpage, pagesize, key);
    }
    #endregion
    #region 获取管理员
    [WebMethod(EnableSession = true)]
    public string ManageUserGet(string id)
    {
        var p = new STU.ManageUser() { id = id.toString(0) };
        if (p.Get())
            return p.toJson<STU.ManageUser>(move: new string[] { "pass" });
        return "";
    }
    #endregion
    #region 变更管理员状态
    [WebMethod(EnableSession = true)]
    public int ManageUserSetState(string id)
    {
        return new STU.ManageUser() { id = id.toString(0) }.SetState(STU.Config.ManageUser.id);
    }
    #endregion

    #region  查询用户列表
    [WebMethod(EnableSession = true)]
    public string GetUserLists(int currentpage, int pagesize, string key)
    {
        return STU.User.GetUserList(currentpage, pagesize, key);
    }
    #endregion
    #region  添加用户
    [WebMethod(EnableSession = true)]
    public bool AddUser(string user_name,string user_wx_num,string user_phone) {
        return new STU.User()
        {
            user_name = user_name,
            user_wx_num = user_wx_num,
            user_phone = user_phone

        }.AddWxUser();
    }
    #endregion
    #region 删除单个用户
    [WebMethod(EnableSession = true)]
    public bool DelUser(int user_id)
    {
        return new STU.User()
        {
            user_id = user_id
        }.DelUserC();
    }
    #endregion
    #region 编辑用户信息
    [WebMethod(EnableSession = true)]
    public bool UpdateUser( string user_name,string user_wx_num,string user_phone, int user_id)
    {
        return new STU.User() {
            user_name = user_name,
            user_wx_num=user_wx_num,
            user_phone=user_phone,
            user_id = user_id,
        }.UpdateUserInfo();
    }
    #endregion

    #region 查询二维码
    [WebMethod(EnableSession = true)]
    public string GetErCodeList(int currentpage, int pagesize, string key)
    {
        return STU.User.GetErCodeC(currentpage, pagesize, key);
    }
    #endregion

    #region 查询活动列表
    [WebMethod(EnableSession = true)]
    public string GetActivityList(int currentpage,int pagesize,string key)
    {
        return STU.Activity.GetActivityC(currentpage, pagesize, key);
    }
    #endregion


    #region 获取报名列表
    [WebMethod(EnableSession = true)]
    public string GetActivitySignUpList(int currentpage, int pagesize, string key)
    {
        return STU.Activity.GetActivitySignUpC(currentpage, pagesize, key);
    }
    #endregion

    #region 获取积分列表
    [WebMethod(EnableSession = true)]
    public string GetIntergral(int currentpage, int pagesize, string key)
    {
        return STU.Mall.GetIntergralC(currentpage, pagesize, key);
    }
    #endregion
   

    #region 获取场地列表
    [WebMethod(EnableSession=true)]
    public string GetSiteList(int currentpage, int pagesize, string key)
    {
        return STU.Site.GetSiteC(currentpage, pagesize, key);
    }
    #endregion
}