codeunit 50158 "PTE Invoice Template"
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Invoice Template Mgmt", 'BuildInvoiceTemplateLine', '', false, false)]
    procedure BuildInvoiceTemplateLine(var SalesHeader: Record "Sales Header"; var InvoiceTemplateHeader: Record "PVS Invoice Template Header"; var InvoiceTemplateLine: Record "PVS Invoice Template Line"; var Job: Record "PVS Job");
    var
        InvoiceTemplateManagement: Codeunit "PVS Invoice Template Mgmt";
        InvoiceTemplateLineTemp: Record "PVS Invoice Template Line" temporary;
    begin
        IF InvoiceTemplateLine."No." <> 'TEST' then
            exit;
        InvoiceTemplateLineTemp.init;
        InvoiceTemplateLineTemp.Type := InvoiceTemplateLineTemp.Type::"G/L Account";
        InvoiceTemplateLineTemp.Description := 'This line is created by special function';
        InvoiceTemplateLineTemp."Manual Description" := true;
        InvoiceTemplateLineTemp.Quantity := 123;
        InvoiceTemplateLineTemp."Unit Price" := 100;
        InvoiceTemplateManagement.Insert_Salesline_New(SalesHeader, InvoiceTemplateLineTemp, InvoiceTemplateHeader, Job, '', '', '', '', '');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Invoice Template Mgmt", 'Insert_Salesline_New_OnBeforeModify', '', false, false)]
    local procedure Insert_Salesline_New_OnBeforeModify(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var InvoiceTemplateHeader: Record "PVS Invoice Template Header"; var InvoiceTemplateLine: Record "PVS Invoice Template Line"; var Job: Record "PVS Job");
    begin
        if InvoiceTemplateHeader.Code <> 'STD' then
            exit;
        if InvoiceTemplateLine.Type <> InvoiceTemplateLine.Type::"Main Invoice" then
            exit;
        SalesLine.Description := SalesLine.Description + 'X';
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"PVS Invoice Template Mgmt", 'BuildInvoiceTemplateHeader', '', false, false)]
    local procedure BuildInvoiceTemplateHeader(var SalesHeader: Record "Sales Header"; var InvoiceTemplateHeader: Record "PVS Invoice Template Header");
    var
        SalesLine: Record "Sales Line";
    begin
        if InvoiceTemplateHeader.Code <> 'TEST' then
            exit;
        SalesLine.Init();
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := 10000;
        SalesLine.Insert();
        SalesLine.Validate(Type, SalesLine.Type::"G/L Account");
        SalesLine.Validate("No.", '6110');
        SalesLine.Validate(Quantity, 123);
        SalesLine.Validate("Unit Price", 1);
        SalesLine."PVS ID" := SalesHeader."PVS Order ID";
        SalesLine.Modify(true);
    end;



}
