unit uServiceTools;

interface
uses Winapi.WinSvc, Winapi.Windows, System.Classes, System.Generics.Collections;

type
  TServiceDependence = record
    isGroup: Boolean;
    NameServiceOrGroup: string;
  end;
  TServiceDependencies = System.TArray<TServiceDependence>;
  TServiceInfo = record
    Name: string;
    DisplayName: string;
    Description: string;
    State: DWORD;
    StartType: DWORD;
    ServiceType: DWORD;
    ExeName: string;
    Group: record
      Name: string;
      ID: DWORD;
    end;
    User: string;
    Dependencies: TServiceDependencies;
  end;
  TServicesList = System.TArray<TServiceInfo>;
//----------------------------------------------------------------
  TServiceManager = class
  private
    hSCManager: SC_HANDLE;
    procedure OpenManager();
    procedure CloseManager();
  public
    constructor Create();
    destructor Destroy(); override;
    function  GetServicesList(ServiceType: DWORD = SERVICE_WIN32; ServiceState: DWORD = SERVICE_STATE_ALL): TServicesList;
    function  GetState(ServiceName: string): DWORD;
    procedure Start(ServiceName: string);
    procedure Stop(ServiceName: string);
    procedure Add(ExeName: string; Name, DisplayName, ConfigFile, Login, Password, Dependence, Description: string);
    procedure Delete(ServiceName: string);
    //--------------------------------
    class function StartTypeToStr(StartType: DWORD): string;
    class function ServiceTypeToArr(ServiceType: DWORD): System.TArray<System.string>;
    class function ServiceTypeToStr(ServiceType: DWORD; sep: string =', '; fmtType: string = '%s'): string;
    class function CurrentStateToStr(CurrentState: DWORD): string;
    class function ErrorControlToStr(ErrorControl: DWORD): string;
    class function DependenciesToArr(pDependencies: LPWSTR): TServiceDependencies;
    class function DependenciesToStr(Dependencies: TServiceDependencies; sep: string =', '; fmtNameSrv: string = '%s'; fmtNameGrp: string = '[%s]'): string;
  end;
//----------------------------------------------------------------
implementation

uses uTools, System.SysUtils, System.Win.Registry, uConst;

{ TServiceManager }

class function TServiceManager.CurrentStateToStr(CurrentState: DWORD): string;
begin
  case CurrentState of
    SERVICE_STOPPED:          Result := 'Остановлена';
    SERVICE_START_PENDING:    Result := 'Запуск';
    SERVICE_STOP_PENDING:     Result := 'Останав';
    SERVICE_RUNNING:          Result := 'Запущена';
    SERVICE_CONTINUE_PENDING: Result := 'Запуск после приостановки';
    SERVICE_PAUSE_PENDING:    Result := 'Приостановка';
    SERVICE_PAUSED:           Result := 'Приостановлена';
    else Result := '?';
  end;
end;

class function TServiceManager.StartTypeToStr(StartType: DWORD): string;
begin
  case StartType of
    SERVICE_AUTO_START:   Result := 'Автоматически';
    SERVICE_BOOT_START:   Result := 'При загрузке';
    SERVICE_DEMAND_START: Result := 'Вручную';
    SERVICE_DISABLED:     Result := 'Отключена';
    SERVICE_SYSTEM_START: Result := 'При старте системы';
    else Result := '?';
  end;
end;

class function TServiceManager.ServiceTypeToArr(ServiceType: DWORD): System.TArray<System.string>;
const ServiceTypes: array of dword = [
    SERVICE_INTERACTIVE_PROCESS,
    SERVICE_FILE_SYSTEM_DRIVER,
    SERVICE_KERNEL_DRIVER,
    SERVICE_WIN32_OWN_PROCESS,
    SERVICE_WIN32_SHARE_PROCESS
];
var tip: DWORD;
    r: TList<string>;
begin
  r := TList<string>.Create;
  for tip in ServiceTypes do
  if (ServiceType and tip)=tip then
  begin
    case tip of
      SERVICE_INTERACTIVE_PROCESS: r.Add('Интерактивная служба');
      SERVICE_FILE_SYSTEM_DRIVER:  r.Add('Драйвер файловой системы');
      SERVICE_KERNEL_DRIVER:       r.Add('Сервисный драйвер');
      SERVICE_WIN32_OWN_PROCESS:   r.Add('Служба, которая запускается в своем собственном процессе');
      SERVICE_WIN32_SHARE_PROCESS: r.Add('Служба, которая совместно использует процесс с другими службами');
      else r.Add('?');
    end;
  end;
  Result := r.ToArray;
  FreeAndNil(r);
