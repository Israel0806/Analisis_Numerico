unit Frame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, StdCtrls, Buttons, LCLType,
  Dialogs, ExtCtrls;

type

  { TRaices }
  TRaices = class(TFrame)
    EditRoot: TEdit;
    procedure EditRootChange(Sender: TObject);
    procedure EditRootKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private

  public
    root : Real;
  end;

implementation

uses main;

{$R *.lfm}

{ TRaices }

procedure TRaices.EditRootKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if Key <> VK_RETURN then
     exit;

  with Form1 do
  begin
    root := StrToFloat(EditRoot.Text);
    if Self.Tag = FrameCount then
      AddRoot;
  end;
end;

procedure TRaices.EditRootChange(Sender: TObject);
var code : Integer;
begin
  Val(EditRoot.Text,root,code);
  if code <> 0 then
    exit;
end;

end.

