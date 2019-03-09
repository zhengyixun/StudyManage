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
    public string img { get; set; }
    public string msg { get; set; }
    public string name { get; set; }
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
    public bool AddUser(string user_name,string user_phone) {
        return new STU.User()
        {
            user_name = user_name,
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
    public bool UpdateUser( string user_phone, int user_id, string user_name)
    {
        return new STU.User() {
            user_phone=user_phone,
            user_id = user_id,
            user_name = user_name,
        }.UpdateUserInfo();
    }
    #endregion
    #region 变更用户状态
    [WebMethod(EnableSession = true)]
    public bool UserSetState(string user_account_state, int user_id)
    {
        return new STU.User() {
            user_account_state = user_account_state,
            user_id = user_id
        }.SetUserState();
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
    #region 添加活动信息
    [WebMethod(EnableSession = true)]
    public bool AddActivity(string activity_creater_name, string activity_name, string activity_site_id, string activity_type, string activity_min_people, string activity_max_people, string activity_con, string activity_work_con, string activity_img_vedio_url, string activity_address, string activity_start_time, string activity_end_time, string activity_signup_end_time, string activity_state)
    {
        return new STU.Activity()
        {
            activity_creater_name= activity_creater_name,
            activity_name = activity_name,
            activity_site_id= activity_site_id,//场地id
            activity_type = activity_type,
            activity_min_people= activity_min_people,
            activity_max_people = activity_max_people,
            activity_con = activity_con,
            activity_work_con= activity_work_con,
            activity_img_vedio_url= activity_img_vedio_url,
            activity_address = activity_address,
            activity_start_time= activity_start_time,
            activity_end_time= activity_end_time,
            activity_signup_end_time= activity_signup_end_time,
            activity_state= activity_state
        }.AddActivityC();
    }
    #endregion
    #region 编辑活动信息
    [WebMethod(EnableSession = true)]
    public bool UpdateActivity(string activity_creater_name, string activity_name, string activity_site_id, string activity_type, string activity_min_people, string activity_max_people, string activity_con, string activity_work_con, string activity_img_vedio_url, string activity_address, string activity_start_time, string activity_end_time, string activity_signup_end_time, string activity_state, string activity_id)
    {
        return new STU.Activity()
        {
            activity_creater_name = activity_creater_name,
            activity_name = activity_name,
            activity_site_id = activity_site_id,//场地id
            activity_type = activity_type,
            activity_min_people= activity_min_people,
            activity_max_people= activity_max_people,
            activity_con= activity_con,
            activity_work_con= activity_work_con,
            activity_img_vedio_url= activity_img_vedio_url,
            activity_address= activity_address,
            activity_start_time= activity_start_time,
            activity_end_time= activity_end_time,
            activity_signup_end_time= activity_signup_end_time,
            activity_state= activity_state,
            activity_id= activity_id,

        }.UpdateActivityC();
    }
    #endregion
    #region 删除活动信息
    [WebMethod(EnableSession = true)]
    public bool DelActivity(string activity_id)
    {
        return new STU.Activity()
        {
            activity_id = activity_id
        }.DelActivityC();
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
    /// <param name="currentpage">页码</param>
    /// <param name="pagesize">每页数量</param>
    /// <param name="key">关键词搜索</param>
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
    #region 添加场地
    [WebMethod(EnableSession = true)]
    public bool AddSite(string site_name,string site_area,string site_img,string site_using_time_total,string site_desc)
    {
        return new STU.Site()
        {
            site_name= site_name,
            site_area= site_area,
            site_img= site_img,
            site_using_time_total= site_using_time_total,
            site_desc = site_desc
        }.AddSiteC();
    }
    #endregion
    #region 编辑场地
    [WebMethod(EnableSession = true)]
    public bool UpdateSite(string site_name, string site_area, string site_img, string site_using_time_total,string site_desc,string site_id)
    {
        return new STU.Site()
        {
            site_name = site_name,
            site_area = site_area,
            site_img = site_img,
            site_using_time_total = site_using_time_total,
            site_desc= site_desc,
            site_id =site_id
        }.UpdateSiteC();
    }
    #endregion
    #region 删除场地
    [WebMethod(EnableSession =true)]
    public bool DelSite(string site_id)
    {
        return new STU.Site()
        {
            site_id = site_id
        }.DelSiteC();
    }
    #endregion



    #region 获取版本信息
    [WebMethod(EnableSession = true)]
    public string GetVersionList(int currentpage, int pagesize, string key)
    {
        return STU.Version.GetVersionC(currentpage, pagesize, key);
    }
    #endregion


    #region 添加图片
    [WebMethod(EnableSession = true)]
    // 添加绘本视频
    public string AddImg(string _img)
    {
        string mp = STU.Config.folder.UpLoad.MapPath();
        this.img = Guid.NewGuid().ToString("N") + System.IO.Path.GetExtension(_img); System.Threading.Thread.Sleep(10);
        if (!STU.FolderConfig.MoveFile(_img, this.img, mp)) { return "封面上传失败"; };

        SqlPar par = SqlXml.GetSql("Uploads", "添加图片");
        par.SetParValues(this.name, this.msg, this.img);
        return DB.ExeSql(par) > 0 ? "" : "添加失败";
    }
    #endregion
    #region 修改图片
    [WebMethod(EnableSession = true)]
    public string UpdateImg(string _oldImg)
    {
        string mp = STU.Config.folder.UpLoad.MapPath();
        if (this.img != "" && this.img != _oldImg)
        {
            string new_img = Guid.NewGuid().ToString("N") + System.IO.Path.GetExtension(_oldImg); System.Threading.Thread.Sleep(10);
            if (!STU.FolderConfig.MoveFile(this.img, new_img, mp)) return "封面上传失败";
            if (!_oldImg.IsNullOrEmpty()) System.IO.File.Delete(mp + _oldImg);
            this.img = new_img;
        }
        else
        {
            this.img = _oldImg;
        }
        SqlPar par = SqlXml.GetSql("Uploads", "编辑图片");
        par.SetParValues(this.name, this.msg, this.img);
        return DB.ExeSql(par) > 0 ? "" : "编辑失败";
    }
    #endregion
}