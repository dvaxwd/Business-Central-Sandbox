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
            ToolTip = 'Unique identifier for the line item.'; //Property: ToolTip
            AutoIncrement = true; //Property: AutoIncrement
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

    //Varriables
    var
        Item: Record Item; //Variable: Item

    //Procudures
    // function to get item details based on Item No.
    local procedure GetItem(ItemNo: Code[20])
    begin
        Item.Get(ItemNo);
        "Item Ref No." := Item."No. 2";
        "Description" := Item.Description;
        "UOM" := Item."Base Unit of Measure";
        "Price" := Item."Unit Cost";
        GetTotalPrice();
    end;
    // function to calculate total price based on Quantity and Price
    local procedure GetTotalPrice()
    begin
        "Total Price" := Quantity * Price;
        Modify(); //modify the current record
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
}