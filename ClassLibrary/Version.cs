using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ZhClass;
namespace STU
{
    public class Version
    {
        #region 获取版本信息
        public static string GetVersionC(int currentpage, int pagesize, string key)
        {
            SqlPar par = SqlXml.GetSearchSqlPage("Version", "版本列表", 0,
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
