object fmEditBlank: TfmEditBlank
  Left = 596
  Top = 346
  BorderStyle = bsDialog
  Caption = 'fmEditBlank'
  ClientHeight = 112
  ClientWidth = 349
  Color = clBtnFace
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
  object lbSeries: TLabel
    Left = 28
    Top = 11
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = #1057#1077#1088#1080#1103':'
  end
  object lbNumFrom: TLabel
    Left = 13
    Top = 37
    Width = 50
    Height = 13
    Alignment = taRightJustify
    Caption = #1053#1086#1084#1077#1088' '#1086#1090':'
  end
  object lbNumTo: TLabel
    Left = 183
    Top = 37
    Width = 50
    Height = 13
    Alignment = taRightJustify
    Caption = #1053#1086#1084#1077#1088' '#1087#1086':'
  end
  object edSeries: TEdit
    Left = 69
    Top = 8
    Width = 164
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edSeriesChange
    OnKeyPress = edSeriesKeyPress
  end
  object edNumFrom: TEdit
    Left = 69
    Top = 34
    Width = 100
    Height = 21
    MaxLength = 250
    TabOrder = 2
    OnChange = edSeriesChange
    OnKeyPress = edNumToKeyPress
  end
  object pnBottom: TPanel
    Left = 0
    Top = 58
    Width = 349
    Height = 54
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object Panel3: TPanel
      Left = 164
      Top = 0
      Width = 185
      Height = 54
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      object bibOk: TBitBtn
        Left = 21
        Top = 23
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        TabOrder = 0
        NumGlyphs = 2
      end
      object bibCancel: TBitBtn
        Left = 104
        Top = 23
        Width = 75
        Height = 25
        Cancel = True
        Caption = #1054#1090#1084#1077#1085#1072
        ModalResult = 2
        TabOrder = 1
        NumGlyphs = 2
      end
    end
    object cbInString: TCheckBox
      Left = 6
      Top = 3
      Width = 186
      Height = 17
      Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1074#1093#1086#1078#1076#1077#1085#1080#1102' '#1089#1090#1088#1086#1082#1080
      TabOrder = 0
      Visible = False
    end
    object bibClear: TBitBtn
      Left = 7
      Top = 23
      Width = 75
      Height = 25
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 1
      OnClick = bibClearClick
      NumGlyphs = 2
    end
  end
  object edNumTo: TEdit
    Left = 239
    Top = 34
    Width = 97
    Height = 21
    MaxLength = 250
    TabOrder = 3
    OnChange = edSeriesChange
    OnKeyPress = edNumToKeyPress
  end
  object CheckBoxVisible: TCheckBox
    Left = 249
    Top = 11
    Width = 80
    Height = 17
    Hint = #1042#1080#1076#1080#1084#1086#1089#1090#1100' '#1074' '#1092#1086#1088#1084#1077
    Caption = #1042#1080#1076#1080#1084#1086#1089#1090#1100
    TabOrder = 1
    OnClick = CheckBoxVisibleClick
  end
end
