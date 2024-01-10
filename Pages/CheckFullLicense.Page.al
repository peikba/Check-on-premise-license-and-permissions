page 50093 "BAC Check Full License"
{
    PageType = List;
    SourceTable = "License Information";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Text; Text)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
}
// CODFX0010127 Warehouse Corrections