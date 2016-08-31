object frmEditorSearch: TfrmEditorSearch
  Left = 132
  Top = 168
  BorderStyle = bsDialog
  Caption = 'Find text'
  ClientHeight = 180
  ClientWidth = 332
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCloseQuery = FormCloseQuery
  PixelsPerInch = 96
  TextHeight = 13
  object LblSearchText: TLabel
    Left = 8
    Top = 12
    Width = 54
    Height = 13
    Caption = '&Search for:'
  end
  object cbSearchText: TComboBox
    Left = 96
    Top = 8
    Width = 228
    Height = 21
    ItemHeight = 13
    TabOrder = 0
  end
  object gbSearchOptions: TGroupBox
    Left = 8
    Top = 40
    Width = 154
    Height = 109
    Caption = 'Options'
    TabOrder = 1
    object cbSearchCaseSensitive: TCheckBox
      Left = 8
      Top = 17
      Width = 140
      Height = 17
      Caption = 'C&ase sensitivity'
      TabOrder = 0
    end
    object cbSearchWholeWords: TCheckBox
      Left = 8
      Top = 39
      Width = 140
      Height = 17
      Caption = '&Whole words only'
      TabOrder = 1
    end
    object cbSearchFromCursor: TCheckBox
      Left = 8
      Top = 61
      Width = 140
      Height = 17
      Caption = 'Search from &cursor'
      TabOrder = 2
    end
    object cbSearchSelectedOnly: TCheckBox
      Left = 8
      Top = 83
      Width = 140
      Height = 17
      Caption = '&Selected text only'
      TabOrder = 3
    end
  end
  object rgSearchDirection: TRadioGroup
    Left = 170
    Top = 40
    Width = 154
    Height = 65
    Caption = 'Direction'
    ItemIndex = 0
    Items.Strings = (
      '&Forward'
      '&Backward')
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 176
    Top = 152
    Width = 73
    Height = 23
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 3
  end
  object btnCancel: TButton
    Left = 256
    Top = 152
    Width = 73
    Height = 23
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 4
  end
end