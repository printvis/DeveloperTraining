codeunit 50190 PTECostCenter
{
    procedure StopCostCenter(OrderNo: text; CostCenterCode: Code[50]; UnitOfMeasureCode: Code[50])
    var
        CaseRec: Record "PVS Case";
        ShopFloorJournalEntry: Record "PVS Shop Floor Journal Entry";
        ShopFloorManagement: Codeunit "PVS Shop Floor Management";
        PVSUser: text;
    begin
        if OrderNo = '' then
            exit;
        CaseRec.SetRange("Order No.", OrderNo);
        if not CaseRec.FindFirst() then
            exit;

        PVSUser := 'PPR';

        ShopFloorJournalEntry.SetRange("User ID", PVSUser);
        ShopFloorJournalEntry.SetRange("Cost Center Code", CostCenterCode);
        ShopFloorJournalEntry.SetRange(UOM, UnitOfMeasureCode);
        ShopFloorJournalEntry.SetRange(ID, CaseRec.ID);
        if ShopFloorJournalEntry.FindFirst() then
            ShopFloorManagement.Journal_Stop_Entry(ShopFloorJournalEntry, false);
    end;



    procedure StartCostCenter(OrderNo: text; CostCenterCode: Code[50]; UnitOfMeasureCode: Code[50])
    var
        CaseRec: Record "PVS Case";
        ShopFloorJournalEntry: Record "PVS Shop Floor Journal Entry";
        ShopFloorManagement: Codeunit "PVS Shop Floor Management";
        PVSUser: text;
    begin
        if OrderNo = '' then
            exit;
        CaseRec.SetRange("Order No.", OrderNo);
        if not CaseRec.FindFirst() then
            exit;

        PVSUser := 'PPR';

        ShopFloorJournalEntry.SetRange("User ID", PVSUser);
        ShopFloorJournalEntry.SetRange("Cost Center Code", CostCenterCode);
        ShopFloorJournalEntry.SetRange(UOM, UnitOfMeasureCode);
        ShopFloorJournalEntry.SetRange(ID, CaseRec.ID);
        if not ShopFloorJournalEntry.FindFirst() then begin
            ShopFloorJournalEntry.Reset();
            ShopFloorManagement.Journal_Add_Entry(PVSUser, CostCenterCode, CaseRec.ID, ShopFloorJournalEntry.Type::Hours, ShopFloorJournalEntry);
            ShopFloorJournalEntry.UOM := UnitOfMeasureCode;
            ShopFloorJournalEntry.Modify();
        end;
        ShopFloorManagement.Journal_Start_Entry(ShopFloorJournalEntry, false);

    end;



}
