unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ClassExponencial;

type

  { TForm1 }

  TForm1 = class(TForm)
    BEjecutar: TButton;
    EditExp: TEdit;
    EditError: TEdit;
    LabelAngulo: TLabel;
    LabelError: TLabel;
    MemoRpta: TMemo;
    procedure BEjecutarClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BEjecutarClick(Sender: TObject);
var Exp: TExp;
begin
   Exp := TExp.Create;
   Exp.x := StrToFloat( editExp.Text );
   Exp.error := StrToFloat ( editError.Text );
   memoRpta.Lines.Add( 'e^' + editExp.Text + ' = ' + FloatToStr ( Exp.exponencial() ) );
   Exp.Destroy;
end;

end.

