unit LoginUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.StdCtrls, Unit5, menuUnit, SetupAmountU, Vcl.Buttons;

type
  TLoginForm = class(TForm)
    Image1: TImage;
    UserNickLabel: TLabel;
    NickNameEdit: TEdit;
    PlayButton: TButton;
    SpeedButton1: TSpeedButton;
    CheckImage: TImage;
    Timer1: TTimer;
    procedure NickNameEditKeyPress(Sender: TObject; var Key: Char);
    procedure NickNameEditChange(Sender: TObject);
    procedure PlayButtonClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;

implementation

{$R *.dfm}

Const
    SET_OF_ALPHABET = ['a'..'z', 'A'..'Z', #8];


procedure TLoginForm.FormCreate(Sender: TObject);
begin
//sdf
end;

function TLoginForm.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
    callHelp := False;
    result := False;
end;

procedure TLoginForm.FormShow(Sender: TObject);
begin
    try
        checkImage.Picture.LoadFromFile('2.png');
        checkImage.Picture.LoadFromFile('4.png');
        checkImage.Picture.LoadFromFile('8.png');
        checkImage.Picture.LoadFromFile('16.png');
        checkImage.Picture.LoadFromFile('32.png');
        checkImage.Picture.LoadFromFile('64.png');
        checkImage.Picture.LoadFromFile('128.png');
        checkImage.Picture.LoadFromFile('256.png');
        checkImage.Picture.LoadFromFile('512.png');
        checkImage.Picture.LoadFromFile('1024.png');
        checkImage.Picture.LoadFromFile('2048.png');
        checkImage.Picture.LoadFromFile('4096.png');
        checkImage.Picture.LoadFromFile('8192.png');
        checkImage.Picture.LoadFromFile('3field.png');
        checkImage.Picture.LoadFromFile('4field.png');
        checkImage.Picture.LoadFromFile('5field.png');
    Except
        messageBox(0,'Некоторые файлы были удалены или неверно изменены','Ошибка', MB_ICONERROR);
        LoginForm.Close;
    end;

end;

procedure TLoginForm.NickNameEditChange(Sender: TObject);
Var
    I: Integer;
    IsCorrect: Boolean;
    Ch: Char;
begin
    I := 1;
    IsCorrect := True;
    while IsCorrect and (I <= Length(NickNameEdit.Text)) do
    Begin
        if (Not (NickNameEdit.Text[I] In SET_OF_ALPHABET))  then
        Begin
            IsCorrect := False;
            NickNameEdit.Text := '';
        End;
        Inc(I);
    End;
    if Length(NickNameEdit.Text) < 1 then
        PlayButton.Enabled := False
    Else
        PlayButton.Enabled := True;

end;

procedure TLoginForm.NickNameEditKeyPress(Sender: TObject; var Key: Char);
begin
    if Not (Key In SET_OF_ALPHABET) then
        Key := #0;
end;

procedure TLoginForm.PlayButtonClick(Sender: TObject);
begin
    Setupform.ShowModal;
    //LoginForm.Hide;
end;

procedure TLoginForm.SpeedButton1Click(Sender: TObject);
begin
    MessageBox(0, 'Введите свой никнейм, только латиница принимается', 'Информация', MB_ICONINFORMATION);
end;

procedure TLoginForm.Timer1Timer(Sender: TObject);
begin
    LoginForm.Width := 637 * 2;
    LoginForm.Height := 415 * 2;
end;

end.
