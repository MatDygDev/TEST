codeunit 50101 "Customer Item Purchase Cost Mgt"
{
    procedure RunForCustomer(Customer: Record Customer)
    var
        Item: Record Item;
        TotalPurchaseCost: Decimal;
        HighestPurchaseCost: Decimal;
    begin
        if not SelectItemFromDialog(Item) then
            exit;

        TotalPurchaseCost := CalculatePurchaseCost(Item."No.");
        HighestPurchaseCost := CalculateHighestPurchaseCost(Item."No.");

        Message(
            'Customer %1: total purchase cost for item %2 (%3) is %4. Highest found purchase cost is %5.',
            Customer."No.",
            Item."No.",
            Item.Description,
            TotalPurchaseCost,
            HighestPurchaseCost);
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
        SetPurchaseEntryFilters(ItemLedgerEntry, ItemNo);

        ItemLedgerEntry.CalcSums("Cost Amount (Actual)");
        TotalPurchaseCost := ItemLedgerEntry."Cost Amount (Actual)";

        exit(TotalPurchaseCost);
    end;

    local procedure CalculateHighestPurchaseCost(ItemNo: Code[20]): Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        HighestPurchaseCost: Decimal;
    begin
        SetPurchaseEntryFilters(ItemLedgerEntry, ItemNo);

        if not ItemLedgerEntry.FindSet() then
            exit(0);

        HighestPurchaseCost := ItemLedgerEntry."Cost Amount (Actual)";
        repeat
            if ItemLedgerEntry."Cost Amount (Actual)" > HighestPurchaseCost then
                HighestPurchaseCost := ItemLedgerEntry."Cost Amount (Actual)";
        until ItemLedgerEntry.Next() = 0;

        exit(HighestPurchaseCost);
    end;

    local procedure SetPurchaseEntryFilters(var ItemLedgerEntry: Record "Item Ledger Entry"; ItemNo: Code[20])
    begin
        if not ItemLedgerEntry.SetCurrentKey("Item No.", "Entry Type") then
            ItemLedgerEntry.SetCurrentKey("Item No.");

        ItemLedgerEntry.SetRange("Item No.", ItemNo);
        ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."Entry Type"::Purchase);
    end;
}
