Unit Unit5;

Interface

Uses
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
    System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Grids, System.Math,
    Vcl.Menus, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Imaging.Pngimage, Vcl.ComCtrls,
    System.ImageList, Vcl.ImgList, ContinueChoiceUnit, LoseUnit;

Type
    TPlayForm = Class(TForm)
        MainMenu1: TMainMenu;
        MoveButton: TMenuItem;
        UpButton: TMenuItem;
        DownButton: TMenuItem;
        LeftButton: TMenuItem;
        RightButton: TMenuItem;
        MainImage: TImage;
        AnimationTimer: TTimer;
        Shape1: TShape;
        ScoreLabel: TLabel;
        ScoreIntLabel: TLabel;
        Shape2: TShape;
        RecordLabel: TLabel;
        RecordIntLabel: TLabel;
        LogoImage: TImage;
        MainMenuButton: TSpeedButton;
        RestartButton: TSpeedButton;
        BackButton: TSpeedButton;
        Procedure UpButtonClick(Sender: TObject);
        Procedure DownButtonClick(Sender: TObject);
        Procedure LeftButtonClick(Sender: TObject);
        Procedure RightButtonClick(Sender: TObject);
        Procedure AnimationTimerTimer(Sender: TObject);
        Procedure FormClose(Sender: TObject; Var Action: TCloseAction);
        Procedure FormShow(Sender: TObject);
        Procedure BackButtonClick(Sender: TObject);
        Procedure RestartButtonClick(Sender: TObject);
        Procedure MainMenuButtonClick(Sender: TObject);
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
    Private
        { Private declarations }
    Public
        { Public declarations }
    End;

Var
    PlayForm: TPlayForm;

Type
    TEmptyCells = Record
        MatrixI: Integer;
        MatrixJ: Integer;
    End;

    TAnimationCell = Record
        Picture: TImage;
        Direction: Integer;
    End;

    TArrOfCellsToAnimate = Array Of TAnimationCell;

    TEmptyCellsArr = Array Of TEmptyCells;

    TField = Record
        NumMatrix: Array Of Array Of Integer;
        ImageMatrix: Array Of Array Of TImage;
    End;

    PStack = ^TStack;

    TStack = Record
        CurField: TField;
        Prev: PStack;
        Next: PStack;
    End;

    TDirection = (Vertical, Horizontal);

Var
    Direction: TDirection;
    Stack: PStack;
    FieldSize, MaxRange, MaxAmount: Integer;
    CellsArrToAnimate: TArrOfCellsToAnimate;
    Field: TField;
    EmptyCellsArr: TEmptyCellsArr;
    CounterOfMoves: Integer;
    EndlessGame: Boolean;

Implementation

Uses
    MenuUnit, FieldSetupUnit, SetupRangeUnit, SetupAmountU, LoginUnit;

Const
    FIELD_3_BOTTOM_BORDER = 900;
    FIELD_3_RIGHT_BORDER = 1100;
    FIELD_4_BOTTOM_BORDER = 1100;
    FIELD_4_RIGHT_BORDER = 1200;
    FIELD_5_BOTTOM_BORDER = 1230;
    FIELD_5_RIGHT_BORDER = 1325;

Type
    TUSerFile = File Of TUser;

{$R *.dfm}

Procedure ScoreChangePlace(CurLabel: TLabel; Direction: Integer);
Begin
    CurLabel.Left := CurLabel.Left - 13 * Direction;
End;

Function CalculatePoints(): Integer;
Var
    I, J, Points: Integer;
Begin
    Points := 0;
    For I := Low(Field.NumMatrix) To High(Field.NumMatrix) Do
        For J := Low(Field.NumMatrix) To High(Field.NumMatrix) Do
            Points := Points + Field.NumMatrix[I, J];
    Points := Points * 10;
    CalculatePoints := Points;
End;

Procedure ShowLose();
Begin
    LoseForm.ShowModal;
End;

Function UpdateCurRecord(CurLabel: TLabel): Integer;
Var
    I, J, CurRecord: Integer;
    OldLabel: String;
Begin
    CurRecord := 0;
    OldLabel := CurLabel.Caption;
    CurRecord := CalculatePoints();
    CurLabel.Caption := IntToStr(CurRecord);
    If Length(OldLabel) < Length(IntToStr(CurRecord)) Then
        ScoreChangePlace(CurLabel, 1)
    Else If Length(OldLabel) > Length(IntToStr(CurRecord)) Then
        ScoreChangePlace(CurLabel, -1);
