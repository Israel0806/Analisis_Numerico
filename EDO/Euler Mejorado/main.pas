unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,EulMejoradoClass;

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
var EulMejorado : TEulMejorado;
begin
  EulMejorado := TEulMejorado.Create;
  EulMejorado.x := StrToFloat(ediX.Text);
  EulMejorado.y := StrToFloat(ediY.Text);
  EulMejorado._xn := StrToFloat(EdiXN.Text);
  EulMejorado.Parse.Expression := ediDF.Text;

  EulMejorado.execute();

end;

end.

