page 50151 "PTE Create Case"
{
    ApplicationArea = All;
    Caption = 'PTE Create Case';
    PageType = List;
    SourceTable = "PVS Case";
    UsageCategory = Administration;
    CardPageId = "PVS Case Card";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = all;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(CreateCaseEnd)
            {
                Caption = 'Create Case';
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = all;

                trigger OnAction()
                begin
                    CreateOrder();
                end;
            }

        }
    }


    local procedure CreateOrder()
    var
        CaseRec: Record "PVS Case";
    begin
        CreateCase(CaseRec);
    end;

    local procedure CreateCase(var CaseRec: Record "PVS Case")
    var
        JobRec: Record "PVS Job";
        JobItem: Record "PVS Job Item";
        JobSheet: Record "PVS Job Sheet";
        JobCalculationUnit: Record "PVS Job Calculation Unit";
        JobCalculationDetail: Record "PVS Job Calculation Detail";
        Customer: Record Customer;
        CalculationManagement: Codeunit "PVS Calculation Management";
        PlanningManagement: Codeunit "PVS Planning Management";
        Main: Codeunit "PVS Main";
    begin
        Customer.FindFirst();

        CaseRec.Init();
        CaseRec.Insert(true);   //ID       
        CaseRec.Validate("Sell-To No.", Customer."No.");
        CaseRec.Validate("Status Code", 'ORDER');
        CaseRec."Job Name" := 'Job ' + Format(CurrentDateTime);
        CaseRec.Modify(true);

        JobRec.Init();
        JobRec.ID := CaseRec.ID;
        JobRec."Skip Calc." := true;
        JobRec.Insert(true);   //Job and Version

        JobRec.Validate("Product Group", 'POSTER');
        JobRec.Validate("Ordered Qty.", 20000);
        JobRec.Validate("Format Code", '10x10');
        JobRec.Validate("Requested Delivery Date", CalcDate('<+14D>', Today()));
        JobRec.Validate("Requested Delivery DateTime", CreateDateTime(CalcDate('<+14D>', Today()), 100000T));
        JobRec.Modify(true);

        JobItem.SetRange(ID, JobRec.ID);
        JobItem.FindFirst();

        JobSheet.Get(JobItem."Sheet ID");
        JobSheet.Validate("Paper Item No.", '68102104');
        JobSheet.Validate("Controlling Unit", 'DIGITAL');
        JobSheet.Modify(true);

        JobCalculationUnit.ID := JobRec.ID;
        JobCalculationUnit.Job := JobRec.Job;
        JobCalculationUnit.Version := JobRec.Version;
        JobCalculationUnit.Validate(Unit, '7910');

        JobCalculationDetail.SetRange(ID, JobRec.ID);
        JobCalculationDetail.SetRange(Job, JobRec.Job);
        JobCalculationDetail.SetRange(Version, JobRec.Version);
        JobCalculationDetail.SetRange("Calc. Unit", '7910');
        JobCalculationDetail.SetRange(Operation, '100');
        JobCalculationDetail.SetRange("Line Type", JobCalculationDetail."Line Type"::Normal);
        JobCalculationDetail.FindFirst();
        JobCalculationDetail.Validate(Quantity, 10000);
        JobCalculationDetail.Validate(Hours, 1);
        JobCalculationDetail."Manual Hours" := true;
        JobCalculationDetail."Manual Qty." := true;
        JobCalculationDetail.Modify(true);

        JobRec.Get(JobRec.ID, JobRec.Job, JobRec.Version);
        JobRec."Skip Calc." := true;
        JobRec.Modify(true);

        CalculationManagement.Case_Re_Calculate_All_Jobs(CaseRec.ID);

        CaseRec.Get(CaseRec.ID);
        CaseRec.Validate("Status Code", 'PLAN');

        PlanningManagement.Auto_Plan_All(0, false, JobRec.ID, JobRec.Job, false, false);



    end;



}
