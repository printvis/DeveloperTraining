codeunit 50162 "PTE Shop Floor 2"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shop Floor JS Add-in Mgt", 'OnAfterBuildPanelBuffer', '', false, false)]
    local procedure OnAfterBuildPanelBuffer(pagename: Text; var in_PanelBuffer: Record "PVS Sorting Buffer"; isTimer: Boolean; var isHandled: Boolean; in_RecordID: Text; in_ControlID: Text);
    var
        TempSortingBuffer: Record "PVS Sorting Buffer" temporary;
        CaseRec: Record "PVS Case";
        PlanRec: Record "PVS Job Planning Unit";
        JSAddinMgt: Codeunit "PVS JS Add-in Management";
        EntryNo: Integer;
        SF_FIELDINFO: label 'FIELDINFO', Locked = true;
    begin
        if pagename <> 'JobCard' then
            exit;

        PlanRec.SetPosition(JSAddinMgt.DecodeBase64ElementName(in_ControlID));
        PlanRec.Find('=');

        CaseRec.Get(PlanRec.ID);

        in_PanelBuffer.Reset();
        in_PanelBuffer.SetRange(Code1, SF_FIELDINFO);
        if in_PanelBuffer.FindFirst() then begin
            TempSortingBuffer := in_PanelBuffer;
            TempSortingBuffer.Text1 := 'Customer';
            TempSortingBuffer.PK1_Integer2 := 1;
            TempSortingBuffer.Text2 := CaseRec."Sell-To Name";
            in_PanelBuffer.Init();
            in_PanelBuffer := TempSortingBuffer;
            if not in_PanelBuffer.Insert() then
                in_PanelBuffer.Modify();
        end;


        in_PanelBuffer.reset;
        Page.Run(Page::"PTE Sorting Buffer", in_PanelBuffer);


    end;

}
