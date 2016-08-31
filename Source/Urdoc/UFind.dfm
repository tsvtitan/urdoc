object fmFind: TfmFind
  Left = 315
  Top = 157
  BorderStyle = bsDialog
  Caption = #1053#1072#1081#1090#1080
  ClientHeight = 117
  ClientWidth = 339
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnR: TPanel
    Left = 249
    Top = 0
    Width = 90
    Height = 117
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 4
    object bibFind: TBitBtn
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = #1053#1072#1081#1090#1080
      TabOrder = 0
      OnClick = bibFindClick
      Glyph.Data = {
        F6000000424DF600000000000000760000002800000010000000100000000100
        0400000000008000000000000000000000001000000010000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
        8888888888888888888800000888880000080F000888880F00080F000888880F
        0008000000080000000800F000000F00000800F000800F00000800F000800F00
        00088000000000000088880F00080F0008888800000800000888888000888000
        88888880F08880F0888888800088800088888888888888888888}
    end
    object bibCancel: TBitBtn
      Left = 8
      Top = 40
      Width = 75
      Height = 25
      Caption = #1047#1072#1082#1088#1099#1090#1100
      TabOrder = 1
      OnClick = bibCancelClick
    end
  end
  object gbFindStr: TGroupBox
    Left = 6
    Top = 2
    Width = 243
    Height = 50
    Caption = ' '#1057#1090#1088#1086#1082#1072' '#1087#1086#1080#1089#1082#1072' '
    TabOrder = 0
    object cbFindStr: TComboBox
      Left = 11
      Top = 17
      Width = 221
      Height = 21
      ItemHeight = 13
      TabOrder = 0
    end
  end
  object rbWhere: TRadioGroup
    Left = 6
    Top = 55
    Width = 123
    Height = 57
    Caption = ' '#1043#1076#1077' '#1080#1089#1082#1072#1090#1100' '
    ItemIndex = 0
    Items.Strings = (
      #1074' '#1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1080
      #1074' '#1054#1087#1080#1089#1072#1085#1080#1080)
    TabOrder = 1
  end
  object cbCharCase: TCheckBox
    Left = 137
    Top = 58
    Width = 108
    Height = 17
    Caption = #1056#1077#1075#1080#1089#1090#1088
    TabOrder = 2
  end
  object cbWholeWord: TCheckBox
    Left = 137
    Top = 74
    Width = 108
    Height = 17
    Caption = #1062#1077#1083#1080#1082#1086#1084' '#1089#1083#1086#1074#1086
    TabOrder = 3
  end
  object cbMulti: TCheckBox
    Left = 137
    Top = 90
    Width = 108
    Height = 17
    Caption = #1052#1091#1083#1100#1090#1080' '#1074#1099#1073#1086#1088
    TabOrder = 5
    Visible = False
  end
end
