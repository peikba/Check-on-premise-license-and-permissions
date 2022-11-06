page 50097 "BAC Check License Extensions"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = AllObjWithCaption;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Object Type"; Rec."Object Type")
                {
                }
                field("Object ID"; Rec."Object ID")
                {
                }
                field("Object Name"; Rec."Object Name")
                {
                }
                field(FromAppName; FromAppName)
                {
                    Caption = 'App Name';
                }
                field(FromAppPublisher; FromAppPublisher)
                {
                    Caption = 'App Publisher';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        FromAppName := '';
        FromAppPublisher := '';
        FromNavApp.SetRange("Package ID", Rec."App Package ID");
        if (FromNavApp.FindFirst) and (Format(Rec."App Package ID") <> '') then begin
            FromAppName := FromNavApp.Name;
            FromAppPublisher := FromNavApp.Publisher;
        end;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("Object ID", 50000, 99999);
        Rec.SetFilter("Object Type", 'TableExtension|PageExtension|ReportExtension|EnumExtension|PermissionSetExtension|ProfileExtension');
    end;

    var
        FromAppName: Text;
        FromAppPublisher: Text;
        FromNavApp: Record "Published Application";

    procedure SetObjectTypeFilter(inObjectTypeFilter: Text)
    begin
        if (inObjectTypeFilter = '') then
            inObjectTypeFilter := 'TableExtension|PageExtension|ReportExtension|EnumExtension|PermissionSetExtension|ProfileExtension';
        Rec.SetFilter("Object Type", inObjectTypeFilter);
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    procedure SetObjectNoFilter(inObjectNoFilter: Text)
    begin
        if Rec.FindFirst() then;
        Rec.SetFilter("Object ID", inObjectNoFilter);
        CurrPage.Update(false);
    end;
}

