report 50102 "MNB General Report"
{
    ApplicationArea = All;
    Caption = 'General Report';
    DefaultRenderingLayout = "GeneralReport.docx";
    // Permissions = 
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    UseRequestPage = true; // set to false if you want to skip request page
    WordMergeDataItem = MainHeader;

    dataset
    {
        dataitem(MainHeader; Integer) //any main table for our report
        {
            DataItemTableView = sorting(Number) where(Number = filter(1 ..));
            #region HEADER ITEMS
            column(Number; Number) { }
            column(DateNotFormatted; Today()) { }
            column(DateFormattedGeneral; Format(Today())) { }
            column(DateFormattedSpecific; Format(Today(), 0, '<Day,2>.<Month,2>.<Year4>')) { }
            column(HeaderLabel1Lbl; HeaderLabel1Lbl) { }
            column(HeaderLabel2Lbl; HeaderLabel2Lbl) { }
            column(HeaderLabel3Lbl; HeaderLabel3Lbl) { }
            column(HeaderLabel4Lbl; HeaderLabel4Lbl) { }
            column(Header1Value; Header1Value) { }
            column(Header2Value; Header2Value) { }
            column(Header3Value; Header3Value) { }
            column(Header4Value; Header4Value) { }
            column(HeaderBarcode; Barcode39Txt) { }
            #endregion

            dataitem(LinesOnHeader; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = filter(1)); // just a dummy filter to get one record per header data
                PrintOnlyIfDetail = true; // set to true if you want to print this dataitem only if there are detail lines
                #region LINES ON HEADER ITEMS
                column(LineLabel1Lbl; LineLabel1Lbl) { }
                column(LineLabel2Lbl; LineLabel2Lbl) { }
                column(LineLabel3Lbl; LineLabel3Lbl) { }
                column(LineLabel4Lbl; LineLabel4Lbl) { }
                column(LineLabel5Lbl; LineLabel5Lbl) { }
                #endregion
                dataitem(LineDetails; Integer)
                {
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                    #region LINE DETAILS ITEMS
                    column(LineNumber; Number) { }
                    column(LineDetailValue1; LineDetailValue1) { }
                    column(LineDetailValue2; LineDetailValue2) { }
                    column(LineDetailValue3; LineDetailValue3) { }
                    column(LineDetailValue4; LineDetailValue4) { }
                    #endregion
                    dataitem(LineSpecificationHeader; Integer)
                    {
                        DataItemTableView = sorting(Number) where(Number = filter(1)); // just a dummy filter to get one record per line data
                        PrintOnlyIfDetail = true; // set to true if you want to print this dataitem only if there are detail lines

                        // add columns here if needed
                        dataitem(LineSpecificationDetails; Integer)
                        {
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                            // add columns here if needed
                            #region LINE SPECIFICATION DETAILS ITEMS
                            column(LineSpecificationDetailNumber; Number) { }
                            column(LineSpecificationDetailValue1; 'Line Spec Detail Value 1 - ' + Format(LineSpecificationDetails.Number)) { }
                            column(LineSpecificationDetailValue2; 'Line Spec Detail Value 2 - ' + Format(LineSpecificationDetails.Number)) { }
                            column(LineSpecificationDetailValue3; 1) { } //to count number of lines in excel
                            #endregion

                            #region LINE SPECIFICATION DETAILS TRIGGERS
                            trigger OnAfterGetRecord()
                            begin
                                if LineSpecificationDetails.Number > NumberOfLineDetails then
                                    CurrReport.Break();
                            end;
                            #endregion
                        }

                        trigger OnAfterGetRecord()
                        var
                            Math: Codeunit Math;
                        begin
                            if Math.IEEERemainder(MainHeader.Number, 2) = 0 then
                                CurrReport.Break(); // to show different output when details exists or not
                        end;
                    }
                    #region LINE DETAILS TRIGGERS
                    trigger OnAfterGetRecord()
                    begin
                        ClearLineDetailVariables();
                        if LineDetails.Number > NumberOfLinesOnHeader then
                            CurrReport.Break();

                        LineDetailValue1 := StrSubstNo(LineDetailValueLbl, 1, LineDetails.Number);
                        LineDetailValue2 := StrSubstNo(LineDetailValueLbl, 2, LineDetails.Number);
                        LineDetailValue3 := StrSubstNo(LineDetailValueLbl, 3, LineDetails.Number);
                        LineDetailValue4 := StrSubstNo(LineDetailValueLbl, 4, LineDetails.Number);
                    end;
                    #endregion
                }
            }

            #region HEADER TRIGGERS

            // sometimes used to filter data before reading the data
            // runs before each record is read
            // trigger OnPreDataItem()
            // begin
            //     MainHeader.SetRange(Number, 1, NumberOfMainHeaders);
            // end;

            trigger OnAfterGetRecord()
            begin
                // ClearHeaderVariables(); // comment that to check what happens with a Header1Value for records from 2 and up

                if MainHeader.Number > NumberOfMainHeaders then
                    // CurrReport.Skip(); // Use skip or break to check differences between them
                    CurrReport.Break();

                CreateBarcode(MainHeader);

                if MainHeader.Number = 1 then
                    Header1Value := StrSubstNo(HeaderValueLbl, 1, MainHeader.Number);
                Header2Value := StrSubstNo(HeaderValueLbl, 2, MainHeader.Number);
                Header3Value := StrSubstNo(HeaderValueLbl, 3, MainHeader.Number);
                Header4Value := StrSubstNo(HeaderValueLbl, 4, MainHeader.Number);
            end;

            // sometimes used to do something after the records has been processed
            // trigger OnPostDataItem()
            // begin
            //     // Message('Report finished processing %1 main header records.', MainHeader.Number);
            // end;
            #endregion
        }
    }
    requestpage
    {
        // SaveValues = true; //use to save last provided values
        layout
        {
            area(Content)
            {
                field(NumberOfMainHeadersField; NumberOfMainHeaders)
                {
                    ApplicationArea = All;
                    Caption = 'Number of Main Headers';
                    ToolTip = 'Specifies the number of main headers to include in the report.';
                }
                field(NumberOfLinesOnHeaderField; NumberOfLinesOnHeader)
                {
                    ApplicationArea = All;
                    Caption = 'Number of Lines on Header';
                    ToolTip = 'Specifies the number of lines to include under each main header.';
                }
                field(NumberOfLineDetailsField; NumberOfLineDetails)
                {
                    ApplicationArea = All;
                    Caption = 'Number of Line Details';
                    ToolTip = 'Specifies the number of line details to include under each line.';
                }
            }
        }
    }
    rendering
    {
        layout("GeneralReport.docx")
        {
            Caption = 'General Report (Word)';
            LayoutFile = './src/General/GeneralReport.docx';
            Summary = 'The General Report (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
            Type = Word;
        }
        layout("GeneralReportNEW.docx")
        {
            Caption = 'General Report (Word) NEW';
            LayoutFile = './src/General/GeneralReportNEW.docx';
            Summary = 'The General Report (Word) provides a simple layout that is also relatively easy for an end-user to modify.';
            Type = Word;
        }
        layout("GeneralReport.xlsx")
        {
            Caption = 'General Report (Excel)';
            LayoutFile = './src/General/GeneralReport.xlsx';
            Summary = 'The General Report (Excel) provides a simple layout that is also relatively easy for an end-user to modify.';
            Type = Excel;
        }
    }
    labels
    {
        Label1Lbl = 'Label 1';
        Label2Lbl = 'Label 2';
        Label3Lbl = 'Label 3';
        Label4Lbl = 'Label 4', Locked = true; // Locked labels cannot be modified in translations
    }

    trigger OnInitReport()
    begin
        NumberOfMainHeaders := 1;
        NumberOfLinesOnHeader := 5;
        NumberOfLineDetails := 1;
    end;

    //use it to check if all parameters are correct
    trigger OnPreReport()
    begin
        if NumberOfMainHeaders < 0 then
            Error('Number of Main Headers must be at least 0.');
        if NumberOfLinesOnHeader < 0 then
            Error('Number of Lines on Header must be at least 0.');
        if NumberOfLineDetails < 0 then
            Error('Number of Line Details must be at least 0.');
    end;

    var
        NumberOfMainHeaders: Integer;
        NumberOfLinesOnHeader: Integer;
        NumberOfLineDetails: Integer;
        Barcode39Txt: Text;
        Header1Value: Text[100];
        Header2Value: Text[100];
        Header3Value: Text[100];
        Header4Value: Text[100];
        HeaderValueLbl: Label 'Header %1 Value - %2', Comment = '%1 is the header value number, %2 is the final value';
        HeaderLabel1Lbl: Label 'Header Label 1';
        HeaderLabel2Lbl: Label 'Header Label 2';
        HeaderLabel3Lbl: Label 'Header Label 3';
        HeaderLabel4Lbl: Label 'Header Label 4', Locked = true; // Locked labels cannot be modified in translations
        LineLabel1Lbl: Label 'Line Label 1';
        LineLabel2Lbl: Label 'Line Label 2';
        LineLabel3Lbl: Label 'Line Label 3';
        LineLabel4Lbl: Label 'Line Label 4';
        LineLabel5Lbl: Label 'Line Label 5';
        LineDetailValue1: Text[100];
        LineDetailValue2: Text[100];
        LineDetailValue3: Text[100];
        LineDetailValue4: Text[100];
        LineDetailValueLbl: Label 'Line %1 Value - %2', Comment = '%1 is the line value number, %2 is the final value';

    procedure ClearHeaderVariables()
    begin
        Header1Value := '';
        Header2Value := '';
        Header3Value := '';
        Header4Value := '';
        Barcode39Txt := '';
    end;

    procedure ClearLineDetailVariables()
    begin
        LineDetailValue1 := '';
        LineDetailValue2 := '';
        LineDetailValue3 := '';
        LineDetailValue4 := '';
    end;

    local procedure CreateBarcode(Header: Record Integer)
    var
        BarcodeString: Text;
        BarcodeFontProvider: Interface "Barcode Font Provider";
    begin
        BarcodeString := Format(Header.Number) + 'ABCD12345'; //working with real data - barcode might be for example the document number
        BarcodeFontProvider := Enum::"Barcode Font Provider"::IDAutomation1D;
        Barcode39Txt := BarcodeFontProvider.EncodeFont(BarcodeString, Enum::"Barcode Symbology"::Code39);
    end;
}