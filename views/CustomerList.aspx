<%@ Page Language="AVR" MasterPageFile="~/MasterPageNav.master" AutoEventWireup="false" CodeFile="CustomerList.aspx.vr" Inherits="views_CustomerList" Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
    <%--#
// HttpContext.Current.IsDebuggingEnabled is true when the application 
// is running under debug. This lets you conditionally include different 
// code for debug/production. In this case the same code is included but 
// it would be good if the CSS were combined and minified for production.
// If you did that the combined and minified CSS would be specified 
// for the production version.
#--%>

</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="Content" Runat="Server">

    <%--<div class="container">--%>

    <div class="right-content">
        <div class="gutter g"></div>
        <div class="center-gutter">
            <div class="subheading mt-3 b">
                <h2>Customer Form</h2>
            </div>
            <div class="subnav r">
                <div class="controls">
                    <asp:Button ID="buttonNext" runat="server" Text="Next" />
                    <asp:Panel ID="Panel1" runat="server" DefaultButton="buttonPositionTo">
                        <asp:Button cssClass="ms-3" ID="buttonPositionTo" runat="server" Text="Position to"/>
                        <asp:TextBox ID="textboxPositionTo" runat="server" placeholder="Position to value"></asp:TextBox>
                    </asp:Panel> 
                </div>
                <!-- gridview start -->
                <asp:GridView ID="gridviewCust" runat="server" AutoGenerateColumns="False" CssClass="gridview zebra-stripe customerlist" DataKeyNames="customer_cmname,customer_cmcustno">
                    <Columns>
                        <asp:BoundField DataField="Customer_CMCustNo" HeaderText="Number" DataFormatString="{0:00000}" HtmlEncode="False">
                        <ItemStyle CssClass="col-number" />
                        </asp:BoundField>

                        <asp:BoundField DataField="customer_cmname" HeaderText="Name" >                
                        <ItemStyle CssClass="col-name" />
                        </asp:BoundField>

                        <%--<asp:ButtonField CommandName="ActionEdit" Text="Edit" >--%>
                        <asp:ButtonField CommandName="ActionEdit" Text='<i class="fas fa-edit"></i>' >
                        <ItemStyle CssClass="col-text-button" />
                        </asp:ButtonField>



                        <%--<asp:ButtonField CommandName="ActionDelete" Text="Delete" >--%>
                        <asp:ButtonField CommandName="ActionDelete" Text='<i class="fas fa-trash"></i>' >
                        <ItemStyle CssClass="col-text-button" />
                        </asp:ButtonField>
                    </Columns>
                </asp:GridView>
                <!-- gridview end -->
                <div class="table-footer">
                    <asp:Label ID="labelTableFooter" runat="server" Text="Label"></asp:Label>
                </div>
            </div>
        </div>
        <div class="gutter g"></div>
    </div>


    <%--</div>--%>


</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" Runat="Server">
    <script>
        applib.removeAspNetCheckboxWrapper('input[type="radio"],input[type="checkbox"]');
    </script>
</asp:Content>
