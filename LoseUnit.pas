unit LoseUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  TLoseForm = class(TForm)
    LoseLabel: TLabel;
    LoseButton: TButton;
    Image1: TImage;
    BetterLuckLabel: TLabel;
    procedure FormShow(Sender: TObject);
    procedure LoseButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoseForm: TLoseForm;

implementation

Uses
    Unit5;

{$R *.dfm}

Procedure ConfirmLose();
Begin
    LoseForm.Close;
    PlayForm.RestartButton.Click;
End;

procedure TLoseForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    ConfirmLose();
end;

function TLoseForm.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
    callHelp := False;
    result := False;
end;

procedure TLoseForm.FormShow(Sender: TObject);
begin
    LoseLabel.Caption := 'Вы проиграли. Ваш счет: ' + PlayForm.ScoreIntLabel.Caption;
end;

procedure TLoseForm.LoseButtonClick(Sender: TObject);
begin
    ConfirmLose();
end;

end.
