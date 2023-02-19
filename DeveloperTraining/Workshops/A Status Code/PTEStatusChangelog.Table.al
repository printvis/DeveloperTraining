table 50100 "PTE Status Change log"
{
    Caption = 'PTE Status Change log';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            DataClassification = ToBeClassified;
        }
        field(2; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(3; "From Code"; Code[50])
        {
            Caption = 'From Code';
            DataClassification = ToBeClassified;
        }
        field(4; "To Code"; Code[50])
        {
            Caption = 'To Code';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; ID, "Entry No.")
        {
            Clustered = true;
        }
    }
}
