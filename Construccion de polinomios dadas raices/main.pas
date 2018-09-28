unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, StdCtrls, Menus, Grids, Frame, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    BEjecutar: TButton;
    BReset: TButton;
    Chart1: TChart;
    Func: TFuncSeries;
    Grid: TStringGrid;
    HorizontalLine: TConstantLine;
    LabelRaices: TLabel;
    LabelRpta: TLabel;
    Panel1: TPanel;
    PanelGrafica: TPanel;
    PanelBReset: TPanel;
    PanelFrames: TPanel;
    PanelClient: TPanel;
    Points: TLineSeries;
    ScrollBox1: TScrollBox;
    ScrollFrame: TScrollBox;
    VerticalLine: TConstantLine;

    procedure BEjecutarClick(Sender: TObject);
    procedure BResetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FuncCalculate(const AX: Double; out AY: Double);
  private
    Parse : TParseMath;
    Roots : array of TRaices;

    function f( x : Real ) : Real;
  public
    FrameCount : Integer;
    procedure AddRoot;
  end;

var
  Form1: TForm1;

implementation

function TForm1.f( x : Real ) : Real;
begin
  Parse.NewValue('x',x);
  Result := Parse.evaluate();
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.AddRoot;
begin
  FrameCount := FrameCount + 1;
  SetLength( Roots, FrameCount + 1 );
  Roots[FrameCount] := TRaices.Create(PanelFrames);
  Roots[FrameCount].Align := alTop;
  Roots[FrameCount].Name := 'Root' + IntToStr(FrameCount);
  Roots[FrameCount].Parent := ScrollFrame;
  Roots[FrameCount].Tag := FrameCount;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Parse := TParseMath.create;
  Parse.AddVariable('x',0);
  FrameCount := -1;
  AddRoot;
end;

procedure TForm1.BResetClick(Sender: TObject);
var i : Integer;
begin
  for i:= 0 to FrameCount do
  begin
    Roots[i].Destroy;
  end;
  Grid.Clean;
  Func.Active := False;
  Points.Clear;
  LabelRpta.Caption := '';
  FrameCount:= -1;
  AddRoot;
end;

procedure TForm1.BEjecutarClick(Sender: TObject);
var i,j : Integer;
begin
  Grid.Clean;
  Points.Clear;
  Func.Active := False;
  LabelRpta.Caption := '';

  Grid.RowCount := FrameCount + 1;
  Grid.ColCount := FrameCount + 1;
  Grid.Width := 80*(FrameCount + 1);
  Grid.Height := 30*(FrameCount + 1);
  for i := 0 to FrameCount do
  begin
    for j := 0 to i do
    begin
      if i = j then
      begin
        Grid.Cells[j,i] := '1';
        continue;
      end;

      Grid.Cells[j,i] := FloatToStr( -Roots[i-1].root*StrToFloat(Grid.Cells[j,i-1]) );
      if j <> 0 then
        Grid.Cells[j,i] := FloatToStr( StrToFloat(Grid.Cells[j,i])+StrToFloat(Grid.Cells[j-1,i-1]) );

    end;
  end;
  Parse.Expression := '';
  LabelRpta.Caption := '';
  for i := FrameCount downto 0 do
  begin
    if i = 0 then
    begin
      LabelRpta.Caption := LabelRpta.Caption + Grid.Cells[i,FrameCount];
      Parse.Expression := Parse.Expression + Grid.Cells[i,FrameCount];
    end
    else
    begin
      LabelRpta.Caption := LabelRpta.Caption + Grid.Cells[i,FrameCount] + 'x^' + IntToStr(i) + ' + ';
      Parse.Expression := Parse.Expression + Grid.Cells[i,FrameCount] + '*x^' + IntToStr(i) + '+';
    end;
  end;

  Points.Clear;
  Points.ShowLines := False;
  Points.ShowPoints := True;
  for i := 0 to FrameCount - 1 do
  begin
    Points.AddXY(Roots[i].root,0);
    Points.SetText(i,'x: ' + FloatToStr(Roots[i].root) );
  end;

  Func.Active := True;

end;

procedure TForm1.FormDestroy(Sender: TObject);
var i : Integer;
begin
  for i := 0 to FrameCount do
  begin
    Roots[i].Destroy;
  end;
end;

procedure TForm1.FuncCalculate(const AX: Double; out AY: Double);
begin
  AY := f(AX);
end;

end.

