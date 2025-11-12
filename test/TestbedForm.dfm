object frmTestBed: TfrmTestBed
  Left = 0
  Top = 0
  Caption = 'Testbed'
  ClientHeight = 304
  ClientWidth = 283
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object lblVersion: TLabel
    Left = 96
    Top = 16
    Width = 51
    Height = 15
    Caption = 'lblVersion'
  end
  object Label1: TLabel
    Left = 8
    Top = 120
    Width = 37
    Height = 15
    Caption = 'Servers'
  end
  object Label2: TLabel
    Left = 88
    Top = 120
    Width = 36
    Height = 15
    Caption = 'Clients'
  end
  object Label3: TLabel
    Left = 169
    Top = 120
    Width = 25
    Height = 15
    Caption = 'Both'
  end
  object Label4: TLabel
    Left = 11
    Top = 80
    Width = 25
    Height = 15
    Caption = 'Host'
  end
  object Label5: TLabel
    Left = 170
    Top = 80
    Width = 22
    Height = 15
    Caption = 'Port'
  end
  object btnVersion: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Version'
    TabOrder = 0
    OnClick = btnVersionClick
  end
  object btnTest: TButton
    Left = 8
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 1
    OnClick = btnTestClick
  end
  object btnResponse: TButton
    Left = 8
    Top = 141
    Width = 75
    Height = 25
    Caption = 'Response'
    TabOrder = 2
    OnClick = btnResponseClick
  end
  object btnRequest: TButton
    Left = 88
    Top = 141
    Width = 75
    Height = 25
    Caption = 'Request'
    TabOrder = 3
    OnClick = btnRequestClick
  end
  object btnPush: TButton
    Left = 8
    Top = 172
    Width = 75
    Height = 25
    Caption = 'Push'
    TabOrder = 4
    OnClick = btnPushClick
  end
  object btnPull: TButton
    Left = 88
    Top = 172
    Width = 75
    Height = 25
    Caption = 'Pull'
    TabOrder = 5
    OnClick = btnPullClick
  end
  object btnPublish: TButton
    Left = 7
    Top = 203
    Width = 75
    Height = 25
    Caption = 'Publish'
    TabOrder = 6
    OnClick = btnPublishClick
  end
  object Subscribe: TButton
    Left = 88
    Top = 203
    Width = 75
    Height = 25
    Caption = 'Subscribe'
    TabOrder = 7
    OnClick = SubscribeClick
  end
  object btnSPair: TButton
    Left = 8
    Top = 234
    Width = 75
    Height = 25
    Caption = 'Pair'
    TabOrder = 8
    OnClick = btnSPairClick
  end
  object btnCPair: TButton
    Left = 89
    Top = 234
    Width = 75
    Height = 25
    Caption = 'Pair'
    TabOrder = 9
    OnClick = btnCPairClick
  end
  object btnPair: TButton
    Left = 170
    Top = 234
    Width = 75
    Height = 25
    Caption = 'Pair'
    TabOrder = 10
    OnClick = btnPairClick
  end
  object btnSBus: TButton
    Left = 8
    Top = 264
    Width = 75
    Height = 25
    Caption = 'Bus'
    TabOrder = 11
    OnClick = btnSBusClick
  end
  object btnCBus: TButton
    Left = 89
    Top = 265
    Width = 75
    Height = 25
    Caption = 'Bus'
    TabOrder = 12
    OnClick = btnCBusClick
  end
  object btnBus: TButton
    Left = 170
    Top = 265
    Width = 75
    Height = 25
    Caption = 'Bus'
    TabOrder = 13
    OnClick = btnBusClick
  end
  object edtHost: TEdit
    Left = 64
    Top = 77
    Width = 100
    Height = 23
    TabOrder = 14
    Text = 'tcp://127.0.0.1'
  end
  object edtPort: TEdit
    Left = 210
    Top = 77
    Width = 65
    Height = 23
    TabOrder = 15
    Text = '5800'
  end
end
