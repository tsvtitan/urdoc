unit SeoCrypterIntf;

interface

uses Classes;

type

  TSeoHashAlgorithm=(haMD4,haMD5,haSHA,haSHA1,haRipeMD128,haRipeMD160,haRipeMD256,haRipeMD320,
                     haHaval128,haHaval160,haHaval192,haHaval224,haHaval256,haSapphire128,
                     haSapphire160,haSapphire192,haSapphire224,haSapphire256,haSapphire288,
                     haSapphire320,haSnefru,haSquare,haTiger,haXOR16,haXOR32,haCRC16_CCITT,
                     haCRC16_Standard,haCRC32);
                     
  TSeoHashFormat=(hfDefault,hfHEX,hfHEXL,hfMIME64,hfUU,hfXX);

  TSeoCipherAlgorithm=(ca3Way,caBlowfish,caGost,caIDEA,caQ128,caSAFER_K40,caSAFER_SK40,caSAFER_K64,
                       caSAFER_SK64,caSAFER_K128,caSAFER_SK128,caSCOP,caShark,caSquare,caTEA,caTEAN,
                       caTwofish,caCast128,caCast256,ca1DES,ca2DES,ca2DDES,ca3DES,ca3DDES,ca3TDES,
                       caDESX,caDiamond2,caDiamond2Lite,caFROG,caMars,caMisty,caNewDES,caRC2,
                       caRC4,caRC5,caRC6,caRijndael,caSapphire,caSkipjack);

  TSeoCipherMode=(cmCTS,cmCBC,cmCFB,cmOFB,cmECB,cmCTSMAC,cmCBCMAC,cmCFBMAC);

  ISeoCrypter=interface(IDispatch)
  ['{153DA69E-C5BE-43E2-80A8-44560FC4D5EC}']
    function GetActive: Boolean; stdcall;
    procedure SetActive(Value: Boolean); stdcall;

    function HashString(S: string; Algorithm: TSeoHashAlgorithm; Format: TSeoHashFormat): String; stdcall;
    function HashStream(Stream: TStream; Algorithm: TSeoHashAlgorithm; Format: TSeoHashFormat): String; stdcall;
    function HashFile(FileName: string; Algorithm: TSeoHashAlgorithm; Format: TSeoHashFormat): String; stdcall;
    procedure EncodeStream(Key: string; Stream: TStream; Algorithm: TSeoCipherAlgorithm; Mode: TSeoCipherMode); stdcall;
    procedure DecodeStream(Key: string; Stream: TStream; Algorithm: TSeoCipherAlgorithm; Mode: TSeoCipherMode); stdcall;

    property Active: Boolean read GetActive write SetActive;
  end;


implementation

end.
