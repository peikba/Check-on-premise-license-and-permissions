page 50098 "BAC Check Tenant Permissions"
{
    Caption = 'Check License Ten Permission FactBox';
    PageType = ListPart;
    SourceTable = 2000000166;
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
                field(AppName; AppName)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        AppName: Text;

    trigger OnAfterGetRecord()
    var
        NavApp: Record "Nav App";
    begin
        clear(AppName);
        if NavApp.Get(Rec."App ID") then
            AppName := NavApp.Name;
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
