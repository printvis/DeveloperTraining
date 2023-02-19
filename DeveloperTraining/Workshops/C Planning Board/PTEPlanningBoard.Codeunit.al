codeunit 50154 "PTE Planning Board"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS planning Board Data", 'OnAfterTooltipText2', '', false, false)]
    local procedure OnAfterTooltipText2(PVSJobPlanningUnit: Record "PVS Job Planning Unit"; var OutToolTipTxt: Text; var OutSearchTxt: Text);
    var
        CaseRec: Record "PVS Case";
    begin

        if CaseRec.Get(PVSJobPlanningUnit.ID) then
            OutToolTipTxt := OutToolTipTxt.Replace('$TEST', CaseRec."Sell-To Name");
    end;
}
