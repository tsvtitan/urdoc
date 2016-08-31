object fmAdjust: TfmAdjust
  Left = 412
  Top = 167
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1082#1086#1083#1086#1085#1086#1082
  ClientHeight = 223
  ClientWidth = 292
  Color = clBtnFace
  Constraints.MinHeight = 170
  Constraints.MinWidth = 250
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 182
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
        Hint = #1055#1086#1076#1090#1074#1077#1088#1076#1080#1090#1100
        Caption = 'OK'
        Default = True
        ModalResult = 1
        TabOrder = 0
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
        ModalResult = 2
        TabOrder = 1
        NumGlyphs = 2
      end
    end
  end
  object pnTabOrder: TPanel
    Left = 0
    Top = 0
    Width = 292
    Height = 182
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object gbTabOrder: TGroupBox
      Left = 5
      Top = 5
      Width = 282
      Height = 172
      Align = alClient
      Caption = ' '#1050#1086#1083#1086#1085#1082#1080'  '
      TabOrder = 0
      object pnList: TPanel
        Left = 2
        Top = 15
        Width = 278
        Height = 155
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object pnListR: TPanel
          Left = 230
          Top = 5
          Width = 43
          Height = 145
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          object btUp: TBitBtn
            Left = 1
            Top = 4
            Width = 40
            Height = 25
            Hint = #1042#1074#1077#1088#1093
            TabOrder = 0
            OnClick = btUpClick
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              0400000000008000000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
              8888888888888888888888888888888888888888888888888888888880000088
              8888888880666088888888888066608888888888806660888888880000666000
              0888888066666660888888880666660888888888806660888888888888060888
              8888888888808888888888888888888888888888888888888888}
          end
          object btDown: TBitBtn
            Left = 1
            Top = 36
            Width = 40
            Height = 25
            Hint = #1042#1085#1080#1079
            TabOrder = 1
            OnClick = btDownClick
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              0400000000008000000000000000000000001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
              8888888888888888888888888888888888888888888888888888888888808888
              8888888888060888888888888066608888888888066666088888888066666660
              8888880000666000088888888066608888888888806660888888888880666088
              8888888880000088888888888888888888888888888888888888}
          end
          object bibCheckAll: TBitBtn
            Left = 1
            Top = 68
            Width = 40
            Height = 25
            Hint = #1042#1099#1073#1088#1072#1090#1100' '#1074#1089#1077
            TabOrder = 2
            OnClick = bibCheckAllClick
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              04000000000080000000120B0000120B00001000000010000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF00C0C0C00000FFFF00FF000000C0C0C000FFFF0000FFFFFF00DADADADADADA
              DADAADADADADADADADADDFFFFFFFFFFFFFDAA788888888888FADD70FFFFFFFFF
              8FDAA70FFF0FFFFF8FADD70FF000FFFF8FDAA70F00000FFF8FADD70F00F000FF
              8FDAA70F0FFF000F8FADD70FFFFFF00F8FDAA70FFFFFFF0F8FADD70FFFFFFFFF
              8FDAA700000000008FADD777777777777FDAADADADADADADADAD}
          end
          object bibUnCheckAll: TBitBtn
            Left = 1
            Top = 100
            Width = 40
            Height = 25
            Hint = #1059#1073#1088#1072#1090#1100' '#1074#1099#1073#1086#1088' '#1074#1089#1077#1093
            TabOrder = 3
            OnClick = bibUnCheckAllClick
            Glyph.Data = {
              F6000000424DF600000000000000760000002800000010000000100000000100
              04000000000080000000120B0000120B00001000000000000000000000000000
              8000008000000080800080000000800080008080000080808000C0C0C0000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00888888888888
              888888888888888888888FFFFFFFFFFFFF888788888888888F88870FFFFFFFFF
              8F88870FFFFFFFFF8F88870FFFFFFFFF8F88870FFFFFFFFF8F88870FFFFFFFFF
              8F88870FFFFFFFFF8F88870FFFFFFFFF8F88870FFFFFFFFF8F88870FFFFFFFFF
              8F888700000000008F888777777777777F888888888888888888}
          end
        end
        object Panel1: TPanel
          Left = 5
          Top = 5
          Width = 225
          Height = 145
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          TabOrder = 0
          object clbList: TCheckListBox
            Left = 5
            Top = 5
            Width = 215
            Height = 135
            OnClickCheck = clbListClickCheck
            Align = alClient
            Flat = False
            ItemHeight = 13
            TabOrder = 0
            OnDragDrop = clbListDragDrop
            OnDragOver = clbListDragOver
            OnDrawItem = clbListDrawItem
            OnMouseMove = clbListMouseMove
          end
        end
      end
    end
  end
end
