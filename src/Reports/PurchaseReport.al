/// <summary>
/// Report PurchaseReport (ID 50131).
/// </summary>
report 50131 "PurchaseReport"
{
    Caption = 'Purchase Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './src/Reports/Layouts/PurchaseReport.rdl';
    // Dataset
    dataset
    {
        dataitem(LoopCopy; Integer)
        {
            DataItemTableView = where(Number = filter(1 ..));
            column(Number; Number) { }
            column("OrginalText"; PrintCopyText) { }
            dataitem(PurchaseTable; "PurchaseTable")
            {
                RequestFilterHeading = 'Report - Purchase Order';
                RequestFilterFields = "Doc No.", "Buy-form Vendor No";
                PrintOnlyIfDetail = true;
                column("DocNo"; "PurchaseTable"."Doc No.") { }
                column("VendorNo"; "PurchaseTable"."Buy-form Vendor No") { }
                column("VendorName"; "PurchaseTable"."Buy-form Vendor Name") { }
                column("Contact"; "PurchaseTable"."Contact") { }
                column("DocDate"; "PurchaseTable"."Document Date") { }
                column("Address"; "PurchaseTable".Address) { }
                column("Status"; "PurchaseTable"."Status") { }
                column("Amount"; "PurchaseTable"."Amount Calculate") { }
                column("VatRegistrationNo"; "Vat Registration No.") { }
                // ***** Column for VAT Cluster *****
                column("VatNOCluster1"; vatRegNoArray[1]) { }
                column("VatNoCluster2"; vatRegNoArray[2]) { }
                column("VatNoCluster3"; vatRegNoArray[3]) { }
                column("VatNoCluster4"; vatRegNoArray[4]) { }
                column("VatNoCluster5"; vatRegNoArray[5]) { }
                column("VatNOCluster6"; vatRegNoArray[6]) { }
                column("VatNoCluster7"; vatRegNoArray[7]) { }
                column("VatNoCluster8"; vatRegNoArray[8]) { }
                column("VatNoCluster9"; vatRegNoArray[9]) { }
                column("VatNoCluster10"; vatRegNoArray[10]) { }
                column("VatNoCluster11"; vatRegNoArray[11]) { }
                column("VatNoCluster12"; vatRegNoArray[12]) { }
                column("VatNoCluster13"; vatRegNoArray[13]) { }

                column("Address2"; Address2) { }
                // ***** Relate Data on LineTable *****
                dataitem(LineTable; "LineTable")
                {
                    DataItemLink = "Doc No." = field("Doc No.");
                    column("ItemNo"; "LineTable"."Item No.") { }
                    column("Description"; "LineTable".Description) { }
                    column("Quantity"; "LineTable".Quantity) { }
                    column("UOM"; "LineTable".UOM) { }
                    column("Price"; "LineTable".Price) { }
                    column("TotalPrice"; "LineTable"."Total Price") { }
                    // Trigger for LineTable
                    trigger OnPreDataItem()
                    begin
                        CurrLine := 0;
                        MaxLinePerPage := 12;
                    end;

                    trigger OnAfterGetRecord()
                    begin
                        CurrLine += 1;
                    end;

                    trigger OnPostDataItem()
                    begin
                        BlankLineNeed := MaxLinePerPage - CurrLine;
                        if BlankLineNeed <= 0 then
                            BlankLineNeed := 0;
                    end;
                }
                dataitem(BlankLine; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                    column(Blankfleld; '') { }
                    // Trigger for BlankLine
                    trigger OnPreDataItem()
                    begin
                        SETFILTER(Number, '1..' + FORMAT(BlankLineNeed));
                    end;
                }
                // Trigger for PurchaseTable
                trigger OnAfterGetRecord()
                begin
                    PurchaseTable.CalcFields("Vat Registration No.");
                    vatRegNo := PurchaseTable."Vat Registration No.";
                    SpiltVatRegNo(PurchaseTable."Vat Registration No.");
                end;
            }
            // Trigger for LoopCopy
            trigger OnAfterGetRecord()
            begin
                if Number = 1 then begin
                    PrintCopyText := 'ต้นฉบับ';
                end else begin
                    PrintCopyText := 'สำเนา';
                end;
                // ***** Break loop *****
                if Number = NumberOfCopies + 1 then begin
                    CurrReport.Break();
                end;
            end;
        }
    }
    // Requestpage
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(PrintOption)
                {
                    Caption = 'Print & Copy';
                    field(NumberOfCopies; NumberOfCopies)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Number of Copies';
                        MinValue = 1;
                    }
                }
            }
        }
        // Trigger of Requestpage
        trigger OnOpenPage()
        begin
            NumberOfCopies := 1;
        end;
    }
    // Variable of report
    var
        // ***** Var for Vendor Detail *****
        Address2: Text;
        PaymentTerm: code[10];

        // ***** Var for VAT Registration No. And Split ******
        vatRegNo: Text[20];
        vatRegNoArray: array[20] of Text;

        // ***** Var for Copies *****
        NumberOfCopies: Integer;
        PrintCopyText: Text;

        // ***** Var for line *****
        MaxLinePerPage: Integer;
        BlankLineNeed: Integer;
        CurrLine: Integer;
    //Procedure
    // function to Spilt Vat Registrtion No.
    local procedure SpiltVatRegNo(vatRegNo: Text): Text
    var
        tempStr: Text;
        vatRegNoLenght: Integer;
        i: Integer;
    begin
        tempStr := vatRegNo;
        vatRegNoLenght := StrLen(vatRegNo);
        if vatRegNoLenght = 13 then begin
            for i := 1 to vatRegNoLenght do begin
                vatRegNoArray[i] := CopyStr(vatRegNo, i, 1)
            end;
        end else begin
            for i := 1 to 13 do begin
                vatRegNoArray[i] := '';
            end;
        end;
    end;
}