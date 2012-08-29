program Spaceball;

uses
  Forms,
  UfrmSpaceBall in '..\UNIT\UfrmSpaceBall.pas' {frmSpaceBall},
  UnitMiniGames in '..\..\API\UnitMiniGames.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Spaceball';
  Application.CreateForm(TfrmSpaceBall, frmSpaceBall);
  Application.Run;
end.
