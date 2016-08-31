object Form1: TForm1
  Left = 207
  Top = 186
  Caption = 'Form1'
  ClientHeight = 547
  ClientWidth = 769
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 769
    Height = 201
    Align = alTop
    BevelKind = bkFlat
    BorderStyle = bsNone
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 201
    Width = 769
    Height = 120
    Align = alTop
    BevelOuter = bvSpace
    Caption = 'Panel1'
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 1
    object Button1: TButton
      Left = 632
      Top = 72
      Width = 75
      Height = 25
      Caption = 'Parse'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Memo2: TMemo
      Left = 1
      Top = 1
      Width = 320
      Height = 118
      Align = alLeft
      BevelInner = bvLowered
      BevelKind = bkFlat
      BorderStyle = bsNone
      Ctl3D = False
      Lines.Strings = (
        'Memo2')
      ParentCtl3D = False
      TabOrder = 1
    end
    object Memo4: TMemo
      Left = 321
      Top = 1
      Width = 272
      Height = 118
      Align = alLeft
      BevelInner = bvLowered
      BevelKind = bkFlat
      BorderStyle = bsNone
      Ctl3D = False
      Lines.Strings = (
        'Memo4')
      ParentCtl3D = False
      TabOrder = 2
    end
    object Edit1: TEdit
      Left = 594
      Top = 8
      Width = 167
      Height = 19
      TabOrder = 3
      Text = 'http://www.google.com/'
    end
    object Button2: TButton
      Left = 632
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Download'
      TabOrder = 4
      OnClick = Button2Click
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 321
    Width = 769
    Height = 226
    Align = alClient
    Caption = 'Panel2'
    TabOrder = 2
    ExplicitHeight = 219
    object TreeView1: TTreeView
      Left = 1
      Top = 1
      Width = 344
      Height = 205
      Align = alLeft
      BevelInner = bvLowered
      BevelKind = bkFlat
      BorderStyle = bsNone
      Ctl3D = False
      Indent = 19
      ParentCtl3D = False
      TabOrder = 0
      OnClick = TreeView1Click
      ExplicitHeight = 198
    end
    object Memo3: TMemo
      Left = 345
      Top = 1
      Width = 423
      Height = 205
      Align = alClient
      BevelInner = bvLowered
      BevelKind = bkFlat
      BorderStyle = bsNone
      Ctl3D = False
      Lines.Strings = (
        'Memo3')
      ParentCtl3D = False
      TabOrder = 1
      ExplicitHeight = 198
    end
    object StatusBar1: TStatusBar
      Left = 1
      Top = 206
      Width = 767
      Height = 19
      Panels = <>
      SimplePanel = True
      SimpleText = 'Ready'
      ExplicitTop = 199
    end
  end
  object InternetHTTPRequest1: TInternetHTTPRequest
    OnProgress = HTMLDecoder1Progress
    Active = False
    Connection = InternetConnection1
    Scheme = isHTTP
    Port = 0
    Service = ictHTTP
    URL = 'http://'
    Method = hmGET
    AcceptTypes.Strings = (
      'text/*'
      'message/*'
      'multipart/*'
      'application/*'
      'image/*'
      'audio/*'
      'video/*'
      'model/*')
    opCacheIfNetFail = False
    opHyperlink = False
    opIgnoreCertCNInvalid = False
    opIgnoreCertDateInvalid = False
    opIgnoreRedirectToHTTP = False
    opIgnoreRedirectToHTTPS = False
    opKeepConnection = False
    opNeedFile = False
    opNoAutoAuth = False
    opNoAutoRedirect = False
    opNoCacheWrite = False
    opCookieHandling = chAPI
    opDisableCookieDialogbox = False
    opForceProxyToReload = False
    opForceReload = False
    opResynchronize = False
    opSecure = False
    Left = 536
    Top = 120
  end
  object InternetConnection1: TInternetConnection
    Connected = False
    Session = InternetSession1
    Scheme = isHTTP
    Port = 0
    Service = ictHTTP
    opCookieHandling = chAPI
    Left = 504
    Top = 120
  end
  object InternetSession1: TInternetSession
    UserAgent = 'Mozilla/4.0 (compatible; MSIE 6.0; Win32)'
    AccessType = atDirect
    Proxy = '192.168.1.1:4480'
    Active = False
    Asynchronous = False
    FromCache = False
    OffLine = False
    EnableStatusCallback = False
    Left = 464
    Top = 120
  end
  object InternetHTTPRequest2: TInternetHTTPRequest
    OnProgress = InternetHTTPRequest2Progress
    Active = False
    Connection = InternetConnection1
    Scheme = isHTTP
    Port = 0
    Service = ictHTTP
    URL = 'http://'
    Method = hmGET
    AcceptTypes.Strings = (
      'image/gif'
      'image/x-xbitmap'
      'image/jpeg'
      'image/pjpeg'
      'application/x-shockwave-flash'
      'application/vnd.ms-powerpoint'
      'application/vnd.ms-excel'
      'application/msword'
      '*/*')
    opCacheIfNetFail = False
    opHyperlink = False
    opIgnoreCertCNInvalid = False
    opIgnoreCertDateInvalid = False
    opIgnoreRedirectToHTTP = False
    opIgnoreRedirectToHTTPS = False
    opKeepConnection = False
    opNeedFile = False
    opNoAutoAuth = False
    opNoAutoRedirect = False
    opNoCacheWrite = False
    opCookieHandling = chAPI
    opDisableCookieDialogbox = False
    opForceProxyToReload = False
    opForceReload = False
    opResynchronize = False
    opSecure = False
    Left = 536
    Top = 160
  end
  object HTMLDecoder1: THTMLDecoder
    HttpRequest = InternetHTTPRequest1
    AddParsingErrorComments = False
    ReFormatOutputHTML = True
    UseFontTagsAsParent = False
    UseSeperateTextTags = False
    RemoveControlChars = True
    CookieHandling = chAPI
    TrytoFixProblems = False
    OnProgress = HTMLDecoder1Progress
    Left = 592
    Top = 112
  end
end
