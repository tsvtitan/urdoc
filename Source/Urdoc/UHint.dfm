object fmChangeHint: TfmChangeHint
  Left = 487
  Top = 166
  BorderStyle = bsDialog
  Caption = 'fmChangeHint'
  ClientHeight = 215
  ClientWidth = 345
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 174
    Width = 345
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      Left = 160
      Top = 0
      Width = 185
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object BitBtn3: TBitBtn
        Left = 21
        Top = 10
        Width = 75
        Height = 25
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
        NumGlyphs = 2
      end
      object BitBtn4: TBitBtn
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
  object pnBack: TPanel
    Left = 0
    Top = 0
    Width = 345
    Height = 174
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object gbHint: TGroupBox
      Left = 5
      Top = 5
      Width = 335
      Height = 164
      Align = alClient
      Caption = ' '#1054#1087#1080#1089#1072#1085#1080#1077' '
      TabOrder = 0
      object Panel1: TPanel
        Left = 2
        Top = 15
        Width = 331
        Height = 147
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 10
        TabOrder = 0
        object mmNint: TMemo
          Left = 10
          Top = 10
          Width = 311
          Height = 127
          Align = alClient
          MaxLength = 250
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
end
