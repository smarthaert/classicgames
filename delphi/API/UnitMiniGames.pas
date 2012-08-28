unit UnitMiniGames;

interface
  uses SysUtils, Graphics, Classes, Windows;
type
  EventOnColision = procedure() of object;
  IColisionBox = Interface
    procedure colide(obj : IColisionBox);
    function  check(obj : IColisionBox):boolean;
    function  getHash : Integer;
  end;//ICOlisionBox

  IPrintable = Interface
    procedure paint(canvas : tCanvas);
  end;

  ITickable = Interface
    procedure tick(time : LongInt);
  end;

  TBlock = class(TInterfacedObject, IColisionBox, IPrintable)
  private
    _color : TColor;
    _location : TPoint;
    _width : Integer;
    _height : Integer;
    _visible : boolean;
    FonColision: EventOnColision;
    procedure SetonColision(const Value: EventOnColision);
  public
    function  getX : Integer;
    function  getY : Integer;
    function  getHash : Integer;
    function  getPointLocation : TPoint;
    procedure setColor(c : Tcolor);
    function  getColor():TColor;
    procedure setLocation(x, y : Integer);
    procedure increaseLocation(x, y : Integer);
    procedure paint(canvas : tCanvas);
    procedure colide(obj : IColisionBox);
    function  check(obj : IColisionBox):boolean;
    procedure doColision(b : TBlock);
    procedure setSize(w, h : Integer);
    constructor Create(x, y : Integer);
  published
    property onColision : EventOnColision read FonColision write SetonColision;
  end;//TBlock

  TBall = class(TBlock, ITickable)
  private
    _direction : TPoint;
  protected
  public
    procedure tick(time : LongInt);
    procedure checkColision();
    procedure up();
    procedure reset();
    constructor Create();
  published
  end;//TBall

  TBlocks = class
  private
     _blocks : TList;
     _index : Word;
     _count : Word;
     _maxBlocks : Integer;
     _visible : boolean;
     function  getHash(point : TPoint):Integer;Overload;
     function  getHash(index : Integer):Integer;Overload;
     procedure changeLocation(a, b : Integer);
     function  getLocationToInsert(hash : Integer): Integer;
     function  getVisible: boolean;
     function  getMinHashIndex(start : Integer = 0):Integer;
  public
     procedure sort;
     procedure add(x,y : Integer);Overload;
     procedure add(point : TPoint);Overload;
     procedure delete(index : word);Overload;
     procedure delete(x,y : Integer);Overload;
     procedure insert(index, x, y : Integer);
     procedure setLocation(index, x, y : Integer);
     function  find(x,y : Integer; index : word ) : Integer;Overload;
     function  find(p : TPoint; _start : Integer = 0; _end : Integer = -1): Integer;Overload;
     function  getPoint(index : Word): Tpoint;
     procedure increaseValues(index : word; x,y : integer);
     function  getCount : Word;
     function  getIndex : Integer;
     function  getX(index : word) : Integer;
     function  getY(index : word) : Integer;
     function  getRectToDraw(index : Integer):Trect;
     procedure paint(c : TCanvas);
     procedure clear;
     constructor Create();
     destructor Destroy;Override;
  end;//TBlocks

  TRacket = class(TInterfacedObject , ITickable, IPrintable)
  private
    _location : TPoint;
    _direction : TPoint;
    _width, _height : Integer;
    _timeToResetDirection : integer;
    _increment : double;
  protected
  public
    function  getHorizontalDisplacement: integer;
    procedure left;
    procedure right;
    procedure reset();
    function checkColision(x,y,w,h : integer): boolean;
    procedure tick(time : LongInt);
    procedure paint(c : Tcanvas);
    constructor Create();
  published
  end;

  TSnake = class
  private
    direction : TPoint;
    blocks : TBlocks;
  public
    function  eat(food : TPoint): TPoint;
    procedure left;
    procedure right;
    procedure top;
    procedure dow;
    procedure Tiker;
    function  getX(index : Integer): Integer;
    function  getY(index : Integer): Integer;
    function  getBlockCount : Integer;
    procedure paint(_canvas : TCanvas);
    function  checkColision(point : TPoint):boolean;
    function  checkSelfColision : boolean;
    constructor Create();
    destructor Destroy;Override;
  end;//TSnake
