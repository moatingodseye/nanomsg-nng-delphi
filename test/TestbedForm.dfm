object frmTestBed: TfrmTestBed
  Left = 0
  Top = 0
  Caption = 'Testbed'
  ClientHeight = 250
  ClientWidth = 174
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
end
