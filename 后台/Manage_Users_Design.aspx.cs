using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZhClass;

public partial class Manage_Users_Design : System.Web.UI.Page
{
    public string flag = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        flag = string.Join
            ("\r\n",
                STU.Config.ManageMenu.GroupBy(t => t.f_name).Select
                (t =>
                    string.Format
                    (@"<div class=""menu""><strong><label class=""head""><input type=""checkbox"" value="""" /><span>{0}</span></label></strong>{1}</div>",
                        t.Key,
                        string.Join
                        ("\r\n",
                            t.Select
                            (p =>
                                string.Format
                                (@"<label class=""item""><input type=""checkbox"" value=""{0}"" /><span>{1}</span></label>",
                                p.flag,
                                p.name
                                )
                            )
                        )
                    )
                )
            );
    }
}