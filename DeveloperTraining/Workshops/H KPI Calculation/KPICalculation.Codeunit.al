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

    [EventSubscriber(ObjectType::Table, Database::"PVS Job", 'OnAfterValidate_Price_Method', '', true, false)]
    local procedure OnAfterValidate_Price_Method2(var in_Rec: Record "PVS Job")
    var
        KPI_Value4: Decimal;
        CacheManagement: Codeunit "PVS Cache Management";
        TempJobCalculationDetail: Record "PVS Job Calculation Detail" temporary;
    begin
        CacheManagement.READ_Tmp_Job_CalcUnitDetails(TempJobCalculationDetail, in_Rec.ID, in_Rec.Job, in_Rec.Version);
        TempJobCalculationDetail.SetRange("Item Type", TempJobCalculationDetail."Item Type"::Plates);
        if TempJobCalculationDetail.FindSet() then
            repeat
                KPI_Value4 += TempJobCalculationDetail.Price;
            until TempJobCalculationDetail.Next() = 0;
        // Assign the KPI values to the Job
        in_Rec."Misc. 4" := KPI_Value4;
        in_Rec.Modify();
    end;
}