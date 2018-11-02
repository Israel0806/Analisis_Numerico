unit EulMejoradoClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, ParseMath;

type
  TEulMejorado = class
    x,y,_xn : Real;
    Parse : TParseMath;

    function f(_x:Real;_y:Real) : Real;
    function execute() : Real;

    public
      constructor Create;
      destructor Destroy; override;
  end;

implementation

uses main;

constructor TEulMejorado.Create;
begin
  Parse := TParseMath.create;
  Parse.AddVariable('x',0);
  Parse.AddVariable('y',0);
end;

destructor TEulMejorado.Destroy;
begin
  Parse.Destroy;
end;

function TEulMejorado.f(_x:Real;_y:Real) : Real;
begin
  Parse.NewValue('x',_x);
  Parse.NewValue('y',_y);
  Result := Parse.Evaluate();
end;

function TEulMejorado.execute() : Real;
var xn, yn,h : Real;
begin
  with Form1 do
  begin
    h := 0.2;
    xn := x+h;
    repeat
      yn := y + h/2*(f(x,y) + f(xn,(y+h*f(x,y) )));
      x := xn;
      y := yn;
      xn := xn + h;
    until xn > _xn;

    Result := yn;
    ShowMessage('f(' + FloatToStr(_xn) + ')=' + FloatToStr(yn));

  end;

end;

end.

