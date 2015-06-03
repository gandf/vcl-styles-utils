program VCLStylePreview;

uses
  SysUtils,
  IOUTils,
  Types,
  Vcl.Forms,
  uMain in 'uMain.pas' {FrmMain},
  Vcl.Themes,
  Windows,
  Vcl.Styles,
  Vcl.Styles.Ext in '..\Common\Vcl.Styles.Ext.pas';

{$R *.res}

function PathCanonicalize(lpszDst: PChar; lpszSrc: PChar): LongBool; stdcall; external 'shlwapi.dll' name 'PathCanonicalizeW';

function ResolvePath(const RelPath, BasePath: string): string;
var
  lpszDst: array[0..MAX_PATH-1] of char;
begin
  PathCanonicalize(@lpszDst[0], PChar(IncludeTrailingPathDelimiter(BasePath) + RelPath));
  Exit(lpszDst);
end;

procedure LoadVCLStyles;
var
  f, s : string;
  LFiles : TStringDynArray;
begin
  s:=ExtractFilePath(ParamStr(0));
  LFiles:=TDirectory.GetFiles(s, '*.vsf');
  if Length(LFiles)>0 then
   for f in TDirectory.GetFiles(s, '*.vsf') do
     TStyleManager.LoadFromFile(f)
  else
  begin
    s:=ResolvePath('..\Styles',ExtractFilePath(ParamStr(0)));
    if DirectoryExists(s) then
    for f in TDirectory.GetFiles(s, '*.vsf') do
      TStyleManager.LoadFromFile(f);
  end;
end;

begin
  LoadVCLStyles;
  TStyleManager.TrySetStyle('Auric');
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmMain, FrmMain);
  Application.Run;
end.