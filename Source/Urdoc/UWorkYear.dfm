object fmWorkYear: TfmWorkYear
  Left = 284
  Top = 245
  BorderStyle = bsDialog
  Caption = #1042#1074#1074#1086#1076' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 102
  ClientWidth = 216
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
    Width = 216
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      Left = 31
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
    Width = 216
    Height = 64
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object grbWorkYear: TGroupBox
      Left = 5
      Top = 5
      Width = 206
      Height = 54
      Align = alClient
      Caption = ' '#1042#1074#1077#1076#1080#1090#1077' '#1088#1072#1073#1086#1095#1080#1081' '#1075#1086#1076' '
      TabOrder = 0
      object lbworkYear: TLabel
        Left = 16
        Top = 24
        Width = 67
        Height = 13
        Caption = #1056#1072#1073#1086#1095#1080#1081' '#1075#1086#1076':'
      end
      object edWorkDate: TEdit
        Left = 90
        Top = 22
        Width = 89
        Height = 21
        ReadOnly = True
        TabOrder = 0
        Text = '2001'
      end
      object udWorkYear: TUpDown
        Left = 179
        Top = 22
        Width = 16
        Height = 21
        Associate = edWorkDate
        Min = 1995
        Max = 2050
        Position = 2001
        TabOrder = 1
        Thousands = False
      end
    end
  end
end
