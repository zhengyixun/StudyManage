using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Main : System.Web.UI.Page
{
    public string str = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        string[] flag = STU.Config.ManageUser.flag.Split(',');
        str = string.Join("\r\n", STU.Config.ManageMenu.Where(t => !t.href.IsNullOrEmpty() && t.flag.Split(',').All(p => flag.Contains(p))).GroupBy(t => t.f_name).Select(t => string.Format(@"<span>{0}</span><div>{1}</div>", t.Key,
              string.Join("", t.Select(p => string.Format(@"<a href=""{1}"">{0}</a>", p.name, p.href)))
              )));
    }
}