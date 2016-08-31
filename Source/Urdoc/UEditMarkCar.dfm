object fmEditMarkCar: TfmEditMarkCar
  Left = 302
  Top = 173
  BorderStyle = bsDialog
  ClientHeight = 101
  ClientWidth = 338
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
  object lbName: TLabel
    Left = 13
    Top = 16
    Width = 79
    Height = 13
    Caption = #1052#1072#1088#1082#1072' '#1084#1072#1096#1080#1085#1099':'
  end
  object pnBottom: TPanel
    Left = 0
    Top = 60
    Width = 338
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 290
    object Panel3: TPanel
      Left = 153
      Top = 0
      Width = 185
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 105
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
  object edName: TEdit
    Left = 102
    Top = 13
    Width = 228
    Height = 21
    MaxLength = 250
    TabOrder = 0
    OnChange = edNameChange
    OnKeyPress = edNameKeyPress
  end
  object cbInString: TCheckBox
    Left = 6
    Top = 44
    Width = 186
    Height = 17
    Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1074#1093#1086#1078#1076#1077#1085#1080#1102' '#1089#1090#1088#1086#1082#1080
    TabOrder = 1
    Visible = False
  end
end
