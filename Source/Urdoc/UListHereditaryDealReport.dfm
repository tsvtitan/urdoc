object fmListHereditaryDeal: TfmListHereditaryDeal
  Left = 527
  Top = 201
  BorderStyle = bsDialog
  Caption = #1054#1087#1080#1089#1100' '#1085#1072#1089#1083#1077#1076#1089#1090#1074#1077#1085#1085#1099#1093' '#1076#1077#1083
  ClientHeight = 164
  ClientWidth = 310
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbUserName: TLabel
    Left = 8
    Top = 298
    Width = 76
    Height = 13
    Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
    Visible = False
  end
  object lbTypeReestr: TLabel
    Left = 39
    Top = 13
    Width = 39
    Height = 13
    Caption = #1056#1077#1077#1089#1090#1088':'
  end
  object lbFromNumber: TLabel
    Left = 28
    Top = 43
    Width = 50
    Height = 13
    Caption = #1057' '#1085#1086#1084#1077#1088#1072':'
  end
  object lbToNumber: TLabel
    Left = 188
    Top = 44
    Width = 16
    Height = 13
    Caption = #1087#1086':'
  end
  object bibUsername: TBitBtn
    Left = 258
    Top = 294
    Width = 22
    Height = 22
    Caption = '...'
    TabOrder = 6
    Visible = False
    OnClick = bibUsernameClick
  end
  object edUserName: TEdit
    Left = 93
    Top = 295
    Width = 165
    Height = 21
    TabOrder = 5
    Visible = False
    OnChange = edFioChange
    OnKeyPress = edUserNameKeyPress
  end
  object pnBottom: TPanel
    Left = 0
    Top = 123
    Width = 310
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 7
    object Panel3: TPanel
      Left = 125
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
        OnClick = bibOkClick
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
  object edTypeReestr: TEdit
    Left = 91
    Top = 10
    Width = 189
    Height = 21
    TabOrder = 0
    OnChange = edFioChange
    OnKeyDown = edTypeReestrKeyDown
    OnKeyPress = edUserNameKeyPress
  end
  object bibTypeReestr: TBitBtn
    Left = 280
    Top = 10
    Width = 22
    Height = 22
    Caption = '...'
    TabOrder = 1
    OnClick = bibTypeReestrClick
  end
  object edFromNumber: TEdit
    Left = 91
    Top = 40
    Width = 84
    Height = 21
    TabOrder = 2
  end
  object edToNumber: TEdit
    Left = 214
    Top = 40
    Width = 87
    Height = 21
    TabOrder = 3
  end
  object grbCert: TGroupBox
    Left = 9
    Top = 66
    Width = 293
    Height = 50
    Caption = ' '#1044#1072#1090#1072' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1103' '
    TabOrder = 4
    object Label3: TLabel
      Left = 15
      Top = 23
      Width = 9
      Height = 13
      Caption = 'c:'
    end
    object Label4: TLabel
      Left = 140
      Top = 23
      Width = 16
      Height = 13
      Caption = #1087#1086':'
    end
    object dtpCertFrom: TDateTimePicker
      Left = 33
      Top = 19
      Width = 95
      Height = 21
      Date = 37044.591104398110000000
      Time = 37044.591104398110000000
      ShowCheckbox = True
      Checked = False
      TabOrder = 0
    end
    object dtpCertTo: TDateTimePicker
      Left = 166
      Top = 19
      Width = 95
      Height = 21
      Date = 37044.591104398110000000
      Time = 37044.591104398110000000
      ShowCheckbox = True
      Checked = False
      TabOrder = 1
    end
    object bibCert: TBitBtn
      Left = 261
      Top = 19
      Width = 22
      Height = 22
      Caption = '...'
      TabOrder = 2
      OnClick = bibCertClick
    end
  end
end
