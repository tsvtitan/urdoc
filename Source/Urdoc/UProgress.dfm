object fmProgress: TfmProgress
  Left = 555
  Top = 262
  BorderIcons = [biMinimize, biMaximize]
  BorderStyle = bsDialog
  Caption = #1050#1086#1087#1080#1088#1086#1074#1072#1085#1080#1077
  ClientHeight = 86
  ClientWidth = 273
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 273
    Height = 86
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object lbProgress: TLabel
      Left = 10
      Top = 7
      Width = 255
      Height = 13
      AutoSize = False
      Caption = 'lbProgress'
      EllipsisPosition = epEndEllipsis
    end
    object Panel2: TPanel
      Left = 8
      Top = 25
      Width = 257
      Height = 21
      BevelOuter = bvNone
      TabOrder = 0
      object gag: TProgressBar
        Left = 0
        Top = 0
        Width = 257
        Height = 21
        Align = alClient
        TabOrder = 0
      end
    end
    object bibBreak: TBitBtn
      Left = 97
      Top = 55
      Width = 75
      Height = 25
      Caption = #1055#1088#1077#1088#1074#1072#1090#1100
      TabOrder = 1
      OnClick = bibBreakClick
    end
  end
end
