unit SeoCrypter;

interface

uses SeoCrypterIntf;

const
  SSeoCrptLibrary='seocrpt.dll';

function _GetCrypter: ISeoCrypter; stdcall; external SSeoCrptLibrary name 'GetCrypter';

implementation


end.
