using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using ZhClass;

public partial class Manage_Users : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //if (!IsPostBack)
        //{
        //    List.ItemDataBound += (a, b) =>
        //        {
        //            string area = b.Item["area"].toString();
        //            switch (area.Length)
        //            {
        //                case 0:
        //                    b.Item.setValue("area", "总管理员");
        //                    break;
        //                case 2:
        //                    b.Item.setValue("area", area.XmlText("省", true));
        //                    break;
        //                case 4:
        //                    b.Item.setValue("area", string.Format("{0} {1}", area.Left(2).XmlText("省", true), area.XmlText("市", true)));
        //                    break;
        //                case 6:
        //                    b.Item.setValue("area", string.Format("{0} {1} {2}", area.Left(2).XmlText("省", true), area.Left(4).XmlText("市", true), area.XmlText("区", true)));
        //                    break;
        //            }
        //        };
        //    CS.ManageUser.List(List);
        //}
    }
}