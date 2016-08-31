object fmEditSumm: TfmEditSumm
  Left = 424
  Top = 215
  BorderStyle = bsDialog
  Caption = 'fmEditSumm'
  ClientHeight = 273
  ClientWidth = 236
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pnBottom: TPanel
    Left = 0
    Top = 232
    Width = 236
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      Left = 51
      Top = 0
      Width = 185
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
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
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 236
    Height = 232
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object grbSumm: TGroupBox
      Left = 5
      Top = 5
      Width = 226
      Height = 222
      Align = alClient
      Caption = ' '#1042#1074#1077#1076#1080#1090#1077' '#1089#1091#1084#1084#1091' '
      TabOrder = 0
      object lbSumm: TLabel
        Left = 16
        Top = 27
        Width = 35
        Height = 13
        Caption = #1057#1091#1084#1084#1072':'
      end
      object btMore: TButton
        Left = 119
        Top = 54
        Width = 75
        Height = 20
        Caption = #1041#1086#1083#1100#1096#1077
        TabOrder = 0
        OnClick = btMoreClick
      end
      object grbCount: TGroupBox
        Left = 7
        Top = 76
        Width = 212
        Height = 139
        Caption = ' '#1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1082#1086#1087#1080#1081' '
        TabOrder = 1
        Visible = False
        object lbIntervalNumReestrFrom: TLabel
          Left = 13
          Top = 65
          Width = 48
          Height = 13
          Caption = #1089' '#1085#1086#1084#1077#1088#1072':'
          Enabled = False
        end
        object lbIntervalNumReestrTo: TLabel
          Left = 128
          Top = 65
          Width = 16
          Height = 13
          Caption = #1087#1086':'
          Enabled = False
        end
        object lbIntervalFrom: TLabel
          Left = 13
          Top = 110
          Width = 48
          Height = 13
          Caption = #1089' '#1085#1086#1084#1077#1088#1072':'
          Enabled = False
        end
        object lbIntervalTo: TLabel
          Left = 128
          Top = 110
          Width = 38
          Height = 13
          Caption = #1082#1086#1083'-'#1074#1086':'
          Enabled = False
        end
        object rbCountOne: TRadioButton
          Left = 11
          Top = 21
          Width = 86
          Height = 17
          Caption = #1054#1076#1085#1091' '#1082#1086#1087#1080#1102
          Checked = True
          TabOrder = 0
          TabStop = True
          OnClick = rbCountOneClick
        end
        object rbCountIntervalNumReestr: TRadioButton
          Left = 11
          Top = 40
          Width = 182
          Height = 17
          Caption = #1048#1085#1090#1077#1088#1074#1072#1083' '#1085#1086#1084#1077#1088#1086#1074' '#1087#1086' '#1088#1077#1077#1089#1090#1088#1091
          TabOrder = 1
          OnClick = rbCountOneClick
        end
        object edIntervalNumReestrFrom: TEdit
          Left = 69
          Top = 62
          Width = 52
          Height = 21
          Color = clBtnFace
          Enabled = False
          MaxLength = 6
          TabOrder = 2
          Text = '0'
          OnKeyPress = edIntervalNumReestrFromKeyPress
        end
        object edIntervalNumReestrTo: TEdit
          Left = 149
          Top = 62
          Width = 52
          Height = 21
          Color = clBtnFace
          Enabled = False
          MaxLength = 6
          TabOrder = 3
          Text = '0'
          OnKeyPress = edIntervalNumReestrFromKeyPress
        end
        object rbCountInterval: TRadioButton
          Left = 11
          Top = 85
          Width = 182
          Height = 17
          Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1082#1086#1087#1080#1081' '#1089' '#1085#1086#1084#1077#1088#1072
          TabOrder = 4
          OnClick = rbCountOneClick
        end
        object edIntervalFrom: TEdit
          Left = 69
          Top = 107
          Width = 52
          Height = 21
          Color = clBtnFace
          Enabled = False
          MaxLength = 6
          TabOrder = 5
          Text = '0'
          OnKeyPress = edIntervalNumReestrFromKeyPress
        end
        object edIntervalTo: TEdit
          Left = 171
          Top = 107
          Width = 30
          Height = 21
          Color = clBtnFace
          Enabled = False
          MaxLength = 3
          TabOrder = 6
          Text = '0'
          OnKeyPress = edIntervalNumReestrFromKeyPress
        end
      end
    end
  end
end
