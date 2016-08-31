object fmMain: TfmMain
  Left = 504
  Top = 210
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1041#1099#1089#1090#1088#1086#1077' '#1074#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077
  ClientHeight = 249
  ClientWidth = 301
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    301
    249)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 16
    Width = 272
    Height = 52
    Caption = 
      #1042#1053#1048#1052#1040#1053#1048#1045'!!!'#13#10#1055#1088#1077#1078#1076#1077' '#1095#1077#1084' '#1079#1072#1087#1091#1089#1082#1072#1090#1100' '#1074#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' '#1080#1079' '#1072#1088#1093#1080#1074#1072#13#10#1091#1073#1077#1076 +
      #1080#1090#1077#1089#1100' '#1095#1090#1086' '#1085#1080' '#1086#1076#1080#1085' '#1080#1079' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1077#1081' '#1085#1077' '#1088#1072#1073#1086#1090#1072#1077#1090#13#10#1089' '#1073#1072#1079#1086#1081' '#1076#1072#1085#1085#1099#1093' '#1082 +
      #1086#1090#1086#1088#1091#1102' '#1073#1091#1076#1077#1090#1077' '#1074#1086#1089#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1090#1100'.'
  end
  object lbArc: TLabel
    Left = 16
    Top = 152
    Width = 33
    Height = 13
    Caption = #1040#1088#1093#1080#1074':'
  end
  object lbBase: TLabel
    Left = 16
    Top = 179
    Width = 28
    Height = 13
    Caption = #1041#1072#1079#1072':'
  end
  object aniRestore: TAnimate
    Left = 16
    Top = 80
    Width = 272
    Height = 60
    CommonAVI = aviCopyFiles
    StopFrame = 34
  end
  object edArc: TEdit
    Left = 59
    Top = 149
    Width = 206
    Height = 21
    TabOrder = 1
  end
  object btArc: TButton
    Left = 268
    Top = 149
    Width = 21
    Height = 21
    Hint = #1042#1099#1073#1088#1072#1090#1100' '#1092#1072#1081#1083' '#1072#1088#1093#1080#1074#1072
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = btArcClick
  end
  object edBase: TEdit
    Left = 59
    Top = 176
    Width = 206
    Height = 21
    TabOrder = 3
  end
  object btBase: TButton
    Left = 268
    Top = 176
    Width = 21
    Height = 21
    Hint = #1042#1099#1073#1088#1072#1090#1100' '#1073#1072#1079#1091' '#1074' '#1082#1086#1090#1086#1088#1091#1102' '#1073#1091#1076#1077#1090#1077' '#1074#1086#1089#1089#1090#1072#1085#1072#1074#1083#1080#1074#1072#1090#1100
    Caption = '...'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    OnClick = btBaseClick
  end
  object bibClose: TBitBtn
    Left = 216
    Top = 216
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1042#1099#1093#1086#1076
    TabOrder = 6
    OnClick = bibCloseClick
  end
  object bibRun: TBitBtn
    Left = 10
    Top = 216
    Width = 75
    Height = 25
    Hint = #1047#1072#1087#1091#1089#1082' '#1074#1086#1089#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1103
    Caption = #1047#1072#1087#1091#1089#1082
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = bibRunClick
  end
  object srvRestore: TIBRestoreService
    TraceFlags = []
    PageBuffers = 0
    Left = 144
    Top = 88
  end
  object od: TOpenDialog
    Left = 80
    Top = 88
  end
  object tm: TTimer
    Enabled = False
    Interval = 350
    OnTimer = tmTimer
    Left = 192
    Top = 88
  end
end
