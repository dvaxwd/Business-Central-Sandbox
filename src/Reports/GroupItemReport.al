/// <summary>
/// Report GroupItemReport (ID 50132).
/// </summary>
report 50132 "GroupItemReport"
{
    Caption = 'Purchase Report - Group Item';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './src/Reports/Layouts/GroupItemReport.rdl';
    dataset
    {
        dataitem(LoopCopy; Integer)
        {
            DataItemTableView = where(Number = filter(1 ..));
            column(Number; Number) { }
            dataitem(PurchaseHeader; PurchaseTable)
            {
                RequestFilterHeading = 'Report - Purchase Order';
                RequestFilterFields = "Doc No.", "Buy-form Vendor No";
                PrintOnlyIfDetail = true;
                column(DocNo; "Doc No.") { }
                column(VendNo; "Buy-form Vendor No") { }
                column(VendName; "Buy-form Vendor Name") { }
                column(Contact; "Contact") { }
                column(Address; "Address") { }
                column(VendShipNo; "Vendor Shipment No.") { }
                column(Amount; "Amount Calculate") { }
                column(Status; "Status") { }
                dataitem(PurchaseLine; LineTable)
                {
                    DataItemLink = "Doc No." = field("Doc No.");
                    //Trigger of PurchaseLine
                    trigger OnAfterGetRecord()
                    begin
                        TempLineTable.SetRange("Doc No.", "Doc No.");
                        TempLineTable.SetRange("Item No.", "Item No.");
                        if TempLineTable.FindFirst() then begin //already group
                            TempLineTable.Quantity += PurchaseLine.Quantity; // Quanity plus
                            TempLineTable."Total Price" += PurchaseLine."Total Price"; //total price plus
                            TempLineTable.Modify(); //save rec
                        end else begin // not group yet create rec
                            TempLineTable.Init();
                            TempLineTable."Doc No." := "Doc No.";
                            TempLineTable."Line No." := "Line No.";
                            TempLineTable."Item No." := "Item No.";
                            TempLineTable.Description := "Description";
                            TempLineTable.Quantity := Quantity;
                            TempLineTable.UOM := UOM;
                            TempLineTable.Price := Price;
                            TempLineTable."Total Price" := "Total Price";
                            TempLineTable.Date := Date;
                            TempLineTable.Insert();
                        end;
                    end;
                }
                dataitem(TempLineTable; LineTable)
                {
                    DataItemLink = "Doc No." = field("Doc No.");
                    DataItemTableView = sorting("Doc No.", "Item No.");
                    UseTemporary = true;
                    column(GroupItemNo; "Item No.") { }
                    column(GroupDescrip; "Description") { }
                    column(GroupQuanity; "Quantity") { }
                    column(GroupUOM; "UOM") { }
                    column(GroupPrice; "Price") { }
                    column(GroupTotalPrice; "Total Price") { }
                    column(GroupDate; "Date") { }
                    // Trigger of TempLine
                    trigger OnPreDataItem()
                    begin
                        MaxLinePerPage := 10;
                    end;

                    trigger OnPostDataItem()
                    begin
                        BlankLineNeeded := MaxLinePerPage - TempLineTable.Count;
                        if BlankLineNeeded < 0 then
                            BlankLineNeeded := 0;
                    end;
                }
                //Trigger of Purchaseheader
                trigger OnPreDataItem()
                begin
                    TempLineTable.DeleteAll();
                end;
            }
            // Trigger of LoopCopy
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
    var
        PrintCopyText: Text;
        NumberOfCopies: Integer;
        MaxLinePerPage: Integer;
        BlankLineNeeded: Integer;
}
