object fmEditChamber: TfmEditChamber
  Left = 596
  Top = 346
  BorderStyle = bsDialog
  Caption = 'fmEditChamber'
  ClientHeight = 192
  ClientWidth = 362
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
  object lbName: TLabel
    Left = 9
    Top = 16
    Width = 77
    Height = 13
    Alignment = taRightJustify
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
  end
  object lbAddress: TLabel
    Left = 51
    Top = 42
    Width = 35
    Height = 13
    Alignment = taRightJustify
    Caption = #1040#1076#1088#1077#1089':'
  end
  object lbPresident: TLabel
    Left = 27
    Top = 68
    Width = 59
    Height = 13
    Alignment = taRightJustify
    Caption = #1055#1088#1077#1079#1080#1076#1077#1085#1090':'
  end
  object lbPhone: TLabel
    Left = 31
    Top = 94
    Width = 56
    Height = 13
    Alignment = taRightJustify
    Caption = #1058#1077#1083#1077#1092#1086#1085#1099':'
  end
  object lbEmail: TLabel
    Left = 36
    Top = 120
    Width = 51
    Height = 13
    Alignment = taRightJustify
    Caption = #1069#1083'.'#1087#1086#1095#1090#1072':'
  end
  object edName: TEdit
    Left = 93
    Top = 12
    Width = 262
    Height = 21
    MaxLength = 100
    TabOrder = 0
    OnChange = edNameChange
    OnKeyPress = edNameKeyPress
  end
  object edAddress: TEdit
    Left = 93
    Top = 38
    Width = 262
    Height = 21
    MaxLength = 250
    TabOrder = 1
    OnChange = edNameChange
    OnKeyPress = edNameKeyPress
  end
  object pnBottom: TPanel
    Left = 0
    Top = 138
    Width = 362
    Height = 54
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 5
    object Panel3: TPanel
      Left = 177
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
  object edPresident: TEdit
    Left = 93
    Top = 64
    Width = 262
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edNameChange
    OnKeyPress = edNameKeyPress
  end
  object edPhone: TEdit
    Left = 93
    Top = 90
    Width = 262
    Height = 21
    MaxLength = 100
    TabOrder = 3
    OnChange = edNameChange
    OnKeyPress = edNameKeyPress
  end
  object edEmail: TEdit
    Left = 93
    Top = 116
    Width = 262
    Height = 21
    MaxLength = 100
    TabOrder = 4
    OnChange = edNameChange
    OnKeyPress = edNameKeyPress
  end
end
