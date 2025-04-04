<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" EnableEventValidation="false" CodeBehind="Invoice.aspx.cs" Inherits="Food_Ordering_Project.User.Invoice" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        /*For disappearing alert message*/
        window.onload = function () {
            var seconds = 5;
            setTimeout(function () {
                document.getElementById("<%=lblMsg.ClientID %>").style.display = "none";
            }, seconds * 1000);
        };
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <section class="book_section layout_padding" style="background-image: url('../Images/payment-bg.png'); width: 100%; height: 100%; background-repeat: no-repeat; background-size: auto; background-attachment: fixed; background-position: left;">

        <div class="container">
            <div class="heading_container heading_center">
                <div class="align-self-end">
                    <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
                </div>
                <%--<h2>Your Orders Invoice</h2>--%>
            </div>
            <div class="container">
                <asp:Repeater ID="rOrderItem" runat="server">
                    <HeaderTemplate>
                        <table class="table table-responsive-sm table-bordered table-hover" id="tblInvoice">
                            <thead class="bg-dark text-white">
                                <tr>
                                    <th>Sr.No</th>
                                    <th>Order Number</th>
                                    <th>Item Name</th>
                                    <th>Unit Price</th>
                                    <th>Quantity</th>
                                    <th>Total Price</th>
                                </tr>
                            </thead>
                            <tbody>
                    </HeaderTemplate>
                    <ItemTemplate>
                        <tr>
                            <td><%# Eval("SrNo") %></td>
                            <td>
                                <%# Eval("OrderNo") %>
                            </td>
                            <td>
                                <%# Eval("Name") %>
                            </td>
                            <td>
                                <%# string.IsNullOrEmpty( Eval("Price").ToString() ) ? "" : "৳"+ Eval("Price") %>
                            </td>
                            <td>
                                <%# Eval("Quantity") %>
                            </td>
                            <td>
                                ৳<%# Eval("TotalPrice") %>
                            </td>
                        </tr>
                    </ItemTemplate>
                    <FooterTemplate>
                        </tbody>
                    </table>
                    </FooterTemplate>
                </asp:Repeater>

                <div class="text-center">
                    <asp:LinkButton ID="lbDownloadInvoice" runat="server" CssClass="btn btn-info" OnClick="lbDownloadInvoice_Click">
                        <i class="fa fa-file-pdf-o mr-2"></i> Download Invoice</asp:LinkButton>
                </div>

                <div class="pt-3">
                    <%--<asp:Literal ID="ltEmbed" runat="server" />--%>
                </div>

            </div>
        </div>
    </section>

</asp:Content>
