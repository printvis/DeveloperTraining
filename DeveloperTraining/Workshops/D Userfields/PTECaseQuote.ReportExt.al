reportextension 50100 "PTE Case Quote" extends "PVS Word Dataset Case Quote"
{
    dataset
    {
        add("PVS Case")
        {
            column(CaseUserfield; UserfieldText)
            {
            }
        }
        modify("PVS Case")
        {
            trigger OnAfterAfterGetRecord()
            var
                UserfieldManagement: Codeunit "PVS Userfield Management";
                FieldNo: Integer;
            begin
                FieldNo := 1;
                UserfieldText := UserfieldManagement.Get_UserField_Value(Database::"PVS Case", 0, '', '', "PVS Case".ID, 0, 0, 0, 0, FieldNo, false);
            end;
        }
    }

    rendering
    {
        layout(LayoutName)
        {
            Type = Word;
            LayoutFile = './Layouts/PTE Case Quote.docx';
        }
    }
    var
        UserfieldText: Text;
}