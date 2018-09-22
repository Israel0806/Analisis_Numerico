unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Grids, ParseMath;

type

  { TForm1 }

  TForm1 = class(TForm)
    BEjecutar: TButton;
    EdiPoints: TEdit;
    Label1: TLabel;
    LabelPx: TLabel;
    Memo1: TMemo;
    PanelClient: TPanel;
    PanelXnum: TPanel;
    PanelXs: TPanel;
    Grid1: TStringGrid;
    procedure BEjecutarClick(Sender: TObject);
    procedure EdiPointsChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    Parse : TParseMath;

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.EdiPointsChange(Sender: TObject);
begin
  if ( EdiPoints.Text = '' ) then
    exit;
  Grid1.ColCount := StrToInt(EdiPoints.Text) + 1;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Parse := TParseMath.create;
  Parse.AddVariable('x',0);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  Parse.Destroy;
end;

procedure TForm1.BEjecutarClick(Sender: TObject);
var i, n, j : Integer;
    l : array of String;
begin
  Memo1.Lines.Clear;
  Parse.Expression := '';
  n := StrToInt(EdiPoints.Text);
  SetLength(l,n);
  for i := 0 to n-1 do
  begin
    l[i] := '';
    for j := 0 to n-1 do
    begin
      if ( j = i ) then
        Continue;
      if ( (j = n - 1) or ( ( j = n - 2) and ( i = n - 1 ) ) )  then
      begin
        l[i] := l[i] + '((x-' + Grid1.Cells[j+1,1] + ')/(' + Grid1.Cells[i+1,1] + '-' + Grid1.Cells[j+1,1] + '))';
        continue;
      end;
      l[i] := l[i] + '((x-' + Grid1.Cells[j+1,1] + ')/(' + Grid1.Cells[i+1,1] + '-' + Grid1.Cells[j+1,1] + '))*';
    end;
    if ( i = n-1 ) then
    begin
      Parse.Expression := Parse.Expression + Grid1.Cells[i+1,2] + '*' + l[i];
    end
    else
      Parse.Expression := Parse.Expression + Grid1.Cells[i+1,2] + '*' + l[i] + '+';
    //Memo1.Lines.Add(Parse.Expression);
    //Memo1.Lines.Add('');
    Memo1.Lines.Add('l[' + IntToStr(i) + '] = ' + l[i]);
  end;
  for i := 0 to n-1 do
  begin
    Parse.NewValue('x',StrToFloat(Grid1.Cells[i+1,1]));

    Memo1.Lines.Add( 'P(' + Grid1.Cells[i+1,1] + ') = ' + FloatToStr( Parse.Evaluate() ) );
  end;
end;

end.

