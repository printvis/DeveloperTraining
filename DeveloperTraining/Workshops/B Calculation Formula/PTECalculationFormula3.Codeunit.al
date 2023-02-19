codeunit 50153 "PTE Calculation Formula 3"
{
    trigger OnRun()
    begin
        SingleInstance.Get_Current_CalcUnitDetailRec(JobCalculationDetail);

        JobCalculationDetail."Qty. Calculated" := 0; // Clear the field to be calculated


        case JobCalculationDetail."Formula Code" of
            1010:
                Formula_1010_Weekday();
            1011:
                Formula_1011_Area();
        end;

        SingleInstance.Set_Current_CalcUnitDetailRec(JobCalculationDetail); // Push back the result
    end;

    local procedure Formula_1010_Weekday()
    begin
        JobCalculationDetail."Qty. Calculated" := Date2DWY(Today(), 1)
    end;

    local procedure Formula_1011_Area()
    begin
        SingleInstance.Get_SheetRecTmp(JobSheetTemp);
        JobSheetTemp.SetRange("Sheet ID", JobCalculationDetail."Sheet ID");
        if JobSheetTemp.FindFirst() then
            JobCalculationDetail."Qty. Calculated" := JobSheetTemp.Width * JobSheetTemp.Length;
    end;

    var
        JobSheetTemp: Record "PVS Job Sheet" temporary;
        JobCalculationDetail: Record "PVS Job Calculation Detail";
        SingleInstance: Codeunit "PVS SingleInstance";

}