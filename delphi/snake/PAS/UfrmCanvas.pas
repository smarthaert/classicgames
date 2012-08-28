unit UfrmCanvas;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms, Dialogs, ExtCtrls,
  UnitMiniGames, StdCtrls;

type
  TfrmCanvas = class(TForm)
    Timer1: TTimer;
    Label1: TLabel;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure resetBlocks;
  private
    { Private declarations }
    food : TBlock;
    snake : TSnake;
    blocks : TBlocks;
    procedure resetFood;
    procedure chekFood;
    procedure clearCanvas;
    procedure doGameOver;
  public
    { Public declarations }
  end;

var
  frmCanvas: TfrmCanvas;

implementation

uses Types, Math;

{$R *.dfm}

procedure TfrmCanvas.Timer1Timer(Sender: TObject);
var result : TPoint;
begin
  clearCanvas();
  food.paint(self.canvas);
  //adiciona o ultimo bloco do personagem que será liberado após sua movimentação
  blocks.add(snake.getX(snake.getBlockCount-1), snake.getY(snake.getBlockCount - 1));
  if snake.checkColision(food.getPointLocation) then
  begin
    result := snake.eat(food.getPointLocation);
    blocks.delete(result.x, result.y);//remove o bloco no qual estava o alimento
    resetFood();
  end;
  try
    snake.Tiker;
    blocks.delete(snake.getX(0), snake.getY(0));//remove o bloco para o qual o personagem se movimentou
    snake.paint(self.Canvas);
  except
    doGameOver();
  end;
end;

procedure TfrmCanvas.FormCreate(Sender: TObject);
begin
   DoubleBuffered := true;
   food := TBlock.create(15,15);

   Randomize;
   food.setColor(clGreen);
   blocks := TBlocks.create;
   snake := TSnake.Create();
   resetBlocks();
   blocks.delete(snake.getX(0), snake.getY(0));
   resetFood();
end;

procedure TfrmCanvas.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  try
    FreeAndNil(blocks);
    FreeAndNil(snake);
    FreeAndNil(food);
  except

  end;
end;

procedure TfrmCanvas.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    37 : snake.left;
    38 : snake.top;
    39 : snake.right;
    40 : snake.dow;
  end;//case
end;

procedure TfrmCanvas.chekFood;
begin
  if snake.checkColision(food.getPointLocation) then
  begin
    snake.eat(food.getPointLocation);
    blocks.delete(food.getX, food.getY);
    resetFood();
  end;
end;

procedure TfrmCanvas.resetFood;
var index : integer;
begin
  index := RandomRange(0, blocks.getCount - 1);
  food.setLocation(blocks.getX(index), blocks.getY(index));
  food.paint(self.Canvas);
end;

procedure TfrmCanvas.resetBlocks;
var x , y : Integer;
begin
   blocks.clear;
   y := 0;
  for y := 0 to 49  do
    for x := 0 to 49 do
     blocks.add(x * 10, y * 10);
end;

procedure TfrmCanvas.clearCanvas;
begin
  canvas.brush.color := clwhite;
  Canvas.FillRect(Rect(0,0,500,500));
end;

procedure TfrmCanvas.doGameOver;
begin
  label1.visible := true;
  Timer1.Enabled := false;
end;

end.
