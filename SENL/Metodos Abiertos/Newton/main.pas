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
    ediDF: TEdit;
    Func: TFuncSeries;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    LabelIt: TLabel;
    LabelResult: TLabel;
    Num1: TEdit;
    ediF: TEdit;
    TError: TEdit;
    TGrid: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FuncCalculate(const AX: Double; out AY: Double);
  private
    parse : TParseMath;
    parsedf : TParseMath;
    function f( x : Real ) : Real;
    function df( x : Real ) : Real;

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

function TForm1.df( x : Real ) : Real;
begin
  parsedf.NewValue('x',x);
  Result := parsedf.Evaluate();
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var SL : TStringList;
    xn, Error, NewError, x : Real;
    n : Integer = 0;
begin
  parse.Expression := ediF.Text;
  parsedf.Expression := ediDF.Text;

  Func.Active := False;
  Func.Active := True;

  SL := TStringList.create;
  TGrid.Clear;
  SL.Add('N'); SL.Add('X'); SL.Add('Error');
  TGrid.ColCount := SL.Count;
  TGrid.Rows[0].Assign(SL);
  TGrid.RowCount := 2;


  x := StrToFloat( Num1.Text );

  Error := StrToFloat( TError.Text );

  if df(x) = 0 then
    begin
      x := x + 0.1
    end;

  //x := x - f(x)/df(x);

  SL.Clear;
  SL.Add( FloatToStr(n) );
  SL.Add( FloatToStr(x) );
  SL.Add( '-' );
  TGrid.Rows[n+1].Assign(SL);

  repeat
     n := n + 1;
     xn := x;
     x := x - f(x)/df(x);

    if df(x) = 0 then
      begin
        x := x + 0.1
      end;
    NewError := abs( x - xn);

    SL.Clear;
    SL.Add( FloatToStr(n) );
    SL.Add( FloatToStr(x) );
    SL.Add( FloatToStr(NewError) );
    TGrid.RowCount := TGrid.RowCount + 1;
    TGrid.Rows[n+1].Assign(SL);

  until NewError <= Error ;

  Chart1LineSeries1.Clear;
  Chart1LineSeries1.Active := False;
  Chart1LineSeries1.ShowLines := False;
  Chart1LineSeries1.ShowPoints := False;
  Chart1LineSeries1.AddXY(x,f(x));

  Chart1LineSeries1.ShowPoints := True;
  Chart1LineSeries1.Active := True;

  LabelResult.Caption := 'Valor Aproximado: ' + FloatToStr(x);
  LabelIt.Caption := 'Iteraciones: ' + FloatToStr(n);

  SL.destroy;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  parse := TParseMath.create;
  parse.AddVariable('x',0);

  parsedf := TParseMath.create;
  parsedf.AddVariable('x',0);

end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  parse.destroy;
  parsedf.destroy;
end;

procedure TForm1.FuncCalculate(const AX: Double; out AY: Double);
begin
  AY := f(AX);
end;

end.

