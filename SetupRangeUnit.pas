unit SetupRangeUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls;

type
  TSetupRangeForm = class(TForm)
    InfoRangeLabel: TLabel;
    RangeTrackBar: TTrackBar;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    SaveRangeSetup: TButton;
    Image1: TImage;
    procedure SaveRangeSetupClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SetupRangeForm: TSetupRangeForm;

implementation

Uses
    MenuUnit;

{$R *.dfm}

procedure TSetupRangeForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    SetupRangeForm.Hide;
    SetupForm.Show;
end;

function TSetupRangeForm.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
    callHelp := False;
    result := False;
end;

procedure TSetupRangeForm.SaveRangeSetupClick(Sender: TObject);
begin
    SetupRangeForm.Hide;
    SetupForm.Show;
end;

end.
