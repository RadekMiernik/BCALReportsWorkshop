reportextension 50102 "MNB Standard Sales Quote" extends "Standard Sales - Quote"
{
    dataset
    {
        modify(Header)
        {
            trigger OnAfterAfterGetRecord()
            begin
                GetCurrencySymbolForHeader();
            end;
        }
        modify(Line)
        {
            trigger OnAfterAfterGetRecord()
            begin
                if FormattedLineAmount <> '' then
                    MNBCurrencySymbol := MNBCurrencySymbolForDocument
                else
                    MNBCurrencySymbol := '';
            end;
        }
        add(Header)
        {
            column(MNBDocumentDate; Format("Document Date", 0, '<Month,2>/<Day,2>/<Year4>')) { }
        }
        add(Line)
        {
            column(MNBCurrencySymbol; MNBCurrencySymbol) { }
        }
        addlast(Line)
        {
            dataitem(MNBCommentLines; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                PrintOnlyIfDetail = true;

                dataitem(MNBCommentLine; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(MNBCommentLineValue; CommentLine) { }
                }

                trigger OnAfterGetRecord()
                begin
                    GetCommentLines();
                    if CommentLine = '' then
                        CurrReport.Break();
                end;
            }
        }
    }
    rendering
    {
        layout(StandardSalesQuoteCase3)
        {
            Caption = 'Standard - Sales Quote Case 3';
            LayoutFile = './src/WordScenarios/Case3/StandardSalesQuoteCase3.docx';
            Summary = 'Standard - Sales Quote Case 3';
            Type = Word;
        }
        // layout(LiveStandardSalesQuoteCase3)
        // {
        //     Caption = 'Live Standard - Sales Quote Case 3';
        //     LayoutFile = './src/WordScenarios/Case3/LiveStandardSalesQuoteCase3.docx';
        //     Summary = 'Live Standard - Sales Quote Case 3';
        //     Type = Word;
        // }
    }

    var
        MNBCurrencySymbolForDocument: Text[10];
        MNBCurrencySymbol: Text[10];
        CommentLine: Text;

    local procedure GetCurrencySymbolForHeader()
    var
        Currency: Record Currency;
        GeneralLedgerSetup: Record "General Ledger Setup";
    begin
        if Header."Currency Code" <> '' then begin
            if Currency.Get(Header."Currency Code") then
                MNBCurrencySymbolForDocument := Currency.GetCurrencySymbol();
        end else
            if GeneralLedgerSetup.Get() then
                MNBCurrencySymbolForDocument := GeneralLedgerSetup.GetCurrencySymbol();
    end;

    local procedure GetCommentLines()
    var
        SalesCommentLine: Record "Sales Comment Line";
        NewLineChar: Char;
    begin
        CommentLine := '';
        NewLineChar := 10;
        SalesCommentLine.SetRange("Document Type", SalesCommentLine."Document Type"::Quote);
        SalesCommentLine.SetRange("No.", Line."Document No.");
        SalesCommentLine.SetRange("Document Line No.", Line."Line No.");

        if SalesCommentLine.FindSet() then //begin
            // CommentLine := CommentLine + NewLineChar + NewLineChar;
            repeat
                if (SalesCommentLine.Comment = '') or (SalesCommentLine.Comment = ' ') then
                    CommentLine := CommentLine + NewLineChar + NewLineChar
                else
                    CommentLine += SalesCommentLine.Comment;
            until SalesCommentLine.Next() = 0;
            // CommentLine := CommentLine + NewLineChar + NewLineChar;
        // end;
    end;
}