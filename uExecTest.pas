unit uExecTest;

interface

uses
  uExecuter,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, Vcl.Grids, Vcl.ValEdit,
  Vcl.Mask, Vcl.ComCtrls, Vcl.ToolWin, System.ImageList, Vcl.ImgList, Vcl.NumberBox;

type
  TfTestExec = class(TFrame)
    Panel: TPanel;
    BtnTerminate: TBitBtn;
    BtnRun: TBitBtn;
    OpenDialog: TOpenDialog;
    Btn_FileOpen: TBitBtn;
    Btn_FileSave: TBitBtn;
    OpenDialog_Config: TOpenDialog;
    SaveDialog_Config: TSaveDialog;
    StartPages: TPageControl;
    TabStart: TTabSheet;
    TabStop: TTabSheet;
    TabTerminate: TTabSheet;
    Edit_Path: TButtonedEdit;
    Edit_StdError: TButtonedEdit;
    Edit_StdOut: TButtonedEdit;
    Edit_Param: TButtonedEdit;
    Edit_Cmd: TButtonedEdit;
    Editor_Env: TValueListEditor;
    Label5: TLabel;
    Label4: TLabel;
    Label_Path: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    LabelEnv: TLabel;
    Label3: TLabel;
    Edit_CmdS: TButtonedEdit;
    Label6: TLabel;
    Edit_ParamS: TButtonedEdit;
    Label7: TLabel;
    Edit_PathS: TButtonedEdit;
    Label8: TLabel;
    Edit_StdOutS: TButtonedEdit;
    Label9: TLabel;
    Edit_StdErrorS: TButtonedEdit;
    Label10: TLabel;
    Editor_EnvS: TValueListEditor;
    CheckBox_HideWin: TCheckBox;
    Label11: TLabel;
    Edit_CmdT: TButtonedEdit;
    Label12: TLabel;
    Edit_ParamT: TButtonedEdit;
    Label13: TLabel;
    Edit_PathT: TButtonedEdit;
    Label14: TLabel;
    Edit_StdOutT: TButtonedEdit;
    Label15: TLabel;
    Edit_StdErrorT: TButtonedEdit;
    Label16: TLabel;
    Editor_EnvT: TValueListEditor;
    Label17: TLabel;
    Edit_RestartCount: TNumberBox;
    Label18: TLabel;
    Edit_TimeoutT: TNumberBox;
    Edit_TimeoutS: TNumberBox;
    Label19: TLabel;
    BtnClear: TBitBtn;
    procedure BtnRunClick(Sender: TObject);
    procedure BtnTerminateClick(Sender: TObject);
    procedure Btn_FileOpenClick(Sender: TObject);
    procedure Btn_FileSaveClick(Sender: TObject);
    procedure BtnClickBrouse(Sender: TObject);
    procedure Btn_PathClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
  private
    { Private declarations }
    exec: TExecuter;
    procedure OnTerminate(Sender: TObject);
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation
uses uTools, System.IniFiles, Vcl.FileCtrl, uConst, System.UITypes, uImages;

{$R *.dfm}

{ TFrame1 }

constructor TfTestExec.Create(AOwner: TComponent);
begin
  inherited;
  exec := nil;
end;

destructor TfTestExec.Destroy;
begin
  BtnTerminateClick(nil);
  inherited;
end;

procedure TfTestExec.BtnRunClick(Sender: TObject);
var StartP, TermP, StopP: TExeParam;
    i: UInt16;
    key, val: string;
    env: TStrings;
