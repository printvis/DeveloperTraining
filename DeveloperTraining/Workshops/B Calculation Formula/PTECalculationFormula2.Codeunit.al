codeunit 50152 "PTE Calculation Formula 2"
{
    trigger OnRun()
    begin
        SingleInstance.Get_Current_CalcUnitDetailRec(JobCalculationDetail);
        SingleInstance.Get_SheetRecTmp(JobSheetTemp);
        JobCalculationDetail."Qty. Calculated" := 0; // Clear the field to be calculated
        JobSheetTemp.SetRange("Sheet ID", JobCalculationDetail."Sheet ID");
        if JobSheetTemp.FindFirst() then
            JobCalculationDetail."Qty. Calculated" := JobSheetTemp.Weight;
        SingleInstance.Set_Current_CalcUnitDetailRec(JobCalculationDetail); // Push back the result
    end;

    var
        JobSheetTemp: Record "PVS Job Sheet" temporary;
        JobCalculationDetail: Record "PVS Job Calculation Detail";
        SingleInstance: Codeunit "PVS SingleInstance";

}