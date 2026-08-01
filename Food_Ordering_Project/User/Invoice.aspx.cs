using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using iTextSharp.text.pdf;
using iTextSharp.text;
using System.IO;
using System.Net;

namespace Food_Ordering_Project.User
{
    public partial class Invoice : System.Web.UI.Page
    {
        SqlConnection con;
        SqlCommand cmd;
        SqlDataAdapter sda;
        DataTable dt;
        protected void Page_Load(object sender, EventArgs e)
        {
            if(!IsPostBack)
            {
                if(Session["userId"] != null)
                {
                    if (Request.QueryString["id"] != null)
                    {

                        rOrderItem.DataSource = GetOrderDetails();
                        rOrderItem.DataBind();
                    }
                }
                else
                {
                    Response.Redirect("Login.aspx");
                }
            }
        }

protected void lbDownloadInvoice_Click(object sender, EventArgs e)
{
    try
    {
        string folderPath = Server.MapPath("~/Invoices/");

        if (!Directory.Exists(folderPath))
        {
            Directory.CreateDirectory(folderPath);
        }

        string fileName = "Order_Invoice_" + Request.QueryString["id"] + ".pdf";
        string filePath = Path.Combine(folderPath, fileName);

        DataTable dtbl = GetOrderDetails();

        ExportToPdf(dtbl, filePath, "Order Invoice");

        Response.Clear();
        Response.ContentType = "application/pdf";
        Response.AppendHeader("Content-Disposition", "attachment; filename=" + fileName);
        Response.TransmitFile(filePath);
        Response.Flush();
        HttpContext.Current.ApplicationInstance.CompleteRequest();
    }
    catch (Exception ex)
    {
        lblMsg.Visible = true;
        lblMsg.Text = "Error Message: " + ex.Message;
    }
}

        DataTable GetOrderDetails()
        {
            double grandTotal = 0;
            con = new SqlConnection(Connection.GetConnectionString());
            cmd = new SqlCommand("Invoice", con);
            cmd.Parameters.AddWithValue("@Action", "INVOICBYID");
            cmd.Parameters.AddWithValue("@PaymentId", Convert.ToInt32(Request.QueryString["id"]));
            cmd.Parameters.AddWithValue("@UserId", Session["userId"]);
            cmd.CommandType = CommandType.StoredProcedure;
            sda = new SqlDataAdapter(cmd);
            dt = new DataTable();
            sda.Fill(dt);
            if(dt.Rows.Count > 0 )
            {
                foreach(DataRow drow in dt.Rows)
                {
                    grandTotal += Convert.ToDouble(drow["TotalPrice"]);
                }
            }
            DataRow dr = dt.NewRow();
            //dr["Quantity"] = "GrandTotal";
            dr["TotalPrice"] = grandTotal;
            dt.Rows.Add(dr);
            return dt;
        }

void ExportToPdf(DataTable dtblTable, string strPdfPath, string strHeader)
{
    using (FileStream fs = new FileStream(strPdfPath, FileMode.Create, FileAccess.Write, FileShare.None))
    {
        Document document = new Document(PageSize.A4);

        PdfWriter writer = PdfWriter.GetInstance(document, fs);

        document.Open();

        // Header
        BaseFont bfntHead = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
        Font fntHead = new Font(bfntHead, 16, Font.BOLD, Color.GRAY);

        Paragraph prgHeading = new Paragraph();
        prgHeading.Alignment = Element.ALIGN_CENTER;
        prgHeading.Add(new Chunk(strHeader.ToUpper(), fntHead));
        document.Add(prgHeading);

        // Author
        BaseFont bfAuthor = BaseFont.CreateFont(BaseFont.TIMES_ROMAN, BaseFont.CP1252, BaseFont.NOT_EMBEDDED);
        Font fntAuthor = new Font(bfAuthor, 8, Font.ITALIC, Color.GRAY);

        Paragraph prgAuthor = new Paragraph();
        prgAuthor.Alignment = Element.ALIGN_RIGHT;
        prgAuthor.Add(new Chunk("Order From : Foodie Fast Food", fntAuthor));

        if (dtblTable.Rows.Count > 0)
        {
            prgAuthor.Add(new Chunk("\nOrder Date : " + dtblTable.Rows[0]["OrderDate"].ToString(), fntAuthor));
        }

        document.Add(prgAuthor);

        document.Add(new Paragraph(" "));

        PdfPTable table = new PdfPTable(dtblTable.Columns.Count - 2);
        table.WidthPercentage = 100;

        Font headerFont = new Font(bfAuthor, 9, Font.BOLD, Color.WHITE);

        for (int i = 0; i < dtblTable.Columns.Count - 2; i++)
        {
            PdfPCell cell = new PdfPCell();
            cell.BackgroundColor = Color.GRAY;
            cell.AddElement(new Chunk(dtblTable.Columns[i].ColumnName.ToUpper(), headerFont));
            table.AddCell(cell);
        }

        Font dataFont = new Font(bfAuthor, 8, Font.NORMAL, Color.BLACK);

        foreach (DataRow row in dtblTable.Rows)
        {
            for (int j = 0; j < dtblTable.Columns.Count - 2; j++)
            {
                PdfPCell cell = new PdfPCell();
                cell.AddElement(new Chunk(row[j].ToString(), dataFont));
                table.AddCell(cell);
            }
        }

        document.Add(table);

        document.Close();
        writer.Close();
    }
}
    }
}
