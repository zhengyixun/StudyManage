using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Error : System.Web.UI.Page
{
    public string g, u;
    protected void Page_Load(object sender, EventArgs e)
    {
        g = System.Web.HttpContext.Current.Items["G"].toString();
        u = System.Web.HttpContext.Current.Items["U"].toString();
    }
}