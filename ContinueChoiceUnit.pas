unit ContinueChoiceUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TContinueChoiceForm = class(TForm)
    DecideLabel: TLabel;
    ButtonYes: TButton;
    ButtonNo: TButton;
    procedure ButtonYesClick(Sender: TObject);
    procedure ButtonNoClick(Sender: TObject);
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ContinueChoiceForm: TContinueChoiceForm;

implementation

Uses
    Unit5;

{$R *.dfm}

procedure TContinueChoiceForm.ButtonNoClick(Sender: TObject);
begin
    EndLessGame := False;
    ContinueChoiceForm.Close;
    PlayForm.Close;
end;

procedure TContinueChoiceForm.ButtonYesClick(Sender: TObject);
begin
    EndLessGame := True;
    ContinueChoiceForm.Close;
end;

function TContinueChoiceForm.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
    callHelp := False;
    result := False;
end;

end.
