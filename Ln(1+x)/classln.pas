unit ClassLN;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TLn = class
    x: Real;
    function ln():Real;
    private

    public
      error: Real;
      constructor create();
      destructor Destroy; override;
  end;

implementation

function potencia( b: Real; n: Integer ): Real;
var i: Integer;
begin
    Result:= 1;
    for i:= 1 to n do
        Result:= Result * b;
end;

function factorial( n: Integer ): LongInt;
begin
   case n of
        0, 1: Result:= 1;
        else Result:= n * factorial( n - 1 );
   end;
end;

constructor TLn.create();
begin
   error:= 0.1;
   x:= 0;
end;

destructor TLn.Destroy;
begin
  //
end;

function TLn.ln(): Real;
var n : Integer = 1;
    NewError, xn: Real;
begin
    Result:=0;
    xn:=1000000;
    repeat
        Result:= Result +  ( potencia(-1, n-1) * (potencia(x, n) / n) );
        NewError := abs( Result - xn);
        n := n + 1;
        xn := Result;
    until ((newError <= Error ) or ( n > 10));
end;


end.

