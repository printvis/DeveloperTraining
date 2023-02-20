tableextension 50100 "PTE Job Ticket" extends "PVS Job Ticket Temp"
{
    fields
    {
        field(50100; CustomTextField; Text[50])
        {
            Caption = 'CustomTextField';
            DataClassification = ToBeClassified;
        }
    }
}