object frmInPackage: TfrmInPackage
  Left = 0
  Top = 0
  Caption = 'frmInPackage'
  ClientHeight = 110
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object lblPut: TLabel
    Left = 8
    Top = 16
    Width = 31
    Height = 15
    Caption = 'lblPut'
  end
  object edtGet: TEdit
    Left = 8
    Top = 37
    Width = 257
    Height = 23
    TabOrder = 0
    Text = 'I come from the package'
  end
  object btnEvent: TButton
    Left = 8
    Top = 72
    Width = 75
    Height = 25
    Caption = 'btnEvent'
    TabOrder = 1
    OnClick = btnEventClick
  end
end
