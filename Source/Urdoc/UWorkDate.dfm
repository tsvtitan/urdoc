object fmWorkDate: TfmWorkDate
  Left = 284
  Top = 245
  BorderStyle = bsDialog
  Caption = #1042#1074#1086#1076' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 102
  ClientWidth = 211
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
  object pnBottom: TPanel
    Left = 0
    Top = 64
    Width = 211
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      Left = 26
      Top = 0
      Width = 185
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object bibOk: TBitBtn
        Left = 21
        Top = 7
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
        Top = 7
        Width = 75
        Height = 25
        Cancel = True
        Caption = #1054#1090#1084#1077#1085#1072
        ModalResult = 2
        TabOrder = 1
        OnClick = bibCancelClick
        NumGlyphs = 2
      end
    end
  end
  object pnWoryear: TPanel
    Left = 0
    Top = 0
    Width = 211
    Height = 64
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object grbWorkYear: TGroupBox
      Left = 5
      Top = 5
      Width = 201
      Height = 54
      Align = alClient
      Caption = ' '#1042#1074#1077#1076#1080#1090#1077' '#1088#1072#1073#1086#1095#1091#1102' '#1076#1072#1090#1091'  '
      TabOrder = 0
      object lbworkYear: TLabel
        Left = 16
        Top = 24
        Width = 74
        Height = 13
        Caption = #1056#1072#1073#1086#1095#1072#1103' '#1076#1072#1090#1072':'
      end
      object dtpWorkdate: TDateTimePicker
        Left = 96
        Top = 21
        Width = 91
        Height = 21
        Date = 37262.615149803200000000
        Time = 37262.615149803200000000
        TabOrder = 0
      end
    end
  end
end
