program I2CTest;

uses
  Forms,
  I2CMain in 'I2CMain.pas' {Form1};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
