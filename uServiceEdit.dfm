object fEditService: TfEditService
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsToolWindow
  ClientHeight = 485
  ClientWidth = 648
  Color = clBtnFace
  Constraints.MinHeight = 460
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 15
  object Label4: TLabel
    AlignWithMargins = True
    Left = 11
    Top = 99
    Width = 626
    Height = 15
    Margins.Left = 11
    Margins.Top = 7
    Margins.Right = 11
    Align = alTop
    Caption = #1054#1087#1080#1089#1072#1085#1080#1077':'
    Layout = tlBottom
    ExplicitWidth = 58
  end
  object Label2: TLabel
    AlignWithMargins = True
    Left = 11
    Top = 147
    Width = 626
    Height = 15
    Margins.Left = 11
    Margins.Top = 7
    Margins.Right = 11
    Align = alTop
    Caption = #1060#1072#1081#1083' '#1085#1072#1089#1090#1088#1086#1077#1082':'
    Layout = tlBottom
    ExplicitWidth = 85
  end
  object Label1: TLabel
    AlignWithMargins = True
    Left = 11
    Top = 5
    Width = 626
    Height = 15
    Margins.Left = 11
    Margins.Top = 5
    Margins.Right = 11
    Align = alTop
    Caption = #1048#1084#1103':'
    FocusControl = Edit_Name
    Layout = tlBottom
    ExplicitWidth = 27
  end
  object Label3: TLabel
    AlignWithMargins = True
    Left = 11
    Top = 51
    Width = 626
    Height = 15
    Margins.Left = 11
    Margins.Top = 5
    Margins.Right = 11
    Align = alTop
    Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1077#1084#1086#1077' '#1080#1084#1103':'
    FocusControl = Edit_DisplayName
    Layout = tlBottom
    ExplicitWidth = 112
  end
  object Label5: TLabel
    AlignWithMargins = True
    Left = 11
    Top = 193
    Width = 626
    Height = 15
    Margins.Left = 11
    Margins.Top = 5
    Margins.Right = 11
    Align = alTop
    Caption = #1047#1072#1087#1091#1089#1082#1072#1090#1100' '#1086#1090' '#1080#1084#1077#1085#1080' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103':'
    FocusControl = Edit_Login
    Layout = tlBottom
    ExplicitWidth = 190
  end
  object Label6: TLabel
    AlignWithMargins = True
    Left = 11
    Top = 239
    Width = 626
    Height = 15
    Margins.Left = 11
    Margins.Top = 5
    Margins.Right = 11
    Align = alTop
    Caption = #1055#1072#1088#1086#1083#1100' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1103':'
    FocusControl = Edit_Password
    Layout = tlBottom
    ExplicitWidth = 123
  end
  object Label7: TLabel
    AlignWithMargins = True
    Left = 11
    Top = 287
    Width = 626
    Height = 15
    Margins.Left = 11
    Margins.Top = 7
    Margins.Right = 11
    Align = alTop
    Caption = #1047#1072#1087#1091#1089#1082#1072#1090#1100' '#1087#1086#1083#1077' '#1089#1083#1091#1078#1073':'
    Layout = tlBottom
    ExplicitWidth = 126
  end
  object Edit_Name: TEdit
    AlignWithMargins = True
    Left = 11
    Top = 23
    Width = 626
    Height = 23
    Margins.Left = 11
    Margins.Top = 0
    Margins.Right = 11
    Margins.Bottom = 0
    Align = alTop
    HideSelection = False
    MaxLength = 254
    TabOrder = 0
  end
  object Edit_DisplayName: TEdit
    AlignWithMargins = True
    Left = 10
    Top = 69
    Width = 628
    Height = 23
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    HideSelection = False
    MaxLength = 254
    TabOrder = 1
  end
  object Panel: TPanel
    Left = 0
    Top = 437
    Width = 648
    Height = 48
    Align = alBottom
    BevelKind = bkFlat
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 5
    Padding.Right = 10
    Padding.Bottom = 5
    ShowCaption = False
    TabOrder = 7
    object BtnStart: TBitBtn
      AlignWithMargins = True
      Left = 10
      Top = 5
      Width = 85
      Height = 34
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      HotImageIndex = 0
      HotImageName = 'icons8-'#1074#1082#1083#1102#1095#1080#1090#1100'-'#1073#1099#1089#1090#1088#1099#1081'-'#1088#1077#1078#1080#1084
      ImageIndex = 4
      ImageName = 'icons8-'#1086#1082
      Images = dmImages.vImageList
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object BtnStop: TBitBtn
      AlignWithMargins = True
      Left = 105
      Top = 5
      Width = 85
      Height = 34
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      Caption = #1054#1090#1084#1077#1085#1072
      HotImageIndex = 1
      HotImageName = 'icons8-'#1074#1099#1082#1083#1102#1095#1077#1085#1080#1077'-'#1089#1080#1089#1090#1077#1084#1099
      ImageIndex = 5
      ImageName = 'icons8-'#1086#1090#1084#1077#1085#1080#1090#1100'-2'
      Images = dmImages.vImageList
      Kind = bkNo
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object Edit_Login: TEdit
    AlignWithMargins = True
    Left = 10
    Top = 211
    Width = 628
    Height = 23
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    HideSelection = False
    MaxLength = 254
    TabOrder = 4
  end
  object Edit_Password: TEdit
    AlignWithMargins = True
    Left = 10
    Top = 257
    Width = 628
    Height = 23
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    HideSelection = False
    MaxLength = 254
    TabOrder = 5
  end
  object Editor_Dependence: TMemo
    AlignWithMargins = True
    Left = 10
    Top = 305
    Width = 628
    Height = 122
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alClient
    HideSelection = False
    TabOrder = 6
  end
  object Edit_Description: TEdit
    AlignWithMargins = True
    Left = 10
    Top = 117
    Width = 628
    Height = 23
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    HideSelection = False
    MaxLength = 254
    TabOrder = 2
  end
  object Edit_Config: TButtonedEdit
    AlignWithMargins = True
    Left = 10
    Top = 165
    Width = 628
    Height = 23
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alTop
    Images = dmImages.vImageList
    RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1092#1072#1081#1083' '#1085#1072#1089#1090#1088#1086#1077#1082#1090
    RightButton.ImageIndex = 10
    RightButton.ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072'-blue'
    RightButton.Visible = True
    TabOrder = 3
    OnRightButtonClick = Btn_ConfigClick
  end
  object OpenDialog_Config: TOpenDialog
    Ctl3D = False
    Filter = 'Ini '#1092#1072#1081#1083#1099'|*.ini|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofReadOnly, ofFileMustExist, ofNoNetworkButton, ofEnableSizing, ofForceShowHidden]
    Left = 232
    Top = 8
  end
  object SaveDialog_cgf: TSaveDialog
    Left = 40
    Top = 8
  end
end
