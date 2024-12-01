unit SetupAmountU;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TSetupAmountForm = class(TForm)
    AmountTrackBar: TTrackBar;
    AmountLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SaveChanges: TButton;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure SaveChangesClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetupAmountForm: TSetupAmountForm;

implementation

Uses
    MenuUnit;

{$R *.dfm}

procedure TSetupAmountForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    SetupAmountForm.Hide;
    SetupForm.Show;
end;

procedure TSetupAmountForm.FormCreate(Sender: TObject);
begin
    AmountLabel.Caption := 'Выберите какое количество случайных чисел ' + #13#10 + 'будет появляться каждый ход';
end;

function TSetupAmountForm.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
    callHelp := False;
    result := False;
end;

procedure TSetupAmountForm.SaveChangesClick(Sender: TObject);
begin
    SetupAmountForm.Hide;
    SetupForm.Show;
end;

end.
