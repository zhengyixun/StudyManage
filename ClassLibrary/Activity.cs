using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZhClass;
namespace STU
{
    public class Activity
    {
        public string activity_id { get; set; }  //用户id
        public string activity_creater_name { get; set; }  
        public string activity_name { get; set; }  
        public string activity_type { get; set; }  
        public string activity_min_people { get; set; }  
        public string activity_max_people { get; set; }
        public string activity_con { get; set; }
        public string activity_work_con { get; set; }
        public string activity_img_vedio_url { get; set; }
        public string activity_address { get; set; }
        public string activity_start_time { get; set; }
        public string activity_end_time { get; set; }
        public string activity_signup_end_time { get; set; }
        public string activity_state { get; set; }
        public string activity_site_id { get; set; }  //场地id

        #region 获取活动列表
        public static string GetActivityC(int currentpage, int pagesize, string key)
        {
            SqlPar par = SqlXml.GetSearchSqlPage("Activity", "活动列表", 0,
                !key.IsNullOrEmpty()
                );
            par.SetParValues(
                key.IsNullOrEmpty() ? null : key
                );
            return ZH.getPageArray(par, currentpage, pagesize).toJson();
        }
        #endregion
        #region 添加活动信息
        public bool AddActivityC()
        {
            SqlPar par = SqlXml.GetSearchSql("Activity", "添加活动信息");
            par.SetParValues(
                this.activity_creater_name, this.activity_name,this.activity_site_id,
                this.activity_type,
                this.activity_min_people, this.activity_max_people, this.activity_con,
                this.activity_work_con, this.activity_img_vedio_url, this.activity_address,
                this.activity_start_time, this.activity_end_time, this.activity_signup_end_time,
                this.activity_state
            );
            return DB.ExeSql(par) > 0;
        }
        #endregion
        #region 审核-编辑活动信息
        public bool UpdateActivityC()
        {
            SqlPar par = SqlXml.GetSearchSql("Activity", "编辑活动信息");
            par.SetParValues(
                this.activity_creater_name, this.activity_name, this.activity_site_id,
                this.activity_type,
                this.activity_min_people, this.activity_max_people, this.activity_con,
                this.activity_work_con, this.activity_img_vedio_url, this.activity_address,
                this.activity_start_time, this.activity_end_time, this.activity_signup_end_time,
                this.activity_state,this.activity_id
            );
            return DB.ExeSql(par) > 0;
        }
        #endregion
        #region 删除活动信息
        public bool DelActivityC()
        {
            SqlPar par = SqlXml.GetSearchSql("Activity", "删除活动信息");
            par.SetParValues(
                 this.activity_id
            );
            return DB.ExeSql(par) > 0;
        }
        #endregion


        #region 获取报名者列表
        public static string GetActivitySignUpC(int currentpage, int pagesize, string key)
        {
            SqlPar par = SqlXml.GetSearchSqlPage("Activity", "报名列表", 0,
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
