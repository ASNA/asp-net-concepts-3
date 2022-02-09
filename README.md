# ASP.NET Webforms concepts 3 #

Changes made to #2 example

- enable views/system to all users in web.config
- Start a new project by copying from your template project

Programming with classes

- Instancing
- Shared members
- Properties
- Referencing
- *This

### CUSTOMER LIST

Starting a new project from an existing one

- Although Visual Studio has a templating feature, it makes changing templates cumbersome.
- I think it's better to simply a copy a project you want to use as the template.

Creating the CustomerList.aspx page

- HTML in CustomerList.aspx markup
   - This HTML is a way to provide a three-column subpage where the left and right columns are gutters that won't have content. This helps center content in the page. We'll hook up CSS to it later.

```
<div class="right-content">

    <div class="gutter"></div>

    <div class="center-gutter">
        <div class="subnav">
            <div class="controls">
			
            </div>
			
			[sibling divs or other top-level elements here as needed.]
			
        </div>
    </div>
    <div class="gutter"></div>
</div>
```

Controls on CustomerList.aspx

- Disable CSS initially -- need to remove it from the discussion for a while
- panelControl, buttonNext, buttonPositionTo, and textboxPositionTo
   - Note that the Panel control has a `controls` property. It is is a control container. We'll discuss this in more detail when we discussing creating the `CustomerList.aspx` page
- Explain panel control and it provides a default button for its contents
- GridView
   - Add a GridView control. Do _not_ add any property styling. We'll do all of that with CSS.
   - Add two BoundFields and two ButtonFields
      - Bound fields
         - GridView's `DataField` names must match those in Memory file
            - Data file uses a prefix and memory uses a pseudo prefix (ie, starts with `Customer_`) to match the field name in the Customer record format.
            -  
```
DclDiskFile Customer +
        Type(*Input) + 
        Org(*Indexed) + 
        Prefix(Customer_) + 
        File("examples/cmastnewl2") +
        DB(DGDB) +
        ImpOpen(*No)  

DclMemoryFile MemFile ImpOpen(*Yes) 
    DclRecordFormat Customers 
    DclRecordFld    Customer_CMCustNo  Type(*Packed) Len(9,0)
    DclRecordFld    Customer_CMName    Type(*Char) Len(40)
         - Number: provide HeaderText (`Number`) and DataField (`Customer_CMCustNo`) and DataFormatString (`{0:00000}`)
         - Name: provide HeaderText (`Name`) and DataField (`Customer_CMName`)
      - Buttton fields
         - ActionEdit - direct user to Customer edit page
         - ActionDelete - not used in this code but shows how to implement multiple buttons
         - Explain the ButtonField's CommandName property
            - ActionEdit and ActionDelete
               - These command names surface the RowCommand event.
            - https://asna.com/us/articles/newsletter/2013/q3/multi-columns-click #link
         - Later we'll change the text to icons (using FontAwesome)
            -  
```
<asp:ButtonField CommandName="ActionEdit" Text="<i class='fa-solid fa-pencil'></i>" />
<asp:ButtonField CommandName="ActionDelete" Text="<i class='fa-light fa-trash-can'></i>" />
   - Add DataKeyNames (`customer_cmname,customer_cmcustno`)
      - DataKeyNames are essentially hidden fields in the GridView
   - GridView events
      - RowCommand
         - The `RowCommand` event fires when a GridView button has been clicked that has a `CommandName` property value assigned.
         - Note how information is passed into the RowCommand event through its `e` argument.
      - SelectedIndexChanged
         - This event isn't used in this code, but its stubbed in here to show that it's available.
   - GridView methods
      - The GridView's `DataBind` method is what causes the GridView's corresponding HTML to be generated and injected into the page.

Discuss connection pooling and singleton DB pattern

