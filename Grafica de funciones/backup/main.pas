unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, ExtCtrls, Frame;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Func: TFuncSeries;
    Panel1: TPanel;
    PFuncs: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FuncCalculate(const AX: Double; out AY: Double);
  private
    GraphicFrame: Array of TFrameFunc;



  public
    MaxPos, ActualPos : Integer;
    procedure AddGraphic;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FuncCalculate(const AX: Double; out AY: Double);
begin

end;

procedure TForm1.AddGraphic;
begin
   MaxPos := MaxPos + 1;
   SetLength( GraphicFrame, MaxPos + 1 );
   GraphicFrame[MaxPos] := TFrameFunc.Create(PFuncs);
   GraphicFrame[MaxPos].Name := 'GF' + IntToStr(MaxPos);
   GraphicFrame[MaxPos].parent := PFuncs;
   GraphicFrame[MaxPos].Align:= alTop;
   GraphicFrame[MaxPos].Tag := MaxPos;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  MaxPos := -1;
  AddGraphic;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var i: Integer;
begin
  for i:= 0 to Length( GraphicFrame ) - 1 do
      if Assigned( GraphicFrame[ i ] ) then
         GraphicFrame[ i ].Destroy;
end;

end.

