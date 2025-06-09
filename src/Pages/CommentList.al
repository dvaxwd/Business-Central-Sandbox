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
    
    actions
    {
        area(Processing)
        {
            action(NewComment)
            {
                Caption = 'New Comment';
                Image = New;
                
                trigger OnAction()
                begin
                    // Code to create a new comment
                end;
            }
        }
    }
}
