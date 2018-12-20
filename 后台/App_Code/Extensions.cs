using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Xml.Linq;

/// <summary>
/// Extensions 的摘要说明
/// </summary>
public static class Extensions
{
    public static string Url(this HttpContext content)
    {
        Dictionary<string, string> i = new Dictionary<string, string>();
        HttpCookie cookie = content.Request.Cookies["url"];
        if (cookie == null)
            cookie = new HttpCookie("url");
        else //分析已有的内容，把键值取出来
            Regex.Matches(cookie.Value, @"""(.*?)"":""(.*?)""", RegexOptions.IgnoreCase).OfType<Match>().ForEach(t => i.Add(t.Groups[1].Value, t.Groups[2].Value));

        Uri urlreferrer = content.Request.UrlReferrer, url = content.Request.Url;
        if (urlreferrer.toString() == url.toString()) //是刷新后的产物
        {
            if (i.ContainsKey(url.LocalPath))
                return i[url.LocalPath]; //若有，给出去
            return "";
        }
        else //正常进入
        {
            if (!i.ContainsKey(url.LocalPath))
                i.Add(url.LocalPath, urlreferrer.PathAndQuery);
            else
                i[url.LocalPath] = urlreferrer.PathAndQuery;
            //先不控制总数

            cookie.Value = string.Join(",", i.Select(t => string.Format(@"""{0}"":""{1}""", t.Key, t.Value)));
            content.Response.SetCookie(cookie);

            return urlreferrer.toString();
        }
    }
    public static void SetXmlForList(this HtmlSelect list, string nodename, Func<XElement, bool> where = null, string defaultvalue = "")
    {
        if (list == null) return;
        var p = ZhClass.SqlXml.CatchXml().Elements(nodename).Elements("node");
        if (where != null)
            p = p.Where(where);
        p.ForEach(t => list.Items.Add(new ListItem(t.Attribute("text").Value, t.Value)));

        if (!defaultvalue.IsNullOrEmpty())
            list.Value = defaultvalue;
    }
}