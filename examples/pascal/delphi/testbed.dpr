program testbed;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  PhippsAI in '..\..\..\src\pascal\PhippsAI.pas',
  utestbed in '..\src\utestbed.pas';

begin
  RunTests;
end.
