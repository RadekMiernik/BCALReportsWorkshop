reportextension 50103 "MNB Standard Sales - Order" extends "Standard Sales - Order Conf."
{
    dataset
    {
        addlast(Header)
        {
            dataitem(MNBPrintStatementDataItem; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                PrintOnlyIfDetail = true;

                dataitem(MNBStatementDataItem; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));

                    column(MNBPrintStatement; PrintStatement) { }

                    trigger OnAfterGetRecord()
                    begin
                        if not PrintStatement then
                            CurrReport.Break();
                    end;
                }
            }
        }
    }
    requestpage
    {
        layout
        {
            addlast(Options)
            {
                field(MNBPrintStatement; PrintStatement)
                {
                    Caption = 'Print Statement';
                    ToolTip = 'Defines if additional statement is added to the printout.';
                    ApplicationArea = All;
                }
            }
        }
    }
    rendering
    {
        layout(StandardSalesOrderCase2)
        {
            Type = Word;
            Caption = 'Standard - Sales Order Confirmation Case 2';
            Summary = 'Standard - Sales Order Confirmation Case 2';
            LayoutFile = './src/WordScenarios/Case2/StandardSalesOrderConfCase2.docx';
        }
    }

    var
        PrintStatement: Boolean;
}