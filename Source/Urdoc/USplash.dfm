object fmSplash: TfmSplash
  Left = 466
  Top = 232
  AlphaBlendValue = 100
  BorderStyle = bsNone
  Caption = #1047#1072#1089#1090#1072#1074#1082#1072
  ClientHeight = 234
  ClientWidth = 305
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  DesignSize = (
    305
    234)
  PixelsPerInch = 96
  TextHeight = 13
  object im: TImage
    Left = 0
    Top = 0
    Width = 305
    Height = 234
    Align = alClient
    Center = True
  end
  object ImLabel: TImage
    Left = 0
    Top = 0
    Width = 305
    Height = 234
    Align = alClient
    AutoSize = True
    Center = True
    ParentShowHint = False
    ShowHint = False
  end
  object lbVersion: TLabel
    Left = 6
    Top = 216
    Width = 43
    Height = 14
    Anchors = [akLeft, akBottom]
    Caption = 'lbVersion'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
  object Shape1: TShape
    Left = 0
    Top = 0
    Width = 305
    Height = 234
    Align = alClient
    Brush.Style = bsClear
  end
  object lbMainPlus: TLabel
    Left = 248
    Top = 1
    Width = 51
    Height = 14
    Alignment = taRightJustify
    Anchors = [akTop, akRight]
    Caption = 'lbMainPlus'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -11
    Font.Name = 'Times New Roman'
    Font.Style = []
    ParentFont = False
    Transparent = True
  end
end
