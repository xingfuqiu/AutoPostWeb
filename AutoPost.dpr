program AutoPost;

uses
  Forms,
  uMain in 'uMain.pas' {frm_Main},
  uDM in 'uDM.pas' {DM: TDataModule},
  uPostThd in 'uPostThd.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDM, DM);
  Application.CreateForm(Tfrm_Main, frm_Main);
  Application.Run;
end.
