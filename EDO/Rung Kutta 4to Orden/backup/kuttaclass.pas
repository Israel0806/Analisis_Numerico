unit KuttaClass;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath;

type
  TKutta4 = class
    x,y,xn : Real;
    Parse : TParseMath;

    function f(_x:Real; _y:Real) : Real;
    function execute() : String;
    public
      constructor create;
      destructor Destroy; override;
  end;

implementation

constructor TKutta4.create;
begin
  Parse := TParseMath.create();
  Parse.AddVariable('x',0);
  Parse.AddVariable('y',0);
end;

destructor TKutta4.Destroy;
begin
  Parse.Destroy;
end;

function TKutta4.f(_x : Real; _y : Real) : Real;
begin
  Parse.NewValue('x',_x);
  Parse.NewValue('y',_y);
  Result := Parse.Evaluate();
end;

function TKutta4.execute() : String;
var h, m, k1, k2, k3, k4 : Real;
begin
  h := 0.00001;
  while x<=xn do
  begin
    k1 := f(x,y);
    k2 := f(x+h/2,y+h/2*k1);
    k3 := f(x+h/2,y+h/2*k2);
    k4 := f(x+h,y+h*k3);
    m := (k1+2*k2+2*k3+k4)/6;
    y := y + h*m;
    x := x + h;
  end;
  Result := FloatToStr(y);
end;

end.

