object Form1: TForm1
  Left = 286
  Top = 231
  Width = 445
  Height = 315
  Caption = 'I2C Test on 24C02 Device Using FT2232C'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 337
    Height = 65
    TabOrder = 0
    object Label1: TLabel
      Left = 176
      Top = 8
      Width = 47
      Height = 13
      Caption = 'File Name'
    end
    object Label2: TLabel
      Left = 8
      Top = 8
      Width = 65
      Height = 13
      Caption = 'Device Name'
    end
    object ComboBox1: TComboBox
      Left = 8
      Top = 32
      Width = 145
      Height = 21
      ItemHeight = 13
      TabOrder = 0
      OnDropDown = ComboBox1DropDown
    end
    object Edit1: TEdit
      Left = 176
      Top = 32
      Width = 145
      Height = 21
      TabOrder = 1
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 72
    Width = 337
    Height = 193
    TabOrder = 1
    object Memo1: TMemo
      Left = 8
      Top = 8
      Width = 321
      Height = 177
      Lines.Strings = (
        '')
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 344
    Top = 0
    Width = 90
    Height = 265
    TabOrder = 2
    object Label3: TLabel
      Left = 16
      Top = 208
      Width = 50
      Height = 13
      Caption = 'Clk Divisor'
    end
    object Label4: TLabel
      Left = 8
      Top = 152
      Width = 57
      Height = 13
      Caption = 'I2C Address'
    end
    object Button1: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Read'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 8
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Prog To Addr'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 8
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Erase'
      TabOrder = 2
      OnClick = Button3Click
    end
    object UpDown1: TUpDown
      Left = 8
      Top = 224
      Width = 25
      Height = 33
      Min = 0
      Max = 32000
      Position = 3
      TabOrder = 3
      Wrap = False
      OnChanging = UpDown1Changing
      OnClick = UpDown1Click
    end
    object Edit2: TEdit
      Left = 40
      Top = 229
      Width = 41
      Height = 21
      TabOrder = 4
      OnChange = Edit2Change
      OnExit = Edit2Exit
    end
    object Button4: TButton
      Left = 8
      Top = 104
      Width = 75
      Height = 25
      Caption = 'Prog Frm File'
      TabOrder = 5
      OnClick = Button4Click
    end
    object ComboBox2: TComboBox
      Left = 8
      Top = 168
      Width = 33
      Height = 21
      ItemHeight = 13
      TabOrder = 6
      Text = '7'
      Items.Strings = (
        '0'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7')
    end
  end
  object MainMenu1: TMainMenu
    Left = 40
    Top = 152
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
      object N1: TMenuItem
        Caption = 'Save As'
        OnClick = N1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    Left = 104
    Top = 136
  end
  object SaveDialog1: TSaveDialog
    Left = 152
    Top = 136
  end
end
