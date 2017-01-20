unit mainunit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Buttons, ExtCtrls, StdCtrls;

type
  TMainForm = class(TForm)
    BrowseButton: TSpeedButton;
    Label2: TLabel;
    AVIName: TEdit;
    Panel1: TPanel;
    ApplyButton: TSpeedButton;
    QuitButton: TSpeedButton;
    OpenDialog: TOpenDialog;
    FourCCDesc: TComboBox;
    Label1: TLabel;
    FourCCCodec: TComboBox;
    procedure QuitButtonClick(Sender: TObject);
    procedure BrowseButtonClick(Sender: TObject);
    procedure ApplyButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}



procedure TMainForm.QuitButtonClick(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TMainForm.BrowseButtonClick(Sender: TObject);
var
  F : File;
  S : String[4];
begin
  If OpenDialog.Execute = True then
  Begin
    SetLength(S,4);
    AssignFile(F,OpenDialog.FileName);
    {$I-}
    Reset(F,1);
    {$I+}
    If IOResult = 0 then
    Begin
      Seek(F,$70);
      BlockRead(F,S[1],4);
      FourCCDesc.Text := S;
      Seek(F,$BC);
      BlockRead(F,S[1],4);
      FourCCCodec.Text := S;
      AVIName.Text := ExtractFileName(OpenDialog.FileName);
      AVIName.Hint := OpenDialog.FileName;
      ApplyButton.Enabled := True;
      CloseFile(F);
    End
      else
    Begin
      MessageDLG('Unable to open file, might be read-only.',mtError,[mbok],0);
    End;
  End;
end;

procedure TMainForm.ApplyButtonClick(Sender: TObject);
var
  F : File;
  S : String[4];
begin
  If (Length(FourCCDesc.Text) = 4) and (Length(FourCCCodec.Text) = 4) then
  Begin
    AssignFile(F,OpenDialog.FileName);
    Reset(F,1);
    Seek(F,$70);
    S := FourCCDesc.Text;
    BlockWrite(F,S[1],4);
    Seek(F,$BC);
    S := FourCCCodec.Text;
    BlockWrite(F,S[1],4);
    CloseFile(F);
    MessageDLG('FourCC code for ['+OpenDialog.Filename+'] has been set.',mtInformation,[mbok],0);
  End
    else
  Begin
    MessageDLG('FourCC code must be 4-Characters long, duh!',mtError,[mbok],0);
  End;
end;

end.
