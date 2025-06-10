page 50122 "PurchaseCard"{
    PageType = Card;
    SourceTable = "PurchaseTable";
    UsageCategory = Tasks; //Property: UsageCategory
    Caption = 'Purchase Card';
    
    layout{
        area(Content){
            group(PurchaseDetails){
                field("Doc No."; Rec."Doc No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.'; //Property: Caption
                    ToolTip = 'Unique identifier for the purchase order.'; //Property: ToolTip
                }
                field("Buy-form Vendor No"; Rec."Buy-form Vendor No")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor No.'; //Property: Caption
                }
                field("Buy-form Vendor Name"; Rec."Buy-form Vendor Name")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Name'; //Property: Caption
                }
                field("Contract"; Rec."Contact")
                {
                    ApplicationArea = All;
                    Caption = 'Contact'; //Property: Caption
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'Date';//Property: Caption
                }
                field("Address"; Rec."Address")
                {
                    ApplicationArea = All;
                    Caption = 'Address'; //Property: Caption
                }
                field("Vendor Shipment No."; Rec."Vendor Shipment No.")
                {
                    ApplicationArea = All;
                }
                field("Amoount Cal"; Rec."Amount Calculate"){
                    ApplicationArea = All;
                    Caption = 'Amount Calculate'; //Property: Caption
                }
                field("Amount Flowfield"; Rec."Amount Flowfield")
                {
                    ApplicationArea = All;
                    Caption = 'Amount Flowfield'; //Property: Caption
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                }
                field("Shipment Date"; Rec."Shipment Date")
                {
                    ApplicationArea = All;
                    Caption = 'Shipment Date'; //Property: Caption
                }
                field("shipment date calculate"; Rec."Shipment Date Calculation")
                {
                    ApplicationArea = All;
                    Caption = 'Shipment Date Calculate'; //Property: Caption
                }

            }
            part(Line; "PurchaseOrderLine"){
                    ApplicationArea = All;
                    Caption = 'Purchase Order Lines';
                    SubPageLink = "Doc No." = field("Doc No.");
            }
        }
    }
}