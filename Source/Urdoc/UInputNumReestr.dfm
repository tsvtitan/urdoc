object fmInputNumber: TfmInputNumber
  Left = 392
  Top = 284
  BorderStyle = bsDialog
  Caption = #1042#1074#1077#1076#1080#1090#1077' '#1085#1086#1084#1077#1088
  ClientHeight = 81
  ClientWidth = 212
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
  object Label1: TLabel
    Left = 8
    Top = 15
    Width = 88
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1074' '#1088#1077#1077#1089#1090#1088#1077':'
  end
  object pnBottom: TPanel
    Left = 0
    Top = 40
    Width = 212
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      Left = 27
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
  object edNumber: TEdit
    Left = 112
    Top = 12
    Width = 89
    Height = 21
    TabOrder = 0
    OnKeyPress = edNumberKeyPress
  end
end
