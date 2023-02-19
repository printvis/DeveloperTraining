codeunit 50200 "Update User field"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Main", 'OnCaseAfterStatusChange', '', false, false)]

    local procedure OnCaseAfterStatusChange(StatusCodeFromRec: Record "PVS Status Code"; StatusCodeToRec: Record "PVS Status Code"; var CaseRec: Record "PVS Case"; var IsHandled: Boolean);
    var
        UserfieldManagement: Codeunit "PVS Userfield Management";
        Job: Record "PVS Job";
        FieldNo: Integer;
    begin
        if StatusCodeToRec.Code <> 'PLAN' then
            exit;
        FieldNo := 26;
        Job.SetRange(ID, CaseRec.ID);
        Job.SetRange(Status, Job.Status::Order);
        Job.SetRange(Active, true);
        if Job.FindFirst() then begin
            UserfieldManagement.Set_UserField_Value(Database::"PVS Job", 0, '',
                        '', CaseRec.ID, Job.Job, Job.Version, 0,
                        0, FieldNo, Format(CurrentDateTime), false);
        end;
    end;
}