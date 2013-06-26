object frm_Main: Tfrm_Main
  Left = 666
  Top = 365
  Width = 742
  Height = 399
  Caption = #33258#21160#21457#24067#24037#20855
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 726
    Height = 45
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label2: TLabel
      Left = 400
      Top = 16
      Width = 121
      Height = 12
      AutoSize = False
      Caption = #21457#24067#38388#38548
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 36
      Height = 12
      Caption = 'Label1'
    end
    object btn_Close: TButton
      Left = 632
      Top = 11
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 0
      OnClick = btn_CloseClick
    end
    object btn_Post: TButton
      Left = 549
      Top = 11
      Width = 75
      Height = 25
      Caption = #24320#22987#21457#24067
      TabOrder = 1
      OnClick = btn_PostClick
    end
  end
  object Memo1: TMemo
    Left = 0
    Top = 45
    Width = 726
    Height = 297
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 342
    Width = 726
    Height = 19
    Panels = <
      item
        Text = #31561#24453#21457#24067
        Width = 60
      end
      item
        Text = #31561#24453#21457#24067
        Width = 140
      end
      item
        Text = #31561#24453#21457#24067
        Width = 80
      end
      item
        Text = #31561#24453#21457#24067
        Width = 50
      end>
  end
  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 336
    Top = 8
  end
end