- Examples
   - With connection pooling on, connect in an aspx page but do not disconnect. Show jobs grow with each postback
      - Fix it with Disconnect DGDB before page goes out of scope
   - With connection pooling off, connect in an aspx page and disconnect. Show how there are no jobs after the page goes out of scope. Seems good, _but_ you are creating a new IBM i job from scratch for every request This is not good! That is expensive.
      - Show how with no disconnect, this also stacks up orphan jobs.
   - Create a class that uses a DB (without singleton DB pattern). Show that it creates orphan jobs -- notice that jobs grow by one with each postback (those are orphan jobs from the class). Add "Open Customer" in constructor and show the orphan jobs have open files!
      - Fix it first with a Close method in the class
         - Note this fixes it -- but you gotta remember to do it!
      - Fix it with the SingletonDB pattern
   - Add a file to index.aspx.vr and open it in the constructor. Use a breakpoint in UseFile to show that there are two instances of the CMastNewL2 file opened.
   - Show job difference between TerminateAll and just plain ol' ending
- [Read about DataGate connection pooling](https://asna.com/us/tech/kb/doc/connection-pooling)
- [Read about how to find ASP.NET job leaks](https://asna.com/us/tech/kb/doc/ibm-i-orphan-jobs)
- [Singleton DB pattern in AVR](https://asna.com/us/tech/kb/doc/singleton-db-pattern)
- Rules of thumb
   - Disconnect before _every_ DB connection goes out of scope
   - Use the singleton DB pattern to pass DB connections around to secondary classes
- Also discuss the need to persist user id and password in session variables if you want the user to always connection with those credentials.

Helper classes

- App_code folder
- CustomerByNameList
   - This classes provides the file IO to populate the GridView's DataSource.
- AppStateHelpers
   - This helper class provides some convenient methods to make it easier to use the Session and Application objects.
   - Note how it has be instanced by passing in a reference to the page's System.Web.HttpContext. This reference provides access to the Session and Application objects.

CodeBehind - CustomerList.aspx.vr

- All file IO for populating the list is done in the CustomerByNameList class.
- Class: CustomerByNameList
   - MemoryFile
   - Properties
   - Constructor
   - Methods: Open, Close, ReadPage, ReadNextPage, PositionPageTo
- Page methods
   - Page_Load
      - Connects to DB
      - Instance CustomerByNameList
      - Fetch first page of data if first time page is displayed
         - If position-to values are provided position the list to those values
         - Otherwise, get first set of rows
   - ArePositionValuesProvided
      - Check session vars to see if position-to values are provided
   - BindGridView
      - Assigns and binds data to the GridView
      - Persist last row keys in ViewState
      - Persist top row keys in SessionState
      - Set Next button enabled status and show "more records" status message
   - Page_Unload
      - Disconnects the database.
   - gridviewCust_SelectedIndexChanged
      - This event handler isn't used in this code but shows how to fetch data from DataKeys if needed.
   - buttonNext_Click
      - Using key values from last row, fetch next page of rows
   - buttonPositionTo_Click
      - Using value in PositionTo textbox attempt to position list at that value
   - gridviewCust_RowCommand
      - Get CommandName, row index (via SelectedIndex), and customer number from that row from the GridView's DataKeys property
      - If CommandName is 'ActionEdit' the save the current customer in a session variable and redirect to the CustomerForm.aspx

Enable CSS and icons

- layout.css
   - Minimal page layout
   - Zebra stripe a table
   - Give Bootstrap form-controls a great background
- FontAwesome
   - https://fontawesome.com/

CSS Grid and Flex

- https://css-tricks.com/snippets/css/complete-guide-grid/
- https://css-tricks.com/snippets/css/a-guide-to-flexbox/

Creating the CustomerForm.aspx

- Discuss [System.Web.UI.Page.Controls](https://docs.microsoft.com/en-us/dotnet/api/system.web.ui.control.controls?view=netframework-4.7.1#system-web-ui-control-controls) property
   - There are several controls that are containers that also have a `Controls` property.
   - Best way to find a control is to recursively iterate a `controls` property looking for the desired control by Id. See `FindControlRecursive` in the `CrudHelpers` class.

### CUSTOMER FORM

Creating the CustomerForm.aspx page

- CustomerList.aspx page note:
   -  If 'first-customer-name' and 'first-customer-number' session variables exist, the list is positioned to those values; otherwise the list is positioned at the top of the file.
- Navigating to the CustomerForm.aspx.page
   - Add update form
      - Add controls
         - Input controls as needed
         - Buttons
            - Update
               - The 'update' button puts the updated customer name and number in the session variables to reposition the list page to the customer updated.
            - Cancel
               - The 'cancel' button uses two session variables to reposition the list back where it was.
      - Validators - don't forget causesvalidation on buttons
   - Fixing ASP.NET checkbox and radio buttons
      - The ASP.NET checkbox and radio button controls inject a SPAN tag around the input tag. This SPAN tag
breaks Bootstrap checkbox/radiobutton rendering.

```
<div class="form-check">
    <span class="form-control" placeholder="Active">
	    <input id="content_CMActive" type="checkbox" name="ctl00$content$CMActive" checked="checked">
	</span>
    <label class="form-check-label" for="CMActive">Active</label>
</div>
```

Bootstrap wants this

```
<div class="form-check">
    <input id="content_CMActive" type="checkbox" name="ctl00$content$CMActive" checked="checked">	
    <label class="form-check-label" for="CMActive">Active</label>
</div>
```

JavaScript to the rescue

```
"use strict";

var applib = applib || {};

applib = class Core {

    static removeAspNetCheckboxWrapper(selector) {
        // ASP.NET's checkbox control puts a span tag wrapper around
        // the checkbox. This wrapper disturbs correct Bootstrap 
        // checkbox behavior. This function removes that wrapper for 
        // a given checkbox element. 

        // Select all elements that match selector.
        const wrappedElements = document.querySelectorAll(selector);

        // For each selected element... 
        wrappedElements.forEach(wrappedElement => {
            const elementToRemove = wrappedElement.parentNode;

            const elementToMove = document.createDocumentFragment();
            elementToMove.appendChild(wrappedElement);

            // ASP.NET also removed this class name. This puts it back.
            wrappedElement.classList.add('form-check-input');
            elementToRemove.parentNode.replaceChild(elementToMove, elementToRemove);
        });
    }
}
```

This JavaScript calls the `removeAspNetCheckboxWrapper` method:

```
<asp:Content ID="Content3" ContentPlaceHolderID="PageScripts" Runat="Server">
    <script>
        applib.removeAspNetCheckboxWrapper('input[type="radio"],input[type="checkbox"]');
    </script>
</asp:Content>
```

Helper classes

- CustomerCrud
   - This class does the IO for reading and updating a single customer.
   - See this [GitHub repo](https://github.com/ASNA/deprecated-avr-asp-net-example) for a more old-school example writing all of the file update logic by hand.
- CrudHelpers
   - Methods
      - GetDataRowValuesForDebugging
         - creates a string of field names and corresponding values for debugging/demoing purposes. By default uses row zero of the dt parameter but an overload also lets you specific a specific row.
      - GetDataFieldNames
         - Given a DataTable, creates a string collection of lower-case field names found in the DataTable's Columns collection. This field name list is often used to collection values from a DataRow by field name. This list is referenced as the FieldNameList in the other method docs below.
      - PopulateUIFromDataRow
         - Given an owner ASP.NET Control (a control with a Controls collection) and a DataTable, this method iterates over the the FieldNameList for the DataTable's zeroth DataRow and assigns values to that zeroth row from corresponding ASP.NET controls with the same ID as the field name.
         - Source control types can be TextBox, Label, RadioButton, CheckBox, and ListControl. Data from any other control types need to be fetched and assigned to the corresponding DataRow field manually after calling PopulateUIFromDataRow.
      - PopulateControlValue
         - Given a control parent (a control with a Controls collection), a field name, and a DataRow, find the control where its lower-case id matches the lower case field name and that field value to the control's value.
      - PopulateDataRowFromUI
         - Given an owner ASP.NET Control (a control with a Controls collection), a field name, and a DataTable, this method iterates over the the FieldNameList for the DataTable's zeroth DataRow and finds the correpsonding ASP.NET control and assigns its value to the zeroth DataRow.
      - PopulateDataRowField
         - Given a control parent (a control with a Controls collection), a field name, and a DataRow, find the control where its lower-case id matches the lower case field name and assign that control's value to the DataRow.
      - FindControlRecursive
         - Given an owner ASP.NET Control (a control with a Controls collection) and a control ID (a field name in this case) recursively search the Control's for that control. The ASP.NET controls should named 'field_' + the field name.
      - LoadListControl
- StateList
   - This class is a file-specific class that creates a ListItemCollection for binding to a listcontrol
   - Also discuss, briefly, how the ASNA.DataGateHelper may work here.