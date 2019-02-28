using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace STU
{
    public class UpXLS : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "text/plain";
            try
            {
                HttpFileCollection uploadedFiles = context.Request.Files;
                HttpPostedFile F = uploadedFiles[0];
                if (F != null)
                {
                    //CS.Config.SaveErr(F.FileName + "," + context.Request.Form["type"]);

                    string file = STU.Config.folder.UpLoad.MapPath() + "\\" + F.FileName;
                    F.SaveAs(file);

                    var ary = file.Import();
                    if (!ary.IsValue)
                        context.Response.Write(@"{ ""err"":""此文档无内容"" }");

                    System.Text.StringBuilder sb = new System.Text.StringBuilder(@"<table cellpadding=""1"" cellspacing=""1"">");
                    sb.AppendFormat(@"<thead><tr>{0}</tr></thead>", string.Join("", ary[0].Select(t => string.Format(@"<td>{0}</td>", t))));
                    ary.RemoveAt(0);
                    sb.Append("<tbody>");
                    ary.ForEach(t => sb.AppendFormat(@"<tr>{0}</tr>", string.Join("", t.Select(p => string.Format(@"<td>{0}</td>", p)))));
                    sb.Append("</tbody>");
                    sb.Append("</table>");
                    context.Response.Write(string.Format(@"{{ ""err"":"""", ""html"":""{0}"" }}", sb.ToString().Base64Encode()));
                }
                else
                    context.Response.Write(@"{ ""err"":""未上传文件"" }");
            }
            catch (Exception e) { ZhClass.ZH.SaveErr(e.toString()); }
        }

        public bool IsReusable { get { return false; } }
    }
}
