object fmNewOperation: TfmNewOperation
  Left = 222
  Top = 158
  Caption = #1053#1086#1074#1072#1103' '#1086#1087#1077#1088#1072#1094#1080#1103
  ClientHeight = 203
  ClientWidth = 592
  Color = clBtnFace
  Constraints.MinHeight = 230
  Constraints.MinWidth = 600
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnBottom: TPanel
    Left = 0
    Top = 162
    Width = 592
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      592
      41)
    object lbNumReestr: TLabel
      Left = 284
      Top = 15
      Width = 40
      Height = 13
      Alignment = taRightJustify
      Anchors = [akRight, akBottom]
      Caption = #1053#1086#1084#1077#1088':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Panel3: TPanel
      Left = 407
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
        Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100
        Caption = 'OK'
        Default = True
        TabOrder = 0
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333330000333333333333333333333333F33333333333
          00003333344333333333333333388F3333333333000033334224333333333333
          338338F3333333330000333422224333333333333833338F3333333300003342
          222224333333333383333338F3333333000034222A22224333333338F338F333
          8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
          33333338F83338F338F33333000033A33333A222433333338333338F338F3333
          0000333333333A222433333333333338F338F33300003333333333A222433333
          333333338F338F33000033333333333A222433333333333338F338F300003333
          33333333A222433333333333338F338F00003333333333333A22433333333333
          3338F38F000033333333333333A223333333333333338F830000333333333333
          333A333333333333333338330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
      end
      object bibCancel: TBitBtn
        Left = 104
        Top = 10
        Width = 75
        Height = 25
        Hint = #1054#1090#1084#1077#1085#1080#1090#1100
        Cancel = True
        Caption = #1054#1090#1084#1077#1085#1072
        TabOrder = 1
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333333333000033338833333333333333333F333333333333
          0000333911833333983333333388F333333F3333000033391118333911833333
          38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
          911118111118333338F3338F833338F3000033333911111111833333338F3338
          3333F8330000333333911111183333333338F333333F83330000333333311111
          8333333333338F3333383333000033333339111183333333333338F333833333
          00003333339111118333333333333833338F3333000033333911181118333333
          33338333338F333300003333911183911183333333383338F338F33300003333
          9118333911183333338F33838F338F33000033333913333391113333338FF833
          38F338F300003333333333333919333333388333338FFF830000333333333333
          3333333333333333333888330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
      end
    end
    object bibOtlogen: TBitBtn
      Left = 7
      Top = 10
      Width = 82
      Height = 25
      Hint = #1054#1090#1083#1086#1078#1080#1090#1100
      Cancel = True
      Caption = #1054#1090#1083#1086#1078#1080#1090#1100
      TabOrder = 0
      Visible = False
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333333FFFFF333333000033333388888833333333333F888888FFF333
        000033338811111188333333338833FFF388FF33000033381119999111833333
        38F338888F338FF30000339119933331111833338F388333383338F300003391
        13333381111833338F8F3333833F38F3000039118333381119118338F38F3338
        33F8F38F000039183333811193918338F8F333833F838F8F0000391833381119
        33918338F8F33833F8338F8F000039183381119333918338F8F3833F83338F8F
        000039183811193333918338F8F833F83333838F000039118111933339118338
        F3833F83333833830000339111193333391833338F33F8333FF838F300003391
        11833338111833338F338FFFF883F83300003339111888811183333338FF3888
        83FF83330000333399111111993333333388FFFFFF8833330000333333999999
        3333333333338888883333330000333333333333333333333333333333333333
        0000}
      NumGlyphs = 2
    end
    object edNumReestr: TEdit
      Left = 330
      Top = 12
      Width = 62
      Height = 21
      Hint = #1053#1086#1084#1077#1088' '#1074' '#1088#1077#1077#1089#1090#1088#1077
      Anchors = [akRight, akBottom]
      MaxLength = 9
      TabOrder = 2
    end
    object btNextNumReestr: TButton
      Left = 397
      Top = 12
      Width = 21
      Height = 21
      Hint = #1057#1083#1077#1076#1091#1102#1097#1080#1081' '#1085#1086#1084#1077#1088' '#1087#1086' '#1088#1077#1077#1089#1090#1088#1091
      Anchors = [akRight, akBottom]
      Caption = '<-'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 3
      OnClick = btNextNumReestrClick
    end
  end
  object pnTop: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 162
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object grbDoplnit: TGroupBox
      Left = 5
      Top = 5
      Width = 582
      Height = 148
      Align = alTop
      Caption = ' '#1053#1077#1086#1073#1093#1086#1076#1080#1084#1099#1077' '#1088#1077#1082#1074#1080#1079#1080#1090#1099' '
      TabOrder = 0
      object lbOperation: TLabel
        Left = 30
        Top = 119
        Width = 54
        Height = 13
        Caption = #1054#1087#1077#1088#1072#1094#1080#1103':'
      end
      object lbSumm: TLabel
        Left = 160
        Top = 24
        Width = 45
        Height = 13
        Caption = #1057'/'#1085#1086#1088#1084#1072':'
        ParentShowHint = False
        ShowHint = True
      end
      object lbSummPriv: TLabel
        Left = 288
        Top = 24
        Width = 41
        Height = 13
        Caption = #1057'/'#1092#1072#1082#1090':'
        ParentShowHint = False
        ShowHint = True
      end
      object lbCurReestr: TLabel
        Left = 44
        Top = 48
        Width = 39
        Height = 13
        Caption = #1056#1077#1077#1089#1090#1088':'
      end
      object lbNumLic: TLabel
        Left = 302
        Top = 48
        Width = 52
        Height = 13
        Caption = #1051#1080#1094#1077#1085#1079#1080#1103':'
      end
      object lbMotion: TLabel
        Left = 7
        Top = 66
        Width = 76
        Height = 26
        Alignment = taRightJustify
        Caption = #1053#1086#1090#1072#1088#1080#1072#1083#1100#1085#1086#1077' '#1076#1077#1081#1089#1090#1074#1080#1077':'
        WordWrap = True
      end
      object lbFio: TLabel
        Left = 7
        Top = 96
        Width = 74
        Height = 13
        Caption = #1060#1072#1084#1080#1083#1080#1103' '#1048'.'#1054'.:'
      end
      object lbCertificateDate: TLabel
        Left = 360
        Top = 119
        Width = 111
        Height = 13
        Caption = #1044#1072#1090#1072' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1103':'
      end
      object cbOperation: TComboBox
        Left = 91
        Top = 116
        Width = 260
        Height = 21
        ItemHeight = 0
        TabOrder = 0
        OnChange = cbOperationChange
      end
      object chbOnSogl: TCheckBox
        Left = 411
        Top = 23
        Width = 65
        Height = 17
        Hint = #1055#1086' '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1102
        Caption = #1055#1086' '#1089#1086#1075#1083'.'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 1
      end
      object cbCurReestr: TComboBox
        Left = 91
        Top = 45
        Width = 199
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 2
      end
      object cbNumLic: TComboBox
        Left = 363
        Top = 45
        Width = 111
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 3
      end
      object cmbMotion: TComboBox
        Left = 91
        Top = 69
        Width = 260
        Height = 21
        Style = csDropDownList
        ItemHeight = 0
        TabOrder = 4
      end
      object chbNoYear: TCheckBox
        Left = 363
        Top = 70
        Width = 113
        Height = 17
        Hint = 
          ' '#1044#1086#1075#1086#1074#1086#1088#1099' '#1074' '#1082#1086#1090#1086#1088#1099#1093' '#1089#1090#1086#1088#1086#1085#1086#1081' '#1080#1083#1080#13#10#1087#1088#1072#1074#1086#1086#1073#1083#1072#1076#1072#1090#1077#1083#1103#1084#1080' '#1079#1085#1072#1095#1072#1090#1089#1103' '#13#10#1085 +
          #1077#1089#1086#1074#1077#1088#1096#1077#1085#1085#1086#1083#1077#1090#1085#1080#1077
        Caption = #1053'/'#1083#1077#1090#1085#1080#1077
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
      end
      object cbFio: TComboBox
        Left = 91
        Top = 93
        Width = 260
        Height = 21
        ItemHeight = 0
        TabOrder = 6
        OnDropDown = cbFioDropDown
      end
      object chbDefect: TCheckBox
        Left = 363
        Top = 94
        Width = 113
        Height = 17
        Hint = 
          ' '#1044#1086#1075#1086#1074#1086#1088#1099' '#1079#1072' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1077#1084' '#1082#1086#1090#1086#1088#1099#1093#13#10#1086#1073#1088#1072#1090#1080#1083#1080#1089#1100' '#1075#1088'-'#1085#1077' '#1080#1084#1077#1102#1097#1080#1077' '#1092#1080 +
          #1079#1080#1095#1077#1089#1082#1080#1077' '#1085#1077#1076#1086#1089#1090#1072#1090#1082#1080
        Caption = #1060#1080#1079'.'#1085#1077#1076#1086#1089#1090#1072#1090#1082#1080
        ParentShowHint = False
        ShowHint = True
        TabOrder = 7
      end
      object dtpCertificateDate: TDateTimePicker
        Left = 477
        Top = 115
        Width = 94
        Height = 21
        Hint = #1044#1072#1090#1072' '#1091#1076#1086#1089#1090#1086#1074#1077#1088#1077#1085#1080#1103' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
        Date = 37664.502589340300000000
        Time = 37664.502589340300000000
        ParentShowHint = False
        ShowHint = True
        TabOrder = 8
      end
    end
  end
end
