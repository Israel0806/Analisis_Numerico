unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, TATools, Forms,
  Controls, Graphics, Dialogs, ExtCtrls, StdCtrls, Grids, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    BEjecutar: TButton;
    _X: TEdit;
    _Y: TEdit;
    Funcion1: TEdit;
    Funcion2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    PanelX: TPanel;
    PanelY: TPanel;
    PanelFuncs: TPanel;
    RptaX: TLabel;
    RptaY: TLabel;
    PanelClient: TPanel;
    PanelF1: TPanel;
    PanelF2: TPanel;
    PanelGrid: TPanel;
    PanelResult: TPanel;
    Grid1: TStringGrid;
    procedure BEjecutarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Parsef1: TParseMath;
    Parsef2: TParseMath;

    function f1( x : Real; y : Real ) : Real;
    function f2( x : Real; y : Real ) : Real;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.f1( x : Real; y : Real ) : Real;
begin
  Parsef1.NewValue('x',x);
  Parsef1.NewValue('y',y);
  Result := Parsef1.Evaluate();
end;


function TForm1.f2( x : Real; y : Real ) : Real;
begin
  Parsef2.NewValue('x',x);
  Parsef2.NewValue('y',y);
  Result := Parsef2.Evaluate();
end;

procedure TForm1.BEjecutarClick(Sender: TObject);
var n : Integer = 0;
    i : Integer;
    det,h, xn, yn, NewError, Error, x, y : Real;
    M1 : array of Real;
    M2 : array of Real;
    MR : array of Real;
    SL : TStringList;
begin
  Parsef1.Expression := Funcion1.Text;
  Parsef2.Expression := Funcion2.Text;

  SetLength(M1,2);
  SetLength(M2,4);
  SetLength(MR,2);

  Error := 0.00001;
  h := 0.000001;
  x := StrToFloat(_X.Text);
  y := StrToFloat(_Y.Text);

  SL := TStringList.Create;
  SL.Add('N'); SL.Add('X'); SL.Add('Y'); SL.Add('Error');
  Grid1.ColCount := SL.Count;
  Grid1.RowCount := 2;
  Grid1.Rows[0].Assign(SL);

  SL.Clear;
  SL.Add(FloatToStr(n));
  SL.Add(FloatToStr(x));
  SL.Add(FloatToStr(y));
  SL.Add('-');
  Grid1.Rows[1].Assign(SL);

  repeat
    n:= n + 1;
    xn := x;
    yn := y;
    //f(x0)
    M1[0] := f1(x,y);
    M1[1] := f2(x,y);

    //Jacobiano
    M2[3] := ( f1(x+h,y) - f1(x-h,y) ) / ( 2*h );
    M2[1] := -( f1(x,y+h) - f1(x,y-h) ) / ( 2*h );
    M2[2] := -( f2(x+h,y) - f2(x-h,y) ) / ( 2*h );
    M2[0] := ( f2(x,y+h) - f2(x,y-h) ) / ( 2*h );

    //determinante
    det := (M2[0]*M2[3])-(M2[1]*M2[2]);
    for i := 0 to 3 do
      M2[i] := M2[i]/det;

    //Multiplicacion
    MR[0] := M2[0]*M1[0]+M2[1]*M1[1];
    MR[1] := M2[2]*M1[0]+M2[3]*M1[1];

    x := x - MR[0];
    y := y - MR[1];

    NewError := Sqrt( Sqr(xn - x)+ Sqr(yn - y));

    SL.Clear;
    SL.Add( FloatToStr(n) );
    SL.Add( FloatToStr(x) );
    SL.Add( FloatToStr(y) );
    SL.Add( FloatToStr(NewError) );
    Grid1.RowCount := Grid1.RowCount + 1;
    Grid1.Rows[n+1].Assign(SL);

  until NewError <= Error;

  RptaX.Caption := 'X: ' + FloatToStr(x);
  RptaY.Caption := 'Y: ' + FloatToStr(y);

  SL.Destroy;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Parsef1 := TParseMath.Create;
  Parsef1.AddVariable('x',0);
  Parsef1.AddVariable('y',0);
  Parsef1.AddVariable('e',2.71828182845);

  Parsef2 := TParseMath.Create;
  Parsef2.AddVariable('x',0);
  Parsef2.AddVariable('y',0);
  Parsef2.AddVariable('e',2.71828182845);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parsef1.Destroy;
  Parsef2.destroy;
end;

end.

