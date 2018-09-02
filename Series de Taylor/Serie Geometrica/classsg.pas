unit ClassSG;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TSG = class
    x : Real;
    function serieSG():Real;
    private

    public
    error : Real;
    constructor create();
    destructor Destroy; override;
  end;


implementation

constructor TSG.create();
begin
  error:= 0.1;
  x:= 0;
end;

destructor TSG.Destroy;
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

function TSG.serieSG() : Real;
var n: Integer = 0;
    NewError, xn : Real;
begin
     Result := 0;
     xn := 1000000;
     repeat
        Result := Result + potencia( x, n );
        NewError := abs( Result - xn );
        n := n + 1;
        xn := Result;
     until ( NewError <= error ) or ( n > 10 );
end;


end.

