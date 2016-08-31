object fmCaseReestr: TfmCaseReestr
  Left = 335
  Top = 221
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088
  ClientHeight = 126
  ClientWidth = 229
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object pnBottom: TPanel
    Left = 0
    Top = 88
    Width = 229
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      Left = 44
      Top = 0
      Width = 185
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object bibOk: TBitBtn
        Left = 21
        Top = 7
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        TabOrder = 0
        OnClick = bibOkClick
        NumGlyphs = 2
      end
      object bibCancel: TBitBtn
        Left = 104
        Top = 7
        Width = 75
        Height = 25
        Cancel = True
        Caption = #1054#1090#1084#1077#1085#1072
        ModalResult = 2
        TabOrder = 1
        NumGlyphs = 2
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 229
    Height = 88
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object rgbTypeRecord: TRadioGroup
      Left = 5
      Top = 5
      Width = 219
      Height = 64
      Align = alTop
      Caption = ' '#1058#1080#1087' '#1079#1072#1087#1080#1089#1080' '#1074' '#1088#1077#1077#1089#1090#1088#1077' '
      ItemIndex = 0
      Items.Strings = (
        #1044#1086#1082#1091#1084#1077#1085#1090' '#1080#1079' '#1096#1072#1073#1083#1086#1085#1072
        #1054#1087#1077#1088#1072#1094#1080#1103' '#1073#1077#1079' '#1096#1072#1073#1083#1086#1085#1072)
      TabOrder = 0
      OnClick = rgbTypeRecordClick
    end
    object chbKeepDoc: TCheckBox
      Left = 13
      Top = 72
      Width = 195
      Height = 17
      Caption = #1061#1088#1072#1085#1080#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090#1099
      TabOrder = 1
      Visible = False
    end
  end
end
