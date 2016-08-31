object PictEditor: TPictEditor
  Left = 258
  Top = 201
  Width = 300
  Height = 250
  BorderIcons = [biSystemMenu, biMaximize]
  Caption = 'Редактор изображения'
  Color = clBtnFace
  Constraints.MinHeight = 250
  Constraints.MinWidth = 300
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 182
    Width = 292
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Panel2: TPanel
      Left = 107
      Top = 0
      Width = 185
      Height = 41
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object bibCancel: TBitBtn
        Left = 102
        Top = 10
        Width = 75
        Height = 25
        Cancel = True
        Caption = 'Отмена'
        ModalResult = 2
        TabOrder = 1
        NumGlyphs = 2
      end
      object bibOk: TBitBtn
        Left = 18
        Top = 10
        Width = 75
        Height = 25
        Caption = 'ОК'
        Default = True
        ModalResult = 1
        TabOrder = 0
        NumGlyphs = 2
      end
    end
  end
  object Panel3: TPanel
    Left = 187
    Top = 0
    Width = 105
    Height = 182
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object Load: TButton
      Left = 9
      Top = 7
      Width = 88
      Height = 24
      Caption = '&Загрузить...'
      TabOrder = 0
      OnClick = LoadClick
    end
    object Save: TButton
      Left = 9
      Top = 33
      Width = 88
      Height = 24
      Caption = '&Сохранить...'
      TabOrder = 1
      OnClick = SaveClick
    end
    object Copy: TButton
      Left = 9
      Top = 59
      Width = 88
      Height = 24
      Caption = '&Копировать'
      TabOrder = 2
      OnClick = CopyClick
    end
    object Paste: TButton
      Left = 9
      Top = 85
      Width = 88
      Height = 24
      Caption = '&Вставить'
      TabOrder = 3
      OnClick = PasteClick
    end
    object Clear: TButton
      Left = 9
      Top = 111
      Width = 88
      Height = 24
      Caption = '&Очистить'
      TabOrder = 4
      OnClick = ClearClick
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 0
    Width = 187
    Height = 182
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel4'
    TabOrder = 2
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 0
      Width = 187
      Height = 182
      Align = alClient
      TabOrder = 0
      object Image: TImage
        Left = 0
        Top = 0
        Width = 183
        Height = 178
        AutoSize = True
        Center = True
      end
    end
  end
  object OD: TOpenPictureDialog
    Options = [ofEnableSizing]
    Left = 35
    Top = 59
  end
  object SD: TSavePictureDialog
    Options = [ofEnableSizing]
    Left = 75
    Top = 59
  end
end
