unit uExecuter;

interface

uses
  System.Classes, System.Generics.Collections, Winapi.Windows;

type
  //------------------------------------------------------------
  TEnvDict = TDictionary<string, string>;
  TEnvironment = class
  private
    env: TEnvDict;
  public
    procedure Add(Key, Value: string);overload;
    procedure Add(EnvDict: TEnvDict);overload;
    function ToEnvironmentBlock(): string;
    constructor Create();
    destructor Destroy; override;
  end;
  //------------------------------------------------------------
  TExeParam = record
    cmd, param, dir, fileStd, fileError: string;
    env: AnsiString;
    cnt: Integer;
  end;
  //------------------------------------------------------------
  TExecuter = class(TThread)
  private
    startP, termP, stopP: TExeParam;
    ProcInfo: TProcessInformation;
    hideWin, msgBox: Boolean;
    //termRun, stopRun: Boolean;
    protected procedure Execute(); override;
    procedure TerminatedSet; override;
    procedure SendMes(msg: String);
  public
    constructor Create(MesBox: Boolean; HideWindow: Boolean; StartParm, TermParm, StopParm: TExeParam);
    destructor Destroy; override;
  end;
  //------------------------------------------------------------

implementation

uses uTools, System.SysUtils, uFormMain, Vcl.Dialogs, System.UITypes, uService;

//----------------------------------------------------------------------------------------------------------------------
// TEnvironment
//----------------------------------------------------------------------------------------------------------------------
constructor TEnvironment.Create;
var
  s: LPWSTR;
  key, val: string;
  c0: Byte;
  i: UInt32;
  keyValSwitch: Boolean;
begin
  inherited Create;
  env := TEnvDict.Create();
  key := '';
  val := '';
  c0 := 0;
  i := 0;
  keyValSwitch := False;
  s := GetEnvironmentStrings;
  while c0<2 do
  begin
    if s[i]=#0 then
    begin
      Inc(c0);
      if key<>'' then
        env.Add(key, val);
      keyValSwitch := False;
      key := '';
      val := '';
    end
    else
    begin
      c0 := 0;
      if s[i]='=' then
      begin
        keyValSwitch := True;
      end
      else
      begin
        case keyValSwitch of
        False:
          key := key + s[i];
        True:
          val := val + s[i];
        end;
      end;
    end;
    inc(i);
  end;
end;

destructor TEnvironment.Destroy;
begin
  env.Free;
  inherited Destroy;
end;

procedure TEnvironment.Add(Key, Value: string);
var v: string;
begin
  if env.TryGetValue(Key, v) then
    Value := Value + ';' + v;
  env.AddOrSetValue(Key, Value);
end;

procedure TEnvironment.Add(EnvDict: TEnvDict);
var key: string;
begin
  for key in EnvDict.Keys do
    Add(key, EnvDict[key]);
end;

function TEnvironment.ToEnvironmentBlock: string;
var key: string;
begin
  Result := '';
  for key in env.Keys do
    Result := Result + key +'='+ env[key] + #0;
  if Length(Result)=0 then
    Result := #0;
  Result := Result + #0;
end;

//----------------------------------------------------------------------------------------------------------------------
// TExecuter
//----------------------------------------------------------------------------------------------------------------------
constructor TExecuter.Create;
begin
  inherited Create(True);
  //-----------------
  startP := StartParm;
  termP  := TermParm;
  stopP  := StopParm;
  //-----------------
  //termRun := RunTerm;
  //stopRun := RunStop;
  //-----------------
  hideWin := HideWindow;
  msgBox := MesBox;
end;

destructor TExecuter.Destroy;
begin
  inherited Destroy;
end;

procedure TExecuter.Execute;
var
  StartInfo: TStartupInfo;
  hStdFile, hErrorFile: THandle;
  fileSecAttr: TSecurityAttributes;
  startCnt: UInt16;
