page 50127 "PurchaseOrderLine"{
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = LineTable;
    AutoSplitKey = true;

    layout
    {
        area(Content)
        {
            repeater(OrderLines)
            {
                field(Type; Rec.Type)
                {
                    Caption = 'Type';
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
    actions
    {
        area(Processing)
        {
            action(seletItem)
            {
                Caption = 'Select Item';
                ToolTip = 'Select an item for this purchase order line.';
                Image = NewItem;
                trigger OnAction()
                begin
                    Rec.SelectMultipleItems();
                end;
            }
            group(Line)
            {
                Caption = 'Line';
                action(Comments)
                {
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
            group(Function)
            {
                Caption = 'Function';
                Image = "Action";
                action(ExpBOM)
                {
                    Caption = 'Explode BOM';
                    Image = ExplodeBOM;
                    ToolTip = 'Add a line for each component on the bill of materials for the selected item. For example, this is useful for selling the parent item as a kit. CAUTION: The line for the parent item will be deleted and only its description will display. To undo this action, delete the component lines and add a line for the parent item again. This action is available only for lines that contain an item.';
                    trigger OnAction()
                    begin
                        ExplodeBOM();
                        CurrPage.Update(true);
                    end;
                }
            }
            group(Order){
                Caption = 'Order';
            }
        }
    }
    var
        DocumentTotals: Codeunit "Document Totals";
    // Procedure
    local procedure ExplodeBOM()
    begin
        CODEUNIT.Run(CODEUNIT::"PurchaseCodeUnit", Rec);
    end;
}