object frmRedisTest: TfrmRedisTest
  Left = 0
  Top = 0
  Caption = 'Redis test'
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
    Height = 127
    Align = alTop
    TabOrder = 0
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
    object btnCreate: TButton
      Left = 8
      Top = 9
      Width = 75
      Height = 25
      Caption = 'btnCreate'
      TabOrder = 0
      OnClick = btnCreateClick
    end
    object rdoInteger: TRadioButton
      Left = 422
      Top = 12
      Width = 73
      Height = 17
      Caption = 'Integer'
      Checked = True
      TabOrder = 1
      TabStop = True
    end
    object edtKey: TEdit
      Left = 264
      Top = 8
      Width = 121
      Height = 23
      TabOrder = 2
    end
    object btnAdd: TButton
      Left = 88
      Top = 8
      Width = 75
      Height = 25
      Caption = 'btnAdd'
      TabOrder = 3
      OnClick = btnAddClick
    end
    object rdoFloat: TRadioButton
      Left = 422
      Top = 35
      Width = 113
      Height = 17
      Caption = 'rdoFloat'
      TabOrder = 4
    end
    object rdoString: TRadioButton
      Left = 422
      Top = 55
      Width = 113
      Height = 17
      Caption = 'rdoString'
      TabOrder = 5
    end
    object rdoDate: TRadioButton
      Left = 422
      Top = 78
      Width = 113
      Height = 17
      Caption = 'rdoDate'
      TabOrder = 6
    end
    object rdoObject: TRadioButton
      Left = 422
      Top = 101
      Width = 113
      Height = 17
      Caption = 'rdoObject'
      TabOrder = 7
    end
    object edtValue: TEdit
      Left = 264
      Top = 37
      Width = 121
      Height = 23
      TabOrder = 8
    end
    object btnExist: TButton
      Left = 89
      Top = 40
      Width = 75
      Height = 25
      Caption = 'btnExist'
      TabOrder = 9
      OnClick = btnExistClick
    end
    object btnRemove: TButton
      Left = 89
      Top = 71
      Width = 75
      Height = 25
      Caption = 'btnRemove'
      TabOrder = 10
      OnClick = btnRemoveClick
    end
  end
  object mmoLog: TMemo
    Left = 0
    Top = 127
    Width = 624
    Height = 314
    Align = alClient
    Lines.Strings = (
      'mmoLog')
    TabOrder = 1
    ExplicitLeft = 104
    ExplicitTop = 216
    ExplicitWidth = 185
    ExplicitHeight = 89
  end
end
