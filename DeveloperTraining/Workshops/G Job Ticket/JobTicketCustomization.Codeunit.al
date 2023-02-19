codeunit 50500 "Job Ticket Customization"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS JobTicket Management", 'OnAfterGetReportBuffer', '', true, true)]
    local procedure OnAfterGetReportBuffer(var in_JobRec: Record "PVS Job"; var in_VERSION_COUNTER: Integer; var Out_BufferRecTmp: Record "PVS Sorting Buffer" temporary; var Result: Boolean)
    var
        TableFilters: Codeunit "PVS Table Filters";
        JobItem: Record "PVS Job Item";
    begin
        Out_BufferRecTmp.SetRange("Report Section", 51);
        if Out_BufferRecTmp.FindSet() then
            repeat
                TableFilters.SELECT_JobItems2Job(JobItem, in_JobRec.ID, in_JobRec.Job, in_JobRec.Version, false);
                JobItem.SetRange("Job Item No.", Out_BufferRecTmp."Report TableID1");
                if JobItem.FindFirst() then begin
                    //Out_BufferRecTmp.Text1 := JobItem.Description;
                    Out_BufferRecTmp.Text1 := 'My custom description';
                    Out_BufferRecTmp.Modify();
                end;
            until Out_BufferRecTmp.Next() = 0;
        Out_BufferRecTmp.Reset();
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS JobTicket Management", 'OnAfterGetReportBuffer', '', true, true)]
    local procedure OnAfterGetReportBuffer2(var in_JobRec: Record "PVS Job"; var in_VERSION_COUNTER: Integer; var Out_BufferRecTmp: Record "PVS Sorting Buffer" temporary; var Result: Boolean)
    var
        ProcessRec: Record "PVS Job Process";
    begin
        Out_BufferRecTmp.SetRange("Report Section", 52);
        if Out_BufferRecTmp.FindSet() then
            repeat
                if ProcessRec.Get(Out_BufferRecTmp."Report TableID1") then begin
                    // Change the primary key 2 to get a new line below 
                    Out_BufferRecTmp.PK1_Integer2 := 1;
                    Out_BufferRecTmp."Report Section" := 50000;
                    Out_BufferRecTmp.Text1 := ProcessRec."Created By User";
                    Out_BufferRecTmp.Insert();
                end;
            until Out_BufferRecTmp.Next() = 0;
        Out_BufferRecTmp.Reset();
    end;
}