begin
  FreeOnTerminate := True;
  //--------------------------
  hStdFile := 0;
  hErrorFile := 0;
  fileSecAttr.nLength := sizeof(fileSecAttr);
  fileSecAttr.lpSecurityDescriptor := nil;
  fileSecAttr.bInheritHandle := True;
  if startP.fileStd<>'' then
  begin
    hStdFile := CreateFile(
        LPCWSTR(startP.fileStd),
        FILE_APPEND_DATA, FILE_SHARE_WRITE or FILE_SHARE_READ, @fileSecAttr, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    if hStdFile=INVALID_HANDLE_VALUE then
    begin
      hStdFile := 0;
      SendMes( format('При открытие файла «%s» произошла ошибка: %s',[ startP.fileStd, SysErrorMessage(GetLastError)] ));
    end;
  end;
  if startP.fileError=startP.fileStd then
    hErrorFile := hStdFile
  else if startP.fileError<>'' then
  begin
    hErrorFile := CreateFile(
        LPCWSTR(startP.fileError),
        FILE_APPEND_DATA, FILE_SHARE_WRITE or FILE_SHARE_READ, @fileSecAttr, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    if hErrorFile=INVALID_HANDLE_VALUE then
    begin
      hErrorFile := 0;
      SendMes( format('При открытие файла «%s» произошла ошибка: %s',[ startP.fileStd, SysErrorMessage(GetLastError)] ));
    end;
  end;
  //--------------------------
  startCnt := 0;
  while not Terminated do
  begin
    inc(startCnt);
    FillChar(StartInfo, SizeOf(StartInfo), 0);
    StartInfo.cb         := SizeOf(StartInfo);
    StartInfo.dwFlags    := Tools.iff<DWORD>( (hStdFile=0)and(hErrorFile=0), 0, STARTF_USESTDHANDLES );
    StartInfo.hStdInput  := 0;
    StartInfo.hStdOutput := hStdFile;
    StartInfo.hStdError  := hErrorFile;

    FillChar(ProcInfo, SizeOf(ProcInfo), 0);

    if CreateProcess(
      Tools.iff<LPCWSTR>(  startP.cmd='', nil, LPCWSTR(startP.cmd)),
      Tools.iff<LPWSTR >(startP.param='', nil, LPWSTR(startP.param)),
      nil, nil, True, Tools.iff<DWORD>(hideWin, CREATE_NO_WINDOW, 0),
      Tools.iff<PAnsiChar>(startP.env='', nil, PAnsiChar(startP.env)),
      Tools.iff<LPCWSTR>(  startP.dir='', nil, LPCWSTR(startP.dir)),
      StartInfo, ProcInfo) then
    begin
      // Ждем завершения инициализации.
      WaitForInputIdle(ProcInfo.hProcess, INFINITE);
      // Ждем завершения процесса.
      WaitforSingleObject(ProcInfo.hProcess, INFINITE);
      // Получаем код завершения.
      // GetExitCodeProcess(ProcInfo.hProcess, ExitCode);
      // Закрываем дескриптор процесса.
      CloseHandle(ProcInfo.hThread);
      // Закрываем дескриптор потока.
      CloseHandle(ProcInfo.hProcess);
      if not Terminated then
        if not msgBox then
          Synchronize( procedure begin
            // перезапуск процесса
            fService.LogMessage('',EVENTLOG_WARNING_TYPE,0, 1);
          end);
    end
    else
    begin
      SendMes( format('При запуске процесса произошла ошибка: %s',[ SysErrorMessage(GetLastError)] ));
    end;
    if(startP.cnt>=0)and(startP.cnt>startCnt)then
      Terminate;
    if not Terminated then
      Sleep(1000);
  end;
  if startP.fileStd<>'' then
    CloseHandle(hStdFile);
  if (startP.fileError<>'') and (startP.fileError<>startP.fileStd) then
    CloseHandle(hErrorFile);
  //---------------------------------------------------------------------------------
  // Пост запуск
  //---------------------------------------------------------------------------------
  if(stopP.cmd<>'')or(stopP.param<>'')then begin
    hStdFile   := 0;
    hErrorFile := 0;
    fileSecAttr.nLength := sizeof(fileSecAttr);
    fileSecAttr.lpSecurityDescriptor := nil;
    fileSecAttr.bInheritHandle := True;
    if stopP.fileStd<>'' then begin
      hStdFile := CreateFile( LPCWSTR(stopP.fileStd), FILE_APPEND_DATA, FILE_SHARE_WRITE or FILE_SHARE_READ, @fileSecAttr, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
      if hStdFile=INVALID_HANDLE_VALUE then begin
        hStdFile := 0;
        SendMes( format('При открытие файла «%s» произошла ошибка: %s',[ stopP.fileStd, SysErrorMessage(GetLastError)] ));
      end;
    end;
    if stopP.fileError=stopP.fileStd then
      hErrorFile := hStdFile
    else if stopP.fileError<>'' then begin
      hErrorFile := CreateFile( LPCWSTR(stopP.fileError), FILE_APPEND_DATA, FILE_SHARE_WRITE or FILE_SHARE_READ, @fileSecAttr, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
      if hErrorFile=INVALID_HANDLE_VALUE then begin
        hErrorFile := 0;
        SendMes( format('При открытие файла «%s» произошла ошибка: %s',[ stopP.fileStd, SysErrorMessage(GetLastError)] ));
      end;
    end;
    //---------------------------------------------------------------------------------
    FillChar(StartInfo, SizeOf(StartInfo), 0);
    StartInfo.cb         := SizeOf(StartInfo);
    StartInfo.dwFlags    := Tools.iff<DWORD>( (hStdFile=0)and(hErrorFile=0), 0, STARTF_USESTDHANDLES );
    StartInfo.hStdInput  := 0;
    StartInfo.hStdOutput := hStdFile;
    StartInfo.hStdError  := hErrorFile;

    FillChar(ProcInfo, SizeOf(ProcInfo), 0);

    if CreateProcess(
      Tools.iff<LPCWSTR>(  stopP.cmd='', nil, LPCWSTR(stopP.cmd)),
      Tools.iff<LPWSTR >(stopP.param='', nil, LPWSTR(stopP.param)),
      nil, nil, True, Tools.iff<DWORD>(hideWin, CREATE_NO_WINDOW, 0),
      Tools.iff<PAnsiChar>(stopP.env='', nil, PAnsiChar(stopP.env)),
      Tools.iff<LPCWSTR>(  stopP.dir='', nil, LPCWSTR(stopP.dir)),
      StartInfo, ProcInfo) then begin
      // Ждем завершения инициализации.
      WaitForInputIdle(ProcInfo.hProcess, DWORD(stopP.cnt));
      // Ждем завершения процесса.
      WaitforSingleObject(ProcInfo.hProcess, DWORD(stopP.cnt));
      // Получаем код завершения.
      // GetExitCodeProcess(ProcInfo.hProcess, ExitCode);
      // Закрываем дескриптор процесса.
      CloseHandle(ProcInfo.hThread);
      // Закрываем дескриптор потока.
      CloseHandle(ProcInfo.hProcess);
      //ProcInfo.hProcess := 0;
    end
    else
      SendMes( format('При запуске пост процесса произошла ошибка: %s',[ SysErrorMessage(GetLastError)] ));
    if stopP.fileStd<>'' then
      CloseHandle(hStdFile);
    if (stopP.fileError<>'') and (stopP.fileError<>stopP.fileStd) then
      CloseHandle(hErrorFile);
  end;
  //---------------------------------------------------------------------------------
end;

procedure TExecuter.SendMes(msg: String);
var stop: Boolean;
begin
  if msgBox then
  begin
    Synchronize( procedure begin
      stop := MessageDlg(msg, TMsgDlgType.mtError, [TMsgDlgBtn.mbRetry, TMsgDlgBtn.mbCancel], 0, TMsgDlgBtn.mbCancel)=mrCancel;
    end);
    if stop then
    begin
      TThreadProc.Create(procedure begin
        uFormMain.FormMain.TestExec.BtnTerminateClick(nil);
      end, True);
    end;
  end
  else
  begin
    Synchronize(procedure begin
      fService.LogMessage(msg,EVENTLOG_ERROR_TYPE);
    end)
  end;
end;

procedure TExecuter.TerminatedSet;
begin
  inherited;
  if ProcInfo.hProcess<>0 then
  begin
    //---------------------------------------------------------------------------------
    if(termP.cmd<>'')or(termP.param<>'')then
    begin
      var hStdFile, hErrorFile: THandle;
      var StartInfo: TStartupInfo;
      var fileSecAttr: TSecurityAttributes;
      hStdFile   := 0;
      hErrorFile := 0;
      fileSecAttr.nLength := sizeof(fileSecAttr);
      fileSecAttr.lpSecurityDescriptor := nil;
      fileSecAttr.bInheritHandle := True;
      if termP.fileStd<>'' then begin
        hStdFile := CreateFile( LPCWSTR(termP.fileStd), FILE_APPEND_DATA, FILE_SHARE_WRITE or FILE_SHARE_READ, @fileSecAttr, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
        if hStdFile=INVALID_HANDLE_VALUE then begin
          hStdFile := 0;
          SendMes( format('При открытие файла «%s» произошла ошибка: %s',[ termP.fileStd, SysErrorMessage(GetLastError)] ));
        end;
      end;
      if termP.fileError=termP.fileStd then
        hErrorFile := hStdFile
      else if termP.fileError<>'' then begin
        hErrorFile := CreateFile( LPCWSTR(termP.fileError), FILE_APPEND_DATA, FILE_SHARE_WRITE or FILE_SHARE_READ, @fileSecAttr, OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
        if hErrorFile=INVALID_HANDLE_VALUE then begin
          hErrorFile := 0;
          SendMes( format('При открытие файла «%s» произошла ошибка: %s',[ termP.fileStd, SysErrorMessage(GetLastError)] ));
        end;
      end;
      //---------------------------------------------------------------------------------
      FillChar(StartInfo, SizeOf(StartInfo), 0);
      StartInfo.cb         := SizeOf(StartInfo);
      StartInfo.dwFlags    := Tools.iff<DWORD>( (hStdFile=0)and(hErrorFile=0), 0, STARTF_USESTDHANDLES );
      StartInfo.hStdInput  := 0;
      StartInfo.hStdOutput := hStdFile;
      StartInfo.hStdError  := hErrorFile;

      FillChar(ProcInfo, SizeOf(ProcInfo), 0);

      if CreateProcess(
        Tools.iff<LPCWSTR>(  termP.cmd='', nil, LPCWSTR(termP.cmd)),
        Tools.iff<LPWSTR >(termP.param='', nil, LPWSTR(termP.param)),
        nil, nil, True, Tools.iff<DWORD>(hideWin, CREATE_NO_WINDOW, 0),
        Tools.iff<PAnsiChar>(termP.env='', nil, PAnsiChar(termP.env)),
        Tools.iff<LPCWSTR>(  termP.dir='', nil, LPCWSTR(termP.dir)),
        StartInfo, ProcInfo) then begin
        // Ждем завершения инициализации.
        WaitForInputIdle(ProcInfo.hProcess, DWORD(termP.cnt));
        // Ждем завершения процесса.
        WaitforSingleObject(ProcInfo.hProcess, DWORD(termP.cnt));
        // Получаем код завершения.
        // GetExitCodeProcess(ProcInfo.hProcess, ExitCode);
        // Закрываем дескриптор процесса.
        CloseHandle(ProcInfo.hThread);
        // Закрываем дескриптор потока.
        CloseHandle(ProcInfo.hProcess);
      end
      else
        SendMes( format('При запуске terminate процесса произошла ошибка: %s',[ SysErrorMessage(GetLastError)] ));
    if termP.fileStd<>'' then
      CloseHandle(hStdFile);
    if (termP.fileError<>'') and (termP.fileError<>termP.fileStd) then
      CloseHandle(hErrorFile);
    end;
    //---------------------------------------------------------------------------------
    if ProcInfo.hProcess<>0 then
    begin
      TerminateThread(ProcInfo.hThread,0);
      TerminateProcess(ProcInfo.hProcess,0);
    end;
  end;
end;

end.