End;

Function IsUserInArr(Const UserArr: Array Of TUser; Const UserNickName: String;
  Var Num: Integer): Boolean;
Var
    IsFound: Boolean;
Begin
    Num := 0;
    IsFound := False;
    While (Not IsFound) And (Num < Length(UserArr)) Do
    Begin
        If UserArr[Num].NickName = UserNickName Then
            IsFound := True
        Else
            Inc(Num);
    End;
    IsUserInArr := IsFound;
End;

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

Procedure AddUserToFile(NickName: String; CurRecord: Integer);
Var
    UserFile: TUSerFile;
    User: TUser;
    UserArr: Array Of TUser;
    I, Position: Integer;
    IsFound, IsExist: Boolean;
Begin
    try
    User.NickName := NickName;
    User.CurrentRecord := CurRecord;
    AssignFile(UserFile, HistoryFilePath);
    IsExist := CheckFileExist(UserFile);
    If IsExist Then
    Begin
        I := 0;
        While Not EOF(USerFile) Do
        Begin
            try
            SetLength(UserArr, I + 1);
            Read(UserFile, UserArr[I]);
            Inc(I);
            except

            end;
        End;
    End;
    Try
        Rewrite(UserFile);
        Position := 0;
        IsFound := IsUserInArr(UserArr, NickName, Position);
        If IsFound Then
        Begin
            If UserArr[Position].CurrentRecord < CurRecord Then
                UserArr[Position] := User;
        End
        Else
        Begin
            SetLength(UserArr, Length(UserArr) + 1);
            UserArr[High(UserArr)] := User;
        End;
        For I := Low(UserArr) To High(UserArr) Do
            Write(UserFile, UserArr[I]);
    Except

    End;
    except

    end;
    try
    CloseFile(UserFile);
    except

    end;
End;

Procedure CopyField(Field: TField);
Var
    I, J: Integer;
Begin
    For I := Low(Field.NumMatrix) To High(Field.NumMatrix) Do
        For J := Low(Field.NumMatrix) To High(Field.NumMatrix) Do
        Begin
            Stack.CurField.NumMatrix[I, J] := Field.NumMatrix[I, J];
            Stack.CurField.ImageMatrix[I, J] := Field.ImageMatrix[I, J];
        End;
End;

Procedure PushStack();
Var
    Prev: PStack;
Begin
    Prev := Stack;
    New(Stack.Next);
    Stack := Stack.Next;
    Setlength(Stack.CurField.NumMatrix, FieldSize, FieldSize);
    SetLength(Stack.CurField.ImageMatrix, FieldSize, FieldSize);

    CopyField(Field);

    Stack.Next := Nil;
    Stack.Prev := Prev;
    PlayForm.BackButton.Enabled := True;
End;

Function CalculatePower(NumPower: Integer): Integer;
Var
    I, Num: Integer;
Begin
    Num := 1;
    For I := 1 To NumPower Do
        Num := 2 * Num;
    CalculatePower := Num;
End;

Procedure FillRandomNumber();
Var
    I, MatrixPosition, CurPower, CurNumber: Integer;
    ImagePath: String;
    IsEnoughSpace: Boolean;
Begin
    IsEnoughSpace := True;
    If Length(EmptyCellsArr) < MaxAmount Then
    Begin
        ShowLose();
        IsEnoughSpace := False;
    End;
    If IsEnoughSpace Then
        For I := 1 To MaxAmount Do
        Begin
            CurPower := RandomRange(1, MaxRange + 1);
            CurNumber := CalculatePower(CurPower);
            MatrixPosition := Random(High(EmptyCellsArr));
            Field.NumMatrix[EmptyCellsArr[MatrixPosition].MatrixI,
              EmptyCellsArr[MatrixPosition].MatrixJ] := CurNumber;
            ImagePath := IntToStr(CurNumber) + '.png';
            try
            Field.ImageMatrix[EmptyCellsArr[MatrixPosition].MatrixI,
              EmptyCellsArr[MatrixPosition].MatrixJ].Picture.LoadFromFile
              (ImagePath);
            except
                messageBox(0,'Некоторые файлы были удалены или неправильно изменены','Ошибка', MB_ICONERROR);
                LoginForm.Close;
            end;
            EmptyCellsArr[MatrixPosition] := EmptyCellsArr[High(EmptyCellsArr)];
            SetLength(EmptyCellsArr, High(EmptyCellsArr));
        End
    Else
        PlayForm.RestartButton.Click;
