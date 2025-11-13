object frmRedisTest: TfrmRedisTest
  Left = 0
  Top = 0
  Caption = 'Redis test'
  ClientHeight = 441
  ClientWidth = 694
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
    Width = 694
    Height = 105
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 624
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
      Caption = 'Float'
      TabOrder = 4
    end
    object rdoString: TRadioButton
      Left = 422
      Top = 58
      Width = 113
      Height = 17
      Caption = 'String'
      TabOrder = 5
    end
    object rdoDate: TRadioButton
      Left = 422
      Top = 81
      Width = 113
      Height = 17
      Caption = 'Date'
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
      OnClick = btnExistClick
    end
    object btnRemove: TButton
      Left = 89
      Top = 71
      Width = 75
      Height = 25
      Caption = 'btnRemove'
      TabOrder = 9
      OnClick = btnRemoveClick
    end
    object btnSave: TButton
      Left = 536
      Top = 8
      Width = 75
      Height = 25
      Caption = 'btnSave'
      TabOrder = 10
      OnClick = btnSaveClick
    end
    object btnLoad: TButton
      Left = 536
      Top = 39
      Width = 75
      Height = 25
      Caption = 'btnLoad'
      TabOrder = 11
      OnClick = btnLoadClick
    end
    object btnDestroy: TButton
      Left = 8
      Top = 40
      Width = 75
      Height = 25
      Caption = 'btnDestroy'
      TabOrder = 12
      OnClick = btnDestroyClick
    end
    object btnDump: TButton
      Left = 616
      Top = 8
      Width = 75
      Height = 25
      Caption = 'btnDump'
      TabOrder = 13
      OnClick = btnDumpClick
    end
    object btnClear: TButton
      Left = 617
      Top = 39
      Width = 75
      Height = 25
      Caption = 'btnClear'
      TabOrder = 14
      OnClick = btnClearClick
    end
  end
  object mmoLog: TMemo
    Left = 0
    Top = 105
    Width = 694
    Height = 336
    Align = alClient
    Lines.Strings = (
      'mmoLog')
    TabOrder = 1
    ExplicitWidth = 624
  end
end
