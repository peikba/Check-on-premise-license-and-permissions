page 50099 "BAC Check License Version Sub"
{
    Caption = 'Check License Version Subform';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Excel Buffer";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Formula; Rec.Formula)
                {
                    Caption = 'Versions';
                }
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    var
        Found: Boolean;
    begin
        ExcelBuffer.Copy(Rec);
        Found := ExcelBuffer.Find(Which);
        if Found then
            Rec := ExcelBuffer;
        exit(Found);
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    var
        ResultSteps: Integer;
    begin
        ExcelBuffer.Copy(Rec);
        ResultSteps := ExcelBuffer.Next(Steps);
        if ResultSteps <> 0 then
            Rec := ExcelBuffer;
        exit(ResultSteps);
    end;

    var
        ExcelBuffer: Record "Excel Buffer" temporary;

    procedure ClearTmpRec()
    begin
        ExcelBuffer.Reset;
        ExcelBuffer.DeleteAll;
    end;

    procedure SetTMPRec(var ExcelBuffer2: Record "Excel Buffer")
    begin
        ExcelBuffer := ExcelBuffer2;
        ExcelBuffer.Insert;
    end;

    procedure UpdatePage()
    begin
        CurrPage.Update;
    end;
}