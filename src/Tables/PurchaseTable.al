table 50121 "PurchaseTable"
{
    Caption = 'Dave Purchase Table'; //Property: Caption
    fields{
        field(1; "Doc No."; Code[20])
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
        field(5; "Date"; Date)
        {
            DataClassification = SystemMetadata;
            Caption = 'Document Date'; //Property: Caption
            ToolTip = 'The date when the purchase order was created.'; //Property: ToolTip
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
        field(8; "Amount Calculate"; Decimal){
            DataClassification = CustomerContent; //Property: DataClassification
            Editable = false; //Property: Editable
            Caption = 'Amount Calculate'; //Property: Caption
        }
        field(9; "Amount Flowfield"; Decimal){
            FieldClass = FlowField;
            CalcFormula = sum(LineTable."Total Price" where("Doc No." = field("Doc No.")));
            Editable = false; //Property: Editable
            Caption = 'Amount Flowfield'; //Property: Caption
        }
        field(10; "Address"; Text[250])
        {
            Caption = 'Address'; //Property: Caption
            ToolTip = 'Address associated with the purchase order.'; //Property: ToolTip
        }field(11; "Shipment Date"; Date)
        {
            DataClassification = SystemMetadata; //Property: DataClassification
            Caption = 'Shipment Date'; //Property: Caption
            ToolTip = 'The expected shipment date for the purchase order.'; //Property: ToolTip
            trigger OnValidate()
                begin
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
    
    local procedure UpdateshipmentDate(docNo: Code[20])
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
}