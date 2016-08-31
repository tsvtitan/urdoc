unit SeoKeys;

interface

uses SeoCrypterIntf;

{$I def.inc}

const

{$IFDEF KEYS_DEF}
  DefaultCipherAlgorithm=caRC5;
  DefaultCipherMode=cmCTS;
  DefaultHashAlgorithm=haMD5;
  DefaultHashFormat=hfHEX;

  SKey='8BC5D6B8D09E0DDCC5A34703F2329585'; // Notary
{$ENDIF}

implementation

end.
