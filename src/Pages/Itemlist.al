page 50130 ItemList
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = Item;
    Caption = 'Item List';
    Editable = false; // Property: Editable
    
    layout
    {
        area(Content)
        {
            repeater(itemList)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the item.';
                }
                field(Name; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Name of the item.';
                }
                field("Tyepe"; Rec.Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Type of the item.';
                }
                field("Inventory"; Rec."Inventory")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates if the item is in inventory.';
                }
                field("Substitute"; Rec."Substitutes Exist")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates if the item is a substitute.';
                }field("Assembly BOM"; Rec."Assembly BOM")
                {
                    ApplicationArea = All;
                    ToolTip = 'Indicates if the item is an assembly BOM.';
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = All;
                    ToolTip = 'Base unit of measure for the item.';
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                    ToolTip = 'Cost of the item per unit.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Selling price of the item per unit.';
                }field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Vendor number associated with the item.';
                }
                
            }
        }
    }
    //

    procedure SelectActiveItems(): Text
    var
        Item: Record Item;
    begin
        exit(SelectInItemList(Item));
    end;
    // Property: SelectActiveItems
    // This procedure allows the user to select an item from the Item List page.
    procedure SelectInItemList(var Item: Record Item): Text
    var
        ItemListPage: Page "Item List";
    begin
        Item.SetRange(Blocked, false);
        ItemListPage.SetTableView(Item);
        ItemListPage.LookupMode(true);
        if ItemListPage.RunModal() = ACTION::LookupOK then
            exit(ItemListPage.GetSelectionFilter());
    end;
    procedure SelectActiveItemsForPurchase(): Text
    var
        Item: Record Item;
    begin
        Item.SetRange("Purchasing Blocked", false);
        exit(SelectInItemList(Item));
    end;
}