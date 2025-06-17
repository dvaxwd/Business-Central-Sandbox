/// <summary>
/// Page PurchaseList_Dave (ID 50120).
/// </summary>
page 50120 "PurchaseList_Dave"
{
    PageType = List;
    Caption = 'Dave Purchase List';
    UsageCategory = Lists; //Property: UsageCategory
    ApplicationArea = All;
    SourceTable = "PurchaseTable";
    CardPageId = "PurchaseCard"; //Property: CardPageId
    Editable = false; //Property: Editable
    AutoSplitKey = true; //Property: AutoSplitKey
    
    layout{
        area(Content){
            repeater(PurchaseList){
                field("No."; Rec."Doc No.")
                {
                    ApplicationArea = All;
                }
                field("Buy-form Vendor No"; Rec."Buy-form Vendor No")
                {
                    ApplicationArea = All;
                }
                field("Buy-form Vendor Name"; Rec."Buy-form Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Contact"; Rec."Contact")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field("Vendor Shipment No."; Rec."Vendor Shipment No.")
                {
                    ApplicationArea = All;
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                }
                field("Total Amount Flowfield"; Rec."Amount Flowfield"){
                    ApplicationArea = All;
                    Caption = 'Totoal F'; //Property: Caption
                    ToolTip = 'Total amount for the purchase order.'; //Property: ToolTip
                }
                field("Total Amount Calculate"; Rec."Amount Calculate")
                {
                    ApplicationArea = All;
                    Caption = 'Total Amount Cal'; //Property: Caption
                    ToolTip = 'Total amount calculated for the purchase order.'; //Property: ToolTip
                }
            }
        }
    }
    actions{
        area(Processing){
            action(Sumary){
                Caption = 'Sumary Report';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                trigger OnAction()
                    var
                        SumaryReport: Report SumaryReport;
                    begin
                        SumaryReport.RunModal();
                    end;
            }
        }
    }
}