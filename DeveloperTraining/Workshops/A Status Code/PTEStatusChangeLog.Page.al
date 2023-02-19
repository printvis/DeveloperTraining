page 50100 "PTE Status Change Log"
{
    ApplicationArea = All;
    Caption = 'PTE Status Change Log';
    PageType = List;
    SourceTable = "PTE Status Change log";
    UsageCategory = Administration;
    
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("From Code"; Rec."From Code")
                {
                    ApplicationArea = All;
                }
                field("To Code"; Rec."To Code")
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