end;

class function TServiceManager.ServiceTypeToStr;
var s: System.TArray<System.string>;
    i: NativeInt;
begin
  s := ServiceTypeToArr(ServiceType);
  i := Length(s);
  while i>0 do
  begin
    Dec(i);
    s[i] := Format(fmtType,[s[i]])
  end;
  Result := string.Join(sep, s);
end;

class function TServiceManager.ErrorControlToStr(ErrorControl: DWORD): string;
begin
  case ErrorControl of
      SERVICE_ERROR_IGNORE:   Result := 'Запуск (начальная загрузка) программы регистрирует ошибку, но продолжает операцию запуска.';
      SERVICE_ERROR_NORMAL:   Result := 'Запуск программы регистрирует ошибку и показывает на экране всплывающее окно сообщения, но продолжает операцию запуска.';
      SERVICE_ERROR_SEVERE:   Result := 'Запуск программы регистрирует ошибку. Если запускается последняя из известных конфигурация без ошибок, продолжается операция запуска. Иначе, система перезапускается с последней, заведомо без ошибок конфигурацией.';
      SERVICE_ERROR_CRITICAL: Result := 'Запуск программы, если возможно, регистрирует ошибку. Если запускается последняя из известных конфигурация без ошибок, операция запуска завершается ошибкой. Иначе, система перезапускается с последней из известных конфигураций без ошибок.';
    else Result := '?';
  end;
end;

class function TServiceManager.DependenciesToArr(pDependencies: LPWSTR): TServiceDependencies;
var
  r: TList<TServiceDependence>;
  s: string;
  d: TServiceDependence;
begin
  if pDependencies=nil then
    SetLength(Result,0)
  else
  begin
    r := TList<TServiceDependence>.Create;
    while pDependencies[0]<>#0 do
    begin
      s := pDependencies;
      inc(pDependencies, length(s)+1);
      d.isGroup := s[1]=SC_GROUP_IDENTIFIER;
      d.NameServiceOrGroup := Tools.iff<string>(d.isGroup, Copy(s,2,length(s)-1), s);
      r.Add(d);
    end;
    Result := r.ToArray;
  end;
end;

class function TServiceManager.DependenciesToStr;
var i: Integer;
begin
  Result := '';
  i := length(Dependencies);
  while i>0 do
  begin
    Dec(i);
    Result := Result + tools.iff<string>(Result='','',sep) + format(Tools.iff<string>(Dependencies[i].isGroup, fmtNameGrp, fmtNameSrv), [Dependencies[i].NameServiceOrGroup]);
  end;
end;

//----------------------------------------------------------------------------------------------------------------------
constructor TServiceManager.Create;
begin
  OpenManager;
  if hSCManager=0 then
     RaiseGetLastError;
  inherited Create;
end;

destructor TServiceManager.Destroy;
begin
  CloseManager;
  inherited;
end;

procedure TServiceManager.OpenManager;
begin
  hSCManager := OpenSCManager(nil, nil, SC_MANAGER_ALL_ACCESS);
end;

procedure TServiceManager.CloseManager;
begin
  if hSCManager<>0 then
    CloseServiceHandle(hSCManager);
end;
//----------------------------------------------------------------------------------------------------------------------
function TServiceManager.GetServicesList;
type
  TLst = TList<TServiceInfo>;
var
  NeedBytes, SrvCount, hResume: DWORD;
  pServices, pSrv: PEnumServiceStatus;
  e: DWORD;
  hSrv: SC_HANDLE;
  pSrvCfg: PQueryServiceConfig;
  pSrvDesc: PByte;
  inf: TServiceInfo;
  list: TLst;
