/// <summary>
/// Page PurchaseCard (ID 50122).
/// </summary>
page 50122 "PurchaseCard"
{
    PageType = Card;
    SourceTable = "PurchaseTable";
    UsageCategory = Tasks; //Property: UsageCategory
    Caption = 'Purchase Card';
    AutoSplitKey = true; //Property: AutoSplitKey

    layout
    {
        area(Content)
        {
            group(PurchaseDetails)
            {
                Caption = 'General';
                field("Doc No."; Rec."Doc No.")
                {
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
                group("Buy-from")
                {
                    Caption = 'Buy-from';
                    field("Address"; Rec."Address")
                    {
                        ApplicationArea = All;
                        Caption = 'Address'; //Property: Caption
                    }
                    field("Address 2"; Rec."Address 2")
                    {
                        ApplicationArea = All;
                        Caption = 'Address 2';
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
                    field("Vendor Shipment No."; Rec."Vendor Shipment No.")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Amoount Cal"; Rec."Amount Calculate")
                {
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
            part(Line; "PurchaseOrderLine")
            {
                ApplicationArea = All;
                Caption = 'Purchase Order Lines';
                SubPageLink = "Doc No." = field("Doc No.");
            }
        }

    }
    actions
    {
        area(Processing)
        {
            group(Print)
            {
                Caption = 'Print/Send';
                Image = Print;
                action(PrintDefault)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Order';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        PurchaseRec: Record PurchaseTable;
                        PurchaseReport: Report PurchaseReport;
                    begin
                        PurchaseRec.SetRange("Doc No.", Rec."Doc No.");
                        PurchaseReport.SetTableView(PurchaseRec);//send Rec to dataItem PurchaseReport
                        PurchaseReport.RunModal();
                    end;
                }
                action(PrintGroup)
                {
                    ApplicationArea = All;
                    Caption = 'Purchase Order - Group Items';
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        PurchaseRec: Record PurchaseTable;
                        GroupItemReport: Report GroupItemReport;
                    begin
                        PurchaseRec.SetRange("Doc No.", Rec."Doc No.");
                        GroupItemReport.SetTableView(PurchaseRec);
                        GroupItemReport.RunModal();
                    end;

                }
            }
        }
    }
    trigger OnAfterGetCurrRecord()
        begin
            Rec.UpdateTotalHeader(Rec."Doc No.");
            CurrPage.Update(true);
        end;
}