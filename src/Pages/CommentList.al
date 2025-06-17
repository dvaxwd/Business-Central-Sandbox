page 50129 CommentList
{
    Caption = 'Comments';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "CommentTable";
    AutoSplitKey = true;
    Editable = true; // Allows editing of comments directly from the list

    layout
    {
        area(Content)
        {
            repeater(CommentList)
            {
                field("Doc No."; Rec."Doc No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Document number associated with the comment.';
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Line number associated with the comment.';
                    Visible = false;
                }
                field("Comment No."; Rec."Comment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Unique identifier for the comment.';
                    Visible = false;
                }
                field("Comment Date"; Rec."Comment Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Date when the comment was made.';
                }
                field(comment; Rec."Content")
                {
                    ApplicationArea = All;
                    ToolTip = 'Content of the comment.';
                }
            }

        }
    }
}
