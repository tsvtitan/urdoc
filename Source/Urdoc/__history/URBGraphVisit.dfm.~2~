object fmGraphVisit: TfmGraphVisit
  Left = 225
  Top = 190
  Caption = #1043#1088#1072#1092#1080#1082' '#1087#1086#1089#1077#1097#1077#1085#1080#1081
  ClientHeight = 253
  ClientWidth = 612
  Color = clBtnFace
  Constraints.MinHeight = 280
  Constraints.MinWidth = 470
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnBut: TPanel
    Left = 523
    Top = 0
    Width = 89
    Height = 253
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object pnModal: TPanel
      Left = 0
      Top = 101
      Width = 89
      Height = 152
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      DesignSize = (
        89
        152)
      object bibOk: TBitBtn
        Left = 8
        Top = 90
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Caption = 'OK'
        Default = True
        TabOrder = 2
        Visible = False
        NumGlyphs = 2
      end
      object bibClose: TBitBtn
        Left = 8
        Top = 122
        Width = 75
        Height = 25
        Anchors = [akRight, akBottom]
        Cancel = True
        Caption = #1047#1072#1082#1088#1099#1090#1100
        ModalResult = 2
        TabOrder = 3
        OnClick = bibCloseClick
        NumGlyphs = 2
      end
      object bibFilter: TBitBtn
        Left = 8
        Top = 10
        Width = 75
        Height = 25
        Hint = #1060#1080#1083#1100#1090#1088' (F6)'
        Caption = #1060#1080#1083#1100#1090#1088
        TabOrder = 0
        OnClick = bibFilterClick
        OnKeyDown = FormKeyDown
      end
      object bibPrint: TBitBtn
        Left = 8
        Top = 42
        Width = 75
        Height = 25
        Hint = #1055#1077#1095#1072#1090#1100
        Caption = #1055#1077#1095#1072#1090#1100
        TabOrder = 1
        OnClick = bibPrintClick
        OnKeyDown = FormKeyDown
      end
    end
    object pnSQL: TPanel
      Left = 0
      Top = 0
      Width = 89
      Height = 101
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 1
      object bibAdd: TBitBtn
        Left = 8
        Top = 7
        Width = 75
        Height = 25
        Hint = #1044#1086#1073#1072#1074#1080#1090#1100' (F2)'
        Caption = #1044#1086#1073#1072#1074#1080#1090#1100
        TabOrder = 0
        OnClick = bibAddClick
        OnKeyDown = FormKeyDown
      end
      object bibChange: TBitBtn
        Left = 8
        Top = 39
        Width = 75
        Height = 25
        Hint = #1048#1079#1084#1077#1085#1080#1090#1100' (F3)'
        Caption = #1048#1079#1084#1077#1085#1080#1090#1100
        TabOrder = 1
        OnClick = bibChangeClick
        OnKeyDown = FormKeyDown
      end
      object bibDel: TBitBtn
        Left = 8
        Top = 71
        Width = 75
        Height = 25
        Hint = #1059#1076#1072#1083#1080#1090#1100' (F4)'
        Caption = #1059#1076#1072#1083#1080#1090#1100
        TabOrder = 2
        OnClick = bibDelClick
        OnKeyDown = FormKeyDown
      end
    end
  end
  object pnGrid: TPanel
    Left = 0
    Top = 0
    Width = 523
    Height = 253
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object pnFind: TPanel
      Left = 0
      Top = 0
      Width = 523
      Height = 29
      Align = alTop
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 18
        Top = 8
        Width = 35
        Height = 13
        Caption = #1053#1072#1081#1090#1080':'
      end
      object edSearch: TEdit
        Left = 64
        Top = 5
        Width = 161
        Height = 21
        TabOrder = 0
        OnKeyDown = FormKeyDown
        OnKeyUp = edSearchKeyUp
      end
    end
    object pnBottom: TPanel
      Left = 0
      Top = 228
      Width = 523
      Height = 25
      Align = alBottom
      AutoSize = True
      BevelOuter = bvNone
      TabOrder = 1
      object lbCount: TLabel
        Left = 163
        Top = 6
        Width = 88
        Height = 13
        Caption = #1042#1089#1077#1075#1086' '#1074#1099#1073#1088#1072#1085#1086': 0'
      end
      object DBNav: TDBNavigator
        Left = 0
        Top = 0
        Width = 148
        Height = 25
        DataSource = ds
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast]
        Flat = True
        Hints.Strings = (
          #1055#1077#1088#1074#1072#1103' '#1079#1072#1087#1080#1089#1100
          #1055#1088#1077#1076#1099#1076#1091#1097#1072#1103' '#1079#1072#1087#1080#1089#1100
          #1057#1083#1077#1076#1091#1102#1097#1072#1103' '#1079#1072#1087#1080#1089#1100
          #1055#1086#1089#1083#1077#1076#1085#1103#1103' '#1079#1072#1087#1080#1089#1100
          #1042#1089#1090#1072#1074#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
          #1059#1076#1072#1083#1080#1090#1100' '#1079#1072#1087#1080#1089#1100
          #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1079#1072#1087#1080#1089#1100
          #1055#1086#1090#1074#1077#1088#1076#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
          #1054#1090#1084#1077#1085#1080#1090#1100' '#1088#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1085#1080#1077
          #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077)
        TabOrder = 0
      end
    end
  end
  object ds: TDataSource
    DataSet = Mainqr
    Left = 96
    Top = 112
  end
  object Mainqr: TIBQuery
    AfterOpen = MainqrAfterOpen
    Left = 136
    Top = 112
  end
  object tran: TIBTransaction
    Left = 184
    Top = 104
  end
end
