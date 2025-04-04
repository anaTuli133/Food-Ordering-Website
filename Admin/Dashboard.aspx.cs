using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Food_Ordering_Project.Admin
{
    public partial class Dashboard : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                Session["breadCrum"] = "";
                if(Session["admin"] == null)
                {
                    Response.Redirect("../User/Login.aspx");
                }
                else
                {
                    DashboardCount dashboard = new DashboardCount();
                    Session["category"] = Convert.ToInt32(dashboard.Count("CATEGORY"));
                    Session["product"] = Convert.ToInt32(dashboard.Count("PRODUCT"));
                    Session["order"] = Convert.ToInt32(dashboard.Count("ORDER"));
                    Session["delivered"] = Convert.ToInt32(dashboard.Count("DELIVERED"));
                    Session["pending"] = Convert.ToInt32(dashboard.Count("PENDING"));
                    Session["user"] = Convert.ToInt32(dashboard.Count("USER"));
                    Session["soldAmount"] = Convert.ToInt32(dashboard.Count("SOLDAMOUNT"));
                    Session["contact"] = Convert.ToInt32(dashboard.Count("CONTACT"));
                }
            }
        }
    }
}