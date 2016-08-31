object fmLogin: TfmLogin
  Left = 585
  Top = 204
  BorderStyle = bsDialog
  Caption = #1048#1076#1077#1085#1090#1080#1092#1080#1082#1072#1094#1080#1103
  ClientHeight = 135
  ClientWidth = 292
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnBottom: TPanel
    Left = 0
    Top = 94
    Width = 292
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      Left = 107
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
  object pn: TPanel
    Left = 0
    Top = 0
    Width = 292
    Height = 94
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object GroupBox1: TGroupBox
      Left = 5
      Top = 5
      Width = 282
      Height = 84
      Align = alClient
      Caption = #1042#1074#1077#1076#1080#1090#1077' '#1089#1074#1086#1080' '#1076#1072#1085#1085#1099#1077
      TabOrder = 0
      object Panel2: TPanel
        Left = 2
        Top = 15
        Width = 278
        Height = 67
        Align = alClient
        BevelOuter = bvNone
        BevelWidth = 5
        BorderWidth = 5
        TabOrder = 0
        object lbUser: TLabel
          Left = 15
          Top = 7
          Width = 76
          Height = 13
          Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
        end
        object lbPass: TLabel
          Left = 50
          Top = 37
          Width = 41
          Height = 13
          Caption = #1055#1072#1088#1086#1083#1100':'
        end
        object im: TImage
          Left = 11
          Top = 27
          Width = 32
          Height = 32
          Picture.Data = {
            055449636F6E0000010001002020100000000000E80200001600000028000000
            2000000040000000010004000000000000020000000000000000000000000000
            0000000000000000000080000080000000808000800000008000800080800000
            C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000
            FFFFFF0000000000000000000000000000000000000000000000077000000000
            00000000000000000000F7870000000000000000000000077008078700000000
            0000000000000887770087870000000000000000000008F7878F778700000000
            00008000000008F78708F787000000000008B330000000078700078700000000
            0800BB80000000878700878700000000833BB80000008F77878F778700000000
            8BBB8030000008F7878F7787000000800BB80300000000078708F78700000833
            BB803000000000878708F78800008BBBB803000000008F77878F77F800008BBB
            8030000000008F7788F77F778000BBB803000000000008F78F77F000000BBB80
            30000000000008F8F7700888888BB8030000000000008F8F77088BBBBBBB8030
            000000000008F78F708BBBBBBBB7B30000000000008F778F70BBBB7B7B7B7300
            0000000008F77F8F0BBBB0B0B7B7B300000000008F77F78F8BBBBB0B0B7B7300
            000000008F777F788BBBBBB0B0B7B300000000008F77F7008BBB880B0B0B7300
            000000008F77708F8BB00770B0B73000000000008F77F0878BB00070BBB73000
            0000000008F7708808B00800BB73000000000000008F77000788000BB3300000
            000000000008FFF0878077773000000000000000000088808880888800000000
            0000000000000000800080000000000000000000000000000000000000000000
            00000000FFF9FFFFFFF0FFFFFE607FFFFC007FFFF8007FFFF8007FF1F8007FE0
            FC107F80F8007F00F0007F00F8007C01FC007803F8007007F000700FF000201F
            F800003FF800007FF00000FFE00001FFC00001FF800001FF000001FF000001FF
            000001FF000803FF000403FF800207FFC0000FFFE0001FFFF0107FFFFE73FFFF
            FF07FFFF}
        end
        object edPass: TEdit
          Left = 101
          Top = 34
          Width = 117
          Height = 21
          MaxLength = 20
          PasswordChar = '*'
          TabOrder = 1
        end
        object cbUsers: TComboBox
          Left = 101
          Top = 4
          Width = 167
          Height = 21
          ItemHeight = 13
          MaxLength = 20
          TabOrder = 0
        end
      end
    end
  end
end
