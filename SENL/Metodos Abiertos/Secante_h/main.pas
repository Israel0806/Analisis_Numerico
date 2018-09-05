unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, Grids, StdCtrls, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Chart1LineSeries1: TLineSeries;
    ediF: TEdit;
    Func: TFuncSeries;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
    parse : TParseMath;
    function f( x : Real ) : Real;

  public

  end;

var
  Form1: TForm1;

implementation

function TForm1.f( x : Real ) : Real;
begin
  parse.NewValue('x',x);
  Result := parse.Evaluate();
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var SL : TStringList;
    x, xn, h, NewError, Error : Real;
    n : Integer = 0;
begin
  parse.Expression := ediF.Text;

  Func.Active := False;
  Func.Active := True;

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

  Chart1LineSeries1.Clear;
  Chart1LineSeries1.Active := False;
  Chart1LineSeries1.ShowLines := False;
  Chart1LineSeries1.ShowPoints := True;
  Chart1LineSeries1.AddXY( x,f(x) );
  Chart1LineSeries1.Active := True;

  LabelResult.Caption := 'Valor Aproximado: ' + FloatToStr(x);
  LabelIt.Caption := 'Iteraciones: ' + FloatToStr(n);


  SL.Destroy;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  parse := TParseMath.create;
  parse.AddVariable('x',0);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  parse.destroy;
end;

procedure TForm1.FuncCalculate(const AX: Double; out AY: Double);
begin
  AY := f(AX);
end;

end.

