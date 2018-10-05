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
    Funcion3: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    PanelZ: TPanel;
    PanelF3: TPanel;
    RptaZ: TLabel;
    _X: TEdit;
    _Z: TEdit;
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
    Parsef3: TParseMath;
    function f1( x : Real; y : Real; z : Real ) : Real;
    function f2( x : Real; y : Real; z : Real ) : Real;
    function f3( x : Real; y : Real; z : Real ) : Real;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.f1( x : Real; y : Real; z : Real ) : Real;
begin
  Parsef1.NewValue('x',x);
  Parsef1.NewValue('y',y);
  Parsef1.NewValue('z',z);
  Result := Parsef1.Evaluate();
end;


function TForm1.f2( x : Real; y : Real; z : Real ) : Real;
begin
  Parsef2.NewValue('x',x);
  Parsef2.NewValue('y',y);
  Parsef2.NewValue('z',z);
  Result := Parsef2.Evaluate();
end;

function TForm1.f3( x : Real; y : Real; z : Real ) : Real;
begin
  Parsef3.NewValue('x',x);
  Parsef3.NewValue('y',y);
  Parsef3.NewValue('z',z);
  Result := Parsef3.Evaluate();
end;

procedure TForm1.BEjecutarClick(Sender: TObject);
var n : Integer = 0;
    i,j,k : Integer;
    det,h, xn, yn, zn, NewError, Error, x, y, z, sum : Real;
    M1 : array of Real;
    M2 : array of Real;
    MR : array of Real;
    M_2 : array of Real;
    SL : TStringList;
