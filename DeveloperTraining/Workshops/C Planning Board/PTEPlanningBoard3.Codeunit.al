enumextension 50150 "PTE Planning Board Menu All." extends "PVS Planning Board Menu All."
{
    value(50150; PTEChangeStatus) { Caption = 'Change Status to Job Costing'; }
    value(50151; PTEShipment) { Caption = 'Shipment'; }
}


codeunit 50156 "PTE Planning Board 3"
{

    [EventSubscriber(ObjectType::Page, Page::"PVS Planning Board", 'OnMenuClickMenuAllocation', '', false, false)]
    local procedure OnMenuClickMenuAllocation(PlanningBoardMenuAll: Enum "PVS Planning Board Menu All."; PlanUnitRecordIDtxt: Text; PlanningBoardData: Codeunit "PVS planning Board Data"; var ReloadPlanning: Boolean; var ReloadPlanningID: Integer; var ReloadPlanningIDList: List of [Integer]);
    begin
        case PlanningBoardMenuAll of
            PlanningBoardMenuAll::PTEChangeStatus:
                begin
                    ReloadPlanningID := ChangeStatus(PlanUnitRecordIDtxt);
                    ReloadPlanning := true;
                end;
            PlanningBoardMenuAll::PTEShipment:
                begin
                    OpenShipment(PlanUnitRecordIDtxt);
                end;
        end;
    end;

    local procedure ChangeStatus(PlanUnitRecordIDtxt: Text): Integer
    var
        JobPlanningUnit: Record "PVS Job Planning Unit";
        CaseRec: Record "PVS Case";
    begin
        if StrLen(PlanUnitRecordIDtxt) > 4 then
            PlanUnitRecordIDtxt := CopyStr(PlanUnitRecordIDtxt, 5);
        JobplanningUnit.SETPOSITION(PlanUnitRecordIDtxt);
        CaseRec.Get(JobPlanningUnit.ID);
        CaseRec.Validate("Status Code", 'JOBCOSTING');
    end;

    local procedure OpenShipment(PlanUnitRecordIDtxt: Text): Integer
    var
        JobPlanningUnit: Record "PVS Job Planning Unit";
        CaseRec: Record "PVS Case";
        JobShipment: Record "PVS Job Shipment";
    begin
        if StrLen(PlanUnitRecordIDtxt) > 4 then
            PlanUnitRecordIDtxt := CopyStr(PlanUnitRecordIDtxt, 5);
        JobplanningUnit.SETPOSITION(PlanUnitRecordIDtxt);
        JobShipment.SetRange(id, JobPlanningUnit.ID);
        page.Run(page::"PVS Job Shipments List", JobShipment);
    end;

}