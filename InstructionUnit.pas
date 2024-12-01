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
    InstructionLabel.Caption := '1. Цель игры: Ваша цель - достичь плитки со значением 2048 на игровом поле.' + #13#10 + '2. Игровое поле: Игровое поле представляет собой квадрат, на котором отображаются ' + #13#10 + 'числовые плитки.' + #13#10 + '3. Движение: Вы можете перемещать плитки в четырех направлениях: вверх, вниз, ' + #13#10 + 'влево и вправо. Для этого используйте клавиши со стрелками на клавиатуре. ';
    InstructionLabel2.Caption := '4. Слияние плиток: Когда две плитки с одинаковыми числовыми значениями сталкиваются ' + #13#10 + 'во время движения, они объединяются в одну плитку.' + #13#10 + '5. Нельзя удалять файлы из папки с игровыми файлами.' + #13#10 + '6. Разрешено изменять иконки чисел на свои. Для этого нужно вставить свои иконки размером' + #13#10 + '55х55 пикселей с сохранением прежних названий и расширений картинок.' + #13#10;
    InstructionLabel3.Caption := '7. Ходы: После каждого хода на игровом поле появляется новая плитка со значением 2 или 4.' + #13#10 +'Плитки появляются на случайных пустых ячейках.' + #13#10 + '8. Завершение игры: Игра завершается, когда заполняется весь игровой квадрат, и вы не ' + #13#10 + 'можете сделать больше ходов. ' + #13#10 + '9. Очки: Ваш счет увеличивается с каждым успешным объединением плиток. Постарайтесь ' + #13#10 + 'набрать как можно больше очков!';

end;

end.
