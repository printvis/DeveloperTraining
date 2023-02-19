codeunit 50194 "PTE Unit Conversion"
{

    trigger OnRun()
    begin
        ConvertItem();
    end;

    procedure ConvertItem()
    var
        Item: Record Item;
        PVSItemManagement: Codeunit "PVS Item Management";
        Area_: Decimal;
        Pcs: Decimal;
        Weight: Decimal;
    begin
        if Item.Get('68182184') then; //example paper
        Pcs := 2660;
        Weight := PVSItemManagement.Item_InventoryUnit_Factor(Item,
        Item."PVS Inventory Unit"::"Pcs.", Item."PVS Inventory Unit"::weight) * PCS;
        Message('%1 Pcs = %2 %3', PCS, Weight, item."PVS Inventory Unit"::weight);
        Area_ := PVSItemManagement.Item_InventoryUnit_Factor(Item,
        Item."PVS Inventory Unit"::"Pcs.", Item."PVS Inventory Unit"::"Area") * Pcs;
        Message('%1 Pcs = %2 %3', PCS, Area_, item."PVS Inventory Unit"::"Area");
    end;
}
