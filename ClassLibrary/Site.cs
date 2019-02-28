using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZhClass;
namespace STU
{
    public class Site
    {
        public string site_id { get; set; } //场地id
        public string site_name { get; set; } //场地名称
        public string site_area { get; set; } //场地面积
        public string site_img { get; set; } //场地图片
        public string site_using_time_total { get; set; } //总共可使用时间段
        public string site_used_time { get; set; } //已被使用时间段
        public string site_desc { get; set; }//备注

        #region 获取场地列表
        public static string GetSiteC(int currentpage, int pagesize, string key)
        {
            SqlPar par = SqlXml.GetSearchSqlPage("Site", "场地列表", 0,
                !key.IsNullOrEmpty()
                );
            par.SetParValues(
                key.IsNullOrEmpty() ? null : key
                );
            return ZH.getPageArray(par, currentpage, pagesize).toJson();
        }
        #endregion
        #region 添加场地
        public bool AddSiteC()
        {
            SqlPar par = SqlXml.GetSql("Site", "添加场地");
            par.SetParValues(this.site_name, this.site_area, this.site_img,this.site_using_time_total, this.site_desc);
            return DB.ExeSql(par) > 0;
        }
        #endregion
        #region 删除场地
        public bool DelSiteC()
        {
            SqlPar par = SqlXml.GetSql("Site", "删除场地");
            par.SetParValues(this.site_id);
            return DB.ExeSql(par) > 0;
        }
        #endregion
        #region 编辑场地
        public bool UpdateSiteC()
        {
            SqlPar par = SqlXml.GetSearchSql("Site", "编辑场地");
            par.SetParValues(
                this.site_name, this.site_area, this.site_img, this.site_using_time_total , this.site_desc, this.site_id
            );
            return DB.ExeSql(par) > 0;
        }
        #endregion

    }
}
