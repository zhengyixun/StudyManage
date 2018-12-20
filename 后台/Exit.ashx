<%@ WebHandler Language="C#" Class="Exit" %>

using System;
using System.Web;
using System.Web.SessionState;
using System.Linq;

public class Exit : IHttpHandler, IRequiresSessionState
{
    public void ProcessRequest(HttpContext context)
    {
        context.Session.Clear();
        context.Request.Cookies.AllKeys.ForEach(t => context.Response.Cookies.Add(new HttpCookie(t)
        {
            Domain = string.Join(".", System.Web.HttpContext.Current.Request.Url.DnsSafeHost.Split('.').Skip(1)),
            Expires = System.DateTime.Now.AddDays(-1)
        }));
        context.Request.Cookies.AllKeys.ForEach(t => context.Response.Cookies.Add(new HttpCookie(t)
        {
            Expires = System.DateTime.Now.AddDays(-1)
        }));
        context.Response.Redirect("/");
    }

    public bool IsReusable { get { return false; } }
}