object fTestExec: TfTestExec
  Left = 0
  Top = 0
  Width = 809
  Height = 552
  Align = alClient
  Constraints.MinHeight = 400
  Constraints.MinWidth = 477
  TabOrder = 0
  PixelsPerInch = 96
  object Panel: TPanel
    Left = 0
    Top = 504
    Width = 809
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
    object BtnTerminate: TBitBtn
      AlignWithMargins = True
      Left = 110
      Top = 5
      Width = 90
      Height = 34
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      Caption = #1057#1090#1086#1087
      Enabled = False
      HotImageIndex = 3
      HotImageName = 'icons8-'#1089#1090#1086#1087
      ImageIndex = 3
      ImageName = 'icons8-'#1089#1090#1086#1087
      Images = dmImages.vImageList
      Kind = bkNo
      NumGlyphs = 2
      TabOrder = 1
      OnClick = BtnTerminateClick
    end
    object BtnRun: TBitBtn
      AlignWithMargins = True
      Left = 10
      Top = 5
      Width = 90
      Height = 34
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      Caption = #1057#1090#1072#1088#1090
      HotImageIndex = 2
      HotImageName = 'icons8-'#1074#1086#1089#1087#1088#1086#1080#1079#1074#1077#1076#1077#1085#1080#1077
      ImageIndex = 2
      ImageName = 'icons8-'#1074#1086#1089#1087#1088#1086#1080#1079#1074#1077#1076#1077#1085#1080#1077
      Images = dmImages.vImageList
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      OnClick = BtnRunClick
    end
    object Btn_FileOpen: TBitBtn
      AlignWithMargins = True
      Left = 481
      Top = 5
      Width = 98
      Height = 34
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = #1054#1090#1082#1088#1099#1090#1100
      ImageIndex = 8
      ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072
      Images = dmImages.vImageList
      TabOrder = 2
      OnClick = Btn_FileOpenClick
      ExplicitLeft = 589
    end
    object Btn_FileSave: TBitBtn
      AlignWithMargins = True
      Left = 589
      Top = 5
      Width = 98
      Height = 34
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
      ImageIndex = 9
      ImageName = 'icons8-'#1089#1086#1093#1088#1072#1085#1080#1090#1100
      Images = dmImages.vImageList
      TabOrder = 3
      OnClick = Btn_FileSaveClick
      ExplicitLeft = 569
      ExplicitTop = 13
    end
    object BtnClear: TBitBtn
      AlignWithMargins = True
      Left = 697
      Top = 5
      Width = 98
      Height = 34
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alRight
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      ImageIndex = 12
      ImageName = 'icons8-'#1089#1090#1077#1088#1077#1090#1100
      Images = dmImages.vImageList
      TabOrder = 4
      OnClick = BtnClearClick
    end
  end
  object StartPages: TPageControl
    Left = 0
    Top = 0
    Width = 809
    Height = 467
    ActivePage = TabStart
    Align = alClient
    TabOrder = 0
    object TabStart: TTabSheet
      Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1087#1088#1086#1094#1077#1089#1089#1072
      object Label5: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 149
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091' '#1089#1090#1072#1085#1076#1072#1088#1090#1085#1086#1075#1086' '#1074#1099#1074#1086#1076#1072':'
        Layout = tlBottom
        ExplicitWidth = 196
      end
      object Label4: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 197
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091' '#1074#1099#1074#1086#1076#1072' '#1086#1096#1080#1073#1086#1082':'
        Layout = tlBottom
        ExplicitWidth = 167
      end
      object Label_Path: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 101
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1056#1072#1073#1086#1095#1072#1103' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1103':'
        Layout = tlBottom
        ExplicitWidth = 116
      end
      object Label2: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 53
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1079#1072#1087#1091#1089#1082#1072':'
        Layout = tlBottom
        ExplicitWidth = 112
      end
      object Label1: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 5
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 5
        Margins.Right = 11
        Align = alTop
        Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1076#1083#1103' '#1079#1072#1087#1091#1089#1082#1072':'
        Layout = tlBottom
        ExplicitWidth = 135
      end
      object LabelEnv: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 293
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1077#1088#1077#1084#1077#1085#1085#1099#1077' '#1086#1082#1088#1091#1078#1077#1085#1080#1103':'
        Layout = tlBottom
        ExplicitWidth = 192
      end
      object Label17: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 245
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1087#1077#1088#1077#1079#1072#1087#1091#1089#1082#1086#1074':'
        Layout = tlBottom
        ExplicitWidth = 146
      end
      object Edit_Path: TButtonedEdit
        AlignWithMargins = True
        Left = 10
        Top = 119
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1102
        RightButton.ImageIndex = 11
        RightButton.ImageName = 'icons8-'#1086#1090#1082#1088#1099#1090#1100'-'#1087#1072#1087#1082#1091'-blue'
        RightButton.Visible = True
        TabOrder = 2
        OnRightButtonClick = Btn_PathClick
      end
      object Edit_StdError: TButtonedEdit
        Tag = 3
        AlignWithMargins = True
        Left = 10
        Top = 215
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1092#1072#1081#1083
        RightButton.ImageIndex = 10
        RightButton.ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072'-blue'
        RightButton.Visible = True
        TabOrder = 4
        OnRightButtonClick = BtnClickBrouse
      end
      object Edit_StdOut: TButtonedEdit
        Tag = 2
        AlignWithMargins = True
        Left = 10
        Top = 167
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1092#1072#1081#1083
        RightButton.ImageIndex = 10
        RightButton.ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072'-blue'
        RightButton.Visible = True
        TabOrder = 3
        OnRightButtonClick = BtnClickBrouse
      end
      object Edit_Param: TButtonedEdit
        Tag = 1
        AlignWithMargins = True
        Left = 10
        Top = 71
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1092#1072#1081#1083
        RightButton.ImageIndex = 10
        RightButton.ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072'-blue'
        RightButton.Visible = True
        TabOrder = 1
        OnRightButtonClick = BtnClickBrouse
      end
      object Edit_Cmd: TButtonedEdit
        AlignWithMargins = True
        Left = 10
        Top = 23
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1092#1072#1081#1083
        RightButton.ImageIndex = 10
        RightButton.ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072'-blue'
        RightButton.Visible = True
        TabOrder = 0
        OnRightButtonClick = BtnClickBrouse
      end
      object Editor_Env: TValueListEditor
        AlignWithMargins = True
        Left = 10
        Top = 311
        Width = 781
        Height = 121
        Hint = '-1 - '#1073#1077#1079' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1081
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 5
        Align = alClient
        GradientEndColor = clBlack
        KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
        TabOrder = 6
        TitleCaptions.Strings = (
          #1055#1077#1088#1077#1084#1077#1085#1085#1072#1103
          #1047#1085#1072#1095#1077#1085#1080#1077)
        ColWidths = (
          150
          625)
      end
      object Edit_RestartCount: TNumberBox
        AlignWithMargins = True
        Left = 10
        Top = 263
        Width = 781
        Height = 23
        Hint = '-1 - '#1073#1077#1079' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1081
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        MinValue = -1.000000000000000000
        MaxValue = 1000.000000000000000000
        TabOrder = 5
        Value = -1.000000000000000000
      end
    end
    object TabTerminate: TTabSheet
      Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1076#1083#1103' '#1086#1089#1090#1072#1085#1086#1074#1082#1080
      ImageIndex = 2
      object Label11: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 5
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 5
        Margins.Right = 11
        Align = alTop
        Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1076#1083#1103' '#1079#1072#1087#1091#1089#1082#1072':'
        Layout = tlBottom
        ExplicitWidth = 135
      end
      object Label12: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 53
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1079#1072#1087#1091#1089#1082#1072':'
        Layout = tlBottom
        ExplicitWidth = 112
      end
      object Label13: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 101
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1056#1072#1073#1086#1095#1072#1103' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1103':'
        Layout = tlBottom
        ExplicitWidth = 116
      end
      object Label14: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 149
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091' '#1089#1090#1072#1085#1076#1072#1088#1090#1085#1086#1075#1086' '#1074#1099#1074#1086#1076#1072':'
        Layout = tlBottom
        ExplicitWidth = 196
      end
      object Label15: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 197
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091' '#1074#1099#1074#1086#1076#1072' '#1086#1096#1080#1073#1086#1082':'
        Layout = tlBottom
        ExplicitWidth = 167
      end
      object Label16: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 293
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1077#1088#1077#1084#1077#1085#1085#1099#1077' '#1086#1082#1088#1091#1078#1077#1085#1080#1103':'
        Layout = tlBottom
        ExplicitWidth = 192
      end
      object Label18: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 245
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1042#1088#1077#1084#1103' '#1086#1078#1080#1076#1072#1085#1080#1077' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1087#1088#1086#1094#1077#1089#1089#1072':'
        Layout = tlBottom
        ExplicitWidth = 221
      end
      object Edit_CmdT: TButtonedEdit
        AlignWithMargins = True
        Left = 10
        Top = 23
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1092#1072#1081#1083
        RightButton.ImageIndex = 10
        RightButton.ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072'-blue'
        RightButton.Visible = True
        TabOrder = 0
        OnRightButtonClick = BtnClickBrouse
      end
      object Edit_ParamT: TButtonedEdit
        Tag = 1
        AlignWithMargins = True
        Left = 10
        Top = 71
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1092#1072#1081#1083
        RightButton.ImageIndex = 10
        RightButton.ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072'-blue'
        RightButton.Visible = True
        TabOrder = 1
        OnRightButtonClick = BtnClickBrouse
      end
      object Edit_PathT: TButtonedEdit
        AlignWithMargins = True
        Left = 10
        Top = 119
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1102
        RightButton.ImageIndex = 11
        RightButton.ImageName = 'icons8-'#1086#1090#1082#1088#1099#1090#1100'-'#1087#1072#1087#1082#1091'-blue'
        RightButton.Visible = True
        TabOrder = 2
        OnRightButtonClick = Btn_PathClick
      end
      object Edit_StdOutT: TButtonedEdit
        Tag = 2
        AlignWithMargins = True
        Left = 10
        Top = 167
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1092#1072#1081#1083
        RightButton.ImageIndex = 10
        RightButton.ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072'-blue'
        RightButton.Visible = True
        TabOrder = 3
        OnRightButtonClick = BtnClickBrouse
      end
      object Edit_StdErrorT: TButtonedEdit
        Tag = 3
        AlignWithMargins = True
        Left = 10
        Top = 215
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1092#1072#1081#1083
        RightButton.ImageIndex = 10
        RightButton.ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072'-blue'
        RightButton.Visible = True
        TabOrder = 4
        OnRightButtonClick = BtnClickBrouse
      end
      object Editor_EnvT: TValueListEditor
        AlignWithMargins = True
        Left = 10
        Top = 311
        Width = 781
        Height = 121
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 5
        Align = alClient
        GradientEndColor = clBlack
        KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
        TabOrder = 6
        TitleCaptions.Strings = (
          #1055#1077#1088#1077#1084#1077#1085#1085#1072#1103
          #1047#1085#1072#1095#1077#1085#1080#1077)
        ColWidths = (
          150
          625)
      end
      object Edit_TimeoutT: TNumberBox
        AlignWithMargins = True
        Left = 10
        Top = 263
        Width = 781
        Height = 23
        Hint = '-1 - '#1073#1077#1079' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1081
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        LargeStep = 1000.000000000000000000
        MinValue = -1.000000000000000000
        MaxValue = 1000000.000000000000000000
        ParentShowHint = False
        SmallStep = 100.000000000000000000
        ShowHint = True
        TabOrder = 5
        Value = 500.000000000000000000
      end
    end
    object TabStop: TTabSheet
      Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1087#1086#1089#1083#1077' '#1086#1089#1090#1072#1085#1086#1074#1082#1080
      ImageIndex = 1
      object Label3: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 5
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 5
        Margins.Right = 11
        Align = alTop
        Caption = #1055#1088#1086#1075#1088#1072#1084#1084#1072' '#1076#1083#1103' '#1079#1072#1087#1091#1089#1082#1072':'
        Layout = tlBottom
        ExplicitWidth = 135
      end
      object Label6: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 53
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1079#1072#1087#1091#1089#1082#1072':'
        Layout = tlBottom
        ExplicitWidth = 112
      end
      object Label7: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 101
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1056#1072#1073#1086#1095#1072#1103' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1103':'
        Layout = tlBottom
        ExplicitWidth = 116
      end
      object Label8: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 149
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091' '#1089#1090#1072#1085#1076#1072#1088#1090#1085#1086#1075#1086' '#1074#1099#1074#1086#1076#1072':'
        Layout = tlBottom
        ExplicitWidth = 196
      end
      object Label9: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 197
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1055#1091#1090#1100' '#1082' '#1092#1072#1081#1083#1091' '#1074#1099#1074#1086#1076#1072' '#1086#1096#1080#1073#1086#1082':'
        Layout = tlBottom
        ExplicitWidth = 167
      end
      object Label10: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 293
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1077#1088#1077#1084#1077#1085#1085#1099#1077' '#1086#1082#1088#1091#1078#1077#1085#1080#1103':'
        Layout = tlBottom
        ExplicitWidth = 192
      end
      object Label19: TLabel
        AlignWithMargins = True
        Left = 11
        Top = 245
        Width = 779
        Height = 15
        Margins.Left = 11
        Margins.Top = 7
        Margins.Right = 11
        Align = alTop
        Caption = #1042#1088#1077#1084#1103' '#1086#1078#1080#1076#1072#1085#1080#1077' '#1079#1072#1074#1077#1088#1096#1077#1085#1080#1103' '#1087#1088#1086#1094#1077#1089#1089#1072':'
        Layout = tlBottom
        ExplicitWidth = 221
      end
      object Edit_CmdS: TButtonedEdit
        AlignWithMargins = True
        Left = 10
        Top = 23
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1092#1072#1081#1083
        RightButton.ImageIndex = 10
        RightButton.ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072'-blue'
        RightButton.Visible = True
        TabOrder = 0
        OnRightButtonClick = BtnClickBrouse
      end
      object Edit_ParamS: TButtonedEdit
        Tag = 1
        AlignWithMargins = True
        Left = 10
        Top = 71
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1092#1072#1081#1083
        RightButton.ImageIndex = 10
        RightButton.ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072'-blue'
        RightButton.Visible = True
        TabOrder = 1
        OnRightButtonClick = BtnClickBrouse
      end
      object Edit_PathS: TButtonedEdit
        AlignWithMargins = True
        Left = 10
        Top = 119
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1076#1080#1088#1077#1082#1090#1086#1088#1080#1102
        RightButton.ImageIndex = 11
        RightButton.ImageName = 'icons8-'#1086#1090#1082#1088#1099#1090#1100'-'#1087#1072#1087#1082#1091'-blue'
        RightButton.Visible = True
        TabOrder = 2
        OnRightButtonClick = Btn_PathClick
      end
      object Edit_StdOutS: TButtonedEdit
        Tag = 2
        AlignWithMargins = True
        Left = 10
        Top = 167
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1092#1072#1081#1083
        RightButton.ImageIndex = 10
        RightButton.ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072'-blue'
        RightButton.Visible = True
        TabOrder = 3
        OnRightButtonClick = BtnClickBrouse
      end
      object Edit_StdErrorS: TButtonedEdit
        Tag = 3
        AlignWithMargins = True
        Left = 10
        Top = 215
        Width = 781
        Height = 23
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Images = dmImages.vImageList
        RightButton.Hint = #1059#1082#1072#1079#1072#1090#1100' '#1092#1072#1081#1083
        RightButton.ImageIndex = 10
        RightButton.ImageName = 'icons8-'#1086#1085#1083#1072#1081#1085'-'#1087#1072#1087#1082#1072'-blue'
        RightButton.Visible = True
        TabOrder = 4
        OnRightButtonClick = BtnClickBrouse
      end
      object Editor_EnvS: TValueListEditor
        AlignWithMargins = True
        Left = 10
        Top = 311
        Width = 781
        Height = 121
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 5
        Align = alClient
        GradientEndColor = clBlack
        KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goEditing, goTabs, goAlwaysShowEditor, goThumbTracking]
        TabOrder = 6
        TitleCaptions.Strings = (
          #1055#1077#1088#1077#1084#1077#1085#1085#1072#1103
          #1047#1085#1072#1095#1077#1085#1080#1077)
        ColWidths = (
          150
          625)
      end
      object Edit_TimeoutS: TNumberBox
        AlignWithMargins = True
        Left = 10
        Top = 263
        Width = 781
        Height = 23
        Hint = '-1 - '#1073#1077#1079' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1081
        Margins.Left = 10
        Margins.Top = 0
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        LargeStep = 1000.000000000000000000
        MinValue = -1.000000000000000000
        MaxValue = 1000000.000000000000000000
        ParentShowHint = False
        SmallStep = 100.000000000000000000
        ShowHint = True
        TabOrder = 5
        Value = 500.000000000000000000
      end
    end
  end
  object CheckBox_HideWin: TCheckBox
    AlignWithMargins = True
    Left = 15
    Top = 472
    Width = 779
    Height = 27
    Margins.Left = 15
    Margins.Top = 5
    Margins.Right = 15
    Margins.Bottom = 5
    Align = alBottom
    Caption = #1053#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1086#1082#1085#1086
    TabOrder = 1
  end
  object OpenDialog: TOpenDialog
    Ctl3D = False
    Filter = 
      #1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*|'#1048#1089#1087#1086#1083#1085#1103#1077#1084#1099#1077' '#1092#1072#1081#1083#1099'|*.exe|Python '#1092#1072#1081#1083#1099'|*.py; *.pyw|'#1051 +
      #1086#1075' '#1092#1072#1081#1083#1099'|*.log|'#1058#1077#1082#1089#1090#1086#1074#1099#1077' '#1092#1072#1081#1083#1099'|*.txt'
    FilterIndex = 2
    Options = [ofReadOnly, ofEnableSizing, ofForceShowHidden]
    Left = 64
    Top = 312
  end
  object OpenDialog_Config: TOpenDialog
    Ctl3D = False
    DefaultExt = 'ini'
    Filter = 'Ini '#1092#1072#1081#1083#1099'|*.ini|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofReadOnly, ofFileMustExist, ofNoNetworkButton, ofEnableSizing, ofForceShowHidden]
    Left = 64
    Top = 360
  end
  object SaveDialog_Config: TSaveDialog
    Ctl3D = False
    DefaultExt = 'ini'
    FileName = 'NewFileName'
    Filter = 'Ini '#1092#1072#1081#1083#1099'|*.ini|'#1042#1089#1077' '#1092#1072#1081#1083#1099'|*.*'
    Options = [ofPathMustExist, ofNoNetworkButton, ofEnableSizing, ofForceShowHidden]
    Left = 64
    Top = 408
  end
end
