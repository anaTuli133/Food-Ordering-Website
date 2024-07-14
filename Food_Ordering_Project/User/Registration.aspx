<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Registration.aspx.cs" Inherits="Food_Ordering_Project.User.Registration" %>

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

    <%--<script src="http://code.jquery.com/jquery-1.10.2.min.js" type="text/javascript"></script>--%>
    <script type="text/javascript">
        function ImagePreview(input) {
            if (input.files && input.files[0]) {
                var reader = new FileReader();
                reader.onload = function (e) {
                    $('#<%=imgUser.ClientID%>').prop('src', e.target.result)
                        .width(200)
                        .height(200);
                };
                reader.readAsDataURL(input.files[0]);
            }
        }
    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">

    <section class="book_section layout_padding"> <%-- style="background-image: url('../Images/chef5.png'); width: 100%; height: 100%; background-repeat: no-repeat; background-size: contain; background-attachment: scroll; background-position: left"--%>
        <div class="container">
            <div class="heading_container">
                <div class="align-self-end">
                    <asp:Label ID="lblMsg" runat="server" Visible="false"></asp:Label>
                </div>
                <asp:Label ID="lblHeaderMsg" runat="server" Text="<h2>User Registration</h2>"></asp:Label>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div class="form_container">

                        <div>
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Name is required" ControlToValidate="txtName"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Enter Full Name"
                                ToolTip="Full Name"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ErrorMessage="Name must be in characters"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[a-zA-Z\s]+$"
                                ControlToValidate="txtName">
                            </asp:RegularExpressionValidator>
                        </div>
                        <div>
                            <asp:RequiredFieldValidator ID="rfvUsername" runat="server" ErrorMessage="Username is required"
                                ControlToValidate="txtUsername" ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter Username"
                                ToolTip="Username"></asp:TextBox>
                        </div>
                        <div>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ErrorMessage="Email is required" ControlToValidate="txtEmail"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="Enter Email"
                                ToolTip="Email"></asp:TextBox>
                        </div>
                        <div>
                            <asp:RequiredFieldValidator ID="rfvMobile" runat="server" ErrorMessage="Mobile number is required" ControlToValidate="txtMobile"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtMobile" runat="server" CssClass="form-control" TextMode="Number" placeholder="Enter Mobile Number"
                                ToolTip="Mobile Number"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ErrorMessage="Mobile No. must have 11 digits"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true" ValidationExpression="^[0-9]{11}$"
                                ControlToValidate="txtMobile">
                            </asp:RegularExpressionValidator>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="form_container">
                        <div>
                            <asp:RequiredFieldValidator ID="rfvAddress" runat="server" ErrorMessage="Address is required" ControlToValidate="txtAddress"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtAddress" runat="server" TextMode="MultiLine" CssClass="form-control"
                                placeholder="Enter Address" ToolTip="Address"></asp:TextBox>
                        </div>
                        <div>
                            <asp:RequiredFieldValidator ID="rfvPostCode" runat="server" ErrorMessage="Post/Zip Code is required" ControlToValidate="txtPostCode"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtPostCode" runat="server" CssClass="form-control" TextMode="Number" placeholder="Enter Post/Zip Code"
                                ToolTip="Post/Zip Code"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator4" runat="server" ControlToValidate="txtPostCode"
                                ErrorMessage="Post/Zip Code must be of 4 digits" ForeColor="Red" Display="Dynamic" SetFocusOnError="true"
                                ValidationExpression="[0-9]{4}"></asp:RegularExpressionValidator>
                        </div>
                        <div>
                            <asp:FileUpload ID="fuUserImage" runat="server" CssClass="form-control" ToolTip="User Image"
                                onchange="ImagePreview(this);" />
                        </div>
                        <div>
                            <asp:RequiredFieldValidator ID="rfvPassword" runat="server" ErrorMessage="Password is required" ControlToValidate="txtPassword"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" placeholder="Enter Password" TextMode="Password"
                                ToolTip="Password"></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="row pl-4">
                    <div class="btn_box">
                        <asp:Button ID="btnRegister" runat="server" Text="Register" CssClass="btn btn-success rounded-pill pl-4 pr-4 text-white"
                            OnClick="btnRegister_Click" />
                        <%--<span class="pl-3 text-black-100">Already registered? <a href="Login.aspx" class="badge badge-info">Login here..</a></span>--%>
                        <asp:Label ID="lblAlreadyUser" runat="server" CssClass="pl-3 text-black-100"
                            Text="Already registered? <a href='Login.aspx' class='badge badge-info'>Login here..</a>">
                        </asp:Label>
                    </div>
                </div>
                <div class="row p-5">
                    <div style="align-items:center">
                        <asp:Image ID="imgUser" runat="server" CssClass="img-thumbnail" />
                    </div>
                </div>
            </div>
        </div>
    </section>

</asp:Content>
