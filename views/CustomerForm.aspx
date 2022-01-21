<%@ Page Language="AVR" MasterPageFile="~/MasterPageNav.master" AutoEventWireup="false" CodeFile="CustomerForm.aspx.vr" Inherits="CustomerForm" Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Head" Runat="Server">
    <%--#
// HttpContext.Current.IsDebuggingEnabled is true when the application 
// is running under debug. This lets you conditionally include different 
// code for debug/production. In this case the same code is included but 
// it would be good if the CSS were combined and minified for production.
// If you did that the combined and minified CSS would be specified 
// for the production version.
#--%>
    <%
    If (HttpContext.Current.IsDebuggingEnabled)     
    %>
    <link rel="stylesheet" href="/public/css/one-column-layout.css">
    <link rel="stylesheet" href="/public/css/grid.css">
    <%
    Else
    %>
    <link rel="stylesheet" href="/public/css/one-column-layout.css">
    <link rel="stylesheet" href="/public/css/grid.css">
    <%
    EndIf 
    %>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="Content" Runat="Server">

    <div class="container">
    <h2>Customer Form</h2>
        <div>
            <asp:Button ID="buttonNext" runat="server" Text="Next" />
            <asp:Panel ID="Panel1" runat="server" DefaultButton="buttonPositionTo" Style="display:inline;">
                <asp:Button ID="buttonPositionTo" runat="server" Text="Position to"/>
                <asp:TextBox ID="textboxPositionTo" runat="server" placeholder="Position to value"></asp:TextBox>
            </asp:Panel> 
        </div>
        <div style="margin-top: 3em;">
        <asp:GridView ID="gridviewCust" runat="server" AutoGenerateColumns="False" CellPadding="4" GridLines="None" 
            AllowPaging="True" CssClass="FixedSizeText" ForeColor="#333333" ShowFooter="True" DataKeyNames="customer_cmname,customer_cmcustno">
            <FooterStyle BackColor="Silver" ForeColor="White" Font-Bold="True" />
            <Columns>
                <asp:BoundField DataField="Customer_CMCustNo" HeaderText="Number" DataFormatString="{0:00000}" HtmlEncode="False">
                    <ItemStyle Width="12%" />
                </asp:BoundField>
                <asp:BoundField DataField="customer_cmname" HeaderText="Name" />
                
                <asp:ButtonField CommandName="ActionEdit" Text="<i class='fa-solid fa-pencil'></i>" />

                <asp:ButtonField CommandName="ActionDelete" Text="<i class='fa-light fa-trash-can'></i>" />

            </Columns>
            <RowStyle BackColor="#E4E4E4" />
            <SelectedRowStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
            <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" />
            <HeaderStyle BackColor="Silver" Font-Bold="True" ForeColor="Black" />
            <AlternatingRowStyle BackColor="White" />
            <PagerSettings Visible="False" />
            <EditRowStyle BackColor="#2461BF" />
        </asp:GridView>
        </div>
</div>


</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" Runat="Server">
    <script>
        applib.removeAspNetCheckboxWrapper('input[type="radio"],input[type="checkbox"]');
    </script>
</asp:Content>
