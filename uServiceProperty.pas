unit uServiceProperty;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.BaseImageCollection, Vcl.ImageCollection,
  System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TFormProperty = class(TForm)
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label2: TLabel;
    Label7: TLabel;
    Edit_Discription: TMemo;
    Label3: TLabel;
    Edit_State: TButtonedEdit;
    Label8: TLabel;
    Edit_StartType: TButtonedEdit;
    Edit_DisplayName: TButtonedEdit;
    Edit_Name: TButtonedEdit;
    Label4: TLabel;
    Edit_User: TButtonedEdit;
    Label5: TLabel;
    Edit_ServiseType: TButtonedEdit;
    Label6: TLabel;
    Edit_ExeName: TButtonedEdit;
    Label10: TLabel;
    Edit_Group: TButtonedEdit;
    Label9: TLabel;
    Edit_TagID: TButtonedEdit;
    Label11: TLabel;
    Edit_Dependencies: TMemo;
    Label1: TLabel;
    BtnStart: TBitBtn;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormProperty: TFormProperty;

implementation

{$R *.dfm}

uses uTools;

procedure TFormProperty.FormShow(Sender: TObject);
begin
  PageControl.ActivePageIndex := 0;
end;

end.
