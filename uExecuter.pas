unit uExecuter;

interface

uses
  System.Classes, System.Generics.Collections, Winapi.Windows;

type
  //------------------------------------------------------------
  TExeParam = record
    cmd, param, dir, fileStd, fileError: string;
    env: string;
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
    function setEnv(const Strings: string): AnsiString;
  public
    constructor Create(MesBox: Boolean; HideWindow: Boolean; StartParm, TermParm, StopParm: TExeParam);
    destructor Destroy; override;
  end;
  //------------------------------------------------------------

implementation

uses uTools, System.SysUtils, uFormMain, Vcl.Dialogs, System.UITypes, uService, System.RegularExpressions;


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

function TExecuter.setEnv(const Strings: string): AnsiString;
type
  Win1251String = type AnsiString(1251);
var
  sEnv, se: LPWSTR;
  ss1, ss2: TStrings;
  s: string;
  i: Integer;
begin
  Result := '';
  if Strings='' then Exit;
  sEnv := GetEnvironmentStrings;
  ss1 := TStringList.Create();
  ss2 := TStringList.Create();
  se := sEnv;
  try
    while se[0]<>#0 do begin
      s := se;
      ss1.Add(s);
      se := @se[Length(s)+1];
    end;
    ss2.Text := Strings;
    for i:=0 to ss2.Count-1 do begin
      s := ss2.KeyNames[i];
      //ss1.Values[s] := Tools.iff<string>(ss1.Values[s]<>'', ss1.Values[s]+';', '')+ss2.Values[s];
      ss1.Values[s] := ss1.Values[s] + Tools.iff<string>(ss1.Values[s]<>'', ss1.Values[s]+';', '') + ss2.Values[s];
    end;
    Result := Win1251String( TRegEx.Replace(ss1.Text, '(?si)[\r\n]+', #0) )+#0;
  finally
    FreeEnvironmentStrings(sEnv);
    FreeAndNil(ss1);
    FreeAndNil(ss2);
  end;
end;

procedure TExecuter.Execute;
var
  StartInfo: TStartupInfo;
  hStdFile, hErrorFile: THandle;
  fileSecAttr: TSecurityAttributes;
  startCnt: UInt16;
  env: AnsiString;
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

    env := setEnv(startP.env);
    if CreateProcess(
      Tools.iff<LPCWSTR>(  startP.cmd='', nil, LPCWSTR(startP.cmd)),
      Tools.iff<LPWSTR >(startP.param='', nil, LPWSTR(startP.param)),
      nil, nil, True, Tools.iff<DWORD>(hideWin, CREATE_NO_WINDOW, 0),
      Tools.iff<PAnsiChar>(env='', nil, PAnsiChar(env)),
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

    env := setEnv(stopP.env);
    if CreateProcess(
      Tools.iff<LPCWSTR>(  stopP.cmd='', nil, LPCWSTR(stopP.cmd)),
      Tools.iff<LPWSTR >(stopP.param='', nil, LPWSTR(stopP.param)),
      nil, nil, True, Tools.iff<DWORD>(hideWin, CREATE_NO_WINDOW, 0),
      Tools.iff<PAnsiChar>(env='', nil, PAnsiChar(env)),
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
      var env: AnsiString;
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

      env := setEnv(termP.env);
      if CreateProcess(
        Tools.iff<LPCWSTR>(  termP.cmd='', nil, LPCWSTR(termP.cmd)),
        Tools.iff<LPWSTR >(termP.param='', nil, LPWSTR(termP.param)),
        nil, nil, True, Tools.iff<DWORD>(hideWin, CREATE_NO_WINDOW, 0),
        Tools.iff<PAnsiChar>(env='', nil, PAnsiChar(env)),
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
