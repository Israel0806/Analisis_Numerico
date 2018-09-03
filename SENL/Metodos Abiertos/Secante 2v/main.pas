unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelIt: TLabel;
    LabelResult: TLabel;
    Num1: TEdit;
    Num2: TEdit;
    TError: TEdit;
    TGrid: TStringGrid;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function f( x : Real ) : Real;
begin
  Result := Cos(x);
  //Result := Sqr(x) - LN(x) - Sin(x) - x;
  //Result := Exp(x) - x - 1;
end;

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var SL : TStringList;
     x0, x1,x, NewError, Error : Real;
     n : Integer = 0;
begin
  SL := TStringList.create;

  TGrid.Clear;
  SL.Add('N'); SL.Add('X'); SL.Add('Error');
  TGrid.ColCount := SL.Count;
  TGrid.Rows[0].Assign(SL);

  x0 := StrToFloat( Num1.Text );
  x1 := StrToFloat( Num2.Text );
  Error := StrToFloat( TError.Text );


  TGrid.RowCount := 3;
  SL.Clear;
  SL.Add('0');
  SL.Add( FloatToStr(x0) );
  SL.Add('-');
  TGrid.Rows[1].Assign(SL);

  SL.Clear;
  SL.Add('1');
  SL.Add( FloatToStr(x1) );
  SL.Add( FloatToStr( abs(x1-x0) ) );
  TGrid.Rows[2].Assign(SL);
  n := 1;

  repeat
    n := n + 1;
    x := x1 - ( (x1 - x0)*f(x1) )/( f(x1) - f(x0) );
    NewError := abs( x1 - x );
    x1 := x;

    SL.Clear;
    SL.Add( FloatToStr(n) );
    SL.Add( FloatToStr(x) );
    SL.Add( FloatToStr( NewError ) );
    TGrid.RowCount := TGrid.RowCount + 1;
    TGrid.Rows[n+1].Assign(SL);

  until NewError <= Error ;


  LabelResult.Caption := 'Valor Aproximado: ' + FloatToStr(x);
  LabelIt.Caption := 'Iteraciones: ' + FloatToStr(n);
  SL.Destroy;
end;

end.

