// reportextension 50100 "MNB Standard Sales - Invoice" extends "Standard Sales - Invoice"
// {
//     dataset
//     {
//         add(Header)
//         {
//             column(MNBCustomerAddress1; MNBCustAddr[1]) { }
//             column(MNBCustomerAddress2; MNBCustAddr[2]) { }
//             column(MNBCustomerAddress3; MNBCustAddr[3]) { }
//             column(MNBCustomerAddress4; MNBCustAddr[4]) { }
//             column(MNBCustomerAddress5; MNBCustAddr[5]) { }
//             column(MNBCustomerAddress6; MNBCustAddr[6]) { }
//             column(MNBCustomerAddress7; MNBCustAddr[7]) { }
//             column(MNBCustomerAddress8; MNBCustAddr[8]) { }
//             column(MNBCustomerAddress9; MNBCustAddr[9]) { }
//         }
//         modify(header)
//         {
//             trigger OnAfterAfterGetRecord()
//             var
//                 i: Integer;
//             begin
//                 for i := 1 to 8 do
//                     MNBCustAddr[i] := CustAddr[i];
//                 MNBCustAddr[9] := Format(Header."VAT Registration No.");
//                 CompressArray(MNBCustAddr);
//             end;
//         }
//         add(Line)
//         {
//             column(MNBServiceDate; Format("MNB Service Date", 0, '<Month,2>/<Day,2>/<Year,2>')) { }
//             column(MNBLineDiscountAmount; "Line Discount Amount") { }
//         }
//         addfirst(Line)
//         {
//             dataitem(AdditionalDates; Integer)
//             {
//                 DataItemTableView = sorting(Number) where(Number = filter(1 .. 2));
//                 PrintOnlyIfDetail = true;

//                 dataitem(AdditionalDatesDetail; Integer)
//                 {
//                     DataItemTableView = sorting(Number) where(Number = const(1));

//                     column(MNBDateDetails; DateDetails) { }

//                     trigger OnAfterGetRecord()
//                     var
//                         SalesInvoiceLine: Record "Sales Invoice Line";
//                     begin
//                         DateDetails := '';

//                         if SalesInvoiceLine.Get(Line."Document No.", Line."Line No.") then begin
//                             if AdditionalDates.Number = 1 then
//                                 if SalesInvoiceLine."MNB Service Start Date" = 0D then
//                                     CurrReport.Skip()
//                                 else
//                                     DateDetails := StrSubstNo(DateDetailsLbl, SalesInvoiceLine.FieldCaption("MNB Service Start Date"), Format(SalesInvoiceLine."MNB Service Start Date", 0, '<Month,2>/<Day,2>/<Year,2>'));

//                             if AdditionalDates.Number = 2 then
//                                 if SalesInvoiceLine."MNB Service End Date" = 0D then
//                                     CurrReport.Skip()
//                                 else
//                                     DateDetails := StrSubstNo(DateDetailsLbl, SalesInvoiceLine.FieldCaption("MNB Service End Date"), Format(SalesInvoiceLine."MNB Service End Date", 0, '<Month,2>/<Day,2>/<Year,2>'));
//                         end;
//                     end;
//                 }
//             }
//         }
//     }
//     rendering
//     {
//         layout(StandardSalesInvoiceISSILCC)
//         {
//             Type = Word;
//             Caption = 'Standard - Sales Invoice ISSILCC';
//             Summary = 'Standard - Sales Invoice ISSILCC';
//             LayoutFile = './layouts/StandardInvoiceISSILCC.docx';
//         }
//     }

//     var
//         MNBCustAddr: array[9] of Text[100];
//         DateDetails: Text;
//         DateDetailsLbl: Label '%1: %2', Comment = '%1 - Field Caption, %2 - Date';
// }