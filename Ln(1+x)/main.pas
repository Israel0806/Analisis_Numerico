unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Classln;

type

  { TForm1 }

  TForm1 = class(TForm)
    BEjecutar: TButton;
    EditNum: TEdit;
    EditError: TEdit;
    LabelNum: TLabel;
    LabelError: TLabel;
    MemoRpta: TMemo;
    procedure BEjecutarClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BEjecutarClick(Sender: TObject);
var LN : Tln;
begin
   LN:= Tln.Create;
   LN.Error:= StrToFloat( editError.Text );
   LN.x:= StrToFloat( editNum.Text );
   memoRpta.Lines.Add( 'ln( 1 + ' + editNum.Text + ' ) = ' + FloatToStr( LN.ln() ) );
   LN.Destroy;
end;

end.

