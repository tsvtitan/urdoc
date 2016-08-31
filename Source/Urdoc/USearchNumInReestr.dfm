object fmSearchNumInReestr: TfmSearchNumInReestr
  Left = 412
  Top = 175
  Caption = #1055#1088#1086#1087#1091#1097#1077#1085#1085#1099#1077' '#1085#1086#1084#1077#1088#1072' '#1087#1086' '#1088#1077#1077#1089#1090#1088#1091
  ClientHeight = 247
  ClientWidth = 446
  Color = clBtnFace
  Constraints.MinHeight = 273
  Constraints.MinWidth = 454
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnBottom: TPanel
    Left = 0
    Top = 211
    Width = 446
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitWidth = 453
    DesignSize = (
      446
      36)
    object lbCount: TLabel
      Left = 11
      Top = 13
      Width = 87
      Height = 13
      Anchors = [akLeft, akBottom]
      Caption = #1042#1089#1077#1075#1086' '#1085#1072#1081#1076#1077#1085#1086': 0'
    end
    object bibClose: TBitBtn
      Left = 364
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = #1047#1072#1082#1088#1099#1090#1100
      ModalResult = 2
      TabOrder = 0
      OnClick = bibCloseClick
      NumGlyphs = 2
      ExplicitLeft = 371
    end
  end
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 446
    Height = 64
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lbTypeReestr: TLabel
      Left = 16
      Top = 15
      Width = 39
      Height = 13
      Caption = #1056#1077#1077#1089#1090#1088':'
    end
    object lbDateAccept: TLabel
      Left = 64
      Top = 42
      Width = 119
      Height = 13
      Alignment = taRightJustify
      Caption = #1044#1072#1090#1072' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1103' '#1089':'
    end
    object lbDateTo: TLabel
      Left = 295
      Top = 42
      Width = 16
      Height = 13
      Alignment = taRightJustify
      Caption = #1087#1086':'
    end
    object cbTypeReestr: TComboBox
      Left = 64
      Top = 11
      Width = 297
      Height = 21
      Style = csDropDownList
      ItemHeight = 13
      TabOrder = 0
      OnChange = cbTypeReestrChange
    end
    object bibSearch: TBitBtn
      Left = 367
      Top = 11
      Width = 73
      Height = 22
      Caption = #1055#1086#1080#1089#1082
      TabOrder = 1
      OnClick = bibSearchClick
    end
    object dtpDateFrom: TDateTimePicker
      Left = 189
      Top = 38
      Width = 95
      Height = 21
      Date = 37072.000000000000000000
      Time = 37072.000000000000000000
      ShowCheckbox = True
      TabOrder = 2
    end
    object dtpDateTo: TDateTimePicker
      Left = 319
      Top = 38
      Width = 95
      Height = 21
      Date = 37072.000000000000000000
      Time = 37072.000000000000000000
      ShowCheckbox = True
      TabOrder = 3
    end
    object bibPeriod: TBitBtn
      Left = 419
      Top = 38
      Width = 21
      Height = 21
      Hint = #1042#1099#1073#1088#1072#1090#1100' '#1087#1077#1088#1080#1086#1076
      Caption = '...'
      TabOrder = 4
      OnClick = bibPeriodClick
    end
  end
  object pnMemo: TPanel
    Left = 0
    Top = 64
    Width = 446
    Height = 147
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 1
    ExplicitTop = 68
    ExplicitWidth = 453
    ExplicitHeight = 143
    object mmSearch: TMemo
      Left = 5
      Top = 5
      Width = 436
      Height = 137
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
      ExplicitHeight = 133
    end
  end
end
