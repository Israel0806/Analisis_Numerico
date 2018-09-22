unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, TATools,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Grids,
  Frame, Types, TAChartUtils, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    BEjectuar: TButton;
    BF1: TButton;
    BF2: TButton;
    Button1: TButton;
    Chart1: TChart;
    HorizontalLine: TConstantLine;
    VerticalLine: TConstantLine;
    Points: TLineSeries;
    DataPointClick: TDataPointClickTool;
    DatapointClick1: TDataPointClickTool;
    EdiF1: TEdit;
    EdiF2: TEdit;
    Func: TFuncSeries;
    Label1: TLabel;
    Label2: TLabel;
    oolSetZoomMouseWheelTool1: TZoomMouseWheelTool;
    Panel4: TPanel;
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
    procedure Button1Click(Sender: TObject);
    procedure DatapointClick1PointClick(ATool: TChartTool; APoint: TPoint);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PanDragAfterMouseUp(ATool: TChartTool; APoint: TPoint);
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



procedure TForm1.PanDragAfterMouseUp(ATool: TChartTool; APoint: TPoint);
var n, i : Integer;
    raizCount : Integer = 0;
    cond : Boolean;
    a, b, Error, xn, x, xi, NewError, interval : Real;
    raices : array[0..100] of Real;
    pg: TDoublePoint;
begin
  pg := Chart1.ImageToGraph(Apoint);
  if not (EdiF1.Text <> '') or not (EdiF2.Text <> '') then
     exit;
  interval := 0.1;
  Error := 0.0001;

  Parse := TParseMath.create;
  Parse.AddVariable('x',0);
  Parse.Expression := EdiF1.Text + '-(' + EdiF2.Text + ')';
  //ShowMessage( FloatToStr(Chart1.BottomAxis.Position) );

  x1 := pg.X-20;
  x2 := pg.X+20;
  //ShowMessage(FloatToStr(x1) + ' ' + FloatToStr(x2));
  xi := x1;
  repeat
    x := xi;
    a := xi;
    b := xi+0.1;
    n := 0;
    if( f(b)*f(a) < 0) then
    begin
      repeat
        if ( f(b)-f(a) = 0 ) then
        begin
          ShowMessage('No existe una interseccion real');
          exit;
        end;
        xn := x;
        x := a-( ( f(a)*(b-a) ) / ( f(b)-f(a) ) );

        if f(a)*f(x) < 0 then
           b := x
        else
           a := x;

        NewError := abs(x - xn);
        n := n + 1;

      until (NewError <= Error) or (n >= 1000);
    end;
    xi := xi + interval;
    if (abs(f(x))>0.001) then
        continue;

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
  until (xi >= x2) or (raizCount >= 1000);

  Parse.Expression := EdiF1.Text;

  Points.Clear;
  Points.Active := False;

  if (raizCount = 0) then
    begin
      ShowMessage('No existe una interseccion real');
      exit;
    end;

  Points.ShowLines := False;
  Points.ShowPoints := True;
  //ShowMessage('raices: ' + IntToStr(raizCount));
  for i := 0 to raizCount-1 do
  begin
     Points.AddXY( raices[i],f(raices[i]) );
     Points.SetText(i,'x = ' + FloatToStr(raices[i]) + ' ' + IntToStr(i))
  end;
  Points.Active := True;
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

procedure TForm1.Button1Click(Sender: TObject);
var i: Integer;
    VerticalLine1 : TConstantLine;
    HorizontalLine1 : TConstantLine;
begin
  for i:= 0 to Length( GraphicFrame ) - 1 do
      if Assigned( GraphicFrame[ i ] ) then
//         GraphicFrame[i].FuncSeries.Clear;
         GraphicFrame[ i ].Destroy;
  MaxPos := -1;
  AddGraphic;
  assignedf1 := false;
  assignedf2 := false;

end;

procedure TForm1.BEjectuarClick(Sender: TObject);
var n, i : Integer;
    raizCount : Integer = 0;
    cond : Boolean;
    a, b, Error, xn, x, xi, NewError, interval : Real;
    raices : array[0..100] of Real;
begin
  if not (EdiF1.Text <> '') or not (EdiF2.Text <> '') then
     exit;
  interval := 0.1;
  Error := 0.0001;

  Parse := TParseMath.create;
  Parse.AddVariable('x',0);
  Parse.Expression := EdiF1.Text + '-(' + EdiF2.Text + ')';

  //ShowMessage( FloatToStr(Chart1.BottomAxis.Position) );

  //ShowMessage(FloatToStr(x1) + ' ' + FloatToStr(x2));
   xi := x1-20;
  repeat
    x := xi;
    a := xi;
    b := xi+0.1;
    n := 0;
    if( f(b)*f(a) < 0) then
    begin
      repeat
        if ( f(b)-f(a) = 0 ) then
        begin
          ShowMessage('No existe una interseccion real');
          exit;
        end;
        xn := x;
        x := a-( ( f(a)*(b-a) ) / ( f(b)-f(a) ) );

        if f(a)*f(x) < 0 then
           b := x
        else
           a := x;

        NewError := abs(x - xn);
        n := n + 1;

      until (NewError <= Error) or (n >= 1000);
    end;
    xi := xi + interval;
    if (abs(f(x))>0.001) then
        continue;

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
  until (xi >= x2 + 20) or (raizCount >= 1000);

  Parse.Expression := EdiF1.Text;

  Points.Clear;
  Points.Active := False;

  if (raizCount = 0) then
    begin
      ShowMessage('No existe una interseccion real');
      exit;
    end;

  Points.ShowLines := False;
  Points.ShowPoints := True;
  //ShowMessage('raices: ' + IntToStr(raizCount));
  for i := 0 to raizCount-1 do
  begin
     Points.AddXY( raices[i],f(raices[i]) );
     Points.SetText(i,'x = ' + FloatToStr(raices[i]) + ' ' + IntToStr(i))
  end;
  Points.Active := True;
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

