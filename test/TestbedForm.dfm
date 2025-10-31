object frmTestBed: TfrmTestBed
  Left = 0
  Top = 0
  Caption = 'Testbed'
  ClientHeight = 268
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
    Top = 80
    Width = 37
    Height = 15
    Caption = 'Servers'
  end
  object Label2: TLabel
    Left = 88
    Top = 80
    Width = 36
    Height = 15
    Caption = 'Clients'
  end
  object Label3: TLabel
    Left = 169
    Top = 80
    Width = 25
    Height = 15
    Caption = 'Both'
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
    Top = 101
    Width = 75
    Height = 25
    Caption = 'Response'
    TabOrder = 2
    OnClick = btnResponseClick
  end
  object btnRequest: TButton
    Left = 88
    Top = 101
    Width = 75
    Height = 25
    Caption = 'Request'
    TabOrder = 3
    OnClick = btnRequestClick
  end
  object btnPush: TButton
    Left = 8
    Top = 132
    Width = 75
    Height = 25
    Caption = 'Push'
    TabOrder = 4
    OnClick = btnPushClick
  end
  object btnPull: TButton
    Left = 88
    Top = 132
    Width = 75
    Height = 25
    Caption = 'Pull'
    TabOrder = 5
    OnClick = btnPullClick
  end
  object btnPublish: TButton
    Left = 7
    Top = 163
    Width = 75
    Height = 25
    Caption = 'Publish'
    TabOrder = 6
    OnClick = btnPublishClick
  end
  object Subscribe: TButton
    Left = 88
    Top = 163
    Width = 75
    Height = 25
    Caption = 'Subscribe'
    TabOrder = 7
    OnClick = SubscribeClick
  end
  object btnSPair: TButton
    Left = 8
    Top = 194
    Width = 75
    Height = 25
    Caption = 'Pair'
    TabOrder = 8
    OnClick = btnSPairClick
  end
  object btnCPair: TButton
    Left = 89
    Top = 194
    Width = 75
    Height = 25
    Caption = 'Pair'
    TabOrder = 9
    OnClick = btnCPairClick
  end
  object btnPair: TButton
    Left = 170
    Top = 194
    Width = 75
    Height = 25
    Caption = 'Pair'
    TabOrder = 10
    OnClick = btnPairClick
  end
  object btnSBus: TButton
    Left = 8
    Top = 224
    Width = 75
    Height = 25
    Caption = 'Bus'
    TabOrder = 11
    OnClick = btnSBusClick
  end
  object btnCBus: TButton
    Left = 89
    Top = 225
    Width = 75
    Height = 25
    Caption = 'Bus'
    TabOrder = 12
    OnClick = btnCBusClick
  end
  object btnBus: TButton
    Left = 170
    Top = 225
    Width = 75
    Height = 25
    Caption = 'Bus'
    TabOrder = 13
    OnClick = btnBusClick
  end
end
