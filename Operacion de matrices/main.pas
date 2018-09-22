unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Grids, MaskEdit, Buttons, Menus;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    FM1: TEdit;
    CM1: TEdit;
    FM2: TEdit;
    CM2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    BEjecutar: TButton;
    Label8: TLabel;
    Suma: TMenuItem;
    Resta: TMenuItem;
    Multiplicacion: TMenuItem;
    Inversa: TMenuItem;
    PopupMenu1: TPopupMenu;
    Matriz1: TStringGrid;
    MatrizResult: TStringGrid;
    Matriz2: TStringGrid;
    procedure BEjecutarClick(Sender: TObject);
    procedure CM1Change(Sender: TObject);
    procedure CM2Change(Sender: TObject);
    procedure InversaClick(Sender: TObject);
    procedure FM1Change(Sender: TObject);
    procedure FM2Change(Sender: TObject);
    procedure MultiplicacionClick(Sender: TObject);
    procedure RestaClick(Sender: TObject);
    procedure SumaClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.SumaClick(Sender: TObject);
begin
   Button1.Caption := 'Suma';
end;

procedure TForm1.RestaClick(Sender: TObject);
begin
   Button1.Caption := 'Resta';
end;

procedure TForm1.MultiplicacionClick(Sender: TObject);
begin
  Button1.Caption := 'Multiplicacion';
end;

procedure TForm1.InversaClick(Sender: TObject);
begin
  Button1.Caption := 'Inversa';
end;

procedure TForm1.FM1Change(Sender: TObject);
begin
  Matriz1.ColCount := StrToInt(FM1.Text);
end;

procedure TForm1.FM2Change(Sender: TObject);
begin
  Matriz2.ColCount := StrToInt(FM2.Text);
end;

procedure TForm1.BEjecutarClick(Sender: TObject);
var i, j, k, f1, f2, c1, c2 : Integer;
    sum, det : Real;
