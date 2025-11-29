object frmPackageDebug: TfrmPackageDebug
  Left = 0
  Top = 0
  Caption = 'frmPackageDebug'
  ClientHeight = 171
  ClientWidth = 374
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
    Width = 374
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitLeft = 144
    ExplicitTop = 40
    ExplicitWidth = 185
    object btnStartup: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'btnStartup'
      TabOrder = 0
      OnClick = btnStartupClick
    end
    object btnShutdown: TButton
      Left = 89
      Top = 8
      Width = 75
      Height = 25
      Caption = 'btnShutdown'
      TabOrder = 1
      OnClick = btnShutdownClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 374
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitLeft = 176
    ExplicitTop = 56
    ExplicitWidth = 185
    object btnPut: TButton
      Left = 8
      Top = 6
      Width = 75
      Height = 25
      Caption = 'btnPut'
      TabOrder = 0
      OnClick = btnPutClick
    end
    object edtPut: TEdit
      Left = 104
      Top = 8
      Width = 201
      Height = 23
      TabOrder = 1
      Text = 'Some values into the '#39'dll'#39
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 82
    Width = 374
    Height = 41
    Align = alTop
    TabOrder = 2
    ExplicitLeft = 88
    ExplicitTop = 112
    ExplicitWidth = 185
    object btnGet: TButton
      Left = 8
      Top = 6
      Width = 75
      Height = 25
      Caption = 'btnGet'
      TabOrder = 0
      OnClick = btnGetClick
    end
    object edtGet: TEdit
      Left = 104
      Top = 8
      Width = 201
      Height = 23
      TabOrder = 1
      Text = 'edtGet'
    end
  end
  object Panel4: TPanel
    Left = 0
    Top = 123
    Width = 374
    Height = 41
    Align = alTop
    Caption = 'Panel4'
    TabOrder = 3
    ExplicitLeft = 48
    ExplicitTop = 144
    ExplicitWidth = 185
    object mmoLog: TMemo
      Left = 1
      Top = 1
      Width = 372
      Height = 39
      Align = alClient
      Lines.Strings = (
        'mmoLog')
      TabOrder = 0
      ExplicitLeft = 88
      ExplicitTop = 24
      ExplicitWidth = 185
      ExplicitHeight = 89
    end
  end
end
