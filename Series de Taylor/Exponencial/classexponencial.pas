unit ClassExponencial;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  TExp = class
     x: Real;
     function exponencial():Real;
     private

     public
     error : Real;
     constructor create();
     destructor Destroy; override;
  end;


implementation

constructor TExp.create();
begin
   x := 0;
   error := 0.1;
end;

destructor TExp.Destroy;
begin
  //
end;

function potencia(b : Real; n : Integer) : Real;
var i : Integer;
begin
   Result := 1;
   for i:=1 to n do
       Result := Result * b;
end;

function factorial( n : integer ) : LongInt;
begin
   case n of
        0,1: Result := 1;
        else Result := n * factorial(n-1);
   end;
end;

function TExp.exponencial():Real;
var n : Integer = 0;
    NewError, xn:Real;
begin
   Result := 0;
   xn := 1000000000;
   repeat
      Result := Result + ( potencia(x,n)/factorial(n) );
      NewError := abs(Result - xn);
      n := n + 1;
      xn := Result;
   until (( NewError <= Error ) or (n > 10));
end;

end.

