unit Frame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, Buttons, LCLType,
  Dialogs, ExtCtrls;

type

  { TRaices }
  TRaices = class(TFrame)
    Edit1: TEdit;
    procedure Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private

  public
    root : Real;
  end;

implementation

uses main;

{$R *.lfm}

{ TRaices }

procedure TRaices.Edit1KeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if Key <> VK_RETURN then
     exit;

  with Form1 do
  begin
    root := StrToFloat(Edit1.Text);
    if Self.Tag = FrameCount then
      AddRoot;
  end;
end;

end.

