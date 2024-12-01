unit InstructionUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Imaging.pngimage,
  Vcl.ExtCtrls;

type
  TInstructionForm = class(TForm)
    InstructionLabel: TLabel;
    InstructionLabel2: TLabel;
    InstructionLabel3: TLabel;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    function FormHelp(Command: Word; Data: NativeInt;
      var CallHelp: Boolean): Boolean;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InstructionForm: TInstructionForm;

implementation

Uses
    MenuUnit;

{$R *.dfm}

procedure TInstructionForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    InstructionForm.Close;
end;

function TInstructionForm.FormHelp(Command: Word; Data: NativeInt;
  var CallHelp: Boolean): Boolean;
begin
    callHelp := False;
    result := False;
end;

procedure TInstructionForm.FormShow(Sender: TObject);
begin
    InstructionLabel.Caption := '1. ���� ����: ���� ���� - ������� ������ �� ��������� 2048 �� ������� ����.' + #13#10 + '2. ������� ����: ������� ���� ������������ ����� �������, �� ������� ������������ ' + #13#10 + '�������� ������.' + #13#10 + '3. ��������: �� ������ ���������� ������ � ������� ������������: �����, ����, ' + #13#10 + '����� � ������. ��� ����� ����������� ������� �� ��������� �� ����������. ';
    InstructionLabel2.Caption := '4. ������� ������: ����� ��� ������ � ����������� ��������� ���������� ������������ ' + #13#10 + '�� ����� ��������, ��� ������������ � ���� ������.' + #13#10 + '5. ������ ������� ����� �� ����� � �������� �������.' + #13#10 + '6. ��������� �������� ������ ����� �� ����. ��� ����� ����� �������� ���� ������ ��������' + #13#10 + '55�55 �������� � ����������� ������� �������� � ���������� ��������.' + #13#10;
    InstructionLabel3.Caption := '7. ����: ����� ������� ���� �� ������� ���� ���������� ����� ������ �� ��������� 2 ��� 4.' + #13#10 +'������ ���������� �� ��������� ������ �������.' + #13#10 + '8. ���������� ����: ���� �����������, ����� ����������� ���� ������� �������, � �� �� ' + #13#10 + '������ ������� ������ �����. ' + #13#10 + '9. ����: ��� ���� ������������� � ������ �������� ������������ ������. ������������ ' + #13#10 + '������� ��� ����� ������ �����!';

end;

end.
