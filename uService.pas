unit uService;

interface

uses
  uExecuter,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.SvcMgr, Vcl.Dialogs;

type
  TfService = class(TService)
    procedure ServiceStart(Sender: TService; var Started: Boolean);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceCreate(Sender: TObject);
  private
    { Private declarations }
    exec: TExecuter;
    procedure OnTerminate(Sender: TObject);
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  fService: TfService;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

uses System.IniFiles, uConst;


{$R *.dfm}
//{$R mc\EventLog32.res}
{$R mc\EventLog64.res}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  fService.Controller(CtrlCode);
end;

function TfService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TfService.ServiceCreate(Sender: TObject);
var ini: TIniFile;
begin
  if System.ParamCount() > 1 then
  begin
    Name := ParamStr(2);
  end
  else
  begin
    // не указано имя службы
    LogMessage('Не задано имя службы', EVENTLOG_ERROR_TYPE);
    Halt;
  end;
end;

procedure TfService.ServiceStart(Sender: TService; var Started: Boolean);
var ini : TIniFile;
  StartP, TermP, StopP: TExeParam;
  key, val: string;
  s: TStringList;
  i: Integer;
begin
  Started := System.ParamCount()>2;
  if not Started then
    // не указан файл настроек
    LogMessage('Не задан файл настроек', EVENTLOG_ERROR_TYPE)
  else
  begin
    try
      ini := TIniFile.Create(ParamStr(3));
      try
        StartP.cmd       := ini.ReadString(GRUOP_START,  FIELD_CMD, '');
        StartP.param     := ini.ReadString(GRUOP_START,  FIELD_PARAM, '');
        StartP.dir       := ini.ReadString(GRUOP_START,  FIELD_PATH, '');
        StartP.fileStd   := ini.ReadString(GRUOP_START,  FIELD_STDOUT, '');
        StartP.fileError := ini.ReadString(GRUOP_START,  FIELD_STDERROR, '');
        StartP.cnt       := ini.ReadInteger(GRUOP_START, FIELD_CNT, -1);
        StartP.env       := '';

        TermP.cmd        := ini.ReadString(GRUOP_TERM,  FIELD_CMD, '');
        TermP.param      := ini.ReadString(GRUOP_TERM,  FIELD_PARAM, '');
        TermP.dir        := ini.ReadString(GRUOP_TERM,  FIELD_PATH, '');
        TermP.fileStd    := ini.ReadString(GRUOP_TERM,  FIELD_STDOUT, '');
        TermP.fileError  := ini.ReadString(GRUOP_TERM,  FIELD_STDERROR, '');
        TermP.cnt        := ini.ReadInteger(GRUOP_TERM, FIELD_CNT, 500);
        TermP.env        := '';

        StopP.cmd        := ini.ReadString(GRUOP_STOP,  FIELD_CMD, '');
        StopP.param      := ini.ReadString(GRUOP_STOP,  FIELD_PARAM, '');
        StopP.dir        := ini.ReadString(GRUOP_STOP,  FIELD_PATH, '');
        StopP.fileStd    := ini.ReadString(GRUOP_STOP,  FIELD_STDOUT, '');
        StopP.fileError  := ini.ReadString(GRUOP_STOP,  FIELD_STDERROR, '');
        StopP.cnt        := ini.ReadInteger(GRUOP_STOP, FIELD_CNT, 500);
        StopP.env        := '';

        s := TStringList.Create();
        try
          s.Clear;
          ini.ReadSection(GRUOP_ENV_START, s);
          StartP.env := s.Text;
          s.Clear;
          ini.ReadSection(GRUOP_ENV_TERM, s);
          StartP.env := s.Text;
          s.Clear;
          ini.ReadSection(GRUOP_ENV_STOP, s);
          StartP.env := s.Text;
        finally
          FreeAndNil(s);
        end;

      except
        on e: Exception do
        begin
          // ошибка при чтении файла
          Started := false;
          LogMessage(format('При чтение файла настроек «%s» произошла ошибка: %s',[ini.FileName, e.Message]), EVENTLOG_ERROR_TYPE);
        end;
      end;
      FreeAndNil(ini);
      if Started then
      begin
        exec := TExecuter.Create( False, True, StartP, TermP, StopP );
        exec.OnTerminate := OnTerminate;
        exec.Start();
      end;
    except
      on e: Exception do
      begin
        Started := false;
        exec := nil;
        // ошибка при создание потока %s
        LogMessage(format('Ошибка при создание процесса: %s',[e.Message]), EVENTLOG_ERROR_TYPE);
      end;
    end;
  end;
  if Started then
    //LogMessage('Запуск цикла', EVENTLOG_SUCCESS);
    LogMessage('', EVENTLOG_SUCCESS,0,1);
end;

procedure TfService.OnTerminate(Sender: TObject);
begin
  exec := nil;
  if not Terminated then
    DoStop;
end;

procedure TfService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  if exec<>nil then
  begin
    //LogMessage('Останов цикла', EVENTLOG_SUCCESS);
    LogMessage('', EVENTLOG_SUCCESS,0,2);
    exec.Terminate;
    //exec.WaitFor;
    //FreeAndNil(exec);
  end;
end;

end.
