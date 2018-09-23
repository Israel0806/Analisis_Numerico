unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Menus, Grids, Frame;

type

  { TForm1 }

  TForm1 = class(TForm)
    BReset: TButton;
    BEjecutar: TButton;
    Grid: TStringGrid;
    LabelRaices: TLabel;
    LabelRpta: TLabel;
    Panel1: TPanel;
    PanelBReset: TPanel;
    PanelFrames: TPanel;
    PanelClient: TPanel;
    ScrollFrame: TScrollBox;

    procedure BEjecutarClick(Sender: TObject);
    procedure BResetClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private

    Roots : array of TRaices;
  public
    FrameCount : Integer;
    procedure AddRoot;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.AddRoot;
begin
  FrameCount := FrameCount + 1;
  SetLength( Roots, FrameCount + 1 );
  Roots[FrameCount] := TRaices.Create(PanelFrames);
  Roots[FrameCount].Align := alTop;
  Roots[FrameCount].Name := 'Root' + IntToStr(FrameCount);
  Roots[FrameCount].Parent := ScrollFrame;
  Roots[FrameCount].Tag := FrameCount;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FrameCount := -1;
  AddRoot;
end;

procedure TForm1.BResetClick(Sender: TObject);
var i : Integer;
begin
  for i:= 0 to FrameCount do
  begin
    Roots[i].Destroy;
  end;
  Grid.Clean;
  FrameCount:= -1;
  AddRoot;
end;

procedure TForm1.BEjecutarClick(Sender: TObject);
var i,j : Integer;
begin
  Grid.RowCount := FrameCount + 1;
  Grid.ColCount := FrameCount + 1;
  Grid.Width := 80*(FrameCount + 1);
  Grid.Height := 30*(FrameCount + 1);
  for i := 0 to FrameCount do
  begin
    for j := 0 to i do
    begin
      if i = j then
      begin
        Grid.Cells[j,i] := '1';
        continue;
      end;

      Grid.Cells[j,i] := FloatToStr( -Roots[i-1].root*StrToFloat(Grid.Cells[j,i-1]) );
      if j <> 0 then
        Grid.Cells[j,i] := FloatToStr( StrToFloat(Grid.Cells[j,i])+StrToFloat(Grid.Cells[j-1,i-1]) );

    end;
  end;

  for i := FrameCount downto 0 do
  begin
    if i = 0 then
    begin
      LabelRpta.Caption := LabelRpta.Caption + Grid.Cells[i,FrameCount];
    end
    else
    begin
      LabelRpta.Caption := LabelRpta.Caption + Grid.Cells[i,FrameCount] + 'x^' + IntToStr(i) + ' + ';

    end;
  end;

end;

procedure TForm1.FormDestroy(Sender: TObject);
var i : Integer;
begin
  for i := 0 to FrameCount do
  begin
    Roots[i].Destroy;
  end;
end;

end.

