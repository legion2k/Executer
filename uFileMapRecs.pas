unit uFileMapRecs;

interface
uses System.Classes, System.SyncObjs;

type
  TFileMap<TRec> = class
  private
  type
    FOnRec = procedure(var rec: TRec) of object;
    FOnStopRead = TNotifyEvent;//procedure() of object;
    TIndex = UInt16;
    PIndex = ^TIndex;
    TRecExt = record
      id: TIndex;
      rec: TRec;
    end;
    TArrRecExt = array [low(TIndex) .. high(TIndex)] of TRecExt;
    PArrRecExt = ^TArrRecExt;
    TLive = UInt32;
    PLive = ^TLive;
    //--------------
    TLiveVarSet = class(TThread)
    private
      p_LiveVar: PLive;
      mtx: TMutex;
    protected
      procedure Execute(); override;
    public
      constructor Create(mutex: TMutex; pLiveVar: PLive);
    end;
    //--------------
    TReadData = class(TThread)
    private
      uMaxCount: TIndex;
      p_LiveVar: PLive;
      p_CurIndex: PIndex;
      p_Rec: PArrRecExt;
      actOnRec: FOnRec;
      mtx: TMutex;
    protected
      procedure Execute(); override;
    public
      constructor Create(mutex: TMutex; MaxCnt: TIndex; pLiveVar: PLive; pCurIndex: PIndex; pRec: PArrRecExt; actionOnRec: FOnRec);
    end;
  var
    sName: string;
    p0_MaxCount: PIndex;
    p1_LiveVar: PLive;
    p2_CurIndex: PIndex;
    p3_Recs: PArrRecExt;
    //--------------
    live: TLiveVarSet;
    read: TReadData;
    mutex: TMutex;
    //--------------
    uMaxCount: TIndex;
    hFMap: THandle;
    sizeMove: NativeInt;
    doOnRec: FOnRec;
    doOnStopRead: FOnStopRead;
    procedure set_OnRec(const Val: FOnRec);
  public
    property OnReadRec: FOnRec read doOnRec write set_OnRec;
    property OnStopRead: FOnStopRead read doOnStopRead write doOnStopRead;
    procedure WriteRec(Rec: TRec);
    constructor Create(Name: string; out Error: String; MaxCount: TIndex = 0);
    destructor Destroy; override;
  end;

implementation
uses
  System.SysUtils, Winapi.Windows, System.Generics.Collections, uTools;
//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
{ TFileMap<TRec>.TLiveVarSet }
constructor TFileMap<TRec>.TLiveVarSet.Create;
begin
  inherited Create(False);
  p_LiveVar := pLiveVar;
  mtx := mutex;
end;

procedure TFileMap<TRec>.TLiveVarSet.Execute;
begin
  FreeOnTerminate := False;
  while not Terminated do
  begin
    mtx.Acquire;
    Inc(p_LiveVar^);
    mtx.Release;
    Sleep(50);
  end;
  //mtx.Release;
end;

//----------------------------------------------------------------------------------------------------------------------
{ TFileMap<TRec>.TReadData }
constructor TFileMap<TRec>.TReadData.Create;
begin
  inherited Create(True);
  uMaxCount  := MaxCnt;
  p_LiveVar  := pLiveVar;
  p_CurIndex := pCurIndex;
  p_Rec      := pRec;
  actOnRec := actionOnRec;
  mtx := mutex;
end;

procedure TFileMap<TRec>.TReadData.Execute;
type
  TListRec = System.Generics.Collections.TQueue<TRec>;
var
  lv: TLive;
  lvCnt: Byte;
  lastIndex: TIndex;
  i: TIndex;
  ar: TListRec;
  r: TRec;
begin
  FreeOnTerminate := False;
  lv := 0;
  lvCnt := 0;
  lastIndex := 0;
  ar := TListRec.Create;
  while not Terminated do
  begin
    //-----------------------
    mtx.Acquire;
    //-----------------------
    if lv=p_LiveVar^ then
    begin
      Inc(lvCnt);
      if lvCnt=3 then
      begin
        Terminate;
      end;
    end
    else
    begin
      lvCnt := 0;
    end;
    //-----------------------
    i := p_CurIndex^ - lastIndex;
    if i>uMaxCount then
      i := uMaxCount;
    while i>0 do
    begin
      dec(i);
      with p_Rec[i] do
      begin
        lastIndex := id;
        ar.Enqueue(rec)
      end;
    end;
    //-----------------------
    mtx.Release;
    //-----------------------
    while ar.Count>0 do
    begin
      r := ar.Dequeue;
      Synchronize(procedure begin
        actOnRec(r)
      end);
    end;
    //-----------------------
    if Terminated then Break;
    Sleep(51);
  end;
  mtx.Release;
  FreeAndNil(ar);
