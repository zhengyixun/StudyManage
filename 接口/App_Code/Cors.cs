using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace STU
{
    /// <summary>
    /// Cors 的摘要说明
    /// </summary>
    public class Cors : IHttpModule
    {
        string[] origins = new string[] {
            "http://studymanage.study.com"
        };
        public Cors() { }

        public void Dispose() { }

        public void Init(HttpApplication context)
        {
            context.BeginRequest += Context_BeginRequest;
            context.Error += Context_Error;
        }

        private void Context_Error(object sender, EventArgs e)
        {
            ZhClass.ZH.SaveErr("Error:" + HttpContext.Current.Server.GetLastError().toString());
        }

        private void Context_BeginRequest(object sender, EventArgs e)
        {
            string origin = HttpContext.Current.Request.Headers["Origin"];
            if (HttpContext.Current.Request.HttpMethod == "OPTIONS") //如是options，则一概放行
            {
                HttpContext.Current.Response.AddHeader("Access-Control-Allow-Origin", origin);
                HttpContext.Current.Response.End(); //这个必须有，否则客户端不会发送POST请求
            }

            //Save(); //这里具体POST时，再判断是否是指定来源，是否有NODEWEBKIT这个自定义头，其实这里的值将来可以做判断
            if (origins.Contains(origin))
            {
                HttpContext.Current.Response.AddHeader("Access-Control-Allow-Origin", origin.IsNull("*"));
            }
        }
        void Save()
        {
            List<string> list = new List<string>();
            list.Add(HttpContext.Current.Request.HttpMethod);
            foreach (var p in HttpContext.Current.Request.Headers)
            {
                list.Add(string.Format("{0}:{1}", p, HttpContext.Current.Request.Headers[p.ToString()]));
            }
            ZhClass.ZH.SaveErr(string.Join("\r\n", list));
        }
    }
}