unit Frame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, Buttons, LCLType,
  ColorBox, Dialogs, TAGraph, TAFuncSeries, ParseMath, Graphics, ExtCtrls, Math;

type

  { TFrameFunc }

  TFrameFunc = class(TFrame)
    ColorButton1: TColorButton;
    Edit1: TEdit;
    Panel1: TPanel;
    procedure ColorButton1ColorChanged(Sender: TObject);
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FrameClick(Sender: TObject);
    procedure CalculateFunc(const AX: Double; out AY: Double);

  private
    Parse: TParseMath;
    function f( x : Real ) : Real;

  public
    FuncColor: TColor;
    FuncSeries: TFuncSeries;
  end;

implementation

uses main;

{$R *.lfm}

{ TFrameFunc }

function TFrameFunc.f( x : Real ) : Real;
begin
  Parse.NewValue('x',x);
  Result := Parse.Evaluate();
end;

procedure TFrameFunc.CalculateFunc(const AX: Double; out AY: Double);
begin
  AY := f(AX);
end;

procedure TFrameFunc.Edit1KeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var limit : String;
begin
  if (Key <> VK_RETURN) or (Edit1.Caption = '') then
     exit;

  with Form1 do begin
     if not Assigned( FuncSeries ) then begin
        FuncSeries:= TFuncSeries.Create( Chart1 );
        Chart1.AddSeries( FuncSeries );
     end;


     FuncSeries.Pen.color := FuncColor;
     FuncSeries.Pen.width := 2;
     FuncSeries.Active := False;

     Parse := TParseMath.create;
     Parse.Expression := Edit1.Text;

     limit := Copy(Parse.Expression,Pos('l',Parse.Expression),2);

     if limit <> 'ln' then
       limit := Copy(Parse.Expression,Pos('s',Parse.Expression),4);

     if (limit = 'ln') or (limit = 'sqrt') then
     begin
       with FuncSeries.DomainExclusions do
         begin
           AddRange(NegInfinity,0);
         end;
     end;

     Parse.AddVariable('x',0);
     Parse.AddVariable('e',2.7182818284);

     FuncSeries.onCalculate :=  @CalculateFunc;
     FuncSeries.Tag := Form1.MaxPos;

     FuncSeries.Active := True;

     if Self.Tag = Form1.MaxPos then
          Form1.AddGraphic;

  end;
end;

procedure TFrameFunc.FrameClick(Sender: TObject);
begin
  Form1.ActualPos := Self.Tag;
  Panel1.Color:= clGray;
end;

procedure TFrameFunc.ColorButton1ColorChanged(Sender: TObject);
begin
   FuncColor:= ColorButton1.ButtonColor;
   if Assigned( FuncSeries ) then
      FuncSeries.Pen.Color:= FuncColor;
end;

end.

