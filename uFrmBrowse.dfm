object frmBrowse: TfrmBrowse
  Left = 0
  Top = 0
  Caption = 'Browse'
  ClientHeight = 665
  ClientWidth = 978
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object sGroupBox2: TsGroupBox
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 968
    Height = 655
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    Caption = 'FTP Server Content'
    TabOrder = 0
    ExplicitLeft = 235
    ExplicitTop = 2
    ExplicitWidth = 743
    ExplicitHeight = 663
    object lstFtpFiles: TVirtualStringTree
      AlignWithMargins = True
      Left = 17
      Top = 30
      Width = 934
      Height = 558
      Margins.Left = 15
      Margins.Top = 15
      Margins.Right = 15
      Margins.Bottom = 15
      Align = alClient
      EmptyListMessage = '< Not connected >'
      Header.AutoSizeIndex = 0
      Header.Height = 30
      Header.Options = [hoAutoResize, hoColumnResize, hoDrag, hoShowImages, hoVisible, hoAutoSpring]
      Header.ParentFont = True
      Images = dm.TreeImages
      ScrollBarOptions.AlwaysVisible = True
      TabOrder = 0
      TreeOptions.PaintOptions = [toHideSelection, toShowButtons, toShowDropmark, toShowRoot, toShowTreeLines, toThemeAware, toUseBlendedImages]
      TreeOptions.SelectionOptions = [toFullRowSelect]
      ExplicitWidth = 709
      ExplicitHeight = 566
      Columns = <
        item
          Position = 0
          Width = 563
          WideText = 'Name'
        end
        item
          Alignment = taRightJustify
          Position = 1
          Width = 130
          WideText = 'Size in Bytes'
        end
        item
          Position = 2
          Width = 220
          WideText = 'Date / Time'
        end>
      WideDefaultText = ''
    end
    object sPanel5: TsPanel
      AlignWithMargins = True
      Left = 17
      Top = 604
      Width = 934
      Height = 48
      Margins.Left = 15
      Margins.Top = 1
      Margins.Right = 15
      Margins.Bottom = 1
      Align = alBottom
      TabOrder = 1
      ExplicitTop = 612
      ExplicitWidth = 709
      DesignSize = (
        934
        48)
      object sLabel5: TsLabel
        Left = 180
        Top = 15
        Width = 70
        Height = 18
        Alignment = taRightJustify
        AutoSize = False
        Caption = 'F&older:'
        FocusControl = txtFolder
      end
      object txtFolder: TsEdit
        Left = 256
        Top = 10
        Width = 659
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
        Text = '/dod/'
        ExplicitWidth = 434
      end
      object btnBack: TsButton
        Left = 100
        Top = 8
        Width = 80
        Height = 30
        Caption = '&Back'
        Enabled = False
        TabOrder = 1
      end
      object btnRoot: TsButton
        Left = 14
        Top = 8
        Width = 80
        Height = 30
        Caption = 'Root'
        TabOrder = 2
      end
    end
  end
end
