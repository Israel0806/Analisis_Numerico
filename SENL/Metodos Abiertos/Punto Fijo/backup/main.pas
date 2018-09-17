unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, StdCtrls, Grids, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    ChartLine: TLineSeries;
    ediG: TEdit;
    ediF: TEdit;
    Func: TFuncSeries;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LabelIt: TLabel;
    LabelResult: TLabel;
    Num1: TEdit;
    TError: TEdit;
    TGrid: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FuncCalculate(const AX: Double; out AY: Double);

  private
    Parsef : TParseMath;
    Parseg : TParseMath;
    function f( x : Real ) : Real;
    function g( x : Real ) : Real;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


procedure TForm1.Button1Click(Sender: TObject);
var n : Integer = 0;
    x, xn, NewError, Error : Real;
    SL : TStringList;
begin
  Func.Active := False;
  Func.Active := True;

  SL := TStringList.create;
  Parsef.Expression := EdiF.Text;
  Parseg.Expression := EdiG.Text;
  x := StrToFloat(Num1.Text);
  Error := StrToFloat(TError.Text);

  SL.Clear;
  TGrid.Clear;
  SL.Add('N'); SL.Add('X'); SL.Add('Error');
  TGrid.RowCount := 2;
  TGrid.Rows[0].Assign(SL);

  SL.Clear;
  SL.Add( FloatToStr(n) );
  SL.Add( FloatToStr(x) );
  SL.Add( FLoatToStr( g(x)) );
  TGrid.Rows[n+1].Assign(SL);

  repeat
    n := n +1;
    xn := x;
    x := g(x);
    NewError := abs( xn - x );

    SL.Clear;
    SL.Add( FloatToStr(n) );
    SL.Add( FloatToStr(x) );
    SL.Add( FloatToStr(g(x)) );
    TGrid.RowCount := TGrid.RowCount + 1;
    TGrid.Rows[n+1].Assign(SL);

  until NewError <= Error;

  ChartLine.Clear;
  ChartLine.Active := False;
  ChartLine.ShowLines := False;
  ChartLine.ShowPoints := True;
  ChartLine.AddXY( x,f(x) );
  ChartLine.Active := True;

  LabelResult.Caption := 'Valor Aproximado: ' + FloatToStr(x);
  LabelIt.Caption := 'Iteraciones: ' + FloatToStr(n);

  SL.Destroy;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Parseg := TParseMath.Create;
  Parseg.AddVariable('x',0);
  Parseg.AddVariable('e',2.7182818284);
  Parsef := TParseMath.Create;
  Parsef.AddVariable('x',0);
  Parsef.AddVariable('e',2.7182818284);

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parsef.Destroy;
  Parseg.Destroy;
end;

procedure TForm1.FuncCalculate(const AX: Double; out AY: Double);
begin
  AY := f(AX);
end;

function TForm1.g(x: Real): Real;
begin
  Parseg.NewValue('x',x);
  Result := Parseg.Evaluate();
end;

function TForm1.f(x: Real): Real;
begin
  Parsef.NewValue('x',x);
  Result := Parsef.Evaluate();
end;

end.

