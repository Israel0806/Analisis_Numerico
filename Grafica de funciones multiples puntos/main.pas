unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, TATools,
  TASources, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Grids,
  Frame, Types, TAChartUtils, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    BEjectuar: TButton;
    BF1: TButton;
    BF2: TButton;
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Chart1LineSeries1: TLineSeries;
    DataPointClick: TDataPointClickTool;
    DatapointClick1: TDataPointClickTool;
    EdiF1: TEdit;
    EdiF2: TEdit;
    Func: TFuncSeries;
    Label1: TLabel;
    Label2: TLabel;
    ScrollBox1: TScrollBox;
    ZoomMouseWheel: TZoomMouseWheelTool;
    PanDrag: TPanDragTool;
    DragTool: TZoomDragTool;
    Panel2: TPanel;
    Panel3: TPanel;
    ToolSet: TChartToolset;
    Panel1: TPanel;
    PFuncs: TPanel;
    procedure BEjectuarClick(Sender: TObject);
    procedure BF1Click(Sender: TObject);
    procedure BF2Click(Sender: TObject);
    procedure DatapointClick1PointClick(ATool: TChartTool; APoint: TPoint);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FuncCalculate(const AX: Double; out AY: Double);
    procedure ScrollBar1Change(Sender: TObject);

  private
    Parse : TParseMath;
    GraphicFrame: Array of TFrameFunc;
    function f( x : Real ) : Real;
  public
    f1, f2 : string;
    assignedf1 : Boolean;
    assignedf2 : Boolean;
    x1, x2 : Real;
    MaxPos, ActualPos : Integer;
    procedure AddGraphic;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.f( x : Real ) : Real;
begin
   Parse.NewValue('x',x);
   Result := Parse.Evaluate();
end;

procedure TForm1.FuncCalculate(const AX: Double; out AY: Double);
begin

end;

procedure TForm1.ScrollBar1Change(Sender: TObject);
begin

end;

procedure TForm1.AddGraphic;
begin
   MaxPos := MaxPos + 1;
   SetLength( GraphicFrame, MaxPos + 1 );
   GraphicFrame[MaxPos] := TFrameFunc.Create(PFuncs);
   GraphicFrame[MaxPos].Name := 'GF' + IntToStr(MaxPos);
   GraphicFrame[MaxPos].parent := ScrollBox1;
   GraphicFrame[MaxPos].Align:= alTop;
   GraphicFrame[MaxPos].Tag := MaxPos;
end;

procedure TForm1.BF1Click(Sender: TObject);
begin
   EdiF1.Caption := '';
   assignedf1 := false;
end;

procedure TForm1.BF2Click(Sender: TObject);
begin
  EdiF2.Caption := '';
  assignedf2 := false;
end;

procedure TForm1.BEjectuarClick(Sender: TObject);
var n, i : Integer;
    raizCount : Integer = 0;
    cond : Boolean;
    Error, h, x, xi, xn, NewError : Real;
    interval : Real = 1;
    raices : array[0..100] of Real;
begin
  if not (EdiF1.Text <> '') or not (EdiF2.Text <> '') then
     exit;

  Error := 0.0001;
  h := 0.00001;

  Parse := TParseMath.create;
  Parse.AddVariable('x',0);
  Parse.Expression := EdiF1.Text + '-(' + EdiF2.Text + ')';
  xi := x1-20;

  repeat
    x := xi;
    n := 0;
    repeat
      xn := x;
      if ( f(x+h) - f(x-h) = 0 ) then
      begin
        ShowMessage('No existe una interseccion real');
        exit;
      end;
      x := x - ( ( 2*h*f(x) ) / ( f(x+h) - f(x-h) ) );
      NewError := abs(x - xn);
      n := n + 1;

    until (NewError <= Error) or (n >= 100);
    xi := xi + interval;
    if (abs(f(x))>0.001) then
    begin
        continue;
    end;
    if (raizCount <> 0) then
    begin
       cond := false;
       for i := 0 to raizCount do
       begin
          if (abs(raices[i] - x)<0.1) then
          begin
             cond := true;
          end;
       end;
       if cond = false then
       begin
          raices[raizCount] := x;
          //ShowMessage('Nueva x: ' + FloatToStr(raices[raizCount]) + LineEnding + IntToStr(raizCount));
          raizCount := raizCount + 1;
       end;
    end
    else
    begin
       raices[0] := x;
       //ShowMessage('Nueva xx: ' + FloatToStr(x) + LineEnding + IntToStr(raizCount));
       raizCount := 1;
    end;
  until (xi >= x2 + 20) or (raizCount >= 100);


  assignedf1 := false;
  assignedf2 := false;
  EdiF1.Caption := '';
  EdiF2.Caption := '';

  Parse.Expression := EdiF1.Text;

  Chart1LineSeries1.Clear;
  Chart1LineSeries1.Active := False;

  if (raizCount = 0) then
    begin
      ShowMessage('No existe una interseccion real');
      exit;
    end;

  Chart1LineSeries1.ShowLines := False;
  Chart1LineSeries1.ShowPoints := True;
  //ShowMessage('raices: ' + IntToStr(raizCount));
  for i := 0 to raizCount-1 do
  begin
     Chart1LineSeries1.AddXY( raices[i],f(raices[i]) );
     Chart1LineSeries1.SetText(i,'x = ' + FloatToStr(raices[i]) + ' ' + IntToStr(i))
  end;
  Chart1LineSeries1.Active := True;


end;

procedure TForm1.DatapointClick1PointClick(ATool: TChartTool; APoint: TPoint);
var
  //Expression : string;
  pg: TDoublePoint;
begin
  pg := Chart1.ImageToGraph(Apoint);
  with ATool as TDatapointClickTool do
    if (Series is TFuncSeries) then
    begin
       if assignedf1 = false then
       begin
          if EdiF2.Text <> GraphicFrame[ TFuncSeries(Series).Tag ].Edit1.Text then
          begin
             x1 := pg.X;
             f1 := GraphicFrame[ TFuncSeries(Series).Tag ].Edit1.Text;
             EdiF1.Caption := f1;
             assignedf1 := true;
          end;

       end
       else
       begin
          if assignedf2 = false then
          begin
            if EdiF1.Text <> GraphicFrame[ TFuncSeries(Series).Tag ].Edit1.Text then
            begin
              x2 := pg.X;
              f2 := GraphicFrame[ TFuncSeries(Series).Tag ].Edit1.Text;
              EdiF2.Caption := f2;
              assignedf2 := true;
            end;

          end;
       end;
       //Expression := GraphicFrame[ TFuncSeries(Series).Tag ].Edit1.Text;
       //Memo1.Lines.Add('f(x) = ' + Expression + '   Puntos: ' + FloatToStr(pg.X) + ', ' + FloatToStr(pg.Y));
    end;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MaxPos := -1;
  AddGraphic;
  assignedf1 := false;
  assignedf2 := false;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var i: Integer;
begin
  for i:= 0 to Length( GraphicFrame ) - 1 do
      if Assigned( GraphicFrame[ i ] ) then
         GraphicFrame[ i ].Destroy;
end;

end.

