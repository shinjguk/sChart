program Project1;

uses
  Vcl.Forms,
  Unit1 in 'Unit1.pas' {Form1},
  sChart in 'sChart.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'sChart sample';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
