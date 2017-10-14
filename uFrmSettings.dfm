object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  Caption = 'Settings'
  ClientHeight = 247
  ClientWidth = 546
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  DesignSize = (
    546
    247)
  PixelsPerInch = 96
  TextHeight = 18
  object sGroupBox1: TsGroupBox
    AlignWithMargins = True
    Left = 15
    Top = 10
    Width = 514
    Height = 172
    Margins.Left = 10
    Margins.Top = 5
    Margins.Right = 10
    Margins.Bottom = 10
    Caption = 'DOD Server FTP Login Information'
    TabOrder = 0
    object sLabel1: TsLabel
      Left = 48
      Top = 35
      Width = 35
      Height = 18
      Alignment = taRightJustify
      AutoSize = False
      Caption = '&Host:'
      FocusControl = txtHost
    end
    object sLabel2: TsLabel
      Left = 11
      Top = 67
      Width = 72
      Height = 18
      AutoSize = False
      Caption = '&Username:'
      FocusControl = txtUsername
    end
    object sLabel3: TsLabel
      Left = 17
      Top = 99
      Width = 66
      Height = 18
      Alignment = taRightJustify
      AutoSize = False
      Caption = '&Password:'
      FocusControl = txtPassword
    end
    object sLabel4: TsLabel
      Left = 17
      Top = 131
      Width = 66
      Height = 18
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'P&ort:'
      FocusControl = txtPort
    end
    object txtHost: TsEdit
      Left = 89
      Top = 32
      Width = 408
      Height = 26
      Color = 3553081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 11777720
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object txtUsername: TsEdit
      Left = 89
      Top = 64
      Width = 192
      Height = 26
      Color = 3553081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 11777720
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object txtPassword: TsEdit
      Left = 89
      Top = 96
      Width = 192
      Height = 26
      Color = 3553081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 11777720
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object txtPort: TsSpinEdit
      Left = 89
      Top = 128
      Width = 96
      Height = 26
      Color = 3553081
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 11777720
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      Text = '21'
      MaxValue = 64399
      MinValue = 1
      Value = 21
    end
  end
  object btnApply: TsButton
    Left = 463
    Top = 214
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = 'Apply'
    ModalResult = 1
    TabOrder = 1
    ExplicitLeft = 702
    ExplicitTop = 428
  end
  object btnCancel: TsButton
    Left = 375
    Top = 214
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 2
    ExplicitLeft = 614
    ExplicitTop = 428
  end
end