end;

//----------------------------------------------------------------------------------------------------------------------
{ TFileMap<TRec> }
constructor TFileMap<TRec>.Create;
begin
  inherited Create;
  sName := Name;
  uMaxCount := MaxCount;
  hFMap := 0;
  live := nil;
  read := nil;
  mutex := nil;
  p0_MaxCount := nil;
  p1_LiveVar := nil;
  p2_CurIndex := nil;
  p3_Recs := nil;
  Error := '';
  //--------------------
  sizeMove := 0;
  if MaxCount=0 then
    hFMap := CreateFileMapping( INVALID_HANDLE_VALUE, nil, PAGE_READONLY, 0, 0, LPCWSTR(Name) )
  else
  begin
    sizeMove := SizeOf(TIndex) + SizeOf(TLive) + SizeOf(TIndex) + MaxCount*SizeOf(TRecExt);
    hFMap := CreateFileMapping( INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, sizeMove, LPCWSTR(sName) );
    sizeMove := (MaxCount-1) * SizeOf(TRecExt);
  end;
  //--------------------
  if hFMap=0 then
  begin
    Error := SysErrorMessage(GetLastError());
    Exit;
  end
  else if MaxCount=0 then
  begin
    if GetLastError<>ERROR_ALREADY_EXISTS then
    begin
      CloseHandle(hFMap);
      hFMap := 0;
      Error := 'Не подключились к существующему файлу';
      Exit
    end;
  end;
  //--------------------
  p0_MaxCount := MapViewOfFile(hFMap, Tools.iff<DWORD>(MaxCount=0, FILE_MAP_READ, FILE_MAP_WRITE), 0, 0, 0);
  if p0_MaxCount=nil then
  begin
    CloseHandle(hFMap);
    hFMap := 0;
    Error := SysErrorMessage(GetLastError());
    exit;
  end;
  //--------------------
  p1_LiveVar  := Pointer( NativeInt(p0_MaxCount) + SizeOf(TIndex) );
  p2_CurIndex := Pointer( NativeInt(p1_LiveVar ) + SizeOf(TLive ) );
  p3_Recs     := Pointer( NativeInt(p2_CurIndex) + SizeOf(TIndex) );
  //--------------------
  mutex := TMutex.Create(nil, False, Name + '_mutex');
  if MaxCount=0 then
    // read := TReadData.Create(p0_MaxCount^,p1_LiveVar, p2_CurIndex, p3_Recs)
    // см. set_OnRec;
  else
    live := TLiveVarSet.Create(mutex, p1_LiveVar);
end;

procedure TFileMap<TRec>.set_OnRec(const Val: FOnRec);
begin
  doOnRec := val;
  if uMaxCount=0 then
  begin
    read := TReadData.Create(mutex, p0_MaxCount^,p1_LiveVar, p2_CurIndex, p3_Recs, val);
    read.OnTerminate := doOnStopRead;
    read.Start();
  end;
end;

destructor TFileMap<TRec>.Destroy;
begin
  //--------------------
  if live<>nil then
  begin
    if live.Started then
    begin
      live.OnTerminate := nil;
      live.Terminate;
      live.WaitFor;
    end;
    FreeAndNil(live);
  end;
  //--------------------
  if read<>nil then
  begin
    read.OnTerminate := nil;
    read.Terminate;
    read.WaitFor;
    FreeAndNil(read);
  end;
  //--------------------
  if mutex<>nil then
    FreeAndNil(mutex);
  //--------------------
  if p0_MaxCount<>nil then
  begin
    UnmapViewOfFile(p0_MaxCount);
    p0_MaxCount := nil;
    p1_LiveVar := nil;
    p2_CurIndex := nil;
    p3_Recs := nil;
  end;
  //--------------------
  if hFMap<>0 then
    CloseHandle(hFMap);
  //--------------------
  inherited Destroy;
end;

procedure TFileMap<TRec>.WriteRec(Rec: TRec);
var r: TRecExt;
begin
  if uMaxCount=0 then
  begin
    raise Exception.Create('Файл открыт только для чтения');
  end
  else
  begin
    mutex.Acquire;
    r.rec := Rec;
    r.id  := p2_CurIndex^;
    Move(p3_Recs[0], p3_Recs[1], sizeMove);
    p3_Recs[0] := r;
    inc(p2_CurIndex^);
    mutex.Release;
  end;
end;

end.
