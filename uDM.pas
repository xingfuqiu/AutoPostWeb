unit uDM;

interface

uses
  SysUtils, Classes, DB, ADODB;


type
  TDM = class(TDataModule)
    conn_SQL: TADOConnection;
    qy_SQL: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function Conn_sqlDB: Boolean;
    function OpenTable(aQuery: TADOQuery; aSQL: string): Integer;
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{$R *.dfm}

function TDM.Conn_sqlDB: Boolean;
var
  sPath: string;
begin
  Result := False;
  sPath := ExtractFilePath(ParamStr(0));
  try
    conn_SQL.Connected := false;
    conn_SQL.ConnectionString := 'FILE NAME='+sPath+'conn.udl';
    conn_SQL.Provider := sPath+'conn.udl';
    conn_SQL.Connected := true;
    Result := True;
  except
    //showmessage('连接失败,请重新配置conn.udl文件');
    //EXIT;
  end;
end;

function TDM.OpenTable(aQuery: TADOQuery; aSQL: string): Integer;
begin
  try
    with aQuery do
    begin
       Close;
       SQL.Clear;
       SQL.Add(aSQL);
       Open;
       Result:= RecordCount;
    end;
  except
    Result := 0;
  end;
end;

procedure TDM.DataModuleCreate(Sender: TObject);
begin
  Conn_sqlDB;
end;

end.
