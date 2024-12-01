program Game2048;

uses
  Vcl.Forms,
  Unit5 in 'Unit5.pas' {Form5},
  FieldSetupUnit in 'FieldSetupUnit.pas' {FieldSetupForm},
  LoginUnit in 'LoginUnit.pas' {LoginForm},
  MenuUnit in 'MenuUnit.pas' {SetupForm},
  SetupAmountU in 'SetupAmountU.pas' {SetupAmountForm},
  SetupRangeUnit in 'SetupRangeUnit.pas' {SetupRangeForm},
  Vcl.Themes,
  Vcl.Styles,
  ContinueChoiceUnit in 'ContinueChoiceUnit.pas' {ContinueChoiceForm},
  LoseUnit in 'LoseUnit.pas' {LoseForm},
  InstructionUnit in 'InstructionUnit.pas' {InstructionForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TPlayForm, PlayForm);
  Application.CreateForm(TFieldSetupForm, FieldSetupForm);
  Application.CreateForm(TSetupForm, SetupForm);
  Application.CreateForm(TSetupAmountForm, SetupAmountForm);
  Application.CreateForm(TSetupRangeForm, SetupRangeForm);
  Application.CreateForm(TContinueChoiceForm, ContinueChoiceForm);
  Application.CreateForm(TLoseForm, LoseForm);
  Application.CreateForm(TInstructionForm, InstructionForm);
  Application.Run;
end.
