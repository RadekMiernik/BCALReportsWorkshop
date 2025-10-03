report 50100 "MNB Invoiced Items"
{
    ApplicationArea = All;
    Caption = 'Invoiced Items';
    DefaultRenderingLayout = "InvoicedItems.xlsx";
    UsageCategory = ReportsAndAnalysis;
    ExcelLayoutMultipleDataSheets = true;

    dataset
    {

        dataitem("Sales Invoice Line"; "Sales Invoice Line")
        {
            DataItemTableView = sorting("Document No.", "Location Code") where(Type = const(Item));

            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Document_No_; "Document No.") { }
            column(ItemNo_; "No.") { }
            column(Quantity; Quantity) { }
            column(Unit_of_Measure_Code; "Unit of Measure Code") { }
            column(Unit_Price; "Unit Price") { }
            column(Line_Amount; "Line Amount") { }
            column(Amount_Including_VAT; "Amount Including VAT") { }
            column(Description; Description) { }
        }
        dataitem(Customer; Customer)
        {
            DataItemTableView = sorting("No.");

            column(CustomerNo_; "No.") { }
            column(Name; Name) { }
            column(City; City) { }
        }
    }

    rendering
    {
        layout("InvoicedItems.xlsx")
        {
            Caption = 'Invoiced Items (Excel)';
            LayoutFile = './src/ExcelScenarios/Case1/InvoicedItems.xlsx';
            Summary = 'The Excel report with all invoiced items in our company.';
            Type = Excel;
        }
    }
}