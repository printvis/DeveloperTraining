codeunit 50191 PTECostCenterStatus
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Shop Floor Management", 'OnBeforeJournal_Special_Start_Stop', '', false, false)]
    local procedure OnBeforeJournal_Special_Start_Stop(var ShopFloorJournalEntry: Record "PVS Shop Floor Journal Entry"; UnitOfMeasure: Record "PVS Unit of Measure"; Is_Start: Boolean; var Handled: Boolean);
    begin
        ShopFloorJournalEntry.CalcFields("Order No.");
        if Is_Start then
            sendToSomewhere(StrSubstNo('%1_%2_%3', ShopFloorJournalEntry."Cost Center Code", ShopFloorJournalEntry."Order No.", 'Started'))
        else
            sendToSomewhere(StrSubstNo('%1_%2_%3', ShopFloorJournalEntry."Cost Center Code", ShopFloorJournalEntry."Order No.", 'Stop'));

    end;

    local procedure sendToSomewhere(TextToSend: Text)
    var
        H: HttpClient;
        r: HttpResponseMessage;
    begin
        h.Get('https://webhook.site/9113df2f-c59d-4823-9408-610cf80774e6?string=' + TextToSend, r);
        //simple HTTP Get
        //but could be anything.
    end;


    // https://webhook.site/#!/9113df2f-c59d-4823-9408-610cf80774e6/55a2d4bb-70ec-4837-99cf-bc94c4019dac/1

}