begin
  hResume := 0;
  EnumServicesStatus(hSCManager, ServiceType, ServiceState, nil, 0, NeedBytes, SrvCount, hResume);
  e := GetLastError;
  if e<>ERROR_MORE_DATA then
    RaiseGetLastError(e);
  //---
  hResume := 0;
  GetMem(pServices, NeedBytes);
  if not EnumServicesStatus(hSCManager, ServiceType, ServiceState, pServices, NeedBytes, NeedBytes, SrvCount, hResume) then
  begin
    FreeMem(pServices);
    RaiseGetLastError;
  end;
  //---
  list := TLst.Create;
  pSrv := pServices;
  while SrvCount>0 do
  begin
    dec(SrvCount);
    inf.Name         := pSrv.lpServiceName;
    inf.DisplayName  := pSrv.lpDisplayName;
    inf.State        := pSrv.ServiceStatus.dwCurrentState;
    inf.ServiceType  := pSrv.ServiceStatus.dwServiceType;
    inf.Description  := '';
    inf.StartType    := 0;
    inf.ExeName      := '';
    inf.Group.Name   := '';
    inf.Group.ID     := 0;
    inf.User         := '';
    inf.Dependencies := [];
    // Для дополнительной информаци по сервису получаем описатель сервиса
    hSrv := OpenService(hSCManager, pSrv.lpServiceName, SERVICE_QUERY_CONFIG);
    if hSrv<>0 then
    begin
      // получаем описание
      QueryServiceConfig2(hSrv, SERVICE_CONFIG_DESCRIPTION, nil, 0, @NeedBytes);
      if GetLastError=ERROR_INSUFFICIENT_BUFFER then
      begin
        GetMem(pSrvDesc, NeedBytes);
        if QueryServiceConfig2(hSrv, SERVICE_CONFIG_DESCRIPTION, pSrvDesc, NeedBytes, @NeedBytes) then
          inf.Description := LPSERVICE_DESCRIPTION(pSrvDesc).lpDescription;
        FreeMem(pSrvDesc);
      end;
      // получаем дополнительную информаци по сервису
      QueryServiceConfig(hSrv, nil, 0, NeedBytes);
      if GetLastError=ERROR_INSUFFICIENT_BUFFER then
      begin
        GetMem(pSrvCfg, NeedBytes);
        if QueryServiceConfig(hSrv, pSrvCfg, NeedBytes, NeedBytes) then
        begin
          inf.StartType    := pSrvCfg.dwStartType;
          inf.ExeName      := pSrvCfg.lpBinaryPathName;
          inf.Group.Name   := pSrvCfg.lpLoadOrderGroup;
          inf.Group.ID     := pSrvCfg.dwTagId;
          inf.User         := pSrvCfg.lpServiceStartName;
          inf.Dependencies := DependenciesToArr(pSrvCfg.lpDependencies);
        end;
        FreeMem(pSrvCfg);
      end;
    end;
    list.Add(inf);
    inc(pSrv);
  end;
  FreeMem(pServices);
  Result := list.ToArray;
  FreeAndNil(list);
end;

//----------------------------------------------------------------------------------------------------------------------
function  TServiceManager.GetState(ServiceName: string): DWORD;
var hService: SC_HANDLE;
    ret: BOOL;
    status: SERVICE_STATUS;
begin
  Result := 0;
  hService:= OpenService(hSCManager, LPCWSTR(ServiceName), SERVICE_QUERY_STATUS);
  if hService = 0 then
    //RaiseGetLastError();
    exit;
  ret := QueryServiceStatus(hService, status);
  if ret then
    Result := status.dwCurrentState;
  CloseServiceHandle(hService);
  //if not ret then
  //  RaiseGetLastError;

end;

//----------------------------------------------------------------------------------------------------------------------
procedure TServiceManager.Stop(ServiceName: string);
var hService: SC_HANDLE;
    ret: BOOL;
    status: SERVICE_STATUS;
begin
  hService:= OpenService(hSCManager, LPCWSTR(ServiceName), SERVICE_STOP or SERVICE_QUERY_CONFIG);
  if hService = 0 then
    RaiseGetLastError();
  ret := ControlService(hService, SERVICE_CONTROL_STOP, status);
  CloseServiceHandle(hService);
  if not ret then
    RaiseGetLastError;
end;

//----------------------------------------------------------------------------------------------------------------------
procedure TServiceManager.Start(ServiceName: string);
var hService: SC_HANDLE;
    pArgs: LPCTSTR;
    ret: BOOL;
begin
  hService:= OpenService(hSCManager, LPCWSTR(ServiceName), SERVICE_START or SERVICE_QUERY_CONFIG);
  if hService = 0 then
    RaiseGetLastError();
  pArgs := nil;
  ret := StartService(hService, 0, pArgs);
  CloseServiceHandle(hService);
  if not ret then
    RaiseGetLastError;
