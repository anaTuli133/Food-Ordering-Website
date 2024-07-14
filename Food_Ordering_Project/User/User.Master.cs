using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Food_Ordering_Project.User
{
    public partial class User : System.Web.UI.MasterPage
    {
        protected void Page_Init(object sender, EventArgs e)
        {
            
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Request.Url.AbsoluteUri.ToString().Contains("Default.aspx"))
            {
                
                form1.Attributes.Add("class", "sub_page");
            }
            else
            {
                form1.Attributes.Remove("class");

                //Load the control   
                Control sliderUserControl = (Control)Page.LoadControl("SliderUserControl.ascx");

                // Add the control to the panel  
                pnlSliderUC.Controls.Add(sliderUserControl);
            }

            if(Session["userId"] != null)
            {
                lbLoginOrLogout.Text = "Logout";
                Utils utils = new Utils();
                Session["cartCount"] = utils.cartCount(Convert.ToInt32(Session["userId"])).ToString();
            }
            else
            {
                lbLoginOrLogout.Text = "Login";
                Session["cartCount"] = "0";
            }
        }

        protected void lbRegisterOrProfile_Click(object sender, EventArgs e)
        {
            if(Session["userId"] != null)
            {
                lbRegisterOrProfile.ToolTip = "User Profile";
                Response.Redirect("Profile.aspx");
            }
            else
            {
                lbRegisterOrProfile.ToolTip = "User Registration";
                Response.Redirect("Registration.aspx");
            }
        }

        protected void lbLoginOrLogout_Click(object sender, EventArgs e)
        {
            if (Session["userId"] == null)
            {
                Response.Redirect("Login.aspx");
            }
            else
            {
                Session.Abandon();
                Response.Redirect("Login.aspx");
            }
        }
    }
}