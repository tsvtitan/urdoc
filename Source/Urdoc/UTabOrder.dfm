object fmTabOrder: TfmTabOrder
  Left = 196
  Top = 148
  ActiveControl = clbList
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = #1055#1086#1088#1103#1076#1086#1082' '#1087#1077#1088#1077#1093#1086#1076#1072
  ClientHeight = 253
  ClientWidth = 432
  Color = clBtnFace
  Constraints.MinHeight = 180
  Constraints.MinWidth = 350
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 212
    Width = 432
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      Left = 247
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
        ModalResult = 1
        TabOrder = 0
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
  object pnTabOrder: TPanel
    Left = 0
    Top = 0
    Width = 432
    Height = 212
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object gbTabOrder: TGroupBox
      Left = 5
      Top = 5
      Width = 422
      Height = 202
      Align = alClient
      Caption = #1057#1087#1080#1089#1086#1082
      TabOrder = 0
      object pnList: TPanel
        Left = 2
        Top = 15
        Width = 418
        Height = 185
        Align = alClient
        BevelOuter = bvNone
        BorderWidth = 5
        TabOrder = 0
        object pnListR: TPanel
          Left = 349
          Top = 5
          Width = 64
          Height = 175
          Align = alRight
          BevelOuter = bvNone
          TabOrder = 1
          object btUp: TBitBtn
            Left = 14
            Top = 4
            Width = 40
            Height = 25
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
            Left = 14
            Top = 36
            Width = 40
            Height = 25
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
        end
        object Panel1: TPanel
          Left = 5
          Top = 5
          Width = 344
          Height = 175
          Align = alClient
          BevelOuter = bvNone
          BorderWidth = 5
          TabOrder = 0
          object clbList: TCheckListBox
            Left = 5
            Top = 5
            Width = 334
            Height = 140
            Align = alClient
            Flat = False
            ItemHeight = 13
            TabOrder = 0
            OnClick = clbListClick
            OnDragDrop = clbListDragDrop
            OnDragOver = clbListDragOver
            OnDrawItem = clbListDrawItem
            OnEndDrag = clbListEndDrag
            OnMouseMove = clbListMouseMove
          end
          object Panel4: TPanel
            Left = 5
            Top = 145
            Width = 334
            Height = 25
            Align = alBottom
            Anchors = [akLeft, akTop, akRight]
            BevelOuter = bvNone
            TabOrder = 1
            DesignSize = (
              334
              25)
            object chbViewInspector: TCheckBox
              Left = 1
              Top = 8
              Width = 204
              Height = 17
              Anchors = [akLeft, akBottom]
              Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1080#1085#1089#1087#1077#1082#1090#1086#1088' '#1086#1073#1100#1077#1082#1090#1086#1074
              TabOrder = 0
            end
          end
        end
      end
    end
  end
end
