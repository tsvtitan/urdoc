object fmSelectNoarius: TfmSelectNoarius
  Left = 366
  Top = 291
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1085#1086#1090#1072#1088#1080#1091#1089#1072
  ClientHeight = 132
  ClientWidth = 299
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
  object lbNotarius: TLabel
    Left = 9
    Top = 46
    Width = 61
    Height = 13
    Caption = #1053#1086#1090#1072#1088#1080#1091#1089':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object pnBottom: TPanel
    Left = 0
    Top = 94
    Width = 299
    Height = 38
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      Left = 114
      Top = 0
      Width = 185
      Height = 38
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        185
        38)
      object bibOk: TBitBtn
        Left = 24
        Top = 8
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
        Left = 105
        Top = 8
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
  end
  object cmbNotarius: TComboBox
    Left = 8
    Top = 65
    Width = 285
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 0
  end
  object meInfo: TMemo
    Left = 5
    Top = 8
    Width = 290
    Height = 34
    Alignment = taCenter
    BorderStyle = bsNone
    Color = clBtnFace
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    OnKeyDown = meInfoKeyDown
  end
end
