unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, Grids, ParseMath, Funcs;

type

  { TForm1 }

  TForm1 = class(TForm)
    BEjecutar: TButton;
    Chart1: TChart;
    EdiPoints: TEdit;
    HorizontalLine: TConstantLine;
    Label1: TLabel;
    Memo1: TMemo;
    PanelClient: TPanel;
    PanelXnum: TPanel;
    PanelXs: TPanel;
    Grid1: TStringGrid;
    VerticalLine: TConstantLine;
    procedure BEjecutarClick(Sender: TObject);
    procedure EdiPointsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    Parse : TParseMath;
    Funcs : array of TFuncs;


  public
    pos : Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.EdiPointsChange(Sender: TObject);
begin
  if ( EdiPoints.Text = '' ) then
    exit;
  Grid1.ColCount := StrToInt(EdiPoints.Text) + 1;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Parse := TParseMath.create;
  Parse.AddVariable('x',0);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parse.Destroy;
end;

procedure TForm1.BEjecutarClick(Sender: TObject);
var x, i, n, j : Integer;
    l : array of String;
begin
  if Length(Funcs) < 0 then
  begin
    for i := 0 to Length(Funcs) do
      Funcs[i].Destroy;
  end;
  pos := -1;
  SetLength(Funcs,0);

  n := StrToInt(EdiPoints.Text);
  SetLength(l,n);

  x := 0;
  while x <= n - 1 do
  begin
    Parse.Expression := '';
    for i := x to x + 5 do
    begin
      if i >= n then
        break;
      l[i] := '';
      for j := x to x + 5 do
      begin
        if ( j = i ) or ( j >=n ) then
          Continue;
        if ( ((j = x + 5) or (j = n - 1) ) or ( (( j = x + 4) and ( i = x + 5 )) or (( j = n-2) and ( i = n-1 )) ) )  then
        begin
          l[i] := l[i] + '((x-' + Grid1.Cells[j+1,1] + ')/(' + Grid1.Cells[i+1,1] + '-' + Grid1.Cells[j+1,1] + '))';
          continue;
        end;
        l[i] := l[i] + '((x-' + Grid1.Cells[j+1,1] + ')/(' + Grid1.Cells[i+1,1] + '-' + Grid1.Cells[j+1,1] + '))*';
      end;
      if ( i = x + 5 ) or ( i = n - 1 ) then
      begin
        Parse.Expression := Parse.Expression + Grid1.Cells[i+1,2] + '*' + l[i];
      end
      else
        Parse.Expression := Parse.Expression + Grid1.Cells[i+1,2] + '*' + l[i] + '+';;

    end;
    Memo1.Lines.Add(Parse.Expression);



    pos := pos + 1;
    SetLength(Funcs,pos + 1);
    Funcs[pos] := TFuncs.Create;
    Funcs[pos].CreateGraph(n,x,Parse.Expression);

    {Funcs[pos].Serie := TFuncSeries.Create(Chart1);
    Chart1.AddSeries(Funcs[pos].Serie);
    Funcs[pos].Serie.OnCalculate := @CalculateFunc;
    Funcs[pos].Serie.Active := False;
    Funcs[pos].Serie.Active := True;  }




    x := x + 4;
    if x = n then
      exit;
    x := x-1;
    if x >= n -1 then
    begin
      //ShowMessage('entro');
      x := n - 4;
    end;

  end;
end;

end.

