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
    EdiF: TEdit;
    Func: TFuncSeries;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    LabelIt: TLabel;
    LabelResult: TLabel;
    Num1: TEdit;
    Num2: TEdit;
    StringGrid1: TStringGrid;
    TError: TEdit;
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

function TForm1.f( x : Real ) : Real;
begin
  parse.NewValue('x',x);
  Result := parse.Evaluate();
  //Result := Sqr(x) - LN(x) - Sin(x) - x;
  //Result := (x* LN(x) - Exp(x) + 0.1)/(5-x)+1;
  //Result := Cos(x) - x;
end;

{$R *.lfm}

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
  // Cabecera
  SL.Add('N'); SL.Add('X'); SL.Add('Error');
  StringGrid1.ColCount := SL.Count;
  StringGrid1.Rows[0].Assign(SL);

  a := StrToFloat ( Num1.Text);
  b := StrToFloat ( Num2.Text);
  Error := StrToFloat (TError.Text);

  n := 0;

  if f(a)*f(b)<0 then
  begin
     x := a-( ( f(a)*(b-a) ) / ( f(b)-f(a) ) );

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
       x := a-( ( f(a)*(b-a) ) / ( f(b)-f(a) ) );

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

    LabelResult.Caption := 'Valor Aproximado: -';
    LabelIt.Caption := 'Iteraciones: -';
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

