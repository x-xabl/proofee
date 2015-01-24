program proofee;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp
  { you can add units after this };

type

  { TproofeeApplication }

  TproofeeApplication = class(TCustomApplication)
  private
    function IndexFile_v01(const aFileName: tFileName): Integer;
    function ResortFile(const aFileName: tFileName): Integer;
  protected
    procedure DoRun(); override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy(); override;
    procedure WriteHelp(); virtual;
  end;

{ TproofeeApplication }

procedure TproofeeApplication.DoRun();
var
  vFileName: tFileName;
  vCount: Integer;
begin
  if HasOption('h','help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;

  if HasOption('r','resort') then begin
    vFileName := GetOptionValue('r','resort');
    vCount := ResortFile(vFileName);
    Writeln(vCount);
  end;

  if HasOption('i','index') then begin
    vFileName := GetOptionValue('i','index');
    vCount := IndexFile_v01(vFileName);
    Writeln(vCount);
  end;

  // stop program loop
  Terminate;
end;

function TproofeeApplication.ResortFile(const aFileName: tFileName): Integer;
var
  vStringList: tStringList;
begin
  vStringList := tStringList.Create();
  try
    vStringList.LoadFromFile(aFileName);
    vStringList.Sort();
    vStringList.SaveToFile(aFileName);
    Result := vStringList.Count;
  finally
    vStringList.Free();
  end;

end;

type
  // tproofeeIndex = class
  // end;

  tproofeeTag = record
    Tag: string;
    Items: array of Integer;
  end;


function TproofeeApplication.IndexFile_v01(const aFileName: tFileName): Integer;
var
  vStringList: tStringList;
  vLineList: tStringList;
  vproofeeTag: ^tproofeeTag;
  vIndex: array of tproofeeTag;
  vI, vT, vJ: Integer;
  vTag: string;
begin
  Result := 0;
  try
    vIndex := nil;
    vStringList := tStringList.Create();
    try
      vLineList := tStringList.Create();
      try
        vStringList.LoadFromFile(aFileName);
        for vI := 0 to vStringList.Count - 1 do begin
          vLineList.Clear();
          vLineList.CommaText := vStringList.Strings[vI];
          if (1 < vLineList.Count) then begin
            for vT := 1 to vLineList.Count - 1 do begin
              vTag := UpperCase(Trim(vLineList.Strings[vT]));
              vproofeeTag := nil;
              if (EmptyStr <> vTag) then begin
                if (0 < Length(vIndex)) then begin
                  for vJ := 0 to Length(vIndex) - 1 do begin
                    if (vIndex[vJ].Tag = vTag) then begin
                      vproofeeTag := @(vIndex[vJ]);
                      Break;
                    end
                  end;
                end;
                if (not Assigned(vproofeeTag)) then begin
                  SetLength(vIndex, Length(vIndex) + 1);
                  vproofeeTag := @(vIndex[Length(vIndex) - 1]);
                  vproofeeTag^.Tag := vTag;
                end;
                SetLength(vproofeeTag^.Items, Length(vproofeeTag^.Items) + 1);
                vproofeeTag^.Items[Length(vproofeeTag^.Items) - 1] := vI;
                Inc(Result);
              end;
            end;
          end;
        end;
      finally
        vLineList.Free();
      end;
    finally
      vStringList.Free();
    end;
  finally
    for vI := 0 to Length(vIndex) - 1 do begin
      Writeln(vIndex[vI].Tag, ' ', Length(vIndex[vI].Items));
    end;
    SetLength(vIndex, 0);
  end
end;



constructor TproofeeApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TproofeeApplication.Destroy();
begin
  inherited Destroy;
end;

procedure TproofeeApplication.WriteHelp();
begin
  { add your help code here }
  writeln('Usage: ',ExeName,' -h');
end;

var
  Application: TproofeeApplication;
begin
  Application:=TproofeeApplication.Create(nil);
  Application.Run;
  Application.Free;
end.

