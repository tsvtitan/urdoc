object fmEnterPeriod: TfmEnterPeriod
  Left = 408
  Top = 159
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1087#1077#1088#1080#1086#1076#1072
  ClientHeight = 203
  ClientWidth = 256
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
  object lbBegin: TLabel
    Left = 96
    Top = 114
    Width = 9
    Height = 13
    Caption = 'c:'
  end
  object lbEnd: TLabel
    Left = 90
    Top = 138
    Width = 16
    Height = 13
    Caption = #1087#1086':'
  end
  object dtpBegin: TDateTimePicker
    Left = 112
    Top = 110
    Width = 133
    Height = 21
    Date = 36907.446560219900000000
    Time = 36907.446560219900000000
    DateFormat = dfLong
    TabOrder = 9
  end
  object Panel1: TPanel
    Left = 0
    Top = 159
    Width = 256
    Height = 44
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 11
    DesignSize = (
      256
      44)
    object bibOk: TBitBtn
      Left = 92
      Top = 12
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'OK'
      Default = True
      TabOrder = 0
      OnClick = bibOkClick
      NumGlyphs = 2
    end
    object bibCancel: TBitBtn
      Left = 174
      Top = 12
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
      NumGlyphs = 2
    end
  end
  object dtpEnd: TDateTimePicker
    Left = 112
    Top = 134
    Width = 133
    Height = 21
    Date = 36907.446560219900000000
    Time = 36907.446560219900000000
    DateFormat = dfLong
    TabOrder = 10
  end
  object rbKvartal: TRadioButton
    Left = 8
    Top = 40
    Width = 76
    Height = 17
    Caption = #1050#1074#1072#1088#1090#1072#1083':'
    TabOrder = 0
    OnClick = rbKvartalClick
  end
  object rbMonth: TRadioButton
    Left = 8
    Top = 64
    Width = 76
    Height = 17
    Caption = #1052#1077#1089#1103#1094':'
    TabOrder = 1
    OnClick = rbKvartalClick
  end
  object rbDay: TRadioButton
    Left = 8
    Top = 88
    Width = 76
    Height = 17
    Caption = #1044#1077#1085#1100':'
    TabOrder = 2
    OnClick = rbKvartalClick
  end
  object rbInterval: TRadioButton
    Left = 8
    Top = 112
    Width = 76
    Height = 17
    Caption = #1048#1085#1090#1077#1088#1074#1072#1083':'
    TabOrder = 3
    OnClick = rbKvartalClick
  end
  object edKvartal: TEdit
    Left = 112
    Top = 38
    Width = 117
    Height = 21
    ReadOnly = True
    TabOrder = 4
    Text = '0'
    OnChange = edKvartalChange
  end
  object udKvartal: TUpDown
    Left = 229
    Top = 38
    Width = 15
    Height = 21
    Associate = edKvartal
    Min = -4
    Max = 4
    TabOrder = 5
    OnChangingEx = udKvartalChangingEx
  end
  object edMonth: TEdit
    Left = 112
    Top = 62
    Width = 117
    Height = 21
    ReadOnly = True
    TabOrder = 6
    Text = '0'
    OnChange = edMonthChange
  end
  object udMonth: TUpDown
    Left = 229
    Top = 62
    Width = 15
    Height = 21
    Associate = edMonth
    Min = -4
    Max = 4
    TabOrder = 7
    OnChangingEx = udMonthChangingEx
  end
  object dtpDay: TDateTimePicker
    Left = 112
    Top = 86
    Width = 133
    Height = 21
    Date = 36907.446560219900000000
    Time = 36907.446560219900000000
    DateFormat = dfLong
    TabOrder = 8
  end
  object rbYear: TRadioButton
    Left = 8
    Top = 16
    Width = 76
    Height = 17
    Caption = #1043#1086#1076':'
    Checked = True
    TabOrder = 12
    TabStop = True
    OnClick = rbKvartalClick
  end
  object edYear: TEdit
    Left = 112
    Top = 14
    Width = 117
    Height = 21
    ReadOnly = True
    TabOrder = 13
    Text = '2001'
    OnChange = edKvartalChange
  end
  object udYear: TUpDown
    Left = 229
    Top = 14
    Width = 16
    Height = 21
    Associate = edYear
    Min = 1950
    Max = 2050
    Position = 2001
    TabOrder = 14
    Thousands = False
    OnChangingEx = udYearChangingEx
  end
end
