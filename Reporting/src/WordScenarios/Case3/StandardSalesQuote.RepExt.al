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
    }
    rendering
    {
        layout(StandardSalesQuoteCase3)
        {
            Type = Word;
            Caption = 'Standard - Sales Quote Case 3';
            Summary = 'Standard - Sales Quote Case 3';
            LayoutFile = './src/WordScenarios/Case3/StandardSalesQuoteCase3.docx';
        }
        layout(StandardSalesQuoteCase3BLANK)
        {
            Type = Word;
            Caption = 'Standard - Sales Quote Case 3 BLANK';
            Summary = 'Standard - Sales Quote Case 3 BLANK';
            LayoutFile = './src/WordScenarios/Case3/StandardSalesQuoteCase3BLANK.docx';
        }
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

        if SalesCommentLine.FindSet() then begin
            CommentLine := CommentLine + NewLineChar + NewLineChar;
            repeat
                if (SalesCommentLine.Comment = '') or (SalesCommentLine.Comment = ' ') then
                    CommentLine := CommentLine + NewLineChar + NewLineChar
                else
                    CommentLine += SalesCommentLine.Comment;
            until SalesCommentLine.Next() = 0;
            CommentLine := CommentLine + NewLineChar + NewLineChar;
        end;
    end;
}