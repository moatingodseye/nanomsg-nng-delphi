object frmTestBed: TfrmTestBed
  Left = 0
  Top = 0
  Caption = 'Testbed'
  ClientHeight = 284
  ClientWidth = 477
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
    Left = 224
    Top = 80
    Width = 36
    Height = 15
    Caption = 'Clients'
  end
  object lblActive: TLabel
    Left = 226
    Top = 16
    Width = 46
    Height = 15
    Caption = 'lblActive'
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
    Left = 224
    Top = 101
    Width = 75
    Height = 25
    Caption = 'Request'
    TabOrder = 3
    OnClick = btnRequestClick
  end
  object btnStopResponse: TButton
    Left = 89
    Top = 101
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 4
    OnClick = btnStopResponseClick
  end
  object btnKick: TButton
    Left = 309
    Top = 101
    Width = 75
    Height = 25
    Caption = 'Kick'
    TabOrder = 5
  end
  object btnStopRequest: TButton
    Left = 394
    Top = 101
    Width = 75
    Height = 25
    Caption = 'Stop'
    TabOrder = 6
    OnClick = btnStopRequestClick
  end
end
