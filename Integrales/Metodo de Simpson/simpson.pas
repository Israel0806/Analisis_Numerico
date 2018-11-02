unit Simpson;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ParseMath;

type
  TSimpson = class
    a, b : Real;
    n : Integer;
    Parse : TParseMath;
    function execute() : Real;
    function f(x:Real) : Real;
    private

    public
      constructor Create();
      destructor Destroy; override;
  end;

implementation

constructor TSimpson.Create();
begin
  Parse := TParseMath.create;
  Parse.AddVariable('x',0);
end;

destructor TSimpson.Destroy;
begin

end;

function TSimpson.execute() : Real;
var h, xn, sumP, sumI : Real;
    i : Integer;
    arr : array of Real;
begin
  SetLength(arr,2*n+1);
  sumP := 0;
  sumI := 0;
  h := (b-a)/(2*n);

  xn := a;
  for i := 0 to 2*n do
  begin
    arr[i] := xn;
    xn := xn + h;

  end;

  for i := 1 to n-1 do
  begin
    sumP := sumP + f(arr[2*i]);

  end;
  for i := 0 to n-1 do
  begin
    sumI := sumI + f(arr[2*i+1]);
  end;

  result := (h/3)*(f(a)+f(b)+2*sumP+4*sumI);
end;

function TSimpson.f(x: Real): Real;
begin
  Parse.NewValue('x',x);
  result := Parse.Evaluate();
end;

end.

