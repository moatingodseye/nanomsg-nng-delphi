object frmRedisTestServer: TfrmRedisTestServer
  Left = 0
  Top = 0
  Caption = 'Redis Test Server'
  ClientHeight = 215
  ClientWidth = 388
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 388
    Height = 49
    Align = alTop
    TabOrder = 0
    object Host: TLabel
      Left = 208
      Top = 13
      Width = 25
      Height = 15
      Caption = 'Host'
    end
    object btnStart: TButton
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Caption = 'btnStart'
      TabOrder = 0
      OnClick = btnStartClick
    end
    object btnStop: TButton
      Left = 89
      Top = 9
      Width = 75
      Height = 25
      Caption = 'btnStop'
      TabOrder = 1
      OnClick = btnStopClick
    end
    object edtHost: TEdit
      Left = 248
      Top = 10
      Width = 121
      Height = 23
      TabOrder = 2
      Text = 'tcp://127.0.0.1:5800'
    end
  end
  object mmoLog: TMemo
    Left = 0
    Top = 49
    Width = 388
    Height = 166
    Align = alClient
    Lines.Strings = (
      'mmoLog')
    TabOrder = 1
    ExplicitLeft = 88
    ExplicitTop = 120
    ExplicitWidth = 185
    ExplicitHeight = 89
  end
end
