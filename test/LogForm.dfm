object frmLog: TfrmLog
  Left = 0
  Top = 0
  Caption = 'Log'
  ClientHeight = 279
  ClientWidth = 216
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object mmoLog: TMemo
    Left = 0
    Top = 41
    Width = 216
    Height = 238
    Align = alClient
    TabOrder = 0
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 216
    Height = 41
    Align = alTop
    TabOrder = 1
    object btnKick: TButton
      Left = 0
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Kick'
      TabOrder = 0
      OnClick = btnKickClick
    end
  end
end
