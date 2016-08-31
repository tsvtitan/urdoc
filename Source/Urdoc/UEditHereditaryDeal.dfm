object fmEditHereditaryDeal: TfmEditHereditaryDeal
  Left = 261
  Top = 162
  BorderStyle = bsDialog
  Caption = 'fmEditHereditaryDeal'
  ClientHeight = 363
  ClientWidth = 487
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
  object lbFio: TLabel
    Left = 11
    Top = 38
    Width = 74
    Height = 13
    Caption = #1060#1072#1084#1080#1083#1080#1103' '#1048'.'#1054'.:'
  end
  object lbNumDeal: TLabel
    Left = 24
    Top = 12
    Width = 63
    Height = 13
    Caption = #1053#1086#1084#1077#1088' '#1076#1077#1083#1072':'
  end
  object lbDateDeal: TLabel
    Left = 251
    Top = 11
    Width = 16
    Height = 13
    Caption = #1086#1090':'
  end
  object lbDeathDate: TLabel
    Left = 313
    Top = 38
    Width = 68
    Height = 13
    Caption = #1044#1072#1090#1072' '#1089#1084#1077#1088#1090#1080':'
  end
  object lbNote: TLabel
    Left = 20
    Top = 65
    Width = 65
    Height = 13
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1103':'
  end
  object edFio: TEdit
    Left = 95
    Top = 35
    Width = 210
    Height = 21
    MaxLength = 50
    TabOrder = 2
    OnChange = edFioChange
    OnKeyPress = edFioKeyPress
  end
  object pnBottom: TPanel
    Left = 0
    Top = 309
    Width = 487
    Height = 54
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 6
    object Panel3: TPanel
      Left = 302
      Top = 0
      Width = 185
      Height = 54
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      object bibOk: TBitBtn
        Left = 21
        Top = 23
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        TabOrder = 0
        NumGlyphs = 2
      end
      object bibCancel: TBitBtn
        Left = 104
        Top = 23
        Width = 75
        Height = 25
        Cancel = True
        Caption = #1054#1090#1084#1077#1085#1072
        ModalResult = 2
        TabOrder = 1
        NumGlyphs = 2
      end
    end
    object cbInString: TCheckBox
      Left = 6
      Top = 3
      Width = 186
      Height = 17
      Caption = #1060#1080#1083#1100#1090#1088' '#1087#1086' '#1074#1093#1086#1078#1076#1077#1085#1080#1102' '#1089#1090#1088#1086#1082#1080
      TabOrder = 0
      Visible = False
    end
    object bibClear: TBitBtn
      Left = 7
      Top = 23
      Width = 75
      Height = 25
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      TabOrder = 1
      OnClick = bibClearClick
      NumGlyphs = 2
    end
  end
  object pc: TPageControl
    Left = 0
    Top = 130
    Width = 487
    Height = 179
    ActivePage = tsDocum
    Align = alBottom
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 5
    object tsDocum: TTabSheet
      Caption = #1048#1089#1090#1088#1077#1073#1086#1074#1072#1085#1085#1099#1077' '#1086#1090' '#1085#1072#1089#1083#1077#1076#1085#1080#1082#1072
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnDocumLeft: TPanel
        Left = 401
        Top = 0
        Width = 78
        Height = 151
        Align = alRight
        BevelOuter = bvNone
        TabOrder = 1
        DesignSize = (
          78
          151)
        object btDocumAdd: TButton
          Left = 3
          Top = 6
          Width = 70
          Height = 23
          Anchors = [akTop, akRight]
          Caption = #1044#1086#1073#1072#1074#1080#1090#1100
          TabOrder = 0
          OnClick = btDocumAddClick
        end
        object btDocumChange: TButton
          Left = 3
          Top = 34
          Width = 70
          Height = 23
          Anchors = [akTop, akRight]
          Caption = #1048#1079#1084#1077#1085#1080#1090#1100
          TabOrder = 1
          OnClick = btDocumChangeClick
        end
        object btDocumDel: TButton
          Left = 3
          Top = 62
          Width = 70
          Height = 23
          Anchors = [akTop, akRight]
          Caption = #1059#1076#1072#1083#1080#1090#1100
          TabOrder = 2
          OnClick = btDocumDelClick
        end
      end
      object pnGridDocum: TPanel
        Left = 0
        Top = 0
        Width = 401
        Height = 151
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
      end
    end
    object tsReestr: TTabSheet
      Caption = #1055#1088#1086#1093#1086#1076#1103#1097#1080#1077' '#1087#1086' '#1088#1077#1077#1089#1090#1088#1091
      ImageIndex = 1
      TabVisible = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object pnGridReestr: TPanel
        Left = 0
        Top = 0
        Width = 479
        Height = 151
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
      end
    end
  end
  object edNumDeal: TEdit
    Left = 95
    Top = 8
    Width = 145
    Height = 21
    MaxLength = 20
    TabOrder = 0
    OnChange = edFioChange
    OnKeyPress = edFioKeyPress
  end
  object dtpDateDeal: TDateTimePicker
    Left = 275
    Top = 8
    Width = 89
    Height = 21
    Date = 37524.538336192100000000
    Time = 37524.538336192100000000
    TabOrder = 1
    OnChange = dtpDateDealChange
  end
  object dtpDeathDate: TDateTimePicker
    Left = 390
    Top = 35
    Width = 89
    Height = 21
    Date = 37524.538336192100000000
    Time = 37524.538336192100000000
    TabOrder = 3
    OnChange = dtpDateDealChange
  end
  object meNote: TMemo
    Left = 95
    Top = 62
    Width = 386
    Height = 59
    TabOrder = 4
    OnChange = edFioChange
    OnKeyPress = edFioKeyPress
  end
  object dsDocum: TDataSource
    Left = 44
    Top = 216
  end
  object dsReestr: TDataSource
    DataSet = qrReestr
    Left = 116
    Top = 216
  end
  object tran: TIBTransaction
    Left = 164
    Top = 218
  end
  object qrReestr: TIBQuery
    Transaction = tran
    ParamCheck = False
    Left = 212
    Top = 218
  end
end
