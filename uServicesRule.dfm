object fServicesRule: TfServicesRule
  Left = 0
  Top = 0
  Width = 647
  Height = 375
  TabOrder = 0
  PixelsPerInch = 96
  object Panel: TPanel
    Left = 0
    Top = 327
    Width = 647
    Height = 48
    Align = alBottom
    BevelKind = bkFlat
    BevelOuter = bvNone
    Padding.Left = 10
    Padding.Top = 5
    Padding.Right = 10
    Padding.Bottom = 5
    ShowCaption = False
    TabOrder = 2
    object BtnCreate: TBitBtn
      AlignWithMargins = True
      Left = 427
      Top = 5
      Width = 98
      Height = 34
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = #1057#1086#1079#1076#1072#1090#1100
      Enabled = False
      ImageIndex = 6
      ImageName = 'icons8-'#1076#1086#1082#1091#1084#1077#1085#1090
      Images = dmImages.vImageList
      Kind = bkIgnore
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BtnCreateClick
    end
    object BtnDel: TBitBtn
      AlignWithMargins = True
      Left = 535
      Top = 5
      Width = 98
      Height = 34
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Enabled = False
      ImageIndex = 7
      ImageName = 'icons8-'#1084#1091#1089#1086#1088
      Images = dmImages.vImageList
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
      OnClick = BtnDelClick
    end
    object BtnStop: TBitBtn
      AlignWithMargins = True
      Left = 110
      Top = 5
      Width = 90
      Height = 34
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alLeft
      Caption = #1057#1090#1086#1087
      Enabled = False
      ImageIndex = 1
      ImageName = 'icons8-'#1074#1099#1082#1083#1102#1095#1077#1085#1080#1077'-'#1089#1080#1089#1090#1077#1084#1099
      Images = dmImages.vImageList
      TabOrder = 2
      OnClick = BtnStopClick
    end
    object BtnStart: TBitBtn
      AlignWithMargins = True
      Left = 10
      Top = 5
      Width = 90
      Height = 34
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alLeft
      Caption = #1055#1091#1089#1082
      ImageIndex = 0
      ImageName = 'icons8-'#1074#1082#1083#1102#1095#1080#1090#1100'-'#1073#1099#1089#1090#1088#1099#1081'-'#1088#1077#1078#1080#1084
      Images = dmImages.vImageList
      TabOrder = 3
      OnClick = BtnStartClick
    end
  end
  object ServicesList: TListView
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 637
    Height = 279
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 0
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BevelKind = bkSoft
    Columns = <
      item
        Caption = #1048#1084#1103' '#1089#1083#1091#1078#1073#1099
        Tag = 1
        Width = 70
      end
      item
        Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1077#1084#1086#1077' '#1080#1084#1103
        Tag = 1
        Width = 120
      end
      item
        Caption = #1054#1087#1080#1089#1072#1085#1080#1077
        Tag = 2
        Width = 300
      end
      item
        Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
        Tag = 3
        Width = 100
      end
      item
        Caption = #1058#1080#1087' '#1079#1072#1087#1091#1089#1082#1072
        Tag = 4
        Width = 100
      end
      item
        Caption = #1042#1093#1086#1076' '#1086#1090' '#1080#1084#1077#1085#1080
        Tag = 5
        Width = 100
      end>
    Enabled = False
    FlatScrollBars = True
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ServicesListDblClick
    OnKeyUp = ServicesListKeyUp
    OnSelectItem = ServicesListSelectItem
  end
  object CheckBox_UpdateOnlySelf: TCheckBox
    AlignWithMargins = True
    Left = 15
    Top = 289
    Width = 617
    Height = 33
    Margins.Left = 15
    Margins.Top = 5
    Margins.Right = 15
    Margins.Bottom = 5
    Align = alBottom
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1089#1086#1073#1089#1090#1074#1077#1085#1085#1099#1077' '#1089#1083#1091#1078#1073#1099
    Checked = True
    Enabled = False
    State = cbChecked
    TabOrder = 1
    OnClick = CheckBox_UpdateOnlySelfClick
  end
  object TimerUpdateStatus: TTimer
    Enabled = False
    Interval = 750
    OnTimer = TimerUpdateStatusTimer
    Left = 120
    Top = 80
  end
end
