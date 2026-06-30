pageextension 50102 "Customer Card Item Purchase Cost" extends "Customer Card"
{
    actions
    {
        addlast(Processing)
        {
            action("Calculate Item Purchase Cost")
            {
                ApplicationArea = All;
                Caption = 'Calculate Item Purchase Cost';
                Image = Calculate;
                ToolTip = 'Select an item and calculate total purchase cost from Item Ledger Entries.';

                trigger OnAction()
                var
                    CustomerItemPurchaseCostMgt: Codeunit "Customer Item Purchase Cost Mgt";
                begin
                    CustomerItemPurchaseCostMgt.RunForCustomer(Rec);
                end;
            }
        }
    }
}
