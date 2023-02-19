codeunit 50160 "PTE Sharepoint"
{

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Main", 'OnCaseAfterStatusChange', '', false, false)]
    local procedure OnCaseAfterStatusChange(StatusCodeFromRec: Record "PVS Status Code"; StatusCodeToRec: Record "PVS Status Code"; var CaseRec: Record "PVS Case"; var IsHandled: Boolean);
    begin
        if StatusCodeToRec.Code <> 'ORDER' then
            exit;
        SaveReportAsDoc(CaseRec.ID);
    end;

    procedure SaveReportAsDoc(inID: Integer)
    var
        Folder: Record "PVS Folder";
        TempCloudStorage: Record "PVS Cloud Storage" temporary;
        TempBlob: Codeunit "Temp Blob";
        Cloudmgt: Codeunit "PVS Cloud Graph Management";
        recRef: RecordRef;
        fldRef: FieldRef;
        OStream: OutStream;
        outNewFileID, ServerFileName, ReportParameters : Text;
    begin

        ServerFileName := 'JobTicket';
        Folder.SetRange(ID, inID);
        if not Folder.FindFirst() then begin
            folder.Folder_Create_Folders();
            Folder.SetRange(ID, inID);
            if not Folder.FindFirst() then
                exit;
        end;

        recRef.Open(Database::"PVS Case");
        fldRef := recRef.Field(1);
        fldRef.SetRange(inID);

        TempBlob.CreateOutStream(oStream);
        if recRef.FindFirst() then
            Report.SaveAs(Report::"PVS Job Ticket", ReportParameters, ReportFormat::Pdf, oStream, recRef)
        else
            exit;

        Cloudmgt.GetFolder(0, Folder."Cloud ID", Folder."Cloud ID", false, TempCloudStorage);
        if TempCloudStorage.Count > 0 then
            ServerFileName := ServerFileName + Format(TempCloudStorage.Count);
        ServerFileName += '.pdf';

        if Cloudmgt.UploadFile(TempBlob, ServerFileName, Folder."Cloud ID", outNewFileID) then;
    end;
}
