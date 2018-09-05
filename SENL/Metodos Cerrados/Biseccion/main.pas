unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries,
  TAIntervalSources, TAMultiSeries, TASources, Forms, Controls, Graphics,
  Dialogs, Grids, StdCtrls, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Chart1LineSeries1: TLineSeries;
    Func: TFuncSeries;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelResult: TLabel;
    LabelIt: TLabel;
    Num1: TEdit;
    Num2: TEdit;
    EdiF: TEdit;
    TError: TEdit;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FuncCalculate(const AX: Double; out AY: Double);
  private
    parse : TParseMath;
    function f( x : Real) : Real;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

function TForm1.f( x : Real ) : Real;
begin
  parse.NewValue('x', x );
  Result := parse.Evaluate();
  //Result := Sqr(x) - LN(x) - Sin(x) - x;
  //Result := power(x,3) + 4*Sqr(x) - 10;
end;


{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var SL : TStringList;
    n : Integer;
    NewError, a, b, x, Error : Real;
begin
  parse.Expression := EdiF.Text;
  Func.Active := False;
  Func.Active := True;

  StringGrid1.Clear;
  SL := TStringList.Create;
  SL.Add('N'); SL.Add('X'); SL.Add('Error');
  StringGrid1.ColCount := SL.Count;
  StringGrid1.Rows[0].Assign(SL);

  n := 0;

  a := StrToFloat ( Num1.Text);
  b := StrToFloat ( Num2.Text);
  Error := StrToFloat (TError.Text);
  if f(a)*f(b)<0 then
  begin
     x := (a+b)/2;

     SL.Clear;
     SL.Add( IntToStr(n) );
     //SL.Add( FloatToStr(a) );
     //SL.Add( FloatToStr(b) );
     SL.Add( FloatToStr(x) );
     SL.Add( '-' );
     StringGrid1.Rows[n+1].Assign(SL);
     StringGrid1.RowCount := 2;
     if f(a)*f(x) < 0 then
         b := x
     else
         a := x;
     repeat
       n := n + 1;
       NewError := x;
       x := (a+b)/2;
       if f(a)*f(x) < 0 then
           b := x
       else
           a := x;

       NewError := abs( NewError - x );

       SL.Clear;
       SL.Add( IntToStr(n) );
       //SL.Add( FloatToStr(a) );
       //SL.Add( FloatToStr(b) );
       SL.Add( FloatToStr(x) );
       SL.Add( FloatToStr(NewError) );
       StringGrid1.RowCount := StringGrid1.RowCount + 1;
       StringGrid1.Rows[n+1].Assign(SL);

     until (NewError <= Error);

     Chart1LineSeries1.Clear;
     Chart1LineSeries1.Active := False;
     Chart1LineSeries1.ShowLines:= False;
     Chart1LineSeries1.ShowPoints:= True;
     Chart1LineSeries1.AddXY( x, f(x) );
     Chart1LineSeries1.Active:= True;

     LabelResult.Caption := 'Valor Aproximado: ' + FloatToStr(x);
     LabelIt.Caption := 'Iteraciones: ' + FloatToStr(n);
  end
  else
  begin
    SL.Clear;
    SL.Add('naa');
    StringGrid1.Rows[1].Assign(SL);
  end;

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

