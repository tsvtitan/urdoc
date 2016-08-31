unit EasyNetDemoUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ComCtrls, HTMLDecoder, PRInternetAccess;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    Memo2: TMemo;
    Memo4: TMemo;
    Panel2: TPanel;
    TreeView1: TTreeView;
    Memo3: TMemo;
    StatusBar1: TStatusBar;
    Edit1: TEdit;
    InternetHTTPRequest1: TInternetHTTPRequest;
    InternetConnection1: TInternetConnection;
    InternetSession1: TInternetSession;
    Button2: TButton;
    InternetHTTPRequest2: TInternetHTTPRequest;
    HTMLDecoder1: THTMLDecoder;
    procedure Button1Click(Sender: TObject);
    procedure TreeView1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure HTMLDecoder1Progress(Sender: TObject; hInet: Pointer;
      Progress, ProgressMax, StatusCode: Cardinal; StatusText: String;
      ElapsedTime, EstimatedTime: TDateTime; Speed: Extended;
      SpeedUnit: String);
    procedure InternetHTTPRequest2Progress(Sender: TObject; hInet: Pointer;
      Progress, ProgressMax, StatusCode: Cardinal; StatusText: String;
      ElapsedTime, EstimatedTime: TDateTime; Speed: Extended;
      SpeedUnit: String);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure BuildElementTree(Parent:TTreeNode; Node:THTMLDOMNode);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
procedure TForm1.BuildElementTree(Parent:TTreeNode; Node:THTMLDOMNode);
var
  NewNode:TTreeNode;
  i:integer;
begin
  NewNode:=TreeView1.Items.AddNode(nil,Parent,Node.ClassName,Node,naAddChild);
  //Application.ProcessMessages;
  for i:=0 to Node.ChildCount-1 do
  begin
    BuildElementTree(NewNode,Node.Childs[i]);
  end;
end;
procedure TForm1.Button1Click(Sender: TObject);
begin
  //InternetHTTPRequest1.URL:=edit1.Text;
  //HTMLDecoder1.URL:=edit1.text;
  HTMLDecoder1.Document.LoadHTML(Memo1.Lines.Text,false);
  TreeView1.Items.Clear;
  BuildElementTree(nil,HTMLDecoder1.Document);
  //TreeView1.FullExpand;
  memo3.lines.clear;
  memo3.lines.Text:=HTMLDecoder1.Document.outerHTML;
end;

procedure TForm1.TreeView1Click(Sender: TObject);
begin
  if assigned(TreeView1.Selected) then
  begin
    memo2.lines.text:=THTMLElement(TreeView1.Selected.Data).outerText;
    memo4.lines.Text:=  THTMLElement(TreeView1.Selected.Data).outerHTML;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
 ss:TStringStream;
begin
  InternetHTTPRequest2.URL:=edit1.Text;
  InternetHTTPRequest2.OpenRequest;
  ss:=TStringStream.Create('');
  InternetHTTPRequest2.SendRequest(ss);
  memo1.Lines.Text:=ss.DataString;
  ss.Free;
end;

procedure TForm1.HTMLDecoder1Progress(Sender: TObject; hInet: Pointer;
  Progress, ProgressMax, StatusCode: Cardinal; StatusText: String;
  ElapsedTime, EstimatedTime: TDateTime; Speed: Extended;
  SpeedUnit: String);
begin
  if ProgressMax<>0 then
    StatusBar1.SimpleText:=(StatusText+' %'+inttostr(trunc(((Progress) / (ProgressMax)) * 100)))
  else
    StatusBar1.SimpleText:=(StatusText);
  Application.ProcessMessages;
end;

procedure TForm1.InternetHTTPRequest2Progress(Sender: TObject;
  hInet: Pointer; Progress, ProgressMax, StatusCode: Cardinal;
  StatusText: String; ElapsedTime, EstimatedTime: TDateTime;
  Speed: Extended; SpeedUnit: String);
begin
  if ProgressMax<>0 then
    StatusBar1.SimpleText:=(StatusText+' %'+inttostr(trunc(((Progress) / (ProgressMax)) * 100)))
  else
    StatusBar1.SimpleText:=(StatusText);
  Application.ProcessMessages;
end;

end.
