object frmDebugClientTest: TfrmDebugClientTest
  Left = 0
  Top = 0
  Caption = 'frmDebugClientTest'
  ClientHeight = 441
  ClientWidth = 624
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
    Width = 624
    Height = 67
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 192
      Top = 14
      Width = 25
      Height = 15
      Caption = 'Host'
    end
    object Label2: TLabel
      Left = 360
      Top = 14
      Width = 22
      Height = 15
      Caption = 'Port'
    end
    object lblStatus: TLabel
      Left = 8
      Top = 46
      Width = 45
      Height = 15
      Caption = 'lblStatus'
    end
    object btnStartup: TButton
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 0
      OnClick = btnStartupClick
    end
    object btnShutdown: TButton
      Left = 89
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Disconnect'
      TabOrder = 1
      OnClick = btnShutdownClick
    end
    object edtHost: TEdit
      Left = 232
      Top = 10
      Width = 121
      Height = 23
      TabOrder = 2
      Text = 'tcp://127.0.0.1'
    end
    object edtPort: TEdit
      Left = 388
      Top = 10
      Width = 61
      Height = 23
      TabOrder = 3
      Text = '5800'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 67
    Width = 624
    Height = 41
    Align = alTop
    TabOrder = 1
    object Label3: TLabel
      Left = 96
      Top = 11
      Width = 138
      Height = 15
      Caption = 'Username/Password/Host'
    end
    object btnPrepare: TButton
      Left = 8
      Top = 6
      Width = 75
      Height = 25
      Caption = 'btnPrepare'
      TabOrder = 0
      OnClick = btnPrepareClick
    end
    object edtPUser: TEdit
      Left = 240
      Top = 7
      Width = 121
      Height = 23
      TabOrder = 1
      Text = 'debra_project'
    end
    object edtPPass: TEdit
      Left = 367
      Top = 7
      Width = 121
      Height = 23
      TabOrder = 2
      Text = 'debra_project'
    end
    object edtPHost: TEdit
      Left = 494
      Top = 7
      Width = 121
      Height = 23
      TabOrder = 3
      Text = '192.168.101.181/debra'
    end
  end
  object mmoLog: TMemo
    Left = 0
    Top = 108
    Width = 624
    Height = 333
    Align = alClient
    Lines.Strings = (
      'mmoLog')
    TabOrder = 2
  end
  object tmTimer: TTimer
    Interval = 200
    OnTimer = tmTimerTimer
    Left = 520
    Top = 24
  end
end
