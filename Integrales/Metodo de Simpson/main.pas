unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  simpson;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edia: TEdit;
    Edib: TEdit;
    Edif: TEdit;
    Edin: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
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
var Simpson : TSimpson;
begin
  Simpson := TSimpson.Create;
  Simpson.a := StrToFloat(Edia.Text);
  Simpson.b := StrToFloat(Edib.Text);
  Simpson.n := StrToInt(Edin.Text);
  Simpson.Parse.Expression := Edif.Text;
  Memo1.Lines.Add('La integral es aprox. = ' + FloatToStr(Simpson.execute()));
  Simpson.Destroy;
end;

end.

