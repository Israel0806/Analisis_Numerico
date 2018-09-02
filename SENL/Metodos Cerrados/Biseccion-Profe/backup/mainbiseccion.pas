unit mainbiseccion;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, TAGraph, TASeries, TAFuncSeries, Forms, Controls,
  Graphics, Dialogs, StdCtrls, ExtCtrls, Grids, class_biseccion, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    Chart1: TChart;
    Chart1ConstantLine1: TConstantLine;
    Chart1ConstantLine2: TConstantLine;
    Chart1FuncSeries1: TFuncSeries;
    Chart1LineSeries1: TLineSeries;
    ediA: TEdit;
    ediB: TEdit;
    ediError: TEdit;
    ediF: TEdit;
    Execute: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    lblIteracionse: TLabel;
    lblRoot: TLabel;
    lblError: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Splitter1: TSplitter;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Chart1FuncSeries1Calculate(const AX: Double; out AY: Double);
    procedure ExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    Parse: TParseMath;
    function f( x: Real): Real;
    procedure Plot(x: Real);
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }


function TForm1.f( x: Real): Real;
begin
   Parse.NewValue('x', x );
   Result:= Parse.Evaluate();
end;

procedure TForm1.Plot( x: Real );

begin
   Chart1FuncSeries1.Active:= True;
   Chart1LineSeries1.ShowLines:= False;
   Chart1LineSeries1.ShowPoints:= True;
   Chart1LineSeries1.AddXY( x, f(x) );
   Chart1LineSeries1.Active:= True;
end;

procedure TForm1.ExecuteClick(Sender: TObject);
var Biseccion: TBiseccion;
    i: Integer;
begin
  Parse.Expression:= ediF.Text;
  Biseccion:= TBiseccion.create;
  with Biseccion do begin
       a:= StrToFloat( ediA.Text );
       b:= StrToFloat( ediB.Text );
       fx:= ediF.Text;
       Error:= StrToFloat( ediError.Text );
       Execute;
       StringGrid1.RowCount:= xn.Count;
       StringGrid1.Cols[1].Assign( xn );
       StringGrid1.Cols[2].Assign( en );
       Plot(x);
       lblRoot.Caption:= FloatToStr( round( x / Error ) * Error );
       lblIteracionse.Caption:= IntToStr( xn.Count );
  end;

  Biseccion.Destroy;
  for i:= 0 to StringGrid1.RowCount -1 do
     StringGrid1.Cells[ 0, i ]:= IntToStr( i+1 );
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Parse:= TParseMath.create();
  Parse.AddVariable( 'x', 0);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parse.destroy;
end;

procedure TForm1.Chart1FuncSeries1Calculate(const AX: Double; out AY: Double);
begin
  AY := f(AX);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Chart1FuncSeries1.Active:= False;
  Chart1LineSeries1.Active:= False;
end;

end.

