object FormMain: TFormMain
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1089#1083#1091#1078#1073
  ClientHeight = 542
  ClientWidth = 844
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  object PageControl: TPageControl
    Left = 0
    Top = 0
    Width = 844
    Height = 542
    ActivePage = TabSheet1
    Align = alClient
    MultiLine = True
    TabOrder = 0
    TabPosition = tpLeft
    object TabSheet1: TTabSheet
      Caption = #1057#1083#1091#1078#1073#1099
      inline fServicesRule: TfServicesRule
        Left = 0
        Top = 0
        Width = 813
        Height = 534
        Align = alClient
        TabOrder = 0
        ExplicitWidth = 813
        ExplicitHeight = 534
        inherited Panel: TPanel
          Top = 486
          Width = 813
          ExplicitTop = 486
          ExplicitWidth = 813
          inherited BtnCreate: TBitBtn
            Left = 593
            ExplicitLeft = 593
          end
          inherited BtnDel: TBitBtn
            Left = 701
            ExplicitLeft = 701
          end
        end
        inherited ServicesList: TListView
          Width = 803
          Height = 438
          Columns = <
            item
              Caption = #1048#1084#1103
              Width = 70
            end
            item
              Caption = #1054#1090#1086#1073#1088#1072#1078#1072#1077#1084#1086#1077' '#1080#1084#1103
              Width = 120
            end
            item
              Caption = #1054#1087#1080#1089#1072#1085#1080#1077
              Width = 400
            end
            item
              Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077
              Width = 100
            end
            item
              Caption = #1058#1080#1087' '#1079#1072#1087#1091#1089#1082#1072
              Width = 100
            end
            item
              Caption = #1042#1093#1086#1076' '#1086#1090' '#1080#1084#1077#1085#1080
              Width = 100
            end
            item
            end
            item
            end
            item
            end
            item
            end
            item
            end
            item
            end
            item
            end
            item
            end
            item
            end>
          ExplicitWidth = 803
          ExplicitHeight = 438
        end
        inherited CheckBox_UpdateOnlySelf: TCheckBox
          Top = 448
          Width = 783
          ExplicitTop = 448
          ExplicitWidth = 783
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = #1050#1086#1085#1092#1080#1075#1091#1088#1072#1090#1086#1088' '#1079#1072#1087#1091#1089#1082#1072
      ImageIndex = 1
      inline TestExec: TfTestExec
        Left = 0
        Top = 0
        Width = 813
        Height = 534
        Align = alClient
        Constraints.MinHeight = 400
        Constraints.MinWidth = 477
        TabOrder = 0
        ExplicitWidth = 813
        ExplicitHeight = 534
        inherited Panel: TPanel
          Top = 488
          Width = 813
          Height = 46
          ExplicitTop = 488
          ExplicitWidth = 813
          ExplicitHeight = 46
          inherited BtnTerminate: TBitBtn
            Height = 32
            ExplicitHeight = 32
          end
          inherited BtnRun: TBitBtn
            Height = 32
            ExplicitHeight = 32
          end
          inherited Btn_FileOpen: TBitBtn
            Left = 593
            Height = 32
            ExplicitLeft = 593
            ExplicitHeight = 32
          end
          inherited Btn_FileSave: TBitBtn
            Left = 701
            Height = 32
            ExplicitLeft = 701
            ExplicitHeight = 32
          end
        end
        inherited StartPages: TPageControl
          Width = 813
          Height = 451
          ExplicitWidth = 813
          ExplicitHeight = 451
          inherited TabStart: TTabSheet
            ExplicitWidth = 805
            ExplicitHeight = 421
            inherited Label5: TLabel
              Width = 783
            end
            inherited Label4: TLabel
              Width = 783
            end
            inherited Label_Path: TLabel
              Width = 783
            end
            inherited Label2: TLabel
              Width = 783
            end
            inherited Label1: TLabel
              Width = 783
            end
            inherited LabelEnv: TLabel
              Width = 783
            end
            inherited Label17: TLabel
              Width = 783
            end
            inherited Edit_Path: TButtonedEdit
              Width = 785
              ExplicitWidth = 785
            end
            inherited Edit_StdError: TButtonedEdit
              Width = 785
              ExplicitWidth = 785
            end
            inherited Edit_StdOut: TButtonedEdit
              Width = 785
              ExplicitWidth = 785
            end
            inherited Edit_Param: TButtonedEdit
              Width = 785
              ExplicitWidth = 785
            end
            inherited Edit_Cmd: TButtonedEdit
              Width = 785
              ExplicitWidth = 785
            end
            inherited Editor_Env: TValueListEditor
              Width = 785
              Height = 105
              ExplicitWidth = 785
              ExplicitHeight = 105
              ColWidths = (
                150
                629)
            end
            inherited Edit_RestartCount: TNumberBox
              Width = 785
              ExplicitWidth = 785
            end
          end
          inherited TabTerminate: TTabSheet
            inherited Label11: TLabel
              Width = 135
            end
            inherited Label12: TLabel
              Width = 112
            end
            inherited Label13: TLabel
              Width = 116
            end
            inherited Label14: TLabel
              Width = 196
            end
            inherited Label15: TLabel
              Width = 167
            end
            inherited Label16: TLabel
              Width = 192
            end
            inherited Label18: TLabel
              Width = 221
            end
          end
          inherited TabStop: TTabSheet
            inherited Label3: TLabel
              Width = 135
            end
            inherited Label6: TLabel
              Width = 112
            end
            inherited Label7: TLabel
              Width = 116
            end
            inherited Label8: TLabel
              Width = 196
            end
            inherited Label9: TLabel
              Width = 167
            end
            inherited Label10: TLabel
              Width = 192
            end
            inherited Label19: TLabel
              Width = 221
            end
          end
        end
        inherited CheckBox_HideWin: TCheckBox
          Top = 456
          Width = 783
          ExplicitTop = 456
          ExplicitWidth = 783
        end
        inherited OpenDialog: TOpenDialog
          Left = 176
        end
      end
    end
  end
end
