table 50124 "LineTable"
{
    fields
    {
        field(1; "Doc No."; Integer)
        {
            DataClassification = CustomerContent; //Property: DataClassification
            Caption = 'Document No.'; //Property: Caption
            ToolTip = 'Unique identifier for the document associated with this line.'; //Property: ToolTip
            TableRelation = PurchaseTable."Doc No.";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent; //Property: DataClassification
            Caption = 'Line No.'; //Property: Caption
        }
        field(3; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified; //Property: DataClassification
            Caption = 'Item No.'; //Property: Caption
            ToolTip = 'Reference number for the item associated with this line.'; //Property: ToolTip
            TableRelation = Item."No.";
            trigger OnValidate()
            begin
                GetItem("Item No.");
            end;
        }
        field(4; "Item Ref No."; Code[20])
        {
            DataClassification = CustomerContent; //Property: DataClassification
            Caption = 'Item Reference No.'; //Property: Caption
            ToolTip = 'Reference number for the item, if different from the Item No.'; //Property: ToolTip
        }
        field(5; "Description"; Text[250])
        {
            Caption = 'Description'; //Property: Caption
            ToolTip = 'Description of the line item.'; //Property: ToolTip
        }
        field(6; "Quantity"; Integer)
        {
            DataClassification = CustomerContent; //Property: DataClassification
            Caption = 'Quantity'; //Property: Caption
            ToolTip = 'Quantity of the item in the line.'; //Property: ToolTip
            trigger OnValidate()
            begin
                GetTotalPrice();
            end;
        }
        field(7; "UOM"; Code[10])
        {
            DataClassification = CustomerContent; //Property: DataClassification
            Caption = 'Unit of Measure Code'; //Property: Caption
            ToolTip = 'Code for the unit of measure of the item.'; //Property: ToolTip
        }
        field(8; "Price"; Decimal)
        {
            Caption = 'Direct Unit Cost Excl. VAT'; //Property: Caption
            ToolTip = 'Price per unit of the item.'; //Property: ToolTip
        }
        field(9; "Total Price"; Decimal)
        {
            DataClassification = CustomerContent; //Property: DataClassification
            Caption = 'Line Amount Excl. VAT'; //Property: Caption
            ToolTip = 'Total amount for the line item.'; //Property: ToolTip
            Editable = false; //Property: Editable
        }
        field(10; "Date"; Date)
        {
            DataClassification = SystemMetadata; //Property: DataClassification
            Caption = 'Expect Reciept Date'; //Property: Caption
            ToolTip = 'The date when the line item was created.'; //Property: ToolTip
        }
    }

    //Keys and Indexes
    keys
    {
        key(PK; "Doc No.", "Line No.")
        {
            Clustered = true; //Property: Clustered
        }
    }

    //Triggers
    trigger OnDelete()
    var
        comment: Record CommentTable; //Variable: CommentTable
        PurchaseOrder: Record PurchaseTable; //Variable: PurchaseTable
    begin
        // Delete comments associated with this line item
        comment.SetRange("Doc No.", Rec."Doc No.");
        comment.SetRange("Line No.", Rec."Line No.");
        if comment.FindSet() then
            repeat
                comment.Delete();
            until comment.Next() = 0;
        // Update the total amount in the purchase order header
        PurchaseOrder.SetRange("Doc No.", Rec."Doc No.");
        if PurchaseOrder.FindFirst() then begin
            PurchaseOrder.Validate("Amount Calculate", PurchaseOrder."Amount Calculate" - Rec."Total Price");
            PurchaseOrder.Modify(true);
        end;
    end;

    //Varriables
    var
        Item: Record Item; //Variable: Item

    //Procudures
    // fuction to select multiple items
    procedure SelectMultipleItems()
    var
        ItemList: Page "ItemList"; //Variable: ItemList
        isHandled: Boolean; //Variable: Boolean
        SelectionFilter: Text;
    begin
        isHandled := false;
        //OnBeforeSelectMultipleItems(Rec,isHandled);
        //if IsHandled then
        //    exit;
        SelectionFilter := ItemList.SelectActiveItemsForPurchase();
        addItems(SelectionFilter);
    end;
    // function to add items based on selection filter
    procedure addItems(selectionFilter: Text)
    var
        Item: Record Item; //Variable: Item
        PurchaseLine: Record "LineTable"; //Variable: LineTable
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSelectMultipleItems(PurchaseLine, IsHandled);
        if IsHandled then
            exit;
        InitNewLine(PurchaseLine);
        Item.SetFilter("No.", SelectionFilter);
        if Item.FindSet() then
            repeat
                addItem(selectionFilter);
            until Item.Next() = 0;
    end;
    // function to initialize a new line
    procedure InitNewLine(var NewPurchLine: Record "LineTable")
    var
        PurchaseLine: Record "LineTable"; //Variable: LineTable
    begin
        NewPurchLine.Copy(Rec);
        PurchaseLine.SetRange("Doc No.", NewPurchLine."Doc No.");
        if PurchaseLine.FindLast() then
            NewPurchLine."Line No." := PurchaseLine."Line No." //if last line exists, set Line No. to last Line No.
        else
            NewPurchLine."Line No." := 0; // if no lines exist, set Line No. to 0
    end;

    procedure AddItem(SelectionFilter: Text)
    var
        Item: Record Item;
        NewLine: Record "LineTable";
        LineNo: Integer;
    begin
        Item.SetFilter("No.", SelectionFilter);
        if Item.FindSet() then begin
            repeat
                NewLine.Reset();
                NewLine.SetRange("Doc No.", "Doc No.");
                if NewLine.FindLast() then
                    LineNo := NewLine."Line No." + 10000
                else
                    LineNo := 10000;
                NewLine.Init();
                NewLine.Validate("Doc No.", "Doc No.");
                NewLine.Validate("Line No.", LineNo);
                NewLine.Validate("Item No.",Item."No.");
                NewLine.Insert();
            until Item.Next() = 0;
        end;
    end;

    // 
    // function to get item details based on Item No.
    local procedure GetItem(ItemNo: Code[20])
    begin
        Item.Get(ItemNo);
        "Item Ref No." := Item."No. 2";
        "Description" := Item.Description;
        "UOM" := Item."Base Unit of Measure";
        "Price" := Item."Unit Cost";
        //GetTotalPrice();
    end;
    // function to calculate total price based on Quantity and Price
    local procedure GetTotalPrice()
    begin
        "Total Price" := Quantity * Price;
        //Modify(); //modify the current record
        // Call the procedure to update the total amount in the header
        UpdateTotalHeader(Rec."Doc No.");
    end;

    local procedure UpdateTotalHeader(DocNo: Integer)
    var
        TotalAmount: Decimal;
        PurchaseOrder: Record PurchaseTable;
        SalesLine: Record LineTable;
    begin
        TotalAmount := 0;
        // Calculate the total amount for the purchase order
        SalesLine.SetRange("Doc No.", Rec."Doc No.");
        if SalesLine.FindSet() then
            repeat
                TotalAmount += SalesLine."Total Price";
            until SalesLine.Next() = 0;
        // Update the total amount in the purchase order header
        PurchaseOrder.SetRange("Doc No.", Rec."Doc No.");
        if PurchaseOrder.FindFirst() then begin
            PurchaseOrder.Validate("Amount Calculate", TotalAmount);
            PurchaseOrder.Modify(true);
        end;
    end;

    // Event to handle before selecting multiple items
    [IntegrationEvent(false, false)]
    local procedure OnBeforeSelectMultipleItems(var PurchaseLine: Record "LineTable"; var IsHandled: Boolean)
    begin
    end;
    // Event to handle before adding an item
    [IntegrationEvent(false, false)]
    local procedure OnAddItemOnBeforeInsert(var PurchaseLine: Record "LineTable")
    begin
    end;
}