begin
  Parsef1.Expression := Funcion1.Text;
  Parsef2.Expression := Funcion2.Text;
  Parsef3.Expression := Funcion3.Text;

  Error := 0.00001;
  h := 0.000001;
  x := StrToFloat(_X.Text);
  y := StrToFloat(_Y.Text);
  z := StrToFloat(_Z.Text);
  if Funcion3.Text = '' then z := 0;

  SL := TStringList.Create;
  SL.Add('N'); SL.Add('X'); SL.Add('Y'); SL.Add('Z'); SL.Add('Error');
  Grid1.ColCount := SL.Count;
  Grid1.RowCount := 2;
  Grid1.Rows[0].Assign(SL);

  SL.Clear;
  SL.Add(FloatToStr(n));
  SL.Add(FloatToStr(x));

  SL.Add(FloatToStr(y));
  SL.Add(FloatToStr(z));
  SL.Add('-');
  Grid1.Rows[1].Assign(SL);

  if Funcion3.Text = '' then
  begin
    SetLength(M1,2);
    SetLength(M2,4);
    SetLength(MR,2);
  end
  else
  begin
    SetLength(M1,3);
    SetLength(M2,9);
    SetLength(M_2,9);
    SetLength(MR,3);
  end;

  repeat
    n:= n + 1;
    xn := x;
    yn := y;
    zn := z;
    //f(x0)
    M1[0] := f1(x,y,z);
    M1[1] := f2(x,y,z);

    if Funcion3.Text <> '' then
      M1[2] := f3(x,y,z);


    //Jacobiano
    if Funcion3.Text = '' then
    begin
      M2[3] := ( f1(x+h,y,z) - f1(x-h,y,z) ) / ( 2*h );
      M2[1] := -( f1(x,y+h,z) - f1(x,y-h,z) ) / ( 2*h );
      M2[2] := -( f2(x+h,y,z) - f2(x-h,y,z) ) / ( 2*h );
      M2[0] := ( f2(x,y+h,z) - f2(x,y-h,z) ) / ( 2*h );
    end
    else
    begin
      M_2[0] := (f1(x+h,y,z) - f1(x-h,y,z))/(2*h);
      M_2[1] := (f1(x,y+h,z) - f1(x,y-h,z))/(2*h);
      M_2[2] := (f1(x,y,z+h) - f1(x,y,z-h))/(2*h);
      M_2[3] := (f2(x+h,y,z) - f2(x-h,y,z))/(2*h);
      M_2[4] := (f2(x,y+h,z) - f2(x,y-h,z))/(2*h);
      M_2[5] := (f2(x,y,z+h) - f2(x,y,z-h))/(2*h);
      M_2[6] := (f3(x+h,y,z) - f3(x-h,y,z))/(2*h);
      M_2[7] := (f3(x,y+h,z) - f3(x,y-h,z))/(2*h);
      M_2[8] := (f3(x,y,z+h) - f3(x,y,z-h))/(2*h);

      M2[0] :=  (M_2[4]*M_2[8]-M_2[5]*M_2[7]);
      M2[1] := -(M_2[3]*M_2[8]-M_2[5]*M_2[6]);
      M2[2] :=  (M_2[3]*M_2[7]-M_2[4]*M_2[6]);
      M2[3] := -(M_2[1]*M_2[8]-M_2[2]*M_2[7]);
      M2[4] :=  (M_2[0]*M_2[8]-M_2[2]*M_2[6]);
      M2[5] := -(M_2[0]*M_2[7]-M_2[1]*M_2[6]);
      M2[6] :=  (M_2[1]*M_2[5]-M_2[2]*M_2[4]);
      M2[7] := -(M_2[0]*M_2[5]-M_2[2]*M_2[3]);
      M2[8] :=  (M_2[0]*M_2[4]-M_2[1]*M_2[3]);
    end;

    //determinante
    det := (M2[0]*M2[3])-(M2[1]*M2[2]);
    if Funcion3.Text <> '' then
    begin
      det := (M_2[0]*M2[5]*M_2[8])+(M_2[1]*M_2[5]*M2[6])+(M_2[2]*M_2[3]*M_2[7])-
             (M_2[2]*M2[4]*M_2[6])-(M_2[1]*M_2[3]*M2[8])-(M_2[0]*M_2[5]*M_2[7]);
    sum := M2[1];
    M2[1] := M2[3];
    M2[3] := sum;
    sum := M2[2];
    M2[2] := M2[6];
    M2[6] := sum;
    sum := M2[5];
    M2[5] := M2[7];
    M2[7] := sum;
    end;
    //ShowMessage(IntToStr(Length(M2)));
    for i := 0 to Length(M2)-1 do
      M2[i] := M2[i]/det;

    //Multiplicacion
    if Funcion3.Text = '' then
    begin
      MR[0] := M2[0]*M1[0]+M2[1]*M1[1];
      MR[1] := M2[2]*M1[0]+M2[3]*M1[1];
    end
    else
    begin
      for j := 0 to 2 do
      begin
        sum := 0;
        for k := 0 to 2 do
        begin
          sum := sum + M2[k+(3*j)]*M1[k];
        end;
        MR[j] := sum;
        //ShowMessage('Mr ' + IntToStr(j) + ' ' + FloatToStr(sum) );
      end;
    end;

    x := x - MR[0];
    y := y - MR[1];
    //ShowMessage(FloatToStr(MR[2]));
    if Funcion3.Text <> '' then
      z := z - MR[2];
    NewError := Sqrt( Sqr(xn - x)+ Sqr(yn - y) + Sqr(zn - z));

    SL.Clear;
    SL.Add( FloatToStr(n) );
    SL.Add( FloatToStr(x) );
    SL.Add( FloatToStr(y) );

    SL.Add( FloatToStr(z) );
    SL.Add( FloatToStr(NewError) );
    Grid1.RowCount := Grid1.RowCount + 1;
    Grid1.Rows[n+1].Assign(SL);

  until (NewError <= Error) or (n>1000);

  RptaX.Caption := 'X: ' + FloatToStr(x);
  RptaY.Caption := 'Y: ' + FloatToStr(y);
  if Funcion3.Text <> '' then
    RptaZ.Caption := 'Z: ' + FloatToStr(z);

  SL.Destroy;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Parsef1 := TParseMath.Create;
  Parsef1.AddVariable('x',0);
  Parsef1.AddVariable('y',0);
  Parsef1.AddVariable('z',0);
  Parsef1.AddVariable('e',2.71828182845);

  Parsef2 := TParseMath.Create;
  Parsef2.AddVariable('x',0);
  Parsef2.AddVariable('y',0);
  Parsef2.AddVariable('z',0);
  Parsef2.AddVariable('e',2.71828182845);

  Parsef3 := TParseMath.Create;
  Parsef3.AddVariable('x',0);
  Parsef3.AddVariable('y',0);
  Parsef3.AddVariable('z',0);
  Parsef3.AddVariable('e',2.71828182845);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parsef1.Destroy;
  Parsef2.destroy;
  Parsef3.destroy;
end;

end.

