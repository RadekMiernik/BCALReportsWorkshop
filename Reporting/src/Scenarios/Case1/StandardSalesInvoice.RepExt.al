reportextension 50100 "MNB Standard Sales - Invoice" extends "Standard Sales - Invoice"
{
    dataset
    {
        add(Header)
        {
            column(MNBCustomerAddress1; MNBCustAddr[1]) { }
            column(MNBCustomerAddress2; MNBCustAddr[2]) { }
            column(MNBCustomerAddress3; MNBCustAddr[3]) { }
            column(MNBCustomerAddress4; MNBCustAddr[4]) { }
            column(MNBCustomerAddress5; MNBCustAddr[5]) { }
            column(MNBCustomerAddress6; MNBCustAddr[6]) { }
            column(MNBCustomerAddress7; MNBCustAddr[7]) { }
            column(MNBCustomerAddress8; MNBCustAddr[8]) { }
            column(MNBCustomerAddress9; MNBCustAddr[9]) { }
        }
        modify(header)
        {
            trigger OnAfterAfterGetRecord()
            var
                i: Integer;
            begin
                for i := 1 to 8 do
                    MNBCustAddr[i] := CustAddr[i];
                MNBCustAddr[9] := Format(Header."Pre-Assigned No.");
                CompressArray(MNBCustAddr);
            end;
        }
    }
    rendering
    {
        layout(StandardSalesInvoiceCase1)
        {
            Type = Word;
            Caption = 'Standard - Sales Invoice Case 1';
            Summary = 'Standard - Sales Invoice Case 1';
            LayoutFile = './src/Scenarios/Case1/StandardInvoiceCase1.docx';
        }
    }

    var
        MNBCustAddr: array[9] of Text[100];
}