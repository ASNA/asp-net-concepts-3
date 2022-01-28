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

- Controls on CustomerList.aspx
   - Disable CSS initially -- need to remove it from the discussion for a while
   - panelControl, buttonNext, buttonPositionTo, and textboxPositionTo
      - Note that the Panel control has a `controls` property. It is is a control container. We'll discuss this in more detail when we discussing creating the `CustomerList.aspx` page
   - Explain panel control and it provides a default button for its contents
   - GridView
      - Add a GridView control. Do _not_ add any property styling. We'll do all of that with CSS.
      - Add two BoundFields and two ButtonFields
         - Bound fields
            - Number: provide HeaderText (`Number`) and DataField (`Customer_CMCustNo`) and DataFormatString (`{0:00000}`)
            - Name: provide HeaderText (`Name`) and DataField (`Customer_CMName`)
         - Buttton fields
            - ActionEdit
            - ActionDelete
            - Explain the ButtonField's CommandName property
               - https://asna.com/us/articles/newsletter/2013/q3/multi-columns-click #link
            - Later we'll change the text to icons (using FontAwesome)

```
<asp:ButtonField CommandName="ActionEdit" Text="<i class='fa-solid fa-pencil'></i>" />
<asp:ButtonField CommandName="ActionDelete" Text="<i class='fa-light fa-trash-can'></i>" />
```

Add DataKeyNames (`customer_cmname,customer_cmcustno`)

- DataKeyNames are essentially hidden fields in the GridView

HTML in CustomerList.aspx markup

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

Discuss connection pooling and singleton DB pattern

- [Read about DataGate connection pooling](https://asna.com/us/tech/kb/doc/connection-pooling)
- [Read about how to find ASP.NET job leaks](https://asna.com/us/tech/kb/doc/ibm-i-orphan-jobs)
- [Singleton DB pattern in AVR](https://asna.com/us/tech/kb/doc/singleton-db-pattern)
- Rules of thumb
   - Disconnect before _every_ DB connection goes out of scope
   - Use the singleton DB pattern to pass DB connections around to secondary classes
- Also discuss the need to persist user id and password in session variables if you want the user to always connection with those credentials.

Helper classes

- CustomerByNameList
- AppStateHelpers

CodeBehind - CustomerList.aspx.vr

- Code
   - All file IO will be done in classes
   - Show `WindowsAppToShowDataList` Windows app
- Class: CustomerByNameList
   - MemoryFile
   - Properties
   - Constructor
   - Methods: Open, Close, ReadPage, ReadNextPage, PositionPageTo
   - Show Windows app using this class

Enable CSS and icons

- layout.css
   - Minimal page layout
   - Zebra stripe a table
   - Give Bootstrap form-controls a great background
- FontAwesome
   - https://fontawesome.com/

Creating the CustomerForm.aspx

- Discuss [System.Web.UI.Page.Controls](https://docs.microsoft.com/en-us/dotnet/api/system.web.ui.control.controls?view=netframework-4.7.1#system-web-ui-control-controls) property
   - There are several controls that are containers that also have a `Controls` property.
   - Best way to find a control is to recursively iterate a `controls` property looking for the desired control by Id. See `FindControlRecursive` in the `CrudHelpers` class.

### CUSTOMER FORM

Creating the CustomerForm.aspx page

- Validators - don't forget causesvalidation on buttons
- Helper classes
   - CrudHelpers
   - CustomerCrud
   - StateList
      - This class is a file-specific class that creates a ListItemCollection for binding to a listcontrol.

Fixing ASP.NET checkbox and radio buttons

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