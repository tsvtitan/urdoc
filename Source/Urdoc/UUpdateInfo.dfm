object fmUpdateInfo: TfmUpdateInfo
  Left = 162
  Top = 171
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103' '#1086#1073' '#1086#1073#1085#1086#1074#1083#1077#1085#1080#1103#1093
  ClientHeight = 353
  ClientWidth = 542
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnBottom: TPanel
    Left = 0
    Top = 318
    Width = 542
    Height = 35
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      542
      35)
    object bibClose: TBitBtn
      Left = 461
      Top = 4
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = #1047#1072#1082#1088#1099#1090#1100
      Default = True
      TabOrder = 1
      OnClick = bibCloseClick
    end
    object chbNotViewOnLoad: TCheckBox
      Left = 9
      Top = 8
      Width = 152
      Height = 17
      Anchors = [akLeft, akBottom]
      Caption = #1041#1086#1083#1100#1096#1077' '#1085#1077' '#1087#1086#1082#1072#1079#1099#1074#1072#1090#1100
      TabOrder = 0
    end
  end
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 542
    Height = 318
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object reInfo: TRichEdit
      Left = 5
      Top = 5
      Width = 532
      Height = 308
      Align = alClient
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
end
