unit uServiceEdit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Buttons;

type
  TfEditService = class(TForm)
    Label4: TLabel;
    Label2: TLabel;
    Edit_Name: TEdit;
    Label1: TLabel;
    OpenDialog_Config: TOpenDialog;
    Edit_DisplayName: TEdit;
    Label3: TLabel;
    Panel: TPanel;
    BtnStart: TBitBtn;
    BtnStop: TBitBtn;
    Edit_Login: TEdit;
    Label5: TLabel;
    Edit_Password: TEdit;
    Label6: TLabel;
    Editor_Dependence: TMemo;
    Label7: TLabel;
    Edit_Description: TEdit;
    SaveDialog_cgf: TSaveDialog;
    Edit_Config: TButtonedEdit;
    procedure Btn_ConfigClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    function Dialog(var Name, DisplayName, ConfigFile, Login, Password, Dependence, Description: string): Boolean;
  end;

var
  fEditService: TfEditService;

implementation

{$R *.dfm}

uses uTools, uImages;

procedure TfEditService.Btn_ConfigClick(Sender: TObject);
begin
  if not OpenDialog_Config.Execute() then Exit;
  Edit_Config.Text := OpenDialog_Config.FileName;
end;

function TfEditService.Dialog;
var i: Integer;
  s: string;
begin
  Edit_Name.Text        := Name;
  Edit_DisplayName.Text := DisplayName;
  Edit_Config.Text      := ConfigFile;
  Edit_Login.Text       := Login;
  Edit_Password.Text    := Password;
  Edit_Description.Text := Description;
  Editor_Dependence.Lines.Text := '';
  //--------------------------
  Result := ShowModal = mrOk;
  if not Result then Exit;
  //--------------------------
  Name        := Edit_Name.Text;
  DisplayName := Edit_DisplayName.Text;
  ConfigFile  := Edit_Config.Text;
  Login       := Edit_Login.Text;
  Password    := Edit_Password.Text;
  i := Editor_Dependence.Lines.Count;
  Dependence := '';
  while i>0 do
  begin
    dec(i);
    s := Trim(Editor_Dependence.Lines.Strings[i]);
    if s<>'' then
      Dependence := Dependence + s + #0;
  end;
  Dependence := Dependence + Tools.iff<string>( Dependence='', #0#0, #0 );
end;

end.
