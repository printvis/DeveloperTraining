codeunit 50191 PTECostCenterStatus
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shop Floor Management", 'OnBeforeJournal_Special_Start_Stop', '', false, false)]
    local procedure OnBeforeJournal_Special_Start_Stop(var ShopFloorJournalEntry: Record "PVS Shop Floor Journal Entry"; UnitOfMeasure: Record "PVS Unit of Measure"; Is_Start: Boolean; var Handled: Boolean)
    var

        RequestText: Text;
    begin
        ShopFloorJournalEntry.CalcFields("Order No.");
        if Is_Start then
            sendToSomewhere(StrSubstNo('%1_%2_%3', ShopFloorJournalEntry."Cost Center Code", ShopFloorJournalEntry."Order No.", 'Started'))
        else
            sendToSomewhere(StrSubstNo('%1_%2_%3', ShopFloorJournalEntry."Cost Center Code", ShopFloorJournalEntry."Order No.", 'Stop'));

    end;

    local procedure sendToSomewhere(TextToSend: Text)
    var
        WebHookHttpClient: HttpClient;
        WebHookResponseMessage: HttpResponseMessage;
        Content: HttpContent;
    begin
        //TODO convert to json
        Content.WriteFrom(TextToSend);

        WebHookHttpClient.Post('https://webhook.site/10c9463e-2fc4-4171-bfe6-59a1614a1261', Content, WebHookResponseMessage);
        //WebHookHttpClient.Get('https://webhook.site/10c9463e-2fc4-4171-bfe6-59a1614a1261?string=' + TextToSend, WebHookResponseMessage);

    end;
}