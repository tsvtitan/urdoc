object fmEditHereditaryDocum: TfmEditHereditaryDocum
  Left = 446
  Top = 154
  BorderStyle = bsDialog
  Caption = 'fmEditHereditaryDocum'
  ClientHeight = 164
  ClientWidth = 377
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
    Left = 15
    Top = 16
    Width = 77
    Height = 13
    Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077':'
  end
  object lbNum: TLabel
    Left = 57
    Top = 42
    Width = 35
    Height = 13
    Caption = #1053#1086#1084#1077#1088':'
  end
  object lbPlace: TLabel
    Left = 15
    Top = 91
    Width = 120
    Height = 26
    Alignment = taRightJustify
    Caption = #1059#1095#1088#1077#1078#1076#1077#1085#1080#1077' '#1074#1099#1076#1072#1074#1096#1077#1077' '#1076#1086#1082#1091#1084#1077#1085#1090':'
    WordWrap = True
  end
  object lbDateDoc: TLabel
    Left = 92
    Top = 70
    Width = 130
    Height = 13
    Caption = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072':'
  end
  object edName: TEdit
    Left = 103
    Top = 12
    Width = 225
    Height = 21
    MaxLength = 150
    TabOrder = 0
    OnChange = edNameChange
    OnKeyPress = edNameKeyPress
  end
  object edNum: TEdit
    Left = 103
    Top = 38
    Width = 225
    Height = 21
    MaxLength = 20
    TabOrder = 1
    OnChange = edNameChange
    OnKeyPress = edNameKeyPress
  end
  object pnBottom: TPanel
    Left = 0
    Top = 124
    Width = 377
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    object Panel3: TPanel
      Left = 192
      Top = 0
      Width = 185
      Height = 40
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object bibOk: TBitBtn
        Left = 21
        Top = 9
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        TabOrder = 0
        NumGlyphs = 2
      end
      object bibCancel: TBitBtn
        Left = 104
        Top = 9
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
  object edPlace: TEdit
    Left = 144
    Top = 95
    Width = 224
    Height = 21
    MaxLength = 255
    TabOrder = 3
    OnChange = edNameChange
    OnKeyPress = edNameKeyPress
  end
  object dtpDateDoc: TDateTimePicker
    Left = 226
    Top = 66
    Width = 102
    Height = 21
    Date = 37524.538336192100000000
    Time = 37524.538336192100000000
    ShowCheckbox = True
    Checked = False
    TabOrder = 2
    OnChange = dtpDateDocChange
  end
end
