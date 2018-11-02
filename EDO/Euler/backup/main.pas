unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, EulerClass;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    ediDF: TEdit;
    ediX: TEdit;
    ediXN: TEdit;
    ediY: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var Euler : TEuler;
begin
  Euler := TEuler.Create;
  Euler.x := StrToFloat(ediX.Text);
  Euler.y := StrToFloat(ediY.Text);
  Euler._xn := StrToFloat(EdiXN.Text);
  Euler.Parse.Expression := ediDF;

  Euler.execute();
end;

end.

