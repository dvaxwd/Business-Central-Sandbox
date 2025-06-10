page 50127 "PurchaseOrderLine"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = LineTable;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(OrderLines)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Caption = 'Line No.'; //Property: Caption
                }
                field("Item No."; Rec."Item No.")
                {
                    ApplicationArea = All;
                    TableRelation = Item."No.";
                    Caption = 'No.'; //Property: Caption
                }
                field("Item Ref No."; Rec."Item Ref No.")
                {
                    ApplicationArea = All;
                    Caption = 'Item Reference No.'; //Property: Caption
                }
                field("Description"; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                    end;
                }
                field("UOM"; Rec."UOM")
                {
                    ApplicationArea = All;
                    Caption = 'Unit of Measure Code'; //Property: Caption
                }
                field(UnitPrice; Rec."Price")
                {
                    ApplicationArea = All;
                    Caption = 'Direct Unit Cost'; //Property: Caption
                }
                field(TotalAmount; Rec."Total Price")
                {
                    ApplicationArea = All;
                    Caption = 'Line Amount Excl. VAT'; //Property: Caption
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = All;
                    Caption = 'Date'; //Property: Caption
                }
            }
        }
    }
    actions{
        area(Processing){
                action(Comments){
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = Comment;
                    ToolTip = 'View and manage comments for this purchase order line.';
                    trigger OnAction()
                        var
                            commentList: Page "CommentList";
                            commentRec: Record "CommentTable";
                        begin
                            commentRec.SetRange("Doc No.", Rec."Doc No.");
                            commentRec.SetRange("Line No.", Rec."Line No.");
                            commentList.SetTableView(commentRec);
                            commentList.RunModal();
                        end;
                
            }
        }
    }
}