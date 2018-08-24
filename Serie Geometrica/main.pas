unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ClassSG;

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
var SG : TSG;
begin
   SG:= TSG.Create;
   SG.error:= StrToFloat( editError.Text );
   SG.x:= StrToFloat( editNum.Text );
   memoRpta.Lines.Add( '1/( 1 - ' + editNum.Text + ' ) = ' + FloatToStr( SG.serieSG() ) );
   SG.Destroy;
end;

end.

