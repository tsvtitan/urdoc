object UserForm: TUserForm
  Left = 537
  Top = 356
  BorderStyle = bsDialog
  Caption = #1041#1072#1079#1072' '#1076#1072#1085#1085#1099#1093
  ClientHeight = 98
  ClientWidth = 216
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    216
    98)
  PixelsPerInch = 96
  TextHeight = 13
  object LabeledEditUser: TLabeledEdit
    Left = 87
    Top = 8
    Width = 121
    Height = 21
    EditLabel.Width = 76
    EditLabel.Height = 13
    EditLabel.Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100':'
    EditLabel.Layout = tlCenter
    LabelPosition = lpLeft
    TabOrder = 0
    Text = 'SYSDBA'
  end
  object LabeledEditPass: TLabeledEdit
    Left = 87
    Top = 35
    Width = 121
    Height = 21
    EditLabel.Width = 41
    EditLabel.Height = 13
    EditLabel.Caption = #1055#1072#1088#1086#1083#1100':'
    EditLabel.Layout = tlCenter
    LabelPosition = lpLeft
    PasswordChar = '*'
    TabOrder = 1
    Text = 'masterkey'
  end
  object ButtonOk: TButton
    Left = 52
    Top = 66
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = #1054#1050
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object ButtonCancel: TButton
    Left = 133
    Top = 66
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
