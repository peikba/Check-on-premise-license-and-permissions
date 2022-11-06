page 50096 "BAC Check License Perm. Sub"
{
    Caption = 'Check License Perm. Subform';
    Editable = false;
    PageType = ListPart;
    ShowFilter = false;
    SourceTable = "License Permission";
    SourceTableView = SORTING("Object Type", "Object Number")
                      WHERE("Object Type" = FILTER(Table .. Query));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                Caption = 'License';
                field("Object Type"; Rec."Object Type")
                {
                    Caption = 'Object Type';
                }
                field("Object Number"; Rec."Object Number")
                {
                    Caption = 'Object Number';
                }
                field(ObjectName; ObjectName)
                {
                    Caption = 'Object Name';
                }
                field("Read Permission"; Rec."Read Permission")
                {
                    Caption = 'Read Permission';
                }
                field("Insert Permission"; Rec."Insert Permission")
                {
                    Caption = 'Insert Permission';
                }
                field("Modify Permission"; Rec."Modify Permission")
                {
                    Caption = 'Modify Permission';
                }
                field("Delete Permission"; Rec."Delete Permission")
                {
                    Caption = 'Delete Permission';
                }
                field("Execute Permission"; Rec."Execute Permission")
                {
                    Caption = 'Execute Permission';
                }
                field(ObjExist; ObjExist)
                {
                    Caption = 'Object Exists';
                    Editable = false;
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
    var
        AllObjWithCap: Record AllObjWithCaption;
    begin
        ObjectName := '';
        FromAppName := '';
        FromAppPublisher := '';
        Clear(AllObjWithCap);

        ObjExist := AllObjWithCap.Get(Rec."Object Type", Rec."Object Number");

        if ObjExist then
            ObjectName := AllObjWithCap."Object Name";

        if ObjExistFilter and ObjExist then
            Rec.Mark;

        FromNavApp.SetRange("Package ID", AllObjWithCap."App Package ID");
        if (FromNavApp.FindFirst) and (Format(AllObjWithCap."App Package ID") <> '') then begin
            FromAppName := FromNavApp.Name;
            FromAppPublisher := FromNavApp.Publisher;
        end;
    end;

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Object Number", '%1..%2', 50000, 99999);
        Rec.SetFilter("Execute Permission", '%1|%2', Rec."Execute Permission"::Yes, Rec."Execute Permission"::Indirect);
        FromAppName := '';
        FromAppPublisher := '';
        Rec.ClearMarks;

        if ObjExistFilter then
            Rec.MarkedOnly(true);
    end;

    var
        ObjExist: Boolean;
        ObjExistFilter: Boolean;
        ObjectName: Text;
        FromAppName: Text;
        FromAppPublisher: Text;
        FromNavApp: Record "Published Application";

    procedure SetExistFilter(SetFilter: Boolean)
    var
        AllObjWithCap: Record AllObjWithCaption;
    begin
        ObjExistFilter := SetFilter;

        Rec.MarkedOnly(false);
        Rec.ClearMarks;
        if ObjExistFilter then begin
            AllObjWithCap.Reset;
            if AllObjWithCap.FindSet() then
                repeat
                    if not (AllObjWithCap."Object Type" in [16, 17]) then begin //PageExtension & TableExtension
                        if Rec.Get(AllObjWithCap."Object Type", AllObjWithCap."Object ID") then
                            Rec.Mark(true);
                    end;
                until AllObjWithCap.Next = 0;
            Rec.MarkedOnly(true);
        end;
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    procedure SetObjectTypeFilter(inObjectTypeFilter: Text)
    begin
        Rec.SetFilter("Object Type", inObjectTypeFilter);
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    procedure SetObjectNoFilter(inObjectNoFilter: Text)
    begin
        Rec.SetFilter("Object Number", inObjectNoFilter);
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;

    procedure SetNotIncludedFilter(inSetNotIncludedFilter: Boolean)
    var
        AllObjWithCap: Record AllObjWithCaption;
        SystemPermission: Record Permission;
        TenantPermission: Record "Tenant Permission";
        ObjTypeFilter: Text;
        ObjNoFilter: Text;
    begin
        ObjNoFilter := Rec.GetFilter("Object Number");
        ObjTypeFilter := Rec.GetFilter("Object Type");
        Rec.ClearMarks;
        Rec.MarkedOnly(false);
        Rec.Reset();
        Rec.SetFilter("Object Number", ObjNoFilter);
        Rec.SetFilter("Object Type", ObjTypeFilter);
        CurrPage.Update(false);

        if not inSetNotIncludedFilter then
            exit;

        AllObjWithCap.Reset;
        AllObjWithCap.SetFilter("Object Name", '<>SUPER*');
        AllObjWithCap.SetFilter("Object Type", ObjTypeFilter);
        AllObjWithCap.SetFilter("Object ID", ObjNoFilter);
        if AllObjWithCap.FindSet() then
            repeat
                if not (AllObjWithCap."Object Type" in [16, 17]) and (AllObjWithCap."Object Type" <> AllObjWithCap."Object Type"::Table) then begin //PageExtension & TableExtension
                    if Rec.Get(AllObjWithCap."Object Type", AllObjWithCap."Object ID") then begin
                        SystemPermission.Reset();
                        SystemPermission.SetRange("Object Type", AllObjWithCap."Object Type");
                        SystemPermission.SetRange("Object ID", AllObjWithCap."Object ID");
                        if SystemPermission.IsEmpty then begin
                            TenantPermission.Reset();
                            TenantPermission.SetRange("Object Type", AllObjWithCap."Object Type");
                            TenantPermission.SetRange("Object ID", AllObjWithCap."Object ID");
                            if TenantPermission.IsEmpty then
                                Rec.Mark(true);
                        end;
                    end;
                end;
            until AllObjWithCap.Next = 0;
        Rec.MarkedOnly(true);
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;
}

