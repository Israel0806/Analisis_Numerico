unit ClassLn;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TLn = class
    x : Real;
    function logNat():Real;
    private

    public
    error : Real;
    constructor create();
    destructor Destroy; override;
  end;


implementation

constructor TLn.create();
begin
  error:= 0.1;
  x:= 0;
end;

destructor TLn.Destroy;
begin
 //
end;

function potencia( b : Real; n : Integer ) : Real;
var i : Integer;
begin
     Result := 1;
     for i := 1 to n do
         Result := Result * b;
end;

function TLn.logNat() : Real;
var n: Integer = 0;
    NewError, xn : Real;
begin
     Result := 0;
     xn := 1000000;
     repeat
        Result := Result + potencia( ( (x-1)/(x+1) ), (2*n+1) ) / ( 2*n + 1 );
        NewError := abs( Result - xn );
        n := n + 1;
        xn := Result;
     until ( NewError <= error ) or ( n > 10 );
     Result := Result * 2;
end;


end.

