unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  trapecio;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edif: TEdit;
    Edia: TEdit;
    Edib: TEdit;
    Edih: TEdit;
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
var Trapecio : TTrapecio;
begin
  Trapecio := TTrapecio.Create;
  Trapecio.a := StrToFloat(Edia.Text);
  Trapecio.b := StrToFloat(Edib.Text);
  Trapecio.h := StrToFloat(Edih.Text);
  Trapecio.Parse.Expression := Edif.Text;

  Memo1.Lines.Add( FloatToStr(Trapecio.execute()) );
  Trapecio.Destroy;

end;

end.

