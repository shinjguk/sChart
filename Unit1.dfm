object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'sChart sample'
  ClientHeight = 916
  ClientWidth = 1366
  Color = clWhite
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #47569#51008' '#44256#46357
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 15
  object PaintBox1: TPaintBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 1088
    Height = 910
    Margins.Right = 0
    Align = alClient
    OnPaint = PaintBox1Paint
    ExplicitWidth = 1072
  end
  object Panel1: TPanel
    Left = 1091
    Top = 0
    Width = 275
    Height = 916
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    object GroupBox2: TGroupBox
      Left = 5
      Top = 160
      Width = 260
      Height = 284
      Caption = ' CHART PROPERTIES '
      TabOrder = 0
      object Label1: TLabel
        Left = 20
        Top = 25
        Width = 123
        Height = 15
        Caption = 'BACKGROUND COLOR'
      end
      object Label2: TLabel
        Left = 20
        Top = 100
        Width = 51
        Height = 15
        Caption = 'DECIMAL'
      end
      object Label3: TLabel
        Left = 20
        Top = 125
        Width = 67
        Height = 15
        Caption = 'GRADATION'
      end
      object Label4: TLabel
        Left = 141
        Top = 213
        Width = 4
        Height = 15
      end
      object Label5: TLabel
        Left = 20
        Top = 200
        Width = 112
        Height = 15
        Caption = 'HORIZONTAL LINE Y'
      end
      object Label6: TLabel
        Left = 20
        Top = 225
        Width = 79
        Height = 15
        Caption = 'LABEL WIDTH '
      end
      object Label7: TLabel
        Left = 20
        Top = 250
        Width = 67
        Height = 15
        Caption = 'LINE COLOR'
      end
      object Edit1: TEdit
        Left = 180
        Top = 22
        Width = 60
        Height = 21
        TabStop = False
        AutoSize = False
        TabOrder = 0
        Text = 'clWhite'
        OnClick = Edit1Click
        OnKeyDown = Edit1KeyDown
      end
      object CheckBox1: TCheckBox
        Left = 20
        Top = 50
        Width = 97
        Height = 17
        TabStop = False
        Caption = 'BOX'
        Checked = True
        State = cbChecked
        TabOrder = 1
        OnClick = CheckBox1Click
      end
      object CheckBox2: TCheckBox
        Left = 20
        Top = 75
        Width = 185
        Height = 17
        TabStop = False
        Caption = 'CANDLE COLOR'
        Checked = True
        State = cbChecked
        TabOrder = 2
        OnClick = CheckBox2Click
      end
      object Edit2: TEdit
        Left = 180
        Top = 97
        Width = 60
        Height = 21
        TabStop = False
        AutoSize = False
        TabOrder = 3
        Text = '2'
        OnClick = Edit2Click
        OnKeyDown = Edit2KeyDown
      end
      object Edit3: TEdit
        Left = 180
        Top = 122
        Width = 60
        Height = 21
        TabStop = False
        AutoSize = False
        TabOrder = 4
        Text = '10'
        OnClick = Edit3Click
        OnKeyDown = Edit3KeyDown
      end
      object CheckBox3: TCheckBox
        Left = 20
        Top = 150
        Width = 148
        Height = 17
        TabStop = False
        Caption = 'GRADATION EXTENSION'
        Checked = True
        State = cbChecked
        TabOrder = 5
        OnClick = CheckBox3Click
      end
      object CheckBox4: TCheckBox
        Left = 20
        Top = 175
        Width = 129
        Height = 17
        TabStop = False
        Caption = 'HORIZONTAL LINE'
        Checked = True
        State = cbChecked
        TabOrder = 6
        OnClick = CheckBox4Click
      end
      object Edit4: TEdit
        Left = 180
        Top = 197
        Width = 60
        Height = 21
        TabStop = False
        AutoSize = False
        TabOrder = 7
        Text = '0'
        OnClick = Edit4Click
        OnKeyDown = Edit4KeyDown
      end
      object Edit5: TEdit
        Left = 180
        Top = 222
        Width = 60
        Height = 21
        TabStop = False
        AutoSize = False
        TabOrder = 8
        Text = '50'
        OnClick = Edit5Click
        OnKeyDown = Edit5KeyDown
      end
      object Edit6: TEdit
        Left = 180
        Top = 247
        Width = 60
        Height = 21
        TabStop = False
        AutoSize = False
        TabOrder = 9
        Text = 'clBlack'
        OnClick = Edit6Click
        OnKeyDown = Edit6KeyDown
      end
    end
    object GroupBox1: TGroupBox
      Left = 5
      Top = 10
      Width = 260
      Height = 136
      Caption = ' CHART TYPES '
      TabOrder = 1
      OnExit = GroupBox1Exit
      object RadioButton1: TRadioButton
        Left = 20
        Top = 25
        Width = 150
        Height = 17
        Caption = 'CANDLE I (OVERLAP)'
        TabOrder = 0
        OnClick = RadioButton1Click
      end
      object RadioButton2: TRadioButton
        Left = 20
        Top = 50
        Width = 150
        Height = 17
        Caption = 'CANDLE II (FLOW)'
        TabOrder = 1
        OnClick = RadioButton2Click
      end
      object RadioButton3: TRadioButton
        Left = 20
        Top = 75
        Width = 150
        Height = 17
        Caption = 'CANDLE && LINES'
        TabOrder = 2
        OnClick = RadioButton3Click
      end
      object RadioButton4: TRadioButton
        Left = 20
        Top = 100
        Width = 113
        Height = 17
        Caption = 'LINE'
        TabOrder = 3
        OnClick = RadioButton4Click
      end
    end
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 677
    Top = 463
  end
end
