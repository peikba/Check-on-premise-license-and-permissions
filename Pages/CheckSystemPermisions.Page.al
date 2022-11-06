page 50094 "BAC Check System Permissions"
{
    Caption = 'Check License Ten Permission FactBox';
    PageType = ListPart;
    SourceTable = 2000000005;
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(List)
            {
                field("Role ID"; Rec."Role ID")
                {
                    ApplicationArea = All;
                }
                field("Role Name"; Rec."Role Name")
                {
                    ApplicationArea = All;
                }
                field("Object Name"; Rec."Object Name")
                {
                    Caption = 'Permissions';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    begin
        if Rec."Read Permission" > 0 then
            Rec."Object Name" := 'r'
        else
            Rec."Object Name" += '-';
        if Rec."Insert Permission" > 0 then
            Rec."Object Name" += 'i'
        else
            Rec."Object Name" += '-';
        if Rec."Modify Permission" > 0 then
            Rec."Object Name" += 'm'
        else
            Rec."Object Name" += '-';
        if Rec."Delete Permission" > 0 then
            Rec."Object Name" += 'd'
        else
            Rec."Object Name" += '-';
    end;
}
