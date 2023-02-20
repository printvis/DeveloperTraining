reportextension 50102 "PTE Job Ticket 2" extends "PVS Job Ticket 2"
{
    RDLCLayout = 'Workshops\G Job Ticket\PVSJobTicket2-custom.rdlc';

    dataset
    {
        add(LINE_DETAILS)
        {
            column(CustomTextField; JobTicketTempS.CustomTextField)
            {
            }
        }
        modify(LINE_DETAILS)
        {
            trigger OnAfterAfterGetRecord()
            var
                PTEJobTicket: Codeunit "PTE Job Ticket";
            begin
                PTEJobTicket.GetJobTicketTemp(JobTicketTempS);
            end;
        }
    }
    var
        JobTicketTempS: Record "PVS Job Ticket Temp";
}