End;

Var
    Delta: Integer;

Procedure SwapPictures(YDirection, XDirection, I, J: Integer);
Var
    BuffImage: TImage;
Begin
    BuffImage := Field.ImageMatrix[I + YDirection, J + XDirection];
    Field.ImageMatrix[I + YDirection, J + XDirection] :=
      Field.ImageMatrix[I, J];
    Field.ImageMatrix[I, J] := BuffImage;
End;

Procedure AddToAnimationArr(Image: TImage; Direction: Integer);
Begin
    SetLength(CellsArrToAnimate, Length(CellsArrToAnimate) + 1);
    CellsArrToAnimate[High(CellsArrToAnimate)].Picture := Image;
    CellsArrToAnimate[High(CellsArrToAnimate)].Direction := Direction;
End;

Procedure AddToEmptyCellsArr(I, J: Integer);
Begin
    Setlength(EmptyCellsArr, Length(EmptyCellsArr) + 1);
    EmptyCellsArr[High(EmptyCellsArr)].MatrixI := I;
    EmptyCellsArr[High(EmptyCellsArr)].MatrixJ := J;
End;

Procedure SwitchCellsIcon(ImageToNewIcon, ImageToEmptyIcon: TImage;
  NewNum: Integer);
Begin
    try
    ImageToNewIcon.Picture.LoadFromFile(IntToStr(NewNum) + '.png');
    ImageToEmptyIcon.Picture := Nil;
    except
        messageBox(0,'Некоторые файлы были удалены или неправильно изменены','Ошибка', MB_ICONERROR);
        LoginForm.Close;
    end;
End;

Procedure GetEmptyCells();
Var
    I, J: Integer;
Begin
    SetLength(EmptyCellsArr, 0);
    For I := Low(Field.NumMatrix) To High(Field.NumMatrix) Do
        For J := Low(Field.NumMatrix) To High(Field.NumMatrix) Do
            If Field.NumMatrix[I, J] = 0 Then
                AddToEmptyCellsArr(I, J);
End;

Procedure SumDown(StartRow, EndRow, StartCol, EndCol: Integer);
Var
    I, J, Direction, FindEmpty: Integer;
Begin
    Direction := 1;
    FindEmpty := 0;
    If StartRow > EndRow Then
    Begin
        Direction := -1;
    End;
    I := StartRow;
    While Abs(I - StartRow) < High(Field.NumMatrix) Do
    Begin
        For J := Low(Field.NumMatrix) To High(Field.NumMatrix) Do
        Begin
            FindEmpty := 0;
            If (Field.NumMatrix[I, J] <> 0) And
              (Field.NumMatrix[I + Direction, J] = 0) Then
            Begin
                Inc(CounterOFMoves);

                Field.NumMatrix[I + Direction, J] := Field.NumMatrix[I, J];
                Field.NumMatrix[I, J] := 0;

                AddToAnimationArr(Field.ImageMatrix[I, J], Direction);
                AddToAnimationArr(Field.ImageMatrix[I + Direction, J],
                  -Direction);

                While (EmptyCellsArr[FindEmpty].MatrixI <> I + Direction) Or
                  (EmptyCellsArr[FindEmpty].MatrixJ <> J) Do
                    Inc(FindEmpty);
                EmptyCellsArr[FindEmpty].MatrixI := I;

                SwapPictures(Direction, 0, I, J);
            End
            Else If (Field.NumMatrix[I, J] <> 0) And
              (Field.NumMatrix[I + Direction, J] = Field.NumMatrix[I, J]) Then
            Begin
                Inc(CounterOFMoves);
                FindEmpty := 0;
                Field.NumMatrix[I + Direction, J] := Field.NumMatrix[I, J] * 2;
                Field.NumMatrix[I, J] := 0;

                SwitchCellsIcon(Field.ImageMatrix[I, J],
                  Field.ImageMatrix[I + Direction, J],
                  Field.NumMatrix[I + Direction, J]);

                SwapPictures(Direction, 0, I, J);

                AddToAnimationArr(Field.ImageMatrix[I, J], -Direction);
                AddToAnimationArr(Field.ImageMatrix[I + Direction, J],
                  Direction);

                AddToEmptyCellsArr(I, J);

            End;
        End;
        I := I + Direction;
    End;
End;

