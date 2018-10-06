unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, Forms, Controls, Graphics,
  Dialogs, Grids, ExtCtrls, StdCtrls, Funcs;

type

  { TForm1 }

  TForm1 = class(TForm)
    BEjecutar: TButton;
    Chart1: TChart;
    EdiPoints: TEdit;
    Grid1: TStringGrid;
    HorizontalLine: TConstantLine;
    Label1: TLabel;
    Memo1: TMemo;
    PanelGrid: TPanel;
    PanelPoints: TPanel;
    PanelChart: TPanel;
    VerticalLine: TConstantLine;
    procedure BEjecutarClick(Sender: TObject);
    procedure EdiPointsChange(Sender: TObject);
  private
    Func : array of TFuncs;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BEjecutarClick(Sender: TObject);
var n,i : Integer;
    h,u,_b,v,z,A,B,C : array of Real;
    S : array of String;
begin
  Memo1.Lines.Clear;
  n := StrToInt(EdiPoints.Text) - 1;
  SetLength(Func,n+1);
  SetLength(h,n+1);
  SetLength(_b,n+1);
  SetLength(u,n+1);
  SetLength(v,n+1);
  SetLength(z,n+1);
  SetLength(A,n+1);
  SetLength(B,n+1);
  SetLength(C,n+1);
  SetLength(S,n+1);

  for i := 0 to n - 1 do
  begin
    h[i] := StrToFloat(Grid1.Cells[i+2,1]) - StrToFloat(Grid1.Cells[i+1,1]);
    _b[i] := 6*(StrToFloat(Grid1.Cells[i+2,2]) - StrToFloat(Grid1.Cells[i+1,1]))/h[i];
    Memo1.Lines.Add( 'h[' + IntToStr(i) + '] = ' + FloatToStr(h[i]));
  end;
  u[0] := 2*(h[0]+h[1]);
  v[0] := _b[1]-_b[0];
  for i := 1 to n - 1 do
  begin
    u[i] := 2*(h[i]+h[i-1])-Sqr(h[i-1])/u[i-1];
    v[i] := _b[i]-_b[i-1]-h[i-1]*v[i-1]/u[i-1];
  end;

  z[n] := 0;

  for i := n-1 downto 1 do
  begin
    z[i] := (v[i]-h[i]*z[i+1])/u[i];
    Memo1.Lines.Add(  'z[' + IntToStr(i) + '] = ' + FloatToStr(z[i]));
  end;
  z[0] := 0;
  for i := 0 to n-1 do
  begin
  //ShowMessage('z1: ' + FloatTostr(z[i+1]));
  //ShowMessage('z: ' + FloatTostr(z[i]));
  //ShowMessage('h: ' + FloatTostr(h[i]));
    A[i] := (z[i+1]-z[i])/(6*h[i]);
    B[i] := z[i]/2;
    C[i] := -((h[i]*z[i+1])/6)-((h[i]*z[i])/3)+((StrToFloat(Grid1.Cells[i+2,2])-StrToFloat(Grid1.Cells[i+1,2]))/h[i]);
  end;

  for i := 0 to n - 1 do
  begin
    S[i] := Grid1.Cells[i+1,2] + '+(x-' + Grid1.Cells[i+1,1] + ')*(' + FloatToStr(C[i]) + '+(x-' + Grid1.Cells[i+1,1] + ')*(' + FloatToStr(B[i]) + '+(x-' + Grid1.Cells[i+1,1] + ')*' + FloatToStr(A[i]) + '))';
    Func[i] := TFuncs.Create;
    Func[i].CreateGraph(n,i+1,S[i]);
    //Memo1.Lines.Add('S[i]= ' + FloatToStr(Func[i].Parse.Evaluate()));
    Memo1.Lines.Add(S[i]);
  end;
end;

procedure TForm1.EdiPointsChange(Sender: TObject);
var n,code : Integer;
begin
  Val(EdiPoints.Text, n,code);
  Grid1.ColCount := n + 1;
end;

end.

