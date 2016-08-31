object fmMain: TfmMain
  Left = 516
  Top = 281
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Тестирование WORD'
  ClientHeight = 97
  ClientWidth = 324
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 16
    Width = 121
    Height = 13
    Caption = 'Строка запуска WORD:'
  end
  object Edit1: TEdit
    Left = 144
    Top = 12
    Width = 169
    Height = 21
    TabOrder = 0
    Text = 'Word.Application'
  end
  object Button1: TButton
    Left = 16
    Top = 56
    Width = 297
    Height = 25
    Caption = 'Запустить WORD'
    TabOrder = 1
    OnClick = Button1Click
  end
end
