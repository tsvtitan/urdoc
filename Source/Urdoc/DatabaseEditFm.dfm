object DatabaseEditForm: TDatabaseEditForm
  Left = 489
  Top = 404
  BorderStyle = bsDialog
  Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 104
  ClientWidth = 330
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    330
    104)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelDatabase: TLabel
    Left = 21
    Top = 40
    Width = 69
    Height = 13
    Alignment = taRightJustify
    Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093':'
  end
  object LabelName: TLabel
    Left = 13
    Top = 13
    Width = 77
    Height = 13
    Alignment = taRightJustify
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
  end
  object edBaseDir: TEdit
    Left = 96
    Top = 37
    Width = 194
    Height = 21
    Color = clBtnFace
    ReadOnly = True
    TabOrder = 1
  end
  object bibBaseDir: TBitBtn
    Left = 296
    Top = 37
    Width = 21
    Height = 21
    Caption = '...'
    TabOrder = 2
    OnClick = bibBaseDirClick
  end
  object bibOk: TBitBtn
    Left = 166
    Top = 71
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    TabOrder = 3
    OnClick = bibOkClick
    NumGlyphs = 2
    ExplicitLeft = 156
    ExplicitTop = 120
  end
  object bibCancel: TBitBtn
    Left = 247
    Top = 71
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 4
    OnClick = bibCancelClick
    NumGlyphs = 2
    ExplicitLeft = 237
    ExplicitTop = 120
  end
  object EditName: TEdit
    Left = 96
    Top = 10
    Width = 221
    Height = 21
    TabOrder = 0
  end
end
