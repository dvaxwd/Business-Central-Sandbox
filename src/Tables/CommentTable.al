table 50123 CommentTable
{
    DataClassification = CustomerContent;
    Caption = 'Comments';
    fields
    {
        field(1; "Doc No."; Integer){
            DataClassification = CustomerContent;
            Caption = 'Document No.';
            ToolTip = 'Unique identifier for the document associated with this comment.';
            TableRelation = PurchaseTable."Doc No.";
        }field(2; "Line No."; Integer){
            DataClassification = CustomerContent;
            Caption = 'Line No.';
            ToolTip = 'Unique identifier for the line item associated with this comment.';
            TableRelation = LineTable."Line No.";
        }field(3; "Comment No."; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Comment No.';
            ToolTip = 'Unique identifier for the comment.';
            AutoIncrement = true;
        }
        field(4;"Comment Date"; Date){
            DataClassification = SystemMetadata;
            Caption = 'Date';
            ToolTip = 'Date when the comment was made.';
            Editable = false;
        }field(5; "Content"; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Comment';
            ToolTip = 'Content of the comment.';
        }
        
    }
    
    keys
    {
        key(PK; "Doc No.", "Line No.", "Comment No.")
        {
            Clustered = true;
        }
    }
    
    
    trigger OnInsert()
    begin
        rec."Comment Date" := Today();
    end;
    
    trigger OnModify()
    begin
        
    end;
    
    trigger OnDelete()
    begin
        
    end;
    
    trigger OnRename()
    begin
        
    end;
    
}