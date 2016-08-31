object fmEditSubs: TfmEditSubs
  Left = 484
  Top = 233
  BorderStyle = bsDialog
  ClientHeight = 112
  ClientWidth = 282
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
    Width = 77
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
  end
  object lbPriority: TLabel
    Left = 170
    Top = 42
    Width = 48
    Height = 13
    Caption = #1055#1086#1088#1103#1076#1086#1082':'
  end
  object pnBottom: TPanel
    Left = 0
    Top = 71
    Width = 282
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object Panel3: TPanel
      Left = 97
      Top = 0
      Width = 185
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      ExplicitLeft = 89
      ExplicitTop = 11
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
      Left = 8
      Top = 11
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
    Width = 174
    Height = 21
    MaxLength = 50
    TabOrder = 0
    OnChange = edNameChange
    OnKeyPress = edNameKeyPress
  end
  object cbInString: TCheckBox
    Left = 8
    Top = 59
    Width = 186
    Height = 17
    Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1074#1093#1086#1078#1076#1077#1085#1080#1102' '#1089#1090#1088#1086#1082#1080
    TabOrder = 3
    Visible = False
  end
  object edPriority: TEdit
    Left = 224
    Top = 39
    Width = 37
    Height = 21
    ReadOnly = True
    TabOrder = 1
    Text = '1'
    OnChange = edNameChange
  end
  object udPriority: TUpDown
    Left = 261
    Top = 39
    Width = 15
    Height = 21
    Associate = edPriority
    Min = 1
    Max = 999
    Position = 1
    TabOrder = 2
  end
end
