using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZhClass;

namespace STU
{
    public class User
    {
        #region 定义变量
        public int user_id { get; set; }  //用户id
        public string user_name { get; set; } //用户姓名
        public string user_wx_name { get; set; } //用户 微信昵称
        public string user_phone { get; set; } //用户 手机号
        public string user_wx_num { get; set; } //用户 微信号
        public string openid { get; set; } //用户 openid
        public string user_state { get; set; }  //用户状态
        public string user_create_time { get; set; } //用户 创建时间
        #endregion

        #region 查看用户列表
        public static string GetUserList(int currentpage, int pagesize, string key)
        {
            SqlPar par = SqlXml.GetSearchSqlPage("User", "用户列表", 0,
                !key.IsNullOrEmpty()
                );
            par.SetParValues(
                key.IsNullOrEmpty() ? null : key
                );
            return ZH.getPageArray(par, currentpage, pagesize).toJson();
        }
        #endregion
        #region 录入用户信息
        public bool AddWxUser()
        {
            SqlPar par = SqlXml.GetSql("User", "添加用户");
            par.SetParValues(this.user_phone, this.user_name, this.user_wx_num);
            return DB.ExeSql(par) > 0;
        }
        #endregion
        #region  编辑用户信息
        public bool UpdateUserInfo()
        {
            SqlPar par = SqlXml.GetSearchSql("User", "编辑用户信息");
            par.SetParValues(
                this.user_name,this.user_wx_num, this.user_phone, this.user_id
            );
            return DB.ExeSql(par) > 0;
        }
        #endregion
        #region 删除用户信息
        public bool DelUserC()
        {
            SqlPar par = SqlXml.GetSql("User", "删除用户");
            par.SetParValues(this.user_id);
            return DB.ExeSql(par) > 0;
        }
        #endregion

        #region 获取验证码
        public static string GetErCodeC(int currentpage, int pagesize, string key)
        {
            SqlPar par = SqlXml.GetSearchSqlPage("User", "二维码列表", 0,
                !key.IsNullOrEmpty()
                );
            par.SetParValues(
                key.IsNullOrEmpty() ? null : key
                );
            return ZH.getPageArray(par, currentpage, pagesize).toJson();
        }
        #endregion
       
    }
}