implementation

uses Types;

{ TSnake }

function TSnake.checkColision(point: TPoint): boolean;
begin
  result := (blocks.getX(0) = point.x) and (blocks.getY(0) = point.y);
end;

function TSnake.checkSelfColision: boolean;
begin
  result := blocks.find(blocks.getX(0), blocks.getY(0),1) > -1;
end;

constructor TSnake.Create;
begin
  inherited;
  direction.X := 1;
  direction.y := 0;
  blocks := TBlocks.create();
  blocks.add(50,50);//define a posição inicial
  blocks.add(40,50); 
end;

destructor TSnake.Destroy;
begin
  FreeAndNil(blocks);
  inherited;
end;

procedure TSnake.dow;
begin
  if (direction.x = 0) and (direction.y = -1) then exit;
  direction.X := 0;
  direction.y := 1;
end;

function TSnake.eat(food: TPoint): TPoint;
var incX, incY, lastX, lastY : Integer;
begin
  incX := 0;
  incY := 0;
  lastX := blocks.getX(blocks.getCount - 1);
  lastY := blocks.getY(blocks.getCount - 1);
  if blocks.getCount = 1 then
  begin
    incx := direction.X * (-1);
    incY := direction.Y * (-1);
  end;
  result.x := lastx + incx * 10;
  result.y := lasty + incy * 10;
  blocks.add(result.x, result.y);
end;

function TSnake.getBlockCount: Integer;
begin
  result := blocks.getCount;
end;

function TSnake.getX(index: Integer): Integer;
begin
  result := blocks.getX(index);
end;

function TSnake.getY(index: Integer): Integer;
begin
  result := blocks.getY(index);
end;

procedure TSnake.left;
begin
  if (direction.x = 1) and (direction.y = 0) then exit;
  direction.X := -1;
  direction.y := 0;
end;

procedure TSnake.paint(_canvas: TCanvas);
begin
  blocks.paint(_canvas);
end;

procedure TSnake.right;
begin
  if (direction.x = -1) and (direction.y = 0) then exit;
  direction.X := 1;
  direction.y := 0;
end;

procedure TSnake.Tiker;
var i : word;
    _incX, _incY, _destX, _destY : Integer;
begin
  _incX := direction.X * 10;
  _incY := direction.Y * 10;
  _destX := blocks.getX(0) + _incX;
  _destY := blocks.getY(0) + _incY;
  if (_destX < 0) or (_destx > 500) or
     (_destY < 0) or (_destY > 500) or
     (blocks.find(_destX, _destY, 1) = -1) then
  raise Exception.Create('Game over');
  if blocks.getcount = 0 then exit;
  for i := blocks.getcount - 1 downto 1 do
    blocks.setLocation(i, blocks.getX(i-1), blocks.getY(i - 1));
  blocks.increaseValues(0, _incX, _incY);    
end;

procedure TSnake.top;
begin
  if (direction.x = 0) and (direction.y = 1) then exit;
  direction.X := 0;
  direction.y := -1;
end;

{ TBlocks }

