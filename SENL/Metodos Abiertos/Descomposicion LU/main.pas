unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Grids, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    BEjecutar: TButton;
    EdiF1: TLabeledEdit;
    EdiF2: TLabeledEdit;
    EdiF3: TLabeledEdit;
    GridU: TStringGrid;
    GridL: TStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    x1: TLabel;
    x2: TLabel;
    x3: TLabel;
    LabelX: TLabel;
    LabelY: TLabel;
    LabelZ: TLabel;
    PanelText: TPanel;
    PanelTop: TPanel;
    ScrollBox1: TScrollBox;
    Arrow: TLabel;
    PanelClient: TPanel;
    PanelBottom: TPanel;
    GridCoef: TStringGrid;
    ScrollBox2: TScrollBox;
    procedure BEjecutarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Parse : TParseMath;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BEjecutarClick(Sender: TObject);
var x, y, z, cambio,a, b, c : Real;
    n,i,j : Integer;
    coe1, coe2, coe3 : String;
begin
  GridCoef.Clean;
  GridU.Clean;
  GridL.Clean;

  //Sacar Coeficientes

  GridCoef.Cells[0,0] := Copy(EdiF1.Text,0,Pos('x',EdiF1.Text)-1);
  GridCoef.Cells[1,0] := Copy(EdiF1.Text,Pos('x',EdiF1.Text)+1,(Pos('y',EdiF1.Text))-(Pos('x',EdiF1.Text)+1));
  GridCoef.Cells[2,0] := Copy(EdiF1.Text,Pos('y',EdiF1.Text)+1,(Pos('z',EdiF1.Text))-(Pos('y',EdiF1.Text)+1));

  GridCoef.Cells[0,1] := Copy(EdiF2.Text,0,Pos('x',EdiF2.Text)-1);
  GridCoef.Cells[1,1] := Copy(EdiF2.Text,Pos('x',EdiF2.Text)+1,(Pos('y',EdiF2.Text))-(Pos('x',EdiF2.Text)+1));
  GridCoef.Cells[2,1] := Copy(EdiF2.Text,Pos('y',EdiF2.Text)+1,(Pos('z',EdiF2.Text))-(Pos('y',EdiF2.Text)+1));

  GridCoef.Cells[0,2] := Copy(EdiF3.Text,0,Pos('x',EdiF3.Text)-1);
  GridCoef.Cells[1,2] := Copy(EdiF3.Text,Pos('x',EdiF3.Text)+1,(Pos('y',EdiF3.Text))-(Pos('x',EdiF3.Text)+1));
  GridCoef.Cells[2,2] := Copy(EdiF3.Text,Pos('y',EdiF3.Text)+1,(Pos('z',EdiF3.Text))-(Pos('y',EdiF3.Text)+1));

  //Transformacion a U
  for i := 0 to 2 do
  begin
    for j := 0 to 2 do
    begin
      if (GridCoef.Cells[j,i] = '') then
        GridCoef.Cells[j,i] := '0';
      if (StrToFloat(GridCoef.Cells[j,i]) > 0) then
        GridCoef.Cells[j,i] := FloatToStr(StrToFloat(GridCoef.Cells[j,i]));

      GridU.Cells[j,i] := GridCoef.Cells[j,i];
      GridL.Cells[i,j] := '0';
      if i = j then
        GridL.Cells[i,j] := '1';
    end;
  end;

  for n := 1 to 2 do
  begin
    for i := n to 2 do
    begin
      cambio := StrToFloat(GridU.Cells[n-1,i])/StrToFloat(GridU.Cells[n-1,n-1]);
      //ShowMessage(GridU.Cells[n-1,i] + LineEnding + GridU.Cells[n-1,n-1]);
      //ShowMessage(FloatToStr(cambio));
      for j := 0 to 2 do
      begin
        GridU.Cells[j,i] := FloatToStr(StrToFloat(GridU.Cells[j,i]) - (cambio*StrToFloat(GridU.Cells[j,n-1])));
        if (StrToFloat(GridU.Cells[j,i]) < 0.000001) and (StrToFloat(GridU.Cells[j,i]) > -0.000001) then
          GridU.Cells[j,i] := '0';
        //ShowMessage((IntToStr(i) + ' ' + IntToStr(j) + ' ' + GridU.Cells[j,i]));
      end;
      GridL.Cells[n-1,i] := FloatToStr(cambio);
    end;
  end;
  //Hallar a,b,c
  coe1 := Copy(EdiF1.Text,Pos('=',EdiF1.Text)+1,Length(EdiF1.Text)-Pos('=',EdiF1.Text)+1);
  coe2 := Copy(EdiF2.Text,Pos('=',EdiF2.Text)+1,Length(EdiF2.Text)-Pos('=',EdiF2.Text)+1);
  coe3 := Copy(EdiF3.Text,Pos('=',EdiF3.Text)+1,Length(EdiF3.Text)-Pos('=',EdiF3.Text)+1);

  x1.Caption := 'a + 0b + 0c = ' + coe1 + ' => a = ' + coe1;
  a := StrToFloat(coe1);
  Parse.NewValue('a',a);

  Parse.Expression := coe2 + '-' + GridL.Cells[0,1] + '*a';
  b := Parse.Evaluate();
  Parse.NewValue('b',b);
  x2.Caption := GridL.Cells[0,1] + 'a + b + 0c = ' + coe2 + ' => b = ' + FloatToStr(b);

  Parse.Expression := coe3 + '-(' + GridL.Cells[0,2] + '*a + ' + GridL.Cells[1,2] + '*b' + ')';
  c := Parse.Evaluate();
  x3.Caption := GridL.Cells[0,2] + 'a + ' + GridL.Cells[1,2] + 'b + c = ' + coe3 + ' => c = ' + FloatToStr(c);

  // Segundo Sistema de ecuaciones
  Label3.Caption := '=>';

  z := c/StrToFloat(GridU.Cells[2,2]);
  Parse.NewValue('z',z);
  Parse.Expression := '(' + FloatToStr(b) + '-' + GridU.Cells[2,1] + '*z' + ')/' + GridU.Cells[1,1];
  y := Parse.Evaluate();
  Parse.NewValue('y',y);
  Parse.Expression := '(' + FloatToStr(a) + '-(' + GridU.Cells[1,0] + '*y+' + GridU.Cells[2,0] + '*z' +')' + ')/' + GridU.Cells[0,0];
  x := Parse.Evaluate();
  LabelX.Caption := GridU.Cells[0,0] + 'x +' + GridU.Cells[1,0] + 'y + ' + GridU.Cells[2,0] + 'z = ' + FloatToStr(a) + ' => x = ' + FloatToStr(x);

  LabelY.Caption := GridU.Cells[0,1] + 'x +' + GridU.Cells[1,1] + 'y + ' + GridU.Cells[2,1] + 'z = ' + FloatToStr(b) + ' => y = ' + FloatToStr(y);

  LabelZ.Caption := GridU.Cells[0,2] + 'x +' + GridU.Cells[1,2] + 'y + ' + GridU.Cells[2,2] + 'z = ' + FloatToStr(c) + ' => z = ' + FloatToStr(z);


end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Parse := TParseMath.create;
  Parse.AddVariable('a',0);
  Parse.AddVariable('b',0);
  Parse.AddVariable('z',0);
  Parse.AddVariable('y',0);
  //Parse.AddVariable('c',0);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parse.destroy;
end;

end.

