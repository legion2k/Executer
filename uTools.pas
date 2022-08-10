unit uTools;

interface

uses System.Classes, Winapi.Windows;

type
  Tools = class
  public
    class function iff<T>(Condition: Boolean; TrueVal: T; FalseVal: T): T; static;
  end;

  TThreadProc = class(TThread)
  private
    _proc: TThreadProcedure;
    _repeat: boolean;
    _sync: Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(Proc: TThreadProcedure; ProcSync: Boolean = False; RepeatWhileNotTeminate: Boolean = false; CreateSuspended: Boolean = False);
  end;

  procedure RaiseGetLastError(error: DWORD); overload;
  procedure RaiseGetLastError(); overload;

implementation
uses System.SysUtils;

{ TOOL }

class function Tools.iff<T>(Condition: Boolean; TrueVal, FalseVal: T): T;
begin
  if Condition then
    Result := TrueVal
  else
    Result := FalseVal;
end;

{ TThreadProc }

constructor TThreadProc.Create;
begin
  inherited create(CreateSuspended);
  _proc := Proc;
  _repeat := RepeatWhileNotTeminate;
  _sync := ProcSync;
  FreeOnTerminate := True;
end;

procedure TThreadProc.Execute;
begin
  inherited;
  repeat
    if _sync then
      Synchronize(_proc)
    else
      _proc();
  until ( (not _repeat) or (Terminated) );
end;

//----------------------------------------------------------------------------------------------------------------------
procedure RaiseGetLastError(error: DWORD);
begin
  raise Exception.CreateHelp(SysErrorMessage(error), error);
end;

procedure RaiseGetLastError(); overload;
begin
  RaiseGetLastError(GetLastError);
end;

end.
