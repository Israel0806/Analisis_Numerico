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
    Label3: TLabel;
    LabelIt: TLabel;
    LabelResult: TLabel;
    Num1: TEdit;
    TGrid: TStringGrid;
    TError: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Num1Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

function f( x : Real ) : Real;
begin
  //Result := Sqr(x) - LN(x) - Sin(x) - x;
  //Result := Cos(x);
  Result := Cos(x) - x;
end;

function ff( x : Real ) : Real;
begin
  //Result := 2*x - 1/x - Cos(x) - 1;
  //Result := -Sin(x);
  Result := -Sin(x) - 1;
end;

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var SL : TStringList;
    xn, Error, NewError, x : Real;
    n : Integer = 0;
begin
  SL := TStringList.create;
  TGrid.Clear;
  SL.Add('N'); SL.Add('X'); SL.Add('Error');
  TGrid.ColCount := SL.Count;
  TGrid.Rows[0].Assign(SL);
  TGrid.RowCount := 2;


  x := StrToFloat( Num1.Text );

  Error := StrToFloat( TError.Text );

  if ff(x) = 0 then
    begin
      x := x + 0.1
    end;

  //x := x - f(x)/ff(x);

  SL.Clear;
  SL.Add( FloatToStr(n) );
  SL.Add( FloatToStr(x) );
  SL.Add( '-' );
  TGrid.Rows[n+1].Assign(SL);

  repeat
     n := n + 1;
     xn := x;
     x := x - f(x)/ff(x);

    if ff(x) = 0 then
      begin
        x := x + 0.1
      end;
    NewError := abs( x - xn);

    SL.Clear;
    SL.Add( FloatToStr(n) );
    SL.Add( FloatToStr(x) );
    SL.Add( FloatToStr(NewError) );
    TGrid.RowCount := TGrid.RowCount + 1;
    TGrid.Rows[n+1].Assign(SL);

  until NewError <= Error ;

  LabelResult.Caption := 'Valor Aproximado: ' + FloatToStr(x);
  LabelIt.Caption := 'Iteraciones: ' + FloatToStr(n);

  SL.destroy;
end;

procedure TForm1.Num1Change(Sender: TObject);
begin

end;

end.

