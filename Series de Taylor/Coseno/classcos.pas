unit classCos;

{$mode objfpc}{$H+}

interface

uses

  Classes,
  SysUtils;

type
  TCos = class
    x: Real;
    function cos():Real;
    private

    public
      Error: Real;
      constructor create();
      destructor Destroy; override;
  end;

implementation

function Potencia( y: Real; n: Integer ): Real;
var i: Integer;
begin
    Result:= 1;
    for i:= 1 to n do
        Result:= Result * y;
end;

function factorial( n: Integer ): LongInt;
begin
   case n of
        0, 1: Result:= 1;
        else Result:= n * factorial( n - 1 );
   end;
end;

constructor TCos.create();
begin
   Error:= 0.1;
   x:= 0;
end;

destructor TCos.Destroy;
begin
  //
end;

function TCos.cos(): Real;
var n : Integer = 0;
    NewError, xn: Real;
begin
    Result:=0;
    xn:=1000000;
    repeat
        Result:= Result +  ( Potencia(-1, n) * (Potencia(x, 2*n) / Factorial(2*n)) );
        NewError := abs( Result - xn);
        n := n + 1;
        xn := Result;
    until ((newError <= Error ) or ( n > 6));
end;


end.

