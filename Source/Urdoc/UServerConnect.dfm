�
 TFMSERVERCONNECT 0	  TPF0TfmServerConnectfmServerConnectLeftTop� BorderIconsbiSystemMenu BorderStylebsDialogCaption(   Соединение с серверомClientHeight� ClientWidth"Color	clBtnFaceFont.CharsetDEFAULT_CHARSET
Font.ColorclWindowTextFont.Height�	Font.NameTahoma
Font.Style OldCreateOrderPositionpoScreenCenterScaledOnCreate
FormCreatePixelsPerInch`
TextHeight 	TGroupBoxgbDBServerInfoLeftTopWidthHeight� Caption*    Информация по серверу TabOrder  TLabellblServerNameLeftTop3WidthCHeightCaption   Имя сервера:FocusControl
cbDBServer  TLabellblProtocolLeftTopLWidth� HeightCaption5   Сетевой протокол соединения:FocusControl
cbProtocol  TLabellblDatabaseLeftTopfWidthEHeightCaption   База данных:FocusControledtDatabase  	TComboBox
cbProtocolLeft� TopIWidthSHeightStylecsDropDownList
ItemHeightTabOrderItems.StringsTCP/IPNetBEUISPX   TRadioButtonrbLocalServerLeftTopWidth}HeightCaption   Локальный серверTabOrder OnClickrbLocalServerClick  TRadioButtonrbRemoteServerLeft� TopWidth{HeightCaption   Удаленный серверTabOrderOnClickrbLocalServerClick  	TComboBox
cbDBServerLeft]Top0Width� Height
ItemHeightTabOrder  TEditedtDatabaseLeftYTopcWidth� HeightParentShowHintShowHint	TabOrder  TButtonbtnSelDBLeft� TopcWidthHeightHintSelect databaseCaption...TabOrderOnClickbtnSelDBClick   TPanelPanel1Left Top� Width"Height$AlignalBottom
BevelOuterbvNoneTabOrder TPanelPanel2LeftTop Width
Height$AlignalRight
BevelOuterbvNoneTabOrder  TBitBtnbtOkLeftgTopWidthKHeightCaptionOKDefault	TabOrderOnClick	btOkClick	NumGlyphs  TBitBtnbtCancelLeft� TopWidthKHeightCancel	Caption   B<5=0ModalResultTabOrder	NumGlyphs  TBitBtnbibTestLeftTopWidthKHeightCaption   "5ABTabOrder OnClickbibTestClick	NumGlyphs    TOpenDialogod
DefaultExt*.fdbFilterZ   Базы данных Firebird (*.fdb)|*.fdb|Базы данных Interbase (*.gdb)|*.gdbOptionsofEnableSizing LeftTop�    