unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Grids,
  StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    LabelIt: TLabel;
    LabelResult: TLabel;
    Num1: TEdit;
    Num2: TEdit;
    StringGrid1: TStringGrid;
    TError: TEdit;
    procedure Button1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

function f( x : Real ) : Real;
begin
  //Result := Sqr(x) - LN(x) - Sin(x) - x;
  Result := (x* LN(x) - Exp(x) + 0.1)/(5-x)+1;
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var SL : TStringList;
  n : Integer;
  NewError, a, b, x, Error : Real;
begin
  StringGrid1.Clear;
  SL := TStringList.Create;
  // Cabecera
  SL.Add('N'); SL.Add('A'); SL.Add('B'); SL.Add('X'); SL.Add('Error');
  StringGrid1.ColCount := SL.Count;
  StringGrid1.Rows[0].Assign(SL);

  a := StrToFloat ( Num1.Text);
  b := StrToFloat ( Num2.Text);
  Error := StrToFloat (TError.Text);

  n := 0;

  if f(a)*f(b)<0 then
  begin
     x := a-( ( f(a)*(b-a) ) / ( f(b)-f(a) ) );

     SL.Clear;
     SL.Add( IntToStr(n) );
     SL.Add( FloatToStr(a) );
     SL.Add( FloatToStr(b) );
     SL.Add( FloatToStr(x) );
     SL.Add( '-' );
     StringGrid1.Rows[n+1].Assign(SL);
     StringGrid1.RowCount := 2;

     if f(a)*f(x) < 0 then
         b := x
     else
         a := x;
     repeat
       n := n + 1;
       NewError := x;
       x := a-( ( f(a)*(b-a) ) / ( f(b)-f(a) ) );

       if f(a)*f(x) < 0 then
           b := x
       else
           a := x;

       NewError := abs( NewError - x );

       SL.Clear;
       SL.Add( IntToStr(n) );
       SL.Add( FloatToStr(a) );
       SL.Add( FloatToStr(b) );
       SL.Add( FloatToStr(x) );
       SL.Add( FloatToStr(NewError) );

       StringGrid1.RowCount := StringGrid1.RowCount + 1;
       StringGrid1.Rows[n+1].Assign(SL);

     until (NewError <= Error);
     LabelResult.Caption := 'Valor Aproximado: ' + FloatToStr(x);
     LabelIt.Caption := 'Iteraciones: ' + FloatToStr(n);
  end
  else
  begin
    SL.Clear;
    SL.Add('naa');
    StringGrid1.Rows[1].Assign(SL);
  end;

  SL.Destroy;

end;

end.

