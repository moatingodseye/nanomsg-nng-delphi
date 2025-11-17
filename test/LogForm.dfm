object frmLog: TfrmLog
  Left = 0
  Top = 0
  Caption = 'Log'
  ClientHeight = 279
  ClientWidth = 326
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object mmoLog: TMemo
    Left = 0
    Top = 73
    Width = 326
    Height = 206
    Align = alClient
    TabOrder = 0
    ExplicitTop = 41
    ExplicitWidth = 216
    ExplicitHeight = 238
  end
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 326
    Height = 73
    Align = alTop
    TabOrder = 1
    ExplicitWidth = 216
    object lblStatus: TLabel
      Left = 0
      Top = 41
      Width = 45
      Height = 15
      Caption = 'lblStatus'
    end
    object btnKick: TButton
      Left = 0
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Kick'
      TabOrder = 0
      OnClick = btnKickClick
    end
    object btnStop: TButton
      Left = 81
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Stop'
      TabOrder = 1
      OnClick = btnStopClick
    end
  end
  object tmTimer: TTimer
    Interval = 200
    OnTimer = tmTimerTimer
    Left = 224
    Top = 40
  end
end
