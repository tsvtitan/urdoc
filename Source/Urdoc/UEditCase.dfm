object fmEditCase: TfmEditCase
  Left = 387
  Top = 221
  BorderStyle = bsDialog
  ClientHeight = 233
  ClientWidth = 290
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
  PixelsPerInch = 96
  TextHeight = 13
  object lbNomin: TLabel
    Left = 13
    Top = 16
    Width = 79
    Height = 13
    Caption = #1048#1084#1077#1085#1080#1090#1077#1083#1100#1085#1099#1081':'
  end
  object lbGenit: TLabel
    Left = 22
    Top = 43
    Width = 73
    Height = 13
    Caption = #1056#1086#1076#1080#1090#1077#1083#1100#1085#1099#1081':'
  end
  object lbDativ: TLabel
    Left = 32
    Top = 71
    Width = 62
    Height = 13
    Caption = #1044#1072#1090#1077#1083#1100#1085#1099#1081':'
  end
  object lbCreat: TLabel
    Left = 16
    Top = 99
    Width = 78
    Height = 13
    Caption = #1058#1074#1086#1088#1080#1090#1077#1083#1100#1085#1099#1081':'
  end
  object lbVinit: TLabel
    Left = 22
    Top = 128
    Width = 72
    Height = 13
    Caption = #1042#1080#1085#1080#1090#1077#1083#1100#1085#1099#1081':'
  end
  object lbPredl: TLabel
    Left = 24
    Top = 157
    Width = 70
    Height = 13
    Caption = #1055#1088#1077#1076#1083#1086#1078#1085#1099#1081':'
  end
  object pnBottom: TPanel
    Left = 0
    Top = 192
    Width = 290
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 7
    object Panel3: TPanel
      Left = 105
      Top = 0
      Width = 185
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object bibOk: TBitBtn
        Left = 21
        Top = 10
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        TabOrder = 0
        NumGlyphs = 2
      end
      object bibCancel: TBitBtn
        Left = 104
        Top = 10
        Width = 75
        Height = 25
        Cancel = True
        Caption = #1054#1090#1084#1077#1085#1072
        ModalResult = 2
        TabOrder = 1
        NumGlyphs = 2
      end
    end
    object bibClear: TBitBtn
      Left = 7
      Top = 10
      Width = 75
      Height = 25
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 0
      OnClick = bibClearClick
      NumGlyphs = 2
    end
  end
  object edNomin: TEdit
    Left = 102
    Top = 13
    Width = 174
    Height = 21
    MaxLength = 50
    TabOrder = 0
    OnChange = edNominChange
    OnKeyPress = edNominKeyPress
  end
  object cbInString: TCheckBox
    Left = 6
    Top = 177
    Width = 186
    Height = 17
    Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1074#1093#1086#1078#1076#1077#1085#1080#1102' '#1089#1090#1088#1086#1082#1080
    TabOrder = 6
    Visible = False
  end
  object edGenit: TEdit
    Left = 102
    Top = 40
    Width = 174
    Height = 21
    MaxLength = 50
    TabOrder = 1
    OnChange = edNominChange
    OnKeyPress = edNominKeyPress
  end
  object edDativ: TEdit
    Left = 102
    Top = 68
    Width = 174
    Height = 21
    MaxLength = 50
    TabOrder = 2
    OnChange = edNominChange
    OnKeyPress = edNominKeyPress
  end
  object edCreat: TEdit
    Left = 102
    Top = 96
    Width = 174
    Height = 21
    MaxLength = 50
    TabOrder = 3
    OnChange = edNominChange
    OnKeyPress = edNominKeyPress
  end
  object edVinit: TEdit
    Left = 102
    Top = 125
    Width = 174
    Height = 21
    MaxLength = 50
    TabOrder = 4
    OnChange = edNominChange
    OnKeyPress = edNominKeyPress
  end
  object edPredl: TEdit
    Left = 102
    Top = 154
    Width = 174
    Height = 21
    MaxLength = 50
    TabOrder = 5
    OnChange = edNominChange
    OnKeyPress = edNominKeyPress
  end
end
