program Snake;

uses
  Forms,
  UfrmSnake in '..\PAS\UfrmSnake.pas' {frmSnake},
  UnitMiniGames in '..\..\API\UnitMiniGames.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Snake';
  Application.CreateForm(TfrmSnake, frmSnake);
  Application.Run;
end.