begin
  f1 := StrToInt(FM1.Text);
  c1 := StrToInt(CM1.Text);
  f2 := StrToInt(FM2.Text);
  c2 := StrToInt(cM2.Text);

  if (Button1.Caption = 'Suma') then
  begin
    if (f1 <> f2) or (c1 <> c2) then
    begin
      ShowMessage('Deben ser matrices de mismo tamaño');
      exit;
    end;

    MatrizResult.RowCount := f1;
    MatrizResult.ColCount := c1;
    for i := 0 to f1-1 do
    begin
      for j := 0 to c1-1 do
      begin
        MatrizResult.Cells[j,i] := FloatToStr( StrToFloat(Matriz1.Cells[j,i]) + StrToFloat(Matriz2.Cells[j,i]) );
      end;
    end;
  end;

  if (Button1.Caption = 'Resta') then
  begin
    if (f1 <> f2) or (c1 <> c2) then
    begin
      ShowMessage('Deben ser matrices de mismo tamaño');
      exit;
    end;

    MatrizResult.RowCount := f1;
    MatrizResult.ColCount := c1;

    for i := 0 to f1-1 do
    begin
      for j := 0 to c1-1 do
      begin
        MatrizResult.Cells[j,i] := FloatToStr( StrToFloat(Matriz1.Cells[j,i]) - StrToFloat(Matriz2.Cells[j,i]) );
      end;
    end;
  end;

  if (Button1.Caption = 'Multiplicacion') then
  begin
    if ( c1 <> f2 ) then
    begin
      ShowMessage('No se puede multiplicar');
      exit;
    end;

    for i := 0 to f1-1 do
    begin
      for j := 0 to c2-1 do
      begin
        sum := 0;
        for k := 0 to c2-1 do
        begin
          sum := sum + (StrToFloat(Matriz1.Cells[k,i]) * StrToFloat(Matriz2.Cells[j,k]));
          //ShowMessage( (Matriz1.Cells[k,i]) + ' * ' + (Matriz2.Cells[j,k]));
        end;
        MatrizResult.Cells[j,i] := FloatToStr(sum);
      end;
    end;
  end;

  if (Button1.Caption = 'Inversa') then
  begin
    if ( c1 <> f1 ) then
    begin
      ShowMessage('La Matriz 1 debe ser cuadratica');
      exit;
    end;

    if ( c1 = 2 ) then
    begin
      det := (StrToFloat(Matriz1.Cells[0,0])*StrToFloat(Matriz1.Cells[1,1]))-
             (StrToFloat(Matriz1.Cells[1,0])*StrToFloat(Matriz1.Cells[0,1]));

      MatrizResult.RowCount := f1;
      MatrizResult.ColCount := c1;

      MatrizResult.Cells[0,0] := FloatToStr( StrToFloat(Matriz1.Cells[1,1])*det );
      MatrizResult.Cells[1,0] := FloatToStr( -StrToFloat(Matriz1.Cells[1,0])*det);
      MatrizResult.Cells[0,1] := FloatToStr( -StrToFloat(Matriz1.Cells[0,1])*det);
      MatrizResult.Cells[1,1] := FloatToStr( StrToFloat(Matriz1.Cells[0,0])*det);

    end
    else
    begin
      if ( c1 = 3 ) then
      begin

        det := (StrToFloat(Matriz1.Cells[0,0])*StrToFloat(Matriz1.Cells[1,1])*StrToFloat(Matriz1.Cells[2,2]))+
               (StrToFloat(Matriz1.Cells[1,0])*StrToFloat(Matriz1.Cells[2,1])*StrToFloat(Matriz1.Cells[0,2]))+
               (StrToFloat(Matriz1.Cells[2,0])*StrToFloat(Matriz1.Cells[0,1])*StrToFloat(Matriz1.Cells[1,2]))-
               (StrToFloat(Matriz1.Cells[2,0])*StrToFloat(Matriz1.Cells[1,1])*StrToFloat(Matriz1.Cells[0,2]))-
               (StrToFloat(Matriz1.Cells[1,0])*StrToFloat(Matriz1.Cells[0,1])*StrToFloat(Matriz1.Cells[2,2]))-
               (StrToFloat(Matriz1.Cells[0,0])*StrToFloat(Matriz1.Cells[2,1])*StrToFloat(Matriz1.Cells[1,2]));
        det := 1 / det;
        MatrizResult.Cells[0,0] := FloatToStr( det*((StrToFloat(Matriz1.Cells[1,1])*StrToFloat(Matriz1.Cells[2,2])) -(StrToFloat(Matriz1.Cells[2,1])*StrToFloat(Matriz1.Cells[1,2])) ));
        MatrizResult.Cells[0,1] := FloatToStr( det*(-((StrToFloat(Matriz1.Cells[0,1])*StrToFloat(Matriz1.Cells[2,2]))-(StrToFloat(Matriz1.Cells[2,1])*StrToFloat(Matriz1.Cells[0,2]))) ));
        MatrizResult.Cells[0,2] := FloatToStr( det*((StrToFloat(Matriz1.Cells[0,1])*StrToFloat(Matriz1.Cells[1,2])) -(StrToFloat(Matriz1.Cells[1,1])*StrToFloat(Matriz1.Cells[0,2])) ));
        MatrizResult.Cells[1,0] := FloatToStr( det*(-((StrToFloat(Matriz1.Cells[1,0])*StrToFloat(Matriz1.Cells[2,2]))-(StrToFloat(Matriz1.Cells[2,0])*StrToFloat(Matriz1.Cells[1,2]))) ));
        MatrizResult.Cells[1,1] := FloatToStr( det*((StrToFloat(Matriz1.Cells[0,0])*StrToFloat(Matriz1.Cells[2,2])) -(StrToFloat(Matriz1.Cells[2,0])*StrToFloat(Matriz1.Cells[0,2])) ));
        MatrizResult.Cells[1,2] := FloatToStr( det*(-((StrToFloat(Matriz1.Cells[0,0])*StrToFloat(Matriz1.Cells[1,2]))-(StrToFloat(Matriz1.Cells[1,0])*StrToFloat(Matriz1.Cells[0,2]))) ));
        MatrizResult.Cells[2,0] := FloatToStr( det*((StrToFloat(Matriz1.Cells[1,0])*StrToFloat(Matriz1.Cells[2,1])) -(StrToFloat(Matriz1.Cells[2,0])*StrToFloat(Matriz1.Cells[1,1])) ));
        MatrizResult.Cells[2,1] := FloatToStr( det*(-((StrToFloat(Matriz1.Cells[0,0])*StrToFloat(Matriz1.Cells[2,1]))-(StrToFloat(Matriz1.Cells[2,0])*StrToFloat(Matriz1.Cells[0,1]))) ));
        MatrizResult.Cells[2,2] := FloatToStr( det*((StrToFloat(Matriz1.Cells[0,0])*StrToFloat(Matriz1.Cells[1,1])) -(StrToFloat(Matriz1.Cells[1,0])*StrToFloat(Matriz1.Cells[0,1])) ));

      end;
    end;
  end;
end;

procedure TForm1.CM1Change(Sender: TObject);
begin
  Matriz1.RowCount := StrToInt(CM1.Text);
end;

procedure TForm1.CM2Change(Sender: TObject);
begin
  Matriz2.RowCount := StrToInt(CM2.Text);
end;

end.

