report 50133 "SumaryReport"{
    Caption = 'Purchase Sumary Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = WithWizard;
    dataset{
        // ***** PurchaseLine Data *****
        dataitem(PurchaseLine; LineTable){
            RequestFilterFields = "Item No.";
            column(ItemNo; "Item No.") { }
            column(Description; Description) { }
            column(Quantity; Quantity) { }
            column(UOM; UOM) { }
            column(Price; Price) { }
            column(TotalPrice; "Total Price") { }
            column(LineDate; Date) { }
            column(StartDate; StartDate) { }
            column(EndDate; EndDate) { }
            // Trigger of PurchaseLine
            trigger OnPreDataItem()
            begin
                if StartDate <> 0D then
                    PurchaseLine.SetRange(Date, StartDate, EndDate);
            end;
        }
    }

    // Requestpage of SummaryReport
    requestpage{
        layout{
            area(Content){
                group(Filter){
                    Caption = 'Find & Filter';
                    field(StartDate; StartDate){
                        Caption = 'Start Date';
                        ToolTip = 'Start date  to show in report';
                    }field(EndDate; EndDate){
                        Caption = 'End Date';
                        ToolTip = 'End date to show in report';
                    }
                }
            }
        }
        // Trigger of requestpage
        trigger OnOpenPage()
            begin
                StartDate := CALCDATE('<-CY', (Today())); // ***** Set Start to first day of year *****
                EndDate := Today;
            end;
    }

    // Rendering of SummaryReport
    rendering{
        layout(WithWizard){
            Type = RDLC;
            LayoutFile = './src/Reports/Layouts/SumaryWizardReport.rdl';
            Caption = 'Sumary With Wizard';
        }layout(WithoutWizard){
            Type = RDLC;
            LayoutFile = './src/Reports/Layouts/SumaryReport.rdl';
            Caption = 'Sumary Without Wizard';
        }
    }

    // Variables
    var
        StartDate: Date;
        EndDate: Date;
}