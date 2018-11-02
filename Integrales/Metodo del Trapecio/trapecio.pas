unit trapecio;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath;

type
  TTrapecio = class
    a, b, h : Real;
    Parse : TParseMath;
    function execute() : Real;
    function f(x:Real) : Real;
    private

    public
      constructor Create();
      destructor Destroy; override;

  end;

implementation


constructor TTrapecio.Create();
begin
  Parse := TParseMath.create;
  Parse.AddVariable('x',0);
end;

destructor TTrapecio.Destroy;
begin

end;

function TTrapecio.execute() : Real;
var xn, sum : Real;
    i,n : Integer;
    arr : array of Real;
begin

  sum := 0;
  n := 0;
  xn := a;
  while xn<>b do
  begin
    xn := xn + h;
    n := n + 1;
  end;
  SetLength(arr,n);
  xn := a;
  for i := 0 to n do
  begin
    arr[i] := xn;
    xn := xn + h;
  end;

  for i:= 1 to n-1 do
  begin
    sum := sum + f(arr[i]);
  end;

  result := h/2*(f(a)+f(b)+2*sum);
end;

function TTrapecio.f(x : Real) : Real;
begin
  Parse.NewValue('x',x);
  Result := Parse.Evaluate();
end;

end.

