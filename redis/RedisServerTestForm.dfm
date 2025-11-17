object frmRedisTestServer: TfrmRedisTestServer
  Left = 0
  Top = 0
  Caption = 'Redis Test Server'
  ClientHeight = 215
  ClientWidth = 522
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
    Width = 522
    Height = 49
    Align = alTop
    TabOrder = 0
    object Host: TLabel
      Left = 176
      Top = 13
      Width = 25
      Height = 15
      Caption = 'Host'
    end
    object Label4: TLabel
      Left = 351
      Top = 13
      Width = 22
      Height = 15
      Caption = 'Port'
    end
    object btnStart: TButton
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 0
      OnClick = btnStartClick
    end
    object btnStop: TButton
      Left = 89
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Disconnect'
      TabOrder = 1
      OnClick = btnStopClick
    end
    object edtHost: TEdit
      Left = 216
      Top = 10
      Width = 121
      Height = 23
      TabOrder = 2
      Text = 'tcp://127.0.0.1'
    end
    object edtPort: TEdit
      Left = 379
      Top = 10
      Width = 46
      Height = 23
      TabOrder = 3
      Text = '5800'
    end
  end
  object mmoLog: TMemo
    Left = 0
    Top = 49
    Width = 522
    Height = 166
    Align = alClient
    Lines.Strings = (
      'mmoLog')
    TabOrder = 1
  end
end
