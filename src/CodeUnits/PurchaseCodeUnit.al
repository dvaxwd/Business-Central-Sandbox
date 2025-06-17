codeunit 50134 PurchaseCodeUnit
{
    TableNo = LineTable;

    var
        // ***** Record *****
        PurchHeader: Record PurchaseTable;
        PurchLineTarget: Record LineTable;
        FromBOMComp: Record "BOM Component";
        Item: Record Item;
        // ***** Integer *****
        NoOfBOMComp: Integer;
        NextLineNo: Integer;
        Selection: Integer;
        LineSpacing: Integer;
        // ***** Message *****
        Text001: Label 'Item %1 is not a BOM.';
        Text003: Label 'There is not enough space to explode the BOM.';
        Text005: Label '&Copy dimensions from BOM,&Retrieve dimensions from components';

    trigger OnRun()
    begin
        FromBOMComp.SetRange("Parent Item No.", Rec."Item No."); //setRange to fine ItemNo in table "bom component"
        NoOfBOMComp := FromBOMComp.Count(); //count amount of component
        if NoOfBOMComp = 0 then
            Error(Text001, Rec."Item No.");
        Selection := GetSelection(Rec);
        if Selection = 0 then
            exit;
        InitParentItemLine(Rec);
        Rec.Delete();
        ExplodeBOMCompLines(Rec);
    end;

    // Procedure
    local procedure GetSelection(PurchLine: Record LineTable) Result: Integer
    begin
        Result := StrMenu(Text005, 2);
    end;

    local procedure InitParentItemLine(FormPurchLine: Record LineTable)
    begin
        PurchLineTarget := FormPurchLine;
        PurchLineTarget.Init();
        PurchLineTarget.Description := FormPurchLine.Description;
    end;

    local procedure ExplodeBOMCompLines(PurchLine: Record LineTable)
    var
        InsertLineBetween: Boolean;
        SkipComponent: Boolean;
    begin
        PurchLineTarget.Reset();
        PurchLineTarget.SetRange("Doc No.", PurchLine."Doc No.");
        NextLineNo := PurchLine."Line No.";
        InsertLineBetween := false;
        PurchLineTarget.SetFilter("Line No.", '>%1', PurchLine."Line No.");
        if PurchLineTarget.FindLast() then begin
            InsertLineBetween := true;
        end;
        if InsertLineBetween then
            LineSpacing := (PurchLineTarget."Line No." - NextLineNo) div (1 + NoOfBOMComp)
        else
            LineSpacing := 10000;
        if LineSpacing = 0 then Error(Text003);

        FromBOMComp.Find('-');
        repeat
            case FromBOMComp.Type of
                FromBOMComp.Type::Item:
                    begin
                        PurchLineTarget.Init();
                        PurchLineTarget."Doc No." := PurchLine."Doc No.";
                        NextLineNo := NextLineNo + LineSpacing;
                        PurchLineTarget."Line No." := NextLineNo;
                        Item.Get(FromBOMComp."No.");
                        PurchLineTarget.Type := PurchLineTarget.Type::Item;
                        PurchLineTarget.Validate("Item No.", FromBOMComp."No.");
                        PurchLineTarget.Validate("UOM", FromBOMComp."Unit of Measure Code");
                        PurchLineTarget.Quantity := FromBOMComp."Quantity per" * PurchLine.Quantity;
                        PurchLineTarget."Total Price" := PurchLineTarget.Quantity * PurchLineTarget.Price;
                        PurchLineTarget.Insert();
                    end;
            end;
        until FromBOMComp.Next() = 0;
    end;
}
