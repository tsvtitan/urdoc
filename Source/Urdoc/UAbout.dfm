object fmAbout: TfmAbout
  Left = 534
  Top = 230
  BorderStyle = bsDialog
  Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
  ClientHeight = 236
  ClientWidth = 310
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object lbTel: TLabel
    Left = 48
    Top = 46
    Width = 262
    Height = 13
    AutoSize = False
  end
  object lbCorp: TLabel
    Left = 48
    Top = 31
    Width = 262
    Height = 13
    AutoSize = False
  end
  object lbVer: TLabel
    Left = 48
    Top = 16
    Width = 262
    Height = 13
    AutoSize = False
    Caption = #1042#1077#1088#1089#1080#1080' '#1085#1077#1090
  end
  object lbMain: TLabel
    Left = 48
    Top = 2
    Width = 257
    Height = 13
    HelpContext = 13
    AutoSize = False
    Caption = #1069#1090#1086' '#1090#1077#1089#1090
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 0
    Top = 190
    Width = 310
    Height = 9
    Align = alBottom
    Shape = bsBottomLine
  end
  object lbMemAll: TLabel
    Left = 5
    Top = 166
    Width = 71
    Height = 13
    Caption = #1042#1089#1077#1075#1086' '#1087#1072#1084#1103#1090#1080':'
  end
  object lbMemUse: TLabel
    Left = 5
    Top = 179
    Width = 114
    Height = 13
    Caption = #1048#1089#1087#1086#1083#1100#1079#1091#1077#1084#1086#1081' '#1087#1072#1084#1103#1090#1080':'
  end
  object Bevel2: TBevel
    Left = 0
    Top = 58
    Width = 310
    Height = 5
    Shape = bsBottomLine
  end
  object imEXE: TImage
    Left = 8
    Top = 10
    Width = 32
    Height = 32
    OnClick = imEXEClick
  end
  object pnBottom: TPanel
    Left = 0
    Top = 199
    Width = 310
    Height = 37
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    DesignSize = (
      310
      37)
    object btOk: TBitBtn
      Left = 223
      Top = 6
      Width = 80
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 2
      TabOrder = 0
      NumGlyphs = 2
    end
  end
  object pnRule: TPanel
    Left = 5
    Top = 69
    Width = 301
    Height = 95
    BevelOuter = bvLowered
    Color = clBlack
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -12
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
end
