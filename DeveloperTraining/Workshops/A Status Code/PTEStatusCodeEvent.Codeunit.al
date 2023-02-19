codeunit 50150 "PTE Status Code Event"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Main", 'OnCaseBeforeStatusChange', '', false, false)]
    local procedure OnCaseBeforeStatusChange(StatusCodeFromRec: Record "PVS Status Code"; StatusCodeToRec: Record "PVS Status Code"; var CaseRec: Record "PVS Case"; var IsHandled: Boolean);
    var
        Job: Record "PVS Job";
    begin
        if StatusCodeToRec.Code <> 'QUOTE' then
            exit;

        Job.SetRange(ID, CaseRec.ID);
        if job.FindFirst() then
            if job."Quoted Price" > 1000 then
                Error('Price is higher then 1000');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Main", 'OnCaseAfterStatusChange', '', false, false)]
    local procedure OnCaseAfterStatusChange(StatusCodeFromRec: Record "PVS Status Code"; StatusCodeToRec: Record "PVS Status Code"; var CaseRec: Record "PVS Case"; var IsHandled: Boolean);
    var
        PTEStatusChangelog: Record "PTE Status Change log";
    begin
        PTEStatusChangelog.ID := CaseRec.ID;
        PTEStatusChangelog."From Code" := StatusCodeFromRec.Code;
        PTEStatusChangelog."To Code" := StatusCodeToRec.Code;
        PTEStatusChangelog.Insert(true);
    end;

}
