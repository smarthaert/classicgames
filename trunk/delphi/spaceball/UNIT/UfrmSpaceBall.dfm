object frmSpaceBall: TfrmSpaceBall
  Left = 297
  Top = 270
  Width = 580
  Height = 520
  Caption = 'SpaceBall'
  Color = clBtnFace
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
    Left = 24
    Top = 104
    Width = 550
    Height = 117
    Caption = 'Game over'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -96
    Font.Name = 'Magneto'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    Visible = False
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 16
    Top = 112
  end
  object TimerRender: TTimer
    Enabled = False
    Interval = 500
    OnTimer = TimerRenderTimer
    Left = 280
    Top = 248
  end
end
