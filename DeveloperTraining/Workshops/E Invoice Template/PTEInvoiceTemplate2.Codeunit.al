codeunit 50159 "PTE Invoice Template 2"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Invoice Template Mgmt", 'BuildInvoiceTemplateLine', '', false, false)]
    local procedure BuildInvoiceTemplateLine(var SalesHeader: Record "Sales Header"; var InvoiceTemplateHeader: Record "PVS Invoice Template Header"; var InvoiceTemplateLine: Record "PVS Invoice Template Line"; var Job: Record "PVS Job");
    var
        JobCalculationUnit: Record "PVS Job Calculation Unit";
        InvoiceTemplateLineTemp: Record "PVS Invoice Template Line" temporary;
        InvoiceTemplateManagement: Codeunit "PVS Invoice Template Mgmt";
    begin
        if InvoiceTemplateLine."No." <> 'CALCUNIT' then
            exit;
        JobCalculationUnit.SetRange(ID, Job.ID);
        JobCalculationUnit.SetRange(Job, Job.Job);
        JobCalculationUnit.SetRange(Version, Job.Version);
        if JobCalculationUnit.FindSet() then
            repeat
                InvoiceTemplateLineTemp.Type := InvoiceTemplateLineTemp.Type::"G/L Account";
                InvoiceTemplateLineTemp.Description := JobCalculationUnit.Text;
                InvoiceTemplateLineTemp."Manual Description" := true;
                InvoiceTemplateLineTemp.Quantity := 1;
                InvoiceTemplateLineTemp."Unit Price" := JobCalculationUnit."Quote Price";
                InvoiceTemplateManagement.Insert_Salesline_New(SalesHeader, InvoiceTemplateLineTemp, InvoiceTemplateHeader, Job, '', '', '', '', '');
            until JobCalculationUnit.Next() = 0;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Invoice Template Mgmt", 'Insert_Salesline_New_OnBeforeModify', '', false, false)]
    local procedure Insert_Salesline_New_OnBeforeModify(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var InvoiceTemplateHeader: Record "PVS Invoice Template Header"; var InvoiceTemplateLine: Record "PVS Invoice Template Line"; var Job: Record "PVS Job");
    begin
        if InvoiceTemplateHeader.Code <> 'STD' then
            exit;
        if InvoiceTemplateLine.Type <> InvoiceTemplateLine.Type::"Main Invoice" then
            exit;
        SalesLine.Validate("Unit Price", Round(SalesLine."Unit Price", 1, '='));
    end;



}
