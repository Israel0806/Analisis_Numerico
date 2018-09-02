unit Coseno;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  classCos;

type

  { TForm1 }

  TForm1 = class(TForm)
    BEjecutar: TButton;
    EditError: TEdit;
    EditAngulo: TEdit;
    LabelAngulo: TLabel;
    LabelErrror: TLabel;
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
var Main: TCos;
begin
   Main:= TCos.Create;
   Main.Error:= StrToFloat( editError.Text );
   Main.x:= StrToFloat( editAngulo.Text );
   memResult.Lines.Add( 'Cos(' + editAngulo.Text + ') = ' + FloatToStr( Main.cos() ) );
   Main.Destroy;
end;

end.