begin
  if exec=nil then begin
    env := TStringList.Create;
    try

    BtnRun.Enabled := False;
    //-----------------------
    StartP.cmd       := Edit_Cmd.Text;
    StartP.param     := Edit_Param.Text;
    StartP.dir       := Edit_Path.Text;
    StartP.fileStd   := Edit_StdOut.Text;
    StartP.fileError := Edit_StdError.Text;
    StartP.cnt       := Edit_RestartCount.ValueInt;
    env.Clear;
    for i:=1 to Editor_Env.RowCount-1 do begin
      key := Editor_Env.Keys[i].Trim();
      val := Editor_Env.Values[key].Trim();
      if (key<>'')and(val<>'') then
        env.Values[key] := val;
    end;
    StartP.env := env.Text;
    //-----------------------
    TermP.cmd       := Edit_CmdT.Text;
    TermP.param     := Edit_ParamT.Text;
    TermP.dir       := Edit_PathT.Text;
    TermP.fileStd   := Edit_StdOutT.Text;
    TermP.fileError := Edit_StdErrorT.Text;
    TermP.cnt       := Edit_TimeoutT.ValueInt;
    env.Clear;
    for i:=1 to Editor_EnvT.RowCount-1 do begin
        key := Editor_EnvT.Keys[i].Trim();
        val := Editor_EnvT.Values[key].Trim();
        if (key<>'')and(val<>'') then
        env.Values[key] := val;
    end;
    TermP.env := env.Text;
    //-----------------------
    StopP.cmd       := Edit_CmdS.Text;
    StopP.param     := Edit_ParamS.Text;
    StopP.dir       := Edit_PathS.Text;
    StopP.fileStd   := Edit_StdOutS.Text;
    StopP.fileError := Edit_StdErrorS.Text;
    StopP.cnt       := Edit_TimeoutS.ValueInt;
    StopP.env       := '';
    env.Clear;
    for i:=1 to Editor_EnvS.RowCount-1 do begin
      key := Editor_EnvS.Keys[i].Trim();
      val := Editor_EnvS.Values[key].Trim();
      if (key<>'')and(val<>'') then
        env.Values[key] := val;
    end;
    StopP.env := env.Text;
    //-----------------------
    exec := TExecuter.Create( True, CheckBox_HideWin.Checked, StartP, TermP, StopP );
    exec.OnTerminate := Self.OnTerminate;
    exec.Start();
    BtnTerminate.Enabled := True;
    finally
      FreeAndNil(env);
    end;
  end else begin
    MessageDlg('Уже запущен',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
  end;
end;

procedure TfTestExec.BtnTerminateClick(Sender: TObject);
begin
  BtnTerminate.Enabled := False;
  if exec<>nil then
  begin
    exec.Terminate;
    exec := nil;
  end
  else if Sender<>nil then
  begin
    MessageDlg('Ещё не запущен',TMsgDlgType.mtWarning, [TMsgDlgBtn.mbOK], 0);
  end;
end;

procedure TfTestExec.OnTerminate(Sender: TObject);
begin
  //exec.WaitFor;
  //FreeAndNil(exec);
  BtnRun.Enabled := True;
end;


procedure TfTestExec.Btn_PathClick(Sender: TObject);
var dir: string;
begin
  if Edit_Path.Text='' then
    dir := ExtractFilePath(Application.ExeName)
  else
    dir := Edit_Path.Text;
  if SelectDirectory(Label_Path.Caption, '', dir) then
    case StartPages.ActivePageIndex of
      0: Edit_Path.Text := dir;
      1: Edit_PathT.Text := dir;
      2: Edit_PathS.Text := dir;
    end;
end;

procedure TfTestExec.BtnClearClick(Sender: TObject);
begin
  Edit_Cmd.Text              := '';
  Edit_Param.Text            := '';
  Edit_Path.Text             := '';
  Edit_StdOut.Text           := '';
  Edit_StdError.Text         := '';
  Edit_RestartCount.ValueInt := -1;
  Editor_Env.Strings.Clear;
  Edit_CmdT.Text             := '';
  Edit_ParamT.Text           := '';
  Edit_PathT.Text            := '';
  Edit_StdOutT.Text          := '';
  Edit_StdErrorT.Text        := '';
  Edit_TimeoutT.ValueInt     := 500;
  Editor_EnvT.Strings.Clear;
  Edit_CmdS.Text             := '';
  Edit_ParamS.Text           := '';
  Edit_PathS.Text            := '';
  Edit_StdOutS.Text          := '';
  Edit_StdErrorS.Text        := '';
  Edit_TimeoutS.ValueInt     := 500;
  Editor_EnvS.Strings.Clear;
end;

procedure TfTestExec.BtnClickBrouse(Sender: TObject);
begin
  case (Sender as TButtonedEdit).Tag of
  0: OpenDialog.FilterIndex := 2;
  1: OpenDialog.FilterIndex := 3;
  2: OpenDialog.FilterIndex := 4;
  3: OpenDialog.FilterIndex := 4;
  end;
  OpenDialog.FileName := '';
  if OpenDialog.Execute then
  case StartPages.ActivePageIndex of
    0:
      case (Sender as TButtonedEdit).Tag of
        0: Edit_Cmd.Text      := OpenDialog.FileName;
        1: Edit_Param.Text    := OpenDialog.FileName;
        2: Edit_StdOut.Text   := OpenDialog.FileName;
        3: Edit_StdError.Text := OpenDialog.FileName;
      end;
    1:
      case (Sender as TButtonedEdit).Tag of
        0: Edit_CmdT.Text      := OpenDialog.FileName;
        1: Edit_ParamT.Text    := OpenDialog.FileName;
        2: Edit_StdOutT.Text   := OpenDialog.FileName;
        3: Edit_StdErrorT.Text := OpenDialog.FileName;
      end;
    2:
      case (Sender as TButtonedEdit).Tag of
        0: Edit_CmdS.Text      := OpenDialog.FileName;
        1: Edit_ParamS.Text    := OpenDialog.FileName;
        2: Edit_StdOutS.Text   := OpenDialog.FileName;
        3: Edit_StdErrorS.Text := OpenDialog.FileName;
      end;
  end;
end;

procedure TfTestExec.Btn_FileSaveClick(Sender: TObject);
var ini: TIniFile;
  i: Integer;
  key, val: string;
begin
  if SaveDialog_Config.Execute then
  begin
    ini := TIniFile.Create(SaveDialog_Config.FileName);
    try
      //---------------------------------------------
      ini.EraseSection(GRUOP_START);
      ini.WriteString(GRUOP_START,  FIELD_CMD,      format('"%s"',[Edit_Cmd.Text]));
      ini.WriteString(GRUOP_START,  FIELD_PARAM,    format('"%s"',[Edit_Param.Text]));
      ini.WriteString(GRUOP_START,  FIELD_PATH,     format('"%s"',[Edit_Path.Text]));
      ini.WriteString(GRUOP_START,  FIELD_STDOUT,   format('"%s"',[Edit_StdOut.Text]));
      ini.WriteString(GRUOP_START,  FIELD_STDERROR, format('"%s"',[Edit_StdError.Text]));
      ini.WriteInteger(GRUOP_START, FIELD_CNT,      Edit_RestartCount.ValueInt);
      ini.EraseSection(GRUOP_ENV_START);
      i := Editor_Env.RowCount;
      while i>0 do
      begin
        dec(i);
        key := Editor_Env.Keys[i].Trim();
        val := Editor_Env.Values[key].Trim();
        if (key<>'')and(val<>'') then
          ini.WriteString(GRUOP_ENV_START, key, val);
      end;
      //---------------------------------------------
      ini.EraseSection(GRUOP_TERM);
      ini.WriteString(GRUOP_TERM,  FIELD_CMD,      format('"%s"',[Edit_CmdT.Text]));
      ini.WriteString(GRUOP_TERM,  FIELD_PARAM,    format('"%s"',[Edit_ParamT.Text]));
      ini.WriteString(GRUOP_TERM,  FIELD_PATH,     format('"%s"',[Edit_PathT.Text]));
      ini.WriteString(GRUOP_TERM,  FIELD_STDOUT,   format('"%s"',[Edit_StdOutT.Text]));
      ini.WriteString(GRUOP_TERM,  FIELD_STDERROR, format('"%s"',[Edit_StdErrorT.Text]));
      ini.WriteInteger(GRUOP_TERM, FIELD_CNT,      Edit_TimeoutT.ValueInt);
      //ini.WriteBool(GRUOP_TERM,    FIELD_ENABLE,   CheckBox_RunToTerminate.Checked);
      ini.EraseSection(GRUOP_ENV_TERM);
      i := Editor_EnvT.RowCount;
      while i>0 do
      begin
        dec(i);
        key := Editor_EnvT.Keys[i].Trim();
        val := Editor_EnvT.Values[key].Trim();
        if (key<>'')and(val<>'') then
          ini.WriteString(GRUOP_ENV_TERM, key, val);
      end;
      //---------------------------------------------
      ini.EraseSection(GRUOP_STOP);
      ini.WriteString(GRUOP_STOP,  FIELD_CMD,      format('"%s"',[Edit_CmdS.Text]));
      ini.WriteString(GRUOP_STOP,  FIELD_PARAM,    format('"%s"',[Edit_ParamS.Text]));
      ini.WriteString(GRUOP_STOP,  FIELD_PATH,     format('"%s"',[Edit_PathS.Text]));
      ini.WriteString(GRUOP_STOP,  FIELD_STDOUT,   format('"%s"',[Edit_StdOutS.Text]));
      ini.WriteString(GRUOP_STOP,  FIELD_STDERROR, format('"%s"',[Edit_StdErrorS.Text]));
      ini.WriteInteger(GRUOP_STOP, FIELD_CNT,      Edit_TimeoutS.ValueInt);
      //ini.WriteBool(GRUOP_STOP,    FIELD_ENABLE,   CheckBox_RunAfterStop.Checked);
      ini.EraseSection(GRUOP_ENV_STOP);
      i := Editor_EnvS.RowCount;
      while i>0 do
      begin
        dec(i);
        key := Editor_EnvS.Keys[i].Trim();
        val := Editor_EnvS.Values[key].Trim();
        if (key<>'')and(val<>'') then
          ini.WriteString(GRUOP_ENV_STOP, key, val);
      end;
      //---------------------------------------------
    except
      on E: Exception do MessageDlg(E.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], E.HelpContext);
    end;
    FreeAndNil(ini);
  end;
