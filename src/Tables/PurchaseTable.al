table 50121 "PurchaseTable"{
    Caption = 'Dave Purchase Table';
    fields
    {
        field(1; "Doc No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'No.';
            ToolTip = 'Unique identifier for the purchase order.';
        }
        field(2; "Buy-form Vendor No"; code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Vendor."No.";
            Caption = 'Buy-form Vendor No.';
            trigger OnValidate()
            begin
                GetVen("Buy-form Vendor No");
            end;
        }
        field(3; "Buy-form Vendor Name"; Text[250])
        {
            Caption = 'Vendor Name';
            ToolTip = 'Name of the Vendor';
        }
        field(4; "Contact"; Text[100])
        {
            Caption = 'Contact';
            ToolTip = 'The contact person for the purchase order.';
        }
        field(5; "Document Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Document Date';
            ToolTip = 'The date when the purchase order was created.';
            trigger OnValidate()
            begin
                "Shipment Date" := "Document Date";
                UpdateshipmentDate("Doc No.");
            end;
        }
        field(6; "Vendor Shipment No."; Code[10])
        {
            Caption = 'Vendor Shipment No.';
            ToolTip = 'The shipment number provided by the vendor for this purchase order.';
        }
        field(7; "Status"; Enum "PurchaseOrderEnum")
        {
            DataClassification = CustomerContent;
            Caption = 'Status';
            ToolTip = 'The current status of the purchase order.';
        }
        field(8; "Amount Calculate"; Decimal)
        {
            DataClassification = CustomerContent;
            Editable = false;
            Caption = 'Amount Calculate';
        }
        field(9; "Amount Flowfield"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = sum(LineTable."Total Price" where("Doc No." = field("Doc No.")));
            Editable = false;
            Caption = 'Amount Flowfield';
        }
        field(10; "Address"; Text[250])
        {
            Caption = 'Address';
            ToolTip = 'Address associated with the purchase order.';
        }
        field(11; "Address 2"; Text[250])
        {
            Caption = 'Address 2';
        }
        field(12; "Shipment Date"; Date)
        {
            DataClassification = CustomerContent;
            Caption = 'Shipment Date';
            ToolTip = 'The expected shipment date for the purchase order.';
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
        field(13; "Shipment Date Calculation"; DateFormula)
        {
            Caption = 'Shipment Date Calculation';
            trigger OnValidate()
            begin
                ShipmentDateCalculation("shipment Date Calculation", "Shipment Date");
                UpdateshipmentDate("Doc No.");
            end;
        }
        field(14; "Vat Registration No."; Code[20])
        {
            Caption = 'Vat Registration No.';
            FieldClass = FlowField;
            CalcFormula = Lookup(Vendor."VAT Registration No." where("No." = field("Buy-form Vendor No")));
        }
    }

    // Key of PurchaseTable
    keys
    {
        key(PK; "Doc No.")
        {
            Clustered = true;
        }
    }

    // Trigger of PurchaseTable
    trigger OnDelete()
    var
        line: Record LineTable;
        comment: Record CommentTable;
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

    // Variables
    var
        Vend: Record Vendor;

    // Procudure of PurchaseTable
    // Function to get vendor details based on Vendor No.
    local procedure GetVen(VendorNo: Code[20])
    begin
        Vend.Get(VendorNo);
        "Buy-form Vendor Name" := Vend.Name;
        "Contact" := Vend.Contact;
        "Vendor Shipment No." := Vend."Shipping Agent Code";
        "Address" := Vend.Address;
        "Address 2" := Vend."Address 2";
    end;
    // Function to update shipment date in line table
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
    // Function to update total in Header
    procedure UpdateTotalHeader(DocNo: Integer)
    var
        TotalAmount: Decimal;
        Line: Record LineTable;
    begin
        if DocNo = 0 then exit;
        TotalAmount := 0;
        Line.SetRange("Doc No.", DocNo);
        if Line.FindSet() then
            repeat
                TotalAmount += Line."Total Price";
            until Line.Next() = 0;
        if Rec."Amount Calculate" <> TotalAmount then
            Rec."Amount Calculate" := TotalAmount;
            Rec.Modify();
    end;
    // Funtion to calculate document date to shipment date
    local procedure ShipmentDateCalculation(DateFormul: DateFormula; ShipmentDate: Date)
    begin
        Rec."Shipment Date" := CalcDate(DateFormul, ShipmentDate);
        Rec.Modify(true);
    end;
}