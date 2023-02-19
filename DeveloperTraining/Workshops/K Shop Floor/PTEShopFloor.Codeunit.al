codeunit 50157 "PTE Shop Floor"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shop Floor JS Add-in Mgt", 'PVSAddMoreTilesJobCard', '', false, false)]
    local procedure PVSAddMoreTilesJobCard(var TempPVSSortingBuffertTiles: Record "PVS Sorting Buffer"; var isHandled: Boolean);
    begin
        TempPVSSortingBufFertTiles.Init();
        TempPVSSortingBuffertTiles.PK1_Integer1 := 1;
        TempPVSSortingBuffertTiles.Text1 := '#CUSTOMSHIP#';
        TempPVSSortingBuffertTiles.Text2 := 'Shipments';
        TempPVSSortingBuffertTiles.Insert();
        isHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shop Floor JS Add-in Mgt", 'OnAfterClickTileJobTicket', '', false, false)]
    local procedure OnAfterClickTileJobTicket(inGroupID: Text; inControlID: Text; var PlanRec: Record "PVS Job Planning Unit"; var ReturnFlag: Integer);
    var
        PVSJobShipment: Record "PVS Job Shipment";
    begin
        if inControlID <> '#CUSTOMSHIP#' then
            exit;

        PVSJobShipment.SetRange(ID, PlanRec.ID);
        Page.Runmodal(Page::"PVS Shipment List", PVSJobShipment); //Runmodal is needed here
        ReturnFlag := 2; //Deselect button
    end;

}
