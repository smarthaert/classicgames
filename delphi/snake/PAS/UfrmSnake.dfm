object frmSnake: TfrmSnake
  Left = 329
  Top = 171
  BorderStyle = bsSingle
  Caption = 'Snake'
  ClientHeight = 483
  ClientWidth = 502
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 40
    Top = 160
    Width = 419
    Height = 112
    Caption = 'Game over'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -96
    Font.Name = 'Brush Script Std'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Visible = False
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 32
    Top = 280
  end
end