Function FindMaxCell(): Boolean;
Var
    IsMaxNum: Boolean;
Begin
    IsMaxNum := False;
    For Var I := Low(Field.NumMatrix) To High(Field.NumMatrix) Do
        For Var J := Low(Field.NumMatrix) To High(Field.NumMatrix) Do
            If Field.NumMatrix[I, J] = 2048 Then
                IsMaxNum := True;
    FindMaxCell := IsMaxNum;
End;

Procedure Sumright(StartRow, EndRow, StartCol, EndCol: Integer);
Var
    I, J, Direction, FindEmpty: Integer;
Begin
    Direction := 1;
    If StartCol > EndCol Then
        Direction := -1;
    J := StartCol;
    While Abs(J - StartCol) < High(Field.NumMatrix) Do
    Begin
        For I := Low(Field.NumMatrix) To High(Field.NumMatrix) Do
        Begin
            FindEmpty := 0;
            If (Field.NumMatrix[I, J] <> 0) And
              (Field.NumMatrix[I, J + Direction] = 0) Then
            Begin
                Inc(CounterOFMoves);
                Field.NumMatrix[I, J + Direction] := Field.NumMatrix[I, J];
                Field.NumMatrix[I, J] := 0;
                While (EmptyCellsArr[FindEmpty].MatrixI <> I) Or
                  (EmptyCellsArr[FindEmpty].MatrixJ <> J + Direction) Do
                    Inc(FindEmpty);
                EmptyCellsArr[FindEmpty].MatrixJ := J;

                AddToAnimationArr(Field.ImageMatrix[I, J], Direction);
                AddToAnimationArr(Field.ImageMatrix[I, J + Direction],
                  -Direction);

                SwapPictures(0, Direction, I, J);
            End
            Else If (Field.NumMatrix[I, J] <> 0) And
              (Field.NumMatrix[I, J + Direction] = Field.NumMatrix[I, J]) Then
            Begin
                Inc(CounterOFMoves);
                Field.NumMatrix[I, J + Direction] := Field.NumMatrix[I, J] * 2;
                Field.NumMatrix[I, J] := 0;

                SwitchCellsIcon(Field.ImageMatrix[I, J],
                  Field.ImageMatrix[I, J + Direction],
                  Field.NumMatrix[I, J + Direction]);

                SwapPictures(0, Direction, I, J);

                AddToEmptyCellsArr(I, J);

                AddToAnimationArr(Field.ImageMatrix[I, J], -Direction);
                AddToAnimationArr(Field.ImageMatrix[I, J + Direction],
                  Direction);

            End;
        End;
        J := J + Direction;
    End;
End;

Procedure DeletePictures();
Var
    I, J: Integer;
Begin
    For I := Low(Field.ImageMatrix) To High(Field.ImageMatrix) Do
        For J := Low(Field.ImageMatrix) To High(Field.ImageMatrix) Do
            If Field.ImageMatrix[I, J] <> Nil Then
                Field.ImageMatrix[I, J].Free;
End;

Procedure GetStartImages();
Var
    I, J: Integer;
Begin
    With PlayForm Do
    Begin
        DeletePictures();
        For I := Low(Field.ImageMatrix) To High(Field.ImageMatrix) Do
            For J := Low(Field.ImageMatrix) To High(Field.ImageMatrix) Do
            Begin
                Field.ImageMatrix[I, J] := TImage.Create(PlayForm);
                Field.ImageMatrix[I, J].Parent := PlayForm;
                Field.ImageMatrix[I, J].Width := 150;
                Field.ImageMatrix[I, J].Height := 150;
            End;
    End;
End;

Procedure GetStartPositions();
Var
    I, J: Integer;
Begin
    For I := Low(Field.ImageMatrix) To High(Field.ImageMatrix) Do
        For J := Low(Field.ImageMatrix) To High(Field.ImageMatrix) Do
        Begin
            Field.ImageMatrix[I, J].Top := 263 + I *
              (Field.ImageMatrix[I, J].Height + 4);
            Field.ImageMatrix[I, J].Left := 443 + J *
              (Field.ImageMatrix[I, J].Width + 4);
        End;
End;

Procedure ClearField();
Begin
    SetLength(Field.NumMatrix, 0, 0);
    SetLength(EmptyCellsArr, 0);
    DeletePictures();
    SetLength(Field.ImageMatrix, 0, 0);
    PlayForm.ScoreIntLabel.Caption := '0';
    PlayForm.ScoreIntLabel.Left := 578;
