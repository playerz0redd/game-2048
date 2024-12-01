unit FieldSetupUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TFieldSetupForm = class(TForm)
    SizeInfoLabel: TLabel;
    FieldSizeTrackBar: TTrackBar;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SaveSizeSetup: TButton;
    Image1: TImage;
    procedure SaveSizeSetupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FieldSetupForm: TFieldSetupForm;

implementation

Uses
    MenuUnit;

{$R *.dfm}

procedure TFieldSetupForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    FieldSetupForm.Hide;
    SetupForm.Show;
end;

function TFieldSetupForm.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
    callHelp := False;
    result := False;
end;

procedure TFieldSetupForm.SaveSizeSetupClick(Sender: TObject);
begin
    FieldSetupForm.Hide;
    SetupForm.Show;
end;

end.
