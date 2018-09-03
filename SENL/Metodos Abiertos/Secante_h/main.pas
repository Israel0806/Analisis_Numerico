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
    Label3: TLabel;
    LabelIt: TLabel;
    LabelResult: TLabel;
    Num1: TEdit;
    TError: TEdit;
    TGrid: TStringGrid;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

function f( x : Real ) : Real;
begin
  //Result := Sqr(x) - LN(x) - Sin(x) - x;
  Result := Cos(x);
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var SL : TStringList;
    x, xn, h, NewError, Error : Real;
    n : Integer = 0;
begin
  SL := TStringList.create;
  TGrid.Clear;
  SL.Add('N'); SL.Add('X'); SL.Add('Error');
  TGrid.ColCount := SL.Count;
  TGrid.Rows[0].Assign(SL);

  x := StrToFloat( Num1.Text );
  Error := StrToFloat ( TError.Text );
  h := Error/10;

  SL.Clear;
  SL.Add( FloatToStr(n) );
  SL.Add( FloatToStr(x) );
  SL.Add( '-' );
  TGrid.RowCount := 2;
  TGrid.Rows[n+1].Assign(SL);

  repeat
    n := n + 1;
    xn := x;
    x := x - ( ( 2*h*f(x) ) / ( f(x+h) - f(x-h) ) );
    NewError := abs( xn - x );

    SL.Clear;
    SL.Add( FloatToStr(n) );
    SL.Add( FloatToStr(x) );
    SL.Add( FloatToStr(NewError) );
    TGrid.RowCount := TGrid.RowCount + 1;
    TGrid.Rows[n+1].Assign(SL);

  until NewError <= Error;

  LabelResult.Caption := 'Valor Aproximado: ' + FloatToStr(x);
  LabelIt.Caption := 'Iteraciones: ' + FloatToStr(n);


  SL.Destroy;

end;

end.

