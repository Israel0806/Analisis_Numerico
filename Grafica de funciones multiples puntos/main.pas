unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, TATools,
  Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Frame, Types, TAChartUtils, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    BEjectuar: TButton;
    BF1: TButton;
    BF2: TButton;
    ButtonReset: TButton;
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
    procedure ButtonResetClick(Sender: TObject);
    procedure DatapointClick1PointClick(ATool: TChartTool; APoint: TPoint);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PanDragAfterMouseUp(ATool: TChartTool; APoint: TPoint);
  private
    Parse : TParseMath;
    ButtonPressed : Boolean;
    GraphicFrame: Array of TFrameFunc;
    function f( x : Real ) : Real;
    procedure Intersec( _x1: Real; _x2: Real );
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

procedure TForm1.Intersec( _x1: Real; _x2: Real);
var n, i : Integer;
    limit : String;
    raizCount : Integer = 0;
    cond : Boolean;
    a, b, Error, xn, x, xi, NewError, interval : Real;
    raices : array[0..100] of Real;
begin
  if  (EdiF1.Text = '') or (EdiF2.Text = '') or (MaxPos = 0) then
     exit;
  interval := 0.1;
  Error := 0.0001;

  Parse := TParseMath.create;
  Parse.AddVariable('x',0);
  Parse.AddVariable('e',2.7182818284);
  Parse.Expression := EdiF1.Text + '-(' + EdiF2.Text + ')';
  //ShowMessage( FloatToStr(Chart1.BottomAxis.Position) );

  x1 := _x1-20;
  x2 := _x1+20;
  //ShowMessage(FloatToStr(x1) + ' ' + FloatToStr(x2));
  xi := x1;

  limit := Copy(Parse.Expression,Pos('l',Parse.Expression),2);
  if limit <> 'ln' then
    limit := Copy(Parse.Expression,Pos('s',Parse.Expression),4);

  if (limit = 'ln') or (limit = 'sqrt') then
  begin
    xi := 0.00001;
  end;

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
    if (abs(f(x))>0.0001) then
        continue;

    if (raizCount <> 0) then
    begin
       cond := false;
       for i := 0 to raizCount do
       begin
          if (abs(raices[i] - x)<0.2) then
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
  until ((xi >= x2) or (raizCount >= 1000));

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

procedure TForm1.BEjectuarClick(Sender: TObject);
begin
  ButtonPressed := True;
  Intersec(x1,x2);
end;

procedure TForm1.PanDragAfterMouseUp(ATool: TChartTool; APoint: TPoint);
var pg: TDoublePoint;
begin
  if (ButtonPressed = False) then
    exit;
  pg := Chart1.ImageToGraph(Apoint);
  ShowMessage(FloatToStr(pg.X));
  Intersec(pg.X,pg.X);
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
   ButtonPressed := False;
end;

procedure TForm1.BF2Click(Sender: TObject);
begin
  EdiF2.Caption := '';
  assignedf2 := false;
  ButtonPressed := False;
end;

procedure TForm1.ButtonResetClick(Sender: TObject);
var i: Integer;
begin
  if MaxPos = 0 then exit;
  for i:= 0 to Length( GraphicFrame ) - 1  do
  begin
      if Assigned( GraphicFrame[ i ] ) then
      begin
         GraphicFrame[ i ].Destroy;
         Chart1.Series[Chart1.SeriesCount-1].Destroy;
      end;
  end;

  EdiF1.Text := '';
  EdiF2.Text := '';

  Points.Clear;
  MaxPos := -1;
  AddGraphic;
  assignedf1 := false;
  assignedf2 := false;

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
  ButtonPressed := False;
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