End;

Procedure TPlayForm.BackButtonClick(Sender: TObject);
Var
    I, J: Integer;
Begin
    Field := Stack.CurField;
    Stack := Stack.Prev;
    GetStartImages();
    GetStartPositions();
    For I := Low(Field.NumMatrix) To High(Field.NumMatrix) Do
        For J := Low(Field.NumMatrix) To High(Field.NumMatrix) Do
        Begin
            If Field.NumMatrix[I, J] = 0 Then
                Field.ImageMatrix[I, J].Picture := Nil
            Else
            begin
                try
                Field.ImageMatrix[I, J].Picture.LoadFromFile
                  (IntToStr(Field.NumMatrix[I, J]) + '.png');
                except
                    messageBox(0,'Некоторые файлы были удалены или неправильно изменены','Ошибка', MB_ICONERROR);
                    LoginForm.Close;
                end;
            end;
        End;
    GetEmptyCells();
    UpDateCurRecord(ScoreIntLabel);
    If Stack.Prev = Nil Then
        BackButton.Enabled := False;
    MoveButton.Enabled := True;
End;

Procedure GoBackScreen();
Begin
    try
    AddUserToFile(LoginForm.NickNameEdit.Text,
      StrToInt(PlayForm.ScoreIntLabel.Caption));
    except

    end;
    PlayForm.Hide;
    SetupForm.Show;
    ClearField();
End;

Procedure PopStack();
Var
    Buff: PStack;
Begin
    Buff := Stack;
    Stack := Stack.Prev;
    Stack.Next := Nil;
    Dispose(Buff);
End;

Procedure FieldMove(FDirection: TDirection; StartRow, EndRow, StartCol,
  EndCol: Integer);
Var
    I: Integer;
Begin
    CounterOfMoves := 0;
    PushStack();
    Direction := FDirection;
    Delta := 0;
    PlayForm.MoveButton.Enabled := False;
    For I := Low(Field.NumMatrix) To High(Field.NumMatrix) Do
        If Direction = Horizontal Then
            SumRight(StartRow, EndRow, StartCol, EndCol)
        Else
            SumDown(StartRow, EndRow, StartCol, EndCol);
    PlayForm.AnimationTimer.Enabled := True;
    UpDateCurRecord(PlayForm.ScoreIntLabel);
    If Not EndLessGame And FindMaxCell() Then
        ContinueChoiceForm.ShowModal;
End;

Procedure TPlayForm.DownButtonClick(Sender: TObject);
Begin
    FieldMove(Vertical, 0, High(Field.NumMatrix) - 1, 0, High(Field.NumMatrix));
End;

Procedure TPlayForm.FormClose(Sender: TObject; Var Action: TCloseAction);
Begin
    GoBackScreen();
End;

function TPlayForm.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
    callHelp := False;
    result := False;
end;

Procedure FillEmptyCellsArr();
Begin
    For Var I := Low(EmptyCellsArr) To High(EmptyCellsArr) Do
    Begin
        EmptyCellsArr[I].MatrixI := I Div FieldSize;
        EmptyCellsArr[I].MatrixJ := I Mod FieldSize;
    End;
End;

Procedure ChangeFormSize(Const FieldSize: Integer);
Begin
    Case FieldSize Of
        3:
            Begin
                PlayForm.Height := FIELD_3_BOTTOM_BORDER;
                PlayForm.Width := FIELD_3_RIGHT_BORDER;
            End;
        4:
            Begin
                PlayForm.Height := FIELD_4_BOTTOM_BORDER;
                PlayForm.Width := FIELD_4_RIGHT_BORDER;
            End;
        5:
            Begin
                PlayForm.Height := FIELD_5_BOTTOM_BORDER;
                PlayForm.Width := FIELD_5_RIGHT_BORDER;
            End;
    End;
End;

Procedure TPlayForm.FormShow(Sender: TObject);
Var
    I: Integer;
