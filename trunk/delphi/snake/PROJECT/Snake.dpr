program Snake;

uses
  Forms,
  UfrmCanvas in '..\PAS\UfrmCanvas.pas' {frmCanvas},
  UnitMiniGames in '..\..\API\UnitMiniGames.pas',
  UfrmSpaceBall in '..\PAS\UfrmSpaceBall.pas' {frmSpaceBall};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmSpaceBall, frmSpaceBall);
  Application.Run;
end.
