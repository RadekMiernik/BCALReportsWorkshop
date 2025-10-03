reportextension 50101 "MNB Standard Purchase - Order" extends "Standard Purchase - Order"
{
    dataset
    {
        add("Purchase Line")
        {
            column(MNBItemPicture; ItemTenantMedia.Content) { }
        }
        modify("Purchase Line")
        {
            trigger OnAfterAfterGetRecord()
            begin
                GetItemPicture("Purchase Line");
            end;
        }
    }

    rendering
    {
        layout(StandardPurchaseOrderCase1)
        {
            Type = Word;
            Caption = 'Standard - Purchase Order Case 4';
            Summary = 'Standard - Purchase Order Case 4';
            LayoutFile = './src/WordScenarios/Case4/StandardPurchaseOrderCase4.docx';
        }
    }

    var
        ItemTenantMedia: Record "Tenant Media";

    local procedure GetItemPicture(PurchaseLine: Record "Purchase Line")
    var
        Item: Record Item;
    begin
        ItemTenantMedia.Reset();
        if PurchaseLine.Type = PurchaseLine.Type::Item then
            if Item.Get(PurchaseLine."No.") then
                if Item.Picture.Count > 0 then begin
                    ItemTenantMedia.Get(Item.Picture.Item(1));
                    ItemTenantMedia.CalcFields(Content);
                end;
    end;
}