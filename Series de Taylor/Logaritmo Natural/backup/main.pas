unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ClassLn;

type

  { TForm1 }

  TForm1 = class(TForm)
    BEjecutar: TButton;
    EditNum: TEdit;
    EditError: TEdit;
    LabelX: TLabel;
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
var Log : TLn;
begin
     Log := Tln.create();
     Log.x := StrToFloat( EditNum.Text );
     Log.error := StrToFloat( EditError.Text );
     MemoRpta.Lines.Add( 'ln( ' + EditNum.Text + ' ) = ' + FloatToStr( Log.logNat() ) );
     Log.Destroy
end;

end.

