object fmPatchUtil: TfmPatchUtil
  Left = 454
  Top = 145
  ActiveControl = lv
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1096#1072#1073#1083#1086#1085#1086#1074
  ClientHeight = 423
  ClientWidth = 592
  Color = clBtnFace
  Constraints.MinHeight = 450
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 157
    Width = 592
    Height = 266
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    ExplicitTop = 416
    object Panel3: TPanel
      Left = 501
      Top = 21
      Width = 86
      Height = 240
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      ExplicitHeight = 261
      DesignSize = (
        86
        240)
      object BitBtn1: TBitBtn
        Left = 9
        Top = 211
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Cancel = True
        Caption = #1047#1072#1082#1088#1099#1090#1100
        TabOrder = 2
        OnClick = BitBtn1Click
        ExplicitTop = 232
      end
      object BitBtn2: TBitBtn
        Left = 9
        Top = 144
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #1047#1072#1087#1091#1089#1082
        TabOrder = 0
        OnClick = BitBtn2Click
        ExplicitTop = 165
      end
      object BitBtn3: TBitBtn
        Left = 9
        Top = 177
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = #1057#1090#1086#1087
        TabOrder = 1
        OnClick = BitBtn3Click
        ExplicitTop = 198
      end
    end
    object GroupBox1: TGroupBox
      Left = 5
      Top = 21
      Width = 496
      Height = 240
      Align = alClient
      Caption = ' '#1054#1087#1094#1080#1080' '
      TabOrder = 1
      ExplicitLeft = 8
      ExplicitTop = 27
      ExplicitHeight = 261
      object lbOnWhat: TLabel
        Left = 281
        Top = 165
        Width = 37
        Height = 13
        Caption = #1085#1072' '#1095#1090#1086':'
      end
      object lbSetStyleFor: TLabel
        Left = 262
        Top = 215
        Width = 61
        Height = 13
        Caption = #1076#1083#1103' '#1090#1077#1082#1089#1090#1072':'
      end
      object lbSetNewSubs: TLabel
        Left = 382
        Top = 89
        Width = 12
        Height = 13
        Caption = #1085#1072
      end
      object chbAddScrollBox: TCheckBox
        Left = 11
        Top = 17
        Width = 337
        Height = 17
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1087#1088#1086#1082#1088#1091#1095#1080#1074#1072#1077#1084#1099#1081' '#1103#1097#1080#1082' '#1085#1072' '#1074#1089#1077' '#1079#1072#1082#1083#1072#1076#1082#1080
        TabOrder = 0
      end
      object chbTownDefault: TCheckBox
        Left = 13
        Top = 316
        Width = 281
        Height = 17
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1086#1081#1089#1090#1074#1086' '#1076#1083#1103' '#1075#1086#1088#1086#1076#1072' '#1087#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102
        TabOrder = 23
        Visible = False
      end
      object chbSetPropertyOnSecondSheet: TCheckBox
        Left = 14
        Top = 339
        Width = 321
        Height = 17
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1086#1081#1089#1090#1074#1086' '#1076#1083#1103' '#1048#1052'.'#1055'. '#1085#1072' '#1074#1090#1086#1088#1086#1081' '#1079#1072#1082#1083#1072#1076#1082#1077
        TabOrder = 1
        Visible = False
      end
      object chbSetDeal: TCheckBox
        Left = 14
        Top = 362
        Width = 329
        Height = 17
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1086#1081#1089#1090#1074#1086' '#1076#1083#1103' '#1087#1086#1083#1077#1081' '#1085#1072#1089#1083#1077#1076#1086#1076#1072#1090#1077#1083#1103' ('#1091#1084#1077#1088#1096#1077#1075#1086')'
        TabOrder = 24
        Visible = False
      end
      object chbSetFirstSheet: TCheckBox
        Left = 11
        Top = 41
        Width = 233
        Height = 17
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1072#1082#1090#1080#1074#1085#1086#1081' '#1087#1077#1088#1074#1091#1102' '#1079#1072#1082#1083#1072#1076#1082#1091
        TabOrder = 2
      end
      object chbSetCurrentDate: TCheckBox
        Left = 14
        Top = 385
        Width = 289
        Height = 17
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1086#1081#1089#1090#1074#1086' '#1076#1083#1103' '#1057#1077#1075#1086#1076#1085#1103#1096#1085#1077#1081' '#1076#1072#1090#1099
        TabOrder = 25
        Visible = False
      end
      object chbChangeText: TCheckBox
        Left = 11
        Top = 164
        Width = 166
        Height = 17
        Caption = #1047#1072#1084#1077#1085#1080#1090#1100' '#1074' '#1088#1077#1076#1072#1082#1090#1086#1088#1077' '#1095#1090#1086':'
        TabOrder = 15
      end
      object edWhat: TEdit
        Left = 176
        Top = 162
        Width = 91
        Height = 21
        TabOrder = 16
      end
      object edOnWhat: TEdit
        Left = 324
        Top = 162
        Width = 91
        Height = 21
        TabOrder = 17
      end
      object chbSetImenitPadeg: TCheckBox
        Left = 14
        Top = 431
        Width = 289
        Height = 17
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1086#1081#1089#1090#1074#1086' '#1076#1083#1103' ('#1048#1052'.'#1055'.)= '#1058#1077#1089#1090' ('#1048#1052'.'#1055'.)'
        TabOrder = 26
        Visible = False
      end
      object chbSetZoom: TCheckBox
        Left = 11
        Top = 189
        Width = 305
        Height = 17
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1052#1072#1089#1096#1090#1072#1073' = '#1055#1086' '#1096#1080#1088#1080#1085#1077' '#1089#1090#1088#1072#1085#1080#1094#1099
        TabOrder = 19
      end
      object chbSetLabelEnd: TCheckBox
        Left = 14
        Top = 408
        Width = 417
        Height = 17
        Caption = 
          #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1086#1081#1089#1090#1074#1086' '#1047#1072#1075#1086#1083#1086#1074#1086#1082' '#1089' '#1086#1082#1086#1085#1095#1072#1085#1080#1077#1084' <:> '#1080' '#1088#1072#1074#1085#1077#1085#1080#1077#1084' '#1089#1087#1088#1072#1074 +
          #1072
        TabOrder = 27
        Visible = False
      end
      object chbSetGridSize: TCheckBox
        Left = 15
        Top = 502
        Width = 273
        Height = 17
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1086#1081#1089#1090#1074#1086' '#1056#1072#1079#1084#1077#1088' '#1089#1077#1090#1082#1080' '#1076#1083#1103' '#1092#1086#1088#1084#1099':'
        TabOrder = 7
        Visible = False
      end
      object edSetGridSize: TEdit
        Left = 285
        Top = 500
        Width = 36
        Height = 21
        ReadOnly = True
        TabOrder = 9
        Text = '2'
        Visible = False
      end
      object udSetGridSize: TUpDown
        Left = 321
        Top = 500
        Width = 15
        Height = 21
        Associate = edSetGridSize
        Min = 1
        Max = 16
        Position = 2
        TabOrder = 8
        Visible = False
      end
      object chbSetFont: TCheckBox
        Left = 11
        Top = 114
        Width = 177
        Height = 17
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1086#1081#1089#1090#1074#1086' '#1064#1088#1080#1092#1090':'
        TabOrder = 10
      end
      object edSetFont: TEdit
        Left = 193
        Top = 112
        Width = 195
        Height = 21
        ReadOnly = True
        TabOrder = 11
      end
      object btSetFont: TButton
        Left = 394
        Top = 112
        Width = 21
        Height = 21
        Caption = '...'
        TabOrder = 12
        OnClick = btSetFontClick
      end
      object chbSetSignatureDate: TCheckBox
        Left = 11
        Top = 139
        Width = 312
        Height = 17
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1086#1081#1089#1090#1074#1086' '#1055#1086#1076#1087#1080#1089#1100' '#1076#1083#1103' '#1101#1083#1077#1084#1077#1085#1090#1072' '#1090#1080#1087#1072' '#1076#1072#1090#1072':'
        TabOrder = 13
      end
      object edSetSignatureDate: TEdit
        Left = 324
        Top = 137
        Width = 91
        Height = 21
        TabOrder = 14
      end
      object chbSetMaskForCode: TCheckBox
        Left = 14
        Top = 454
        Width = 321
        Height = 17
        Caption = #1055#1088#1080#1084#1077#1085#1080#1090#1100' '#1084#1072#1089#1082#1091' '#1076#1083#1103' '#1082#1086#1076#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103
        TabOrder = 28
        Visible = False
      end
      object chbSetStyle: TCheckBox
        Left = 11
        Top = 213
        Width = 121
        Height = 17
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1090#1080#1083#1100':'
        TabOrder = 20
      end
      object edSetStyleFor: TEdit
        Left = 330
        Top = 211
        Width = 122
        Height = 21
        TabOrder = 22
      end
      object cmbStyleName: TComboBox
        Left = 132
        Top = 211
        Width = 120
        Height = 21
        ItemHeight = 13
        TabOrder = 21
        Items.Strings = (
          #1047#1072#1075#1086#1083#1086#1074#1086#1082' 1'
          #1047#1072#1075#1086#1083#1086#1074#1086#1082' 2'
          #1047#1072#1075#1086#1083#1086#1074#1086#1082' 3'
          #1059#1076#1086#1089#1090#1086#1074#1077#1088#1080#1090#1077#1083#1100#1085#1072#1103' '#1085#1072#1076#1087#1080#1089#1100)
      end
      object chbWithFields: TCheckBox
        Left = 421
        Top = 164
        Width = 53
        Height = 17
        Caption = #1055#1086#1083#1103
        TabOrder = 18
      end
      object chbChangeOldDate: TCheckBox
        Left = 11
        Top = 65
        Width = 417
        Height = 17
        Caption = #1047#1072#1084#1077#1085#1080#1090#1100' '#1089#1090#1072#1088#1086#1077' '#1087#1086#1083#1077' '#1076#1072#1090#1072' '#1085#1072' '#1085#1086#1074#1086#1077
        TabOrder = 3
      end
      object chbSetNewSubs: TCheckBox
        Left = 11
        Top = 89
        Width = 278
        Height = 17
        Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1086#1076#1089#1090#1072#1085#1086#1074#1082#1091' '#1076#1083#1103' '#1101#1083#1077#1084#1077#1085#1090#1086#1074' '#1089' '#1087#1086#1083#1103#1084#1080':'
        TabOrder = 4
      end
      object edSetNewSubsField: TEdit
        Left = 295
        Top = 87
        Width = 80
        Height = 21
        TabOrder = 5
      end
      object edSetNewSubsValue: TEdit
        Left = 400
        Top = 87
        Width = 80
        Height = 21
        TabOrder = 6
      end
      object chbDeleteLabelByCaption: TCheckBox
        Left = 15
        Top = 479
        Width = 185
        Height = 17
        Caption = #1059#1076#1072#1083#1080#1090#1100' '#1084#1077#1090#1082#1080' '#1089' '#1079#1072#1075#1086#1083#1086#1074#1082#1086#1084':'
        TabOrder = 29
        Visible = False
      end
      object edDeleteLabelByCaption: TEdit
        Left = 251
        Top = 477
        Width = 220
        Height = 21
        TabOrder = 30
        Visible = False
      end
      object chbDeleteElementByWord: TCheckBox
        Left = 15
        Top = 291
        Width = 225
        Height = 17
        Caption = #1059#1076#1072#1083#1080#1090#1100' '#1101#1083#1077#1084#1077#1085#1090#1099' '#1089#1086' '#1089#1074#1086#1081#1089#1090#1074#1086#1084' Word:'
        TabOrder = 31
        Visible = False
      end
      object edDeleteElementByWord: TEdit
        Left = 251
        Top = 289
        Width = 220
        Height = 21
        TabOrder = 32
        Visible = False
      end
    end
    object ProgressBar: TProgressBar
      Left = 5
      Top = 5
      Width = 582
      Height = 16
      Align = alTop
      TabOrder = 2
      Visible = False
    end
  end
  object lv: TListView
    Left = 0
    Top = 0
    Width = 592
    Height = 157
    Align = alClient
    Checkboxes = True
    Columns = <
      item
        AutoSize = True
        Caption = #1048#1084#1103' '#1096#1072#1073#1083#1086#1085#1072
      end
      item
        Caption = #1044#1072#1090#1072' '#1080' '#1074#1088#1077#1084#1103' '#1080#1079#1084#1077#1085#1077#1085#1080#1103
        Width = 100
      end>
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    PopupMenu = pmUtil
    TabOrder = 1
    ViewStyle = vsReport
  end
  object pmUtil: TPopupMenu
    Left = 400
    Top = 168
    object Checkall1: TMenuItem
      Caption = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
      OnClick = Checkall1Click
    end
    object Uncheckall1: TMenuItem
      Caption = #1059#1073#1088#1072#1090#1100' '#1074#1099#1073#1086#1088' '#1074#1089#1077#1093
      OnClick = Uncheckall1Click
    end
  end
  object fd: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 365
    Top = 167
  end
end
