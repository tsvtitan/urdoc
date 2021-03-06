unit ReceptionFm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, ComCtrls,
  IdHttp, IdUri,
  HTMLDecoder,
  IBQuery, IBDatabase;

type

  THTMLElementClass=class of THTMLElement;

  TReceptionIdHttp=class(TIdHttp)
  end;

  TReceptionForm=class;

  TReceptionThread=class(TThread)
  private
    FLastResult: String;
    FPosition: Integer;
    FMax: Integer;
    FLabelStatus: String;
    FMemoStatus: String;
    FParent: TReceptionForm;
    procedure UpdateProgressBar;
    procedure UpdateLabelStatus;
    procedure UpdateMemo;
  public
    destructor Destroy; override;
    procedure Execute; override;
    procedure Suspend; reintroduce;

    property LastResult: String read FLastResult;
    property Parent: TReceptionForm read FParent write FParent;
  end;

  TReceptionForm = class(TForm)
    pnBottom: TPanel;
    bibClose: TBitBtn;
    LabelSite: TLabel;
    ComboBoxSite: TComboBox;
    ButtonStart: TButton;
    LabelRefresh: TLabel;
    ProgressBarRefresh: TProgressBar;
    LabelCaptionStatus: TLabel;
    LabelStatus: TLabel;
    Memo: TMemo;
    procedure bibCloseClick(Sender: TObject);
    procedure ComboBoxSiteChange(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
  private
    FThread: TReceptionThread;
    procedure ThreadTerminate(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

  end;

var
  ReceptionForm: TReceptionForm;

implementation

uses UDm, StrUtils;

{$R *.dfm}

{ TReceptionThread }

destructor TReceptionThread.Destroy;
begin
  TerminateThread(Handle,0);
  inherited Destroy;
end;

procedure TReceptionThread.UpdateProgressBar;
begin
  FParent.ProgressBarRefresh.Position:=FPosition;
  FParent.ProgressBarRefresh.Max:=FMax;
  FParent.ProgressBarRefresh.Update;
end;

procedure TReceptionThread.UpdateLabelStatus;
begin
  FParent.LabelStatus.Caption:=FLabelStatus;
  FParent.LabelStatus.Update;
end;

procedure TReceptionThread.UpdateMemo;
begin
  FParent.Memo.Lines.Add(Format('%s > %s',[TimeToStr(Time),FMemoStatus]));
  FParent.Memo.Update;
end;

procedure TReceptionThread.Execute;
var
  AllChamberCount: Integer;
  AllNotaryCount: Integer;
const
  UserAgent='Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.2)';
  TagA='A';
  TagTD='TD';
  ParamHref='href';

  procedure EmptyChambers;
  var
    qr: TIBQuery;
    tr: TIBTransaction;
  begin
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
      tr.AddDatabase(dm.IBDbase);
      dm.IBDbase.AddTransaction(tr);
      tr.Params.Text:=DefaultTransactionParamsTwo;
      qr.Database:=dm.IBDbase;
      qr.Transaction:=tr;
      qr.Transaction.Active:=true;

      qr.SQL.Text:='DELETE FROM '+TableNotary;
      qr.ExecSql;
      tr.Commit;

      qr.SQL.Text:='DELETE FROM '+TableChamber;
      qr.ExecSql;
      tr.Commit;

    finally
      qr.Free;
      tr.Free;
    end;
  end;

  function InsertChamber(ChamberName, ChamberAddress, ChamberPresident, ChamberPhones: String; var ChamberId: Integer): Boolean;
  var
    qr: TIBQuery;
    tr: TIBTransaction;
    ID: Integer;
  begin
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
      Result:=false;
      tr.AddDatabase(dm.IBDbase);
      dm.IBDbase.AddTransaction(tr);
      tr.Params.Text:=DefaultTransactionParamsTwo;
      qr.Database:=dm.IBDbase;
      qr.Transaction:=tr;
      qr.Transaction.Active:=true;
      ID:=GetGenId(TableChamber,1);
      qr.SQL.Text:='Insert into '+TableChamber+' (chamber_id,name,address,president,phone,email)'+
                   ' values ('+IntToStr(ID)+
                   ','+QuotedStr(Trim(ChamberName))+
                   ','+QuotedStr(Trim(ChamberAddress))+
                   ','+QuotedStr(Trim(ChamberPresident))+
                   ','+iff(Trim(ChamberPhones)<>'',QuotedStr(Trim(ChamberPhones)),'null')+
                   ',null'+
                   ')';
      qr.ExecSql;
      tr.Commit;

      Result:=true;
      ChamberId:=ID;
    finally
      qr.Free;
      tr.Free;
    end;
  end;

  function InsertNotary(ChamberId: Integer; NotaryFIO, NotaryAddress, NotaryPhones: String): Boolean;
  var
    qr: TIBQuery;
    tr: TIBTransaction;
    ID: Integer;
  begin
    tr:=TIBTransaction.Create(nil);
    qr:=TIBQuery.Create(nil);
    try
      Result:=false;
      tr.AddDatabase(dm.IBDbase);
      dm.IBDbase.AddTransaction(tr);
      tr.Params.Text:=DefaultTransactionParamsTwo;
      qr.Database:=dm.IBDbase;
      qr.Transaction:=tr;
      qr.Transaction.Active:=true;
      ID:=GetGenId(TableNotary,1);
      qr.SQL.Text:='Insert into '+TableNotary+' (notary_id,fio,chamber_id,address,phone,email,county,letter,work_graph,is_helper) '+
                   ' values ('+IntToStr(ID)+
                   ','+QuotedStr(Trim(NotaryFIO))+
                   ','+IntToStr(ChamberId)+
                   ','+QuotedStr(Trim(NotaryAddress))+
                   ','+iff(Trim(NotaryPhones)<>'',QuotedStr(Trim(NotaryPhones)),'null')+
                   ',null'+
                   ',null'+
                   ',null'+
                   ',null'+
                   ',0'+
                   ')';
      qr.ExecSql;
      tr.Commit;

      Result:=true;
    finally
      qr.Free;
      tr.Free;
    end;
  end;

  procedure ReceptionNotaryRu(HttpParent: TReceptionIdHttp; MainHtml: String);

    procedure LoadChamber(ChamberName, ChamberUrl: String);
    const
      SAddress='�����:';
      SPhone='�������:';
      SPresident='���������:';
      SVPresident='����-���������:';

      function GetChildCount(ParentElement: THTMLElement; ParentClass: THTMLElementClass): Integer;
      var
        i: Integer;
        Element: THTMLElement;
      begin
        Result:=0;
        for i:=0 to ParentElement.Childs.Count-1 do begin
          Element:=ParentElement.Childs.Items[i];
          if Element is ParentClass then
            Inc(Result);

          Result:=Result+GetChildCount(Element,ParentClass);
        end;
      end;

      function ChamberExists(Html: String): Boolean;
      begin
        Result:=(AnsiPos(SAddress,Html)<>0) and
                (AnsiPos(SPhone,Html)<>0) and
                (AnsiPos(SPresident,Html)<>0);
      end;

      function NotaryExists(Html: String): Boolean;
      begin
        Result:=(AnsiPos(SAddress,Html)<>0) and
                (AnsiPos(SPhone,Html)<>0);
      end;

      procedure GetChamberParams(Html: String; var ChamberAddress, ChamberPresident, ChamberPhones: String);
      var
        Str: TStringList;
      begin
        Str:=TStringList.Create;
        try
          Str.Text:=Html;

          if Str.Count>0 then begin
            ChamberAddress:=Copy(Str.Strings[0],AnsiPos(SAddress,Str.Strings[0])+Length(SAddress),Length(Str.Strings[0]));
            ChamberAddress:=Trim(ChamberAddress);
          end;

          if Str.Count>1 then begin
            ChamberPhones:=Copy(Str.Strings[1],AnsiPos(SPhone,Str.Strings[1])+Length(SPhone),Length(Str.Strings[1]));
            ChamberPhones:=Trim(ChamberPhones);
          end;

          if Str.Count>2 then begin
            ChamberPresident:=Copy(Str.Strings[2],AnsiPos(SPresident,Str.Strings[2])+Length(SPresident),Length(Str.Strings[2]));
            ChamberPresident:=Trim(ChamberPresident);
          end;

        finally
          Str.Free;
        end;
      end;

      procedure GetNotaryParams(Html: String; var NotaryFIO, NotaryAddress, NotaryPhones: String);
      var
        Str: TStringList;
      begin
        Str:=TStringList.Create;
        try
          Str.Text:=Html;

          if Str.Count>0 then begin
            NotaryFIO:=Trim(Str.Strings[0]);
          end;

          if Str.Count>1 then begin
            NotaryAddress:=Copy(Str.Strings[1],AnsiPos(SAddress,Str.Strings[1])+Length(SAddress),Length(Str.Strings[1]));
            NotaryAddress:=Trim(NotaryAddress);
          end;

          if Str.Count>2 then begin
            NotaryPhones:=Copy(Str.Strings[2],AnsiPos(SPhone,Str.Strings[2])+Length(SPhone),Length(Str.Strings[2]));
            NotaryPhones:=Trim(NotaryPhones);
          end;
        finally
          Str.Free;
        end;
      end;

    var
      Url: String;
      Http: TReceptionIdHttp;
      Parser: THTMLDecoder;
      i,j: Integer;
      ChamberId: Integer;
      Html: String;
      Table: THTMLTable;
      Row: THTMLRow;
      FoundChamber: Boolean;
      ChamberAddress, ChamberPresident, ChamberPhones: String;
      NotaryFIO, NotaryAddress, NotaryPhones: String;
      TableCount: Integer;
      NotaryCount: Integer;
    begin
      FLabelStatus:=Format('%s',[ChamberName]);
      Synchronize(UpdateLabelStatus);

      FMemoStatus:=Format('%s',[ChamberName]);
      Synchronize(UpdateMemo);

      try
        Http:=TReceptionIdHttp.Create(nil);
        Parser:=THTMLDecoder.Create(nil);
        try

          Url:='';
          try
            Http.URL.Host:=HttpParent.URL.Host;
            Http.URL.Port:=HttpParent.URL.Port;
            Http.URL.Protocol:=HttpParent.URL.Protocol;
            Http.URL.Path:=HttpParent.URL.Path;
            Http.URL.Document:=ChamberUrl;
            Url:=Http.URL.GetFullURI([]);
          except
          end;

          Http.Request.UserAgent:=HttpParent.Request.UserAgent;
          Html:=Http.Get(Url);

          {<td>
            <p align="center"><font face="Arial, Helvetica, sans-serif" size="2"><b><br>������������ ������ ���������� ������</b></font></p>
            <p><font face="Arial, Helvetica, sans-serif" size="2">
            <b>�����:</b> 385000, �.������, ��.���������,3<br>
            <b>�������:</b> (8772)57-41-32 �/����<br>
            <b>���������:</b> �������� ������� �����������<br>
            <b>����-���������:</b> ������ ���� ���������<br>
            <b>��������:</b> ������������ ������ ����������<br>
            <b>���������� ����������:</b> 41<br>
            </font></p>
          </td>
          .
          <td><font face="Arial, Helvetica, sans-serif" size="2">
              <b><a href="notary.php?chamberid=006&id=00001" onClick=win(400,350) target=window>������� ������� ����������</a></b><br>
              �����: 385000,�.������,��.����������,�.69<br>
              �������: (8772)53-06-28<br>
          </font></td>}

          ChamberId:=0;
          NotaryCount:=0;
          FoundChamber:=false;
          Parser.Document.LoadHTML(Html,true);
          for i:=0 to Parser.Document.Tables.Count-1 do begin
            Table:=Parser.Document.Tables.Items[i];
            TableCount:=GetChildCount(Table,THTMLTable);
            if TableCount=0 then begin
              for j:=0 to Table.Rows.Count-1 do begin
                Row:=Table.Rows.Items[j];
                if not FoundChamber then begin
                  FoundChamber:=ChamberExists(Row.innerText);
                  if FoundChamber then begin
                    GetChamberParams(Row.innerText,ChamberAddress,ChamberPresident,ChamberPhones);
                    FoundChamber:=InsertChamber(ChamberName,ChamberAddress,ChamberPresident,ChamberPhones,ChamberId);
                  end;
                end else begin
                  if NotaryExists(Row.innerText) then begin
                    GetNotaryParams(Row.innerText,NotaryFIO,NotaryAddress,NotaryPhones);
                    if InsertNotary(ChamberId,NotaryFIO,NotaryAddress,NotaryPhones) then
                      Inc(NotaryCount);
                  end;
                end;
              end;
            end;
          end;

          AllNotaryCount:=AllNotaryCount+NotaryCount;
          FMemoStatus:=Format('������� ����������: %d',[NotaryCount]);
          Synchronize(UpdateMemo);

        finally
          Parser.Free;
          Http.Free;
        end;
      except
      end;
    end;

  var
    Parser: THTMLDecoder;
    i: Integer;
    S: String;
    ChamberAnchors: TStringList;
    Anchor: THTMLAnchor;
  const
    ChamberHref='bd.php?method=view&id=';
  begin
    Parser:=THTMLDecoder.Create(nil);
    ChamberAnchors:=TStringList.Create;
    try
      Parser.Document.LoadHTML(MainHtml,true);

      // <a href="bd.php?method=view&id=006">���������� ���������������</a>
      for i:=0 to Parser.Document.Anchors.Count-1 do begin
        Anchor:=Parser.Document.Anchors.items[i];
        S:=Copy(Anchor.Href,1,Length(ChamberHref));
        if AnsiSameText(S,ChamberHref) then begin
          ChamberAnchors.AddObject(Trim(Anchor.PlainText),Anchor);
        end;
      end;

      AllChamberCount:=ChamberAnchors.Count;
      FMemoStatus:=Format('������� ������������ �����: %d',[AllChamberCount]);
      Synchronize(UpdateMemo);

      FMax:=AllChamberCount;
      for i:=0 to ChamberAnchors.Count-1 do begin
        Anchor:=THTMLAnchor(ChamberAnchors.Objects[i]);
        LoadChamber(ChamberAnchors.Strings[i],Anchor.Href);
        FPosition:=i+1;
        Synchronize(UpdateProgressBar);
      end;
      
    finally
      ChamberAnchors.Free;
      Parser.Free;
    end;
  end;

var
  Url: String;
  Http: TReceptionIdHttp;
  Html: String;
begin
  try
    Http:=TReceptionIdHttp.Create(nil);
    FPosition:=0;
    FMax:=0;
    Synchronize(UpdateProgressBar);
    try


      FLabelStatus:='�������� ������...';
      Synchronize(UpdateLabelStatus);
      FMemoStatus:=FLabelStatus;
      Synchronize(UpdateMemo);
      EmptyChambers;

      Http.Request.UserAgent:=UserAgent;

      Url:='';
      case FParent.ComboBoxSite.ItemIndex of
        0: Url:='http://www.notary.ru/notary/bd.php';
      end;
      FLabelStatus:=Format('������ �� %s',[Url]);
      Synchronize(UpdateLabelStatus);

      Html:=Http.Get(Url);

      FLabelStatus:='������ ���������...';
      Synchronize(UpdateLabelStatus);
      FMemoStatus:=FLabelStatus;
      Synchronize(UpdateMemo);

      AllChamberCount:=0;
      AllNotaryCount:=0;

      case FParent.ComboBoxSite.ItemIndex of
        0: ReceptionNotaryRu(Http,Html);
      end;

      FLastResult:='���������� ������� ���������.'+#13#10+
                   '������� ������������ �����: '+IntToStr(AllChamberCount)+#13#10+
                   '������� ����������: '+IntToStr(AllNotaryCount);
    finally
      Http.Free;
    end;
  except
    On E: Exception do begin
      FLastResult:=E.Message;
    end;
  end;
end;


procedure TReceptionThread.Suspend;
begin
  FLastResult:='���������� ��������.';
  inherited Suspend;
end;

{ TReceptionForm }

constructor TReceptionForm.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ThreadTerminate(nil);
end;

destructor TReceptionForm.Destroy;
begin
  if Assigned(FThread) then
    FreeAndNil(FThread);
  inherited Destroy;
end;

procedure TReceptionForm.ThreadTerminate(Sender: TObject);
begin
  ButtonStart.Caption:='�����';
  LabelCaptionStatus.Visible:=false;
  LabelStatus.Visible:=false;
  LabelRefresh.Visible:=false;
  ProgressBarRefresh.Visible:=false;
  if Assigned(FThread) then begin
    FThread.Terminate;
    if Trim(FThread.LastResult)<>'' then
      ShowInfo(FThread.LastResult);
    FThread:=nil;  
  end;
end;

procedure TReceptionForm.bibCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TReceptionForm.ButtonStartClick(Sender: TObject);
begin
  if Assigned(FThread) then begin
    if not FThread.Suspended then begin
      ButtonStart.Caption:='����������';
      FThread.Suspend
    end else begin
      ButtonStart.Caption:='�����';
      FThread.Resume;
    end;
  end else begin
    ButtonStart.Caption:='�����';
    LabelCaptionStatus.Visible:=true;
    LabelStatus.Visible:=true;
    LabelRefresh.Visible:=true;
    ProgressBarRefresh.Visible:=true;
    FThread:=TReceptionThread.Create(true);
    FThread.Parent:=Self;
    FThread.FreeOnTerminate:=true;
    FThread.OnTerminate:=ThreadTerminate;
    FThread.Resume;
  end;
end;

procedure TReceptionForm.ComboBoxSiteChange(Sender: TObject);
begin
  ButtonStart.Enabled:=ComboBoxSite.ItemIndex<>-1;
end;

end.
