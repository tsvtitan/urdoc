object fmEditNotarius: TfmEditNotarius
  Left = 389
  Top = 170
  BorderStyle = bsDialog
  Caption = 'fmEditNotarius'
  ClientHeight = 318
  ClientWidth = 362
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
  object lbFio: TLabel
    Left = 94
    Top = 16
    Width = 27
    Height = 13
    Alignment = taRightJustify
    Caption = #1060#1048#1054':'
  end
  object lbUrAdres: TLabel
    Left = 14
    Top = 42
    Width = 107
    Height = 13
    Alignment = taRightJustify
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1080#1081' '#1072#1076#1088#1077#1089':'
  end
  object lbINN: TLabel
    Left = 96
    Top = 96
    Width = 25
    Height = 13
    Alignment = taRightJustify
    Caption = #1048#1053#1053':'
  end
  object LabelPhone: TLabel
    Left = 73
    Top = 69
    Width = 48
    Height = 13
    Alignment = taRightJustify
    Caption = #1058#1077#1083#1077#1092#1086#1085':'
  end
  object edFio: TEdit
    Left = 128
    Top = 12
    Width = 224
    Height = 21
    MaxLength = 50
    TabOrder = 0
    OnChange = edFioChange
    OnKeyPress = edFioKeyPress
  end
  object edUrAdres: TEdit
    Left = 128
    Top = 38
    Width = 224
    Height = 21
    MaxLength = 250
    TabOrder = 1
    OnChange = edFioChange
    OnKeyPress = edFioKeyPress
  end
  object pnBottom: TPanel
    Left = 0
    Top = 264
    Width = 362
    Height = 54
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    ExplicitTop = 226
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
  object pc: TPageControl
    Left = 0
    Top = 145
    Width = 362
    Height = 119
    ActivePage = tsTownFull
    Align = alBottom
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    ExplicitTop = 107
    object tsTownFull: TTabSheet
      Caption = #1058#1080#1087' '#1085#1072#1089'. '#1087#1091#1085#1082#1090#1072' ('#1087#1086#1083#1085#1086#1077')'
      object lbTownFullNormal: TLabel
        Left = 13
        Top = 13
        Width = 115
        Height = 13
        Caption = #1043#1086#1088#1086#1076', '#1089#1077#1083#1086', '#1076#1077#1088#1077#1074#1085#1103':'
      end
      object lbTownFullWhere: TLabel
        Left = 7
        Top = 39
        Width = 121
        Height = 13
        Caption = #1043#1086#1088#1086#1076#1077', '#1089#1077#1083#1077', '#1076#1077#1088#1077#1074#1085#1077':'
      end
      object lbTownFullWhat: TLabel
        Left = 7
        Top = 65
        Width = 121
        Height = 13
        Caption = #1043#1086#1088#1086#1076#1072', '#1089#1077#1083#1072', '#1076#1077#1088#1077#1074#1085#1080':'
      end
      object edTownFullNormal: TEdit
        Left = 131
        Top = 9
        Width = 214
        Height = 21
        MaxLength = 250
        TabOrder = 0
        OnChange = edFioChange
        OnKeyPress = edFioKeyPress
      end
      object edTownFullWhere: TEdit
        Left = 131
        Top = 35
        Width = 214
        Height = 21
        MaxLength = 250
        TabOrder = 1
        OnChange = edFioChange
        OnKeyPress = edFioKeyPress
      end
      object edTownFullWhat: TEdit
        Left = 131
        Top = 61
        Width = 214
        Height = 21
        MaxLength = 250
        TabOrder = 2
        OnChange = edFioChange
        OnKeyPress = edFioKeyPress
      end
    end
    object tsTownSmall: TTabSheet
      Caption = #1058#1080#1087' '#1085#1072#1089'. '#1087#1091#1085#1082#1090#1072' ('#1089#1086#1082#1088'.)'
      ImageIndex = 1
      object lbTownSmallNormal: TLabel
        Left = 87
        Top = 13
        Width = 43
        Height = 13
        Caption = #1075'., '#1089'., '#1076'.'
      end
      object lbTownSmallWhere: TLabel
        Left = 87
        Top = 39
        Width = 43
        Height = 13
        Caption = #1075'., '#1089'., '#1076'.'
      end
      object lbTownSmallWhat: TLabel
        Left = 87
        Top = 65
        Width = 43
        Height = 13
        Caption = #1075'., '#1089'., '#1076'.'
      end
      object edTownSmallNormal: TEdit
        Left = 134
        Top = 9
        Width = 213
        Height = 21
        MaxLength = 250
        TabOrder = 0
        OnChange = edFioChange
        OnKeyPress = edFioKeyPress
      end
      object edTownSmallWhere: TEdit
        Left = 134
        Top = 35
        Width = 213
        Height = 21
        MaxLength = 250
        TabOrder = 1
        OnChange = edFioChange
        OnKeyPress = edFioKeyPress
      end
      object edTownSmallWhat: TEdit
        Left = 134
        Top = 61
        Width = 213
        Height = 21
        MaxLength = 250
        TabOrder = 2
        OnChange = edFioChange
        OnKeyPress = edFioKeyPress
      end
    end
    object tsNameTown: TTabSheet
      Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
      ImageIndex = 2
      object lbNameTownNormal: TLabel
        Left = 62
        Top = 13
        Width = 59
        Height = 13
        Caption = #1050#1088#1072#1089#1085#1086#1103#1088#1089#1082
      end
      object lbNameTownWhere: TLabel
        Left = 56
        Top = 39
        Width = 65
        Height = 13
        Caption = #1050#1088#1072#1089#1085#1086#1103#1088#1089#1082#1077
      end
      object lbNameTownWhat: TLabel
        Left = 56
        Top = 65
        Width = 65
        Height = 13
        Caption = #1050#1088#1072#1089#1085#1086#1103#1088#1089#1082#1072
      end
      object edNameTownNormal: TEdit
        Left = 133
        Top = 9
        Width = 212
        Height = 21
        MaxLength = 250
        TabOrder = 0
        OnChange = edFioChange
        OnKeyPress = edFioKeyPress
      end
      object edNameTownWhere: TEdit
        Left = 133
        Top = 35
        Width = 212
        Height = 21
        MaxLength = 250
        TabOrder = 1
        OnChange = edFioChange
        OnKeyPress = edFioKeyPress
      end
      object edNameTownWhat: TEdit
        Left = 133
        Top = 61
        Width = 212
        Height = 21
        MaxLength = 250
        TabOrder = 2
        OnChange = edFioChange
        OnKeyPress = edFioKeyPress
      end
    end
  end
  object chbIsHelper: TCheckBox
    Left = 128
    Top = 119
    Width = 97
    Height = 17
    Caption = #1069#1090#1086' '#1087#1086#1084#1086#1097#1085#1080#1082
    TabOrder = 4
    OnClick = chbIsHelperClick
  end
  object edINN: TEdit
    Left = 128
    Top = 92
    Width = 224
    Height = 21
    MaxLength = 12
    TabOrder = 3
    OnChange = edFioChange
    OnKeyPress = edFioKeyPress
  end
  object EditPhone: TEdit
    Left = 128
    Top = 65
    Width = 224
    Height = 21
    MaxLength = 100
    TabOrder = 2
    OnChange = edFioChange
    OnKeyPress = edFioKeyPress
  end
end
