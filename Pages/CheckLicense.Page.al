page 50095 "BAC Check License"
{
    ApplicationArea = All;
    Caption = 'Check License';
    LinksAllowed = false;
    PageType = Document;
    ShowFilter = false;
    UsageCategory = Administration;
    SaveValues = true;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ObjectTypes; ObjectTypes)
                {
                    Caption = 'ObjectTypes';

                    trigger OnValidate()
                    begin
                        ShowObjects := ObjectTypes = ObjectTypes::Objects;
                        CurrPage.Update(false);
                    end;
                }
                field("LicenseInfo1.Text"; LicenseInfo1.Text)
                {
                    ShowCaption = false;
                }
                field("LicenseInfo2.Text"; LicenseInfo2.Text)
                {
                    ShowCaption = false;
                }
                grid(MyGrid)
                {
                    GridLayout = Rows;
                    field(ShowSystemPermissions; ShowPermissions)
                    {
                        Caption = 'System Permissions';
                        ToolTip = 'Show the System Permissions FactBox';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            CurrPage.Update(false);
                        end;
                    }
                    field(ShowTenantPermissions; ShowTenantPermissions)
                    {
                        Caption = 'Tenant Permissions';
                        ToolTip = 'Show the Tenant Permissions FactBox';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            CurrPage.Update(false);
                        end;
                    }
                    field(ShowVersions; ShowVersions)
                    {
                        Caption = 'Version Window';
                        ToolTip = 'Show the Version Overview FactBox';
                        ApplicationArea = All;

                        trigger OnValidate()
                        begin
                            CurrPage.Update(false);
                        end;
                    }
                }
            }
            group(Filters)
            {
                Caption = 'Filters';
                Visible = ShowObjects;
                field("Filter Object Exists"; ExistFilter)
                {
                    Caption = 'Filter only Object that Exists';

                    trigger OnValidate()
                    begin
                        CurrPage.LicencePage.Page.SetExistFilter(ExistFilter);
                    end;
                }
                field(NotIncludedInPermissions; NotIncludedInPermissions)
                {
                    Caption = 'Not Included In Permissions';
                    trigger OnValidate()
                    begin
                        CurrPage.LicencePage.Page.SetNotIncludedFilter(NotIncludedInPermissions);
                        ResetFilters();
                    end;
                }

                field("TableFilter"; TableFilter)
                {
                    Caption = 'Tables';

                    trigger OnValidate()
                    begin
                        SetObjectFilter();
                    end;
                }
                field("TableDataFilter"; TableDataFilter)
                {
                    Caption = 'Table Data';

                    trigger OnValidate()
                    begin
                        SetObjectFilter();
                    end;
                }
                field(PageFilter; PageFilter)
                {
                    Caption = 'Pages';

                    trigger OnValidate()
                    begin
                        SetObjectFilter();
                    end;
                }
                field(CodeunitFilter; CodeunitFilter)
                {
                    Caption = 'Codeunits';

                    trigger OnValidate()
                    begin
                        SetObjectFilter();
                    end;
                }
                field(ReportFilter; ReportFilter)
                {
                    Caption = 'Reports';

                    trigger OnValidate()
                    begin
                        SetObjectFilter();
                    end;
                }
                field(QueryFilter; QueryFilter)
                {
                    Caption = 'Queries';
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        SetObjectFilter();
                    end;
                }
                field(XMLPortFilter; XMLPortFilter)
                {
                    Caption = 'XMLports';
                    Importance = Additional;

                    trigger OnValidate()
                    begin
                        SetObjectFilter();
                    end;
                }

                field(ObjectNoFilter; ObjectNoFilter)
                {
                    Caption = 'Object No Filter';

                    trigger OnValidate()
                    begin
                        CurrPage.LicencePage.page.SetObjectNoFilter(ObjectNoFilter);
                    end;
                }
            }
            group(Filters2)
            {
                Caption = 'Filters';
                Visible = Not ShowObjects;
                field(TableExtFilter; TableExtFilter)
                {
                    Caption = 'Table Extensions';

                    trigger OnValidate()
                    begin
                        SetObjectExtFilter();
                    end;
                }
                field(PageExtFilter; PageExtFilter)
                {
                    Caption = 'Page Extensions';

                    trigger OnValidate()
                    begin
                        SetObjectExtFilter();
                    end;
                }
                field(ExtObjectNoFilter; ExtObjectNoFilter)
                {
                    Caption = 'Object No Filter';

                    trigger OnValidate()
                    begin
                        CurrPage.ObjectExtensions.Page.SetObjectNoFilter(ExtObjectNoFilter);
                    end;
                }
            }
            part(LicencePage; "BAC Check License Perm. Sub")
            {
                Caption = 'Object Permissions';
                Enabled = ShowObjects;
                ShowFilter = false;
                Visible = ShowObjects;
            }
            part(ObjectExtensions; "BAC Check License Extensions")
            {
                Caption = 'Object Extensions';
                Enabled = Not ShowObjects;
                Visible = Not ShowObjects;
            }
        }
        area(factboxes)
        {
            part(Permissions; "BAC Check System Permissions")
            {
                Caption = 'System Permissions';
                Provider = LicencePage;
                SubPageLink = "Object Type" = field("Object Type"), "Object ID" = Field("Object Number");
                Visible = ShowPermissions;
            }
            part(TenantPermissions; "BAC Check Tenant Permissions")
            {
                Caption = 'Tenant Permissions';
                Provider = LicencePage;
                SubPageLink = "Object Type" = field("Object Type"), "Object ID" = Field("Object Number");
                Visible = ShowTenantPermissions;
            }
            part(VersionPage; "BAC Check License Version Sub")
            {
                Caption = 'Object Versions';
                Visible = ShowVersions;
            }
        }
    }

    trigger OnOpenPage()
    begin
        CurrPage.VersionPage.PAGE.ClearTmpRec;
        NotIncludedInPermissions := false;
        ObjectTypes := ObjectTypes::Objects;
        ResetFilters();
        LicenseInfo1.Get(4);
        LicenseInfo2.Get(5);
        PopulateVersionList;

        VersionTextBuffer2.Reset;
        if VersionTextBuffer2.Find('-') then
            repeat
                CurrPage.VersionPage.PAGE.SetTMPRec(VersionTextBuffer2);
            until VersionTextBuffer2.Next = 0;
        CurrPage.VersionPage.PAGE.UpdatePage;
        ShowObjects := true;
    end;

    var
        LicenseInfo1: Record "License Information";
        LicenseInfo2: Record "License Information";
        ExistFilter: Boolean;
        ">>Version": Integer;
        VersionTextBuffer: Record "Excel Buffer" temporary;
        VersionTextBuffer2: Record "Excel Buffer" temporary;
        TableFilter: Boolean;
        TableDataFilter: Boolean;
        PageFilter: Boolean;
        QueryFilter: Boolean;
        ReportFilter: Boolean;
        CodeunitFilter: Boolean;
        XMLPortFilter: Boolean;
        ObjectTypes: Option Objects,"Extension Objects";
        ShowObjects: Boolean;
        TableExtFilter: Boolean;
        PageExtFilter: Boolean;
        ObjectNoFilter: Text;
        ExtObjectNoFilter: Text;
        ShowPermissions: Boolean;
        ShowTenantPermissions: Boolean;
        ShowVersions: Boolean;
        NotIncludedInPermissions: Boolean;

    procedure PopulateVersionList()
    var
        "Object": Record "Object";
        IntPos: Integer;
        BaseVersion: Text[250];
        VersionText: Text[250];
        i: Integer;
    begin
        VersionTextBuffer.Reset;
        VersionTextBuffer.DeleteAll;

        i := 0;
        Object.Reset;
        Object.SetCurrentKey(Type, Name);
        Object.SetFilter("Version List", '<>%1', '');
        if Object.Find('-') then
            repeat
                while StrPos(Object."Version List", ',') <> 0 do begin
                    i := i + 1;
                    VersionText := CopyStr(Object."Version List", 1, StrPos(Object."Version List", ',') - 1);
                    Object."Version List" := CopyStr(Object."Version List", StrPos(Object."Version List", ',') + 1, StrLen(Object."Version List"));
                    InsertVersionBuffer(VersionText, i);
                end;
                i := i + 1;
                VersionText := Object."Version List";
                InsertVersionBuffer(VersionText, i);
            until Object.Next = 0;

        i := 0;
        VersionTextBuffer.Reset;
        if VersionTextBuffer.Find('-') then
            repeat
                i := i + 1;
                IntPos := FindFirstNo(VersionTextBuffer."Cell Value as Text");
                if IntPos > 0 then begin
                    BaseVersion := CopyStr(VersionTextBuffer."Cell Value as Text", 1, IntPos - 1);
                    CutVersion(VersionText, IntPos, BaseVersion);
                    InsertVersionBuffer2(VersionText, BaseVersion, i);
                end;
            until VersionTextBuffer.Next = 0;
    end;

    procedure InsertVersionBuffer(VersionText: Text[250]; i: Integer)
    begin
        VersionTextBuffer.SetRange("Cell Value as Text", VersionText);
        if VersionTextBuffer.IsEmpty then begin
            VersionTextBuffer.SetRange("Cell Value as Text");

            VersionTextBuffer."Row No." := i;
            VersionTextBuffer."Cell Value as Text" := VersionText;
            VersionTextBuffer.Insert;
        end;
    end;


    procedure InsertVersionBuffer2(NewVersion: Text[250]; BaseVersion: Text[250]; i: Integer)
    var
        HighestVersion: Text[250];
        VersionInt: Text[250];
    begin
        HighestVersion := '';

        VersionTextBuffer2.SetRange("Cell Value as Text", BaseVersion);
        if VersionTextBuffer2.Find('-') then begin
            repeat
                if HighestVersion < VersionTextBuffer2.Comment then
                    HighestVersion := VersionTextBuffer2.Comment;
            until VersionTextBuffer2.Next = 0;
            if NewVersion > HighestVersion then begin
                VersionTextBuffer2.Comment := NewVersion;
                VersionTextBuffer2.Formula := VersionTextBuffer."Cell Value as Text";
                VersionTextBuffer2.Modify;
            end;
        end else begin
            VersionTextBuffer2."Row No." := i;
            VersionTextBuffer2."Cell Value as Text" := BaseVersion;
            VersionTextBuffer2.Comment := NewVersion;
            VersionTextBuffer2.Formula := VersionTextBuffer."Cell Value as Text";
            VersionTextBuffer2.Insert;
        end;
    end;


    procedure FindFirstNo(TextVar: Text[250]): Integer
    var
        TextInt: Integer;
        i: Integer;
    begin
        for i := 1 to StrLen(TextVar) do begin
            if Evaluate(TextInt, CopyStr(TextVar, i, 1)) then
                exit(i);
        end;
    end;


    procedure CutVersion(var VersionText: Text[250]; IntPos: Integer; BaseVersion: Text[250])
    begin
        // Add baseversions in this function when needed
        case true of
            BaseVersion in ['PM', 'PMBS']:
                VersionText := CopyStr(VersionTextBuffer."Cell Value as Text",
                  11, StrLen(VersionTextBuffer."Cell Value as Text"));
            BaseVersion = 'DKLL':
                VersionText := CopyStr(VersionTextBuffer."Cell Value as Text",
                  10, StrLen(VersionTextBuffer."Cell Value as Text"));
            else
                VersionText := CopyStr(VersionTextBuffer."Cell Value as Text",
                  IntPos, StrLen(VersionTextBuffer."Cell Value as Text"));
        end;
    end;

    local procedure SetObjectFilter()
    var
        ObjectTypeFilter: Text;
    begin
        ObjectTypeFilter := '';
        if TableFilter then
            ObjectTypeFilter += '|Table';
        if TableDataFilter then
            ObjectTypeFilter += '|TableData';
        if PageFilter then
            ObjectTypeFilter += '|Page';
        if QueryFilter then
            ObjectTypeFilter += '|Query';
        if ReportFilter then
            ObjectTypeFilter += '|Report';
        if CodeunitFilter then
            ObjectTypeFilter += '|Codeunit';
        if XMLPortFilter then
            ObjectTypeFilter += '|XMLport';

        ObjectTypeFilter := CopyStr(ObjectTypeFilter, 2);
        CurrPage.LicencePage.PAGE.SetObjectTypeFilter(ObjectTypeFilter);
        CurrPage.LicencePage.PAGE.SetObjectNoFilter(ObjectNoFilter);
    end;

    local procedure SetObjectExtFilter()
    var
        ObjectTypeFilter: Text;
    begin
        ObjectTypeFilter := '';
        if TableExtFilter then
            ObjectTypeFilter += '|TableExtension';
        if PageExtFilter then
            ObjectTypeFilter += '|PageExtension';
        ObjectTypeFilter := CopyStr(ObjectTypeFilter, 2);
        CurrPage.ObjectExtensions.PAGE.SetObjectTypeFilter(ObjectTypeFilter);
    end;

    local procedure ResetFilters()
    begin
        ObjectNoFilter := '50000..99999';
        ExistFilter := false;
        TableFilter := false;
        TableDataFilter := false;
        PageFilter := false;
        ReportFilter := false;
        QueryFilter := false;
        CodeunitFilter := False;
        CurrPage.LicencePage.Page.SetObjectNoFilter(ObjectNoFilter);
    end;
}