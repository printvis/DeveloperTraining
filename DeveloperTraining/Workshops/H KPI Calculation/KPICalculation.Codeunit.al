codeunit 50600 "PTE KPI Calculation"
{
    [EventSubscriber(ObjectType::Table, Database::"PVS Job", 'OnAfterValidate_Price_Method', '', true, false)]
    local procedure OnAfterValidate_Price_Method(var in_Rec: Record "PVS Job")
    var
        KPI_Value1: Decimal;
        KPI_Value2: Decimal;
        KPI_Value3: Decimal;
    begin
        // If you only want to calculate for a certain prod group you can add this check 
        if in_Rec."Product Group" <> 'POSTER' then exit;

        // Calculate up to 16 KPI values 
        KPI_Value1 := 13;
        KPI_Value2 := 23;
        KPI_Value3 := KPI_Value1 + KPI_Value2;

        // Assign the KPI values to the Job 
        in_Rec."Misc. 1" := KPI_Value1;
        in_Rec."Misc. 2" := KPI_Value2;
        in_Rec."Misc. 3" := KPI_Value3;
    end;

    [EventSubscriber(ObjectType::Table, Database::"PVS Job", 'OnAfterValidate_Price_Method', '', false, false)]
    procedure OnAfterValidate_Price_Method3(var in_Rec: Record "PVS Job");
    var
        TempJobCalculationDetail: Record "PVS Job Calculation Detail" temporary;
        Item: Record Item temporary;
        CacheManagement: Codeunit "PVS Cache Management";
        ItemManagement: Codeunit "PVS Item Management";
    begin
        CacheManagement.READ_Tmp_Job_CalcUnitDetails(TempJobCalculationDetail, in_Rec.ID, in_Rec.Job, in_Rec.Version);
        TempJobCalculationDetail.SetRange("Item Type", TempJobCalculationDetail."Item Type"::Paper);
        if TempJobCalculationDetail.FindFirst() then
            if Item.Get(TempJobCalculationDetail."Item No.") then begin
                in_Rec."Misc. 4" := Item."PVS Price" * 1000;
                in_Rec."Misc. 5" := ItemManagement.Item_InventoryUnit_Factor(Item, Item."PVS Inventory Unit"::"Pcs.", Item."PVS Inventory Unit"::Weight);
                in_Rec."Misc. 6" := ItemManagement.Item_InventoryUnit_Factor(Item, Item."PVS Inventory Unit"::"Pcs.", Item."PVS Inventory Unit"::"Area");
            end;
        in_Rec.Modify();
    end;
}