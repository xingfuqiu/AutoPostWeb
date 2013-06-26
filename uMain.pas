unit uMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, uPostThd, XPMan, IniFiles;

type
  Tfrm_Main = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    btn_Close: TButton;
    btn_Post: TButton;
    StatusBar1: TStatusBar;
    Label2: TLabel;
    Label1: TLabel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btn_CloseClick(Sender: TObject);
    procedure edt_NumKeyPress(Sender: TObject; var Key: Char);
    procedure btn_PostClick(Sender: TObject);

    Procedure ShowPostStatus(Sender: TObject; bPost: Boolean; PostStatus: Boolean; PostNum: Integer; PostID: Integer; PostTitle: String);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    ini: TInifile;
    AutoPostThd: TPostThd;
    sToday, sYesterday: String;
    iSuccess, iFaild: Integer;
    iTodayPostCount: Integer;
    function GetPostCount: Integer;
  protected
    procedure ShowPostInfo(var Message: TMessage); message WM_SHOW_POSTINFO;
  public
    { Public declarations }
  end;

var
  frm_Main: Tfrm_Main;

implementation

uses Math, uDM;

{$R *.dfm}

procedure Tfrm_Main.FormCreate(Sender: TObject);
begin
  Timer1.Interval := 1000*60;
  //Timer1.Interval := 1000*4;
  iSuccess := 0;
  iFaild := 0;
  StatusBar1.Panels[2].Text := '数据库:'+ IntToStr(GetPostCount);

  sYesterday := FormatDateTime('yyyy-mm-dd', Now);
  ini := TIniFile.Create(ExtractFilePath(ParamStr(0))+'config.ini');
  iTodayPostCount := ini.ReadInteger('date', sYesterday, 100);
  Label1.Caption := sYesterday+ ',未发布：'+IntToStr(iTodayPostCount)+',配置发布：'+IntToStr(iTodayPostCount);
end;

procedure Tfrm_Main.btn_CloseClick(Sender: TObject);
begin
  Close;
end;

procedure Tfrm_Main.edt_NumKeyPress(Sender: TObject; var Key: Char);
begin
  if Not (Key in ['0'..'9', #8]) then
    Key := #0;
end;

procedure Tfrm_Main.btn_PostClick(Sender: TObject);
begin
  if btn_Post.Caption = '开始发布' then
  begin
    iSuccess := 0;
    iFaild := 0;
    Timer1.Enabled := True;
    AutoPostThd := TPostThd.Create(Handle);
    AutoPostThd.OnPostStatus := ShowPostStatus;
  end else
  begin
    Timer1.Enabled := False;
    StatusBar1.Panels[0].Text := '停止发布';
    btn_Post.Caption := '开始发布';
    StatusBar1.Panels[2].Text := '数据库:'+ IntToStr(GetPostCount);
    StatusBar1.Panels[3].Text := '手动停止发布';
    
    if Assigned(AutoPostThd) then
      AutoPostThd.SetBreak;
  end;
end;

procedure Tfrm_Main.ShowPostStatus(Sender: TObject; bPost: Boolean; PostStatus: Boolean; PostNum: Integer; PostID: Integer; PostTitle: String);
begin
  if bPost then
  begin
    StatusBar1.Panels[0].Text := '正在发布';
    StatusBar1.Panels[2].Text := '数据库:'+ IntToStr(GetPostCount);
    btn_Post.Caption := '停止发布';
    Label1.Caption := FormatDateTime('yyyy-mm-dd', Now)+ ',未发布：'+IntToStr(iTodayPostCount-PostNum)+',配置发布：'+IntToStr(iTodayPostCount);

    StatusBar1.Panels[3].Text := '正在发布第'+IntToStr(PostNum)+'条攻略，标题：'+PostTitle;
    if PostStatus then
    begin
      Memo1.Lines.Add(Format('第%d攻略，数据库ID %d, %s 发布成功！', [PostNum, PostID, PostTitle]));
      Inc(iSuccess);
    end else
    begin
      Memo1.Lines.Add(Format('第%d攻略，数据库ID %d, %s 发布失败！', [PostNum, PostID, PostTitle]));
      Inc(iFaild);
    end;
    StatusBar1.Panels[1].Text := Format('成功%d, 失败%d', [iSuccess, iFaild]);

  end else
  begin
    StatusBar1.Panels[0].Text := '停止发布';
    btn_Post.Caption := '开始发布';
    StatusBar1.Panels[2].Text := '数据库:'+ IntToStr(GetPostCount);
    StatusBar1.Panels[3].Text := '发布完成';
  end;
end;

procedure Tfrm_Main.FormDestroy(Sender: TObject);
begin
  ini.Free;
  if Assigned(AutoPostThd) then
    AutoPostThd.SetBreak;
end;

function Tfrm_Main.GetPostCount: Integer;
var
  sSQL: String;
begin
  sSQL := 'select id, title from GameNews where sortId<>1 and isAddLink=1 and gameid >0 and islock=1 order by id DESC';
  Result := DM.OpenTable(DM.qy_SQL, sSQL);
end;

procedure Tfrm_Main.ShowPostInfo(var Message: TMessage);
var
  WaitTime, M, s: Integer;
begin
  WaitTime :=  Message.wParam;
  //iTodayPostCount := Message.lParam;
  M := WaitTime div 60;
  s := WaitTime mod 60;
  Label2.Caption := '发布间隔:'+IntToStr(M)+'分'+IntToStr(s)+'秒';

  //Label1.Caption := FormatDateTime('yyyy-mm-dd', Now)+ ',未发布：'+IntToStr(iTodayPostCount)+',配置发布：'+IntToStr(iTodayPostCount);
end;

procedure Tfrm_Main.Timer1Timer(Sender: TObject);
begin
  sToday := FormatDateTime('yyyy-mm-dd', Now);
  if sToday = sYesterday then
  begin
    Exit;
  end;
  OutputDebugString('AutoPost:第二天，唤醒工作线程！');
  sYesterday := sToday;
  iTodayPostCount := ini.ReadInteger('date', sToday, 100);
  Label1.Caption := sToday+ ',未发布：'+IntToStr(iTodayPostCount)+',配置发布：'+IntToStr(iTodayPostCount);
  AutoPostThd.StartWork;
end;

end.