end;

procedure TfTestExec.Btn_FileOpenClick(Sender: TObject);
var ini: TIniFile;
  i: Integer;
  s: TStringList;
  key, val: string;
begin
  if OpenDialog_Config.Execute then
  begin
    ini := TIniFile.Create(OpenDialog_Config.FileName);
    try
      s := TStringList.Create();
      //---------------------------------------------
      Edit_Cmd.Text              := ini.ReadString(GRUOP_START,  FIELD_CMD, '');
      Edit_Param.Text            := ini.ReadString(GRUOP_START,  FIELD_PARAM, '');
      Edit_Path.Text             := ini.ReadString(GRUOP_START,  FIELD_PATH, '');
      Edit_StdOut.Text           := ini.ReadString(GRUOP_START,  FIELD_STDOUT, '');
      Edit_StdError.Text         := ini.ReadString(GRUOP_START,  FIELD_STDERROR, '');
      Edit_RestartCount.ValueInt := ini.ReadInteger(GRUOP_START, FIELD_CNT, -1);
      Editor_Env.Strings.Clear;
      s.Clear;
      ini.ReadSection(GRUOP_ENV_START, s);
      i := s.Count;
      while i>0 do
      begin
        dec(i);
        key := s.Strings[i];
        val := ini.ReadString(GRUOP_ENV_START, key, '').Trim;
        key := key.Trim;
        if (key<>'')and(val<>'') then
          Editor_Env.Values[key] := val;
      end;
      //---------------------------------------------
      Edit_CmdT.Text         := ini.ReadString(GRUOP_TERM,  FIELD_CMD, '');
      Edit_ParamT.Text       := ini.ReadString(GRUOP_TERM,  FIELD_PARAM, '');
      Edit_PathT.Text        := ini.ReadString(GRUOP_TERM,  FIELD_PATH, '');
      Edit_StdOutT.Text      := ini.ReadString(GRUOP_TERM,  FIELD_STDOUT, '');
      Edit_StdErrorT.Text    := ini.ReadString(GRUOP_TERM,  FIELD_STDERROR, '');
      Edit_TimeoutT.ValueInt := ini.ReadInteger(GRUOP_TERM, FIELD_CNT, 500);
      //CheckBox_RunToTerminate.Checked := ini.ReadBool(GRUOP_TERM, FIELD_ENABLE, False);
      Editor_EnvT.Strings.Clear;
      s.Clear;
      ini.ReadSection(GRUOP_ENV_TERM, s);
      i := s.Count;
      while i>0 do
      begin
        dec(i);
        key := s.Strings[i];
        val := ini.ReadString(GRUOP_ENV_TERM, key, '').Trim;
        key := key.Trim;
        if (key<>'')and(val<>'') then
          Editor_EnvT.Values[key] := val;
      end;
      //---------------------------------------------
      Edit_CmdS.Text         := ini.ReadString(GRUOP_STOP,  FIELD_CMD, '');
      Edit_ParamS.Text       := ini.ReadString(GRUOP_STOP,  FIELD_PARAM, '');
      Edit_PathS.Text        := ini.ReadString(GRUOP_STOP,  FIELD_PATH, '');
      Edit_StdOutS.Text      := ini.ReadString(GRUOP_STOP,  FIELD_STDOUT, '');
      Edit_StdErrorS.Text    := ini.ReadString(GRUOP_STOP,  FIELD_STDERROR, '');
      Edit_TimeoutS.ValueInt := ini.ReadInteger(GRUOP_STOP, FIELD_CNT, 500);
      //CheckBox_RunAfterStop.Checked := ini.ReadBool(GRUOP_STOP, FIELD_ENABLE, False);
      Editor_EnvS.Strings.Clear;
      s.Clear;
      ini.ReadSection(GRUOP_ENV_STOP, s);
      i := s.Count;
      while i>0 do
      begin
        dec(i);
        key := s.Strings[i];
        val := ini.ReadString(GRUOP_ENV_STOP, key, '').Trim;
        key := key.Trim;
        if (key<>'')and(val<>'') then
          Editor_EnvS.Values[key] := val;
      end;
      //---------------------------------------------
      FreeAndNil(s);
    except
      on E: Exception do MessageDlg(E.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], E.HelpContext);
    end;
    FreeAndNil(ini);
  end;
end;

end.
