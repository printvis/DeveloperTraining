codeunit 50151 "PTE Calculation Formula"
{
    trigger OnRun()
    begin
        SingleInstance.Get_Current_CalcUnitDetailRec(JobCalculationDetail);
        JobCalculationDetail."Qty. Calculated" := 0; // Clear the field to be calculated
        JobCalculationDetail."Qty. Calculated" := Random(10000); // Assign value
        SingleInstance.Set_Current_CalcUnitDetailRec(JobCalculationDetail); // Push back the result

    end;

    var
        JobCalculationDetail: Record "PVS Job Calculation Detail";
        SingleInstance: Codeunit "PVS SingleInstance";

}