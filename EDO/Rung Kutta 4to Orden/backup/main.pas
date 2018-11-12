unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, KuttaClass;

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
var Kutta4 : TKutta4;
begin
  Kutta4 := TKutta4.Create;
  Kutta4.Parse.Expression := EdiDF.Text;
  Kutta4.x := StrToFloat(EdiX.Text);
  Kutta4.y := StrToFloat(EdiY.Text);
  Kutta4.xn := StrToFloat(EdiXN.Text);

  ShowMessage(Kutta4.execute());
  Kutta4.Destroy;

end;

end.

