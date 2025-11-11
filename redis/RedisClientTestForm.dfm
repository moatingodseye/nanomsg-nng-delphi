object frmRedisClientTest: TfrmRedisClientTest
  Left = 0
  Top = 0
  Caption = 'frmRedisClientTest'
  ClientHeight = 278
  ClientWidth = 511
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
    Width = 511
    Height = 41
    Align = alTop
    TabOrder = 0
    object Host: TLabel
      Left = 208
      Top = 13
      Width = 25
      Height = 15
      Caption = 'Host'
    end
    object Label4: TLabel
      Left = 375
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
      Text = 'tcp://127.0.0.1'
    end
    object edtPort: TEdit
      Left = 403
      Top = 10
      Width = 102
      Height = 23
      TabOrder = 3
      Text = '5800'
    end
  end
  object mmoLog: TMemo
    Left = 0
    Top = 168
    Width = 511
    Height = 110
    Align = alClient
    Lines.Strings = (
      'mmoLog')
    TabOrder = 1
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 511
    Height = 127
    Align = alTop
    TabOrder = 2
    object Label1: TLabel
      Left = 391
      Top = 11
      Width = 25
      Height = 15
      Caption = 'Type'
    end
    object Label2: TLabel
      Left = 215
      Top = 11
      Width = 19
      Height = 15
      Caption = 'Key'
    end
    object Label3: TLabel
      Left = 215
      Top = 40
      Width = 28
      Height = 15
      Caption = 'Value'
    end
    object rdoInteger: TRadioButton
      Left = 422
      Top = 12
      Width = 73
      Height = 17
      Caption = 'Integer'
      Checked = True
      TabOrder = 0
      TabStop = True
    end
    object edtKey: TEdit
      Left = 264
      Top = 8
      Width = 121
      Height = 23
      TabOrder = 1
    end
    object Button1: TButton
      Left = 88
      Top = 8
      Width = 75
      Height = 25
      Caption = 'btnAdd'
      TabOrder = 2
      OnClick = Button1Click
    end
    object rdoFloat: TRadioButton
      Left = 422
      Top = 35
      Width = 113
      Height = 17
      Caption = 'rdoFloat'
      TabOrder = 3
    end
    object rdoString: TRadioButton
      Left = 422
      Top = 55
      Width = 113
      Height = 17
      Caption = 'rdoString'
      TabOrder = 4
    end
    object rdoDate: TRadioButton
      Left = 422
      Top = 78
      Width = 113
      Height = 17
      Caption = 'rdoDate'
      TabOrder = 5
    end
    object rdoObject: TRadioButton
      Left = 422
      Top = 101
      Width = 113
      Height = 17
      Caption = 'rdoObject'
      TabOrder = 6
    end
    object edtValue: TEdit
      Left = 264
      Top = 37
      Width = 121
      Height = 23
      TabOrder = 7
    end
    object btnExist: TButton
      Left = 89
      Top = 40
      Width = 75
      Height = 25
      Caption = 'btnExist'
      TabOrder = 8
    end
    object btnRemove: TButton
      Left = 89
      Top = 71
      Width = 75
      Height = 25
      Caption = 'btnRemove'
      TabOrder = 9
    end
  end
end
