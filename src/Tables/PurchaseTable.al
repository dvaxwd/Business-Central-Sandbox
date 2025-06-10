table 50121 "PurchaseTable"
{
    Caption = 'Dave Purchase Table'; //Property: Caption
    fields
    {
        field(1; "Doc No."; Integer)
        {
            DataClassification = CustomerContent; //Property: DataClassification
            Caption = 'No.'; //Property: Caption
            ToolTip = 'Unique identifier for the purchase order.'; //Property: ToolTip
        }
        field(2; "Buy-form Vendor No"; code[20])
        {
            DataClassification = CustomerContent; //Property: DataClassification
            TableRelation = Vendor."No."; //Property: TableRelation
            Caption = 'Buy-form Vendor No.'; //Property: Caption
            trigger OnValidate()
            begin
                GetVen("Buy-form Vendor No");
            end;
        }
        field(3; "Buy-form Vendor Name"; Text[250])
        {
            Caption = 'Vendor Name'; //Property: Caption
            ToolTip = 'Name of the Vendor'; //Property: ToolTip
        }
        field(4; "Contact"; Text[100])
        {
            Caption = 'Contact'; //Property: Caption
            ToolTip = 'The contact person for the purchase order.'; //Property: ToolTip
        }
        field(5; "Document Date"; Date)
        {
            DataClassification = SystemMetadata;
            Caption = 'Document Date'; //Property: Caption
            ToolTip = 'The date when the purchase order was created.'; //Property: ToolTip
            trigger OnValidate()
            begin
                "Shipment Date" := "Document Date";
                UpdateshipmentDate("Doc No.");
            end;
        }
        field(6; "Vendor Shipment No."; Code[10])
        {
            Caption = 'Vendor Shipment No.'; //Property: Caption
            ToolTip = 'The shipment number provided by the vendor for this purchase order.'; //Property: ToolTip
        }
        field(7; "Status"; Enum "PerchaseOrderEnum")
        {
            DataClassification = ToBeClassified; //Property: DataClassification
            Caption = 'Status'; //Property: Caption
            ToolTip = 'The current status of the purchase order.'; //Property: ToolTip
        }
        field(8; "Amount Calculate"; Decimal)
        {
            DataClassification = CustomerContent; //Property: DataClassification
            Editable = false; //Property: Editable
            Caption = 'Amount Calculate'; //Property: Caption
        }
        field(9; "Amount Flowfield"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum(LineTable."Total Price" where("Doc No." = field("Doc No.")));
            Editable = false; //Property: Editable
            Caption = 'Amount Flowfield'; //Property: Caption
        }
        field(10; "Address"; Text[250])
        {
            Caption = 'Address'; //Property: Caption
            ToolTip = 'Address associated with the purchase order.'; //Property: ToolTip
        }
        field(11; "Shipment Date"; Date)
        {
            DataClassification = SystemMetadata; //Property: DataClassification
            Caption = 'Shipment Date'; //Property: Caption
            ToolTip = 'The expected shipment date for the purchase order.'; //Property: ToolTip
            trigger OnValidate()
            var
                confirm: Boolean;
            begin
                confirm := confirm('Do you want to update the shipment date in the line table?');
                if confirm then begin
                    UpdateshipmentDate("Doc No.");
                end else begin
                    "Shipment Date" := xRec."Shipment Date";
                end;
            end;
        }
        field(12; "Shipment Date Calculation"; DateFormula)
        {
            Caption = 'Shipment Date Calculation'; //Property: Caption
            trigger OnValidate()
            begin
                ShipmentDateCalculation("shipment Date Calculation", "Shipment Date");
                UpdateshipmentDate("Doc No.");
            end;
        }
    }

    keys
    {
        key(PK; "Doc No.")
        {
            Clustered = true; //Property: Clustered
        }
    }

    // triggers
    trigger OnDelete()  
        var
            line: Record LineTable; //Variable: LineTable
            comment: Record CommentTable; //Variable: CommentTable
        begin
            // Delete all lines associated with this purchase order
            line.SetRange("Doc No.", "Doc No.");
            if line.FindSet() then
                repeat
                    line.Delete();
                until line.Next() = 0;
            // Delete all comments associated with this purchase order
            comment.SetRange("Doc No.", "Doc No.");
            if comment.FindSet() then
                repeat
                    comment.Delete();
                until comment.Next() = 0;
        end;

    // variables
    var
        Vend: Record Vendor; //Variable: Vendor

    //procudure
    //function to get vendor details based on Vendor No.
    local procedure GetVen(VendorNo: Code[20])
    begin
        Vend.Get(VendorNo);
        "Buy-form Vendor Name" := Vend.Name;
        "Contact" := Vend.Contact;
        "Vendor Shipment No." := Vend."Shipping Agent Code";
        "Address" := Vend.Address;
    end;
    // function to update shipment date in line table
    local procedure UpdateshipmentDate(docNo: Integer)
    var
        line: Record "LineTable";
    begin
        line.SetRange("Doc No.", docNo);
        if line.FindSet() then
            repeat
                line."Date" := "Shipment Date";
                line.Modify(true);
            until line.Next() = 0;
    end;

    local procedure ShipmentDateCalculation(DateFormul: DateFormula; ShipmentDate: Date)
    begin
        Rec."Shipment Date" := CalcDate(DateFormul, ShipmentDate);
        Rec.Modify(true);
    end;
}