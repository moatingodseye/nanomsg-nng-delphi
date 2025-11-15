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
    Height = 41
    Align = alTop
    TabOrder = 0
    object Label1: TLabel
      Left = 192
      Top = 12
      Width = 25
      Height = 15
      Caption = 'Host'
    end
    object Label2: TLabel
      Left = 392
      Top = 12
      Width = 22
      Height = 15
      Caption = 'Port'
    end
    object btnStartup: TButton
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Caption = 'btnStartup'
      TabOrder = 0
      OnClick = btnStartupClick
    end
    object btnShutdown: TButton
      Left = 89
      Top = 9
      Width = 75
      Height = 25
      Caption = 'btnShutdown'
      TabOrder = 1
      OnClick = btnShutdownClick
    end
    object edtHost: TEdit
      Left = 232
      Top = 9
      Width = 121
      Height = 23
      TabOrder = 2
      Text = 'tcp://127.0.0.1'
    end
    object edtPort: TEdit
      Left = 420
      Top = 9
      Width = 61
      Height = 23
      TabOrder = 3
      Text = '5800'
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 624
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitLeft = 64
    ExplicitTop = 88
    ExplicitWidth = 185
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
    Top = 82
    Width = 624
    Height = 359
    Align = alClient
    Lines.Strings = (
      'mmoLog')
    TabOrder = 2
    ExplicitLeft = 160
    ExplicitTop = 136
    ExplicitWidth = 185
    ExplicitHeight = 89
  end
end
