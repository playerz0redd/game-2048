Unit MenuUnit;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Unit5, SetupAmountU,
    SetupRangeUnit, FieldSetupUnit, InstructionUnit, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls, Vcl.Imaging.jpeg;

Type
    TSetupForm = Class(TForm)
        PlayButton: TButton;
        FieldSizeSetUpBtn: TButton;
        AmountSetupButton: TButton;
        RangeSetupBtn: TButton;
    AboutDevButton: TButton;
    InstructionButton: TButton;
    Image1: TImage;
    Label1: TLabel;
        Procedure AmountSetupButtonClick(Sender: TObject);
        Procedure RangeSetupBtnClick(Sender: TObject);
        Procedure FieldSizeSetUpBtnClick(Sender: TObject);
        Procedure PlayButtonClick(Sender: TObject);
        Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
    procedure AboutDevButtonClick(Sender: TObject);
    procedure InstructionButtonClick(Sender: TObject);
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Const
    HistoryFilePath = 'UserFile.txt';
    RECORD_LABEL_LEFT = 860;
Type
    TUser = Record
        NickName: String[10];
        CurrentRecord: Integer;
    End;

Var
    SetupForm: TSetupForm;
    User: TUser;

Implementation

Uses
    LoginUnit;

Const
    MAX_VALUE = 99999;
    MIN_VALUE = 0;

Type
    TUSerFile = File Of TUser;

{$R *.dfm}

Function CheckFileExist(Var F: TUSerFile): Boolean;
Var
    IsExist: Boolean;
Begin
    IsExist := True;
    Try
        Reset(F);
    Except
        IsExist := False;
    End;
    CheckFileExist := IsExist;
End;

Function CheckRange(Num: Integer): boolean;
Var
    InRange: Boolean;
Begin
    InRange := True;
    if (Num < MIN_VALUE) Or (Num > MAX_VALUE) then
        InRange := False;
    CheckRange := InRange;
End;

Procedure FindUserInHistory();
Var
    UserFile: TUserFile;
    FindUser: TUser;
    NickNameToFind: String;
    IsFileExist: Boolean;
Begin
    IsFileExist := True;
    NickNameToFind := LoginForm.NickNameEdit.Text;
    AssignFile(UserFile, HistoryFilePath);
    IsFileExist := CheckFileExist(UserFile);
    If IsFileExist Then
    Begin
        While (Not EOF(UserFile)) And (FindUser.NickName <> NickNameToFind) Do
            Read(UserFile, FindUser);
        If (FindUser.NickName <> NickNameToFind) Or Not CheckRange(FindUser.CurrentRecord) Then
            PlayForm.RecordIntLabel.Caption := '0'
        Else
            PlayForm.RecordIntLabel.Caption := IntToStr(FindUser.CurrentRecord);
        CloseFile(UserFile);
    End;
End;

Procedure GetCorrectPlaceForRecord();
Var
    CurRecord: Integer;
Begin
    CurRecord := StrToInt(PlayForm.RecordIntLabel.Caption);
    PlayForm.RecordIntLabel.Left := RECORD_LABEL_LEFT;
    While CurRecord <> 0 Do
    Begin
        CurRecord := CurRecord Div 10;
        PlayForm.RecordIntLabel.Left := PlayForm.RecordIntLabel.Left - 10;
    End;
End;

procedure TSetupForm.AboutDevButtonClick(Sender: TObject);
begin
    MessageBox(0, 'Разработал Бычковский Павел Васильевич, студент группы 351005', 'О разработчике', 0);
end;

Procedure TSetupForm.AmountSetupButtonClick(Sender: TObject);
Begin
    SetupAmountForm.Show;
    SetupForm.Hide;
End;

Procedure TSetupForm.FieldSizeSetUpBtnClick(Sender: TObject);
Begin
    FieldSetupForm.Show;
    SetupForm.Hide;
End;

Procedure TSetupForm.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
    LoginForm.Close;
End;

function TSetupForm.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
    callHelp := False;
    result := False;
end;

procedure TSetupForm.InstructionButtonClick(Sender: TObject);
begin
    InstructionForm.ShowModal;
end;

Procedure TSetupForm.PlayButtonClick(Sender: TObject);
Begin
    FindUserInHistory();
    GetCorrectPlaceForRecord();
    SetupForm.Hide;
    PlayForm.Show;
    PlayForm.MoveButton.Enabled := True;
End;

Procedure TSetupForm.RangeSetupBtnClick(Sender: TObject);
Begin
    SetupForm.Hide;
    SetupRangeForm.Show;
End;

End.
