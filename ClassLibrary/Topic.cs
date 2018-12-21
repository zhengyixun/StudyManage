using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZhClass;

namespace STU
{
    public class Topic
    {
        public int id { get; set; }
        public string topicName { get; set; }
        public string topicAnswer { get; set; }
        public string state { get; set; }
        /// <summary>
        /// state 默认  可以不传
        /// </summary>
        public string memo { get; set; }

        #region
        public static string SelectDataByPage(int currentpage,int pagesize,string key) 
        {
            SqlPar par = SqlXml.GetSearchSqlPage("Topic", "获取问题数据", 0, !key.IsNullOrEmpty());
            par.SetParValues(key.IsNullOrEmpty() ? null : key);///key 不是空则 根据key值查询
            return ZH.getPageArray(par, currentpage, pagesize).toJson();///将获取到的数据转成json
        }
        #endregion

        #region 添加问题
        public bool Add()
        {
            SqlPar par = SqlXml.GetSql("Topic", "添加问题");///创建节点
            par.SetParValues(this.topicName,this.topicAnswer,this.memo);  ///顺序要一样 state 默认是1 可以不穿
            return DB.ExeSql(par) > 0;///>0代表插入成功
        }
        #endregion
        #region  修改问题
        public bool Update()
        {
            SqlPar par = SqlXml.GetSql("Topic", "修改问题");///创建节点
            par.SetParValues(this.topicName, this.topicAnswer, this.state, this.memo, this.id);///修改的时候，状态 可以修改
            return DB.ExeSql(par) > 0;///>0代表执行成功
        }
        #endregion
        #region  删除问题
        public bool Del()
        {
            SqlPar par = SqlXml.GetSql("Topic", "删除问题");///创建节点
            par.SetParValues(this.id);
            return DB.ExeSql(par) > 0;///>0代表执行成功
        }
        #endregion
        #region
        public bool GetRow()
        {
            SqlPar par = SqlXml.GetSql("Topic", "获取单挑数据问题");///创建节点
            par.SetParValues(this.id);
            var obj = DB.GetRow(par);
            if (obj.IsValue) {
                ///赋值
                this.topicName = obj["topicName"].toString();
                this.topicAnswer = obj["topicAnswer"].toString();
                this.state = obj["state"].toString();
                this.memo = obj["memo"].toString();
                return true;
            }
            else
            {
                return false;
            }
        }
        #endregion
    }
}
