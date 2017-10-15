object frmSettings: TfrmSettings
  Left = 0
  Top = 0
  Caption = 'Settings'
  ClientHeight = 667
  ClientWidth = 585
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 18
  object sGroupBox1: TsGroupBox
    AlignWithMargins = True
    Left = 10
    Top = 5
    Width = 565
    Height = 207
    Margins.Left = 10
    Margins.Top = 5
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    Caption = 'DOD Server FTP Login Information'
    TabOrder = 0
    ExplicitLeft = 15
    ExplicitTop = 10
    ExplicitWidth = 514
    DesignSize = (
      565
      207)
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
      Width = 458
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
      ExplicitWidth = 584
    end
    object txtUsername: TsEdit
      Left = 89
      Top = 64
      Width = 272
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
      Left = 89
      Top = 96
      Width = 272
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
      Left = 89
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
    object btnTestConnection: TsButton
      Left = 89
      Top = 168
      Width = 192
      Height = 25
      Caption = 'Test Connection'
      Default = True
      TabOrder = 4
      OnClick = btnTestConnectionClick
    end
  end
  object sGroupBox2: TsGroupBox
    AlignWithMargins = True
    Left = 10
    Top = 232
    Width = 565
    Height = 375
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alClient
    Caption = 'Server Content'
    TabOrder = 1
    ExplicitLeft = 186
    ExplicitTop = 280
    ExplicitWidth = 185
    ExplicitHeight = 105
    object lstFiles: TVirtualStringTree
      Left = 2
      Top = 20
      Width = 561
      Height = 353
      Align = alClient
      EmptyListMessage = '< Not connected >'
      Header.AutoSizeIndex = 0
      Header.Height = 22
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowImages, hoVisible, hoAutoSpring]
      Header.ParentFont = True
      Images = dm.TreeImages
      ScrollBarOptions.AlwaysVisible = True
      TabOrder = 0
      TreeOptions.SelectionOptions = [toFullRowSelect]
      OnGetText = lstFilesGetText
      OnGetImageIndex = lstFilesGetImageIndex
      ExplicitWidth = 699
      ExplicitHeight = 392
      Columns = <
        item
          Position = 0
          Width = 390
          WideText = 'Name'
        end
        item
          Alignment = taRightJustify
          Position = 1
          Width = 150
          WideText = 'Size in Bytes'
        end>
      WideDefaultText = ''
    end
  end
  object sPanel1: TsPanel
    Left = 0
    Top = 617
    Width = 585
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    ExplicitTop = 656
    ExplicitWidth = 723
    DesignSize = (
      585
      50)
    object btnCancel: TsButton
      Left = 413
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 0
      ExplicitLeft = 551
    end
    object btnApply: TsButton
      Left = 494
      Top = 10
      Width = 75
      Height = 25
      Anchors = [akRight, akBottom]
      Caption = 'Apply'
      ModalResult = 1
      TabOrder = 1
      ExplicitLeft = 632
    end
  end
end
