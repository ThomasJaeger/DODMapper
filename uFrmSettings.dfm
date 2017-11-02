object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  Caption = 'Settings'
  ClientHeight = 278
  ClientWidth = 679
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Courier New'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 17
  object sGroupBox1: TsGroupBox
    AlignWithMargins = True
    Left = 10
    Top = 5
    Width = 659
    Height = 204
    Margins.Left = 10
    Margins.Top = 5
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    Caption = 'DOD Server FTP Login Information'
    TabOrder = 0
    DesignSize = (
      659
      204)
    object sLabel1: TsLabel
      Left = 17
      Top = 35
      Width = 89
      Height = 18
      Alignment = taRightJustify
      AutoSize = False
      Caption = '&Host:'
      FocusControl = txtHost
    end
    object sLabel2: TsLabel
      Left = 11
      Top = 67
      Width = 95
      Height = 18
      Alignment = taRightJustify
      AutoSize = False
      Caption = '&Username:'
      FocusControl = txtUsername
    end
    object sLabel3: TsLabel
      Left = 17
      Top = 99
      Width = 89
      Height = 18
      Alignment = taRightJustify
      AutoSize = False
      Caption = '&Password:'
      FocusControl = txtPassword
    end
    object sLabel4: TsLabel
      Left = 17
      Top = 131
      Width = 89
      Height = 18
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'P&ort:'
      FocusControl = txtPort
    end
    object sLabel5: TsLabel
      Left = 17
      Top = 163
      Width = 89
      Height = 18
      Alignment = taRightJustify
      AutoSize = False
      Caption = '&Folder:'
      FocusControl = txtFolder
    end
    object txtHost: TsEdit
      Left = 112
      Top = 32
      Width = 529
      Height = 26
      Anchors = [akLeft, akTop, akRight]
      Color = 4804169
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 13816530
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object txtUsername: TsEdit
      Left = 112
      Top = 64
      Width = 249
      Height = 26
      Color = 4804169
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 13816530
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object txtPassword: TsEdit
      Left = 112
      Top = 96
      Width = 249
      Height = 26
      Color = 4804169
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 13816530
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object txtPort: TsSpinEdit
      Left = 112
      Top = 128
      Width = 96
      Height = 26
      Color = 4804169
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 13816530
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
    object txtFolder: TsEdit
      Left = 112
      Top = 160
      Width = 529
      Height = 26
      Anchors = [akLeft, akTop, akRight]
      Color = 4804169
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 13816530
      Font.Height = -15
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      Text = '/'
    end
  end
  object sPanel1: TsPanel
    Left = 0
    Top = 228
    Width = 679
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    ExplicitTop = 617
    ExplicitWidth = 585
    DesignSize = (
      679
      50)
    object btnCancel: TsButton
      Left = 507
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      ExplicitLeft = 413
    end
    object btnApply: TsButton
      Left = 588
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Apply'
      ModalResult = 1
      TabOrder = 1
      OnClick = btnApplyClick
      ExplicitLeft = 494
    end
  end
end
