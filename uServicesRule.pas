unit uServicesRule;

interface

uses
  uServiceTools,
  System.RegularExpressions,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Controls, Vcl.ComCtrls, Vcl.Buttons, Vcl.Forms, System.ImageList, Vcl.ImgList;

type
  TfServicesRule = class(TFrame)
    Panel: TPanel;
    BtnCreate: TBitBtn;
    ServicesList: TListView;
    BtnDel: TBitBtn;
    TimerUpdateStatus: TTimer;
    CheckBox_UpdateOnlySelf: TCheckBox;
    BtnStop: TBitBtn;
    BtnStart: TBitBtn;
    procedure TimerUpdateStatusTimer(Sender: TObject);
    procedure BtnStartClick(Sender: TObject);
    procedure BtnStopClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnCreateClick(Sender: TObject);
    procedure CheckBox_UpdateOnlySelfClick(Sender: TObject);
    procedure ServicesListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ServicesListDblClick(Sender: TObject);
    procedure ServicesListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
  private
    { Private declarations }
    SrvMng: TServiceManager;
    procedure FillServicesList();
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}

uses uTools, uServiceEdit, System.UITypes, Vcl.Dialogs, uImages, uServiceProperty;

{ TfServicesRule }

constructor TfServicesRule.Create(AOwner: TComponent);
begin
  inherited;
  try
    SrvMng := TServiceManager.Create;
  except
    on e: Exception do
    begin
      FreeAndNil(SrvMng);
      if MessageDlg( format('При получении доступа к менеджеру служб возникла ошибка: «%s»'#10'Возможно требуются права администратора', [e.Message]), TMsgDlgType.mtError, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbClose], e.HelpContext, TMsgDlgBtn.mbClose, ['Продолжить', 'Закрыть приложение'])=mrClose then
        Halt;
      exit;
    end;
  end;
  ServicesList.Enabled := True;
  CheckBox_UpdateOnlySelf.Enabled := True;
  BtnStart.Enabled := True;
  BtnStop.Enabled := True;
  BtnCreate.Enabled := True;
  BtnDel.Enabled := True;
  TimerUpdateStatus.Enabled := True;
  FillServicesList;
end;

destructor TfServicesRule.Destroy;
begin
  if SrvMng<>nil then
    FreeAndNil(SrvMng);
  inherited;
end;

procedure TfServicesRule.FillServicesList;
var
  lst: TServicesList;
  inf: TServiceInfo;
  ExeName: string;
begin
  if SrvMng=nil then Exit;
  ServicesList.Items.BeginUpdate;
  ExeName := UpperCase(Application.ExeName);
  try
    ServicesList.Clear;
    //RegEx := TRegEx.Create(format('"*%s',[Application.ExeName]));
    lst := SrvMng.GetServicesList();
    for inf in lst do
      if not CheckBox_UpdateOnlySelf.Checked or (pos(ExeName, UpperCase(inf.ExeName)) in [1,2]) then
      with ServicesList.Items.Add do
      begin
        Caption := inf.Name;
        SubItems.Add(inf.DisplayName);
        SubItems.Add(inf.Description);
        SubItems.Add(SrvMng.CurrentStateToStr(inf.State));
        SubItems.Add(SrvMng.StartTypeToStr(inf.StartType));
        SubItems.Add(inf.User);
        //
        SubItems.Add(SrvMng.ServiceTypeToStr(inf.ServiceType));
        SubItems.Add(inf.ExeName);
        SubItems.Add(inf.Group.Name);
        SubItems.Add(IntToStr(inf.Group.ID));
        SubItems.Add(SrvMng.DependenciesToStr(inf.Dependencies, ','#10));
      end;
  except
    on e: Exception do
      MessageDlg( format('При получении списка служб возникла ошибка:'#10'«%s»', [e.Message]), TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], e.HelpContext);
  end;
  ServicesList.Items.EndUpdate;
end;

procedure TfServicesRule.ServicesListDblClick(Sender: TObject);
begin
  if ServicesList.Selected=nil then Exit;
  with ServicesList.Selected do
  with FormProperty do
  begin
    Edit_Name.Text := ServicesList.Selected.Caption;
    Edit_DisplayName.Text := SubItems.Strings[0];
    Edit_Discription.Lines.Text := SubItems.Strings[1];
    Edit_State.Text := SubItems.Strings[2];
    Edit_StartType.Text := SubItems.Strings[3];
    Edit_User.Text := SubItems.Strings[4];
    Edit_ServiseType.Text := SubItems.Strings[5];
    Edit_ExeName.Text := SubItems.Strings[6];
    Edit_Group.Text := SubItems.Strings[7];
    Edit_TagID.Text := SubItems.Strings[8];
    Edit_Dependencies.Lines.Text := SubItems.Strings[9];
  end;
  FormProperty.ShowModal()
end;

procedure TfServicesRule.ServicesListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=VK_F5 then
    FillServicesList
  else if Key=VK_RETURN then
    ServicesListDblClick(nil)
end;

procedure TfServicesRule.ServicesListSelectItem(Sender: TObject; Item: TListItem; Selected: Boolean);
begin
//  if Item = nil then
//    CheckBox_UpdateOnlySelf.Caption := 'nil'
//  else
//    CheckBox_UpdateOnlySelf.Caption := item.Caption;
end;

procedure TfServicesRule.CheckBox_UpdateOnlySelfClick(Sender: TObject);
begin
  FillServicesList
end;

procedure TfServicesRule.TimerUpdateStatusTimer(Sender: TObject);
var
  i,ti: Integer;
  name: string;
  li: TListItem;
  s: string;
begin
  if ServicesList.TopItem=nil then exit;
//  ServicesList.Items.BeginUpdate;
  ti := ServicesList.TopItem.Index;
  i := ti + ServicesList.VisibleRowCount;
  while i>ti do
  begin
    Dec(i);
    li := ServicesList.Items.Item[i];
    if li=nil then Break;
    //li.SubItems.BeginUpdate;
    s := SrvMng.CurrentStateToStr(SrvMng.GetState(li.Caption));
    if li.SubItems.Strings[2]<>s then
      li.SubItems.Strings[2] := s;
    //li.SubItems.EndUpdate;
  end;
//  ServicesList.Items.EndUpdate;
end;

procedure TfServicesRule.BtnStartClick(Sender: TObject);
begin
  if ServicesList.Selected=nil then Exit;
  try
    SrvMng.Start(ServicesList.Selected.Caption);
  except
    on e: Exception do
      MessageDlg( format('При запуске службы возникла ошибка:'#10'«%s»', [e.Message]), TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], e.HelpContext);
  end;
end;

procedure TfServicesRule.BtnStopClick(Sender: TObject);
begin
  if ServicesList.Selected=nil then Exit;
  try
    SrvMng.Stop(ServicesList.Selected.Caption);
  except
    on e: Exception do
      MessageDlg( format('При остановке службы возникла ошибка:'#10'«%s»', [e.Message]), TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], e.HelpContext);
  end;
end;

procedure TfServicesRule.BtnDelClick(Sender: TObject);
var name: string;
begin
  if ServicesList.Selected=nil then Exit;
  name := ServicesList.Selected.Caption;
  if MessageDlg( format('Подтверждение удаленя службы «%s»', [name]), TMsgDlgType.mtConfirmation, [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo], 0, TMsgDlgBtn.mbNo, ['Удалить', 'Не удалять'])=mrYes then
    try
      SrvMng.Delete(ServicesList.Selected.Caption);
      MessageDlg( format('Cлужба «%s» успешно помечена для удаления', [Name]), TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
    except
      on e: Exception do
        MessageDlg( format('При удаление службы «%s» возникла ошибка:'#10'«%s»', [name, e.Message]), TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], e.HelpContext);
    end;
end;

procedure TfServicesRule.BtnCreateClick(Sender: TObject);
var Name, DisplayName, ConfigFile, Dependence, Login, Password, Description: string;
begin
  Name := '';
  DisplayName := '';
  ConfigFile := '';
  Login := '';
  Password := '';
  Dependence := '';
  Description := '';
  if fEditService.Dialog(Name, DisplayName, ConfigFile, Login, Password, Dependence, Description) then
  try
    SrvMng.Add(Application.ExeName, Name, DisplayName, ConfigFile, Login, Password, Dependence, Description);
    MessageDlg( format('Cлужба «%s» создана успешно', [Name]), TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
  except
    on e: Exception do
      MessageDlg( format('При создание службы «%s» возникла ошибка:'#10'«%s»', [Name, e.Message]), TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], e.HelpContext);
  end;
end;

end.