Begin
    FieldSize := FieldSetupForm.FieldSizeTrackBar.Position;
    MaxRange := SetupRangeForm.RangeTrackBar.Position;
    MaxAmount := SetupAmountForm.AmountTrackBar.Position;
    ChangeFormSize(FieldSize);
    Randomize;
    Setlength(EmptyCellsArr, FieldSize * FieldSize);
    SetLength(Field.ImageMatrix, FieldSize, FieldSize);
    FillEmptyCellsArr();
    GetStartImages();
    New(Stack);
    Stack.Prev := Nil;
    Stack.Next := Nil;
    try
        MainImage.Picture.LoadFromFile(IntToStr(FieldSize) + 'field.png');
    except
        messageBox(0,'Некоторые файлы были удалены или неправильно изменены','Ошибка', MB_ICONERROR);
        LoginForm.Close;
    end;

    Setlength(Field.NumMatrix, FieldSize, FieldSize);
    GetStartPositions();

    FillRandomNumber();
    BackButton.Enabled := False;
    EndLessGame := False;
End;

Procedure TPlayForm.LeftButtonClick(Sender: TObject);
Begin
    FieldMove(Horizontal, 0, High(Field.NumMatrix) + 1,
      High(Field.NumMatrix), 1);
End;

Procedure TPlayForm.RestartButtonClick(Sender: TObject);
Var
    I: Integer;
Begin
    try
    If StrToInt(ScoreIntLabel.Caption) > StrToInt(RecordIntLabel.Caption) Then
    Begin
        RecordIntLabel.Left := 865;
        RecordIntLabel.Caption := ScoreIntLabel.Caption;
        for Var K  := 2 to length(RecordIntLabel.Caption) do
            ScoreChangePlace(RecordIntLabel, 1);
            AddUserToFile(LoginForm.NickNameEdit.Text,
      StrToInt(PlayForm.RecordIntLabel.Caption));

    End;
    except

    end;

    ClearField();
    Setlength(EmptyCellsArr, FieldSize * FieldSize);
    SetLength(Field.ImageMatrix, FieldSize, FieldSize);
    For I := Low(EmptyCellsArr) To High(EmptyCellsArr) Do
    Begin
        EmptyCellsArr[I].MatrixI := I Div FieldSize;
        EmptyCellsArr[I].MatrixJ := I Mod FieldSize;
    End;
    GetStartImages();
    New(Stack);
    Stack.Prev := Nil;
    Stack.Next := Nil;

    Setlength(Field.NumMatrix, FieldSize, FieldSize);
    GetStartPositions();
    AddUserToFile(LoginForm.NickNameEdit.Text,
      StrToInt(PlayForm.ScoreIntLabel.Caption));

    FillRandomNumber();
    BackButton.Enabled := False;
    MoveButton.Enabled := True;

End;

Procedure TPlayForm.RightButtonClick(Sender: TObject);
Begin
    FieldMove(Horizontal, 0, High(Field.NumMatrix) + 1, 0,
      High(Field.NumMatrix) - 1);
End;

Procedure TPlayForm.MainMenuButtonClick(Sender: TObject);
Begin
    GoBackScreen();
End;

Procedure DecideWithCounterOfMoves(CounterOfMoves: Integer);
Begin
    If CounterOfMoves <> 0 Then
    Begin
        FillRandomNumber()
    End
    Else If (CounterofMoves = 0) And (Length(EmptyCellsArr) = 0) Then
    Begin
        ShowLose();
    End
    Else
    Begin
        PopStack();
        PlayForm.BackButton.Enabled := False;
        If Stack.Prev <> Nil Then
            PlayForm.BackButton.Enabled := True;
    End;
End;

Procedure TPlayForm.AnimationTimerTimer(Sender: TObject);
Var
    Limit: Integer;
Begin
    Limit := 154 * Length(CellsArrToAnimate);
    If Abs(Delta) < Limit Then
        For Var I := Low(CellsArrToAnimate) To High(CellsArrToAnimate) Do
        Begin
            If Direction = Vertical Then
                CellsArrToAnimate[I].Picture.Top := CellsArrToAnimate[I]
                  .Picture.Top + CellsArrToAnimate[I].Direction * 22
            Else
                CellsArrToAnimate[I].Picture.Left := CellsArrToAnimate[I]
                  .Picture.Left + CellsArrToAnimate[I].Direction * 22;
            Delta := Delta + 22;
        End
    Else
    Begin
        AnimationTimer.Enabled := False;
        Setlength(CellsArrToAnimate, 0);
        DecideWithCounterOfMoves(CounterOfMoves);
        MoveButton.Enabled := True;
    End;
End;

Procedure TPlayForm.UpButtonClick(Sender: TObject);
Begin
    FieldMove(Vertical, High(Field.NumMatrix), 1, 0, High(Field.NumMatrix));
End;

End.
