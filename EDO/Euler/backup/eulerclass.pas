unit EulerClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Dialogs, ParseMath;

type
  TEuler = class
    x, y, _xn : Real;
    Parse : TParseMath;

    function f(_x:Real;_y:Real) : Real;
    function execute() : Real;

    public
      constructor Create;
      destructor Destroy; override;
  end;

implementation

uses main;

constructor TEuler.Create;
begin
  Parse := TParseMath.create;
  Parse.AddVariable('x',0);
  Parse.AddVariable('y',0);
end;

destructor TEuler.Destroy;
begin
  Parse.Destroy;
end;

function Teuler.f(_x:Real;_y:Real) : Real;
begin
  Parse.NewValue('x',_x);
  Parse.NewValue('y',_y);
  Result := Parse.Evaluate();
end;

function TEuler.execute() : Real;
var xn, yn,h : Real;
begin
  with Form1 do
  begin
    h := 0.2;
    xn := x+h;
    repeat
      yn := y + h*(f(x,y));
      x := xn;
      y := yn;
      xn := xn + h;
    until xn > _xn;

    Result := yn;

  end;

end;

end.

