table 50124 "LineTable"{
    Caption = 'Dave LineTable';
    fields{
        field(1; "Doc No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Document No.';
            ToolTip = 'Unique identifier for the document associated with this line.';
            TableRelation = PurchaseTable."Doc No.";
        }
        field(2; "Line No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Line No.';
        }
        field(3; "Type"; Enum "Purchase Line Type")
        {
            Caption = 'Type';
        }
        field(4; "Item No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Item No.';
            ToolTip = 'Reference number for the item associated with this line.';
            TableRelation = Item."No.";
            trigger OnValidate()
            begin
                GetItem("Item No.");
            end;
        }
        field(5; "Item Ref No."; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Item Reference No.';
            ToolTip = 'Reference number for the item, if different from the Item No.';
        }
        field(6; "Description"; Text[250])
        {
            Caption = 'Description';
            ToolTip = 'Description of the line item.';
        }
        field(7; "Quantity"; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
            ToolTip = 'Quantity of the item in the line.';
            trigger OnValidate()
            begin
                GetTotalPrice();
            end;
        }
        field(8; "UOM"; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Unit of Measure Code';
            ToolTip = 'Code for the unit of measure of the item.';
        }
        field(9; "Price"; Decimal)
        {
            Caption = 'Direct Unit Cost Excl. VAT';
            ToolTip = 'Price per unit of the item.';
            trigger OnValidate()
            begin
                GetTotalPrice();
            end;
        }
        field(10; "Total Price"; Decimal)
        {
            DataClassification = CustomerContent;
            Caption = 'Line Amount Excl. VAT';
            ToolTip = 'Total amount for the line item.';
            Editable = false;
        }
        field(11; "Date"; Date)
        {
            DataClassification = SystemMetadata;
            Caption = 'Expect Receipt Date';
            ToolTip = 'The date when the line item was created.';
        }
    }

    // Keys of LineTable
    keys
    {
        key(PK; "Doc No.", "Line No.")
        {
            Clustered = true;
        }
        key("Key 1"; "Item No.") { }
    }

    // Triggers of LineTable
    trigger OnInsert()
        begin
            GetTotalPrice();
        end;
    trigger OnDelete()
        var
            comment: Record CommentTable;
            PurchaseOrder: Record PurchaseTable;
        begin
            // ***** Delete comments associated with this line item *****
            comment.SetRange("Doc No.", Rec."Doc No.");
            comment.SetRange("Line No.", Rec."Line No.");
            if comment.FindSet() then
                repeat
                    comment.Delete();
                until comment.Next() = 0;
        end;

    // Varriables
    var
        Item: Record Item;

    // Procudures of LineTable
    // Fuction to select multiple items
    procedure SelectMultipleItems()
        var
            ItemList: Page "ItemList";
            SelectionFilter: Text;
        begin
            // ***** Go to ItemList and select multi Items *****
            SelectionFilter := ItemList.SelectActiveItemsForPurchase();
            if SelectionFilter <> '' then
                addItems(SelectionFilter);
        end;
    // Function to add items based on selection filter
    procedure addItems(selectionFilter: Text)
        var
            Item: Record Item;
            PurchaseLine: Record "LineTable";
            IsHandled: Boolean;
        begin
            InitNewLine(PurchaseLine);
            Item.SetFilter("No.", SelectionFilter);
            addItem(selectionFilter);
        end;
    // Function to initialize a new line
    procedure InitNewLine(var NewPurchLine: Record "LineTable")
        var
            PurchaseLine: Record "LineTable";
        begin
            NewPurchLine.Copy(Rec);
            PurchaseLine.SetRange("Doc No.", NewPurchLine."Doc No.");
            if PurchaseLine.FindLast() then
                NewPurchLine."Line No." := PurchaseLine."Line No."
            else
                NewPurchLine."Line No." := 0;
        end;
    // Function to add Item into LineTable
    procedure AddItem(SelectionFilter: Text)
        var
            Item: Record Item;
            NewLine: Record "LineTable";
            LineNo: Integer;
        begin
            // ***** Filter item by item no. base on SelectionFilter *****
            Item.SetFilter("No.", SelectionFilter);
            // ****** Repeat init data into LineTable *****
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
                    NewLine.Validate("Item No.", Item."No.");
                    NewLine.Insert();
                until Item.Next() = 0;
            end;
        end; 
    // Function to get item details based on Item No.
    local procedure GetItem(ItemNo: Code[20])
        begin
            Item.Get(ItemNo);
            "Item Ref No." := Item."No. 2";
            "Description" := Item.Description;
            "UOM" := Item."Base Unit of Measure";
            "Price" := Item."Unit Cost";
        end;
    // Function to calculate total price based on Quantity and Price
    local procedure GetTotalPrice()
        begin
            "Total Price" := Quantity * Price;
        end;
}