unit UfrmSpaceBall;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, UnitMiniGames, StdCtrls;

type
  TfrmSpaceBall = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    TimerRender: TTimer;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TimerRenderTimer(Sender: TObject);
  private
    { Private declarations }
    _time : LongInt;
    ball : Tball;
    racket : TRacket;
    procedure reset();
    procedure clearScreen();
    procedure doGameOver();
    procedure checkColision();
  public
    { Public declarations }
  end;

var
  frmSpaceBall: TfrmSpaceBall;

implementation

{$R *.dfm}

procedure TfrmSpaceBall.Timer1Timer(Sender: TObject);
begin
  inc(_time);
  self.clearScreen();
  try
    racket.tick(_time);
    ball.tick(_time);
    ball.tick(_time);
    checkColision();
    racket.paint(self.canvas);
    ball.paint(self.canvas);
  except
    doGameOver();
  end;
end;

procedure TfrmSpaceBall.FormCreate(Sender: TObject);
begin
  DoubleBuffered := true;
   ball := TBall.Create;
   racket := TRacket.Create;
   reset();
end;

procedure TfrmSpaceBall.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  try
    FreeAndNil(ball);
    FreeAndNil(racket);
  except

  end;
end;

procedure TfrmSpaceBall.clearScreen;
begin
   self.canvas.Brush.color := Self.Color;
   self.Canvas.FillRect(rect(0,0, 500,500));
end;

procedure TfrmSpaceBall.reset;
begin
   _time := 0;
   ball.reset();
   racket.reset();
   clearScreen();
   label1.visible := false;
   timer1.Enabled := true;
   timerRender.Enabled := true;
end;

procedure TfrmSpaceBall.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = 37 then //left
     racket.left
   else if key = 39 then //right
     racket.right;
end;

procedure TfrmSpaceBall.TimerRenderTimer(Sender: TObject);
begin
  ball.paint(self.canvas);
  racket.paint(self.canvas);
end;

procedure TfrmSpaceBall.doGameOver;
begin
   timer1.enabled := false;
   timerRender.enabled := false;
   label1.visible := true;
   self.Repaint;
end;

procedure TfrmSpaceBall.checkColision;
begin
  if racket.checkColision(ball.getX, ball.getY, 10 , 10) then
  begin
    ball.increaseLocation(racket.getHorizontalDisplacement, 0);
    ball.up();
  end;
end;

end.
