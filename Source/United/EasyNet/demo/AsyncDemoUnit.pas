unit AsyncDemoUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, PRInternetAccess, StdCtrls, ComCtrls, ExtCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Memo1: TMemo;
    Panel2: TPanel;
    Memo2: TMemo;
    Panel3: TPanel;
    Memo3: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    InternetSession1: TInternetSession;
    InternetConnection1: TInternetConnection;
    InternetHTTPRequest1: TInternetHTTPRequest;
    InternetHTTPRequest2: TInternetHTTPRequest;
    InternetHTTPRequest3: TInternetHTTPRequest;
    InternetConnection2: TInternetConnection;
    InternetConnection3: TInternetConnection;
    Panel01: TPanel;
    Panel02: TPanel;
    Panel03: TPanel;
    InternetSession2: TInternetSession;
    InternetSession3: TInternetSession;
    Label1: TLabel;
    Label2: TLabel;
    procedure InternetHTTPRequest1Loaded(Sender: TObject; hInet: Pointer;
      Stream: TStream);
    procedure InternetHTTPRequest2Loaded(Sender: TObject; hInet: Pointer;
      Stream: TStream);
    procedure InternetHTTPRequest3Loaded(Sender: TObject; hInet: Pointer;
      Stream: TStream);
    procedure Button1Click(Sender: TObject);
    procedure InternetHTTPRequest1Redirect(Sender: TObject; hInet: Pointer;
      OldURL, NewURL: String; var cancel: Boolean);
    procedure InternetHTTPRequest1Progress(Sender: TObject; hInet: Pointer;
      Progress, ProgressMax, StatusCode: Cardinal; StatusText: String;
      ElapsedTime, EstimatedTime: TDateTime; Speed: Extended;
      SpeedUnit: String);
    procedure InternetHTTPRequest2Progress(Sender: TObject; hInet: Pointer;
      Progress, ProgressMax, StatusCode: Cardinal; StatusText: String;
      ElapsedTime, EstimatedTime: TDateTime; Speed: Extended;
      SpeedUnit: String);
    procedure InternetHTTPRequest3Progress(Sender: TObject; hInet: Pointer;
      Progress, ProgressMax, StatusCode: Cardinal; StatusText: String;
      ElapsedTime, EstimatedTime: TDateTime; Speed: Extended;
      SpeedUnit: String);
    procedure InternetHTTPRequest2Redirect(Sender: TObject; hInet: Pointer;
      OldURL, NewURL: String; var cancel: Boolean);
    procedure InternetHTTPRequest3Redirect(Sender: TObject; hInet: Pointer;
      OldURL, NewURL: String; var cancel: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.InternetHTTPRequest1Loaded(Sender: TObject;
  hInet: Pointer; Stream: TStream);
begin
  memo1.Text:=TStringstream(Stream).DataString;

end;

procedure TForm1.InternetHTTPRequest2Loaded(Sender: TObject;
  hInet: Pointer; Stream: TStream);
begin
  memo3.Text:=TStringstream(Stream).DataString;

end;

procedure TForm1.InternetHTTPRequest3Loaded(Sender: TObject;
  hInet: Pointer; Stream: TStream);
begin
  memo2.Text:=TStringstream(Stream).DataString;

end;

procedure TForm1.Button1Click(Sender: TObject);
var ss1,ss2,ss3:TStringstream;
begin
  InternetHTTPRequest1.URL:=edit1.Text;
  InternetHTTPRequest2.URL:=edit2.Text;
  InternetHTTPRequest3.URL:=edit3.Text;
  ss1:=TStringstream.Create('');
  ss2:=TStringstream.Create('');
  ss3:=TStringstream.Create('');
  InternetHTTPRequest1.OpenRequest;
  InternetHTTPRequest2.OpenRequest;
  InternetHTTPRequest3.OpenRequest;

  InternetHTTPRequest1.SendRequest(ss1);
  InternetHTTPRequest2.SendRequest(ss2);
  InternetHTTPRequest3.SendRequest(ss3);
  {while InternetHTTPRequest1.AsyncStatus<>asFinished do
    Application.ProcessMessages;
  InternetHTTPRequest1.CloseRequest;
  while InternetHTTPRequest2.AsyncStatus<>asFinished do
    Application.ProcessMessages;
  InternetHTTPRequest2.CloseRequest;
  while InternetHTTPRequest3.AsyncStatus<>asFinished do
    Application.ProcessMessages;
  InternetHTTPRequest3.CloseRequest;
  }
end;

procedure TForm1.InternetHTTPRequest1Redirect(Sender: TObject;
  hInet: Pointer; OldURL, NewURL: String; var cancel: Boolean);
begin
  edit1.Text:=newurl;
end;

procedure TForm1.InternetHTTPRequest1Progress(Sender: TObject;
  hInet: Pointer; Progress, ProgressMax, StatusCode: Cardinal;
  StatusText: String; ElapsedTime, EstimatedTime: TDateTime;
  Speed: Extended; SpeedUnit: String);
begin
   panel01.Caption:=StatusText+' '+inttostr(Progress)+'/'+inttostr(ProgressMax);
   Application.ProcessMessages;
end;

procedure TForm1.InternetHTTPRequest2Progress(Sender: TObject;
  hInet: Pointer; Progress, ProgressMax, StatusCode: Cardinal;
  StatusText: String; ElapsedTime, EstimatedTime: TDateTime;
  Speed: Extended; SpeedUnit: String);
begin
   panel02.Caption:=StatusText+' '+inttostr(Progress)+'/'+inttostr(ProgressMax);
   Application.ProcessMessages;
end;

procedure TForm1.InternetHTTPRequest3Progress(Sender: TObject;
  hInet: Pointer; Progress, ProgressMax, StatusCode: Cardinal;
  StatusText: String; ElapsedTime, EstimatedTime: TDateTime;
  Speed: Extended; SpeedUnit: String);
begin
   panel03.Caption:=StatusText+' '+inttostr(Progress)+'/'+inttostr(ProgressMax);
   Application.ProcessMessages;
end;

procedure TForm1.InternetHTTPRequest2Redirect(Sender: TObject;
  hInet: Pointer; OldURL, NewURL: String; var cancel: Boolean);
begin
  edit2.Text:=newurl;
end;

procedure TForm1.InternetHTTPRequest3Redirect(Sender: TObject;
  hInet: Pointer; OldURL, NewURL: String; var cancel: Boolean);
begin
  edit3.Text:=newurl;
end;

end.
