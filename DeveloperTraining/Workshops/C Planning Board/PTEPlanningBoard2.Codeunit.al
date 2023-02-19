codeunit 50155 "PTE Planning Board 2"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS planning Board Mgt", 'PVSOnBeforeGetColor', '', false, false)]
    local procedure PVSOnBeforeGetColor(PVSJobplanningUnit: Record "PVS Job Planning Unit"; var outColor: Text[100]; var OutTextColor: Text[100]; var Is_Handled: Boolean);
    begin
        if PVSJobplanningUnit.ID <> 20 then
            exit;

        outColor := 'purple';
        OutTextColor := 'white';
        Is_Handled := true;
    end;

}