procedure TBlocks.add(x, y: Integer);
begin
  try
  if _blocks.Count >= _maxBlocks then raise Exception.Create('Stack overflow'#13'procedure TBlocks.add(x, y: Integer);');
  _blocks.Add(TBlock.Create(x,y));
  except end;
end;

procedure TBlocks.add(point: TPoint);
begin
  add(point.x , point.y);
end;

procedure TBlocks.changeLocation(a, b: Integer);
begin
  _blocks.Exchange(a,b);
end;

procedure TBlocks.clear;
var temp : TBlock;
begin
  try
     while _blocks.Count > 0 do
     begin
       temp := TBLock(_blocks.Items[0]);
       _blocks.Remove(temp);
       FreeAndNil(temp);
     end;
  except

  end;
end;

function compare(a, b: Pointer): Integer;
var _a ,_b : TBlock;
begin
  _a := TBlock(a);
  _b := TBlock(b);
  if _a.getHash > _b.getHash then
    result := 1
  else if _a.getHash < _b.getHash then
    result := -1
  else result := 0;
end;

constructor TBlocks.Create();
begin
  _maxBlocks := 2500;
  _index := 0;
  _count := 0;
  _blocks := TList.create;
//  _blocks.Capacity := 2500;
end;

procedure TBlocks.delete(index: word);
var temp : TObject;
begin
  temp := _blocks.items[index];
  _blocks.remove(temp);
  FreeAndNil(temp);
end;

procedure TBlocks.delete(x, y: Integer);
var _x : Integer;
begin
  _x := find(x,y, 0);
  if _x > -1 then
    delete(_x);
end;

destructor TBlocks.Destroy;
begin
  self.clear;
  _blocks.Free;
  _blocks := nil;
  inherited;
end;

function TBlocks.find(x, y: Integer; index : word): Integer;
var i : Word;
  temp : TBlock;
begin
  if (index > _blocks.Count - 1) or (index < 0) then raise exception.create('Stack Overflow'#13 +
   'function TBlocks.find(x, y: Integer; index : word = 0): Integer;');
  result := -1;
  for i := index to _blocks.Count -1 do
  begin
    temp := TBlock(_blocks.items[i]);
    if (temp.getX = X) and (temp.getY = y) then
    begin
      result := i;
      break;
    end;
  end;//for
end;

function TBlocks.find(p : TPoint;_start : Integer = 0; _end : Integer = -1): Integer;
var mid, _a, _b : Integer;
begin
  if _end < 0 then _end := _count;
  result := -1;
  if _start >= _end then
     exit;
  mid := _start + trunc((_end - _start) / 2);
  _a := getHash(p);
  _b := getHash(mid);
  if _a = _b then
    result := mid
  else
   if _b < _a then result := find(p, mid + 1, _end)
     else result := find( p, _start, mid );
end;

function TBlocks.getCount: Word;
begin
  result := _blocks.Count;
end;

function TBlocks.getHash(point: TPoint): Integer;
begin
  result := point.y * 50 + point.X;
end;

function TBlocks.getHash(index: Integer): Integer;
begin
  result := TBlock(_blocks.items[index]).getHash;
end;

function TBlocks.getIndex: Integer;
begin
  result := _index;
end;

function TBlocks.getLocationToInsert(hash: Integer): Integer;
var i : Integer;
begin
  result := 0;
  for i := 0 to _count - 1 do
  begin
    result := i;
    if (i = _count -1) then exit;
    if ( (getHash(i) > hash) and (getHash(i+1) > hash) ) then
      exit;
  end;
end;

(**
  Retorna o menor Hash apartir da posição informada.
  Este método é especialmente útil para o ordenamento boobleSort
**)
function TBlocks.getMinHashIndex(start: Integer): Integer;
var i : Integer;
begin
  result := 2147483647;//Max value of integer
  for i := start to _count - 1 do
     if getHash(i) < result then result := getHash(i);
end;

function TBlocks.getPoint(index: Word): Tpoint;
var temp : TBlock;
begin
  temp := TBlock(_blocks.items[index]);
  result.x := temp.getX;
  result.y := temp.gety;
end;

function TBlocks.getRectToDraw(index: Integer): Trect;
begin
  result.Left  := getX(index);
  result.Top   := getY(index);
  result.Right := result.Left + 10;
  result.Bottom:=result.Top + 10;
end;

function TBlocks.getVisible: boolean;
begin
  result := _visible;
end;

function TBlocks.getX(index: word): Integer;
begin
  result := TBlock(_blocks.Items[index]).getX;
end;

function TBlocks.getY(index: word): Integer;
begin
  result := TBlock(_blocks.Items[index]).getY;
end;

procedure TBlocks.increaseValues(index: word; x, y: integer);
begin
  TBlock(_blocks.items[index]).increaseLocation(x, y);
end;

procedure TBlocks.insert(index, x, y: Integer);
begin
  _blocks.Insert(index, TBlock.Create(x,y));
end;

procedure TBlocks.paint(c : TCanvas);
var i : Integer;
begin
  for i := 0 to _blocks.Count - 1 do
    TBlock(_blocks.items[i]).paint(c);
end;

procedure TBlocks.setLocation(index, x, y: Integer);
begin
  TBLock(_blocks.items[index]).setLocation(x, y);
end;

procedure TBlocks.sort;
begin
  _blocks.Sort(compare);
end;

{ TBlock }

function TBlock.check(obj: IColisionBox): boolean;
begin
   result := obj.getHash = self.getHash;  
end;

procedure TBlock.colide(obj: IColisionBox);
begin

end;

constructor TBlock.Create(x, y : Integer);
begin
  _color  := clRed;
  _width  := 10;
  _height := 10;
  _location.X := x;
  _location.y := y;
  _visible := true;
end;

procedure TBlock.doColision(b: TBlock);
begin

end;

function TBlock.getColor: TColor;
begin
  result := _color;
end;

function TBlock.getHash: Integer;
begin
  result := _location.y * 50 + _location.x;
end;

function TBlock.getPointLocation: TPoint;
begin
  result.x := _location.x;
  result.y := _location.y;
end;

function TBlock.getX: Integer;
begin
  result := _location.x;
end;

function TBlock.getY: Integer;
begin
  result := _location.Y;
end;

procedure TBlock.increaseLocation(x, y: Integer);
begin
  _location.x := _location.x + x;
  _location.y := _location.y + y;
end;

procedure TBlock.paint(canvas: tCanvas);
begin
  canvas.Pen.Color := $0;
  canvas.Brush.color := _color;
{  canvas.FillRect(Rect(_location.x,
                       _location.y,
                       _width,
                       _height));
   }
  canvas.Rectangle(_location.x,
                   _location.y,
                   _location.x + _width,
                   _location.y + _height);
end;

procedure TBlock.setColor(c: Tcolor);
begin
  _color := c;
end;

procedure TBlock.setLocation(x, y: Integer);
begin
  _location.x := x;
  _location.y := y;
end;

procedure TBlock.SetonColision(const Value: EventOnColision);
begin
  FonColision := Value;
end;

procedure TBlock.setSize(w, h: Integer);
begin
   _width := w;
   _height:= h;
end;

{ TBall }

procedure TBall.checkColision;
begin
  if (getX >= 490) then _direction.x := -1;
  if (getX <= 0 ) then _direction.x := 1;
  if (getY >= 490) then raise Exception.Create('Game over'); //_direction.y := -1;
  if (getY <= 0)  then _direction.y := 1;
end;

constructor TBall.Create;
begin
  reset();
end;

procedure TBall.reset;
begin
  _direction.x := -1;
  _direction.y := 1;
  setLocation(200, 200);
  setSize(10,10);
end;

procedure TBall.tick(time: Integer);
begin
  checkColision();
  self.increaseLocation(_direction.x * 2, _direction.y * 2);
end;

procedure TBall.up;
begin
   _direction.y := -1;
end;

{ TRacket }

function TRacket.checkColision(x, y, w, h: integer): boolean;
begin
  result := (x + w>= _location.X) and (x <= _location.X + _width) and
     (y + h>= _location.Y) and (y <= _location.y + _height);
end;

constructor TRacket.Create;
begin
  reset();
end;

function TRacket.getHorizontalDisplacement: integer;
begin
  result := _direction.X;
end;

procedure TRacket.left;
begin
  _direction.x := _direction.x -3;
  _timeToResetDirection := 5;
end;

procedure TRacket.paint(c: Tcanvas);
begin
  c.Brush.Color := clblue;
  c.FillRect(rect(_location.x,
                  _location.y,
                  _location.x + _width,
                  _location.y + _height));
end;

procedure TRacket.reset;
begin
  _increment := 0;
  _width := 80;
  _height := 10;
  _location.y := 440;
  _location.x := round(500/2 - _width / 2);
end;

procedure TRacket.right;
begin
  _direction.x := _direction.x + 3;
  _timeToResetDirection := 5;  
end;

procedure TRacket.tick(time: Integer);
begin
  _location.x := _location.x + _direction.x;
  if _timeToResetDirection > 0 then dec(_timeToResetDirection)
  else _direction.x := 0;

end;

end.
