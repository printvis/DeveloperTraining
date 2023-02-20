codeunit 50107 "PTE Job Ticket"
{
    SingleInstance = true;
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS JobTicket Management", 'OnBeforeGetPressSubject', '', true, true)]
    local procedure OnBeforeGetPressSubject(var in_JobItem: Record "PVS Job Item"; in_DepartmentRec: Record "PVS Department"; var PressSubjectTemp: Record "PVS Job Ticket Temp" temporary; var lastentry: Integer; var isHandled: Boolean)
    begin
        PressSubjectTemp.PressSubjectBody := in_JobItem.Description;
        PressSubjectTemp."Report Section" := "PVS LineTypes"::"Press - Process Subject Body";
        LastEntry += 1;
        PressSubjectTemp.PK1_Integer1 := LastEntry;
        PressSubjectTemp.KEY_Sorting_Decimal1 := LastEntry * 1000;
        PressSubjectTemp.Insert();
        isHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS JobTicket Management", 'OnAfterGetPressBody', '', true, true)]
    local procedure OnAfterGetPressBody(var in_SheetRec: Record "PVS Job Sheet"; in_DepartmentRec: Record "PVS Department";
    var PressBodyTemp: Record "PVS Job Ticket Temp" temporary; var lastentry: Integer)
    var
        ProcessRec: Record "PVS Job Process";
    begin
        if not ProcessRec.get(in_SheetRec."First Process ID") then
            ProcessRec.Init();
        PressBodyTemp.Init();
        PressBodyTemp.PK1_Integer2 := 1;
        PressBodyTemp."Report Section" := PressBodyTemp."Report Section"::MyNewSection;
        PressBodyTemp.CustomTextField := ProcessRec."Created By User";
        PressBodyTemp.Insert(); //Logic
        SetJobTicketTemp(PressBodyTemp);
    end;

    procedure GetJobTicketTemp(var JobTicketTemp: Record "PVS Job Ticket Temp")
    begin
        JobTicketTemp := Global_JobTicketTemp;
    end;

    procedure SetJobTicketTemp(var JobTicketTemp: Record "PVS Job Ticket Temp")
    begin
        Global_JobTicketTemp := JobTicketTemp;
    end;

    var
        Global_JobTicketTemp: Record "PVS Job Ticket Temp";
}