end;
//----------------------------------------------------------------------------------------------------------------------
procedure TServiceManager.Delete(ServiceName: string);
var hService: SC_HANDLE;
    ok: BOOL;
    Reg: TRegistry;
    err: string;
begin
  hService:= OpenService(hSCManager, LPCWSTR(ServiceName), SERVICE_ALL_ACCESS);
  if hService = 0 then
    RaiseGetLastError();
  ok := DeleteService(hService);
  CloseServiceHandle(hService);
  if ok then
  begin
    err := '';
    Reg := TRegIniFile.Create(KEY_WRITE);
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.DeleteKey(format(EVENT_LOG_KEY,[ServiceName]));
      Reg.CloseKey;
    except
      on e: Exception do err := e.Message;
    end;
    FreeAndNil(Reg);
  end
  else
    RaiseGetLastError;
//  CloseManager;
//  Sleep(100);
//  OpenManager;
  if err<>'' then
    raise Exception.Create(err);
end;

//----------------------------------------------------------------------------------------------------------------------
procedure TServiceManager.Add;
var
  hService: SC_HANDLE;
  BinaryPathName: string;
  ret: BOOL;
begin
  BinaryPathName := format('"%s" -s "%s" "%s"',[ExeName, Name, ConfigFile]);
  hService := CreateService(
    hSCManager,                   // Дескриптор базы данных диспетчера управления службой.
    LPCWSTR(Name),                // задает устанавливаемое имя службы
    LPCWSTR(DisplayName),         // [optional] отображаемое имя, которое используется пользовательскими программами интерфейса, чтобы идентифицировать службу
    SERVICE_ALL_ACCESS,           // Доступ к службе. Перед предоставлением требуемого доступа, система проверяет маркер доступа вызывающего процесса
    SERVICE_WIN32_OWN_PROCESS or
    SERVICE_INTERACTIVE_PROCESS,  // Типы службы
    SERVICE_AUTO_START,           // Варианты запуска службы.
    SERVICE_ERROR_NORMAL,         // Серьезность ошибки и предпринимаемое действие, если эта служба не в состоянии запуститься.
    LPCWSTR(BinaryPathName),      // полный путь доступа к двоичному файлу службы. Путь может также включать в себя и параметры для автозапуска службы.
    nil,
    nil,
    LPCWSTR(Dependence),
    Tools.iff<LPCWSTR>( Login='', nil, LPCWSTR(Login)),
    Tools.iff<LPCWSTR>( Password='', nil, LPCWSTR(Password)));
  if hService=0 then
    RaiseGetLastError
  else
  begin
    var Reg: TRegistry;
    var err: string;
    err := '';
    Reg := TRegIniFile.Create(KEY_WRITE);
    try
      Reg.RootKey := HKEY_LOCAL_MACHINE;
      Reg.OpenKey(format(EVENT_LOG_KEY,[name]), true);
      // Файл, содержащий ресурсы строк категорий.
      Reg.WriteString('CategoryMessageFile',ExeName);
      // Файл, содержащий ресурсы строк событий.
      Reg.WriteString('EventMessageFile',   ExeName);
      // Количество категорий событий, которые вы собираетесь использовать. (Это максимальная величина, и не будет проблем, если не все категории на самом деле будут применяться).
      //Reg.WriteInteger('CategoryCount',7);
      // Допустимые типы событий.
      Reg.WriteInteger('TypesSupported',EVENTLOG_SUCCESS or EVENTLOG_ERROR_TYPE or EVENTLOG_WARNING_TYPE or EVENTLOG_INFORMATION_TYPE);
      // Если значение – 1, то пользователи под учётной записью Guest и Anonymous не имеют доступа к журналу. По умолчанию – 0.
      //Reg.WriteInteger('RestrictGuestAccess', 0);
      Reg.CloseKey;
    except
      on ex: Exception do  err := ex.Message;
    end;
    FreeAndNil(reg);
    //-------------------
    var desc: SERVICE_DESCRIPTION;
    desc.lpDescription := LPWSTR(Description);
    ret := ChangeServiceConfig2(hService, SERVICE_CONFIG_DESCRIPTION, @desc);
    CloseServiceHandle(hService);
    if not ret then
      RaiseGetLastError
    else if err<>'' then
      raise Exception.Create(err);
  end;
end;

end.
