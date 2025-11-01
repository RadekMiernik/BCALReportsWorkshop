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
                    ApplicationArea = All;
                    Caption = 'Print Statement';
                    ToolTip = 'Defines if additional statement is added to the printout.';
                }
            }
        }
    }
    rendering
    {
        layout(StandardSalesOrderCase2)
        {
            Caption = 'Standard - Sales Order Confirmation Case 2';
            LayoutFile = './src/WordScenarios/Case2/StandardSalesOrderConfCase2.docx';
            Summary = 'Standard - Sales Order Confirmation Case 2';
            Type = Word;
        }
        // layout(LiveStandardSalesOrderCase2)
        // {
        //     Caption = 'Live Standard - Sales Order Confirmation Case 2';
        //     LayoutFile = './src/WordScenarios/Case2/LiveStandardSalesOrderConfCase2.docx';
        //     Summary = 'Live Standard - Sales Order Confirmation Case 2';
        //     Type = Word;
        // }
    }

    var
        PrintStatement: Boolean;
}