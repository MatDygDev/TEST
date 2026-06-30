codeunit 50101 "Customer Item Purchase Cost Mgt"
{
    procedure RunForCustomer(Customer: Record Customer)
    var
        Item: Record Item;
        TotalPurchaseCost: Decimal;
    begin
        if not SelectItemFromDialog(Item) then
            exit;

        TotalPurchaseCost := CalculatePurchaseCost(Item."No.");

        Message(
            'Customer %1: total purchase cost for item %2 (%3) is %4.',
            Customer."No.",
            Item."No.",
            Item.Description,
            TotalPurchaseCost);
    end;

    local procedure SelectItemFromDialog(var Item: Record Item): Boolean
    var
        ItemList: Page "Item List";
    begin
        Item.Reset();
        ItemList.LookupMode(true);
        ItemList.SetTableView(Item);

        if ItemList.RunModal() <> Action::LookupOK then
            exit(false);

        ItemList.GetRecord(Item);
        exit(true);
    end;

    local procedure CalculatePurchaseCost(ItemNo: Code[20]): Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        TotalPurchaseCost: Decimal;
    begin
        if not ItemLedgerEntry.SetCurrentKey("Item No.", "Entry Type") then
            ItemLedgerEntry.SetCurrentKey("Item No.");

        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);

        ItemLedgerEntry.CalcSums("Cost Amount (Actual)");
        TotalPurchaseCost := ItemLedgerEntry."Cost Amount (Actual)";

        exit(TotalPurchaseCost);
    end;
}
