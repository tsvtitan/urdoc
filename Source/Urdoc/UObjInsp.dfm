object fmObjInsp: TfmObjInsp
  Left = 464
  Top = 128
  BorderStyle = bsSizeToolWin
  Caption = #1054#1073#1100#1077#1082#1090#1085#1099#1081' '#1080#1085#1089#1087#1077#1082#1090#1086#1088
  ClientHeight = 381
  ClientWidth = 229
  Color = clBtnFace
  Constraints.MinHeight = 100
  Constraints.MinWidth = 100
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnStartDock = FormStartDock
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter: TSplitter
    Left = 0
    Top = 298
    Width = 229
    Height = 3
    Cursor = crVSplit
    Align = alBottom
  end
  object PanelInfo: TPanel
    Left = 0
    Top = 301
    Width = 229
    Height = 80
    Align = alBottom
    BevelOuter = bvNone
    BorderWidth = 3
    TabOrder = 0
    object MemoInfo: TMemo
      Left = 3
      Top = 3
      Width = 223
      Height = 74
      Align = alClient
      Color = clBtnFace
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
