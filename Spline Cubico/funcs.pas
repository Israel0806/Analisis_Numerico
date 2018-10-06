unit Funcs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, Grids, ParseMath, Math;

type
  TFuncs = class
    procedure CalculateFunc(const AX: Double; out AY: Double);
  private

    function f( x : Real ) : Real;
  public
    Serie : TFuncSeries;
    Parse : TParseMath;
    procedure CreateGraph(n : Integer;x : Integer; expression : String);

  end;

implementation

uses main;

procedure TFuncs.CalculateFunc(const AX: Double; out AY: Double);
begin
  AY := f(AX);
end;

function TFuncs.f( x : Real ) : Real;
begin
  Parse.NewValue('x',x);
  Result := Parse.Evaluate();
end;

procedure TFuncs.CreateGraph(n : Integer; x : Integer; expression : String);
begin
  with Form1 do
  begin
    Parse := TParseMath.create;
    Parse.AddVariable('x',0);
    Parse.Expression := expression;
    Serie := TFuncSeries.Create(Chart1);
    Chart1.AddSeries(Serie);
    Serie.Active := False;
    with Serie.DomainExclusions do
       begin
         AddRange(NegInfinity,StrToFloat(Grid1.Cells[x,1])-0.0001);
         AddRange(StrToFloat(Grid1.Cells[x+1,1])+0.0001,Infinity);
       end;
    Serie.OnCalculate := @CalculateFunc;

    Serie.Active := True;
  end;
end;

end.

