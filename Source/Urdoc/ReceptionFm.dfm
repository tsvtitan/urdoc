object ReceptionForm: TReceptionForm
  Left = 470
  Top = 301
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1054#1073#1085#1086#1074#1083#1077#1085#1080#1077' '#1085#1086#1090#1072#1088#1080#1091#1089#1086#1074' '#1080' '#1085#1086#1090#1072#1088#1080#1072#1083#1100#1085#1099#1093' '#1087#1072#1083#1072#1090
  ClientHeight = 298
  ClientWidth = 392
  Color = clBtnFace
  Constraints.MinHeight = 325
  Constraints.MinWidth = 400
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    392
    298)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelSite: TLabel
    Left = 45
    Top = 13
    Width = 29
    Height = 13
    Alignment = taRightJustify
    Caption = #1057#1072#1081#1090':'
  end
  object LabelRefresh: TLabel
    Left = 24
    Top = 37
    Width = 50
    Height = 13
    Alignment = taRightJustify
    Caption = #1055#1088#1086#1075#1088#1077#1089#1089':'
  end
  object LabelCaptionStatus: TLabel
    Left = 34
    Top = 59
    Width = 40
    Height = 13
    Caption = #1057#1090#1072#1090#1091#1089':'
  end
  object LabelStatus: TLabel
    Left = 80
    Top = 59
    Width = 304
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    EllipsisPosition = epEndEllipsis
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    ParentFont = False
    ExplicitWidth = 297
  end
  object pnBottom: TPanel
    Left = 0
    Top = 262
    Width = 392
    Height = 36
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 4
    DesignSize = (
      392
      36)
    object bibClose: TBitBtn
      Left = 310
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
    end
  end
  object ComboBoxSite: TComboBox
    Left = 80
    Top = 10
    Width = 209
    Height = 21
    Style = csDropDownList
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 0
    OnChange = ComboBoxSiteChange
    Items.Strings = (
      'http://www.notary.ru')
  end
  object ButtonStart: TButton
    Left = 295
    Top = 10
    Width = 89
    Height = 21
    Anchors = [akTop, akRight]
    Caption = #1057#1090#1072#1088#1090
    Enabled = False
    TabOrder = 1
    OnClick = ButtonStartClick
  end
  object ProgressBarRefresh: TProgressBar
    Left = 80
    Top = 37
    Width = 304
    Height = 16
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
  end
  object Memo: TMemo
    Left = 8
    Top = 78
    Width = 376
    Height = 178
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 3
    WordWrap = False
  end
end
