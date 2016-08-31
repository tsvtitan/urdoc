{******************************************************************}
{                                                                  }
{ Borland Delphi Runtime Library                                   }
{ Cryptographic API Prototypes and Definitions unit                }
{                                                                  }
{ Portions created by Microsoft are                                }
{ Copyright (C) 1992-1999 Microsoft Corporation.                   }
{ All Rights Reserved.                                             }
{                                                                  }       
{ The original file is: wincrypt.h, 1992 - 1999                    }
{ The original Pascal code is: WinCrypt.pas, released 28-02-2002   }
{ The  developer of the Pascal code is                             }
{  Starodub Oleg  (1cqa@mail.ru)                                   }
{                                                                  }
{ Copyright (C) 2002 Starodub Oleg                                 }
{                                                                  }
{ The contents of this file are used with permission, subject to   }
{ the Mozilla Public License Version 1.1 (the "License"); you may  }
{ not use this file except in compliance with the License. You may }
{ obtain a copy of the License at                                  }
{ http://www.mozilla.org/MPL/MPL-1.1.html                          }
{                                                                  }
{ Software distributed under the License is distributed on an      }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   }
{ implied. See the License for the specific language governing     }
{ rights and limitations under the License.                        }
{                                                                  }
{******************************************************************}
//+---------------------------------------------------------------------------
//
//  Microsoft Windows
//  Copyright (C) Microsoft Corporation, 1992-1999.
//
//  File:       wincrypt.h
//
//  Contents:   Cryptographic API Prototypes and Definitions
//
//----------------------------------------------------------------------------
unit WinCrypt;

interface

uses Windows;

//
// Algorithm IDs and Flags
//

// ALG_ID crackers
function GET_ALG_CLASS(x: DWORD): DWORD;
function GET_ALG_TYPE(x: DWORD): DWORD;
function GET_ALG_SID(x: DWORD): DWORD;

// Algorithm classes
const
  ALG_CLASS_ANY          = 0;
  ALG_CLASS_SIGNATURE    = 1 shl 13;
  ALG_CLASS_MSG_ENCRYPT  = 2 shl 13;
  ALG_CLASS_DATA_ENCRYPT = 3 shl 13;
  ALG_CLASS_HASH         = 4 shl 13;
  ALG_CLASS_KEY_EXCHANGE = 5 shl 13;
  ALG_CLASS_ALL          = 7 shl 13;

  // Algorithm types
  ALG_TYPE_ANY           = 0;
  ALG_TYPE_DSS           = 1 shl 9;
  ALG_TYPE_RSA           = 2 shl 9;
  ALG_TYPE_BLOCK         = 3 shl 9;
  ALG_TYPE_STREAM        = 4 shl 9;
  ALG_TYPE_DH            = 5 shl 9;
  ALG_TYPE_SECURECHANNEL = 6 shl 9;

  // Generic sub-ids
  ALG_SID_ANY = 0;

  // Some RSA sub-ids
  ALG_SID_RSA_ANY      = 0;
  ALG_SID_RSA_PKCS     = 1;
  ALG_SID_RSA_MSATWORK = 2;
  ALG_SID_RSA_ENTRUST  = 3;
  ALG_SID_RSA_PGP      = 4;

  // Some DSS sub-ids
  //
  ALG_SID_DSS_ANY  = 0;
  ALG_SID_DSS_PKCS = 1;
  ALG_SID_DSS_DMS  = 2;

  // Block cipher sub ids
  // DES sub_ids
  ALG_SID_DES        = 1;
  ALG_SID_3DES       = 3;
  ALG_SID_DESX       = 4;
  ALG_SID_IDEA       = 5;
  ALG_SID_CAST       = 6;
  ALG_SID_SAFERSK64  = 7;
  ALG_SID_SAFERSK128 = 8;
  ALG_SID_3DES_112   = 9;
  ALG_SID_CYLINK_MEK = 12;
  ALG_SID_RC5        = 13;
  ALG_SID_AES_128    = 14;
  ALG_SID_AES_192    = 15;
  ALG_SID_AES_256    = 16;
  ALG_SID_AES        = 17;

  // Fortezza sub-ids
  ALG_SID_SKIPJACK = 10;
  ALG_SID_TEK      = 11;

  // KP_MODE
  CRYPT_MODE_CBCI    = 6; // ANSI CBC Interleaved
  CRYPT_MODE_CFBP    = 7; // ANSI CFB Pipelined
  CRYPT_MODE_OFBP    = 8; // ANSI OFB Pipelined
  CRYPT_MODE_CBCOFM  = 9; // ANSI CBC + OF Masking
  CRYPT_MODE_CBCOFMI = 10; // ANSI CBC + OFM Interleaved

  // RC2 sub-ids
  ALG_SID_RC2 = 2;

  // Stream cipher sub-ids
  ALG_SID_RC4  = 1;
  ALG_SID_SEAL = 2;

  // Diffie-Hellman sub-ids
  ALG_SID_DH_SANDF       = 1;
  ALG_SID_DH_EPHEM       = 2;
  ALG_SID_AGREED_KEY_ANY = 3;
  ALG_SID_KEA            = 4;

  // Hash sub ids
  ALG_SID_MD2              = 1;
  ALG_SID_MD4              = 2;
  ALG_SID_MD5              = 3;
  ALG_SID_SHA              = 4;
  ALG_SID_SHA1             = 4;
  ALG_SID_MAC              = 5;
  ALG_SID_RIPEMD           = 6;
  ALG_SID_RIPEMD160        = 7;
  ALG_SID_SSL3SHAMD5       = 8;
  ALG_SID_HMAC             = 9;
  ALG_SID_TLS1PRF          = 10;
  ALG_SID_HASH_REPLACE_OWF = 11;

  // secure channel sub ids
  ALG_SID_SSL3_MASTER          = 1;
  ALG_SID_SCHANNEL_MASTER_HASH = 2;
  ALG_SID_SCHANNEL_MAC_KEY     = 3;
  ALG_SID_PCT1_MASTER          = 4;
  ALG_SID_SSL2_MASTER          = 5;
  ALG_SID_TLS1_MASTER          = 6;
  ALG_SID_SCHANNEL_ENC_KEY     = 7;

  // Our silly example sub-id
  ALG_SID_EXAMPLE = 80;

type
  ALG_ID = UINT;

// algorithm identifier definitions
const
  CALG_MD2 = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MD2);
  CALG_MD4 = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MD4);
  CALG_MD5 = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MD5);
  CALG_SHA = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA);
  CALG_SHA1 = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SHA1);
  CALG_MAC = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_MAC);
  CALG_RSA_SIGN = (ALG_CLASS_SIGNATURE or ALG_TYPE_RSA or ALG_SID_RSA_ANY);
  CALG_DSS_SIGN = (ALG_CLASS_SIGNATURE or ALG_TYPE_DSS or ALG_SID_DSS_ANY);
  CALG_NO_SIGN = (ALG_CLASS_SIGNATURE or ALG_TYPE_ANY or ALG_SID_ANY);
  CALG_RSA_KEYX = (ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_RSA or ALG_SID_RSA_ANY);
  CALG_DES = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_DES);
  CALG_3DES_112 = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or
    ALG_SID_3DES_112);
  CALG_3DES = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_3DES);
  CALG_DESX = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_DESX);
  CALG_RC2 = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_RC2);
  CALG_RC4 = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_STREAM or ALG_SID_RC4);
  CALG_SEAL = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_STREAM or ALG_SID_SEAL);
  CALG_DH_SF = (ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_DH or ALG_SID_DH_SANDF);
  CALG_DH_EPHEM = (ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_DH or ALG_SID_DH_EPHEM);
  CALG_AGREEDKEY_ANY = (ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_DH or
    ALG_SID_AGREED_KEY_ANY);
  CALG_KEA_KEYX = (ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_DH or ALG_SID_KEA);
  CALG_HUGHES_MD5 = (ALG_CLASS_KEY_EXCHANGE or ALG_TYPE_ANY or ALG_SID_MD5);
  CALG_SKIPJACK = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or
    ALG_SID_SKIPJACK);
  CALG_TEK = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_TEK);
  CALG_CYLINK_MEK = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or
    ALG_SID_CYLINK_MEK);
  CALG_SSL3_SHAMD5 = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_SSL3SHAMD5);
  CALG_SSL3_MASTER = (ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL or
    ALG_SID_SSL3_MASTER);
  CALG_SCHANNEL_MASTER_HASH = (ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL
    or ALG_SID_SCHANNEL_MASTER_HASH);
  CALG_SCHANNEL_MAC_KEY = (ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL or
    ALG_SID_SCHANNEL_MAC_KEY);
  CALG_SCHANNEL_ENC_KEY = (ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL or
    ALG_SID_SCHANNEL_ENC_KEY);
  CALG_PCT1_MASTER = (ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL or
    ALG_SID_PCT1_MASTER);
  CALG_SSL2_MASTER = (ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL or
    ALG_SID_SSL2_MASTER);
  CALG_TLS1_MASTER = (ALG_CLASS_MSG_ENCRYPT or ALG_TYPE_SECURECHANNEL or
    ALG_SID_TLS1_MASTER);
  CALG_RC5 = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or ALG_SID_RC5);
  CALG_HMAC = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_HMAC);
  CALG_TLS1PRF = (ALG_CLASS_HASH or ALG_TYPE_ANY or ALG_SID_TLS1PRF);

  CALG_HASH_REPLACE_OWF = (ALG_CLASS_HASH or ALG_TYPE_ANY or
    ALG_SID_HASH_REPLACE_OWF);
  CALG_AES_128          = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or
    ALG_SID_AES_128);
  CALG_AES_192          = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or
    ALG_SID_AES_192);
  CALG_AES_256          = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or
    ALG_SID_AES_256);
  CALG_AES              = (ALG_CLASS_DATA_ENCRYPT or ALG_TYPE_BLOCK or
    ALG_SID_AES);

type
  HCRYPTPROV = ULONG;
  HCRYPTKEY  = ULONG;
  HCRYPTHASH = ULONG;

// dwFlags definitions for CryptAcquireContext
const
  CRYPT_VERIFYCONTEXT  = $F0000000;
  CRYPT_NEWKEYSET      = $00000008;
  CRYPT_DELETEKEYSET   = $00000010;
  CRYPT_MACHINE_KEYSET = $00000020;
  CRYPT_SILENT         = $00000040;

  // dwFlag definitions for CryptGenKey
  CRYPT_EXPORTABLE     = $00000001;
  CRYPT_USER_PROTECTED = $00000002;
  CRYPT_CREATE_SALT    = $00000004;
  CRYPT_UPDATE_KEY     = $00000008;
  CRYPT_NO_SALT        = $00000010;
  CRYPT_PREGEN         = $00000040;
  CRYPT_RECIPIENT      = $00000010;
  CRYPT_INITIATOR      = $00000040;
  CRYPT_ONLINE         = $00000080;
  CRYPT_SF             = $00000100;
  CRYPT_CREATE_IV      = $00000200;
  CRYPT_KEK            = $00000400;
  CRYPT_DATA_KEY       = $00000800;
  CRYPT_VOLATILE       = $00001000;
  CRYPT_SGCKEY         = $00002000;
  CRYPT_ARCHIVABLE     = $00004000;

  RSA1024BIT_KEY       = $04000000;

  // dwFlags definitions for CryptDeriveKey
  CRYPT_SERVER         = $00000400;

  KEY_LENGTH_MASK      = $FFFF0000;

  // dwFlag definitions for CryptExportKey
  CRYPT_Y_ONLY        = $00000001;
  CRYPT_SSL2_FALLBACK = $00000002;
  CRYPT_DESTROYKEY    = $00000004;
  CRYPT_OAEP          = $00000040; // used with RSA encryptions/decryptions
  // CryptExportKey, CryptImportKey,
  // CryptEncrypt and CryptDecrypt

  CRYPT_BLOB_VER3      = $00000080; // export version 3 of a blob type
  CRYPT_IPSEC_HMAC_KEY = $00000100; // CryptImportKey only

  // dwFlags definitions for CryptCreateHash
  CRYPT_SECRETDIGEST = $00000001;

  // dwFlags definitions for CryptHashData
  CRYPT_OWF_REPL_LM_HASH = $00000001;  // this is only for the OWF replacement CSP

  // dwFlags definitions for CryptHashSessionKey
  CRYPT_LITTLE_ENDIAN = $00000001;

  // dwFlags definitions for CryptSignHash and CryptVerifySignature
  CRYPT_NOHASHOID    = $00000001;
  CRYPT_TYPE2_FORMAT = $00000002;
  CRYPT_X931_FORMAT  = $00000004;

  // dwFlag definitions for CryptSetProviderEx and CryptGetDefaultProvider
  CRYPT_MACHINE_DEFAULT = $00000001;
  CRYPT_USER_DEFAULT    = $00000002;
  CRYPT_DELETE_DEFAULT  = $00000004;

  // exported key blob definitions
  SIMPLEBLOB           = $1;
  PUBLICKEYBLOB        = $6;
  PRIVATEKEYBLOB       = $7;
  PLAINTEXTKEYBLOB     = $8;
  OPAQUEKEYBLOB        = $9;
  PUBLICKEYBLOBEX      = $A;
  SYMMETRICWRAPKEYBLOB = $B;

  AT_KEYEXCHANGE = 1;
  AT_SIGNATURE   = 2;

  CRYPT_USERDATA = 1;

  // dwParam
  KP_IV               = 1;  // Initialization vector
  KP_SALT             = 2;  // Salt value
  KP_PADDING          = 3;  // Padding values
  KP_MODE             = 4;  // Mode of the cipher
  KP_MODE_BITS        = 5;  // Number of bits to feedback
  KP_PERMISSIONS      = 6;  // Key permissions DWORD
  KP_ALGID            = 7;  // Key algorithm
  KP_BLOCKLEN         = 8;  // Block size of the cipher
  KP_KEYLEN           = 9;  // Length of key in bits
  KP_SALT_EX          = 10; // Length of salt in bytes
  KP_P                = 11; // DSS/Diffie-Hellman P value
  KP_G                = 12; // DSS/Diffie-Hellman G value
  KP_Q                = 13; // DSS Q value
  KP_X                = 14; // Diffie-Hellman X value
  KP_Y                = 15; // Y value
  KP_RA               = 16; // Fortezza RA value
  KP_RB               = 17; // Fortezza RB value
  KP_INFO             = 18; // for putting information into an RSA envelope
  KP_EFFECTIVE_KEYLEN = 19; // setting and getting RC2 effective key length
  KP_SCHANNEL_ALG     = 20; // for setting the Secure Channel algorithms
  KP_CLIENT_RANDOM    = 21; // for setting the Secure Channel client random data
  KP_SERVER_RANDOM    = 22; // for setting the Secure Channel server random data
  KP_RP               = 23;
  KP_PRECOMP_MD5      = 24;
  KP_PRECOMP_SHA      = 25;
  KP_CERTIFICATE      = 26; // for setting Secure Channel certificate data (PCT1)
  KP_CLEAR_KEY        = 27; // for setting Secure Channel clear key data (PCT1)
  KP_PUB_EX_LEN       = 28;
  KP_PUB_EX_VAL       = 29;
  KP_KEYVAL           = 30;
  KP_ADMIN_PIN        = 31;
  KP_KEYEXCHANGE_PIN  = 32;
  KP_SIGNATURE_PIN    = 33;
  KP_PREHASH          = 34;

  KP_OAEP_PARAMS     = 36; // for setting OAEP params on RSA keys
  KP_CMS_KEY_INFO    = 37;
  KP_CMS_DH_KEY_INFO = 38;
  KP_PUB_PARAMS      = 39; // for setting public parameters
  KP_VERIFY_PARAMS   = 40; // for verifying DSA and DH parameters
  KP_HIGHEST_VERSION = 41; // for TLS protocol version setting

  // KP_PADDING
  PKCS5_PADDING  = 1; // PKCS 5 (sec 6.2) padding method
  RANDOM_PADDING = 2;
  ZERO_PADDING   = 3;

  // KP_MODE
  CRYPT_MODE_CBC = 1; // Cipher block chaining
  CRYPT_MODE_ECB = 2; // Electronic code book
  CRYPT_MODE_OFB = 3; // Output feedback mode
  CRYPT_MODE_CFB = 4; // Cipher feedback mode
  CRYPT_MODE_CTS = 5; // Ciphertext stealing mode

  // KP_PERMISSIONS
  CRYPT_ENCRYPT    = $0001; // Allow encryption
  CRYPT_DECRYPT    = $0002; // Allow decryption
  CRYPT_EXPORT     = $0004; // Allow key to be exported
  CRYPT_READ       = $0008; // Allow parameters to be read
  CRYPT_WRITE      = $0010; // Allow parameters to be set
  CRYPT_MAC        = $0020; // Allow MACs to be used with key
  CRYPT_EXPORT_KEY = $0040; // Allow key to be used for exporting keys
  CRYPT_IMPORT_KEY = $0080; // Allow key to be used for importing keys
  CRYPT_ARCHIVE    = $0100; // Allow key to be exported at creation only

  HP_ALGID         = $0001; // Hash algorithm
  HP_HASHVAL       = $0002; // Hash value
  HP_HASHSIZE      = $0004; // Hash value size
  HP_HMAC_INFO     = $0005; // information for creating an HMAC
  HP_TLS1PRF_LABEL = $0006; // label for TLS1 PRF
  HP_TLS1PRF_SEED  = $0007; // seed for TLS1 PRF

  CRYPT_FAILED = FALSE;
  CRYPT_SUCCEED = TRUE;

function RCRYPT_SUCCEEDED(rt: BOOL): boolean;
function RCRYPT_FAILED(rt: BOOL): boolean;

// CryptGetProvParam
const
  PP_ENUMALGS            = 1;
  PP_ENUMCONTAINERS      = 2;
  PP_IMPTYPE             = 3;
  PP_NAME                = 4;
  PP_VERSION             = 5;
  PP_CONTAINER           = 6;
  PP_CHANGE_PASSWORD     = 7;
  PP_KEYSET_SEC_DESCR    = 8; // get/set security descriptor of keyset
  PP_CERTCHAIN           = 9; // for retrieving certificates from tokens
  PP_KEY_TYPE_SUBTYPE    = 10;
  PP_PROVTYPE            = 16;
  PP_KEYSTORAGE          = 17;
  PP_APPLI_CERT          = 18;
  PP_SYM_KEYSIZE         = 19;
  PP_SESSION_KEYSIZE     = 20;
  PP_UI_PROMPT           = 21;
  PP_ENUMALGS_EX         = 22;
  PP_ENUMMANDROOTS       = 25;
  PP_ENUMELECTROOTS      = 26;
  PP_KEYSET_TYPE         = 27;
  PP_ADMIN_PIN           = 31;
  PP_KEYEXCHANGE_PIN     = 32;
  PP_SIGNATURE_PIN       = 33;
  PP_SIG_KEYSIZE_INC     = 34;
  PP_KEYX_KEYSIZE_INC    = 35;
  PP_UNIQUE_CONTAINER    = 36;
  PP_SGC_INFO            = 37;
  PP_USE_HARDWARE_RNG    = 38;
  PP_KEYSPEC             = 39;
  PP_ENUMEX_SIGNING_PROT = 40;

  CRYPT_FIRST    = 1;
  CRYPT_NEXT     = 2;
  CRYPT_SGC_ENUM = 4;

  CRYPT_IMPL_HARDWARE  = 1;
  CRYPT_IMPL_SOFTWARE  = 2;
  CRYPT_IMPL_MIXED     = 3;
  CRYPT_IMPL_UNKNOWN   = 4;
  CRYPT_IMPL_REMOVABLE = 8;

  // key storage flags
  CRYPT_SEC_DESCR = $00000001;
  CRYPT_PSTORE    = $00000002;
  CRYPT_UI_PROMPT = $00000004;

  // protocol flags
  CRYPT_FLAG_PCT1    = $0001;
  CRYPT_FLAG_SSL2    = $0002;
  CRYPT_FLAG_SSL3    = $0004;
  CRYPT_FLAG_TLS1    = $0008;
  CRYPT_FLAG_IPSEC   = $0010;
  CRYPT_FLAG_SIGNING = $0020;

  // SGC flags
  CRYPT_SGC     = $0001;
  CRYPT_FASTSGC = $0002;

  // CryptSetProvParam
  PP_CLIENT_HWND         = 1;
  PP_CONTEXT_INFO        = 11;
  PP_KEYEXCHANGE_KEYSIZE = 12;
  PP_SIGNATURE_KEYSIZE   = 13;
  PP_KEYEXCHANGE_ALG     = 14;
  PP_SIGNATURE_ALG       = 15;
  PP_DELETEKEY           = 24;

  PROV_RSA_FULL      = 1;
  PROV_RSA_SIG       = 2;
  PROV_DSS           = 3;
  PROV_FORTEZZA      = 4;
  PROV_MS_EXCHANGE   = 5;
  PROV_SSL           = 6;
  PROV_RSA_SCHANNEL  = 12;
  PROV_DSS_DH        = 13;
  PROV_EC_ECDSA_SIG  = 14;
  PROV_EC_ECNRA_SIG  = 15;
  PROV_EC_ECDSA_FULL = 16;
  PROV_EC_ECNRA_FULL = 17;
  PROV_DH_SCHANNEL   = 18;
  PROV_SPYRUS_LYNKS  = 20;
  PROV_RNG           = 21;
  PROV_INTEL_SEC     = 22;
  PROV_REPLACE_OWF   = 23;
  PROV_RSA_AES       = 24;

  // STT defined Providers
  PROV_STT_MER  = 7;
  PROV_STT_ACQ  = 8;
  PROV_STT_BRND = 9;
  PROV_STT_ROOT = 10;
  PROV_STT_ISS  = 11;

  // Provider friendly names
  MS_DEF_PROV_A = AnsiString('Microsoft Base Cryptographic Provider v1.0');
  MS_DEF_PROV_W = WideString('Microsoft Base Cryptographic Provider v1.0');
{$IFDEF UNICODE}
  MS_DEF_PROV = MS_DEF_PROV_W;
{$ELSE}
  MS_DEF_PROV = MS_DEF_PROV_A;
{$ENDIF}

  MS_ENHANCED_PROV_A =
    AnsiString('Microsoft Enhanced Cryptographic Provider v1.0');
  MS_ENHANCED_PROV_W =
    WideString('Microsoft Enhanced Cryptographic Provider v1.0');
{$IFDEF UNICODE}
  MS_ENHANCED_PROV = MS_ENHANCED_PROV_W;
{$ELSE}
  MS_ENHANCED_PROV = MS_ENHANCED_PROV_A;
{$ENDIF}

  MS_STRONG_PROV_A = AnsiString('Microsoft Strong Cryptographic Provider');
  MS_STRONG_PROV_W = WideString('Microsoft Strong Cryptographic Provider');
{$IFDEF UNICODE}
  MS_STRONG_PROV = MS_STRONG_PROV_W;
{$ELSE}
  MS_STRONG_PROV = MS_STRONG_PROV_A;
{$ENDIF}

  MS_DEF_RSA_SIG_PROV_A =
    AnsiString('Microsoft RSA Signature Cryptographic Provider');
  MS_DEF_RSA_SIG_PROV_W =
    WideString('Microsoft RSA Signature Cryptographic Provider');
{$IFDEF UNICODE}
  MS_DEF_RSA_SIG_PROV = MS_DEF_RSA_SIG_PROV_W;
{$ELSE}
  MS_DEF_RSA_SIG_PROV = MS_DEF_RSA_SIG_PROV_A;
{$ENDIF}

  MS_DEF_RSA_SCHANNEL_PROV_A =
    AnsiString('Microsoft RSA SChannel Cryptographic Provider');
  MS_DEF_RSA_SCHANNEL_PROV_W =
    WideString('Microsoft RSA SChannel Cryptographic Provider');
{$IFDEF UNICODE}
  MS_DEF_RSA_SCHANNEL_PROV = MS_DEF_RSA_SCHANNEL_PROV_W;
{$ELSE}
  MS_DEF_RSA_SCHANNEL_PROV = MS_DEF_RSA_SCHANNEL_PROV_A;
{$ENDIF}

  MS_DEF_DSS_PROV_A = AnsiString('Microsoft Base DSS Cryptographic Provider');
  MS_DEF_DSS_PROV_W = WideString('Microsoft Base DSS Cryptographic Provider');
{$IFDEF UNICODE}
  MS_DEF_DSS_PROV = MS_DEF_DSS_PROV_W;
{$ELSE}
  MS_DEF_DSS_PROV = MS_DEF_DSS_PROV_A;
{$ENDIF}

  MS_DEF_DSS_DH_PROV_A =
    AnsiString('Microsoft Base DSS and Diffie-Hellman Cryptographic Provider');
  MS_DEF_DSS_DH_PROV_W =
    WideString('Microsoft Base DSS and Diffie-Hellman Cryptographic Provider');
{$IFDEF UNICODE}
  MS_DEF_DSS_DH_PROV = MS_DEF_DSS_DH_PROV_W;
{$ELSE}
  MS_DEF_DSS_DH_PROV = MS_DEF_DSS_DH_PROV_A;
{$ENDIF}

  MS_ENH_DSS_DH_PROV_A =
    AnsiString('Microsoft Enhanced DSS and Diffie-Hellman Cryptographic Provider');
  MS_ENH_DSS_DH_PROV_W =
    WideString('Microsoft Enhanced DSS and Diffie-Hellman Cryptographic Provider');
{$IFDEF UNICODE}
  MS_ENH_DSS_DH_PROV = MS_ENH_DSS_DH_PROV_W;
{$ELSE}
  MS_ENH_DSS_DH_PROV = MS_ENH_DSS_DH_PROV_A;
{$ENDIF}

  MS_DEF_DH_SCHANNEL_PROV_A =
    AnsiString('Microsoft DH SChannel Cryptographic Provider');
  MS_DEF_DH_SCHANNEL_PROV_W =
    WideString('Microsoft DH SChannel Cryptographic Provider');
{$IFDEF UNICODE}
  MS_DEF_DH_SCHANNEL_PROV = MS_DEF_DH_SCHANNEL_PROV_W;
{$ELSE}
  MS_DEF_DH_SCHANNEL_PROV = MS_DEF_DH_SCHANNEL_PROV_A;
{$ENDIF}

  MS_SCARD_PROV_A = AnsiString('Microsoft Base Smart Card Crypto Provider');
  MS_SCARD_PROV_W = WideString('Microsoft Base Smart Card Crypto Provider');
{$IFDEF UNICODE}
  MS_SCARD_PROV = MS_SCARD_PROV_W;
{$ELSE}
  MS_SCARD_PROV = MS_SCARD_PROV_A;
{$ENDIF}

  MS_ENH_RSA_AES_PROV_A =
    AnsiString('Microsoft Enhanced RSA and AES Cryptographic Provider (Prototype)');
  MS_ENH_RSA_AES_PROV_W =
    WideString('Microsoft Enhanced RSA and AES Cryptographic Provider (Prototype)');
{$IFDEF UNICODE}
  MS_ENH_RSA_AES_PROV = MS_ENH_RSA_AES_PROV_W;
{$ELSE}
  MS_ENH_RSA_AES_PROV = MS_ENH_RSA_AES_PROV_A;
{$ENDIF}

  MAXUIDLEN = 64;

  // Exponentiation Offload Reg Location
  EXPO_OFFLOAD_REG_VALUE = 'ExpoOffload';
  EXPO_OFFLOAD_FUNC_NAME = 'OffloadModExpo';

  CUR_BLOB_VERSION = 2;

  // structure for use with CryptSetKeyParam for CMS keys
  // DO NOT USE THIS STRUCTURE!!!!!
type
  CMS_KEY_INFO = record
    dwVersion: DWORD;  // sizeof(CMS_KEY_INFO)
    Algid:     ALG_ID; // algorithmm id for the key to be converted
    pbOID:     PBYTE;  // pointer to OID to hash in with Z
    cbOID:     DWORD;  // length of OID to hash in with Z
  end;
  PCMS_KEY_INFO = ^CMS_KEY_INFO;

  // structure for use with CryptSetHashParam with CALG_HMAC
  HMAC_Info = record
    HashAlgid: ALG_ID;
    pbInnerString: PBYTE;
    cbInnerString: DWORD;
    pbOuterString: PBYTE;
    cbOuterString: DWORD;
  end;
  PHMAC_INFO = ^HMAC_INFO;

  // structure for use with CryptSetKeyParam with KP_SCHANNEL_ALG
  SCHANNEL_ALG = record
    dwUse:      DWORD;
    Algid:      ALG_ID;
    cBits:      DWORD;
    dwFlags:    DWORD;
    dwReserved: DWORD;
  end;
  PSCHANNEL_ALG = ^SCHANNEL_ALG;

// uses of algortihms for SCHANNEL_ALG structure
const
  SCHANNEL_MAC_KEY = $00000000;
  SCHANNEL_ENC_KEY = $00000001;

  // uses of dwFlags SCHANNEL_ALG structure
  INTERNATIONAL_USAGE = $00000001;

type
  PROV_ENUMALGS = record
    aiAlgid:   ALG_ID;
    dwBitLen:  DWORD;
    dwNameLen: DWORD;
    szName:    array[1..20] of char;
  end;

  PROV_ENUMALGS_EX = record
    aiAlgid:       ALG_ID;
    dwDefaultLen:  DWORD;
    dwMinLen:      DWORD;
    dwMaxLen:      DWORD;
    dwProtocols:   DWORD;
    dwNameLen:     DWORD;
    szName:        array[1..20] of char;
    dwLongNameLen: DWORD;
    szLongName:    array[1..40] of char;
  end;

  PUBLICKEYSTRUC = record
    bType:    byte;
    bVersion: byte;
    reserved: word;
    aiKeyAlg: ALG_ID;
  end;
  BLOBHEADER = PUBLICKEYSTRUC;

  RSAPUBKEY = record
    magic:  DWORD; // Has to be RSA1
    bitlen: DWORD; // # of bits in modulus
    pubexp: DWORD; // public exponent
  end; // Modulus data follows

  PUBKEY = record
    magic:  DWORD;
    bitlen: DWORD; // # of bits in modulus
  end;
  DHPUBKEY  = PUBKEY;
  DSSPUBKEY = PUBKEY;
  KEAPUBKEY = PUBKEY;
  TEKPUBKEY = PUBKEY;

  DSSSEED = record
    counter: DWORD;
    seed:    array[1..20] of byte;
  end;

  PUBKEYVER3 = record
    magic:   DWORD;
    bitlenP: DWORD; // # of bits in prime modulus
    bitlenQ: DWORD; // # of bits in prime q, 0 if not available
    bitlenJ: DWORD; // # of bits in (p-1)/q, 0 if not available
    DSSSeed: DSSSEED;
  end;
  DHPUBKEY_VER3 = PUBKEYVER3;
  DSSPUBKEY_VER3 = PUBKEYVER3;

  PRIVKEYVER3 = record
    magic:   DWORD;
    bitlenP: DWORD; // # of bits in prime modulus
    bitlenQ: DWORD; // # of bits in prime q, 0 if not available
    bitlenJ: DWORD; // # of bits in (p-1)/q, 0 if not available
    bitlenX: DWORD; // # of bits in X
    DSSSeed: DSSSEED;
  end;
  DHPRIVKEY_VER3 = PRIVKEYVER3;
  DSSPRIVKEY_VER3 = PRIVKEYVER3;

  KEY_TYPE_SUBTYPE = record
    dwKeySpec: DWORD;
    xType:     TGUID;
    Subtype:   TGUID;
  end;
  PKEY_TYPE_SUBTYPE = ^KEY_TYPE_SUBTYPE;

  CERT_FORTEZZA_DATA_PROP = record
    SerialNumber: array[1..8] of UCHAR;
    CertIndex:    integer;
    CertLabel:    array[1..36] of UCHAR;
  end;

  //+-------------------------------------------------------------------------
  //  CRYPTOAPI BLOB definitions
  //--------------------------------------------------------------------------
  CRYPTOAPI_BLOB = record
    cbData: DWORD;
    pbData: PByte;
  end;
  CRYPT_INTEGER_BLOB   = CRYPTOAPI_BLOB;
  CRYPT_UINT_BLOB      = CRYPTOAPI_BLOB;
  CRYPT_OBJID_BLOB     = CRYPTOAPI_BLOB;
  CERT_NAME_BLOB       = CRYPTOAPI_BLOB;
  CERT_RDN_VALUE_BLOB  = CRYPTOAPI_BLOB;
  CERT_BLOB            = CRYPTOAPI_BLOB;
  CRL_BLOB             = CRYPTOAPI_BLOB;
  DATA_BLOB            = CRYPTOAPI_BLOB;
  CRYPT_DATA_BLOB      = CRYPTOAPI_BLOB;
  CRYPT_HASH_BLOB      = CRYPTOAPI_BLOB;
  CRYPT_DIGEST_BLOB    = CRYPTOAPI_BLOB;
  CRYPT_DER_BLOB       = CRYPTOAPI_BLOB;
  CRYPT_ATTR_BLOB      = CRYPTOAPI_BLOB;
  PCRYPT_INTEGER_BLOB  = ^CRYPT_INTEGER_BLOB;
  PCRYPT_UINT_BLOB     = ^CRYPT_UINT_BLOB;
  PCRYPT_OBJID_BLOB    = ^CRYPT_OBJID_BLOB;
  PCERT_NAME_BLOB      = ^CERT_NAME_BLOB;
  PCERT_RDN_VALUE_BLOB = ^CERT_RDN_VALUE_BLOB;
  PCERT_BLOB           = ^CERT_BLOB;
  PCRL_BLOB            = ^CRL_BLOB;
  PDATA_BLOB           = ^DATA_BLOB;
  PCRYPT_DATA_BLOB     = ^CRYPT_DATA_BLOB;
  PCRYPT_HASH_BLOB     = ^CRYPT_HASH_BLOB;
  PCRYPT_DIGEST_BLOB   = ^CRYPT_DIGEST_BLOB;
  PCRYPT_DER_BLOB      = ^CRYPT_DER_BLOB;
  PCRYPT_ATTR_BLOB     = ^CRYPT_ATTR_BLOB;

  // structure for use with CryptSetKeyParam for CMS keys
  CMS_DH_KEY_INFO = record
    dwVersion:          DWORD; // sizeof(CMS_DH_KEY_INFO)
    Algid:              ALG_ID; // algorithmm id for the key to be converted
    pszContentEncObjId: LPSTR; // pointer to OID to hash in with Z
    PubInfo:            CRYPT_DATA_BLOB; // OPTIONAL - public information
    pReserved:          pointer; // reserved - should be NULL
  end;
  PCMS_DH_KEY_INFO = ^CMS_DH_KEY_INFO;

function CryptAcquireContextA(
  var phProv: HCRYPTPROV;
  szContainer: LPCSTR;
  szProvider: LPCSTR;
  dwProvType: DWORD;
  dwFlags: DWORD
  ): BOOL; stdcall;
function CryptAcquireContextW(
  var phProv: HCRYPTPROV;
  szContainer: LPCWSTR;
  szProvider: LPCWSTR;
  dwProvType: DWORD;
  dwFlags: DWORD
  ): BOOL; stdcall;
{$IFDEF UNICODE}
function CryptAcquireContext(
  var phProv: HCRYPTPROV;
  szContainer: LPCWSTR;
  szProvider: LPCWSTR;
  dwProvType: DWORD;
  dwFlags: DWORD
  ): BOOL; stdcall;
{$ELSE}
function CryptAcquireContext(
  var phProv: HCRYPTPROV;
  szContainer: LPCSTR;
  szProvider: LPCSTR;
  dwProvType: DWORD;
  dwFlags: DWORD
  ): BOOL; stdcall;
{$ENDIF} // !UNICODE

function CryptReleaseContext(
  hProv: HCRYPTPROV;
  dwFlags: DWORD
  ): BOOL; stdcall;

function CryptGenKey(
  hProv: HCRYPTPROV;
  Algid: ALG_ID;
  dwFlags: DWORD;
  var phKey: HCRYPTKEY
  ): BOOL; stdcall;

function CryptDeriveKey(
  hProv: HCRYPTPROV;
  Algid: ALG_ID;
  hBaseData: HCRYPTHASH;
  dwFlags: DWORD;
  var phKey: HCRYPTKEY
  ): BOOL; stdcall;

function CryptDestroyKey(
  hKey: HCRYPTKEY
  ): BOOL; stdcall;

function CryptSetKeyParam(
  hKey: HCRYPTKEY;
  dwParam: DWORD;
  pbData: PBYTE;
  dwFlags: DWORD
  ): BOOL; stdcall;

function CryptGetKeyParam(
  hKey: HCRYPTKEY;
  dwParam: DWORD;
  pbData: PBYTE;
  var pdwDataLen: DWORD;
  dwFlags: DWORD
  ): BOOL; stdcall;

function CryptSetHashParam(
  hHash: HCRYPTHASH;
  dwParam: DWORD;
  pbData: PBYTE;
  dwFlags: DWORD
  ): BOOL; stdcall;

function CryptGetHashParam(
  hHash: HCRYPTHASH;
  dwParam: DWORD;
  pbData: PBYTE;
  var pdwDataLen: DWORD;
  dwFlags: DWORD
  ): BOOL; stdcall;

function CryptSetProvParam(
  hProv: HCRYPTPROV;
  dwParam: DWORD;
  pbData: PBYTE;
  dwFlags: DWORD
  ): BOOL; stdcall;

function CryptGetProvParam(
  hProv: HCRYPTPROV;
  dwParam: DWORD;
  pbData: PBYTE;
  var pdwDataLen: DWORD;
  dwFlags: DWORD
  ): BOOL; stdcall;

function CryptGenRandom(
  hProv: HCRYPTPROV;
  dwLen: DWORD;
  pbBuffer: PBYTE
  ): BOOL; stdcall;

function CryptGetUserKey(
  hProv: HCRYPTPROV;
  dwKeySpec: DWORD;
  var phUserKey: HCRYPTKEY
  ): BOOL; stdcall;

function CryptExportKey(
  hKey: HCRYPTKEY;
  hExpKey: HCRYPTKEY;
  dwBlobType: DWORD;
  dwFlags: DWORD;
  pbData: PBYTE;
  var pdwDataLen: DWORD
  ): BOOL; stdcall;

function CryptImportKey(
  hProv: HCRYPTPROV;
  pbData: PBYTE;
  dwDataLen: DWORD;
  hPubKey: HCRYPTKEY;
  dwFlags: DWORD;
  var phKey: HCRYPTKEY
  ): BOOL; stdcall;

function CryptEncrypt(
  hKey: HCRYPTKEY;
  hHash: HCRYPTHASH;
  Final: BOOL;
  dwFlags: DWORD;
  pbData: PBYTE;
  var pdwDataLen: DWORD;
  dwBufLen: DWORD
  ): BOOL; stdcall;

function CryptDecrypt(
  hKey: HCRYPTKEY;
  hHash: HCRYPTHASH;
  Final: BOOL;
  dwFlags: DWORD;
  pbData: PBYTE;
  var pdwDataLen: DWORD
  ): BOOL; stdcall;

function CryptCreateHash(
  hProv: HCRYPTPROV;
  Algid: ALG_ID;
  hKey: HCRYPTKEY;
  dwFlags: DWORD;
  var phHash: HCRYPTHASH
  ): BOOL; stdcall;

function CryptHashData(
  hHash: HCRYPTHASH;
  pbData: PBYTE;
  dwDataLen: DWORD;
  dwFlags: DWORD
  ): BOOL; stdcall;

function CryptHashSessionKey(
  hHash: HCRYPTHASH;
  hKey: HCRYPTKEY;
  dwFlags: DWORD
  ): BOOL; stdcall;

function CryptDestroyHash(
  hHash: HCRYPTHASH
  ): BOOL; stdcall;

function CryptSignHashA(
  hHash: HCRYPTHASH;
  dwKeySpec: DWORD;
  szDescription: LPCSTR;
  dwFlags: DWORD;
  pbSignature: PBYTE;
  var pdwSigLen: DWORD
  ): BOOL; stdcall;
function CryptSignHashW(
  hHash: HCRYPTHASH;
  dwKeySpec: DWORD;
  szDescription: LPCWSTR;
  dwFlags: DWORD;
  pbSignature: PBYTE;
  var pdwSigLen: DWORD
  ): BOOL; stdcall;
{$IFDEF UNICODE}
function CryptSignHash(
  hHash: HCRYPTHASH;
  dwKeySpec: DWORD;
  szDescription: LPCWSTR;
  dwFlags: DWORD;
  pbSignature: PBYTE;
  var pdwSigLen: DWORD
  ): BOOL; stdcall;
{$ELSE}
function CryptSignHash(
  hHash: HCRYPTHASH;
  dwKeySpec: DWORD;
  szDescription: LPCSTR;
  dwFlags: DWORD;
  pbSignature: PBYTE;
  var pdwSigLen: DWORD
  ): BOOL; stdcall;
{$ENDIF} // !UNICODE

function CryptVerifySignatureA(
  hHash: HCRYPTHASH;
  pbSignature: PBYTE;
  dwSigLen: DWORD;
  hPubKey: HCRYPTKEY;
  szDescription: LPCSTR;
  dwFlags: DWORD
  ): BOOL; stdcall;
function CryptVerifySignatureW(
  hHash: HCRYPTHASH;
  pbSignature: PBYTE;
  dwSigLen: DWORD;
  hPubKey: HCRYPTKEY;
  szDescription: LPCWSTR;
  dwFlags: DWORD
  ): BOOL; stdcall;
{$IFDEF UNICODE}
function CryptVerifySignature(
  hHash: HCRYPTHASH;
  pbSignature: PBYTE;
  dwSigLen: DWORD;
  hPubKey: HCRYPTKEY;
  szDescription: LPCWSTR;
  dwFlags: DWORD
  ): BOOL; stdcall;
{$ELSE}
function CryptVerifySignature(
  hHash: HCRYPTHASH;
  pbSignature: PBYTE;
  dwSigLen: DWORD;
  hPubKey: HCRYPTKEY;
  szDescription: LPCSTR;
  dwFlags: DWORD
  ): BOOL; stdcall;
{$ENDIF} // !UNICODE

function CryptSetProviderA(
  pszProvName: LPCSTR;
  dwProvType: DWORD
  ): BOOL; stdcall;
function CryptSetProviderW(
  pszProvName: LPCWSTR;
  dwProvType: DWORD
  ): BOOL; stdcall;
{$IFDEF UNICODE}
function CryptSetProvider(
  pszProvName: LPCWSTR;
  dwProvType: DWORD
  ): BOOL; stdcall;
{$ELSE}
function CryptSetProvider(
  pszProvName: LPCSTR;
  dwProvType: DWORD
  ): BOOL; stdcall;
{$ENDIF} // !UNICODE

function CryptSetProviderExA(
  pszProvName: LPCSTR;
  dwProvType: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD
  ): BOOL; stdcall;
function CryptSetProviderExW(
  pszProvName: LPCWSTR;
  dwProvType: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD
  ): BOOL; stdcall;
{$IFDEF UNICODE}
function CryptSetProviderEx(
  pszProvName: LPCWSTR;
  dwProvType: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD
  ): BOOL; stdcall;
{$ELSE}
function CryptSetProviderEx(
  pszProvName: LPCSTR;
  dwProvType: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD
  ): BOOL; stdcall;
{$ENDIF} // !UNICODE

function CryptGetDefaultProviderA(
  dwProvType: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD;
  pszProvName: LPSTR;
  var pcbProvName: DWORD
  ): BOOL; stdcall;
function CryptGetDefaultProviderW(
  dwProvType: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD;
  pszProvName: LPWSTR;
  var pcbProvName: DWORD
  ): BOOL; stdcall;
{$IFDEF UNICODE}
function CryptGetDefaultProvider(
  dwProvType: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD;
  pszProvName: LPWSTR;
  var pcbProvName: DWORD
  ): BOOL; stdcall;
{$ELSE}
function CryptGetDefaultProvider(
  dwProvType: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD;
  pszProvName: LPSTR;
  var pcbProvName: DWORD
  ): BOOL; stdcall;
{$ENDIF} // !UNICODE

function CryptEnumProviderTypesA(
  dwIndex: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD;
  var pdwProvType: DWORD;
  pszTypeName: LPSTR;
  var pcbTypeName: DWORD
  ): BOOL; stdcall;
function CryptEnumProviderTypesW(
  dwIndex: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD;
  var pdwProvType: DWORD;
  pszTypeName: LPWSTR;
  var pcbTypeName: DWORD
  ): BOOL; stdcall;
{$IFDEF UNICODE}
function CryptEnumProviderTypes(
  dwIndex: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD;
  var pdwProvType: DWORD;
  pszTypeName: LPWSTR;
  var pcbTypeName: DWORD
  ): BOOL; stdcall;
{$ELSE}
function CryptEnumProviderTypes(
  dwIndex: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD;
  var pdwProvType: DWORD;
  pszTypeName: LPSTR;
  var pcbTypeName: DWORD
  ): BOOL; stdcall;
{$ENDIF} // !UNICODE

function CryptEnumProvidersA(
  dwIndex: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD;
  var pdwProvType: DWORD;
  pszProvName: LPSTR;
  var pcbProvName: DWORD
  ): BOOL; stdcall;
function CryptEnumProvidersW(
  dwIndex: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD;
  var pdwProvType: DWORD;
  pszProvName: LPWSTR;
  var pcbProvName: DWORD
  ): BOOL; stdcall;
{$IFDEF UNICODE}
function CryptEnumProviders(
  dwIndex: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD;
  var pdwProvType: DWORD;
  pszProvName: LPWSTR;
  var pcbProvName: DWORD
  ): BOOL; stdcall;
{$ELSE}
function CryptEnumProviders(
  dwIndex: DWORD;
  pdwReserved: pointer;
  dwFlags: DWORD;
  var pdwProvType: DWORD;
  pszProvName: LPSTR;
  var pcbProvName: DWORD
  ): BOOL; stdcall;
{$ENDIF} // !UNICODE

function CryptContextAddRef(
  hProv: HCRYPTPROV;
  pdwReserved: pointer;
  dwFlags: DWORD
  ): BOOL; stdcall;

function CryptDuplicateKey(
  hKey: HCRYPTKEY;
  pdwReserved: pointer;
  dwFlags: DWORD;
  var phKey: HCRYPTKEY
  ): BOOL; stdcall;

function CryptDuplicateHash(
  hHash: HCRYPTHASH;
  pdwReserved: pointer;
  dwFlags: DWORD;
  var phHash: HCRYPTHASH
  ): BOOL; stdcall;

type
  CRYPT_KEY_LIMITS = record
    dwVersion:         DWORD;
    algId:             ALG_ID;
    dwMinKeyLength:    DWORD;
    dwMaxKeyLength:    DWORD;
    dwRequiredFlags:   DWORD;
    dwDisallowedFlags: DWORD;
  end;
  PCRYPT_KEY_LIMITS = ^CRYPT_KEY_LIMITS;

// Request Flag definitions
const
  CRYPTLIMIT_USING_PCT = $0001;
  CRYPTLIMIT_USING_SGC = $0002;

function CryptGetLocalKeyLimits(
  algId: ALG_ID;
  dwFlags: DWORD;
  pLimits: PCRYPT_KEY_LIMITS;
  var cbLimitLength: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  In a CRYPT_BIT_BLOB the last byte may contain 0-7 unused bits. Therefore, the
//  overall bit length is cbData * 8 - cUnusedBits.
//--------------------------------------------------------------------------
type
  CRYPT_BIT_BLOB = record
    cbData:      DWORD;
    pbData:      PBYTE;
    cUnusedBits: DWORD;
  end;
  PCRYPT_BIT_BLOB = ^CRYPT_BIT_BLOB;

  //+-------------------------------------------------------------------------
  //  Type used for any algorithm
  //
  //  Where the Parameters CRYPT_OBJID_BLOB is in its encoded representation. For most
  //  algorithm types, the Parameters CRYPT_OBJID_BLOB is NULL (Parameters.cbData = 0).
  //--------------------------------------------------------------------------
  CRYPT_ALGORITHM_IDENTIFIER = record
    pszObjId:   LPSTR;
    Parameters: CRYPT_OBJID_BLOB;
  end;
  PCRYPT_ALGORITHM_IDENTIFIER = ^CRYPT_ALGORITHM_IDENTIFIER;

  // Following are the definitions of various algorithm object identifiers
  // RSA
const
  szOID_RSA         = '1.2.840.113549';
  szOID_PKCS        = '1.2.840.113549.1';
  szOID_RSA_HASH    = '1.2.840.113549.2';
  szOID_RSA_ENCRYPT = '1.2.840.113549.3';

  szOID_PKCS_1  = '1.2.840.113549.1.1';
  szOID_PKCS_2  = '1.2.840.113549.1.2';
  szOID_PKCS_3  = '1.2.840.113549.1.3';
  szOID_PKCS_4  = '1.2.840.113549.1.4';
  szOID_PKCS_5  = '1.2.840.113549.1.5';
  szOID_PKCS_6  = '1.2.840.113549.1.6';
  szOID_PKCS_7  = '1.2.840.113549.1.7';
  szOID_PKCS_8  = '1.2.840.113549.1.8';
  szOID_PKCS_9  = '1.2.840.113549.1.9';
  szOID_PKCS_10 = '1.2.840.113549.1.10';
  szOID_PKCS_12 = '1.2.840.113549.1.12';

  szOID_RSA_RSA         = '1.2.840.113549.1.1.1';
  szOID_RSA_MD2RSA      = '1.2.840.113549.1.1.2';
  szOID_RSA_MD4RSA      = '1.2.840.113549.1.1.3';
  szOID_RSA_MD5RSA      = '1.2.840.113549.1.1.4';
  szOID_RSA_SHA1RSA     = '1.2.840.113549.1.1.5';
  szOID_RSA_SETOAEP_RSA = '1.2.840.113549.1.1.6';

  szOID_RSA_DH = '1.2.840.113549.1.3.1';

  szOID_RSA_data          = '1.2.840.113549.1.7.1';
  szOID_RSA_signedData    = '1.2.840.113549.1.7.2';
  szOID_RSA_envelopedData = '1.2.840.113549.1.7.3';
  szOID_RSA_signEnvData   = '1.2.840.113549.1.7.4';
  szOID_RSA_digestedData  = '1.2.840.113549.1.7.5';
  szOID_RSA_hashedData    = '1.2.840.113549.1.7.5';
  szOID_RSA_encryptedData = '1.2.840.113549.1.7.6';

  szOID_RSA_emailAddr         = '1.2.840.113549.1.9.1';
  szOID_RSA_unstructName      = '1.2.840.113549.1.9.2';
  szOID_RSA_contentType       = '1.2.840.113549.1.9.3';
  szOID_RSA_messageDigest     = '1.2.840.113549.1.9.4';
  szOID_RSA_signingTime       = '1.2.840.113549.1.9.5';
  szOID_RSA_counterSign       = '1.2.840.113549.1.9.6';
  szOID_RSA_challengePwd      = '1.2.840.113549.1.9.7';
  szOID_RSA_unstructAddr      = '1.2.840.113549.1.9.8';
  szOID_RSA_extCertAttrs      = '1.2.840.113549.1.9.9';
  szOID_RSA_certExtensions    = '1.2.840.113549.1.9.14';
  szOID_RSA_SMIMECapabilities = '1.2.840.113549.1.9.15';
  szOID_RSA_preferSignedData  = '1.2.840.113549.1.9.15.1';

  szOID_RSA_SMIMEalg            = '1.2.840.113549.1.9.16.3';
  szOID_RSA_SMIMEalgESDH        = '1.2.840.113549.1.9.16.3.5';
  szOID_RSA_SMIMEalgCMS3DESwrap = '1.2.840.113549.1.9.16.3.6';
  szOID_RSA_SMIMEalgCMSRC2wrap  = '1.2.840.113549.1.9.16.3.7';

  szOID_RSA_MD2 = '1.2.840.113549.2.2';
  szOID_RSA_MD4 = '1.2.840.113549.2.4';
  szOID_RSA_MD5 = '1.2.840.113549.2.5';

  szOID_RSA_RC2CBC       = '1.2.840.113549.3.2';
  szOID_RSA_RC4          = '1.2.840.113549.3.4';
  szOID_RSA_DES_EDE3_CBC = '1.2.840.113549.3.7';
  szOID_RSA_RC5_CBCPad   = '1.2.840.113549.3.9';

  szOID_ANSI_X942    = '1.2.840.10046';
  szOID_ANSI_X942_DH = '1.2.840.10046.2.1';

  szOID_X957         = '1.2.840.10040';
  szOID_X957_DSA     = '1.2.840.10040.4.1';
  szOID_X957_SHA1DSA = '1.2.840.10040.4.3';

  // ITU-T UsefulDefinitions
  szOID_DS         = '2.5';
  szOID_DSALG      = '2.5.8';
  szOID_DSALG_CRPT = '2.5.8.1';
  szOID_DSALG_HASH = '2.5.8.2';
  szOID_DSALG_SIGN = '2.5.8.3';
  szOID_DSALG_RSA  = '2.5.8.1.1';
  // NIST OSE Implementors' Workshop (OIW)
  // http://nemo.ncsl.nist.gov/oiw/agreements/stable/OSI/12s_9506.w51
  // http://nemo.ncsl.nist.gov/oiw/agreements/working/OSI/12w_9503.w51
  szOID_OIW = '1.3.14';
  // NIST OSE Implementors' Workshop (OIW) Security SIG algorithm identifiers
  szOID_OIWSEC             = '1.3.14.3.2';
  szOID_OIWSEC_md4RSA      = '1.3.14.3.2.2';
  szOID_OIWSEC_md5RSA      = '1.3.14.3.2.3';
  szOID_OIWSEC_md4RSA2     = '1.3.14.3.2.4';
  szOID_OIWSEC_desECB      = '1.3.14.3.2.6';
  szOID_OIWSEC_desCBC      = '1.3.14.3.2.7';
  szOID_OIWSEC_desOFB      = '1.3.14.3.2.8';
  szOID_OIWSEC_desCFB      = '1.3.14.3.2.9';
  szOID_OIWSEC_desMAC      = '1.3.14.3.2.10';
  szOID_OIWSEC_rsaSign     = '1.3.14.3.2.11';
  szOID_OIWSEC_dsa         = '1.3.14.3.2.12';
  szOID_OIWSEC_shaDSA      = '1.3.14.3.2.13';
  szOID_OIWSEC_mdc2RSA     = '1.3.14.3.2.14';
  szOID_OIWSEC_shaRSA      = '1.3.14.3.2.15';
  szOID_OIWSEC_dhCommMod   = '1.3.14.3.2.16';
  szOID_OIWSEC_desEDE      = '1.3.14.3.2.17';
  szOID_OIWSEC_sha         = '1.3.14.3.2.18';
  szOID_OIWSEC_mdc2        = '1.3.14.3.2.19';
  szOID_OIWSEC_dsaComm     = '1.3.14.3.2.20';
  szOID_OIWSEC_dsaCommSHA  = '1.3.14.3.2.21';
  szOID_OIWSEC_rsaXchg     = '1.3.14.3.2.22';
  szOID_OIWSEC_keyHashSeal = '1.3.14.3.2.23';
  szOID_OIWSEC_md2RSASign  = '1.3.14.3.2.24';
  szOID_OIWSEC_md5RSASign  = '1.3.14.3.2.25';
  szOID_OIWSEC_sha1        = '1.3.14.3.2.26';
  szOID_OIWSEC_dsaSHA1     = '1.3.14.3.2.27';
  szOID_OIWSEC_dsaCommSHA1 = '1.3.14.3.2.28';
  szOID_OIWSEC_sha1RSASign = '1.3.14.3.2.29';
  // NIST OSE Implementors' Workshop (OIW) Directory SIG algorithm identifiers
  szOID_OIWDIR             = '1.3.14.7.2';
  szOID_OIWDIR_CRPT        = '1.3.14.7.2.1';
  szOID_OIWDIR_HASH        = '1.3.14.7.2.2';
  szOID_OIWDIR_SIGN        = '1.3.14.7.2.3';
  szOID_OIWDIR_md2         = '1.3.14.7.2.2.1';
  szOID_OIWDIR_md2RSA      = '1.3.14.7.2.3.1';

  // INFOSEC Algorithms
  // joint-iso-ccitt(2) country(16) us(840) organization(1) us-government(101) dod(2) id-infosec(1)
  szOID_INFOSEC                       = '2.16.840.1.101.2.1';
  szOID_INFOSEC_sdnsSignature         = '2.16.840.1.101.2.1.1.1';
  szOID_INFOSEC_mosaicSignature       = '2.16.840.1.101.2.1.1.2';
  szOID_INFOSEC_sdnsConfidentiality   = '2.16.840.1.101.2.1.1.3';
  szOID_INFOSEC_mosaicConfidentiality = '2.16.840.1.101.2.1.1.4';
  szOID_INFOSEC_sdnsIntegrity         = '2.16.840.1.101.2.1.1.5';
  szOID_INFOSEC_mosaicIntegrity       = '2.16.840.1.101.2.1.1.6';
  szOID_INFOSEC_sdnsTokenProtection   = '2.16.840.1.101.2.1.1.7';
  szOID_INFOSEC_mosaicTokenProtection = '2.16.840.1.101.2.1.1.8';
  szOID_INFOSEC_sdnsKeyManagement     = '2.16.840.1.101.2.1.1.9';
  szOID_INFOSEC_mosaicKeyManagement   = '2.16.840.1.101.2.1.1.10';
  szOID_INFOSEC_sdnsKMandSig          = '2.16.840.1.101.2.1.1.11';
  szOID_INFOSEC_mosaicKMandSig        = '2.16.840.1.101.2.1.1.12';
  szOID_INFOSEC_SuiteASignature       = '2.16.840.1.101.2.1.1.13';
  szOID_INFOSEC_SuiteAConfidentiality = '2.16.840.1.101.2.1.1.14';
  szOID_INFOSEC_SuiteAIntegrity       = '2.16.840.1.101.2.1.1.15';
  szOID_INFOSEC_SuiteATokenProtection = '2.16.840.1.101.2.1.1.16';
  szOID_INFOSEC_SuiteAKeyManagement   = '2.16.840.1.101.2.1.1.17';
  szOID_INFOSEC_SuiteAKMandSig        = '2.16.840.1.101.2.1.1.18';
  szOID_INFOSEC_mosaicUpdatedSig      = '2.16.840.1.101.2.1.1.19';
  szOID_INFOSEC_mosaicKMandUpdSig     = '2.16.840.1.101.2.1.1.20';
  szOID_INFOSEC_mosaicUpdatedInteg    = '2.16.840.1.101.2.1.1.21';

type
  CRYPT_OBJID_TABLE = record
    dwAlgId:  DWORD;
    pszObjId: LPCSTR;
  end;
  PCRYPT_OBJID_TABLE = ^CRYPT_OBJID_TABLE;

  //+-------------------------------------------------------------------------
  //  PKCS #1 HashInfo (DigestInfo)
  //--------------------------------------------------------------------------
  CRYPT_HASH_INFO = record
    HashAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    Hash:          CRYPT_HASH_BLOB;
  end;
  PCRYPT_HASH_INFO = ^CRYPT_HASH_INFO;

  //+-------------------------------------------------------------------------
  //  Type used for an extension to an encoded content
  //
  //  Where the Value's CRYPT_OBJID_BLOB is in its encoded representation.
  //--------------------------------------------------------------------------
  CERT_EXTENSION = record
    pszObjId:  LPSTR;
    fCritical: BOOL;
    Value:     CRYPT_OBJID_BLOB;
  end;
  PCERT_EXTENSION = ^CERT_EXTENSION;

  //+-------------------------------------------------------------------------
  //  AttributeTypeValue
  //
  //  Where the Value's CRYPT_OBJID_BLOB is in its encoded representation.
  //--------------------------------------------------------------------------
  CRYPT_ATTRIBUTE_TYPE_VALUE = record
    pszObjId: LPSTR;
    Value:    CRYPT_OBJID_BLOB;
  end;
  PCRYPT_ATTRIBUTE_TYPE_VALUE = ^CRYPT_ATTRIBUTE_TYPE_VALUE;

  //+-------------------------------------------------------------------------
  //  Attributes
  //
  //  Where the Value's PATTR_BLOBs are in their encoded representation.
  //--------------------------------------------------------------------------
  CRYPT_ATTRIBUTE = record
    pszObjId: LPSTR;
    cValue:   DWORD;
    rgValue:  PCRYPT_ATTR_BLOB;
  end;
  PCRYPT_ATTRIBUTE = ^CRYPT_ATTRIBUTE;

  CRYPT_ATTRIBUTES = record
    cAttr:  DWORD;
    rgAttr: PCRYPT_ATTRIBUTE;
  end;
  PCRYPT_ATTRIBUTES = CRYPT_ATTRIBUTES;

  //+-------------------------------------------------------------------------
  //  Attributes making up a Relative Distinguished Name (CERT_RDN)
  //
  //  The interpretation of the Value depends on the dwValueType.
  //  See below for a list of the types.
  //--------------------------------------------------------------------------
  CERT_RDN_ATTR = record
    pszObjId:    LPSTR;
    dwValueType: DWORD;
    Value:       CERT_RDN_VALUE_BLOB;
  end;
  PCERT_RDN_ATTR = ^CERT_RDN_ATTR;

  //+-------------------------------------------------------------------------
  //  CERT_RDN attribute Object Identifiers
  //--------------------------------------------------------------------------
  // Labeling attribute types:
const
  szOID_COMMON_NAME          = '2.5.4.3'; // case-ignore string
  szOID_SUR_NAME             = '2.5.4.4'; // case-ignore string
  szOID_DEVICE_SERIAL_NUMBER = '2.5.4.5'; // printable string

  // Geographic attribute types:
  szOID_COUNTRY_NAME           = '2.5.4.6'; // printable 2char string
  szOID_LOCALITY_NAME          = '2.5.4.7'; // case-ignore string
  szOID_STATE_OR_PROVINCE_NAME = '2.5.4.8'; // case-ignore string
  szOID_STREET_ADDRESS         = '2.5.4.9'; // case-ignore string

  // Organizational attribute types:
  szOID_ORGANIZATION_NAME        = '2.5.4.10'; // case-ignore string
  szOID_ORGANIZATIONAL_UNIT_NAME = '2.5.4.11'; // case-ignore string
  szOID_TITLE                    = '2.5.4.12'; // case-ignore string

  // Explanatory attribute types:
  szOID_DESCRIPTION       = '2.5.4.13'; // case-ignore string
  szOID_SEARCH_GUIDE      = '2.5.4.14';
  szOID_BUSINESS_CATEGORY = '2.5.4.15'; // case-ignore string

  // Postal addressing attribute types:
  szOID_POSTAL_ADDRESS                = '2.5.4.16';
  szOID_POSTAL_CODE                   = '2.5.4.17'; // case-ignore string
  szOID_POST_OFFICE_BOX               = '2.5.4.18'; // case-ignore string
  szOID_PHYSICAL_DELIVERY_OFFICE_NAME = '2.5.4.19'; // case-ignore string

  // Telecommunications addressing attribute types:
  szOID_TELEPHONE_NUMBER             = '2.5.4.20'; // telephone number
  szOID_TELEX_NUMBER                 = '2.5.4.21';
  szOID_TELETEXT_TERMINAL_IDENTIFIER = '2.5.4.22';
  szOID_FACSIMILE_TELEPHONE_NUMBER   = '2.5.4.23';
  szOID_X21_ADDRESS                  = '2.5.4.24'; // numeric string
  szOID_INTERNATIONAL_ISDN_NUMBER    = '2.5.4.25'; // numeric string
  szOID_REGISTERED_ADDRESS           = '2.5.4.26';
  szOID_DESTINATION_INDICATOR        = '2.5.4.27'; // printable string

  // Preference attribute types:
  szOID_PREFERRED_DELIVERY_METHOD = '2.5.4.28';

  // OSI application attribute types:
  szOID_PRESENTATION_ADDRESS          = '2.5.4.29';
  szOID_SUPPORTED_APPLICATION_CONTEXT = '2.5.4.30';

  // Relational application attribute types:
  szOID_MEMBER        = '2.5.4.31';
  szOID_OWNER         = '2.5.4.32';
  szOID_ROLE_OCCUPANT = '2.5.4.33';
  szOID_SEE_ALSO      = '2.5.4.34';

  // Security attribute types:
  szOID_USER_PASSWORD               = '2.5.4.35';
  szOID_USER_CERTIFICATE            = '2.5.4.36';
  szOID_CA_CERTIFICATE              = '2.5.4.37';
  szOID_AUTHORITY_REVOCATION_LIST   = '2.5.4.38';
  szOID_CERTIFICATE_REVOCATION_LIST = '2.5.4.39';
  szOID_CROSS_CERTIFICATE_PAIR      = '2.5.4.40';

  // Undocumented attribute types???
  //#define szOID_???                         '2.5.4.41'
  szOID_GIVEN_NAME = '2.5.4.42'; // case-ignore string
  szOID_INITIALS   = '2.5.4.43'; // case-ignore string

  // The DN Qualifier attribute type specifies disambiguating information to add
  // to the relative distinguished name of an entry. It is intended to be used
  // for entries held in multiple DSAs which would otherwise have the same name,
  // and that its value be the same in a given DSA for all entries to which
  // the information has been added.
  szOID_DN_QUALIFIER = '2.5.4.46';

  // Pilot user attribute types:
  szOID_DOMAIN_COMPONENT = '0.9.2342.19200300.100.1.25'; // IA5, UTF8 string

  // used for PKCS 12 attributes
  szOID_PKCS_12_FRIENDLY_NAME_ATTR     = '1.2.840.113549.1.9.20';
  szOID_PKCS_12_LOCAL_KEY_ID           = '1.2.840.113549.1.9.21';
  szOID_PKCS_12_KEY_PROVIDER_NAME_ATTR = '1.3.6.1.4.1.311.17.1';
  szOID_LOCAL_MACHINE_KEYSET           = '1.3.6.1.4.1.311.17.2';

  //+-------------------------------------------------------------------------
  //  Microsoft CERT_RDN attribute Object Identifiers
  //--------------------------------------------------------------------------
  // Special RDN containing the KEY_ID. Its value type is CERT_RDN_OCTET_STRING.
  szOID_KEYID_RDN = '1.3.6.1.4.1.311.10.7.1';

  //+-------------------------------------------------------------------------
  //  CERT_RDN Attribute Value Types
  //
  //  For RDN_ENCODED_BLOB, the Value's CERT_RDN_VALUE_BLOB is in its encoded
  //  representation. Otherwise, its an array of bytes.
  //
  //  For all CERT_RDN types, Value.cbData is always the number of bytes, not
  //  necessarily the number of elements in the string. For instance,
  //  RDN_UNIVERSAL_STRING is an array of ints (cbData == intCnt * 4) and
  //  RDN_BMP_STRING is an array of unsigned shorts (cbData == ushortCnt * 2).
  //
  //  A RDN_UTF8_STRING is an array of UNICODE characters (cbData == charCnt *2).
  //  These UNICODE characters are encoded as UTF8 8 bit characters.
  //
  //  For CertDecodeName, two 0 bytes are always appended to the end of the
  //  string (ensures a CHAR or WCHAR string is null terminated).
  //  These added 0 bytes are't included in the BLOB.cbData.
  //--------------------------------------------------------------------------
  CERT_RDN_ANY_TYPE         = 0;
  CERT_RDN_ENCODED_BLOB     = 1;
  CERT_RDN_OCTET_STRING     = 2;
  CERT_RDN_NUMERIC_STRING   = 3;
  CERT_RDN_PRINTABLE_STRING = 4;
  CERT_RDN_TELETEX_STRING   = 5;
  CERT_RDN_T61_STRING       = 5;
  CERT_RDN_VIDEOTEX_STRING  = 6;
  CERT_RDN_IA5_STRING       = 7;
  CERT_RDN_GRAPHIC_STRING   = 8;
  CERT_RDN_VISIBLE_STRING   = 9;
  CERT_RDN_ISO646_STRING    = 9;
  CERT_RDN_GENERAL_STRING   = 10;
  CERT_RDN_UNIVERSAL_STRING = 11;
  CERT_RDN_INT4_STRING      = 11;
  CERT_RDN_BMP_STRING       = 12;
  CERT_RDN_UNICODE_STRING   = 12;
  CERT_RDN_UTF8_STRING      = 13;

  CERT_RDN_TYPE_MASK  = $000000FF;
  CERT_RDN_FLAGS_MASK = $FF000000;

  //+-------------------------------------------------------------------------
  //  Flags that can be or'ed with the above Value Type when encoding/decoding
  //--------------------------------------------------------------------------
  // For encoding: when set, CERT_RDN_T61_STRING is selected instead of
  // CERT_RDN_UNICODE_STRING if all the unicode characters are <= 0xFF
  CERT_RDN_ENABLE_T61_UNICODE_FLAG = $80000000;

  // For encoding: when set, CERT_RDN_UTF8_STRING is selected instead of
  // CERT_RDN_UNICODE_STRING.
  CERT_RDN_ENABLE_UTF8_UNICODE_FLAG = $20000000;

  // For encoding: when set, the characters aren't checked to see if they
  // are valid for the Value Type.
  CERT_RDN_DISABLE_CHECK_TYPE_FLAG = $40000000;

  // For decoding: by default, CERT_RDN_T61_STRING values are initially decoded
  // as UTF8. If the UTF8 decoding fails, then, decoded as 8 bit characters.
  // Setting this flag skips the initial attempt to decode as UTF8.
  CERT_RDN_DISABLE_IE4_UTF8_FLAG = $01000000;

  // Macro to check that the dwValueType is a character string and not an
  // encoded blob or octet string
function IS_CERT_RDN_CHAR_STRING(X: DWORD): boolean;

//+-------------------------------------------------------------------------
//  A CERT_RDN consists of an array of the above attributes
//--------------------------------------------------------------------------
type
  CERT_RDN = record
    cRDNAttr:  DWORD;
    rgRDNAttr: PCERT_RDN_ATTR;
  end;
  PCERT_RDN = ^CERT_RDN;

  //+-------------------------------------------------------------------------
  //  Information stored in a subject's or issuer's name. The information
  //  is represented as an array of the above RDNs.
  //--------------------------------------------------------------------------
  CERT_NAME_INFO = record
    cRDN:  DWORD;
    rgRDN: PCERT_RDN;
  end;
  PCERT_NAME_INFO = ^CERT_NAME_INFO;

  //+-------------------------------------------------------------------------
  //  Name attribute value without the Object Identifier
  //
  //  The interpretation of the Value depends on the dwValueType.
  //  See above for a list of the types.
  //--------------------------------------------------------------------------
  CERT_NAME_VALUE = record
    dwValueType: DWORD;
    Value:       CERT_RDN_VALUE_BLOB;
  end;
  PCERT_NAME_VALUE = ^CERT_NAME_VALUE;

  //+-------------------------------------------------------------------------
  //  Public Key Info
  //
  //  The PublicKey is the encoded representation of the information as it is
  //  stored in the bit string
  //--------------------------------------------------------------------------
  CERT_PUBLIC_KEY_INFO = record
    Algorithm: CRYPT_ALGORITHM_IDENTIFIER;
    PublicKey: CRYPT_BIT_BLOB;
  end;
  PCERT_PUBLIC_KEY_INFO = ^CERT_PUBLIC_KEY_INFO;

const
  CERT_RSA_PUBLIC_KEY_OBJID        = szOID_RSA_RSA;
  CERT_DEFAULT_OID_PUBLIC_KEY_SIGN = szOID_RSA_RSA;
  CERT_DEFAULT_OID_PUBLIC_KEY_XCHG = szOID_RSA_RSA;

  //+-------------------------------------------------------------------------
  //  structure that contains all the information in a PKCS#8 PrivateKeyInfo
  //--------------------------------------------------------------------------
type
  CRYPT_PRIVATE_KEY_INFO = record
    Version:     DWORD;
    Algorithm:   CRYPT_ALGORITHM_IDENTIFIER;
    PrivateKey:  CRYPT_DER_BLOB;
    pAttributes: PCRYPT_ATTRIBUTES;
  end;
  PCRYPT_PRIVATE_KEY_INFO = CRYPT_PRIVATE_KEY_INFO;

  //+-------------------------------------------------------------------------
  //  structure that contains all the information in a PKCS#8
  //  EncryptedPrivateKeyInfo
  //--------------------------------------------------------------------------
  CRYPT_ENCRYPTED_PRIVATE_KEY_INFO = record
    EncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    EncryptedPrivateKey: CRYPT_DATA_BLOB;
  end;
  PCRYPT_ENCRYPTED_PRIVATE_KEY_INFO = ^CRYPT_ENCRYPTED_PRIVATE_KEY_INFO;

  //+-------------------------------------------------------------------------
  // this callback is given when an EncryptedProvateKeyInfo structure is
  // encountered during ImportPKCS8.  the caller is then expected to decrypt
  // the private key and hand back the decrypted contents.
  //
  // the parameters are:
  // Algorithm - the algorithm used to encrypt the PrivateKeyInfo
  // EncryptedPrivateKey - the encrypted private key blob
  // pClearTextKey - a buffer to receive the clear text
  // cbClearTextKey - the number of bytes of the pClearTextKey buffer
  //                  note the if this is zero then this should be
  //                  filled in with the size required to decrypt the
  //                  key into, and pClearTextKey should be ignored
  // pVoidDecryptFunc - this is the pVoid that was passed into the call
  //                    and is preserved and passed back as context
  //+-------------------------------------------------------------------------
  PCRYPT_DECRYPT_PRIVATE_KEY_FUNC = function(
    Algorithm: CRYPT_ALGORITHM_IDENTIFIER;
    EncryptedPrivateKey: CRYPT_DATA_BLOB;
    pbClearTextKey: PBYTE;
    var pcbClearTextKey: DWORD;
    pVoidDecryptFunc: pointer
    ): BOOL; stdcall;

  //+-------------------------------------------------------------------------
  // this callback is given when creating a PKCS8 EncryptedPrivateKeyInfo.
  // The caller is then expected to encrypt the private key and hand back
  // the encrypted contents.
  //
  // the parameters are:
  // Algorithm - the algorithm used to encrypt the PrivateKeyInfo
  // pClearTextPrivateKey - the cleartext private key to be encrypted
  // pbEncryptedKey - the output encrypted private key blob
  // cbEncryptedKey - the number of bytes of the pbEncryptedKey buffer
  //                  note the if this is zero then this should be
  //                  filled in with the size required to encrypt the
  //                  key into, and pbEncryptedKey should be ignored
  // pVoidEncryptFunc - this is the pVoid that was passed into the call
  //                    and is preserved and passed back as context
  //+-------------------------------------------------------------------------
  PCRYPT_ENCRYPT_PRIVATE_KEY_FUNC = function(
    var pAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    var pClearTextPrivateKey: CRYPT_DATA_BLOB;
    pbEncryptedKey: PBYTE;
    var pcbEncryptedKey: DWORD;
    pVoidEncryptFunc: pointer
    ): BOOL; stdcall;

  //+-------------------------------------------------------------------------
  // this callback is given from the context of a ImportPKCS8 calls.  the caller
  // is then expected to hand back an HCRYPTPROV to receive the key being imported
  //
  // the parameters are:
  // pPrivateKeyInfo - pointer to a CRYPT_PRIVATE_KEY_INFO structure which
  //                   describes the key being imported
  // EncryptedPrivateKey - the encrypted private key blob
  // phCryptProv - a pointer to a HCRRYPTPROV to be filled in
  // pVoidResolveFunc - this is the pVoidResolveFunc passed in by the caller in the
  //                    CRYPT_PRIVATE_KEY_BLOB_AND_PARAMS struct
  //+-------------------------------------------------------------------------
  PCRYPT_RESOLVE_HCRYPTPROV_FUNC = function(
    var pPrivateKeyInfo: CRYPT_PRIVATE_KEY_INFO;
    var phCryptProv: HCRYPTPROV;
    pVoidResolveFunc: pointer
    ): BOOL; stdcall;

  //+-------------------------------------------------------------------------
  // this struct contains a PKCS8 private key and two pointers to callback
  // functions, with a corresponding pVoids.  the first callback is used to give
  // the caller the opportunity to specify where the key is imported to.  the callback
  // passes the caller the algoroithm OID and key size to use in making the decision.
  // the other callback is used to decrypt the private key if the PKCS8 contains an
  // EncryptedPrivateKeyInfo.  both pVoids are preserved and passed back to the caller
  // in the respective callback
  //+-------------------------------------------------------------------------
  CRYPT_PKCS8_IMPORT_PARAMS = record
    PrivateKey:             CRYPT_DIGEST_BLOB; // PKCS8 blob
    pResolvehCryptProvFunc: PCRYPT_RESOLVE_HCRYPTPROV_FUNC; // optional
    pVoidResolveFunc:       pointer; // optional
    pDecryptPrivateKeyFunc: PCRYPT_DECRYPT_PRIVATE_KEY_FUNC;
    pVoidDecryptFunc:       pointer;
  end;
  PCRYPT_PKCS8_IMPORT_PARAMS = ^CRYPT_PKCS8_IMPORT_PARAMS;
  CRYPT_PRIVATE_KEY_BLOB_AND_PARAMS = CRYPT_PKCS8_IMPORT_PARAMS;
  PCRYPT_PRIVATE_KEY_BLOB_AND_PARAMS = ^CRYPT_PRIVATE_KEY_BLOB_AND_PARAMS;

  //+-------------------------------------------------------------------------
  // this struct contains information identifying a private key and a pointer
  // to a callback function, with a corresponding pVoid. The callback is used
  // to encrypt the private key. If the pEncryptPrivateKeyFunc is NULL, the
  // key will not be encrypted and an EncryptedPrivateKeyInfo will not be generated.
  // The pVoid is preserved and passed back to the caller in the respective callback
  //+-------------------------------------------------------------------------
  CRYPT_PKCS8_EXPORT_PARAMS = record
    hCryptProv:             HCRYPTPROV;
    dwKeySpec:              DWORD;
    pszPrivateKeyObjId:     LPSTR;
    pEncryptPrivateKeyFunc: PCRYPT_ENCRYPT_PRIVATE_KEY_FUNC;
    pVoidEncryptFunc:       pointer;
  end;
  PCRYPT_PKCS8_EXPORT_PARAMS = ^CRYPT_PKCS8_EXPORT_PARAMS;

  //+-------------------------------------------------------------------------
  //  Information stored in a certificate
  //
  //  The Issuer, Subject, Algorithm, PublicKey and Extension BLOBs are the
  //  encoded representation of the information.
  //--------------------------------------------------------------------------
  TARR_CERT_EXTENSION = PCERT_EXTENSION;
  CERT_INFO = record
    dwVersion:            DWORD;
    SerialNumber:         CRYPT_INTEGER_BLOB;
    SignatureAlgorithm:   CRYPT_ALGORITHM_IDENTIFIER;
    Issuer:               CERT_NAME_BLOB;
    NotBefore:            FILETIME;
    NotAfter:             FILETIME;
    Subject:              CERT_NAME_BLOB;
    SubjectPublicKeyInfo: CERT_PUBLIC_KEY_INFO;
    IssuerUniqueId:       CRYPT_BIT_BLOB;
    SubjectUniqueId:      CRYPT_BIT_BLOB;
    cExtension:           DWORD;
    rgExtension:          TARR_CERT_EXTENSION;
  end;
  PCERT_INFO = ^CERT_INFO;

  //+-------------------------------------------------------------------------
  //  Certificate versions
  //--------------------------------------------------------------------------
const
  CERT_V1 = 0;
  CERT_V2 = 1;
  CERT_V3 = 2;

  //+-------------------------------------------------------------------------
  //  Certificate Information Flags
  //--------------------------------------------------------------------------
  CERT_INFO_VERSION_FLAG                 = 1;
  CERT_INFO_SERIAL_NUMBER_FLAG           = 2;
  CERT_INFO_SIGNATURE_ALGORITHM_FLAG     = 3;
  CERT_INFO_ISSUER_FLAG                  = 4;
  CERT_INFO_NOT_BEFORE_FLAG              = 5;
  CERT_INFO_NOT_AFTER_FLAG               = 6;
  CERT_INFO_SUBJECT_FLAG                 = 7;
  CERT_INFO_SUBJECT_PUBLIC_KEY_INFO_FLAG = 8;
  CERT_INFO_ISSUER_UNIQUE_ID_FLAG        = 9;
  CERT_INFO_SUBJECT_UNIQUE_ID_FLAG       = 10;
  CERT_INFO_EXTENSION_FLAG               = 11;

  //+-------------------------------------------------------------------------
  //  An entry in a CRL
  //
  //  The Extension BLOBs are the encoded representation of the information.
  //--------------------------------------------------------------------------
type
  CRL_ENTRY = record
    SerialNumber:   CRYPT_INTEGER_BLOB;
    RevocationDate: FILETIME;
    cExtension:     DWORD;
    rgExtension:    PCERT_EXTENSION;
  end;
  PCRL_ENTRY = ^CRL_ENTRY;

  //+-------------------------------------------------------------------------
  //  Information stored in a CRL
  //
  //  The Issuer, Algorithm and Extension BLOBs are the encoded
  //  representation of the information.
  //--------------------------------------------------------------------------
  CRL_INFO = record
    dwVersion:          DWORD;
    SignatureAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    Issuer:             CERT_NAME_BLOB;
    ThisUpdate:         FILETIME;
    NextUpdate:         FILETIME;
    cCRLEntry:          DWORD;
    rgCRLEntry:         PCRL_ENTRY;
    cExtension:         DWORD;
    rgExtension:        PCERT_EXTENSION;
  end;
  PCRL_INFO = ^CRL_INFO;

  //+-------------------------------------------------------------------------
  //  CRL versions
  //--------------------------------------------------------------------------
const
  CRL_V1 = 0;
  CRL_V2 = 1;

  //+-------------------------------------------------------------------------
  //  Information stored in a certificate request
  //
  //  The Subject, Algorithm, PublicKey and Attribute BLOBs are the encoded
  //  representation of the information.
  //--------------------------------------------------------------------------
type
  CERT_REQUEST_INFO = record
    dwVersion:            DWORD;
    Subject:              CERT_NAME_BLOB;
    SubjectPublicKeyInfo: CERT_PUBLIC_KEY_INFO;
    cAttribute:           DWORD;
    rgAttribute:          PCRYPT_ATTRIBUTE;
  end;
  PCERT_REQUEST_INFO = ^CERT_REQUEST_INFO;

  //+-------------------------------------------------------------------------
  //  Certificate Request versions
  //--------------------------------------------------------------------------
const
  CERT_REQUEST_V1 = 0;

  //+-------------------------------------------------------------------------
  //  Information stored in Netscape's Keygen request
  //--------------------------------------------------------------------------
type
  CERT_KEYGEN_REQUEST_INFO = record
    dwVersion:            DWORD;
    SubjectPublicKeyInfo: CERT_PUBLIC_KEY_INFO;
    pwszChallengeString:  LPWSTR; // encoded as IA5
  end;
  PCERT_KEYGEN_REQUEST_INFO = ^CERT_KEYGEN_REQUEST_INFO;

const
  CERT_KEYGEN_REQUEST_V1 = 0;

  //+-------------------------------------------------------------------------
  //  Certificate, CRL, Certificate Request or Keygen Request Signed Content
  //
  //  The "to be signed" encoded content plus its signature. The ToBeSigned
  //  is the encoded CERT_INFO, CRL_INFO, CERT_REQUEST_INFO or
  //  CERT_KEYGEN_REQUEST_INFO.
  //--------------------------------------------------------------------------
type
  CERT_SIGNED_CONTENT_INFO = record
    ToBeSigned:         CRYPT_DER_BLOB;
    SignatureAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    Signature:          CRYPT_BIT_BLOB;
  end;
  PCERT_SIGNED_CONTENT_INFO = ^CERT_SIGNED_CONTENT_INFO;

  //+-------------------------------------------------------------------------
  //  Certificate Trust List (CTL)
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CTL Usage. Also used for EnhancedKeyUsage extension.
  //--------------------------------------------------------------------------
  TARR_LPSTR = ^LPSTR; {My type. Oleg}
  CTL_USAGE = record
    cUsageIdentifier:     DWORD;
    rgpszUsageIdentifier: TARR_LPSTR; // array of pszObjId
  end;
  PCTL_USAGE = ^CTL_USAGE;
  CERT_ENHKEY_USAGE = CTL_USAGE;
  PCERT_ENHKEY_USAGE = ^CERT_ENHKEY_USAGE;

  //+-------------------------------------------------------------------------
  //  An entry in a CTL
  //--------------------------------------------------------------------------
  CTL_ENTRY = record
    SubjectIdentifier: CRYPT_DATA_BLOB; // For example, its hash
    cAttribute:        DWORD;
    rgAttribute:       PCRYPT_ATTRIBUTE; // OPTIONAL
  end;
  PCTL_ENTRY = ^CTL_ENTRY;

  //+-------------------------------------------------------------------------
  //  Information stored in a CTL
  //--------------------------------------------------------------------------
  CTL_INFO = record
    dwVersion:        DWORD;
    SubjectUsage:     CTL_USAGE;
    ListIdentifier:   CRYPT_DATA_BLOB; // OPTIONAL
    SequenceNumber:   CRYPT_INTEGER_BLOB; // OPTIONAL
    ThisUpdate:       FILETIME;
    NextUpdate:       FILETIME; // OPTIONAL
    SubjectAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    cCTLEntry:        DWORD;
    rgCTLEntry:       PCTL_ENTRY; // OPTIONAL
    cExtension:       DWORD;
    rgExtension:      PCERT_EXTENSION; // OPTIONAL
  end;
  PCTL_INFO = ^CTL_INFO;

  //+-------------------------------------------------------------------------
  //  CTL versions
  //--------------------------------------------------------------------------
const
  CTL_V1 = 0;

  //+-------------------------------------------------------------------------
  //  TimeStamp Request
  //
  //  The pszTimeStamp is the OID for the Time type requested
  //  The pszContentType is the Content Type OID for the content, usually DATA
  //  The Content is a un-decoded blob
  //--------------------------------------------------------------------------
type
  CRYPT_TIME_STAMP_REQUEST_INFO = record
    pszTimeStampAlgorithm: LPSTR; // pszObjId
    pszContentType:        LPSTR; // pszObjId
    Content:               CRYPT_OBJID_BLOB;
    cAttribute:            DWORD;
    rgAttribute:           PCRYPT_ATTRIBUTE;
  end;
  PCRYPT_TIME_STAMP_REQUEST_INFO = ^CRYPT_TIME_STAMP_REQUEST_INFO;

  //+-------------------------------------------------------------------------
  //  Name Value Attribute
  //--------------------------------------------------------------------------
  CRYPT_ENROLLMENT_NAME_VALUE_PAIR = record
    pwszName:  LPWSTR;
    pwszValue: LPWSTR;
  end;
  PCRYPT_ENROLLMENT_NAME_VALUE_PAIR = ^CRYPT_ENROLLMENT_NAME_VALUE_PAIR;

  //+-------------------------------------------------------------------------
  //  CSP Provider
  //--------------------------------------------------------------------------
  CRYPT_CSP_PROVIDER = record
    dwKeySpec:        DWORD;
    pwszProviderName: LPWSTR;
    Signature:        CRYPT_BIT_BLOB;
  end;
  PCRYPT_CSP_PROVIDER = ^CRYPT_CSP_PROVIDER;

  //+-------------------------------------------------------------------------
  //  Certificate and Message encoding types
  //
  //  The encoding type is a DWORD containing both the certificate and message
  //  encoding types. The certificate encoding type is stored in the LOWORD.
  //  The message encoding type is stored in the HIWORD. Some functions or
  //  structure fields require only one of the encoding types. The following
  //  naming convention is used to indicate which encoding type(s) are
  //  required:
  //      dwEncodingType              (both encoding types are required)
  //      dwMsgAndCertEncodingType    (both encoding types are required)
  //      dwMsgEncodingType           (only msg encoding type is required)
  //      dwCertEncodingType          (only cert encoding type is required)
  //
  //  Its always acceptable to specify both.
  //--------------------------------------------------------------------------
const
  CERT_ENCODING_TYPE_MASK = $0000FFFF;
  CMSG_ENCODING_TYPE_MASK = $FFFF0000;

function GET_CERT_ENCODING_TYPE(X: DWORD): DWORD;
function GET_CMSG_ENCODING_TYPE(X: DWORD): DWORD;

const
  CRYPT_ASN_ENCODING  = $00000001;
  CRYPT_NDR_ENCODING  = $00000002;
  X509_ASN_ENCODING   = $00000001;
  X509_NDR_ENCODING   = $00000002;
  PKCS_7_ASN_ENCODING = $00010000;
  PKCS_7_NDR_ENCODING = $00020000;

  //+-------------------------------------------------------------------------
  //  format the specified data structure according to the certificate
  //  encoding type.
  //
  //  The default behavior of CryptFormatObject is to return single line
  //  display of the encoded data, that is, each subfield will be concatenated with
  //  a ", " on one line.  If user prefers to display the data in multiple line,
  //  set the flag CRYPT_FORMAT_STR_MULTI_LINE, that is, each subfield will be displayed
  //  on a seperate line.
  //
  //  If there is no formatting routine installed or registered
  //  for the lpszStructType, the hex dump of the encoded BLOB will be returned.
  //  User can set the flag CRYPT_FORMAT_STR_NO_HEX to disable the hex dump.
  //--------------------------------------------------------------------------

function CryptFormatObject(
  dwCertEncodingType: DWORD;
  dwFormatType: DWORD;
  dwFormatStrType: DWORD;
  pFormatStruct: pointer;
  lpszStructType: LPCSTR;
  pbEncoded: PBYTE;
  cbEncoded: DWORD;
  pbFormat: pointer;
  var pcbFormat: DWORD
  ): BOOL; stdcall;
//-------------------------------------------------------------------------
// constants for dwFormatStrType of function CryptFormatObject
//-------------------------------------------------------------------------
const
  CRYPT_FORMAT_STR_MULTI_LINE = $0001;
  CRYPT_FORMAT_STR_NO_HEX     = $0010;

  //-------------------------------------------------------------------------
  // constants for dwFormatType of function CryptFormatObject
  // when format X509_NAME or X509_UNICODE_NAME
  //-------------------------------------------------------------------------
  // Just get the simple string
  CRYPT_FORMAT_SIMPLE = $0001;

  //Put an attribute name infront of the attribute
  //such as "O=Microsoft,DN=xiaohs"
  CRYPT_FORMAT_X509 = $0002;

  //Put an OID infront of the simple string, such as
  //"2.5.4.22=Microsoft,2.5.4.3=xiaohs"
  CRYPT_FORMAT_OID = $0004;

  //Put a ";" between each RDN.  The default is ","
  CRYPT_FORMAT_RDN_SEMICOLON = $0100;

  //Put a "\n" between each RDN.
  CRYPT_FORMAT_RDN_CRLF = $0200;

  //Unquote the DN value, which is quoated by default va the following
  //rules: if the DN contains leading or trailing
  //white space or one of the following characters: ",", "+", "=",
  //""", "\n",  "<", ">", "#" or ";". The quoting character is ".
  //If the DN Value contains a " it is double quoted ("").
  CRYPT_FORMAT_RDN_UNQUOTE = $0400;

  //reverse the order of the RDNs before converting to the string
  CRYPT_FORMAT_RDN_REVERSE = $0800;

  //-------------------------------------------------------------------------
  //  contants dwFormatType of function CryptFormatObject when format a DN.:
  //
  //  The following three values are defined in the section above:
  //  CRYPT_FORMAT_SIMPLE:    Just a simple string
  //                          such as  "Microsoft+xiaohs+NT"
  //  CRYPT_FORMAT_X509       Put an attribute name infront of the attribute
  //                          such as "O=Microsoft+xiaohs+NT"
  //
  //  CRYPT_FORMAT_OID        Put an OID infront of the simple string,
  //                          such as "2.5.4.22=Microsoft+xiaohs+NT"
  //
  //  Additional values are defined as following:
  //----------------------------------------------------------------------------
  //Put a "," between each value.  Default is "+"
  CRYPT_FORMAT_COMMA = $1000;

  //Put a ";" between each value
  CRYPT_FORMAT_SEMICOLON = CRYPT_FORMAT_RDN_SEMICOLON;

  //Put a "\n" between each value
  CRYPT_FORMAT_CRLF = CRYPT_FORMAT_RDN_CRLF;

  //+-------------------------------------------------------------------------
  //  Encode / decode the specified data structure according to the certificate
  //  encoding type.
  //
  //  See below for a list of the predefined data structures.
  //--------------------------------------------------------------------------
type
  PFN_CRYPT_ALLOC = function(
    cbSize: DWORD
    ): pointer; stdcall;
  PFN_CRYPT_FREE = procedure(
    pv: pointer
    ); stdcall;

  CRYPT_ENCODE_PARA = record
    cbSize:   DWORD;
    pfnAlloc: PFN_CRYPT_ALLOC; // OPTIONAL
    pfnFree:  PFN_CRYPT_FREE; // OPTIONAL
  end;
  PCRYPT_ENCODE_PARA = ^CRYPT_ENCODE_PARA;

function CryptEncodeObjectEx(
  dwCertEncodingType: DWORD;
  lpszStructType: LPCSTR;
  pvStructInfo: pointer;
  dwFlags: DWORD;
  pEncodePara: PCRYPT_ENCODE_PARA;
  pvEncoded: pointer;
  out pcbEncoded: DWORD
  ): BOOL; stdcall;

function CryptEncodeObject(
  dwCertEncodingType: DWORD;
  lpszStructType: LPCSTR;
  pvStructInfo: pointer;
  pbEncoded: PBYTE;
  var pcbEncoded: DWORD
  ): BOOL; stdcall;

// By default the signature bytes are reversed. The following flag can
// be set to inhibit the byte reversal.
//
// This flag is applicable to
//      X509_CERT_TO_BE_SIGNED
const
  CRYPT_ENCODE_NO_SIGNATURE_BYTE_REVERSAL_FLAG = $8;

  //  When the following flag is set the called encode function allocates
  //  memory for the encoded bytes. A pointer to the allocated bytes
  //  is returned in pvEncoded. If pEncodePara or pEncodePara->pfnAlloc is
  //  NULL, then, LocalAlloc is called for the allocation and LocalFree must
  //  be called to do the free. Otherwise, pEncodePara->pfnAlloc is called
  //  for the allocation.
  //
  //  *pcbEncoded is ignored on input and updated with the length of the
  //  allocated, encoded bytes.
  //
  //  If pfnAlloc is set, then, pfnFree should also be set.
  CRYPT_ENCODE_ALLOC_FLAG = $8000;

  //  The following flag is applicable when encoding X509_UNICODE_NAME.
  //  When set, CERT_RDN_T61_STRING is selected instead of
  //  CERT_RDN_UNICODE_STRING if all the unicode characters are <= 0xFF
  CRYPT_UNICODE_NAME_ENCODE_ENABLE_T61_UNICODE_FLAG =
    CERT_RDN_ENABLE_T61_UNICODE_FLAG;

  //  The following flag is applicable when encoding X509_UNICODE_NAME.
  //  When set, CERT_RDN_UTF8_STRING is selected instead of
  //  CERT_RDN_UNICODE_STRING.
  CRYPT_UNICODE_NAME_ENCODE_ENABLE_UTF8_UNICODE_FLAG =
    CERT_RDN_ENABLE_UTF8_UNICODE_FLAG;

  //  The following flag is applicable when encoding X509_UNICODE_NAME,
  //  X509_UNICODE_NAME_VALUE or X509_UNICODE_ANY_STRING.
  //  When set, the characters aren't checked to see if they
  //  are valid for the specified Value Type.
  CRYPT_UNICODE_NAME_ENCODE_DISABLE_CHECK_TYPE_FLAG =
    CERT_RDN_DISABLE_CHECK_TYPE_FLAG;

  //  The following flag is applicable when encoding the PKCS_SORTED_CTL. This
  //  flag should be set if the identifier for the TrustedSubjects is a hash,
  //  such as, MD5 or SHA1.
  CRYPT_SORTED_CTL_ENCODE_HASHED_SUBJECT_IDENTIFIER_FLAG = $10000;

type
  CRYPT_DECODE_PARA = record
    cbSize:   DWORD;
    pfnAlloc: PFN_CRYPT_ALLOC; // OPTIONAL
    pfnFree:  PFN_CRYPT_FREE; // OPTIONAL
  end;
  PCRYPT_DECODE_PARA = ^CRYPT_DECODE_PARA;

function CryptDecodeObjectEx(
  dwCertEncodingType: DWORD;
  lpszStructType: LPCSTR;
  pbEncoded: PBYTE;
  cbEncoded: DWORD;
  dwFlags: DWORD;
  pDecodePara: PCRYPT_DECODE_PARA;
  pvStructInfo: pointer;
  var pcbStructInfo: DWORD
  ): BOOL; stdcall;

function CryptDecodeObject(
  dwCertEncodingType: DWORD;
  lpszStructType: LPCSTR;
  pbEncoded: PBYTE;
  cbEncoded: DWORD;
  dwFlags: DWORD;
  pvStructInfo: pointer;
  var pcbStructInfo: DWORD
  ): BOOL; stdcall;

// When the following flag is set the nocopy optimization is enabled.
// This optimization where appropriate, updates the pvStructInfo fields
// to point to content residing within pbEncoded instead of making a copy
// of and appending to pvStructInfo.
//
// Note, when set, pbEncoded can't be freed until pvStructInfo is freed.
const
  CRYPT_DECODE_NOCOPY_FLAG = $1;

  // For CryptDecodeObject(), by default the pbEncoded is the "to be signed"
  // plus its signature. Set the following flag, if pbEncoded points to only
  // the "to be signed".
  //
  // This flag is applicable to
  //      X509_CERT_TO_BE_SIGNED
  //      X509_CERT_CRL_TO_BE_SIGNED
  //      X509_CERT_REQUEST_TO_BE_SIGNED
  //      X509_KEYGEN_REQUEST_TO_BE_SIGNED
  CRYPT_DECODE_TO_BE_SIGNED_FLAG = $2;

  // When the following flag is set, the OID strings are allocated in
  // crypt32.dll and shared instead of being copied into the returned
  // data structure. This flag may be set if crypt32.dll isn't unloaded
  // before the caller is unloaded.
  CRYPT_DECODE_SHARE_OID_STRING_FLAG = $4;

  // By default the signature bytes are reversed. The following flag can
  // be set to inhibit the byte reversal.
  //
  // This flag is applicable to
  //      X509_CERT_TO_BE_SIGNED
  CRYPT_DECODE_NO_SIGNATURE_BYTE_REVERSAL_FLAG = $8;

  // When the following flag is set the called decode function allocates
  // memory for the decoded structure. A pointer to the allocated structure
  // is returned in pvStructInfo. If pDecodePara or pDecodePara->pfnAlloc is
  // NULL, then, LocalAlloc is called for the allocation and LocalFree must
  // be called to do the free. Otherwise, pDecodePara->pfnAlloc is called
  // for the allocation.
  //
  // *pcbStructInfo is ignored on input and updated with the length of the
  // allocated, decoded structure.
  //
  // This flag may also be set in the CryptDecodeObject API. Since
  // CryptDecodeObject doesn't take a pDecodePara, LocalAlloc is always
  // called for the allocation which must be freed by calling LocalFree.
  CRYPT_DECODE_ALLOC_FLAG = $8000;

  // The following flag is applicable when decoding X509_UNICODE_NAME,
  // X509_UNICODE_NAME_VALUE or X509_UNICODE_ANY_STRING.
  // By default, CERT_RDN_T61_STRING values are initially decoded
  // as UTF8. If the UTF8 decoding fails, then, decoded as 8 bit characters.
  // Setting this flag skips the initial attempt to decode as UTF8.
  CRYPT_UNICODE_NAME_DECODE_DISABLE_IE4_UTF8_FLAG =
    CERT_RDN_DISABLE_IE4_UTF8_FLAG;

  //+-------------------------------------------------------------------------
  //  Predefined X509 certificate data structures that can be encoded / decoded.
  //--------------------------------------------------------------------------
  CRYPT_ENCODE_DECODE_NONE       = 0;
  X509_CERT                      = LPCSTR(1);
  X509_CERT_TO_BE_SIGNED         = LPCSTR(2);
  X509_CERT_CRL_TO_BE_SIGNED     = LPCSTR(3);
  X509_CERT_REQUEST_TO_BE_SIGNED = LPCSTR(4);
  X509_EXTENSIONS                = LPCSTR(5);
  X509_NAME_VALUE                = LPCSTR(6);
  X509_NAME                      = LPCSTR(7);
  X509_PUBLIC_KEY_INFO           = LPCSTR(8);

  //+-------------------------------------------------------------------------
  //  Predefined X509 certificate extension data structures that can be
  //  encoded / decoded.
  //--------------------------------------------------------------------------
  X509_AUTHORITY_KEY_ID      = LPCSTR(9);
  X509_KEY_ATTRIBUTES        = LPCSTR(10);
  X509_KEY_USAGE_RESTRICTION = LPCSTR(11);
  X509_ALTERNATE_NAME        = LPCSTR(12);
  X509_BASIC_CONSTRAINTS     = LPCSTR(13);
  X509_KEY_USAGE             = LPCSTR(14);
  X509_BASIC_CONSTRAINTS2    = LPCSTR(15);
  X509_CERT_POLICIES         = LPCSTR(16);

  //+-------------------------------------------------------------------------
  //  Additional predefined data structures that can be encoded / decoded.
  //--------------------------------------------------------------------------
  PKCS_UTC_TIME         = LPCSTR(17);
  PKCS_TIME_REQUEST     = LPCSTR(18);
  RSA_CSP_PUBLICKEYBLOB = LPCSTR(19);
  X509_UNICODE_NAME     = LPCSTR(20);

  X509_KEYGEN_REQUEST_TO_BE_SIGNED  = LPCSTR(21);
  PKCS_ATTRIBUTE                    = LPCSTR(22);
  PKCS_CONTENT_INFO_SEQUENCE_OF_ANY = LPCSTR(23);

  //+-------------------------------------------------------------------------
  //  Predefined primitive data structures that can be encoded / decoded.
  //--------------------------------------------------------------------------
  X509_UNICODE_NAME_VALUE = LPCSTR(24);
  X509_ANY_STRING         = X509_NAME_VALUE;
  X509_UNICODE_ANY_STRING = X509_UNICODE_NAME_VALUE;
  X509_OCTET_STRING       = LPCSTR(25);
  X509_BITS               = LPCSTR(26);
  X509_INTEGER            = LPCSTR(27);
  X509_MULTI_BYTE_INTEGER = LPCSTR(28);
  X509_ENUMERATED         = LPCSTR(29);
  X509_CHOICE_OF_TIME     = LPCSTR(30);

  //+-------------------------------------------------------------------------
  //  More predefined X509 certificate extension data structures that can be
  //  encoded / decoded.
  //--------------------------------------------------------------------------
  X509_AUTHORITY_KEY_ID2     = LPCSTR(31);
  X509_AUTHORITY_INFO_ACCESS = LPCSTR(32);
  X509_CRL_REASON_CODE       = X509_ENUMERATED;
  PKCS_CONTENT_INFO          = LPCSTR(33);
  X509_SEQUENCE_OF_ANY       = LPCSTR(34);
  X509_CRL_DIST_POINTS       = LPCSTR(35);
  X509_ENHANCED_KEY_USAGE    = LPCSTR(36);
  PKCS_CTL                   = LPCSTR(37);

  X509_MULTI_BYTE_UINT    = LPCSTR(38);
  X509_DSS_PUBLICKEY      = X509_MULTI_BYTE_UINT;
  X509_DSS_PARAMETERS     = LPCSTR(39);
  X509_DSS_SIGNATURE      = LPCSTR(40);
  PKCS_RC2_CBC_PARAMETERS = LPCSTR(41);
  PKCS_SMIME_CAPABILITIES = LPCSTR(42);

  //+-------------------------------------------------------------------------
  //  data structures for private keys
  //--------------------------------------------------------------------------
  PKCS_RSA_PRIVATE_KEY            = LPCSTR(43);
  PKCS_PRIVATE_KEY_INFO           = LPCSTR(44);
  PKCS_ENCRYPTED_PRIVATE_KEY_INFO = LPCSTR(45);

  //+-------------------------------------------------------------------------
  //  certificate policy qualifier
  //--------------------------------------------------------------------------
  X509_PKIX_POLICY_QUALIFIER_USERNOTICE = LPCSTR(46);

  //+-------------------------------------------------------------------------
  //  Diffie-Hellman Key Exchange
  //--------------------------------------------------------------------------
  X509_DH_PUBLICKEY  = X509_MULTI_BYTE_UINT;
  X509_DH_PARAMETERS = LPCSTR(47);
  PKCS_ATTRIBUTES    = LPCSTR(48);
  PKCS_SORTED_CTL    = LPCSTR(49);

  //+-------------------------------------------------------------------------
  //  X942 Diffie-Hellman
  //--------------------------------------------------------------------------
  X942_DH_PARAMETERS = LPCSTR(50);

  //+-------------------------------------------------------------------------
  //  The following is the same as X509_BITS, except before encoding,
  //  the bit length is decremented to exclude trailing zero bits.
  //--------------------------------------------------------------------------
  X509_BITS_WITHOUT_TRAILING_ZEROES = LPCSTR(51);

  //+-------------------------------------------------------------------------
  //  X942 Diffie-Hellman Other Info
  //--------------------------------------------------------------------------
  X942_OTHER_INFO             = LPCSTR(52);

  X509_CERT_PAIR              = LPCSTR(53);
  X509_ISSUING_DIST_POINT     = LPCSTR(54);
  X509_NAME_CONSTRAINTS       = LPCSTR(55);
  X509_POLICY_MAPPINGS        = LPCSTR(56);
  X509_POLICY_CONSTRAINTS     = LPCSTR(57);
  X509_CROSS_CERT_DIST_POINTS = LPCSTR(58);

//+-------------------------------------------------------------------------
//  Certificate Management Messages over CMS (CMC) Data Structures
//--------------------------------------------------------------------------
  CMC_DATA                    = LPCSTR(59);
  CMC_RESPONSE                = LPCSTR(60);
  CMC_STATUS                  = LPCSTR(61);
  CMC_ADD_EXTENSIONS          = LPCSTR(62);
  CMC_ADD_ATTRIBUTES          = LPCSTR(63);

//+-------------------------------------------------------------------------
//  Certificate Template
//--------------------------------------------------------------------------
  X509_CERTIFICATE_TEMPLATE   = LPCSTR(64);

  //+-------------------------------------------------------------------------
  //  Predefined PKCS #7 data structures that can be encoded / decoded.
  //--------------------------------------------------------------------------
  PKCS7_SIGNER_INFO = LPCSTR(500);

  //+-------------------------------------------------------------------------
  //  Predefined PKCS #7 data structures that can be encoded / decoded.
  //--------------------------------------------------------------------------
  CMS_SIGNER_INFO = LPCSTR(501);

  //+-------------------------------------------------------------------------
  //  Predefined Software Publishing Credential (SPC)  data structures that
  //  can be encoded / decoded.
  //
  //  Predefined values: 2000 .. 2999
  //
  //  See spc.h for value and data structure definitions.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  Extension Object Identifiers
  //--------------------------------------------------------------------------
  szOID_AUTHORITY_KEY_IDENTIFIER = '2.5.29.1';
  szOID_KEY_ATTRIBUTES           = '2.5.29.2';
  szOID_CERT_POLICIES_95         = '2.5.29.3';
  szOID_KEY_USAGE_RESTRICTION    = '2.5.29.4';
  szOID_SUBJECT_ALT_NAME         = '2.5.29.7';
  szOID_ISSUER_ALT_NAME          = '2.5.29.8';
  szOID_BASIC_CONSTRAINTS        = '2.5.29.10';
  szOID_KEY_USAGE                = '2.5.29.15';
  szOID_PRIVATEKEY_USAGE_PERIOD  = '2.5.29.16';
  szOID_BASIC_CONSTRAINTS2       = '2.5.29.19';
  szOID_CERT_POLICIES            = '2.5.29.32';
  szOID_ANY_CERT_POLICY          = '2.5.29.32.0';

  szOID_AUTHORITY_KEY_IDENTIFIER2 = '2.5.29.35';
  szOID_SUBJECT_KEY_IDENTIFIER    = '2.5.29.14';
  szOID_SUBJECT_ALT_NAME2         = '2.5.29.17';
  szOID_ISSUER_ALT_NAME2          = '2.5.29.18';
  szOID_CRL_REASON_CODE           = '2.5.29.21';
  szOID_REASON_CODE_HOLD          = '2.5.29.23';
  szOID_CRL_DIST_POINTS           = '2.5.29.31';
  szOID_ENHANCED_KEY_USAGE        = '2.5.29.37';

  // szOID_CRL_NUMBER -- Base CRLs only.  Monotonically increasing sequence
  // number for each CRL issued by a CA.
  szOID_CRL_NUMBER                = '2.5.29.20';
  // szOID_DELTA_CRL_INDICATOR -- Delta CRLs only.  Marked critical.
  // Contains the minimum base CRL Number that can be used with a delta CRL.
  szOID_DELTA_CRL_INDICATOR       = '2.5.29.27';
  szOID_ISSUING_DIST_POINT        = '2.5.29.28';
// szOID_FRESHEST_CRL -- Base CRLs only.  Formatted identically to a CDP
// extension that holds URLs to fetch the delta CRL.
  szOID_FRESHEST_CRL              = '2.5.29.46';
  szOID_NAME_CONSTRAINTS          = '2.5.29.30';

// Note on 1/1/2000 szOID_POLICY_MAPPINGS was changed from "2.5.29.5"
  szOID_POLICY_MAPPINGS           = '2.5.29.33';
  szOID_LEGACY_POLICY_MAPPINGS    = '2.5.29.5';
  szOID_POLICY_CONSTRAINTS        = '2.5.29.36';


  // Microsoft PKCS10 Attributes
  szOID_RENEWAL_CERTIFICATE        = '1.3.6.1.4.1.311.13.1';
  szOID_ENROLLMENT_NAME_VALUE_PAIR = '1.3.6.1.4.1.311.13.2.1';
  szOID_ENROLLMENT_CSP_PROVIDER    = '1.3.6.1.4.1.311.13.2.2';
  szOID_OS_VERSION                 = '1.3.6.1.4.1.311.13.2.3';

  //
  // Extension contain certificate type
  szOID_ENROLLMENT_AGENT = '1.3.6.1.4.1.311.20.2.1';

  // Internet Public Key Infrastructure (PKIX)
  szOID_PKIX = '1.3.6.1.5.5.7';
  szOID_PKIX_PE = '1.3.6.1.5.5.7.1';
  szOID_AUTHORITY_INFO_ACCESS = '1.3.6.1.5.5.7.1.1';

  // Microsoft extensions or attributes
  szOID_CERT_EXTENSIONS        = '1.3.6.1.4.1.311.2.1.14';
  szOID_NEXT_UPDATE_LOCATION   = '1.3.6.1.4.1.311.10.2';
  szOID_REMOVE_CERTIFICATE     = '1.3.6.1.4.1.311.10.8.1';
  szOID_CROSS_CERT_DIST_POINTS = '1.3.6.1.4.1.311.10.9.1';

  //  Microsoft PKCS #7 ContentType Object Identifiers
  szOID_CTL = '1.3.6.1.4.1.311.10.1';

  //  Microsoft Sorted CTL Extension Object Identifier
  szOID_SORTED_CTL = '1.3.6.1.4.1.311.10.1.1';

  // serialized serial numbers for PRS
  szOID_SERIALIZED = '1.3.6.1.4.1.311.10.3.3.1';

  // UPN principal name in SubjectAltName
  szOID_NT_PRINCIPAL_NAME = '1.3.6.1.4.1.311.20.2.3';

  // Windows product update unauthenticated attribute
  szOID_PRODUCT_UPDATE = '1.3.6.1.4.1.311.31.1';

  // CryptUI
  szOID_ANY_APPLICATION_POLICY = '1.3.6.1.4.1.311.10.12.1';

  //+-------------------------------------------------------------------------
  //  Object Identifiers for use with Auto Enrollment
  //--------------------------------------------------------------------------
  szOID_AUTO_ENROLL_CTL_USAGE = '1.3.6.1.4.1.311.20.1';

  // Extension contain certificate type
  szOID_ENROLL_CERTTYPE_EXTENSION = '1.3.6.1.4.1.311.20.2';

  szOID_CERT_MANIFOLD = '1.3.6.1.4.1.311.20.3';

  //+-------------------------------------------------------------------------
  //  Object Identifiers for use with the MS Certificate Server
  //--------------------------------------------------------------------------
  szOID_CERTSRV_CA_VERSION = '1.3.6.1.4.1.311.21.1';

  // szOID_CERTSRV_PREVIOUS_CERT_HASH -- Contains the sha1 hash of the previous
  // version of the CA certificate.
  szOID_CERTSRV_PREVIOUS_CERT_HASH   = '1.3.6.1.4.1.311.21.2';

  // szOID_CRL_VIRTUAL_BASE -- Delta CRLs only.  Contains the base CRL Number
  // of the corresponding base CRL.
  szOID_CRL_VIRTUAL_BASE         = '1.3.6.1.4.1.311.21.3';

  // szOID_CRL_NEXT_PUBLISH -- Contains the time when the next CRL is expected
  // to be published.  This may be sooner than the CRL's NextUpdate field.
  szOID_CRL_NEXT_PUBLISH         = '1.3.6.1.4.1.311.21.4';

  // Enhanced Key Usage for CA encryption certificate
  szOID_KP_CA_EXCHANGE           = '1.3.6.1.4.1.311.21.5';

  // Enhanced Key Usage for key recovery agent certificate
  szOID_KP_KEY_RECOVERY_AGENT    = '1.3.6.1.4.1.311.21.6';

  // Certificate template extension (v2)
  szOID_CERTIFICATE_TEMPLATE     = '1.3.6.1.4.1.311.21.7';

  // The root oid for all enterprise specific oids
  szOID_ENTERPRISE_OID_ROOT      = '1.3.6.1.4.1.311.21.8';

  // Dummy signing Subject RDN
  szOID_RDN_DUMMY_SIGNER         = '1.3.6.1.4.1.311.21.9';

  // Application Policies extension -- same encoding as szOID_CERT_POLICIES
  szOID_APPLICATION_CERT_POLICIES    = '1.3.6.1.4.1.311.21.10';

  // Application Policy Mappings -- same encoding as szOID_POLICY_MAPPINGS
  szOID_APPLICATION_POLICY_MAPPINGS  = '1.3.6.1.4.1.311.21.11';

  // Application Policy Constraints -- same encoding as szOID_POLICY_CONSTRAINTS
  szOID_APPLICATION_POLICY_CONSTRAINTS = '1.3.6.1.4.1.311.21.12';

  szOID_ARCHIVED_KEY_ATTR              = '1.3.6.1.4.1.311.21.13';
  szOID_CRL_SELF_CDP                   = '1.3.6.1.4.1.311.21.14';


  // Requires all certificates below the root to have a non-empty intersecting
  // issuance certificate policy usage.
  szOID_REQUIRE_CERT_CHAIN_POLICY      = '1.3.6.1.4.1.311.21.15';
  szOID_ARCHIVED_KEY_CERT_HASH         = '1.3.6.1.4.1.311.21.16';
  szOID_ISSUED_CERT_HASH               = '1.3.6.1.4.1.311.21.17';

  // Enhanced key usage for DS email replication
  szOID_DS_EMAIL_REPLICATION           = '1.3.6.1.4.1.311.21.19';

  szOID_REQUEST_CLIENT_INFO            = '1.3.6.1.4.1.311.21.20';
  szOID_ENCRYPTED_KEY_HASH             = '1.3.6.1.4.1.311.21.21';

  //+-------------------------------------------------------------------------
  //  Object Identifiers for use with the MS Directory Service
  //--------------------------------------------------------------------------
  szOID_NTDS_REPLICATION = '1.3.6.1.4.1.311.25.1';

  //+-------------------------------------------------------------------------
  //  Extension Object Identifiers (currently not implemented)
  //--------------------------------------------------------------------------
  szOID_SUBJECT_DIR_ATTRS = '2.5.29.9';

  //+-------------------------------------------------------------------------
  //  Enhanced Key Usage (Purpose) Object Identifiers
  //--------------------------------------------------------------------------
  szOID_PKIX_KP = '1.3.6.1.5.5.7.3';

  // Consistent key usage bits: DIGITAL_SIGNATURE, KEY_ENCIPHERMENT
  // or KEY_AGREEMENT
  szOID_PKIX_KP_SERVER_AUTH = '1.3.6.1.5.5.7.3.1';

  // Consistent key usage bits: DIGITAL_SIGNATURE
  szOID_PKIX_KP_CLIENT_AUTH = '1.3.6.1.5.5.7.3.2';

  // Consistent key usage bits: DIGITAL_SIGNATURE
  szOID_PKIX_KP_CODE_SIGNING = '1.3.6.1.5.5.7.3.3';

  // Consistent key usage bits: DIGITAL_SIGNATURE, NON_REPUDIATION and/or
  // (KEY_ENCIPHERMENT or KEY_AGREEMENT)
  szOID_PKIX_KP_EMAIL_PROTECTION = '1.3.6.1.5.5.7.3.4';

  // Consistent key usage bits: DIGITAL_SIGNATURE and/or
  // (KEY_ENCIPHERMENT or KEY_AGREEMENT)
  szOID_PKIX_KP_IPSEC_END_SYSTEM = '1.3.6.1.5.5.7.3.5';

  // Consistent key usage bits: DIGITAL_SIGNATURE and/or
  // (KEY_ENCIPHERMENT or KEY_AGREEMENT)
  szOID_PKIX_KP_IPSEC_TUNNEL = '1.3.6.1.5.5.7.3.6';

  // Consistent key usage bits: DIGITAL_SIGNATURE and/or
  // (KEY_ENCIPHERMENT or KEY_AGREEMENT)
  szOID_PKIX_KP_IPSEC_USER = '1.3.6.1.5.5.7.3.7';

  // Consistent key usage bits: DIGITAL_SIGNATURE or NON_REPUDIATION
  szOID_PKIX_KP_TIMESTAMP_SIGNING = '1.3.6.1.5.5.7.3.8';

  // IKE (Internet Key Exchange) Intermediate KP for an IPsec end entity.
  // Defined in draft-ietf-ipsec-pki-req-04.txt, December 14, 1999.
  szOID_IPSEC_KP_IKE_INTERMEDIATE = '1.3.6.1.5.5.8.2.2';
  //+-------------------------------------------------------------------------
  //  Microsoft Enhanced Key Usage (Purpose) Object Identifiers
  //+-------------------------------------------------------------------------

  //  Signer of CTLs
  szOID_KP_CTL_USAGE_SIGNING = '1.3.6.1.4.1.311.10.3.1';

  //  Signer of TimeStamps
  szOID_KP_TIME_STAMP_SIGNING = '1.3.6.1.4.1.311.10.3.2';

  szOID_SERVER_GATED_CRYPTO = '1.3.6.1.4.1.311.10.3.3';

  szOID_SGC_NETSCAPE = '2.16.840.1.113730.4.1';

  szOID_KP_EFS = '1.3.6.1.4.1.311.10.3.4';
  szOID_EFS_RECOVERY = '1.3.6.1.4.1.311.10.3.4.1';

  // Can use Windows Hardware Compatible (WHQL)
  szOID_WHQL_CRYPTO = '1.3.6.1.4.1.311.10.3.5';

  // Signed by the NT5 build lab
  szOID_NT5_CRYPTO = '1.3.6.1.4.1.311.10.3.6';

  // Signed by and OEM of WHQL
  szOID_OEM_WHQL_CRYPTO = '1.3.6.1.4.1.311.10.3.7';

  // Signed by the Embedded NT
  szOID_EMBEDDED_NT_CRYPTO = '1.3.6.1.4.1.311.10.3.8';

  // Signer of a CTL containing trusted roots
  szOID_ROOT_LIST_SIGNER     = '1.3.6.1.4.1.311.10.3.9';

  // Can sign cross-cert and subordinate CA requests with qualified
  // subordination (name constraints, policy mapping, etc.)
  szOID_KP_QUALIFIED_SUBORDINATION   = '1.3.6.1.4.1.311.10.3.10';

  // Can be used to encrypt/recover escrowed keys
  szOID_KP_KEY_RECOVERY              = '1.3.6.1.4.1.311.10.3.11';

  // Signer of documents
  szOID_KP_DOCUMENT_SIGNING          = '1.3.6.1.4.1.311.10.3.12';

  // The default WinVerifyTrust Authenticode policy is to treat all time stamped
  // signatures as being valid forever. This OID limits the valid lifetime of the
  // signature to the lifetime of the certificate. This allows timestamped
  // signatures to expire. Normally this OID will be used in conjunction with
  // szOID_PKIX_KP_CODE_SIGNING to indicate new time stamp semantics should be
  // used. Support for this OID was added in WXP.
  szOID_KP_LIFETIME_SIGNING          = '1.3.6.1.4.1.311.10.3.13';

  szOID_DRM = '1.3.6.1.4.1.311.10.5.1';

  // Microsoft DRM EKU
  szOID_DRM_INDIVIDUALIZATION = '1.3.6.1.4.1.311.10.5.2';

  szOID_LICENSES = '1.3.6.1.4.1.311.10.6.1';

  szOID_LICENSE_SERVER = '1.3.6.1.4.1.311.10.6.2';

  szOID_KP_SMARTCARD_LOGON = '1.3.6.1.4.1.311.20.2.2';

  //+-------------------------------------------------------------------------
  //  Microsoft Attribute Object Identifiers
  //+-------------------------------------------------------------------------
  szOID_YESNO_TRUST_ATTR = '1.3.6.1.4.1.311.10.4.1';

  //+-------------------------------------------------------------------------
  //  Qualifiers that may be part of the szOID_CERT_POLICIES and
  //  szOID_CERT_POLICIES95 extensions
  //+-------------------------------------------------------------------------
  szOID_PKIX_POLICY_QUALIFIER_CPS = '1.3.6.1.5.5.7.2.1';
  szOID_PKIX_POLICY_QUALIFIER_USERNOTICE = '1.3.6.1.5.5.7.2.2';

  // OID for old qualifer
  szOID_CERT_POLICIES_95_QUALIFIER1 = '2.16.840.1.113733.1.7.1.1';

  //+-------------------------------------------------------------------------
  //  X509_CERT
  //
  //  The "to be signed" encoded content plus its signature. The ToBeSigned
  //  content is the CryptEncodeObject() output for one of the following:
  //  X509_CERT_TO_BE_SIGNED, X509_CERT_CRL_TO_BE_SIGNED or
  //  X509_CERT_REQUEST_TO_BE_SIGNED.
  //
  //  pvStructInfo points to CERT_SIGNED_CONTENT_INFO.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_CERT_TO_BE_SIGNED
  //
  //  pvStructInfo points to CERT_INFO.
  //
  //  For CryptDecodeObject(), the pbEncoded is the "to be signed" plus its
  //  signature (output of a X509_CERT CryptEncodeObject()).
  //
  //  For CryptEncodeObject(), the pbEncoded is just the "to be signed".
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_CERT_CRL_TO_BE_SIGNED
  //
  //  pvStructInfo points to CRL_INFO.
  //
  //  For CryptDecodeObject(), the pbEncoded is the "to be signed" plus its
  //  signature (output of a X509_CERT CryptEncodeObject()).
  //
  //  For CryptEncodeObject(), the pbEncoded is just the "to be signed".
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_CERT_REQUEST_TO_BE_SIGNED
  //
  //  pvStructInfo points to CERT_REQUEST_INFO.
  //
  //  For CryptDecodeObject(), the pbEncoded is the "to be signed" plus its
  //  signature (output of a X509_CERT CryptEncodeObject()).
  //
  //  For CryptEncodeObject(), the pbEncoded is just the "to be signed".
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_EXTENSIONS
  //  szOID_CERT_EXTENSIONS
  //
  //  pvStructInfo points to following CERT_EXTENSIONS.
  //--------------------------------------------------------------------------
type
  CERT_EXTENSIONS = record
    cExtension:  DWORD;
    rgExtension: PCERT_EXTENSION;
  end;
  PCERT_EXTENSIONS = ^CERT_EXTENSIONS;

  //+-------------------------------------------------------------------------
  //  X509_NAME_VALUE
  //  X509_ANY_STRING
  //
  //  pvStructInfo points to CERT_NAME_VALUE.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_UNICODE_NAME_VALUE
  //  X509_UNICODE_ANY_STRING
  //
  //  pvStructInfo points to CERT_NAME_VALUE.
  //
  //  The name values are unicode strings.
  //
  //  For CryptEncodeObject:
  //    Value.pbData points to the unicode string.
  //    If Value.cbData = 0, then, the unicode string is NULL terminated.
  //    Otherwise, Value.cbData is the unicode string byte count. The byte count
  //    is twice the character count.
  //
  //    If the unicode string contains an invalid character for the specified
  //    dwValueType, then, *pcbEncoded is updated with the unicode character
  //    index of the first invalid character. LastError is set to:
  //    CRYPT_E_INVALID_NUMERIC_STRING, CRYPT_E_INVALID_PRINTABLE_STRING or
  //    CRYPT_E_INVALID_IA5_STRING.
  //
  //    To disable the above check, either set CERT_RDN_DISABLE_CHECK_TYPE_FLAG
  //    in dwValueType or set CRYPT_UNICODE_NAME_ENCODE_DISABLE_CHECK_TYPE_FLAG
  //    in dwFlags passed to CryptEncodeObjectEx.
  //
  //    The unicode string is converted before being encoded according to
  //    the specified dwValueType. If dwValueType is set to 0, LastError
  //    is set to E_INVALIDARG.
  //
  //    If the dwValueType isn't one of the character strings (its a
  //    CERT_RDN_ENCODED_BLOB or CERT_RDN_OCTET_STRING), then, CryptEncodeObject
  //    will return FALSE with LastError set to CRYPT_E_NOT_CHAR_STRING.
  //
  //  For CryptDecodeObject:
  //    Value.pbData points to a NULL terminated unicode string. Value.cbData
  //    contains the byte count of the unicode string excluding the NULL
  //    terminator. dwValueType contains the type used in the encoded object.
  //    Its not forced to CERT_RDN_UNICODE_STRING. The encoded value is
  //    converted to the unicode string according to the dwValueType.
  //
  //    If the encoded object isn't one of the character string types, then,
  //    CryptDecodeObject will return FALSE with LastError set to
  //    CRYPT_E_NOT_CHAR_STRING. For a non character string, decode using
  //    X509_NAME_VALUE or X509_ANY_STRING.
  //
  //    By default, CERT_RDN_T61_STRING values are initially decoded
  //    as UTF8. If the UTF8 decoding fails, then, decoded as 8 bit characters.
  //    Set CRYPT_UNICODE_NAME_DECODE_DISABLE_IE4_UTF8_FLAG in dwFlags
  //    passed to either CryptDecodeObject or CryptDecodeObjectEx to
  //    skip the initial attempt to decode as UTF8.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_NAME
  //
  //  pvStructInfo points to CERT_NAME_INFO.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_UNICODE_NAME
  //
  //  pvStructInfo points to CERT_NAME_INFO.
  //
  //  The RDN attribute values are unicode strings except for the dwValueTypes of
  //  CERT_RDN_ENCODED_BLOB or CERT_RDN_OCTET_STRING. These dwValueTypes are
  //  the same as for a X509_NAME. Their values aren't converted to/from unicode.
  //
  //  For CryptEncodeObject:
  //    Value.pbData points to the unicode string.
  //    If Value.cbData = 0, then, the unicode string is NULL terminated.
  //    Otherwise, Value.cbData is the unicode string byte count. The byte count
  //    is twice the character count.
  //
  //    If dwValueType = 0 (CERT_RDN_ANY_TYPE), the pszObjId is used to find
  //    an acceptable dwValueType. If the unicode string contains an
  //    invalid character for the found or specified dwValueType, then,
  //    *pcbEncoded is updated with the error location of the invalid character.
  //    See below for details. LastError is set to:
  //    CRYPT_E_INVALID_NUMERIC_STRING, CRYPT_E_INVALID_PRINTABLE_STRING or
  //    CRYPT_E_INVALID_IA5_STRING.
  //
  //    To disable the above check, either set CERT_RDN_DISABLE_CHECK_TYPE_FLAG
  //    in dwValueType or set CRYPT_UNICODE_NAME_ENCODE_DISABLE_CHECK_TYPE_FLAG
  //    in dwFlags passed to CryptEncodeObjectEx.
  //
  //    Set CERT_RDN_UNICODE_STRING in dwValueType or set
  //    CRYPT_UNICODE_NAME_ENCODE_ENABLE_T61_UNICODE_FLAG in dwFlags passed
  //    to CryptEncodeObjectEx to select CERT_RDN_T61_STRING instead of
  //    CERT_RDN_UNICODE_STRING if all the unicode characters are <= 0xFF.
  //
  //    Set CERT_RDN_ENABLE_UTF8_UNICODE_STRING in dwValueType or set
  //    CRYPT_UNICODE_NAME_ENCODE_ENABLE_UTF8_UNICODE_FLAG in dwFlags passed
  //    to CryptEncodeObjectEx to select CERT_RDN_UTF8_STRING instead of
  //    CERT_RDN_UNICODE_STRING.
  //
  //    The unicode string is converted before being encoded according to
  //    the specified or ObjId matching dwValueType.
  //
  //  For CryptDecodeObject:
  //    Value.pbData points to a NULL terminated unicode string. Value.cbData
  //    contains the byte count of the unicode string excluding the NULL
  //    terminator. dwValueType contains the type used in the encoded object.
  //    Its not forced to CERT_RDN_UNICODE_STRING. The encoded value is
  //    converted to the unicode string according to the dwValueType.
  //
  //    If the dwValueType of the encoded value isn't a character string
  //    type, then, it isn't converted to UNICODE. Use the
  //    IS_CERT_RDN_CHAR_STRING() macro on the dwValueType to check
  //    that Value.pbData points to a converted unicode string.
  //
  //    By default, CERT_RDN_T61_STRING values are initially decoded
  //    as UTF8. If the UTF8 decoding fails, then, decoded as 8 bit characters.
  //    Set CRYPT_UNICODE_NAME_DECODE_DISABLE_IE4_UTF8_FLAG in dwFlags
  //    passed to either CryptDecodeObject or CryptDecodeObjectEx to
  //    skip the initial attempt to decode as UTF8.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  Unicode Name Value Error Location Definitions
  //
  //  Error location is returned in *pcbEncoded by
  //  CryptEncodeObject(X509_UNICODE_NAME)
  //
  //  Error location consists of:
  //    RDN_INDEX     - 10 bits << 22
  //    ATTR_INDEX    - 6 bits << 16
  //    VALUE_INDEX   - 16 bits (unicode character index)
  //--------------------------------------------------------------------------
const
  CERT_UNICODE_RDN_ERR_INDEX_MASK    = $3FF;
  CERT_UNICODE_RDN_ERR_INDEX_SHIFT   = 22;
  CERT_UNICODE_ATTR_ERR_INDEX_MASK   = $003F;
  CERT_UNICODE_ATTR_ERR_INDEX_SHIFT  = 16;
  CERT_UNICODE_VALUE_ERR_INDEX_MASK  = $0000FFFF;
  CERT_UNICODE_VALUE_ERR_INDEX_SHIFT = 0;

function GET_CERT_UNICODE_RDN_ERR_INDEX(X: DWORD): DWORD;
function GET_CERT_UNICODE_ATTR_ERR_INDEX(X: DWORD): DWORD;
function GET_CERT_UNICODE_VALUE_ERR_INDEX(X: DWORD): DWORD;

//+-------------------------------------------------------------------------
//  X509_PUBLIC_KEY_INFO
//
//  pvStructInfo points to CERT_PUBLIC_KEY_INFO.
//--------------------------------------------------------------------------

//+-------------------------------------------------------------------------
//  X509_AUTHORITY_KEY_ID
//  szOID_AUTHORITY_KEY_IDENTIFIER
//
//  pvStructInfo points to following CERT_AUTHORITY_KEY_ID_INFO.
//--------------------------------------------------------------------------
type
  CERT_AUTHORITY_KEY_ID_INFO = record
    KeyId:            CRYPT_DATA_BLOB;
    CertIssuer:       CERT_NAME_BLOB;
    CertSerialNumber: CRYPT_INTEGER_BLOB;
  end;
  PCERT_AUTHORITY_KEY_ID_INFO = ^CERT_AUTHORITY_KEY_ID_INFO;

  //+-------------------------------------------------------------------------
  //  X509_KEY_ATTRIBUTES
  //  szOID_KEY_ATTRIBUTES
  //
  //  pvStructInfo points to following CERT_KEY_ATTRIBUTES_INFO.
  //--------------------------------------------------------------------------
  CERT_PRIVATE_KEY_VALIDITY = record
    NotBefore: FILETIME;
    NotAfter:  FILETIME;
  end;
  PCERT_PRIVATE_KEY_VALIDITY = ^CERT_PRIVATE_KEY_VALIDITY;

  CERT_KEY_ATTRIBUTES_INFO = record
    KeyId:                  CRYPT_DATA_BLOB;
    IntendedKeyUsage:       CRYPT_BIT_BLOB;
    pPrivateKeyUsagePeriod: PCERT_PRIVATE_KEY_VALIDITY; // OPTIONAL
  end;
  PCERT_KEY_ATTRIBUTES_INFO = ^CERT_KEY_ATTRIBUTES_INFO;

  // Byte[0]
const
  CERT_DIGITAL_SIGNATURE_KEY_USAGE = $80;
  CERT_NON_REPUDIATION_KEY_USAGE   = $40;
  CERT_KEY_ENCIPHERMENT_KEY_USAGE  = $20;
  CERT_DATA_ENCIPHERMENT_KEY_USAGE = $10;
  CERT_KEY_AGREEMENT_KEY_USAGE     = $08;
  CERT_KEY_CERT_SIGN_KEY_USAGE     = $04;
  CERT_OFFLINE_CRL_SIGN_KEY_USAGE  = $02;
  CERT_CRL_SIGN_KEY_USAGE          = $02;
  CERT_ENCIPHER_ONLY_KEY_USAGE     = $01;
  // Byte[1]
  CERT_DECIPHER_ONLY_KEY_USAGE     = $80;

  //+-------------------------------------------------------------------------
  //  X509_KEY_USAGE_RESTRICTION
  //  szOID_KEY_USAGE_RESTRICTION
  //
  //  pvStructInfo points to following CERT_KEY_USAGE_RESTRICTION_INFO.
  //--------------------------------------------------------------------------
type
  CERT_POLICY_ID = record
    cCertPolicyElementId:     DWORD;
    rgpszCertPolicyElementId: TARR_LPSTR; // pszObjId
  end;
  PCERT_POLICY_ID = ^CERT_POLICY_ID;

  CERT_KEY_USAGE_RESTRICTION_INFO = record
    cCertPolicyId:      DWORD;
    rgCertPolicyId:     PCERT_POLICY_ID;
    RestrictedKeyUsage: CRYPT_BIT_BLOB;
  end;
  PCERT_KEY_USAGE_RESTRICTION_INFO = ^CERT_KEY_USAGE_RESTRICTION_INFO;

  // See CERT_KEY_ATTRIBUTES_INFO for definition of the RestrictedKeyUsage bits

  //+-------------------------------------------------------------------------
  //  X509_ALTERNATE_NAME
  //  szOID_SUBJECT_ALT_NAME
  //  szOID_ISSUER_ALT_NAME
  //  szOID_SUBJECT_ALT_NAME2
  //  szOID_ISSUER_ALT_NAME2
  //
  //  pvStructInfo points to following CERT_ALT_NAME_INFO.
  //--------------------------------------------------------------------------
  CERT_OTHER_NAME = record
    pszObjId: LPSTR;
    Value:    CRYPT_OBJID_BLOB;
  end;
  PCERT_OTHER_NAME = ^CERT_OTHER_NAME;

  CERT_ALT_NAME_ENTRY = record
    case dwAltNameChoice: DWORD of
      1: (pOtherName:      PCERT_OTHER_NAME); // 1
      2: (pwszRfc822Name:  LPWSTR);           // 2  (encoded IA5)
      3: (pwszDNSName:     LPWSTR);           // 3  (encoded IA5)
      // Not implemented x400Address;         // 4
      5: (DirectoryName:   CERT_NAME_BLOB);   // 5
      // Not implemented pEdiPartyName;       // 6
      7: (pwszURL:         LPWSTR);           // 7  (encoded IA5)
      8: (IPAddress:       CRYPT_DATA_BLOB);  // 8  (Octet String)
      9: (pszRegisteredID: LPSTR);            // 9  (Object Identifer)
  end;
  PCERT_ALT_NAME_ENTRY = ^CERT_ALT_NAME_ENTRY;

const
  CERT_ALT_NAME_OTHER_NAME     = 1;
  CERT_ALT_NAME_RFC822_NAME    = 2;
  CERT_ALT_NAME_DNS_NAME       = 3;
  CERT_ALT_NAME_X400_ADDRESS   = 4;
  CERT_ALT_NAME_DIRECTORY_NAME = 5;
  CERT_ALT_NAME_EDI_PARTY_NAME = 6;
  CERT_ALT_NAME_URL            = 7;
  CERT_ALT_NAME_IP_ADDRESS     = 8;
  CERT_ALT_NAME_REGISTERED_ID  = 9;

type
  CERT_ALT_NAME_INFO = record
    cAltEntry:  DWORD;
    rgAltEntry: PCERT_ALT_NAME_ENTRY;
  end;
  PCERT_ALT_NAME_INFO = ^CERT_ALT_NAME_INFO;

  //+-------------------------------------------------------------------------
  //  Alternate name IA5 Error Location Definitions for
  //  CRYPT_E_INVALID_IA5_STRING.
  //
  //  Error location is returned in *pcbEncoded by
  //  CryptEncodeObject(X509_ALTERNATE_NAME)
  //
  //  Error location consists of:
  //    ENTRY_INDEX   - 8 bits << 16
  //    VALUE_INDEX   - 16 bits (unicode character index)
  //--------------------------------------------------------------------------
const
  CERT_ALT_NAME_ENTRY_ERR_INDEX_MASK  = $FF;
  CERT_ALT_NAME_ENTRY_ERR_INDEX_SHIFT = 16;
  CERT_ALT_NAME_VALUE_ERR_INDEX_MASK  = $0000FFFF;
  CERT_ALT_NAME_VALUE_ERR_INDEX_SHIFT = 0;

function GET_CERT_ALT_NAME_ENTRY_ERR_INDEX(X: DWORD): DWORD;
function GET_CERT_ALT_NAME_VALUE_ERR_INDEX(X: DWORD): DWORD;

//+-------------------------------------------------------------------------
//  X509_BASIC_CONSTRAINTS
//  szOID_BASIC_CONSTRAINTS
//
//  pvStructInfo points to following CERT_BASIC_CONSTRAINTS_INFO.
//--------------------------------------------------------------------------
type
  CERT_BASIC_CONSTRAINTS_INFO = record
    SubjectType:          CRYPT_BIT_BLOB;
    fPathLenConstraint:   BOOL;
    dwPathLenConstraint:  DWORD;
    cSubtreesConstraint:  DWORD;
    rgSubtreesConstraint: PCERT_NAME_BLOB;
  end;
  PCERT_BASIC_CONSTRAINTS_INFO = ^CERT_BASIC_CONSTRAINTS_INFO;

const
  CERT_CA_SUBJECT_FLAG         = $80;
  CERT_END_ENTITY_SUBJECT_FLAG = $40;

  //+-------------------------------------------------------------------------
  //  X509_BASIC_CONSTRAINTS2
  //  szOID_BASIC_CONSTRAINTS2
  //
  //  pvStructInfo points to following CERT_BASIC_CONSTRAINTS2_INFO.
  //--------------------------------------------------------------------------
type
  CERT_BASIC_CONSTRAINTS2_INFO = record
    fCA:                 BOOL;
    fPathLenConstraint:  BOOL;
    dwPathLenConstraint: DWORD;
  end;
  PCERT_BASIC_CONSTRAINTS2_INFO = ^CERT_BASIC_CONSTRAINTS2_INFO;

  //+-------------------------------------------------------------------------
  //  X509_KEY_USAGE
  //  szOID_KEY_USAGE
  //
  //  pvStructInfo points to a CRYPT_BIT_BLOB. Has same bit definitions as
  //  CERT_KEY_ATTRIBUTES_INFO's IntendedKeyUsage.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_CERT_POLICIES
  //  szOID_CERT_POLICIES
  //  szOID_CERT_POLICIES_95   NOTE--Only allowed for decoding!!!
  //
  //  pvStructInfo points to following CERT_POLICIES_INFO.
  //
  //  NOTE: when decoding using szOID_CERT_POLICIES_95 the pszPolicyIdentifier
  //        may contain an empty string
  //--------------------------------------------------------------------------
  CERT_POLICY_QUALIFIER_INFO = record
    pszPolicyQualifierId: LPSTR; // pszObjId
    Qualifier:            CRYPT_OBJID_BLOB; // optional
  end;
  PCERT_POLICY_QUALIFIER_INFO = CERT_POLICY_QUALIFIER_INFO;

  CERT_POLICY_INFO = record
    pszPolicyIdentifier: LPSTR; // pszObjId
    cPolicyQualifier:    DWORD; // optional
    rgPolicyQualifier:   PCERT_POLICY_QUALIFIER_INFO;
  end;
  PCERT_POLICY_INFO = ^CERT_POLICY_INFO;

  CERT_POLICIES_INFO = record
    cPolicyInfo:  DWORD;
    rgPolicyInfo: PCERT_POLICY_INFO;
  end;
  PCERT_POLICIES_INFO = ^CERT_POLICIES_INFO;

  //+-------------------------------------------------------------------------
  //  X509_PKIX_POLICY_QUALIFIER_USERNOTICE
  //  szOID_PKIX_POLICY_QUALIFIER_USERNOTICE
  //
  //  pvStructInfo points to following CERT_POLICY_QUALIFIER_USER_NOTICE.
  //
  //--------------------------------------------------------------------------
  TARR_INT = ^integer;
  CERT_POLICY_QUALIFIER_NOTICE_REFERENCE = record
    pszOrganization: LPSTR;
    cNoticeNumbers:  DWORD;
    rgNoticeNumbers: TARR_INT;
  end;
  PCERT_POLICY_QUALIFIER_NOTICE_REFERENCE =
    ^CERT_POLICY_QUALIFIER_NOTICE_REFERENCE;

  CERT_POLICY_QUALIFIER_USER_NOTICE = record
    pNoticeReference: PCERT_POLICY_QUALIFIER_NOTICE_REFERENCE; // optional
    pszDisplayText:   LPWSTR; // optional
  end;
  PCERT_POLICY_QUALIFIER_USER_NOTICE = ^CERT_POLICY_QUALIFIER_USER_NOTICE;

  //+-------------------------------------------------------------------------
  //  szOID_CERT_POLICIES_95_QUALIFIER1 - Decode Only!!!!
  //
  //  pvStructInfo points to following CERT_POLICY95_QUALIFIER1.
  //
  //--------------------------------------------------------------------------
  CPS_URLS = record
    pszURL:     LPWSTR;
    pAlgorithm: PCRYPT_ALGORITHM_IDENTIFIER; // optional
    pDigest:    PCRYPT_DATA_BLOB; // optional
  end;
  PCPS_URLS = ^CPS_URLS;

  CERT_POLICY95_QUALIFIER1 = record
    pszPracticesReference:  LPWSTR; // optional
    pszNoticeIdentifier:    LPSTR; // optional
    pszNSINoticeIdentifier: LPSTR; // optional
    cCPSURLs:               DWORD;
    rgCPSURLs:              PCPS_URLS; // optional
  end;
  PCERT_POLICY95_QUALIFIER1 = ^CERT_POLICY95_QUALIFIER1;

  //+-------------------------------------------------------------------------
  //  X509_POLICY_MAPPINGS
  //  szOID_POLICY_MAPPINGS
  //  szOID_LEGACY_POLICY_MAPPINGS
  //
  //  pvStructInfo points to following CERT_POLICY_MAPPINGS_INFO.
  //--------------------------------------------------------------------------
  CERT_POLICY_MAPPING = record
    pszIssuerDomainPolicy:  LPSTR;      // pszObjId
    pszSubjectDomainPolicy: LPSTR;     // pszObjId
  end;
  PCERT_POLICY_MAPPING = ^CERT_POLICY_MAPPING;

  CERT_POLICY_MAPPINGS_INFO = record
    cPolicyMapping:  DWORD;
    rgPolicyMapping: PCERT_POLICY_MAPPING;
  end;
  PCERT_POLICY_MAPPINGS_INFO = ^CERT_POLICY_MAPPINGS_INFO;

  //+-------------------------------------------------------------------------
  //  X509_POLICY_CONSTRAINTS
  //  szOID_POLICY_CONSTRAINTS
  //
  //  pvStructInfo points to following CERT_POLICY_CONSTRAINTS_INFO.
  //--------------------------------------------------------------------------
  CERT_POLICY_CONSTRAINTS_INFO = record
    fRequireExplicitPolicy:           BOOL;
    dwRequireExplicitPolicySkipCerts: DWORD;
    fInhibitPolicyMapping:            BOOL;
    dwInhibitPolicyMappingSkipCerts:  DWORD;
  end;
  PCERT_POLICY_CONSTRAINTS_INFO = ^CERT_POLICY_CONSTRAINTS_INFO;

  //+-------------------------------------------------------------------------
  //  RSA_CSP_PUBLICKEYBLOB
  //
  //  pvStructInfo points to a PUBLICKEYSTRUC immediately followed by a
  //  RSAPUBKEY and the modulus bytes.
  //
  //  CryptExportKey outputs the above StructInfo for a dwBlobType of
  //  PUBLICKEYBLOB. CryptImportKey expects the above StructInfo when
  //  importing a public key.
  //
  //  For dwCertEncodingType = X509_ASN_ENCODING, the RSA_CSP_PUBLICKEYBLOB is
  //  encoded as a PKCS #1 RSAPublicKey consisting of a SEQUENCE of a
  //  modulus INTEGER and a publicExponent INTEGER. The modulus is encoded
  //  as being a unsigned integer. When decoded, if the modulus was encoded
  //  as unsigned integer with a leading 0 byte, the 0 byte is removed before
  //  converting to the CSP modulus bytes.
  //
  //  For decode, the aiKeyAlg field of PUBLICKEYSTRUC is always set to
  //  CALG_RSA_KEYX.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_KEYGEN_REQUEST_TO_BE_SIGNED
  //
  //  pvStructInfo points to CERT_KEYGEN_REQUEST_INFO.
  //
  //  For CryptDecodeObject(), the pbEncoded is the "to be signed" plus its
  //  signature (output of a X509_CERT CryptEncodeObject()).
  //
  //  For CryptEncodeObject(), the pbEncoded is just the "to be signed".
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  PKCS_ATTRIBUTE data structure
  //
  //  pvStructInfo points to a CRYPT_ATTRIBUTE.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  PKCS_ATTRIBUTES data structure
  //
  //  pvStructInfo points to a CRYPT_ATTRIBUTES.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  PKCS_CONTENT_INFO_SEQUENCE_OF_ANY data structure
  //
  //  pvStructInfo points to following CRYPT_CONTENT_INFO_SEQUENCE_OF_ANY.
  //
  //  For X509_ASN_ENCODING: encoded as a PKCS#7 ContentInfo structure wrapping
  //  a sequence of ANY. The value of the contentType field is pszObjId,
  //  while the content field is the following structure:
  //      SequenceOfAny ::= SEQUENCE OF ANY
  //
  //  The CRYPT_DER_BLOBs point to the already encoded ANY content.
  //--------------------------------------------------------------------------
type
  CRYPT_CONTENT_INFO_SEQUENCE_OF_ANY = record
    pszObjId: LPSTR;
    cValue:   DWORD;
    rgValue:  PCRYPT_DER_BLOB;
  end;
  PCRYPT_CONTENT_INFO_SEQUENCE_OF_ANY = ^CRYPT_CONTENT_INFO_SEQUENCE_OF_ANY;

  //+-------------------------------------------------------------------------
  //  PKCS_CONTENT_INFO data structure
  //
  //  pvStructInfo points to following CRYPT_CONTENT_INFO.
  //
  //  For X509_ASN_ENCODING: encoded as a PKCS#7 ContentInfo structure.
  //  The CRYPT_DER_BLOB points to the already encoded ANY content.
  //--------------------------------------------------------------------------
type
  CRYPT_CONTENT_INFO = record
    pszObjId: LPSTR;
    Content:  CRYPT_DER_BLOB;
  end;
  PCRYPT_CONTENT_INFO = ^CRYPT_CONTENT_INFO;

  //+-------------------------------------------------------------------------
  //  X509_OCTET_STRING data structure
  //
  //  pvStructInfo points to a CRYPT_DATA_BLOB.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_BITS data structure
  //
  //  pvStructInfo points to a CRYPT_BIT_BLOB.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_BITS_WITHOUT_TRAILING_ZEROES data structure
  //
  //  pvStructInfo points to a CRYPT_BIT_BLOB.
  //
  //  The same as X509_BITS, except before encoding, the bit length is
  //  decremented to exclude trailing zero bits.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_INTEGER data structure
  //
  //  pvStructInfo points to an int.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_MULTI_BYTE_INTEGER data structure
  //
  //  pvStructInfo points to a CRYPT_INTEGER_BLOB.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_ENUMERATED data structure
  //
  //  pvStructInfo points to an int containing the enumerated value
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_CHOICE_OF_TIME data structure
  //
  //  pvStructInfo points to a FILETIME.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_SEQUENCE_OF_ANY data structure
  //
  //  pvStructInfo points to following CRYPT_SEQUENCE_OF_ANY.
  //
  //  The CRYPT_DER_BLOBs point to the already encoded ANY content.
  //--------------------------------------------------------------------------
type
  CRYPT_SEQUENCE_OF_ANY = record
    cValue:  DWORD;
    rgValue: PCRYPT_DER_BLOB;
  end;
  PCRYPT_SEQUENCE_OF_ANY = ^CRYPT_SEQUENCE_OF_ANY;

  //+-------------------------------------------------------------------------
  //  X509_AUTHORITY_KEY_ID2
  //  szOID_AUTHORITY_KEY_IDENTIFIER2
  //
  //  pvStructInfo points to following CERT_AUTHORITY_KEY_ID2_INFO.
  //
  //  For CRYPT_E_INVALID_IA5_STRING, the error location is returned in
  //  *pcbEncoded by CryptEncodeObject(X509_AUTHORITY_KEY_ID2)
  //
  //  See X509_ALTERNATE_NAME for error location defines.
  //--------------------------------------------------------------------------
type
  CERT_AUTHORITY_KEY_ID2_INFO = record
    KeyId:                     CRYPT_DATA_BLOB;
    AuthorityCertIssuer:       CERT_ALT_NAME_INFO; // Optional, set cAltEntry
    // to 0 to omit.
    AuthorityCertSerialNumber: CRYPT_INTEGER_BLOB;
  end;
  PCERT_AUTHORITY_KEY_ID2_INFO = ^CERT_AUTHORITY_KEY_ID2_INFO;

  //+-------------------------------------------------------------------------
  //  szOID_SUBJECT_KEY_IDENTIFIER
  //
  //  pvStructInfo points to a CRYPT_DATA_BLOB.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_AUTHORITY_INFO_ACCESS
  //  szOID_AUTHORITY_INFO_ACCESS
  //
  //  pvStructInfo points to following CERT_AUTHORITY_INFO_ACCESS.
  //
  //  For CRYPT_E_INVALID_IA5_STRING, the error location is returned in
  //  *pcbEncoded by CryptEncodeObject(X509_AUTHORITY_INFO_ACCESS)
  //
  //  Error location consists of:
  //    ENTRY_INDEX   - 8 bits << 16
  //    VALUE_INDEX   - 16 bits (unicode character index)
  //
  //  See X509_ALTERNATE_NAME for ENTRY_INDEX and VALUE_INDEX error location
  //  defines.
  //--------------------------------------------------------------------------

type
  CERT_ACCESS_DESCRIPTION = record
    pszAccessMethod: LPSTR; // pszObjId
    AccessLocation:  CERT_ALT_NAME_ENTRY;
  end;
  PCERT_ACCESS_DESCRIPTION = ^CERT_ACCESS_DESCRIPTION;

type
  CERT_AUTHORITY_INFO_ACCESS = record
    cAccDescr:  DWORD;
    rgAccDescr: PCERT_ACCESS_DESCRIPTION;
  end;
  PCERT_AUTHORITY_INFO_ACCESS = ^CERT_AUTHORITY_INFO_ACCESS;

  //+-------------------------------------------------------------------------
  //  PKIX Access Description: Access Method Object Identifiers
  //--------------------------------------------------------------------------
const
  szOID_PKIX_ACC_DESCR  = '1.3.6.1.5.5.7.48';
  szOID_PKIX_OCSP       = '1.3.6.1.5.5.7.48.1';
  szOID_PKIX_CA_ISSUERS = '1.3.6.1.5.5.7.48.2';

  //+-------------------------------------------------------------------------
  //  X509_CRL_REASON_CODE
  //  szOID_CRL_REASON_CODE
  //
  //  pvStructInfo points to an int which can be set to one of the following
  //  enumerated values:
  //--------------------------------------------------------------------------
  CRL_REASON_UNSPECIFIED            = 0;
  CRL_REASON_KEY_COMPROMISE         = 1;
  CRL_REASON_CA_COMPROMISE          = 2;
  CRL_REASON_AFFILIATION_CHANGED    = 3;
  CRL_REASON_SUPERSEDED             = 4;
  CRL_REASON_CESSATION_OF_OPERATION = 5;
  CRL_REASON_CERTIFICATE_HOLD       = 6;
  CRL_REASON_REMOVE_FROM_CRL        = 8;

  //+-------------------------------------------------------------------------
  //  X509_CRL_DIST_POINTS
  //  szOID_CRL_DIST_POINTS
  //
  //  pvStructInfo points to following CRL_DIST_POINTS_INFO.
  //
  //  For CRYPT_E_INVALID_IA5_STRING, the error location is returned in
  //  *pcbEncoded by CryptEncodeObject(X509_CRL_DIST_POINTS)
  //
  //  Error location consists of:
  //    CRL_ISSUER_BIT    - 1 bit  << 31 (0 for FullName, 1 for CRLIssuer)
  //    POINT_INDEX       - 7 bits << 24
  //    ENTRY_INDEX       - 8 bits << 16
  //    VALUE_INDEX       - 16 bits (unicode character index)
  //
  //  See X509_ALTERNATE_NAME for ENTRY_INDEX and VALUE_INDEX error location
  //  defines.
  //--------------------------------------------------------------------------
type
  CRL_DIST_POINT_NAME = record
    case dwDistPointNameChoice: DWORD of
      1: (FullName: CERT_ALT_NAME_INFO); // 1
      // Not implemented      IssuerRDN;      // 2
  end;
  PCRL_DIST_POINT_NAME = ^CRL_DIST_POINT_NAME;

const
  CRL_DIST_POINT_NO_NAME         = 0;
  CRL_DIST_POINT_FULL_NAME       = 1;
  CRL_DIST_POINT_ISSUER_RDN_NAME = 2;

type
  CRL_DIST_POINT = record
    DistPointName: CRL_DIST_POINT_NAME; // OPTIONAL
    ReasonFlags:   CRYPT_BIT_BLOB;      // OPTIONAL
    CRLIssuer:     CERT_ALT_NAME_INFO;  // OPTIONAL
  end;
  PCRL_DIST_POINT = ^CRL_DIST_POINT;

const
  CRL_REASON_UNUSED_FLAG                 = $80;
  CRL_REASON_KEY_COMPROMISE_FLAG         = $40;
  CRL_REASON_CA_COMPROMISE_FLAG          = $20;
  CRL_REASON_AFFILIATION_CHANGED_FLAG    = $10;
  CRL_REASON_SUPERSEDED_FLAG             = $08;
  CRL_REASON_CESSATION_OF_OPERATION_FLAG = $04;
  CRL_REASON_CERTIFICATE_HOLD_FLAG       = $02;

type
  CRL_DIST_POINTS_INFO = record
    cDistPoint:  DWORD;
    rgDistPoint: PCRL_DIST_POINT;
  end;
  PCRL_DIST_POINTS_INFO = ^CRL_DIST_POINTS_INFO;

const
  CRL_DIST_POINT_ERR_INDEX_MASK     = $7F;
  CRL_DIST_POINT_ERR_INDEX_SHIFT    = 24;
  CRL_DIST_POINT_ERR_CRL_ISSUER_BIT = $80000000;

function GET_CRL_DIST_POINT_ERR_INDEX(X: DWORD): DWORD;
function IS_CRL_DIST_POINT_ERR_CRL_ISSUER(X: DWORD): boolean;

//+-------------------------------------------------------------------------
//  X509_CROSS_CERT_DIST_POINTS
//  szOID_CROSS_CERT_DIST_POINTS
//
//  pvStructInfo points to following CROSS_CERT_DIST_POINTS_INFO.
//
//  For CRYPT_E_INVALID_IA5_STRING, the error location is returned in
//  *pcbEncoded by CryptEncodeObject(X509_CRL_DIST_POINTS)
//
//  Error location consists of:
//    POINT_INDEX       - 8 bits << 24
//    ENTRY_INDEX       - 8 bits << 16
//    VALUE_INDEX       - 16 bits (unicode character index)
//
//  See X509_ALTERNATE_NAME for ENTRY_INDEX and VALUE_INDEX error location
//  defines.
//--------------------------------------------------------------------------
type
  CROSS_CERT_DIST_POINTS_INFO = record
    // Seconds between syncs. 0 implies use client default.
    dwSyncDeltaTime: DWORD;
    cDistPoint:      DWORD;
    rgDistPoint:     PCERT_ALT_NAME_INFO;
  end;
  PCROSS_CERT_DIST_POINTS_INFO = ^CROSS_CERT_DIST_POINTS_INFO;

const
  CROSS_CERT_DIST_POINT_ERR_INDEX_MASK  = $FF;
  CROSS_CERT_DIST_POINT_ERR_INDEX_SHIFT = 24;

  function GET_CROSS_CERT_DIST_POINT_ERR_INDEX(X: DWORD): DWORD;

//+-------------------------------------------------------------------------
//  X509_ENHANCED_KEY_USAGE
//  szOID_ENHANCED_KEY_USAGE
//
//  pvStructInfo points to a CERT_ENHKEY_USAGE, CTL_USAGE.
//--------------------------------------------------------------------------

//+-------------------------------------------------------------------------
//  X509_CERT_PAIR
//
//  pvStructInfo points to the following CERT_PAIR.
//--------------------------------------------------------------------------
type
  CERT_PAIR = record
    Forward: CERT_BLOB;        // OPTIONAL, if Forward.cbData == 0, omitted
    Reverse: CERT_BLOB;        // OPTIONAL, if Reverse.cbData == 0, omitted
  end;
  PCERT_PAIR = ^CERT_PAIR;

//+-------------------------------------------------------------------------
//  szOID_CRL_NUMBER
//
//  pvStructInfo points to an int.
//--------------------------------------------------------------------------

//+-------------------------------------------------------------------------
//  szOID_DELTA_CRL_INDICATOR
//
//  pvStructInfo points to an int.
//--------------------------------------------------------------------------

//+-------------------------------------------------------------------------
//  szOID_ISSUING_DIST_POINT
//  X509_ISSUING_DIST_POINT
//
//  pvStructInfo points to the following CRL_ISSUING_DIST_POINT.
//
//  For CRYPT_E_INVALID_IA5_STRING, the error location is returned in
//  *pcbEncoded by CryptEncodeObject(X509_ISSUING_DIST_POINT)
//
//  Error location consists of:
//    ENTRY_INDEX       - 8 bits << 16
//    VALUE_INDEX       - 16 bits (unicode character index)
//
//  See X509_ALTERNATE_NAME for ENTRY_INDEX and VALUE_INDEX error location
//  defines.
//--------------------------------------------------------------------------
  CRL_ISSUING_DIST_POINT  = record
    DistPointName:          CRL_DIST_POINT_NAME;              // OPTIONAL
    fOnlyContainsUserCerts: BOOL;
    fOnlyContainsCACerts:   BOOL;
    OnlySomeReasonFlags:    CRYPT_BIT_BLOB;        // OPTIONAL
    fIndirectCRL:           BOOL
  end;
  PCRL_ISSUING_DIST_POINT = ^CRL_ISSUING_DIST_POINT;

//+-------------------------------------------------------------------------
//  szOID_FRESHEST_CRL
//
//  pvStructInfo points to CRL_DIST_POINTS_INFO.
//--------------------------------------------------------------------------

//+-------------------------------------------------------------------------
//  szOID_NAME_CONSTRAINTS
//  X509_NAME_CONSTRAINTS
//
//  pvStructInfo points to the following CERT_NAME_CONSTRAINTS_INFO
//
//  For CRYPT_E_INVALID_IA5_STRING, the error location is returned in
//  *pcbEncoded by CryptEncodeObject(X509_NAME_CONSTRAINTS)
//
//  Error location consists of:
//    EXCLUDED_SUBTREE_BIT  - 1 bit  << 31 (0 for permitted, 1 for excluded)
//    ENTRY_INDEX           - 8 bits << 16
//    VALUE_INDEX           - 16 bits (unicode character index)
//
//  See X509_ALTERNATE_NAME for ENTRY_INDEX and VALUE_INDEX error location
//  defines.
//--------------------------------------------------------------------------
  CERT_GENERAL_SUBTREE = record
    Base:      CERT_ALT_NAME_ENTRY;
    dwMinimum: DWORD;
    fMaximum:  BOOL;
    dwMaximum: DWORD;
  end;
  PCERT_GENERAL_SUBTREE = ^CERT_GENERAL_SUBTREE;

  CERT_NAME_CONSTRAINTS_INFO  = record
    cPermittedSubtree:  DWORD;
    rgPermittedSubtree: PCERT_GENERAL_SUBTREE;
    cExcludedSubtree:   DWORD;
    rgExcludedSubtree:  PCERT_GENERAL_SUBTREE;
  end;
  PCERT_NAME_CONSTRAINTS_INFO = ^CERT_NAME_CONSTRAINTS_INFO;

const
  CERT_EXCLUDED_SUBTREE_BIT   =   $80000000;

  function IS_CERT_EXCLUDED_SUBTREE(X: DWORD): boolean;

//+-------------------------------------------------------------------------
//  szOID_NEXT_UPDATE_LOCATION
//
//  pvStructInfo points to a CERT_ALT_NAME_INFO.
//--------------------------------------------------------------------------

//+-------------------------------------------------------------------------
//  szOID_REMOVE_CERTIFICATE
//
//  pvStructInfo points to an int which can be set to one of the following
//   0 - Add certificate
//   1 - Remove certificate
//--------------------------------------------------------------------------

//+-------------------------------------------------------------------------
//  PKCS_CTL
//  szOID_CTL
//
//  pvStructInfo points to a CTL_INFO.
//--------------------------------------------------------------------------

//+-------------------------------------------------------------------------
//  PKCS_SORTED_CTL
//
//  pvStructInfo points to a CTL_INFO.
//
//  Same as for PKCS_CTL, except, the CTL entries are sorted. The following
//  extension containing the sort information is inserted as the first
//  extension in the encoded CTL.
//
//  Only supported for Encoding. CRYPT_ENCODE_ALLOC_FLAG flag must be
//  set.
//--------------------------------------------------------------------------

//+-------------------------------------------------------------------------
// Sorted CTL TrustedSubjects extension
//
//  Array of little endian DWORDs:
//   [0] - Flags
//   [1] - Count of HashBucket entry offsets
//   [2] - Maximum HashBucket entry collision count
//   [3 ..] (Count + 1) HashBucket entry offsets
//
//  When this extension is present in the CTL,
//  the ASN.1 encoded sequence of TrustedSubjects are HashBucket ordered.
//
//  The entry offsets point to the start of the first encoded TrustedSubject
//  sequence for the HashBucket. The encoded TrustedSubjects for a HashBucket
//  continue until the encoded offset of the next HashBucket. A HashBucket has
//  no entries if HashBucket[N] == HashBucket[N + 1].
//
//  The HashBucket offsets are from the start of the ASN.1 encoded CTL_INFO.
//--------------------------------------------------------------------------
const
  SORTED_CTL_EXT_FLAGS_OFFSET         = (0 * 4);
  SORTED_CTL_EXT_COUNT_OFFSET         = (1 * 4);
  SORTED_CTL_EXT_MAX_COLLISION_OFFSET = (2 * 4);
  SORTED_CTL_EXT_HASH_BUCKET_OFFSET   = (3 * 4);

  // If the SubjectIdentifiers are a MD5 or SHA1 hash, the following flag is
  // set. When set, the first 4 bytes of the SubjectIdentifier are used as
  // the dwhash. Otherwise, the SubjectIdentifier bytes are hashed into dwHash.
  // In either case the HashBucket index = dwHash % cHashBucket.
  SORTED_CTL_EXT_HASHED_SUBJECT_IDENTIFIER_FLAG = $1;

  //+-------------------------------------------------------------------------
  //  X509_MULTI_BYTE_UINT
  //
  //  pvStructInfo points to a CRYPT_UINT_BLOB. Before encoding, inserts a
  //  leading 0x00. After decoding, removes a leading 0x00.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_DSS_PUBLICKEY
  //
  //  pvStructInfo points to a CRYPT_UINT_BLOB.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_DSS_PARAMETERS
  //
  //  pvStructInfo points to following CERT_DSS_PARAMETERS data structure.
  //--------------------------------------------------------------------------
type
  CERT_DSS_PARAMETERS = record
    p: CRYPT_UINT_BLOB;
    q: CRYPT_UINT_BLOB;
    g: CRYPT_UINT_BLOB;
  end;
  PCERT_DSS_PARAMETERS = ^CERT_DSS_PARAMETERS;

  //+-------------------------------------------------------------------------
  //  X509_DSS_SIGNATURE
  //
  //  pvStructInfo is a BYTE rgbSignature[CERT_DSS_SIGNATURE_LEN]. The
  //  bytes are ordered as output by the DSS CSP's CryptSignHash().
  //--------------------------------------------------------------------------
const
  CERT_DSS_R_LEN         = 20;
  CERT_DSS_S_LEN         = 20;
  CERT_DSS_SIGNATURE_LEN = (CERT_DSS_R_LEN + CERT_DSS_S_LEN);

  // Sequence of 2 unsigned integers (the extra +1 is for a potential leading
  // 0x00 to make the integer unsigned)
  CERT_MAX_ASN_ENCODED_DSS_SIGNATURE_LEN = (2 + 2 * (2 + 20 + 1));

  //+-------------------------------------------------------------------------
  //  X509_DH_PUBLICKEY
  //
  //  pvStructInfo points to a CRYPT_UINT_BLOB.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  X509_DH_PARAMETERS
  //
  //  pvStructInfo points to following CERT_DH_PARAMETERS data structure.
  //--------------------------------------------------------------------------
type
  CERT_DH_PARAMETERS = record
    p: CRYPT_UINT_BLOB;
    g: CRYPT_UINT_BLOB;
  end;
  PCERT_DH_PARAMETERS = ^CERT_DH_PARAMETERS;

  //+-------------------------------------------------------------------------
  //  X942_DH_PARAMETERS
  //
  //  pvStructInfo points to following CERT_X942_DH_PARAMETERS data structure.
  //
  //  If q.cbData == 0, then, the following fields are zero'ed.
  //--------------------------------------------------------------------------
type
  CERT_X942_DH_VALIDATION_PARAMS = record
    seed:        CRYPT_BIT_BLOB;
    pgenCounter: DWORD;
  end;
  PCERT_X942_DH_VALIDATION_PARAMS = ^CERT_X942_DH_VALIDATION_PARAMS;

type
  CERT_X942_DH_PARAMETERS = record
    p: CRYPT_UINT_BLOB; // odd prime, p = jq + 1
    g: CRYPT_UINT_BLOB; // generator, g
    q: CRYPT_UINT_BLOB; // factor of p - 1, OPTIONAL
    j: CRYPT_UINT_BLOB; // subgroup factor, OPTIONAL
    pValidationParams: PCERT_X942_DH_VALIDATION_PARAMS; // OPTIONAL
  end;
  PCERT_X942_DH_PARAMETERS = ^CERT_X942_DH_PARAMETERS;

  //+-------------------------------------------------------------------------
  //  X942_OTHER_INFO
  //
  //  pvStructInfo points to following CRYPT_X942_OTHER_INFO data structure.
  //
  //  rgbCounter and rgbKeyLength are in Little Endian order.
  //--------------------------------------------------------------------------
const
  CRYPT_X942_COUNTER_BYTE_LENGTH    = 4;
  CRYPT_X942_KEY_LENGTH_BYTE_LENGTH = 4;
  CRYPT_X942_PUB_INFO_BYTE_LENGTH   = (512 / 8);
type
  CRYPT_X942_OTHER_INFO = record
    pszContentEncryptionObjId: LPSTR;
    rgbCounter:   array[1..CRYPT_X942_COUNTER_BYTE_LENGTH] of BYTE;
    rgbKeyLength: array[1..CRYPT_X942_KEY_LENGTH_BYTE_LENGTH] of BYTE;
    PubInfo:      CRYPT_DATA_BLOB; // OPTIONAL
  end;
  PCRYPT_X942_OTHER_INFO = ^CRYPT_X942_OTHER_INFO;

  //+-------------------------------------------------------------------------
  //  PKCS_RC2_CBC_PARAMETERS
  //  szOID_RSA_RC2CBC
  //
  //  pvStructInfo points to following CRYPT_RC2_CBC_PARAMETERS data structure.
  //--------------------------------------------------------------------------
type
  CRYPT_RC2_CBC_PARAMETERS = record
    dwVersion: DWORD;
    fIV:       BOOL; // set if has following IV
    rgbIV:     array[1..8] of BYTE;
  end;
  PCRYPT_RC2_CBC_PARAMETERS = ^CRYPT_RC2_CBC_PARAMETERS;

const
  CRYPT_RC2_40BIT_VERSION  = 160;
  CRYPT_RC2_56BIT_VERSION  = 52;
  CRYPT_RC2_64BIT_VERSION  = 120;
  CRYPT_RC2_128BIT_VERSION = 58;

  //+-------------------------------------------------------------------------
  //  PKCS_SMIME_CAPABILITIES
  //  szOID_RSA_SMIMECapabilities
  //
  //  pvStructInfo points to following CRYPT_SMIME_CAPABILITIES data structure.
  //
  //  Note, for CryptEncodeObject(X509_ASN_ENCODING), Parameters.cbData == 0
  //  causes the encoded parameters to be omitted and not encoded as a NULL
  //  (05 00) as is done when encoding a CRYPT_ALGORITHM_IDENTIFIER. This
  //  is per the SMIME specification for encoding capabilities.
  //--------------------------------------------------------------------------
type
  CRYPT_SMIME_CAPABILITY = record
    pszObjId:   LPSTR;
    Parameters: CRYPT_OBJID_BLOB;
  end;
  PCRYPT_SMIME_CAPABILITY = ^CRYPT_SMIME_CAPABILITY;

type
  CRYPT_SMIME_CAPABILITIES = record
    cCapability:  DWORD;
    rgCapability: PCRYPT_SMIME_CAPABILITY;
  end;
  PCRYPT_SMIME_CAPABILITIES = ^CRYPT_SMIME_CAPABILITIES;

  //+-------------------------------------------------------------------------
  //  PKCS7_SIGNER_INFO
  //
  //  pvStructInfo points to CMSG_SIGNER_INFO.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMS_SIGNER_INFO
  //
  //  pvStructInfo points to CMSG_CMS_SIGNER_INFO.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  Verisign Certificate Extension Object Identifiers
  //--------------------------------------------------------------------------
const
  // Octet String containing Boolean
    szOID_VERISIGN_PRIVATE_6_9      = '2.16.840.1.113733.1.6.9';

  // Octet String containing IA5 string: lower case 32 char hex string
    szOID_VERISIGN_ONSITE_JURISDICTION_HASH = '2.16.840.1.113733.1.6.11';

  // Octet String containing Bit string
    szOID_VERISIGN_BITSTRING_6_13    = '2.16.840.1.113733.1.6.13';

  // EKU
    szOID_VERISIGN_ISS_STRONG_CRYPTO = '2.16.840.1.113733.1.8.1';

  //+-------------------------------------------------------------------------
  //  Netscape Certificate Extension Object Identifiers
  //--------------------------------------------------------------------------
  szOID_NETSCAPE                   = '2.16.840.1.113730';
  szOID_NETSCAPE_CERT_EXTENSION    = '2.16.840.1.113730.1';
  szOID_NETSCAPE_CERT_TYPE         = '2.16.840.1.113730.1.1';
  szOID_NETSCAPE_BASE_URL          = '2.16.840.1.113730.1.2';
  szOID_NETSCAPE_REVOCATION_URL    = '2.16.840.1.113730.1.3';
  szOID_NETSCAPE_CA_REVOCATION_URL = '2.16.840.1.113730.1.4';
  szOID_NETSCAPE_CERT_RENEWAL_URL  = '2.16.840.1.113730.1.7';
  szOID_NETSCAPE_CA_POLICY_URL     = '2.16.840.1.113730.1.8';
  szOID_NETSCAPE_SSL_SERVER_NAME   = '2.16.840.1.113730.1.12';
  szOID_NETSCAPE_COMMENT           = '2.16.840.1.113730.1.13';

  //+-------------------------------------------------------------------------
  //  Netscape Certificate Data Type Object Identifiers
  //--------------------------------------------------------------------------
  szOID_NETSCAPE_DATA_TYPE     = '2.16.840.1.113730.2';
  szOID_NETSCAPE_CERT_SEQUENCE = '2.16.840.1.113730.2.5';

  //+-------------------------------------------------------------------------
  //  szOID_NETSCAPE_CERT_TYPE extension
  //
  //  Its value is a bit string. CryptDecodeObject/CryptEncodeObject using
  //  X509_BITS or X509_BITS_WITHOUT_TRAILING_ZEROES.
  //
  //  The following bits are defined:
  //--------------------------------------------------------------------------
  NETSCAPE_SSL_CLIENT_AUTH_CERT_TYPE = $80;
  NETSCAPE_SSL_SERVER_AUTH_CERT_TYPE = $40;
  NETSCAPE_SMIME_CERT_TYPE           = $20;
  NETSCAPE_SIGN_CERT_TYPE            = $10;
  NETSCAPE_SSL_CA_CERT_TYPE          = $04;
  NETSCAPE_SMIME_CA_CERT_TYPE        = $02;
  NETSCAPE_SIGN_CA_CERT_TYPE         = $01;

  //+-------------------------------------------------------------------------
  //  szOID_NETSCAPE_BASE_URL extension
  //
  //  Its value is an IA5_STRING. CryptDecodeObject/CryptEncodeObject using
  //  X509_ANY_STRING or X509_UNICODE_ANY_STRING, where,
  //  dwValueType = CERT_RDN_IA5_STRING.
  //
  //  When present this string is added to the beginning of all relative URLs
  //  in the certificate.  This extension can be considered an optimization
  //  to reduce the size of the URL extensions.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  szOID_NETSCAPE_REVOCATION_URL extension
  //
  //  Its value is an IA5_STRING. CryptDecodeObject/CryptEncodeObject using
  //  X509_ANY_STRING or X509_UNICODE_ANY_STRING, where,
  //  dwValueType = CERT_RDN_IA5_STRING.
  //
  //  It is a relative or absolute URL that can be used to check the
  //  revocation status of a certificate. The revocation check will be
  //  performed as an HTTP GET method using a url that is the concatenation of
  //  revocation-url and certificate-serial-number.
  //  Where the certificate-serial-number is encoded as a string of
  //  ascii hexadecimal digits. For example, if the netscape-base-url is
  //  https://www.certs-r-us.com/, the netscape-revocation-url is
  //  cgi-bin/check-rev.cgi?, and the certificate serial number is 173420,
  //  the resulting URL would be:
  //  https://www.certs-r-us.com/cgi-bin/check-rev.cgi?02a56c
  //
  //  The server should return a document with a Content-Type of
  //  application/x-netscape-revocation.  The document should contain
  //  a single ascii digit, '1' if the certificate is not curently valid,
  //  and '0' if it is curently valid.
  //
  //  Note: for all of the URLs that include the certificate serial number,
  //  the serial number will be encoded as a string which consists of an even
  //  number of hexadecimal digits.  If the number of significant digits is odd,
  //  the string will have a single leading zero to ensure an even number of
  //  digits is generated.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  szOID_NETSCAPE_CA_REVOCATION_URL extension
  //
  //  Its value is an IA5_STRING. CryptDecodeObject/CryptEncodeObject using
  //  X509_ANY_STRING or X509_UNICODE_ANY_STRING, where,
  //  dwValueType = CERT_RDN_IA5_STRING.
  //
  //  It is a relative or absolute URL that can be used to check the
  //  revocation status of any certificates that are signed by the CA that
  //  this certificate belongs to. This extension is only valid in CA
  //  certificates.  The use of this extension is the same as the above
  //  szOID_NETSCAPE_REVOCATION_URL extension.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  szOID_NETSCAPE_CERT_RENEWAL_URL extension
  //
  //  Its value is an IA5_STRING. CryptDecodeObject/CryptEncodeObject using
  //  X509_ANY_STRING or X509_UNICODE_ANY_STRING, where,
  //  dwValueType = CERT_RDN_IA5_STRING.
  //
  //  It is a relative or absolute URL that points to a certificate renewal
  //  form. The renewal form will be accessed with an HTTP GET method using a
  //  url that is the concatenation of renewal-url and
  //  certificate-serial-number. Where the certificate-serial-number is
  //  encoded as a string of ascii hexadecimal digits. For example, if the
  //  netscape-base-url is https://www.certs-r-us.com/, the
  //  netscape-cert-renewal-url is cgi-bin/check-renew.cgi?, and the
  //  certificate serial number is 173420, the resulting URL would be:
  //  https://www.certs-r-us.com/cgi-bin/check-renew.cgi?02a56c
  //  The document returned should be an HTML form that will allow the user
  //  to request a renewal of their certificate.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  szOID_NETSCAPE_CA_POLICY_URL extension
  //
  //  Its value is an IA5_STRING. CryptDecodeObject/CryptEncodeObject using
  //  X509_ANY_STRING or X509_UNICODE_ANY_STRING, where,
  //  dwValueType = CERT_RDN_IA5_STRING.
  //
  //  It is a relative or absolute URL that points to a web page that
  //  describes the policies under which the certificate was issued.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  szOID_NETSCAPE_SSL_SERVER_NAME extension
  //
  //  Its value is an IA5_STRING. CryptDecodeObject/CryptEncodeObject using
  //  X509_ANY_STRING or X509_UNICODE_ANY_STRING, where,
  //  dwValueType = CERT_RDN_IA5_STRING.
  //
  //  It is a "shell expression" that can be used to match the hostname of the
  //  SSL server that is using this certificate.  It is recommended that if
  //  the server's hostname does not match this pattern the user be notified
  //  and given the option to terminate the SSL connection.  If this extension
  //  is not present then the CommonName in the certificate subject's
  //  distinguished name is used for the same purpose.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  szOID_NETSCAPE_COMMENT extension
  //
  //  Its value is an IA5_STRING. CryptDecodeObject/CryptEncodeObject using
  //  X509_ANY_STRING or X509_UNICODE_ANY_STRING, where,
  //  dwValueType = CERT_RDN_IA5_STRING.
  //
  //  It is a comment that may be displayed to the user when the certificate
  //  is viewed.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  szOID_NETSCAPE_CERT_SEQUENCE
  //
  //  Its value is a PKCS#7 ContentInfo structure wrapping a sequence of
  //  certificates. The value of the contentType field is
  //  szOID_NETSCAPE_CERT_SEQUENCE, while the content field is the following
  //  structure:
  //      CertificateSequence ::= SEQUENCE OF Certificate.
  //
  //  CryptDecodeObject/CryptEncodeObject using
  //  PKCS_CONTENT_INFO_SEQUENCE_OF_ANY, where,
  //  pszObjId = szOID_NETSCAPE_CERT_SEQUENCE and the CRYPT_DER_BLOBs point
  //  to encoded X509 certificates.
  //--------------------------------------------------------------------------

  //+=========================================================================
  //  Certificate Management Messages over CMS (CMC) Data Structures
  //==========================================================================

  // Content Type (request)
  szOID_CT_PKI_DATA               = '1.3.6.1.5.5.7.12.2';

  // Content Type (response)
  szOID_CT_PKI_RESPONSE           = '1.3.6.1.5.5.7.12.3';

  // Signature value that only contains the hash octets. The parameters for
  // this algorithm must be present and must be encoded as NULL.
  szOID_PKIX_NO_SIGNATURE         = '1.3.6.1.5.5.7.6.2';

  szOID_CMC                       = '1.3.6.1.5.5.7.7';
  szOID_CMC_STATUS_INFO           = '1.3.6.1.5.5.7.7.1';
  szOID_CMC_IDENTIFICATION        = '1.3.6.1.5.5.7.7.2';
  szOID_CMC_IDENTITY_PROOF        = '1.3.6.1.5.5.7.7.3';
  szOID_CMC_DATA_RETURN           = '1.3.6.1.5.5.7.7.4';

  // Transaction Id (integer)
  szOID_CMC_TRANSACTION_ID        = '1.3.6.1.5.5.7.7.5';

  // Sender Nonce (octet string)
  szOID_CMC_SENDER_NONCE          = '1.3.6.1.5.5.7.7.6';

  // Recipient Nonce (octet string)
  szOID_CMC_RECIPIENT_NONCE       = '1.3.6.1.5.5.7.7.7';

  szOID_CMC_ADD_EXTENSIONS        = '1.3.6.1.5.5.7.7.8';
  szOID_CMC_ENCRYPTED_POP         = '1.3.6.1.5.5.7.7.9';
  szOID_CMC_DECRYPTED_POP         = '1.3.6.1.5.5.7.7.10';
  szOID_CMC_LRA_POP_WITNESS       = '1.3.6.1.5.5.7.7.11';

  // Issuer Name + Serial
  szOID_CMC_GET_CERT              = '1.3.6.1.5.5.7.7.15';

  // Issuer Name [+ CRL Name] + Time [+ Reasons]
  szOID_CMC_GET_CRL               = '1.3.6.1.5.5.7.7.16';

  // Issuer Name + Serial [+ Reason] [+ Effective Time] [+ Secret] [+ Comment]
  szOID_CMC_REVOKE_REQUEST        = '1.3.6.1.5.5.7.7.17';

  // (octet string) URL-style parameter list (IA5?)
  szOID_CMC_REG_INFO              = '1.3.6.1.5.5.7.7.18';

  szOID_CMC_RESPONSE_INFO         = '1.3.6.1.5.5.7.7.19';

  // (octet string)
  szOID_CMC_QUERY_PENDING         = '1.3.6.1.5.5.7.7.21';
  szOID_CMC_ID_POP_LINK_RANDOM    = '1.3.6.1.5.5.7.7.22';
  szOID_CMC_ID_POP_LINK_WITNESS   = '1.3.6.1.5.5.7.7.23';

  // optional Name + Integer
  szOID_CMC_ID_CONFIRM_CERT_ACCEPTANCE = '1.3.6.1.5.5.7.7.24';

  szOID_CMC_ADD_ATTRIBUTES        = '1.3.6.1.4.1.311.10.10.1';

  //+-------------------------------------------------------------------------
  //  CMC_DATA
  //  CMC_RESPONSE
  //
  //  Certificate Management Messages over CMS (CMC) PKIData and Response
  //  messages.
  //
  //  For CMC_DATA, pvStructInfo points to a CMC_DATA_INFO.
  //  CMC_DATA_INFO contains optional arrays of tagged attributes, requests,
  //  content info and/or arbitrary other messages.
  //
  //  For CMC_RESPONSE, pvStructInfo points to a CMC_RESPONSE_INFO.
  //  CMC_RESPONSE_INFO is the same as CMC_DATA_INFO without the tagged
  //  requests.
  //--------------------------------------------------------------------------
type
  CMC_TAGGED_ATTRIBUTE = record
    dwBodyPartID: DWORD;
    Attribute:    CRYPT_ATTRIBUTE;
  end;
  PCMC_TAGGED_ATTRIBUTE = ^CMC_TAGGED_ATTRIBUTE;

  CMC_TAGGED_CERT_REQUEST = record
    dwBodyPartID:      DWORD;
    SignedCertRequest: CRYPT_DER_BLOB;
  end;
  PCMC_TAGGED_CERT_REQUEST = ^CMC_TAGGED_CERT_REQUEST;

const
  CMC_TAGGED_CERT_REQUEST_CHOICE = 1;
type
  CMC_TAGGED_REQUEST = record
    case dwTaggedRequestChoice: DWORD of
      CMC_TAGGED_CERT_REQUEST_CHOICE:
        (pTaggedCertRequest: PCMC_TAGGED_CERT_REQUEST);
  end;
  PCMC_TAGGED_REQUEST = ^CMC_TAGGED_REQUEST;

  CMC_TAGGED_CONTENT_INFO = record
    dwBodyPartID:       DWORD;
    EncodedContentInfo: CRYPT_DER_BLOB;
  end;
  PCMC_TAGGED_CONTENT_INFO = ^CMC_TAGGED_CONTENT_INFO;

  CMC_TAGGED_OTHER_MSG = record
    dwBodyPartID: DWORD;
    pszObjId:     LPSTR;
    Value:        CRYPT_OBJID_BLOB;
  end;
  PCMC_TAGGED_OTHER_MSG = ^CMC_TAGGED_OTHER_MSG;

  // All the tagged arrays are optional
  CMC_DATA_INFO = record
    cTaggedAttribute:    DWORD;
    rgTaggedAttribute:   PCMC_TAGGED_ATTRIBUTE;
    cTaggedRequest:      DWORD;
    rgTaggedRequest:     PCMC_TAGGED_REQUEST;
    cTaggedContentInfo:  DWORD;
    rgTaggedContentInfo: PCMC_TAGGED_CONTENT_INFO;
    cTaggedOtherMsg:     DWORD;
    rgTaggedOtherMsg:    PCMC_TAGGED_OTHER_MSG;
  end;
  PCMC_DATA_INFO = ^CMC_DATA_INFO;

  // All the tagged arrays are optional
  CMC_RESPONSE_INFO = record
    cTaggedAttribute:    DWORD;
    rgTaggedAttribute:   PCMC_TAGGED_ATTRIBUTE;
    cTaggedContentInfo:  DWORD;
    rgTaggedContentInfo: PCMC_TAGGED_CONTENT_INFO;
    cTaggedOtherMsg:     DWORD;
    rgTaggedOtherMsg:    PCMC_TAGGED_OTHER_MSG;
  end;
  PCMC_RESPONSE_INFO = ^CMC_RESPONSE_INFO;


  //+-------------------------------------------------------------------------
  //  CMC_STATUS
  //
  //  Certificate Management Messages over CMS (CMC) Status.
  //
  //  pvStructInfo points to a CMC_STATUS_INFO.
  //--------------------------------------------------------------------------
  CMC_PEND_INFO = record
    PendToken: CRYPT_DATA_BLOB;
    PendTime:  FILETIME;
  end;
  PCMC_PEND_INFO = ^CMC_PEND_INFO;

// dwStatus values
const
  CMC_OTHER_INFO_NO_CHOICE   = 0;
  CMC_OTHER_INFO_FAIL_CHOICE = 1;
  CMC_OTHER_INFO_PEND_CHOICE = 2;

type
  CMC_STATUS_INFO = record
    dwStatus:         DWORD;
    cBodyList:        DWORD;
    rgdwBodyList:     PDWORD;
    pwszStatusString: LPWSTR;   // OPTIONAL
    case dwOtherInfoChoice: DWORD of
      // CMC_OTHER_INFO_NO_CHOICE
      //  none
      CMC_OTHER_INFO_FAIL_CHOICE:(dwFailInfo: DWORD);
      CMC_OTHER_INFO_PEND_CHOICE:(pPendInfo:  PCMC_PEND_INFO);
  end;
  PCMC_STATUS_INFO = ^CMC_STATUS_INFO;

const
  // Request was granted
  CMC_STATUS_SUCCESS         = 0;

  // Request failed, more information elsewhere in the message
  CMC_STATUS_FAILED          = 2;

  // The request body part has not yet been processed. Requester is responsible
  // to poll back. May only be returned for certificate request operations.
  CMC_STATUS_PENDING         = 3;

  // The requested operation is not supported
  CMC_STATUS_NO_SUPPORT      = 4;

  // Confirmation using the idConfirmCertAcceptance control is required
  // before use of certificate
  CMC_STATUS_CONFIRM_REQUIRED= 5;

  // dwFailInfo values

  // Unrecognized or unsupported algorithm
  CMC_FAIL_BAD_ALG           = 0;

  // Integrity check failed
  CMC_FAIL_BAD_MESSAGE_CHECK = 1;

  // Transaction not permitted or supported
  CMC_FAIL_BAD_REQUEST       = 2;

  // Message time field was not sufficiently close to the system time
  CMC_FAIL_BAD_TIME          = 3;

  // No certificate could be identified matching the provided criteria
  CMC_FAIL_BAD_CERT_ID       = 4;

  // A requested X.509 extension is not supported by the recipient CA.
  CMC_FAIL_UNSUPORTED_EXT    = 5;

  // Private key material must be supplied
  CMC_FAIL_MUST_ARCHIVE_KEYS = 6;

  // Identification Attribute failed to verify
  CMC_FAIL_BAD_IDENTITY      = 7;

  // Server requires a POP proof before issuing certificate
  CMC_FAIL_POP_REQUIRED      = 8;

  // POP processing failed
  CMC_FAIL_POP_FAILED        = 9;

  // Server policy does not allow key re-use
  CMC_FAIL_NO_KEY_REUSE      = 10;

  CMC_FAIL_INTERNAL_CA_ERROR = 11;

  CMC_FAIL_TRY_LATER         = 12;

  //+-------------------------------------------------------------------------
  //  CMC_ADD_EXTENSIONS
  //
  //  Certificate Management Messages over CMS (CMC) Add Extensions control
  //  attribute.
  //
  //  pvStructInfo points to a CMC_ADD_EXTENSIONS_INFO.
  //--------------------------------------------------------------------------
type
  CMC_ADD_EXTENSIONS_INFO = record
    dwCmcDataReference: DWORD;
    cCertReference:     DWORD;
    rgdwCertReference:  PDWORD;
    cExtension:         DWORD;
    rgExtension:        PCERT_EXTENSION;
  end;
  PCMC_ADD_EXTENSIONS_INFO = ^CMC_ADD_EXTENSIONS_INFO;

  //+-------------------------------------------------------------------------
  //  CMC_ADD_ATTRIBUTES
  //
  //  Certificate Management Messages over CMS (CMC) Add Attributes control
  //  attribute.
  //
  //  pvStructInfo points to a CMC_ADD_ATTRIBUTES_INFO.
  //--------------------------------------------------------------------------
  CMC_ADD_ATTRIBUTES_INFO = record
    dwCmcDataReference: DWORD;
    cCertReference:     DWORD;
    rgdwCertReference:  PDWORD;
    cAttribute:         DWORD;
    rgAttribute:        PCRYPT_ATTRIBUTE;
  end;
  PCMC_ADD_ATTRIBUTES_INFO = ^CMC_ADD_ATTRIBUTES_INFO;

  //+-------------------------------------------------------------------------
  //  X509_CERTIFICATE_TEMPLATE
  //  szOID_CERTIFICATE_TEMPLATE
  //
  //  pvStructInfo points to following CERT_TEMPLATE_EXT data structure.
  //
  //--------------------------------------------------------------------------
  CERT_TEMPLATE_EXT = record
    pszObjId:       LPSTR;
    dwMajorVersion: DWORD;
    fMinorVersion:  BOOL;      // TRUE for a minor version
    dwMinorVersion: DWORD;
  end;
  PCERT_TEMPLATE_EXT = ^CERT_TEMPLATE_EXT;

  //+=========================================================================
  //  Object IDentifier (OID) Installable Functions:  Data Structures and APIs
  //==========================================================================
type
  HCRYPTOIDFUNCSET  = pointer;
  HCRYPTOIDFUNCADDR = pointer;
  PHCRYPTOIDFUNCADDR = ^HCRYPTOIDFUNCADDR;

  // Predefined OID Function Names
const
  CRYPT_OID_ENCODE_OBJECT_FUNC       = 'CryptDllEncodeObject';
  CRYPT_OID_DECODE_OBJECT_FUNC       = 'CryptDllDecodeObject';
  CRYPT_OID_ENCODE_OBJECT_EX_FUNC    = 'CryptDllEncodeObjectEx';
  CRYPT_OID_DECODE_OBJECT_EX_FUNC    = 'CryptDllDecodeObjectEx';
  CRYPT_OID_CREATE_COM_OBJECT_FUNC   = 'CryptDllCreateCOMObject';
  CRYPT_OID_VERIFY_REVOCATION_FUNC   = 'CertDllVerifyRevocation';
  CRYPT_OID_VERIFY_CTL_USAGE_FUNC    = 'CertDllVerifyCTLUsage';
  CRYPT_OID_FORMAT_OBJECT_FUNC       = 'CryptDllFormatObject';
  CRYPT_OID_FIND_OID_INFO_FUNC       = 'CryptDllFindOIDInfo';
  CRYPT_OID_FIND_LOCALIZED_NAME_FUNC = 'CryptDllFindLocalizedName';

  // CryptDllEncodeObject has same function signature as CryptEncodeObject.

  // CryptDllDecodeObject has same function signature as CryptDecodeObject.

  // CryptDllEncodeObjectEx has same function signature as CryptEncodeObjectEx.
  // The Ex version MUST support the CRYPT_ENCODE_ALLOC_FLAG option.
  //
  // If an Ex function isn't installed or registered, then, attempts to find
  // a non-EX version. If the ALLOC flag is set, then, CryptEncodeObjectEx,
  // does the allocation and calls the non-EX version twice.

  // CryptDllDecodeObjectEx has same function signature as CryptDecodeObjectEx.
  // The Ex version MUST support the CRYPT_DECODE_ALLOC_FLAG option.
  //
  // If an Ex function isn't installed or registered, then, attempts to find
  // a non-EX version. If the ALLOC flag is set, then, CryptDecodeObjectEx,
  // does the allocation and calls the non-EX version twice.

  // CryptDllCreateCOMObject has the following signature:
  //      BOOL WINAPI CryptDllCreateCOMObject(
  //          IN DWORD dwEncodingType,
  //          IN LPCSTR pszOID,
  //          IN PCRYPT_DATA_BLOB pEncodedContent,
  //          IN DWORD dwFlags,
  //          IN REFIID riid,
  //          OUT void **ppvObj);

  // CertDllVerifyRevocation has the same signature as CertVerifyRevocation
  //  (See CertVerifyRevocation for details on when called)

  // CertDllVerifyCTLUsage has the same signature as CertVerifyCTLUsage

  // CryptDllFindOIDInfo currently is only used to store values used by
  // CryptFindOIDInfo. See CryptFindOIDInfo() for more details.

  // CryptDllFindLocalizedName is only used to store localized string
  // values used by CryptFindLocalizedName. See CryptFindLocalizedName() for
  // more details.

  //  Example of a complete OID Function Registry Name:
  //    HKEY_LOCAL_MACHINE\Software\Microsoft\Cryptography\OID
  //      Encoding Type 1\CryptDllEncodeObject\1.2.3
  //
  //  The key's L"Dll" value contains the name of the Dll.
  //  The key's L"FuncName" value overrides the default function name
const
  CRYPT_OID_REGPATH = 'Software\\Microsoft\\Cryptography\\OID';
  CRYPT_OID_REG_ENCODING_TYPE_PREFIX   = 'EncodingType ';
  CRYPT_OID_REG_DLL_VALUE_NAME         = WideString('Dll');
  CRYPT_OID_REG_FUNC_NAME_VALUE_NAME   = WideString('FuncName');
  CRYPT_OID_REG_FUNC_NAME_VALUE_NAME_A = AnsiString('FuncName');

  // CRYPT_INSTALL_OID_FUNC_BEFORE_FLAG can be set in the key's L"CryptFlags"
  // value to register the functions before the installed functions.
  //
  // CryptSetOIDFunctionValue must be called to set this value. L"CryptFlags"
  // must be set using a dwValueType of REG_DWORD.
  CRYPT_OID_REG_FLAGS_VALUE_NAME = WideString('CryptFlags');

  // OID used for Default OID functions
  CRYPT_DEFAULT_OID = 'DEFAULT';

type
  CRYPT_OID_FUNC_ENTRY = record
    pszOID:     LPCSTR;
    pvFuncAddr: pointer;
  end;
  PCRYPT_OID_FUNC_ENTRY = ^CRYPT_OID_FUNC_ENTRY;

const
  CRYPT_INSTALL_OID_FUNC_BEFORE_FLAG = 1;

  //+-------------------------------------------------------------------------
  //  Install a set of callable OID function addresses.
  //
  //  By default the functions are installed at end of the list.
  //  Set CRYPT_INSTALL_OID_FUNC_BEFORE_FLAG to install at beginning of list.
  //
  //  hModule should be updated with the hModule passed to DllMain to prevent
  //  the Dll containing the function addresses from being unloaded by
  //  CryptGetOIDFuncAddress/CryptFreeOIDFunctionAddress. This would be the
  //  case when the Dll has also regsvr32'ed OID functions via
  //  CryptRegisterOIDFunction.
  //
  //  DEFAULT functions are installed by setting rgFuncEntry[].pszOID =
  //  CRYPT_DEFAULT_OID.
  //--------------------------------------------------------------------------
function CryptInstallOIDFunctionAddress(
  hModule: HMODULE; // hModule passed to DllMain
  dwEncodingType: DWORD;
  pszFuncName: LPCSTR;
  cFuncEntry: DWORD;
  rgFuncEntry: PCRYPT_OID_FUNC_ENTRY;
  dwFlags: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Initialize and return handle to the OID function set identified by its
//  function name.
//
//  If the set already exists, a handle to the existing set is returned.
//--------------------------------------------------------------------------
function CryptInitOIDFunctionSet(
  pszFuncName: LPCSTR;
  dwFlags: DWORD
  ): HCRYPTOIDFUNCSET; stdcall;

//+-------------------------------------------------------------------------
//  Search the list of installed functions for an encoding type and OID match.
//  If not found, search the registry.
//
//  For success, returns TRUE with *ppvFuncAddr updated with the function's
//  address and *phFuncAddr updated with the function address's handle.
//  The function's handle is AddRef'ed. CryptFreeOIDFunctionAddress needs to
//  be called to release it.
//
//  For a registry match, the Dll containing the function is loaded.
//
//  By default, both the registered and installed function lists are searched.
//  Set CRYPT_GET_INSTALLED_OID_FUNC_FLAG to only search the installed list
//  of functions. This flag would be set by a registered function to get
//  the address of a pre-installed function it was replacing. For example,
//  the registered function might handle a new special case and call the
//  pre-installed function to handle the remaining cases.
//--------------------------------------------------------------------------
function CryptGetOIDFunctionAddress(
  hFuncSet: HCRYPTOIDFUNCSET;
  dwEncodingType: DWORD;
  pszOID: LPCSTR;
  dwFlags: DWORD;
  var ppvFuncAddr: pointer;
  var phFuncAddr: HCRYPTOIDFUNCADDR
  ): BOOL; stdcall;

const
  CRYPT_GET_INSTALLED_OID_FUNC_FLAG = $1;

  //+-------------------------------------------------------------------------
  //  Get the list of registered default Dll entries for the specified
  //  function set and encoding type.
  //
  //  The returned list consists of none, one or more null terminated Dll file
  //  names. The list is terminated with an empty (L"\0") Dll file name.
  //  For example: L"first.dll" L"\0" L"second.dll" L"\0" L"\0"
  //--------------------------------------------------------------------------
function CryptGetDefaultOIDDllList(
  hFuncSet: HCRYPTOIDFUNCSET;
  dwEncodingType: DWORD;
  pwszDllList: LPWSTR;
  var pcchDllList: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Either: get the first or next installed DEFAULT function OR
//  load the Dll containing the DEFAULT function.
//
//  If pwszDll is NULL, search the list of installed DEFAULT functions.
//  *phFuncAddr must be set to NULL to get the first installed function.
//  Successive installed functions are returned by setting *phFuncAddr
//  to the hFuncAddr returned by the previous call.
//
//  If pwszDll is NULL, the input *phFuncAddr
//  is always CryptFreeOIDFunctionAddress'ed by this function, even for
//  an error.
//
//  If pwszDll isn't NULL, then, attempts to load the Dll and the DEFAULT
//  function. *phFuncAddr is ignored upon entry and isn't
//  CryptFreeOIDFunctionAddress'ed.
//
//  For success, returns TRUE with *ppvFuncAddr updated with the function's
//  address and *phFuncAddr updated with the function address's handle.
//  The function's handle is AddRef'ed. CryptFreeOIDFunctionAddress needs to
//  be called to release it or CryptGetDefaultOIDFunctionAddress can also
//  be called for a NULL pwszDll.
//--------------------------------------------------------------------------
function CryptGetDefaultOIDFunctionAddress(
  hFuncSet: HCRYPTOIDFUNCSET;
  dwEncodingType: DWORD;
  pwszDll: LPCWSTR;
  dwFlags: DWORD;
  var ppvFuncAddr: pointer;
  phFuncAddr: PHCRYPTOIDFUNCADDR
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Releases the handle AddRef'ed and returned by CryptGetOIDFunctionAddress
//  or CryptGetDefaultOIDFunctionAddress.
//
//  If a Dll was loaded for the function its unloaded. However, before doing
//  the unload, the DllCanUnloadNow function exported by the loaded Dll is
//  called. It should return S_FALSE to inhibit the unload or S_TRUE to enable
//  the unload. If the Dll doesn't export DllCanUnloadNow, the Dll is unloaded.
//
//  DllCanUnloadNow has the following signature:
//      STDAPI  DllCanUnloadNow(void);
//--------------------------------------------------------------------------
function CryptFreeOIDFunctionAddress(
  hFuncAddr: HCRYPTOIDFUNCADDR;
  dwFlags: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Register the Dll containing the function to be called for the specified
//  encoding type, function name and OID.
//
//  pwszDll may contain environment-variable strings
//  which are ExpandEnvironmentStrings()'ed before loading the Dll.
//
//  In addition to registering the DLL, you may override the
//  name of the function to be called. For example,
//      pszFuncName = "CryptDllEncodeObject",
//      pszOverrideFuncName = "MyEncodeXyz".
//  This allows a Dll to export multiple OID functions for the same
//  function name without needing to interpose its own OID dispatcher function.
//--------------------------------------------------------------------------
function CryptRegisterOIDFunction(
  dwEncodingType: DWORD;
  pszFuncName: LPCSTR;
  pszOID: LPCSTR;
  pwszDll: LPCWSTR;
  pszOverrideFuncName: LPCSTR
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Unregister the Dll containing the function to be called for the specified
//  encoding type, function name and OID.
//--------------------------------------------------------------------------
function CryptUnregisterOIDFunction(
  dwEncodingType: DWORD;
  pszFuncName: LPCSTR;
  pszOID: LPCSTR
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Register the Dll containing the default function to be called for the
//  specified encoding type and function name.
//
//  Unlike CryptRegisterOIDFunction, you can't override the function name
//  needing to be exported by the Dll.
//
//  The Dll is inserted before the entry specified by dwIndex.
//    dwIndex == 0, inserts at the beginning.
//    dwIndex == CRYPT_REGISTER_LAST_INDEX, appends at the end.
//
//  pwszDll may contain environment-variable strings
//  which are ExpandEnvironmentStrings()'ed before loading the Dll.
//--------------------------------------------------------------------------
function CryptRegisterDefaultOIDFunction(
  dwEncodingType: DWORD;
  pszFuncName: LPCSTR;
  dwIndex: DWORD;
  pwszDll: LPCWSTR
  ): BOOL; stdcall;

const
  CRYPT_REGISTER_FIRST_INDEX = 0;
  CRYPT_REGISTER_LAST_INDEX  = $FFFFFFFF;

  //+-------------------------------------------------------------------------
  //  Unregister the Dll containing the default function to be called for
  //  the specified encoding type and function name.
  //--------------------------------------------------------------------------
function CryptUnregisterDefaultOIDFunction(
  dwEncodingType: DWORD;
  pszFuncName: LPCSTR;
  pwszDll: LPCWSTR
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Set the value for the specified encoding type, function name, OID and
//  value name.
//
//  See RegSetValueEx for the possible value types.
//
//  String types are UNICODE.
//--------------------------------------------------------------------------
function CryptSetOIDFunctionValue(
  dwEncodingType: DWORD;
  pszFuncName: LPCSTR;
  pszOID: LPCSTR;
  pwszValueName: LPCWSTR;
  dwValueType: DWORD;
  pbValueData: PBYTE;
  cbValueData: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Get the value for the specified encoding type, function name, OID and
//  value name.
//
//  See RegEnumValue for the possible value types.
//
//  String types are UNICODE.
//--------------------------------------------------------------------------
function CryptGetOIDFunctionValue(
  dwEncodingType: DWORD;
  pszFuncName: LPCSTR;
  pszOID: LPCSTR;
  pwszValueName: LPCWSTR;
  var pdwValueType: DWORD;
  pbValueData: PBYTE;
  var pcbValueData: DWORD
  ): BOOL; stdcall;

type
  TARR_LPCWSTR = ^LPCWSTR; {My types. Oleg}
  TARR_PBYTE =   ^PBYTE;
  TARR_DWORD =   ^DWORD;

  PFN_CRYPT_ENUM_OID_FUNC = function(
    dwEncodingType: DWORD;
    pszFuncName: LPCSTR;
    pszOID: LPCSTR;
    cValue: DWORD;
    rgdwValueType: PDWORD;
    rgpwszValueName: TARR_LPCWSTR;
    rgpbValueData: TARR_PBYTE;
    rgcbValueData: TARR_DWORD;
    pvArg: pointer
    ): BOOL; stdcall;

  //+-------------------------------------------------------------------------
  //  Enumerate the OID functions identified by their encoding type,
  //  function name and OID.
  //
  //  pfnEnumOIDFunc is called for each registry key matching the input
  //  parameters. Setting dwEncodingType to CRYPT_MATCH_ANY_ENCODING_TYPE matches
  //  any. Setting pszFuncName or pszOID to NULL matches any.
  //
  //  Set pszOID == CRYPT_DEFAULT_OID to restrict the enumeration to only the
  //  DEFAULT functions
  //
  //  String types are UNICODE.
  //--------------------------------------------------------------------------
function CryptEnumOIDFunction(
  dwEncodingType: DWORD;
  pszFuncName: LPCSTR;
  pszOID: LPCSTR;
  dwFlags: DWORD;
  pvArg: pointer;
  pfnEnumOIDFunc: PFN_CRYPT_ENUM_OID_FUNC
  ): BOOL; stdcall;

const
  CRYPT_MATCH_ANY_ENCODING_TYPE = $FFFFFFFF;

  //+=========================================================================
  //  Object IDentifier (OID) Information:  Data Structures and APIs
  //==========================================================================

  //+-------------------------------------------------------------------------
  //  OID Information
  //--------------------------------------------------------------------------
type
  CRYPT_OID_INFO = record
    cbSize:    DWORD;
    pszOID:    LPCSTR;
    pwszName:  LPCWSTR;
    dwGroupId: DWORD;
    case integer of
      1: (
        dwValue:    DWORD;
        ExtraInfo:  CRYPT_DATA_BLOB);
      2: (
        Algid:      ALG_ID);
      3: (
        dwLength:   DWORD);
  end;
  PCRYPT_OID_INFO = ^CRYPT_OID_INFO;
  CCRYPT_OID_INFO = CRYPT_OID_INFO;
  PCCRYPT_OID_INFO = ^CCRYPT_OID_INFO;

  //+-------------------------------------------------------------------------
  //  OID Group IDs
  //--------------------------------------------------------------------------
const
  CRYPT_HASH_ALG_OID_GROUP_ID     = 1;
  CRYPT_ENCRYPT_ALG_OID_GROUP_ID  = 2;
  CRYPT_PUBKEY_ALG_OID_GROUP_ID   = 3;
  CRYPT_SIGN_ALG_OID_GROUP_ID     = 4;
  CRYPT_RDN_ATTR_OID_GROUP_ID     = 5;
  CRYPT_EXT_OR_ATTR_OID_GROUP_ID  = 6;
  CRYPT_ENHKEY_USAGE_OID_GROUP_ID = 7;
  CRYPT_POLICY_OID_GROUP_ID       = 8;
  CRYPT_TEMPLATE_OID_GROUP_ID     = 9;
  CRYPT_LAST_OID_GROUP_ID         = 9;

  CRYPT_FIRST_ALG_OID_GROUP_ID = CRYPT_HASH_ALG_OID_GROUP_ID;
  CRYPT_LAST_ALG_OID_GROUP_ID  = CRYPT_SIGN_ALG_OID_GROUP_ID;

  // The CRYPT_*_ALG_OID_GROUP_ID's have an Algid. The CRYPT_RDN_ATTR_OID_GROUP_ID
  // has a dwLength. The CRYPT_EXT_OR_ATTR_OID_GROUP_ID,
  // CRYPT_ENHKEY_USAGE_OID_GROUP_ID, CRYPT_POLICY_OID_GROUP_ID or
  // CRYPT_TEMPLATE_OID_GROUP_ID don't have a dwValue.
  //

  // CRYPT_PUBKEY_ALG_OID_GROUP_ID has the following optional ExtraInfo:
  //  DWORD[0] - Flags. CRYPT_OID_INHIBIT_SIGNATURE_FORMAT_FLAG can be set to
  //             inhibit the reformatting of the signature before
  //             CryptVerifySignature is called or after CryptSignHash
  //             is called. CRYPT_OID_USE_PUBKEY_PARA_FOR_PKCS7_FLAG can
  //             be set to include the public key algorithm's parameters
  //             in the PKCS7's digestEncryptionAlgorithm's parameters.
  //             CRYPT_OID_NO_NULL_ALGORITHM_PARA_FLAG can be set to omit
  //             NULL parameters when encoding.

  CRYPT_OID_INHIBIT_SIGNATURE_FORMAT_FLAG  = $1;
  CRYPT_OID_USE_PUBKEY_PARA_FOR_PKCS7_FLAG = $2;
  CRYPT_OID_NO_NULL_ALGORITHM_PARA_FLAG    = $4;

  // CRYPT_SIGN_ALG_OID_GROUP_ID has the following optional ExtraInfo:
  //  DWORD[0] - Public Key Algid.
  //  DWORD[1] - Flags. Same as above for CRYPT_PUBKEY_ALG_OID_GROUP_ID.
  //  DWORD[2] - Optional CryptAcquireContext(CRYPT_VERIFYCONTEXT)'s dwProvType.
  //             If omitted or 0, uses Public Key Algid to select
  //             appropriate dwProvType for signature verification.

  // CRYPT_RDN_ATTR_OID_GROUP_ID has the following optional ExtraInfo:
  //  Array of DWORDs:
  //   [0 ..] - Null terminated list of acceptable RDN attribute
  //            value types. An empty list implies CERT_RDN_PRINTABLE_STRING,
  //            CERT_RDN_UNICODE_STRING, 0.

  //+-------------------------------------------------------------------------
  //  Find OID information. Returns NULL if unable to find any information
  //  for the specified key and group. Note, returns a pointer to a constant
  //  data structure. The returned pointer MUST NOT be freed.
  //
  //  dwKeyType's:
  //    CRYPT_OID_INFO_OID_KEY, pvKey points to a szOID
  //    CRYPT_OID_INFO_NAME_KEY, pvKey points to a wszName
  //    CRYPT_OID_INFO_ALGID_KEY, pvKey points to an ALG_ID
  //    CRYPT_OID_INFO_SIGN_KEY, pvKey points to an array of two ALG_ID's:
  //      ALG_ID[0] - Hash Algid
  //      ALG_ID[1] - PubKey Algid
  //
  //  Setting dwGroupId to 0, searches all groups according to the dwKeyType.
  //  Otherwise, only the dwGroupId is searched.
  //--------------------------------------------------------------------------
function CryptFindOIDInfo(
  dwKeyType: DWORD;
  pvKey:     pointer;
  dwGroupId: DWORD
  ): PCCRYPT_OID_INFO; stdcall;

const
  CRYPT_OID_INFO_OID_KEY   = 1;
  CRYPT_OID_INFO_NAME_KEY  = 2;
  CRYPT_OID_INFO_ALGID_KEY = 3;
  CRYPT_OID_INFO_SIGN_KEY  = 4;

  //+-------------------------------------------------------------------------
  //  Register OID information. The OID information specified in the
  //  CCRYPT_OID_INFO structure is persisted to the registry.
  //
  //  crypt32.dll contains information for the commonly known OIDs. This function
  //  allows applications to augment crypt32.dll's OID information. During
  //  CryptFindOIDInfo's first call, the registered OID information is installed.
  //
  //  By default the registered OID information is installed after crypt32.dll's
  //  OID entries. Set CRYPT_INSTALL_OID_INFO_BEFORE_FLAG to install before.
  //--------------------------------------------------------------------------
function CryptRegisterOIDInfo(
  pInfo: PCCRYPT_OID_INFO;
  dwFlags: DWORD
  ): BOOL; stdcall;

const
  CRYPT_INSTALL_OID_INFO_BEFORE_FLAG = 1;

  //+-------------------------------------------------------------------------
  //  Unregister OID information. Only the pszOID and dwGroupId fields are
  //  used to identify the OID information to be unregistered.
  //--------------------------------------------------------------------------
function CryptUnregisterOIDInfo(
  pInfo: PCCRYPT_OID_INFO
  ): BOOL; stdcall;

// If the callback returns FALSE, stops the enumeration.
type
  PFN_CRYPT_ENUM_OID_INFO = function(
    pInfo: PCCRYPT_OID_INFO;
    pvArg: pointer
    ): BOOL; stdcall;

  //+-------------------------------------------------------------------------
  //  Enumerate the OID information.
  //
  //  pfnEnumOIDInfo is called for each OID information entry.
  //
  //  Setting dwGroupId to 0 matches all groups. Otherwise, only enumerates
  //  entries in the specified group.
  //
  //  dwFlags currently isn't used and must be set to 0.
  //--------------------------------------------------------------------------
function CryptEnumOIDInfo(
  dwGroupId: DWORD;
  dwFlags: DWORD;
  pvArg: pointer;
  pfnEnumOIDInfo: PFN_CRYPT_ENUM_OID_INFO
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Find the localized name for the specified name. For example, find the
//  localized name for the "Root" system store name. A case insensitive
//  string comparison is done.
//
//  Returns NULL if unable to find the the specified name.
//
//  Localized names for the predefined system stores ("Root", "My") and
//  predefined physical stores (".Default", ".LocalMachine") are pre-installed
//  as resource strings in crypt32.dll. CryptSetOIDFunctionValue can be called
//  as follows to register additional localized strings:
//      dwEncodingType = CRYPT_LOCALIZED_NAME_ENCODING_TYPE
//      pszFuncName = CRYPT_OID_FIND_LOCALIZED_NAME_FUNC
//      pszOID = CRYPT_LOCALIZED_NAME_OID
//      pwszValueName = Name to be localized, for example, L"ApplicationStore"
//      dwValueType = REG_SZ
//      pbValueData = pointer to the UNICODE localized string
//      cbValueData = (wcslen(UNICODE localized string) + 1) * sizeof(WCHAR)
//
//  To unregister, set pbValueData to NULL and cbValueData to 0.
//
//  The registered names are searched before the pre-installed names.
//--------------------------------------------------------------------------
function CryptFindLocalizedName(
  pwszCryptName: LPCWSTR
  ): LPCWSTR; stdcall;

const
  CRYPT_LOCALIZED_NAME_ENCODING_TYPE = 0;
  CRYPT_LOCALIZED_NAME_OID = 'LocalizedNames';

  //+=========================================================================
  //  Low Level Cryptographic Message Data Structures and APIs
  //==========================================================================

type
  HCRYPTMSG = pointer;

const
  szOID_PKCS_7_DATA               = '1.2.840.113549.1.7.1';
  szOID_PKCS_7_SIGNED             = '1.2.840.113549.1.7.2';
  szOID_PKCS_7_ENVELOPED          = '1.2.840.113549.1.7.3';
  szOID_PKCS_7_SIGNEDANDENVELOPED = '1.2.840.113549.1.7.4';
  szOID_PKCS_7_DIGESTED           = '1.2.840.113549.1.7.5';
  szOID_PKCS_7_ENCRYPTED          = '1.2.840.113549.1.7.6';

  szOID_PKCS_9_CONTENT_TYPE       = '1.2.840.113549.1.9.3';
  szOID_PKCS_9_MESSAGE_DIGEST     = '1.2.840.113549.1.9.4';

  //+-------------------------------------------------------------------------
  //  Message types
  //--------------------------------------------------------------------------
  CMSG_DATA                 = 1;
  CMSG_SIGNED               = 2;
  CMSG_ENVELOPED            = 3;
  CMSG_SIGNED_AND_ENVELOPED = 4;
  CMSG_HASHED               = 5;
  CMSG_ENCRYPTED            = 6;

  //+-------------------------------------------------------------------------
  //  Message Type Bit Flags
  //--------------------------------------------------------------------------
  CMSG_ALL_FLAGS                 = not DWORD(0);
  CMSG_DATA_FLAG                 = 1 shl CMSG_DATA;
  CMSG_SIGNED_FLAG               = 1 shl CMSG_SIGNED;
  CMSG_ENVELOPED_FLAG            = 1 shl CMSG_ENVELOPED;
  CMSG_SIGNED_AND_ENVELOPED_FLAG = 1 shl CMSG_SIGNED_AND_ENVELOPED;
  CMSG_HASHED_FLAG               = 1 shl CMSG_HASHED;
  CMSG_ENCRYPTED_FLAG            = 1 shl CMSG_ENCRYPTED;

  //+-------------------------------------------------------------------------
  //  Certificate Issuer and SerialNumber
  //--------------------------------------------------------------------------
type
  CERT_ISSUER_SERIAL_NUMBER = record
    Issuer:       CERT_NAME_BLOB;
    SerialNumber: CRYPT_INTEGER_BLOB;
  end;
  PCERT_ISSUER_SERIAL_NUMBER = ^CERT_ISSUER_SERIAL_NUMBER;

  //+-------------------------------------------------------------------------
  //  Certificate Identifier
  //--------------------------------------------------------------------------
const
  CERT_ID_ISSUER_SERIAL_NUMBER = 1;
  CERT_ID_KEY_IDENTIFIER       = 2;
  CERT_ID_SHA1_HASH            = 3;
type
  CERT_ID = record
    case dwIdChoice: DWORD of
      CERT_ID_ISSUER_SERIAL_NUMBER:
        (IssuerSerialNumber: CERT_ISSUER_SERIAL_NUMBER);
      CERT_ID_KEY_IDENTIFIER:
        (KeyId: CRYPT_HASH_BLOB);
      CERT_ID_SHA1_HASH:
        (HashId: CRYPT_HASH_BLOB);
  end;
  PCERT_ID = ^CERT_ID;

  //+-------------------------------------------------------------------------
  //  The message encode information (pvMsgEncodeInfo) is message type dependent
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_DATA: pvMsgEncodeInfo = NULL
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_SIGNED
  //
  //  The pCertInfo in the CMSG_SIGNER_ENCODE_INFO provides the Issuer, SerialNumber
  //  and PublicKeyInfo.Algorithm. The PublicKeyInfo.Algorithm implicitly
  //  specifies the HashEncryptionAlgorithm to be used.
  //
  //  If the SignerId is present with a nonzero dwIdChoice its used instead
  //  of the Issuer and SerialNumber in pCertInfo.
  //
  //  CMS supports the KEY_IDENTIFIER and ISSUER_SERIAL_NUMBER CERT_IDs. PKCS #7
  //  version 1.5 only supports the ISSUER_SERIAL_NUMBER CERT_ID choice.
  //
  //  If HashEncryptionAlgorithm is present and not NULL its used instead of
  //  the PublicKeyInfo.Algorithm.
  //
  //  Note, for RSA, the hash encryption algorithm is normally the same as
  //  the public key algorithm. For DSA, the hash encryption algorithm is
  //  normally a DSS signature algorithm.
  //
  //  pvHashEncryptionAuxInfo currently isn't used and must be set to NULL if
  //  present in the data structure.
  //
  //  The hCryptProv and dwKeySpec specify the private key to use. If dwKeySpec
  //  == 0, then, defaults to AT_SIGNATURE.
  //
  //  If the HashEncryptionAlgorithm is set to szOID_PKIX_NO_SIGNATURE, then,
  //  the signature value only contains the hash octets. hCryptProv must still
  //  be specified. However, since a private key isn't used the hCryptProv can be
  //  acquired using CRYPT_VERIFYCONTEXT.
  //
  //  If CMSG_CRYPT_RELEASE_CONTEXT_FLAG is set in the dwFlags
  //  passed to CryptMsgOpenToEncode(), the signer hCryptProv's are released.
  //
  //  pvHashAuxInfo currently isn't used and must be set to NULL.
  //
  //  CMS signed messages allow the inclusion of Attribute Certs.
  //--------------------------------------------------------------------------
type
  CMSG_SIGNER_ENCODE_INFO = record
    cbSize:                  DWORD;
    pCertInfo:               PCERT_INFO;
    hCryptProv:              HCRYPTPROV;
    dwKeySpec:               DWORD;
    HashAlgorithm:           CRYPT_ALGORITHM_IDENTIFIER;
    pvHashAuxInfo:           pointer;
    cAuthAttr:               DWORD;
    rgAuthAttr:              PCRYPT_ATTRIBUTE;
    cUnauthAttr:             DWORD;
    rgUnauthAttr:            PCRYPT_ATTRIBUTE;
    SignerId:                CERT_ID;
    HashEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    pvHashEncryptionAuxInfo: pointer;
  end;
  PCMSG_SIGNER_ENCODE_INFO = ^CMSG_SIGNER_ENCODE_INFO;

  CMSG_SIGNED_ENCODE_INFO = record
    cbSize:            DWORD;
    cSigners:          DWORD;
    rgSigners:         PCMSG_SIGNER_ENCODE_INFO;
    cCertEncoded:      DWORD;
    rgCertEncoded:     PCERT_BLOB;
    cCrlEncoded:       DWORD;
    rgCrlEncoded:      PCRL_BLOB;
    cAttrCertEncoded:  DWORD;
    rgAttrCertEncoded: PCERT_BLOB;
  end;
  PCMSG_SIGNED_ENCODE_INFO = ^CMSG_SIGNED_ENCODE_INFO;

  //+-------------------------------------------------------------------------
  //  CMSG_ENVELOPED
  //
  //  The PCERT_INFO for the rgRecipients provides the Issuer, SerialNumber
  //  and PublicKeyInfo. The PublicKeyInfo.Algorithm implicitly
  //  specifies the KeyEncryptionAlgorithm to be used.
  //
  //  The PublicKeyInfo.PublicKey in PCERT_INFO is used to encrypt the content
  //  encryption key for the recipient.
  //
  //  hCryptProv is used to do the content encryption, recipient key encryption
  //  and export. The hCryptProv's private keys aren't used. If hCryptProv
  //  is NULL, a default hCryptProv is chosen according to the
  //  ContentEncryptionAlgorithm and the first recipient KeyEncryptionAlgorithm.
  //
  //  If CMSG_CRYPT_RELEASE_CONTEXT_FLAG is set in the dwFlags
  //  passed to CryptMsgOpenToEncode(), the envelope's hCryptProv is released.
  //
  //  Note: CAPI currently doesn't support more than one KeyEncryptionAlgorithm
  //  per provider. This will need to be fixed.
  //
  //  Currently, pvEncryptionAuxInfo is only defined for RC2 or RC4 encryption
  //  algorithms. Otherwise, its not used and must be set to NULL.
  //  See CMSG_RC2_AUX_INFO for the RC2 encryption algorithms.
  //  See CMSG_RC4_AUX_INFO for the RC4 encryption algorithms.
  //
  //  To enable SP3 compatible encryption, pvEncryptionAuxInfo should point to
  //  a CMSG_SP3_COMPATIBLE_AUX_INFO data structure.
  //
  //  To enable the CMS envelope enhancements, rgpRecipients must be set to
  //  NULL, and rgCmsRecipients updated to point to an array of
  //  CMSG_RECIPIENT_ENCODE_INFO's.
  //
  //  Also, CMS envelope enhancements support the inclusion of a bag of
  //  Certs, CRLs, Attribute Certs and/or Unprotected Attributes.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  Recipient Encode Info
  //
  //  Note, only key transport recipients are supported in PKCS #7 version 1.5.
  //--------------------------------------------------------------------------
const
  CMSG_KEY_TRANS_RECIPIENT = 1;
  CMSG_KEY_AGREE_RECIPIENT = 2;
  CMSG_MAIL_LIST_RECIPIENT = 3;

  CMSG_KEY_AGREE_EPHEMERAL_KEY_CHOICE = 1;
  CMSG_KEY_AGREE_STATIC_KEY_CHOICE    = 2;

  CMSG_MAIL_LIST_HANDLE_KEY_CHOICE    = 1;

type
  PCMSG_KEY_TRANS_RECIPIENT_ENCODE_INFO = ^CMSG_KEY_TRANS_RECIPIENT_ENCODE_INFO;
  PCMSG_KEY_AGREE_RECIPIENT_ENCODE_INFO = ^CMSG_KEY_AGREE_RECIPIENT_ENCODE_INFO;
  PCMSG_MAIL_LIST_RECIPIENT_ENCODE_INFO = ^CMSG_MAIL_LIST_RECIPIENT_ENCODE_INFO;

  CMSG_RECIPIENT_ENCODE_INFO = record
    case dwRecipientChoice: DWORD of
      CMSG_KEY_TRANS_RECIPIENT:
        (pKeyTrans: PCMSG_KEY_TRANS_RECIPIENT_ENCODE_INFO);
      CMSG_KEY_AGREE_RECIPIENT:
        (pKeyAgree: PCMSG_KEY_AGREE_RECIPIENT_ENCODE_INFO);
      CMSG_MAIL_LIST_RECIPIENT:
        (pMailList: PCMSG_MAIL_LIST_RECIPIENT_ENCODE_INFO);
  end;
  PCMSG_RECIPIENT_ENCODE_INFO = ^CMSG_RECIPIENT_ENCODE_INFO;

  TARR_PCERT_INFO = ^PCERT_INFO; {My type. Oleg}
  CMSG_ENVELOPED_ENCODE_INFO = record
    cbSize:                     DWORD;
    hCryptProv:                 HCRYPTPROV;
    ContentEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    pvEncryptionAuxInfo:        pointer;
    cRecipients:                DWORD;
    // The following array may only be used for transport recipients identified
    // by their IssuereAndSerialNumber. If rgpRecipients != NULL, then,
    // the rgCmsRecipients must be NULL.
    rgpRecipients:              TARR_PCERT_INFO;
    // If rgCmsRecipients != NULL, then, the above rgpRecipients must be
    // NULL.
    rgCmsRecipients:            PCMSG_RECIPIENT_ENCODE_INFO;
    cCertEncoded:               DWORD;
    rgCertEncoded:              PCERT_BLOB;
    cCrlEncoded:                DWORD;
    rgCrlEncoded:               PCRL_BLOB;
    cAttrCertEncoded:           DWORD;
    rgAttrCertEncoded:          PCERT_BLOB;
    cUnprotectedAttr:           DWORD;
    rgUnprotectedAttr:          PCRYPT_ATTRIBUTE;
  end;
  PCMSG_ENVELOPED_ENCODE_INFO = ^CMSG_ENVELOPED_ENCODE_INFO;

  //+-------------------------------------------------------------------------
  //  Key Transport Recipient Encode Info
  //
  //  hCryptProv is used to do the recipient key encryption
  //  and export. The hCryptProv's private keys aren't used.
  //
  //  If hCryptProv is NULL, then, the hCryptProv specified in
  //  CMSG_ENVELOPED_ENCODE_INFO is used.
  //
  //  Note, even if CMSG_CRYPT_RELEASE_CONTEXT_FLAG is set in the dwFlags
  //  passed to CryptMsgOpenToEncode(), this hCryptProv isn't released.
  //
  //  CMS supports the KEY_IDENTIFIER and ISSUER_SERIAL_NUMBER CERT_IDs. PKCS #7
  //  version 1.5 only supports the ISSUER_SERIAL_NUMBER CERT_ID choice.
  //--------------------------------------------------------------------------
  CMSG_KEY_TRANS_RECIPIENT_ENCODE_INFO = record
    cbSize:                 DWORD;
    KeyEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    pvKeyEncryptionAuxInfo: pointer;
    hCryptProv:             HCRYPTPROV;
    RecipientPublicKey:     CRYPT_BIT_BLOB;
    RecipientId:            CERT_ID;
  end;

  //+-------------------------------------------------------------------------
  //  Key Agreement Recipient Encode Info
  //
  //  If hCryptProv is NULL, then, the hCryptProv specified in
  //  CMSG_ENVELOPED_ENCODE_INFO is used.
  //
  //  For the CMSG_KEY_AGREE_STATIC_KEY_CHOICE, both the hCryptProv and
  //  dwKeySpec must be specified to select the sender's private key.
  //
  //  Note, even if CMSG_CRYPT_RELEASE_CONTEXT_FLAG is set in the dwFlags
  //  passed to CryptMsgOpenToEncode(), this hCryptProv isn't released.
  //
  //  CMS supports the KEY_IDENTIFIER and ISSUER_SERIAL_NUMBER CERT_IDs.
  //
  //  There is 1 key choice, ephemeral originator. The originator's ephemeral
  //  key is generated using the public key algorithm parameters shared
  //  amongst all the recipients.
  //
  //  There are 2 key choices: ephemeral originator or static sender. The
  //  originator's ephemeral key is generated using the public key algorithm
  //  parameters shared amongst all the recipients. For the static sender its
  //  private key is used. The hCryptProv and dwKeySpec specify the private key.
  //  The pSenderId identifies the certificate containing the sender's public key.
  //
  //  Currently, pvKeyEncryptionAuxInfo isn't used and must be set to NULL.
  //
  //  If KeyEncryptionAlgorithm.Parameters.cbData == 0, then, its Parameters
  //  are updated with the encoded KeyWrapAlgorithm.
  //
  //  Currently, pvKeyWrapAuxInfo is only defined for algorithms with
  //  RC2. Otherwise, its not used and must be set to NULL.
  //  When set for RC2 algorithms, points to a CMSG_RC2_AUX_INFO containing
  //  the RC2 effective key length.
  //
  //  Note, key agreement recipients are not supported in PKCS #7 version 1.5.
  //--------------------------------------------------------------------------
  CMSG_RECIPIENT_ENCRYPTED_KEY_ENCODE_INFO = record
    cbSize:             DWORD;
    RecipientPublicKey: CRYPT_BIT_BLOB;
    RecipientId:        CERT_ID;
    // Following fields are optional and only applicable to KEY_IDENTIFIER
    // CERT_IDs.
    Date:               FILETIME;
    pOtherAttr:         PCRYPT_ATTRIBUTE_TYPE_VALUE;
  end;
  PCMSG_RECIPIENT_ENCRYPTED_KEY_ENCODE_INFO =
    ^CMSG_RECIPIENT_ENCRYPTED_KEY_ENCODE_INFO;

  TARR_PCMSG_RECIPIENT_ENCRYPTED_KEY_ENCODE_INFO
    = ^PCMSG_RECIPIENT_ENCRYPTED_KEY_ENCODE_INFO; {My type. Oleg}
  CMSG_KEY_AGREE_RECIPIENT_ENCODE_INFO = record
    cbSize:                 DWORD;
    KeyEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    pvKeyEncryptionAuxInfo: pointer;
    KeyWrapAlgorithm:       CRYPT_ALGORITHM_IDENTIFIER;
    pvKeyWrapAuxInfo:       pointer;
    // The following hCryptProv and dwKeySpec must be specified for the
    // CMSG_KEY_AGREE_STATIC_KEY_CHOICE.
    //
    // For CMSG_KEY_AGREE_EPHEMERAL_KEY_CHOICE, dwKeySpec isn't applicable
    // and hCryptProv is optional.
    hCryptProv:             HCRYPTPROV;
    dwKeySpec:              DWORD;
    case dwKeyChoice: DWORD of
      CMSG_KEY_AGREE_EPHEMERAL_KEY_CHOICE:
      // The ephemeral public key algorithm and parameters.
      (pEphemeralAlgorithm:         PCRYPT_ALGORITHM_IDENTIFIER;
        UserKeyingMaterial:         CRYPT_DATA_BLOB; // OPTIONAL
        cRecipientEncryptedKeys:    DWORD;
        rgpRecipientEncryptedKeys:  TARR_PCMSG_RECIPIENT_ENCRYPTED_KEY_ENCODE_INFO);
      CMSG_KEY_AGREE_STATIC_KEY_CHOICE:
      // The CertId of the sender's certificate
      (pSenderId:                   PCERT_ID);
  end;

  //+-------------------------------------------------------------------------
  //  Mail List Recipient Encode Info
  //
  //  There is 1 choice for the KeyEncryptionKey: an already created CSP key
  //  handle. For the key handle choice, hCryptProv must be nonzero. This key
  //  handle isn't destroyed.
  //
  //  Note, even if CMSG_CRYPT_RELEASE_CONTEXT_FLAG is set in the dwFlags
  //  passed to CryptMsgOpenToEncode(), this hCryptProv isn't released.
  //
  //  Currently, pvKeyEncryptionAuxInfo is only defined for RC2 key wrap
  //  algorithms. Otherwise, its not used and must be set to NULL.
  //  When set for RC2 algorithms, points to a CMSG_RC2_AUX_INFO containing
  //  the RC2 effective key length.
  //
  //  Note, mail list recipients are not supported in PKCS #7 version 1.5.
  //--------------------------------------------------------------------------
  CMSG_MAIL_LIST_RECIPIENT_ENCODE_INFO = record
    cbSize:                 DWORD;
    KeyEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    pvKeyEncryptionAuxInfo: pointer;
    hCryptProv:             HCRYPTPROV;
    case dwKeyChoice: DWORD of
      CMSG_MAIL_LIST_HANDLE_KEY_CHOICE:
        (hKeyEncryptionKey: HCRYPTKEY;
        KeyId:              CRYPT_DATA_BLOB;
        // Following fields are optional.
        Date:               FILETIME;
        pOtherAttr:         PCRYPT_ATTRIBUTE_TYPE_VALUE);
  end;

  //+-------------------------------------------------------------------------
  //  CMSG_RC2_AUX_INFO
  //
  //  AuxInfo for RC2 encryption algorithms. The pvEncryptionAuxInfo field
  //  in CMSG_ENCRYPTED_ENCODE_INFO should be updated to point to this
  //  structure. If not specified, defaults to 40 bit.
  //
  //  Note, this AuxInfo is only used when, the ContentEncryptionAlgorithm's
  //  Parameter.cbData is zero. Otherwise, the Parameters is decoded to
  //  get the bit length.
  //
  //  If CMSG_SP3_COMPATIBLE_ENCRYPT_FLAG is set in dwBitLen, then, SP3
  //  compatible encryption is done and the bit length is ignored.
  //--------------------------------------------------------------------------
type
  CMSG_RC2_AUX_INFO = record
    cbSize:   DWORD;
    dwBitLen: DWORD;
  end;
  PCMSG_RC2_AUX_INFO = ^CMSG_RC2_AUX_INFO;

  //+-------------------------------------------------------------------------
  //  CMSG_SP3_COMPATIBLE_AUX_INFO
  //
  //  AuxInfo for enabling SP3 compatible encryption.
  //
  //  The CMSG_SP3_COMPATIBLE_ENCRYPT_FLAG is set in dwFlags to enable SP3
  //  compatible encryption. When set, uses zero salt instead of no salt,
  //  the encryption algorithm parameters are NULL instead of containing the
  //  encoded RC2 parameters or encoded IV octet string and the encrypted
  //  symmetric key is encoded little endian instead of big endian.
  //--------------------------------------------------------------------------
type
  CMSG_SP3_COMPATIBLE_AUX_INFO = record
    cbSize:  DWORD;
    dwFlags: DWORD;
  end;
  PCMSG_SP3_COMPATIBLE_AUX_INFO = ^CMSG_SP3_COMPATIBLE_AUX_INFO;

const
  CMSG_SP3_COMPATIBLE_ENCRYPT_FLAG = $80000000;

  //+-------------------------------------------------------------------------
  //  CMSG_RC4_AUX_INFO
  //
  //  AuxInfo for RC4 encryption algorithms. The pvEncryptionAuxInfo field
  //  in CMSG_ENCRYPTED_ENCODE_INFO should be updated to point to this
  //  structure. If not specified, uses the CSP's default bit length with no
  //  salt. Note, the base CSP has a 40 bit default and the enhanced CSP has
  //  a 128 bit default.
  //
  //  If CMSG_RC4_NO_SALT_FLAG is set in dwBitLen, then, no salt is generated.
  //  Otherwise, (128 - dwBitLen)/8 bytes of salt are generated and encoded
  //  as an OCTET STRING in the algorithm parameters field.
  //--------------------------------------------------------------------------
type
  CMSG_RC4_AUX_INFO = record
    cbSize:   DWORD;
    dwBitLen: DWORD;
  end;
  PCMSG_RC4_AUX_INFO = ^CMSG_RC4_AUX_INFO;

const
  CMSG_RC4_NO_SALT_FLAG = $40000000;

  //+-------------------------------------------------------------------------
  //  CMSG_SIGNED_AND_ENVELOPED
  //
  //  For PKCS #7, a signed and enveloped message doesn't have the
  //  signer's authenticated or unauthenticated attributes. Otherwise, a
  //  combination of the CMSG_SIGNED_ENCODE_INFO and CMSG_ENVELOPED_ENCODE_INFO.
  //--------------------------------------------------------------------------
type
  CMSG_SIGNED_AND_ENVELOPED_ENCODE_INFO = record
    cbSize:        DWORD;
    SignedInfo:    CMSG_SIGNED_ENCODE_INFO;
    EnvelopedInfo: CMSG_ENVELOPED_ENCODE_INFO;
  end;
  PCMSG_SIGNED_AND_ENVELOPED_ENCODE_INFO =
    ^CMSG_SIGNED_AND_ENVELOPED_ENCODE_INFO;

  //+-------------------------------------------------------------------------
  //  CMSG_HASHED
  //
  //  hCryptProv is used to do the hash. Doesn't need to use a private key.
  //
  //  If CMSG_CRYPT_RELEASE_CONTEXT_FLAG is set in the dwFlags
  //  passed to CryptMsgOpenToEncode(), the hCryptProv is released.
  //
  //  If fDetachedHash is set, then, the encoded message doesn't contain
  //  any content (its treated as NULL Data)
  //
  //  pvHashAuxInfo currently isn't used and must be set to NULL.
  //--------------------------------------------------------------------------
type
  CMSG_HASHED_ENCODE_INFO = record
    cbSize:        DWORD;
    hCryptProv:    HCRYPTPROV;
    HashAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    pvHashAuxInfo: pointer;
  end;
  PCMSG_HASHED_ENCODE_INFO = ^CMSG_HASHED_ENCODE_INFO;

  //+-------------------------------------------------------------------------
  //  CMSG_ENCRYPTED
  //
  //  The key used to encrypt the message is identified outside of the message
  //  content (for example, password).
  //
  //  The content input to CryptMsgUpdate has already been encrypted.
  //
  //  pvEncryptionAuxInfo currently isn't used and must be set to NULL.
  //--------------------------------------------------------------------------
type
  CMSG_ENCRYPTED_ENCODE_INFO = record
    cbSize:                     DWORD;
    ContentEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    pvEncryptionAuxInfo:        pointer;
  end;
  PCMSG_ENCRYPTED_ENCODE_INFO = ^CMSG_ENCRYPTED_ENCODE_INFO;

  //+-------------------------------------------------------------------------
  //  This parameter allows messages to be of variable length with streamed
  //  output.
  //
  //  By default, messages are of a definite length and
  //  CryptMsgGetParam(CMSG_CONTENT_PARAM) is
  //  called to get the cryptographically processed content. Until closed,
  //  the handle keeps a copy of the processed content.
  //
  //  With streamed output, the processed content can be freed as its streamed.
  //
  //  If the length of the content to be updated is known at the time of the
  //  open, then, ContentLength should be set to that length. Otherwise, it
  //  should be set to CMSG_INDEFINITE_LENGTH.
  //--------------------------------------------------------------------------
  PFN_CMSG_STREAM_OUTPUT = function(
    pvArg: pointer;
    pbData: PBYTE;
    cbData: DWORD;
    fFinal: BOOL
    ): BOOL; stdcall;

const
  CMSG_INDEFINITE_LENGTH = $FFFFFFFF;

type
  CMSG_STREAM_INFO = record
    cbContent:       DWORD;
    pfnStreamOutput: PFN_CMSG_STREAM_OUTPUT;
    pvArg:           pointer;
  end;
  PCMSG_STREAM_INFO = ^CMSG_STREAM_INFO;

  //+-------------------------------------------------------------------------
  //  Open dwFlags
  //--------------------------------------------------------------------------
const
  CMSG_BARE_CONTENT_FLAG             = $00000001;
  CMSG_LENGTH_ONLY_FLAG              = $00000002;
  CMSG_DETACHED_FLAG                 = $00000004;
  CMSG_AUTHENTICATED_ATTRIBUTES_FLAG = $00000008;
  CMSG_CONTENTS_OCTETS_FLAG          = $00000010;
  CMSG_MAX_LENGTH_FLAG               = $00000020;

  // When set, nonData type inner content is encapsulated within an
  // OCTET STRING. Applicable to both Signed and Enveloped messages.
  CMSG_CMS_ENCAPSULATED_CONTENT_FLAG = $00000040;

  // If set, then, the hCryptProv passed to CryptMsgOpenToEncode or
  // CryptMsgOpenToDecode is released on the final CryptMsgClose.
  // Not released if CryptMsgOpenToEncode or CryptMsgOpenToDecode fails.
  //
  // Note, the envelope recipient hCryptProv's aren't released.
  CMSG_CRYPT_RELEASE_CONTEXT_FLAG    = $00008000;

  //+-------------------------------------------------------------------------
  //  Open a cryptographic message for encoding
  //
  //  If CMSG_BARE_CONTENT_FLAG is specified for a streamed message,
  //  the streamed output will not have an outer ContentInfo wrapper. This
  //  makes it suitable to be streamed into an enclosing message.
  //
  //  The pStreamInfo parameter needs to be set to stream the encoded message
  //  output.
  //--------------------------------------------------------------------------
function CryptMsgOpenToEncode(
  dwMsgEncodingType: DWORD;
  dwFlags: DWORD;
  dwMsgType: DWORD;
  pvMsgEncodeInfo: pointer;
  pszInnerContentObjID: LPSTR;
  pStreamInfo: PCMSG_STREAM_INFO
  ): HCRYPTMSG; stdcall;

//+-------------------------------------------------------------------------
//  Calculate the length of an encoded cryptographic message.
//
//  Calculates the length of the encoded message given the
//  message type, encoding parameters and total length of
//  the data to be updated. Note, this might not be the exact length. However,
//  it will always be greater than or equal to the actual length.
//--------------------------------------------------------------------------
function CryptMsgCalculateEncodedLength(
  dwMsgEncodingType: DWORD;
  dwFlags: DWORD;
  dwMsgType: DWORD;
  pvMsgEncodeInfo: pointer;
  pszInnerContentObjID: LPSTR;
  cbData: DWORD
  ): DWORD; stdcall;

//+-------------------------------------------------------------------------
//  Open a cryptographic message for decoding
//
//  hCryptProv specifies the crypto provider to use for hashing and/or
//  decrypting the message. If hCryptProv is NULL, a default crypt provider
//  is used.
//
//  Currently pRecipientInfo isn't used and should be set to NULL.
//
//  The pStreamInfo parameter needs to be set to stream the decoded content
//  output.
//--------------------------------------------------------------------------
function CryptMsgOpenToDecode(
  dwMsgEncodingType: DWORD;
  dwFlags: DWORD;
  dwMsgType: DWORD;
  hCryptProv: HCRYPTPROV;
  pRecipientInfo: PCERT_INFO;
  pStreamInfo: PCMSG_STREAM_INFO
  ): HCRYPTMSG; stdcall;

//+-------------------------------------------------------------------------
//  Duplicate a cryptographic message handle
//--------------------------------------------------------------------------
function CryptMsgDuplicate(
  hCryptMsg: HCRYPTMSG
  ): HCRYPTMSG; stdcall;

//+-------------------------------------------------------------------------
//  Close a cryptographic message handle
//
//  LastError is preserved unless FALSE is returned.
//--------------------------------------------------------------------------
function CryptMsgClose(
  hCryptMsg: HCRYPTMSG
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Update the content of a cryptographic message. Depending on how the
//  message was opened, the content is either encoded or decoded.
//
//  This function is repetitively called to append to the message content.
//  fFinal is set to identify the last update. On fFinal, the encode/decode
//  is completed. The encoded/decoded content and the decoded parameters
//  are valid until the open and all duplicated handles are closed.
//--------------------------------------------------------------------------
function CryptMsgUpdate(
  hCryptMsg: HCRYPTMSG;
  pbData: PBYTE;
  cbData: DWORD;
  fFinal: BOOL
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Get a parameter after encoding/decoding a cryptographic message. Called
//  after the final CryptMsgUpdate. Only the CMSG_CONTENT_PARAM and
//  CMSG_COMPUTED_HASH_PARAM are valid for an encoded message.
//
//  For an encoded HASHED message, the CMSG_COMPUTED_HASH_PARAM can be got
//  before any CryptMsgUpdates to get its length.
//
//  The pvData type definition depends on the dwParamType value.
//
//  Elements pointed to by fields in the pvData structure follow the
//  structure. Therefore, *pcbData may exceed the size of the structure.
//
//  Upon input, if *pcbData == 0, then, *pcbData is updated with the length
//  of the data and the pvData parameter is ignored.
//
//  Upon return, *pcbData is updated with the length of the data.
//
//  The OBJID BLOBs returned in the pvData structures point to
//  their still encoded representation. The appropriate functions
//  must be called to decode the information.
//
//  See below for a list of the parameters to get.
//--------------------------------------------------------------------------
function CryptMsgGetParam(
  hCryptMsg: HCRYPTMSG;
  dwParamType: DWORD;
  dwIndex: DWORD;
  pvData: pointer;
  var pcbData: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Get parameter types and their corresponding data structure definitions.
//--------------------------------------------------------------------------
const
  CMSG_TYPE_PARAM                              = 1;
  CMSG_CONTENT_PARAM                           = 2;
  CMSG_BARE_CONTENT_PARAM                      = 3;
  CMSG_INNER_CONTENT_TYPE_PARAM                = 4;
  CMSG_SIGNER_COUNT_PARAM                      = 5;
  CMSG_SIGNER_INFO_PARAM                       = 6;
  CMSG_SIGNER_CERT_INFO_PARAM                  = 7;
  CMSG_SIGNER_HASH_ALGORITHM_PARAM             = 8;
  CMSG_SIGNER_AUTH_ATTR_PARAM                  = 9;
  CMSG_SIGNER_UNAUTH_ATTR_PARAM                = 10;
  CMSG_CERT_COUNT_PARAM                        = 11;
  CMSG_CERT_PARAM                              = 12;
  CMSG_CRL_COUNT_PARAM                         = 13;
  CMSG_CRL_PARAM                               = 14;
  CMSG_ENVELOPE_ALGORITHM_PARAM                = 15;
  CMSG_RECIPIENT_COUNT_PARAM                   = 17;
  CMSG_RECIPIENT_INDEX_PARAM                   = 18;
  CMSG_RECIPIENT_INFO_PARAM                    = 19;
  CMSG_HASH_ALGORITHM_PARAM                    = 20;
  CMSG_HASH_DATA_PARAM                         = 21;
  CMSG_COMPUTED_HASH_PARAM                     = 22;
  CMSG_ENCRYPT_PARAM                           = 26;
  CMSG_ENCRYPTED_DIGEST                        = 27;
  CMSG_ENCODED_SIGNER                          = 28;
  CMSG_ENCODED_MESSAGE                         = 29;
  CMSG_VERSION_PARAM                           = 30;
  CMSG_ATTR_CERT_COUNT_PARAM                   = 31;
  CMSG_ATTR_CERT_PARAM                         = 32;
  CMSG_CMS_RECIPIENT_COUNT_PARAM               = 33;
  CMSG_CMS_RECIPIENT_INDEX_PARAM               = 34;
  CMSG_CMS_RECIPIENT_ENCRYPTED_KEY_INDEX_PARAM = 35;
  CMSG_CMS_RECIPIENT_INFO_PARAM                = 36;
  CMSG_UNPROTECTED_ATTR_PARAM                  = 37;
  CMSG_SIGNER_CERT_ID_PARAM                    = 38;
  CMSG_CMS_SIGNER_INFO_PARAM                   = 39;

  //+-------------------------------------------------------------------------
  //  CMSG_TYPE_PARAM
  //
  //  The type of the decoded message.
  //
  //  pvData points to a DWORD
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CONTENT_PARAM
  //
  //  The encoded content of a cryptographic message. Depending on how the
  //  message was opened, the content is either the whole PKCS#7
  //  message (opened to encode) or the inner content (opened to decode).
  //  In the decode case, the decrypted content is returned, if enveloped.
  //  If not enveloped, and if the inner content is of type DATA, the returned
  //  data is the contents octets of the inner content.
  //
  //  pvData points to the buffer receiving the content bytes
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_BARE_CONTENT_PARAM
  //
  //  The encoded content of an encoded cryptographic message, without the
  //  outer layer of ContentInfo. That is, only the encoding of the
  //  ContentInfo.content field is returned.
  //
  //  pvData points to the buffer receiving the content bytes
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_INNER_CONTENT_TYPE_PARAM
  //
  //  The type of the inner content of a decoded cryptographic message,
  //  in the form of a NULL-terminated object identifier string
  //  (eg. "1.2.840.113549.1.7.1").
  //
  //  pvData points to the buffer receiving the object identifier string
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_SIGNER_COUNT_PARAM
  //
  //  Count of signers in a SIGNED or SIGNED_AND_ENVELOPED message
  //
  //  pvData points to a DWORD
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_SIGNER_CERT_INFO_PARAM
  //
  //  To get all the signers, repetitively call CryptMsgGetParam, with
  //  dwIndex set to 0 .. SignerCount - 1.
  //
  //  pvData points to a CERT_INFO struct.
  //
  //  Only the following fields have been updated in the CERT_INFO struct:
  //  Issuer and SerialNumber.
  //
  //  Note, if the KEYID choice was selected for a CMS SignerId, then, the
  //  SerialNumber is 0 and the Issuer is encoded containing a single RDN with a
  //  single Attribute whose OID is szOID_KEYID_RDN, value type is
  //  CERT_RDN_OCTET_STRING and value is the KEYID. When the
  //  CertGetSubjectCertificateFromStore and
  //  CertFindCertificateInStore(CERT_FIND_SUBJECT_CERT) APIs see this
  //  special KEYID Issuer and SerialNumber, they do a KEYID match.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_SIGNER_INFO_PARAM
  //
  //  To get all the signers, repetitively call CryptMsgGetParam, with
  //  dwIndex set to 0 .. SignerCount - 1.
  //
  //  pvData points to a CMSG_SIGNER_INFO struct.
  //
  //  Note, if the KEYID choice was selected for a CMS SignerId, then, the
  //  SerialNumber is 0 and the Issuer is encoded containing a single RDN with a
  //  single Attribute whose OID is szOID_KEYID_RDN, value type is
  //  CERT_RDN_OCTET_STRING and value is the KEYID. When the
  //  CertGetSubjectCertificateFromStore and
  //  CertFindCertificateInStore(CERT_FIND_SUBJECT_CERT) APIs see this
  //  special KEYID Issuer and SerialNumber, they do a KEYID match.
  //--------------------------------------------------------------------------
type
  CMSG_SIGNER_INFO = record
    dwVersion:               DWORD;
    Issuer:                  CERT_NAME_BLOB;
    SerialNumber:            CRYPT_INTEGER_BLOB;
    HashAlgorithm:           CRYPT_ALGORITHM_IDENTIFIER;
    HashEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    EncryptedHash:           CRYPT_DATA_BLOB;
    AuthAttrs:               CRYPT_ATTRIBUTES;
    UnauthAttrs:             CRYPT_ATTRIBUTES;
  end;
  PCMSG_SIGNER_INFO = ^CMSG_SIGNER_INFO;

  //+-------------------------------------------------------------------------
  //  CMSG_SIGNER_CERT_ID_PARAM
  //
  //  To get all the signers, repetitively call CryptMsgGetParam, with
  //  dwIndex set to 0 .. SignerCount - 1.
  //
  //  pvData points to a CERT_ID struct.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CMS_SIGNER_INFO_PARAM
  //
  //  Same as CMSG_SIGNER_INFO_PARAM, except, contains SignerId instead of
  //  Issuer and SerialNumber.
  //
  //  To get all the signers, repetitively call CryptMsgGetParam, with
  //  dwIndex set to 0 .. SignerCount - 1.
  //
  //  pvData points to a CMSG_CMS_SIGNER_INFO struct.
  //--------------------------------------------------------------------------
type
  CMSG_CMS_SIGNER_INFO = record
    dwVersion:               DWORD;
    SignerId:                CERT_ID;
    HashAlgorithm:           CRYPT_ALGORITHM_IDENTIFIER;
    HashEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    EncryptedHash:           CRYPT_DATA_BLOB;
    AuthAttrs:               CRYPT_ATTRIBUTES;
    UnauthAttrs:             CRYPT_ATTRIBUTES;
  end;
  PCMSG_CMS_SIGNER_INFO = ^CMSG_CMS_SIGNER_INFO;

  //+-------------------------------------------------------------------------
  //  CMSG_SIGNER_HASH_ALGORITHM_PARAM
  //
  //  This parameter specifies the HashAlgorithm that was used for the signer.
  //
  //  Set dwIndex to iterate through all the signers.
  //
  //  pvData points to an CRYPT_ALGORITHM_IDENTIFIER struct.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_SIGNER_AUTH_ATTR_PARAM
  //
  //  The authenticated attributes for the signer.
  //
  //  Set dwIndex to iterate through all the signers.
  //
  //  pvData points to a CMSG_ATTR struct.
  //--------------------------------------------------------------------------
type
  CMSG_ATTR  = CRYPT_ATTRIBUTES;
  PCMSG_ATTR = ^CRYPT_ATTRIBUTES;

  //+-------------------------------------------------------------------------
  //  CMSG_SIGNER_UNAUTH_ATTR_PARAM
  //
  //  The unauthenticated attributes for the signer.
  //
  //  Set dwIndex to iterate through all the signers.
  //
  //  pvData points to a CMSG_ATTR struct.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CERT_COUNT_PARAM
  //
  //  Count of certificates in a SIGNED or SIGNED_AND_ENVELOPED message.
  //
  //  CMS, also supports certificates in an ENVELOPED message.
  //
  //  pvData points to a DWORD
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CERT_PARAM
  //
  //  To get all the certificates, repetitively call CryptMsgGetParam, with
  //  dwIndex set to 0 .. CertCount - 1.
  //
  //  pvData points to an array of the certificate's encoded bytes.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CRL_COUNT_PARAM
  //
  //  Count of CRLs in a SIGNED or SIGNED_AND_ENVELOPED message.
  //
  //  CMS, also supports CRLs in an ENVELOPED message.
  //
  //  pvData points to a DWORD
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CRL_PARAM
  //
  //  To get all the CRLs, repetitively call CryptMsgGetParam, with
  //  dwIndex set to 0 .. CrlCount - 1.
  //
  //  pvData points to an array of the CRL's encoded bytes.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_ENVELOPE_ALGORITHM_PARAM
  //
  //  The ContentEncryptionAlgorithm that was used in
  //  an ENVELOPED or SIGNED_AND_ENVELOPED message.
  //
  //  For streaming you must be able to successfully get this parameter before
  //  doing a CryptMsgControl decrypt.
  //
  //  pvData points to an CRYPT_ALGORITHM_IDENTIFIER struct.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_RECIPIENT_COUNT_PARAM
  //
  //  Count of recipients in an ENVELOPED or SIGNED_AND_ENVELOPED message.
  //
  //  Count of key transport recepients.
  //
  //  The CMSG_CMS_RECIPIENT_COUNT_PARAM has the total count of
  //  recipients (it also includes key agree and mail list recipients).
  //
  //  pvData points to a DWORD
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_RECIPIENT_INDEX_PARAM
  //
  //  Index of the recipient used to decrypt an ENVELOPED or SIGNED_AND_ENVELOPED
  //  message.
  //
  //  Index of a key transport recipient. If a non key transport
  //  recipient was used to decrypt, fails with LastError set to
  //  CRYPT_E_INVALID_INDEX.
  //
  //  pvData points to a DWORD
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_RECIPIENT_INFO_PARAM
  //
  //  To get all the recipients, repetitively call CryptMsgGetParam, with
  //  dwIndex set to 0 .. RecipientCount - 1.
  //
  //  Only returns the key transport recepients.
  //
  //  The CMSG_CMS_RECIPIENT_INFO_PARAM returns all recipients.
  //
  //  pvData points to a CERT_INFO struct.
  //
  //  Only the following fields have been updated in the CERT_INFO struct:
  //  Issuer, SerialNumber and PublicKeyAlgorithm. The PublicKeyAlgorithm
  //  specifies the KeyEncryptionAlgorithm that was used.
  //
  //  Note, if the KEYID choice was selected for a key transport recipient, then,
  //  the SerialNumber is 0 and the Issuer is encoded containing a single RDN
  //  with a single Attribute whose OID is szOID_KEYID_RDN, value type is
  //  CERT_RDN_OCTET_STRING and value is the KEYID. When the
  //  CertGetSubjectCertificateFromStore and
  //  CertFindCertificateInStore(CERT_FIND_SUBJECT_CERT) APIs see this
  //  special KEYID Issuer and SerialNumber, they do a KEYID match.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_HASH_ALGORITHM_PARAM
  //
  //  The HashAlgorithm in a HASHED message.
  //
  //  pvData points to an CRYPT_ALGORITHM_IDENTIFIER struct.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_HASH_DATA_PARAM
  //
  //  The hash in a HASHED message.
  //
  //  pvData points to an array of bytes.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_COMPUTED_HASH_PARAM
  //
  //  The computed hash for a HASHED message.
  //  This may be called for either an encoded or decoded message.
  //
  //  Also, the computed hash for one of the signer's in a SIGNED message.
  //  It may be called for either an encoded or decoded message after the
  //  final update.  Set dwIndex to iterate through all the signers.
  //
  //  pvData points to an array of bytes.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_ENCRYPT_PARAM
  //
  //  The ContentEncryptionAlgorithm that was used in an ENCRYPTED message.
  //
  //  pvData points to an CRYPT_ALGORITHM_IDENTIFIER struct.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_ENCODED_MESSAGE
  //
  //  The full encoded message. This is useful in the case of a decoded
  //  message which has been modified (eg. a signed-data or
  //  signed-and-enveloped-data message which has been countersigned).
  //
  //  pvData points to an array of the message's encoded bytes.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_VERSION_PARAM
  //
  //  The version of the decoded message.
  //
  //  pvData points to a DWORD
  //--------------------------------------------------------------------------
const
  CMSG_SIGNED_DATA_V1                  = 1;
  CMSG_SIGNED_DATA_V3                  = 3;
  CMSG_SIGNED_DATA_PKCS_1_5_VERSION    = CMSG_SIGNED_DATA_V1;
  CMSG_SIGNED_DATA_CMS_VERSION         = CMSG_SIGNED_DATA_V3;

  CMSG_SIGNER_INFO_V1                  = 1;
  CMSG_SIGNER_INFO_V3                  = 3;
  CMSG_SIGNER_INFO_PKCS_1_5_VERSION    = CMSG_SIGNER_INFO_V1;
  CMSG_SIGNER_INFO_CMS_VERSION         = CMSG_SIGNER_INFO_V3;

  CMSG_HASHED_DATA_V0                  = 0;
  CMSG_HASHED_DATA_V2                  = 2;
  CMSG_HASHED_DATA_PKCS_1_5_VERSION    = CMSG_HASHED_DATA_V0;
  CMSG_HASHED_DATA_CMS_VERSION         = CMSG_HASHED_DATA_V2;

  CMSG_ENVELOPED_DATA_V0               = 0;
  CMSG_ENVELOPED_DATA_V2               = 2;
  CMSG_ENVELOPED_DATA_PKCS_1_5_VERSION = CMSG_ENVELOPED_DATA_V0;
  CMSG_ENVELOPED_DATA_CMS_VERSION      = CMSG_ENVELOPED_DATA_V2;

  //+-------------------------------------------------------------------------
  //  CMSG_ATTR_CERT_COUNT_PARAM
  //
  //  Count of attribute certificates in a SIGNED or ENVELOPED message.
  //
  //  pvData points to a DWORD
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_ATTR_CERT_PARAM
  //
  //  To get all the attribute certificates, repetitively call CryptMsgGetParam,
  //  with dwIndex set to 0 .. AttrCertCount - 1.
  //
  //  pvData points to an array of the attribute certificate's encoded bytes.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CMS_RECIPIENT_COUNT_PARAM
  //
  //  Count of all CMS recipients in an ENVELOPED message.
  //
  //  pvData points to a DWORD
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CMS_RECIPIENT_INDEX_PARAM
  //
  //  Index of the CMS recipient used to decrypt an ENVELOPED message.
  //
  //  pvData points to a DWORD
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CMS_RECIPIENT_ENCRYPTED_KEY_INDEX_PARAM
  //
  //  For a CMS key agreement recipient, the index of the encrypted key
  //  used to decrypt an ENVELOPED message.
  //
  //  pvData points to a DWORD
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CMS_RECIPIENT_INFO_PARAM
  //
  //  To get all the CMS recipients, repetitively call CryptMsgGetParam, with
  //  dwIndex set to 0 .. CmsRecipientCount - 1.
  //
  //  pvData points to a CMSG_CMS_RECIPIENT_INFO struct.
  //--------------------------------------------------------------------------

type
  CMSG_KEY_TRANS_RECIPIENT_INFO = record
    dwVersion:              DWORD;
    // Currently, only ISSUER_SERIAL_NUMBER or KEYID choices
    RecipientId:            CERT_ID;
    KeyEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    EncryptedKey:           CRYPT_DATA_BLOB;
  end;
  PCMSG_KEY_TRANS_RECIPIENT_INFO = ^CMSG_KEY_TRANS_RECIPIENT_INFO;

  CMSG_RECIPIENT_ENCRYPTED_KEY_INFO = record
    // Currently, only ISSUER_SERIAL_NUMBER or KEYID choices
    RecipientId:  CERT_ID;
    EncryptedKey: CRYPT_DATA_BLOB;
    // The following optional fields are only applicable to KEYID choice
    Date:         FILETIME;
    pOtherAttr:   PCRYPT_ATTRIBUTE_TYPE_VALUE;
  end;
  PCMSG_RECIPIENT_ENCRYPTED_KEY_INFO = ^CMSG_RECIPIENT_ENCRYPTED_KEY_INFO;

const
  CMSG_KEY_AGREE_ORIGINATOR_CERT       = 1;
  CMSG_KEY_AGREE_ORIGINATOR_PUBLIC_KEY = 2;
type
  TARR_PCMSG_RECIPIENT_ENCRYPTED_KEY_INFO = ^PCMSG_RECIPIENT_ENCRYPTED_KEY_INFO;
  CMSG_KEY_AGREE_RECIPIENT_INFO = record
    dwVersion: DWORD;
    case dwOriginatorChoice: DWORD of
      CMSG_KEY_AGREE_ORIGINATOR_CERT:
        (OriginatorCertId:          CERT_ID;
        UserKeyingMaterial:         CRYPT_DATA_BLOB;
        KeyEncryptionAlgorithm:     CRYPT_ALGORITHM_IDENTIFIER;
        cRecipientEncryptedKeys:    DWORD;
        rgpRecipientEncryptedKeys:  TARR_PCMSG_RECIPIENT_ENCRYPTED_KEY_INFO);
      CMSG_KEY_AGREE_ORIGINATOR_PUBLIC_KEY:
        (OriginatorPublicKeyInfo:   CERT_PUBLIC_KEY_INFO);
  end;
  PCMSG_KEY_AGREE_RECIPIENT_INFO = ^CMSG_KEY_AGREE_RECIPIENT_INFO;

  CMSG_MAIL_LIST_RECIPIENT_INFO = record
    dwVersion:              DWORD;
    KeyId:                  CRYPT_DATA_BLOB;
    KeyEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    EncryptedKey:           CRYPT_DATA_BLOB;
    // The following fields are optional
    Date:                   FILETIME;
    pOtherAttr:             PCRYPT_ATTRIBUTE_TYPE_VALUE;
  end;
  PCMSG_MAIL_LIST_RECIPIENT_INFO = ^CMSG_MAIL_LIST_RECIPIENT_INFO;

  CMSG_CMS_RECIPIENT_INFO = record
    case dwRecipientChoice: DWORD of
      CMSG_KEY_TRANS_RECIPIENT:
        (pKeyTrans: PCMSG_KEY_TRANS_RECIPIENT_INFO);
      CMSG_KEY_AGREE_RECIPIENT:
        (pKeyAgree: PCMSG_KEY_AGREE_RECIPIENT_INFO);
      CMSG_MAIL_LIST_RECIPIENT:
        (pMailList: PCMSG_MAIL_LIST_RECIPIENT_INFO);
  end;
  PCMSG_CMS_RECIPIENT_INFO = ^CMSG_CMS_RECIPIENT_INFO;

  // dwVersion numbers for the KeyTrans, KeyAgree and MailList recipients
const
  CMSG_ENVELOPED_RECIPIENT_V0     = 0;
  CMSG_ENVELOPED_RECIPIENT_V2     = 2;
  CMSG_ENVELOPED_RECIPIENT_V3     = 3;
  CMSG_ENVELOPED_RECIPIENT_V4     = 4;
  CMSG_KEY_TRANS_PKCS_1_5_VERSION = CMSG_ENVELOPED_RECIPIENT_V0;
  CMSG_KEY_TRANS_CMS_VERSION      = CMSG_ENVELOPED_RECIPIENT_V2;
  CMSG_KEY_AGREE_VERSION          = CMSG_ENVELOPED_RECIPIENT_V3;
  CMSG_MAIL_LIST_VERSION          = CMSG_ENVELOPED_RECIPIENT_V4;

  //+-------------------------------------------------------------------------
  //  CMSG_UNPROTECTED_ATTR_PARAM
  //
  //  The unprotected attributes in the envelped message.
  //
  //  pvData points to a CMSG_ATTR struct.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  Perform a special "control" function after the final CryptMsgUpdate of a
  //  encoded/decoded cryptographic message.
  //
  //  The dwCtrlType parameter specifies the type of operation to be performed.
  //
  //  The pvCtrlPara definition depends on the dwCtrlType value.
  //
  //  See below for a list of the control operations and their pvCtrlPara
  //  type definition.
  //--------------------------------------------------------------------------
function CryptMsgControl(
  hCryptMsg: HCRYPTMSG;
  dwFlags: DWORD;
  dwCtrlType: DWORD;
  pvCtrlPara: pointer
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Message control types
//--------------------------------------------------------------------------
const
  CMSG_CTRL_VERIFY_SIGNATURE       = 1;
  CMSG_CTRL_DECRYPT                = 2;
  CMSG_CTRL_VERIFY_HASH            = 5;
  CMSG_CTRL_ADD_SIGNER             = 6;
  CMSG_CTRL_DEL_SIGNER             = 7;
  CMSG_CTRL_ADD_SIGNER_UNAUTH_ATTR = 8;
  CMSG_CTRL_DEL_SIGNER_UNAUTH_ATTR = 9;
  CMSG_CTRL_ADD_CERT               = 10;
  CMSG_CTRL_DEL_CERT               = 11;
  CMSG_CTRL_ADD_CRL                = 12;
  CMSG_CTRL_DEL_CRL                = 13;
  CMSG_CTRL_ADD_ATTR_CERT          = 14;
  CMSG_CTRL_DEL_ATTR_CERT          = 15;
  CMSG_CTRL_KEY_TRANS_DECRYPT      = 16;
  CMSG_CTRL_KEY_AGREE_DECRYPT      = 17;
  CMSG_CTRL_MAIL_LIST_DECRYPT      = 18;
  CMSG_CTRL_VERIFY_SIGNATURE_EX    = 19;
  CMSG_CTRL_ADD_CMS_SIGNER_INFO    = 20;

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_VERIFY_SIGNATURE
  //
  //  Verify the signature of a SIGNED or SIGNED_AND_ENVELOPED
  //  message after it has been decoded.
  //
  //  For a SIGNED_AND_ENVELOPED message, called after
  //  CryptMsgControl(CMSG_CTRL_DECRYPT), if CryptMsgOpenToDecode was called
  //  with a NULL pRecipientInfo.
  //
  //  pvCtrlPara points to a CERT_INFO struct.
  //
  //  The CERT_INFO contains the Issuer and SerialNumber identifying
  //  the Signer of the message. The CERT_INFO also contains the
  //  PublicKeyInfo
  //  used to verify the signature. The cryptographic provider specified
  //  in CryptMsgOpenToDecode is used.
  //
  //  Note, if the message contains CMS signers identified by KEYID, then,
  //  the CERT_INFO's Issuer and SerialNumber is ignored and only the public
  //  key is used to find a signer whose signature verifies.
  //
  //  The following CMSG_CTRL_VERIFY_SIGNATURE_EX should be used instead.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_VERIFY_SIGNATURE_EX
  //
  //  Verify the signature of a SIGNED message after it has been decoded.
  //
  //  pvCtrlPara points to the following CMSG_CTRL_VERIFY_SIGNATURE_EX_PARA.
  //
  //  If hCryptProv is NULL, uses the cryptographic provider specified in
  //  CryptMsgOpenToDecode. If CryptMsgOpenToDecode's hCryptProv is also NULL,
  //  gets default provider according to the signer's public key OID.
  //
  //  dwSignerIndex is the index of the signer to use to verify the signature.
  //
  //  The signer can be a pointer to a CERT_PUBLIC_KEY_INFO, certificate
  //  context or a chain context.
  //
  //  If the signer's HashEncryptionAlgorithm is szOID_PKIX_NO_SIGNATURE, then,
  //  the signature is expected to contain the hash octets. Only dwSignerType
  //  of CMSG_VERIFY_SIGNER_NULL may be specified to verify this no signature
  //  case.
  //--------------------------------------------------------------------------
type
  CMSG_CTRL_VERIFY_SIGNATURE_EX_PARA = record
    cbSize:        DWORD;
    hCryptProv:    HCRYPTPROV;
    dwSignerIndex: DWORD;
    dwSignerType:  DWORD;
    pvSigner:      pointer;
  end;
  PCMSG_CTRL_VERIFY_SIGNATURE_EX_PARA = ^CMSG_CTRL_VERIFY_SIGNATURE_EX_PARA;

  // Signer Types
const
  CMSG_VERIFY_SIGNER_PUBKEY = 1;
  // pvSigner :: PCERT_PUBLIC_KEY_INFO
  CMSG_VERIFY_SIGNER_CERT   = 2;
  // pvSigner :: PCCERT_CONTEXT
  CMSG_VERIFY_SIGNER_CHAIN  = 3;
  // pvSigner :: PCCERT_CHAIN_CONTEXT
  CMSG_VERIFY_SIGNER_NULL   = 4;
  // pvSigner :: NULL

//+-------------------------------------------------------------------------
//  CMSG_CTRL_DECRYPT
//
//  Decrypt an ENVELOPED or SIGNED_AND_ENVELOPED message after it has been
//  decoded.
//
//  This decrypt is only applicable to key transport recipients.
//
//  hCryptProv and dwKeySpec specify the private key to use. For dwKeySpec ==
//  0, defaults to AT_KEYEXCHANGE.
//
//  If CMSG_CRYPT_RELEASE_CONTEXT_FLAG is set in the dwFlags passed
//  to CryptMsgControl, then, the hCryptProv is released on the final
//  CryptMsgClose. Not released if CryptMsgControl fails.
//
//  dwRecipientIndex is the index of the recipient in the message associated
//  with the hCryptProv's private key.
//
//  The dwRecipientIndex is the index of a key transport recipient.
//
//  Note, the message can only be decrypted once.
//--------------------------------------------------------------------------
type
  CMSG_CTRL_DECRYPT_PARA = record
    cbSize:           DWORD;
    hCryptProv:       HCRYPTPROV;
    dwKeySpec:        DWORD;
    dwRecipientIndex: DWORD;
  end;
  PCMSG_CTRL_DECRYPT_PARA = ^CMSG_CTRL_DECRYPT_PARA;

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_KEY_TRANS_DECRYPT
  //
  //  Decrypt an ENVELOPED message after it has been decoded for a key
  //  transport recipient.
  //
  //  hCryptProv and dwKeySpec specify the private key to use. For dwKeySpec ==
  //  0, defaults to AT_KEYEXCHANGE.
  //
  //  If CMSG_CRYPT_RELEASE_CONTEXT_FLAG is set in the dwFlags passed
  //  to CryptMsgControl, then, the hCryptProv is released on the final
  //  CryptMsgClose. Not released if CryptMsgControl fails.
  //
  //  pKeyTrans points to the CMSG_KEY_TRANS_RECIPIENT_INFO obtained via
  //  CryptMsgGetParam(CMSG_CMS_RECIPIENT_INFO_PARAM)
  //
  //  dwRecipientIndex is the index of the recipient in the message associated
  //  with the hCryptProv's private key.
  //
  //  Note, the message can only be decrypted once.
  //--------------------------------------------------------------------------
type
  CMSG_CTRL_KEY_TRANS_DECRYPT_PARA = record
    cbSize:           DWORD;
    hCryptProv:       HCRYPTPROV;
    dwKeySpec:        DWORD;
    pKeyTrans:        PCMSG_KEY_TRANS_RECIPIENT_INFO;
    dwRecipientIndex: DWORD;
  end;
  PCMSG_CTRL_KEY_TRANS_DECRYPT_PARA = ^CMSG_CTRL_KEY_TRANS_DECRYPT_PARA;

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_KEY_AGREE_DECRYPT
  //
  //  Decrypt an ENVELOPED message after it has been decoded for a key
  //  agreement recipient.
  //
  //  hCryptProv and dwKeySpec specify the private key to use. For dwKeySpec ==
  //  0, defaults to AT_KEYEXCHANGE.
  //
  //  If CMSG_CRYPT_RELEASE_CONTEXT_FLAG is set in the dwFlags passed
  //  to CryptMsgControl, then, the hCryptProv is released on the final
  //  CryptMsgClose. Not released if CryptMsgControl fails.
  //
  //  pKeyAgree points to the CMSG_KEY_AGREE_RECIPIENT_INFO obtained via
  //  CryptMsgGetParam(CMSG_CMS_RECIPIENT_INFO_PARAM) for dwRecipientIndex.
  //
  //  dwRecipientIndex, dwRecipientEncryptedKeyIndex are the indices of the
  //  recipient's encrypted key in the message associated with the hCryptProv's
  //  private key.
  //
  //  OriginatorPublicKey is the originator's public key obtained from either
  //  the originator's certificate or the CMSG_KEY_AGREE_RECIPIENT_INFO obtained
  //  via the CMSG_CMS_RECIPIENT_INFO_PARAM.
  //
  //  Note, the message can only be decrypted once.
  //--------------------------------------------------------------------------
type
  CMSG_CTRL_KEY_AGREE_DECRYPT_PARA = record
    cbSize:                       DWORD;
    hCryptProv:                   HCRYPTPROV;
    dwKeySpec:                    DWORD;
    pKeyAgree:                    PCMSG_KEY_AGREE_RECIPIENT_INFO;
    dwRecipientIndex:             DWORD;
    dwRecipientEncryptedKeyIndex: DWORD;
    OriginatorPublicKey:          CRYPT_BIT_BLOB;
  end;
  PCMSG_CTRL_KEY_AGREE_DECRYPT_PARA = ^CMSG_CTRL_KEY_AGREE_DECRYPT_PARA;

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_MAIL_LIST_DECRYPT
  //
  //  Decrypt an ENVELOPED message after it has been decoded for a mail
  //  list recipient.
  //
  //  pMailList points to the CMSG_MAIL_LIST_RECIPIENT_INFO obtained via
  //  CryptMsgGetParam(CMSG_CMS_RECIPIENT_INFO_PARAM) for dwRecipientIndex.
  //
  //  There is 1 choice for the KeyEncryptionKey: an already created CSP key
  //  handle. For the key handle choice, hCryptProv must be nonzero. This key
  //  handle isn't destroyed.
  //
  //  If CMSG_CRYPT_RELEASE_CONTEXT_FLAG is set in the dwFlags passed
  //  to CryptMsgControl, then, the hCryptProv is released on the final
  //  CryptMsgClose. Not released if CryptMsgControl fails.
  //
  //  For RC2 wrap, the effective key length is obtained from the
  //  KeyEncryptionAlgorithm parameters and set on the hKeyEncryptionKey before
  //  decrypting.
  //
  //  Note, the message can only be decrypted once.
  //--------------------------------------------------------------------------
type
  CMSG_CTRL_MAIL_LIST_DECRYPT_PARA = record
    cbSize:           DWORD;
    hCryptProv:       HCRYPTPROV;
    pMailList:        PCMSG_MAIL_LIST_RECIPIENT_INFO;
    dwRecipientIndex: DWORD;
    case dwKeyChoice: DWORD of
      CMSG_MAIL_LIST_HANDLE_KEY_CHOICE:
        (hKeyEncryptionKey: HCRYPTKEY);
      // Reserve space for a potential pointer choice
      // *pvKeyEncryptionKey: void;
  end;
  PCMSG_CTRL_MAIL_LIST_DECRYPT_PARA = ^CMSG_CTRL_MAIL_LIST_DECRYPT_PARA;

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_VERIFY_HASH
  //
  //  Verify the hash of a HASHED message after it has been decoded.
  //
  //  Only the hCryptMsg parameter is used, to specify the message whose
  //  hash is being verified.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_ADD_SIGNER
  //
  //  Add a signer to a signed-data message.
  //
  //  pvCtrlPara points to a CMSG_SIGNER_ENCODE_INFO.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_ADD_CMS_SIGNER_INFO
  //
  //  Add a signer to a signed-data message.
  //
  //  Differs from the above, CMSG_CTRL_ADD_SIGNER, wherein, the signer info
  //  already contains the signature.
  //
  //  pvCtrlPara points to a CMSG_CMS_SIGNER_INFO.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_DEL_SIGNER
  //
  //  Remove a signer from a signed-data or signed-and-enveloped-data message.
  //
  //  pvCtrlPara points to a DWORD containing the 0-based index of the
  //  signer to be removed.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_ADD_SIGNER_UNAUTH_ATTR
  //
  //  Add an unauthenticated attribute to the SignerInfo of a signed-data or
  //  signed-and-enveloped-data message.
  //
  //  The unauthenticated attribute is input in the form of an encoded blob.
  //--------------------------------------------------------------------------
type
  CMSG_CTRL_ADD_SIGNER_UNAUTH_ATTR_PARA = record
    cbSize:        DWORD;
    dwSignerIndex: DWORD;
    blob:          CRYPT_DATA_BLOB;
  end;
  PCMSG_CTRL_ADD_SIGNER_UNAUTH_ATTR_PARA =
    ^CMSG_CTRL_ADD_SIGNER_UNAUTH_ATTR_PARA;

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_DEL_SIGNER_UNAUTH_ATTR
  //
  //  Delete an unauthenticated attribute from the SignerInfo of a signed-data
  //  or signed-and-enveloped-data message.
  //
  //  The unauthenticated attribute to be removed is specified by
  //  a 0-based index.
  //--------------------------------------------------------------------------
  CMSG_CTRL_DEL_SIGNER_UNAUTH_ATTR_PARA = record
    cbSize:            DWORD;
    dwSignerIndex:     DWORD;
    dwUnauthAttrIndex: DWORD;
  end;
  PCMSG_CTRL_DEL_SIGNER_UNAUTH_ATTR_PARA =
    ^CMSG_CTRL_DEL_SIGNER_UNAUTH_ATTR_PARA;

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_ADD_CERT
  //
  //  Add a certificate to a signed-data or signed-and-enveloped-data message.
  //
  //  pvCtrlPara points to a CRYPT_DATA_BLOB containing the certificate's
  //  encoded bytes.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_DEL_CERT
  //
  //  Delete a certificate from a signed-data or signed-and-enveloped-data
  //  message.
  //
  //  pvCtrlPara points to a DWORD containing the 0-based index of the
  //  certificate to be removed.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_ADD_CRL
  //
  //  Add a CRL to a signed-data or signed-and-enveloped-data message.
  //
  //  pvCtrlPara points to a CRYPT_DATA_BLOB containing the CRL's
  //  encoded bytes.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_DEL_CRL
  //
  //  Delete a CRL from a signed-data or signed-and-enveloped-data message.
  //
  //  pvCtrlPara points to a DWORD containing the 0-based index of the CRL
  //  to be removed.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_ADD_ATTR_CERT
  //
  //  Add an attribute certificate to a signed-data message.
  //
  //  pvCtrlPara points to a CRYPT_DATA_BLOB containing the attribute
  //  certificate's encoded bytes.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CMSG_CTRL_DEL_ATTR_CERT
  //
  //  Delete an attribute certificate from a signed-data message.
  //
  //  pvCtrlPara points to a DWORD containing the 0-based index of the
  //  attribute certificate to be removed.
  //--------------------------------------------------------------------------

//+-------------------------------------------------------------------------
//  Verify a countersignature, at the SignerInfo level.
//  ie. verify that pbSignerInfoCountersignature contains the encrypted
//  hash of the encryptedDigest field of pbSignerInfo.
//
//  hCryptProv is used to hash the encryptedDigest field of pbSignerInfo.
//  The only fields referenced from pciCountersigner are SerialNumber, Issuer,
//  and SubjectPublicKeyInfo.
//--------------------------------------------------------------------------
function CryptMsgVerifyCountersignatureEncoded(
  hCryptProv: HCRYPTPROV;
  dwEncodingType: DWORD;
  pbSignerInfo: PBYTE;
  cbSignerInfo: DWORD;
  pbSignerInfoCountersignature: PBYTE;
  cbSignerInfoCountersignature: DWORD;
  pciCountersigner: PCERT_INFO
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Verify a countersignature, at the SignerInfo level.
//  ie. verify that pbSignerInfoCountersignature contains the encrypted
//  hash of the encryptedDigest field of pbSignerInfo.
//
//  hCryptProv is used to hash the encryptedDigest field of pbSignerInfo.
//
//  The signer can be a CERT_PUBLIC_KEY_INFO, certificate context or a
//  chain context.
//--------------------------------------------------------------------------
function CryptMsgVerifyCountersignatureEncodedEx(
  hCryptProv: HCRYPTPROV;
  dwEncodingType: DWORD;
  pbSignerInfo: PBYTE;
  cbSignerInfo: DWORD;
  pbSignerInfoCountersignature: PBYTE;
  cbSignerInfoCountersignature: DWORD;
  dwSignerType: DWORD;
  pvSigner: pointer;
  dwFlags: DWORD;
  pvReserved: pointer
  ): BOOL; stdcall;

// See CMSG_CTRL_VERIFY_SIGNATURE_EX_PARA for dwSignerType definitions

//+-------------------------------------------------------------------------
//  Countersign an already-existing signature in a message
//
//  dwIndex is a zero-based index of the SignerInfo to be countersigned.
//--------------------------------------------------------------------------
function CryptMsgCountersign(
  hCryptMsg: HCRYPTMSG;
  dwIndex: DWORD;
  cCountersigners: DWORD;
  rgCountersigners: PCMSG_SIGNER_ENCODE_INFO
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Countersign an already-existing signature (encoded SignerInfo).
//  Output an encoded SignerInfo blob, suitable for use as a countersignature
//  attribute in the unauthenticated attributes of a signed-data or
//  signed-and-enveloped-data message.
//--------------------------------------------------------------------------
function CryptMsgCountersignEncoded(
  dwEncodingType: DWORD;
  pbSignerInfo: PBYTE;
  cbSignerInfo: DWORD;
  cCountersigners: DWORD;
  rgCountersigners: PCMSG_SIGNER_ENCODE_INFO;
  pbCountersignature: PBYTE;
  pcbCountersignature: PDWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  CryptMsg OID installable functions
//--------------------------------------------------------------------------
type
  PFN_CMSG_ALLOC = function(
    cb: DWORD
    ): pointer; stdcall;
  PFN_CMSG_FREE = procedure(
    pv: pointer
    ); stdcall;

  // Note, the following 3 installable functions are obsolete and have been
  // replaced with GenContentEncryptKey, ExportKeyTrans, ExportKeyAgree,
  // ExportMailList, ImportKeyTrans, ImportKeyAgree and ImportMailList
  // installable functions.

  // If *phCryptProv is NULL upon entry, then, if supported, the installable
  // function should acquire a default provider and return. Note, its up
  // to the installable function to release at process detach.
  //
  // If paiEncrypt->Parameters.cbData is 0, then, the callback may optionally
  // return default encoded parameters in *ppbEncryptParameters and
  // *pcbEncryptParameters. pfnAlloc must be called for the allocation.
const
  CMSG_OID_GEN_ENCRYPT_KEY_FUNC = 'CryptMsgDllGenEncryptKey';
type
  PFN_CMSG_GEN_ENCRYPT_KEY = function(
    var phCryptProv: HCRYPTPROV;
    paiEncrypt: PCRYPT_ALGORITHM_IDENTIFIER;
    pvEncryptAuxInfo: pointer;
    pPublicKeyInfo: PCERT_PUBLIC_KEY_INFO;
    pfnAlloc: PFN_CMSG_ALLOC;
    var phEncryptKey: HCRYPTKEY;
    var ppbEncryptParameters: PBYTE;
    var pcbEncryptParameters: DWORD
    ): BOOL; stdcall;

const
  CMSG_OID_EXPORT_ENCRYPT_KEY_FUNC = 'CryptMsgDllExportEncryptKey';
type
  PFN_CMSG_EXPORT_ENCRYPT_KEY = function(
    hCryptProv: HCRYPTPROV;
    hEncryptKey: HCRYPTKEY;
    pPublicKeyInfo: PCERT_PUBLIC_KEY_INFO;
    pbData: PBYTE;
    var pcbData: DWORD
    ): BOOL; stdcall;

const
  CMSG_OID_IMPORT_ENCRYPT_KEY_FUNC = 'CryptMsgDllImportEncryptKey';
type
  PFN_CMSG_IMPORT_ENCRYPT_KEY = function(
    hCryptProv: HCRYPTPROV;
    dwKeySpec: DWORD;
    paiEncrypt: PCRYPT_ALGORITHM_IDENTIFIER;
    paiPubKey: PCRYPT_ALGORITHM_IDENTIFIER;
    pbEncodedKey: PBYTE;
    cbEncodedKey: DWORD;
    var phEncryptKey: HCRYPTKEY
    ): BOOL; stdcall;

  // To get the default installable function for GenContentEncryptKey,
  // ExportKeyTrans, ExportKeyAgree, ExportMailList, ImportKeyTrans,
  // ImportKeyAgree or ImportMailList call CryptGetOIDFunctionAddress()
  // with the pszOID argument set to the following constant. dwEncodingType
  // should be set to CRYPT_ASN_ENCODING or X509_ASN_ENCODING.
const
  CMSG_DEFAULT_INSTALLABLE_FUNC_OID = LPCSTR(1);

  //+-------------------------------------------------------------------------
  //  Content Encrypt Info
  //
  //  The following data structure contains the information shared between
  //  the GenContentEncryptKey and the ExportKeyTrans, ExportKeyAgree and
  //  ExportMailList installable functions.
  //--------------------------------------------------------------------------
type
  CMSG_CONTENT_ENCRYPT_INFO = record
    cbSize:                     DWORD;
    hCryptProv:                 HCRYPTPROV;
    ContentEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    pvEncryptionAuxInfo:        pointer;
    cRecipients:                DWORD;
    rgCmsRecipients:            PCMSG_RECIPIENT_ENCODE_INFO;
    pfnAlloc:                   PFN_CMSG_ALLOC;
    pfnFree:                    PFN_CMSG_FREE;
    dwEncryptFlags:             DWORD;
    hContentEncryptKey:         HCRYPTKEY;
    dwFlags:                    DWORD;
  end;
  PCMSG_CONTENT_ENCRYPT_INFO = ^CMSG_CONTENT_ENCRYPT_INFO;

const
  CMSG_CONTENT_ENCRYPT_PAD_ENCODED_LEN_FLAG = $00000001;

  CMSG_CONTENT_ENCRYPT_FREE_PARA_FLAG       = $00000001;
  CMSG_CONTENT_ENCRYPT_RELEASE_CONTEXT_FLAG = $00008000;

  //+-------------------------------------------------------------------------
  // Upon input, ContentEncryptInfo has been initialized from the
  // EnvelopedEncodeInfo.
  //
  // Note, if rgpRecipients instead of rgCmsRecipients are set in the
  // EnvelopedEncodeInfo, then, the rgpRecipients have been converted
  // to rgCmsRecipients in the ContentEncryptInfo.
  //
  // The following fields may be changed in ContentEncryptInfo:
  //      hContentEncryptKey
  //      hCryptProv
  //      ContentEncryptionAlgorithm.Parameters
  //      dwFlags
  //
  // All other fields in the ContentEncryptInfo are READONLY.
  //
  // If CMSG_CONTENT_ENCRYPT_PAD_ENCODED_LEN_FLAG is set upon entry
  // in dwEncryptFlags, then, any potentially variable length encoded
  // output should be padded with zeroes to always obtain the
  // same maximum encoded length. This is necessary for
  // CryptMsgCalculateEncodedLength() or CryptMsgOpenToEncode() with
  // definite length streaming.
  //
  // The hContentEncryptKey must be updated.
  //
  // If hCryptProv is NULL upon input, then, it must be updated.
  // If a HCRYPTPROV is acquired that must be released, then, the
  // CMSG_CONTENT_ENCRYPT_RELEASE_CONTEXT_FLAG must be set in dwFlags.
  //
  // If ContentEncryptionAlgorithm.Parameters is updated, then, the
  // CMSG_CONTENT_ENCRYPT_FREE_PARA_FLAG must be set in dwFlags. pfnAlloc and
  // pfnFree must be used for doing the allocation.
  //
  // ContentEncryptionAlgorithm.pszObjId is used to get the OIDFunctionAddress.
  //--------------------------------------------------------------------------
const
  CMSG_OID_GEN_CONTENT_ENCRYPT_KEY_FUNC = 'CryptMsgDllGenContentEncryptKey';
type
  PFN_CMSG_GEN_CONTENT_ENCRYPT_KEY = function(
    var pContentEncryptInfo: CMSG_CONTENT_ENCRYPT_INFO;
    dwFlags: DWORD;
    pvReserved: pointer
    ): BOOL; stdcall;

  //+-------------------------------------------------------------------------
  //  Key Transport Encrypt Info
  //
  //  The following data structure contains the information updated by the
  //  ExportKeyTrans installable function.
  //--------------------------------------------------------------------------
type
  CMSG_KEY_TRANS_ENCRYPT_INFO = record
    cbSize:                 DWORD;
    dwRecipientIndex:       DWORD;
    KeyEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    EncryptedKey:           CRYPT_DATA_BLOB;
    dwFlags:                DWORD;
  end;
  PCMSG_KEY_TRANS_ENCRYPT_INFO = ^CMSG_KEY_TRANS_ENCRYPT_INFO;

const
  CMSG_KEY_TRANS_ENCRYPT_FREE_PARA_FLAG = $00000001;

  //+-------------------------------------------------------------------------
  // Upon input, KeyTransEncryptInfo has been initialized from the
  // KeyTransEncodeInfo.
  //
  // The following fields may be changed in KeyTransEncryptInfo:
  //      EncryptedKey
  //      KeyEncryptionAlgorithm.Parameters
  //      dwFlags
  //
  // All other fields in the KeyTransEncryptInfo are READONLY.
  //
  // The EncryptedKey must be updated. The pfnAlloc and pfnFree specified in
  // ContentEncryptInfo must be used for doing the allocation.
  //
  // If the KeyEncryptionAlgorithm.Parameters is updated, then, the
  // CMSG_KEY_TRANS_ENCRYPT_FREE_PARA_FLAG must be set in dwFlags.
  // The pfnAlloc and pfnFree specified in ContentEncryptInfo must be used
  // for doing the allocation.
  //
  // KeyEncryptionAlgorithm.pszObjId is used to get the OIDFunctionAddress.
  //--------------------------------------------------------------------------
const
  CMSG_OID_EXPORT_KEY_TRANS_FUNC = 'CryptMsgDllExportKeyTrans';
type
  PFN_CMSG_EXPORT_KEY_TRANS = function(
    pContentEncryptInfo: PCMSG_CONTENT_ENCRYPT_INFO;
    pKeyTransEncodeInfo: PCMSG_KEY_TRANS_RECIPIENT_ENCODE_INFO;
    var pKeyTransEncryptInfo: CMSG_KEY_TRANS_ENCRYPT_INFO;
    dwFlags: DWORD;
    pvReserved: pointer
    ): BOOL; stdcall;

  //+-------------------------------------------------------------------------
  //  Key Agree Key Encrypt Info
  //
  //  The following data structure contains the information updated by the
  //  ExportKeyAgree installable function for each encrypted key agree
  //  recipient.
  //--------------------------------------------------------------------------
type
  CMSG_KEY_AGREE_KEY_ENCRYPT_INFO = record
    cbSize:       DWORD;
    EncryptedKey: CRYPT_DATA_BLOB;
  end;
  PCMSG_KEY_AGREE_KEY_ENCRYPT_INFO = ^CMSG_KEY_AGREE_KEY_ENCRYPT_INFO;

  //+-------------------------------------------------------------------------
  //  Key Agree Encrypt Info
  //
  //  The following data structure contains the information applicable to
  //  all recipients. Its updated by the ExportKeyAgree installable function.
  //--------------------------------------------------------------------------
type
  TARR_PCMSG_KEY_AGREE_KEY_ENCRYPT_INFO = ^PCMSG_KEY_AGREE_KEY_ENCRYPT_INFO;
  CMSG_KEY_AGREE_ENCRYPT_INFO = record
    cbSize:                 DWORD;
    dwRecipientIndex:       DWORD;
    KeyEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    UserKeyingMaterial:     CRYPT_DATA_BLOB;
    case dwOriginatorChoice: DWORD of
      CMSG_KEY_AGREE_ORIGINATOR_CERT:
      (OriginatorCertId:            CERT_ID;
        cKeyAgreeKeyEncryptInfo:    DWORD;
        rgpKeyAgreeKeyEncryptInfo:  TARR_PCMSG_KEY_AGREE_KEY_ENCRYPT_INFO;
        dwFlags:                    DWORD);
      CMSG_KEY_AGREE_ORIGINATOR_PUBLIC_KEY:
      (OriginatorPublicKeyInfo:     CERT_PUBLIC_KEY_INFO);
  end;
  PCMSG_KEY_AGREE_ENCRYPT_INFO = ^CMSG_KEY_AGREE_ENCRYPT_INFO;

const
  CMSG_KEY_AGREE_ENCRYPT_FREE_PARA_FLAG        = $00000001;
  CMSG_KEY_AGREE_ENCRYPT_FREE_MATERIAL_FLAG    = $00000002;
  CMSG_KEY_AGREE_ENCRYPT_FREE_PUBKEY_ALG_FLAG  = $00000004;
  CMSG_KEY_AGREE_ENCRYPT_FREE_PUBKEY_PARA_FLAG = $00000008;
  CMSG_KEY_AGREE_ENCRYPT_FREE_PUBKEY_BITS_FLAG = $00000010;

  //+-------------------------------------------------------------------------
  // Upon input, KeyAgreeEncryptInfo has been initialized from the
  // KeyAgreeEncodeInfo.
  //
  // The following fields may be changed in KeyAgreeEncryptInfo:
  //      KeyEncryptionAlgorithm.Parameters
  //      UserKeyingMaterial
  //      dwOriginatorChoice
  //      OriginatorCertId
  //      OriginatorPublicKeyInfo
  //      dwFlags
  //
  // All other fields in the KeyAgreeEncryptInfo are READONLY.
  //
  // If the KeyEncryptionAlgorithm.Parameters is updated, then, the
  // CMSG_KEY_AGREE_ENCRYPT_FREE_PARA_FLAG must be set in dwFlags.
  // The pfnAlloc and pfnFree specified in ContentEncryptInfo must be used
  // for doing the allocation.
  //
  // If the UserKeyingMaterial is updated, then, the
  // CMSG_KEY_AGREE_ENCRYPT_FREE_MATERIAL_FLAG must be set in dwFlags.
  // pfnAlloc and pfnFree must be used for doing the allocation.
  //
  // The dwOriginatorChoice must be updated to either
  // CMSG_KEY_AGREE_ORIGINATOR_CERT or CMSG_KEY_AGREE_ORIGINATOR_PUBLIC_KEY.
  //
  // If the OriginatorPublicKeyInfo is updated, then, the appropriate
  // CMSG_KEY_AGREE_ENCRYPT_FREE_PUBKEY_*_FLAG must be set in dwFlags and
  // pfnAlloc and pfnFree must be used for doing the allocation.
  //
  // If CMSG_CONTENT_ENCRYPT_PAD_ENCODED_LEN_FLAG is set upon entry
  // in pContentEncryptInfo->dwEncryptFlags, then, the OriginatorPublicKeyInfo's
  // Ephemeral PublicKey should be padded with zeroes to always obtain the
  // same maximum encoded length. Note, the length of the generated ephemeral Y
  // public key can vary depending on the number of leading zero bits.
  //
  // Upon input, the array of *rgpKeyAgreeKeyEncryptInfo has been initialized.
  // The EncryptedKey must be updated for each recipient key.
  // The pfnAlloc and pfnFree specified in
  // ContentEncryptInfo must be used for doing the allocation.
  //
  // KeyEncryptionAlgorithm.pszObjId is used to get the OIDFunctionAddress.
  //--------------------------------------------------------------------------
const
  CMSG_OID_EXPORT_KEY_AGREE_FUNC = 'CryptMsgDllExportKeyAgree';
type
  PFN_CMSG_EXPORT_KEY_AGREE = function(
    pContentEncryptInfo: PCMSG_CONTENT_ENCRYPT_INFO;
    pKeyAgreeEncodeInfo: PCMSG_KEY_AGREE_RECIPIENT_ENCODE_INFO;
    var pKeyAgreeEncryptInfo: CMSG_KEY_AGREE_ENCRYPT_INFO;
    dwFlags: DWORD;
    pvReserved: pointer
    ): BOOL; stdcall;

  //+-------------------------------------------------------------------------
  //  Mail List Encrypt Info
  //
  //  The following data structure contains the information updated by the
  //  ExportMailList installable function.
  //--------------------------------------------------------------------------
type
  CMSG_MAIL_LIST_ENCRYPT_INFO = record
    cbSize:                 DWORD;
    dwRecipientIndex:       DWORD;
    KeyEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    EncryptedKey:           CRYPT_DATA_BLOB;
    dwFlags:                DWORD;
  end;
  PCMSG_MAIL_LIST_ENCRYPT_INFO = ^CMSG_MAIL_LIST_ENCRYPT_INFO;

const
  CMSG_MAIL_LIST_ENCRYPT_FREE_PARA_FLAG = $00000001;

  //+-------------------------------------------------------------------------
  // Upon input, MailListEncryptInfo has been initialized from the
  // MailListEncodeInfo.
  //
  // The following fields may be changed in MailListEncryptInfo:
  //      EncryptedKey
  //      KeyEncryptionAlgorithm.Parameters
  //      dwFlags
  //
  // All other fields in the MailListEncryptInfo are READONLY.
  //
  // The EncryptedKey must be updated. The pfnAlloc and pfnFree specified in
  // ContentEncryptInfo must be used for doing the allocation.
  //
  // If the KeyEncryptionAlgorithm.Parameters is updated, then, the
  // CMSG_MAIL_LIST_ENCRYPT_FREE_PARA_FLAG must be set in dwFlags.
  // The pfnAlloc and pfnFree specified in ContentEncryptInfo must be used
  // for doing the allocation.
  //
  // KeyEncryptionAlgorithm.pszObjId is used to get the OIDFunctionAddress.
  //--------------------------------------------------------------------------
const
  CMSG_OID_EXPORT_MAIL_LIST_FUNC = 'CryptMsgDllExportMailList';
type
  PFN_CMSG_EXPORT_MAIL_LIST = function(
    pContentEncryptInfo: PCMSG_CONTENT_ENCRYPT_INFO;
    pMailListEncodeInfo: PCMSG_MAIL_LIST_RECIPIENT_ENCODE_INFO;
    var pMailListEncryptInfo: CMSG_MAIL_LIST_ENCRYPT_INFO;
    dwFlags: DWORD;
    pvReserved: pointer
    ): BOOL; stdcall;

  //+-------------------------------------------------------------------------
  // OID Installable functions for importing an encoded and encrypted content
  // encryption key.
  //
  // There's a different installable function for each CMS Recipient choice:
  //  ImportKeyTrans
  //  ImportKeyAgree
  //  ImportMailList
  //
  // Iterates through the following OIDs to get the OID installable function:
  //   KeyEncryptionOID!ContentEncryptionOID
  //   KeyEncryptionOID
  //   ContentEncryptionOID
  //
  // If the OID installable function doesn't support the specified
  // KeyEncryption and ContentEncryption OIDs, then, return FALSE with
  // LastError set to E_NOTIMPL.
  //--------------------------------------------------------------------------
const
  CMSG_OID_IMPORT_KEY_TRANS_FUNC = 'CryptMsgDllImportKeyTrans';
type
  PFN_CMSG_IMPORT_KEY_TRANS = function(
    pContentEncryptionAlgorithm: PCRYPT_ALGORITHM_IDENTIFIER;
    pKeyTransDecryptPara: PCMSG_CTRL_KEY_TRANS_DECRYPT_PARA;
    dwFlags: DWORD;
    pvReserved: pointer;
    var phContentEncryptKey: HCRYPTKEY
    ): BOOL; stdcall;

const
  CMSG_OID_IMPORT_KEY_AGREE_FUNC = 'CryptMsgDllImportKeyAgree';
type
  PFN_CMSG_IMPORT_KEY_AGREE = function(
    pContentEncryptionAlgorithm: PCRYPT_ALGORITHM_IDENTIFIER;
    pKeyAgreeDecryptPara: PCMSG_CTRL_KEY_AGREE_DECRYPT_PARA;
    dwFlags: DWORD;
    pvReserved: pointer;
    var phContentEncryptKey: HCRYPTKEY
    ): BOOL; stdcall;

const
  CMSG_OID_IMPORT_MAIL_LIST_FUNC = 'CryptMsgDllImportMailList';
type
  PFN_CMSG_IMPORT_MAIL_LIST = function(
    pContentEncryptionAlgorithm: PCRYPT_ALGORITHM_IDENTIFIER;
    pMailListDecryptPara: PCMSG_CTRL_MAIL_LIST_DECRYPT_PARA;
    dwFlags: DWORD;
    pvReserved: pointer;
    var phContentEncryptKey: HCRYPTKEY
    ): BOOL; stdcall;

  //+=========================================================================
  //  Certificate Store Data Structures and APIs
  //==========================================================================

  //+-------------------------------------------------------------------------
  //              In its most basic implementation, a cert store is simply a
  //              collection of certificates and/or CRLs. This is the case when
  //              a cert store is opened with all of its certificates and CRLs
  //              coming from a PKCS #7 encoded cryptographic message.
  //
  //              Nonetheless, all cert stores have the following properties:
  //               - A public key may have more than one certificate in the store.
  //                 For example, a private/public key used for signing may have a
  //                 certificate issued for VISA and another issued for
  //                 Mastercard. Also, when a certificate is renewed there might
  //                 be more than one certificate with the same subject and
  //                 issuer.
  //               - However, each certificate in the store is uniquely
  //                 identified by its Issuer and SerialNumber.
  //               - There's an issuer of subject certificate relationship. A
  //                 certificate's issuer is found by doing a match of
  //                 pSubjectCert->Issuer with pIssuerCert->Subject.
  //                 The relationship is verified by using
  //                 the issuer's public key to verify the subject certificate's
  //                 signature. Note, there might be X.509 v3 extensions
  //                 to assist in finding the issuer certificate.
  //               - Since issuer certificates might be renewed, a subject
  //                 certificate might have more than one issuer certificate.
  //               - There's an issuer of CRL relationship. An
  //                 issuer's CRL is found by doing a match of
  //                 pIssuerCert->Subject with pCrl->Issuer.
  //                 The relationship is verified by using
  //                 the issuer's public key to verify the CRL's
  //                 signature. Note, there might be X.509 v3 extensions
  //                 to assist in finding the CRL.
  //               - Since some issuers might support the X.509 v3 delta CRL
  //                 extensions, an issuer might have more than one CRL.
  //               - The store shouldn't have any redundant certificates or
  //                 CRLs. There shouldn't be two certificates with the same
  //                 Issuer and SerialNumber. There shouldn't be two CRLs with
  //                 the same Issuer, ThisUpdate and NextUpdate.
  //               - The store has NO policy or trust information. No
  //                 certificates are tagged as being "root". Its up to
  //                 the application to maintain a list of CertIds (Issuer +
  //                 SerialNumber) for certificates it trusts.
  //               - The store might contain bad certificates and/or CRLs.
  //                 The issuer's signature of a subject certificate or CRL may
  //                 not verify. Certificates or CRLs may not satisfy their
  //                 time validity requirements. Certificates may be
  //                 revoked.
  //
  //              In addition to the certificates and CRLs, properties can be
  //              stored. There are two predefined property IDs for a user
  //              certificate: CERT_KEY_PROV_HANDLE_PROP_ID and
  //              CERT_KEY_PROV_INFO_PROP_ID. The CERT_KEY_PROV_HANDLE_PROP_ID
  //              is a HCRYPTPROV handle to the private key assoicated
  //              with the certificate. The CERT_KEY_PROV_INFO_PROP_ID contains
  //              information to be used to call
  //              CryptAcquireContext and CryptSetProvParam to get a handle
  //              to the private key associated with the certificate.
  //
  //              There exists two more predefined property IDs for certificates
  //              and CRLs, CERT_SHA1_HASH_PROP_ID and CERT_MD5_HASH_PROP_ID.
  //              If these properties don't already exist, then, a hash of the
  //              content is computed. (CERT_HASH_PROP_ID maps to the default
  //              hash algorithm, currently, CERT_SHA1_HASH_PROP_ID).
  //
  //              There are additional APIs for creating certificate and CRL
  //      contexts not in a store (CertCreateCertificateContext and
  //      CertCreateCRLContext).
  //
  //--------------------------------------------------------------------------
type
  HCERTSTORE = pointer;

  //+-------------------------------------------------------------------------
  //  Certificate context.
  //
  //  A certificate context contains both the encoded and decoded representation
  //  of a certificate. A certificate context returned by a cert store function
  //  must be freed by calling the CertFreeCertificateContext function. The
  //  CertDuplicateCertificateContext function can be called to make a duplicate
  //  copy (which also must be freed by calling CertFreeCertificateContext).
  //--------------------------------------------------------------------------
type
  CERT_CONTEXT = record
    dwCertEncodingType: DWORD;
    pbCertEncoded:      PBYTE;
    cbCertEncoded:      DWORD;
    pCertInfo:          PCERT_INFO;
    hCertStore:         HCERTSTORE;
  end;
  PCERT_CONTEXT = ^CERT_CONTEXT;
  PCCERT_CONTEXT = ^CERT_CONTEXT;
  PPCCERT_CONTEXT = ^PCCERT_CONTEXT;

  //+-------------------------------------------------------------------------
  //  CRL context.
  //
  //  A CRL context contains both the encoded and decoded representation
  //  of a CRL. A CRL context returned by a cert store function
  //  must be freed by calling the CertFreeCRLContext function. The
  //  CertDuplicateCRLContext function can be called to make a duplicate
  //  copy (which also must be freed by calling CertFreeCRLContext).
  //--------------------------------------------------------------------------
type
  CRL_CONTEXT = record
    dwCertEncodingType: DWORD;
    pbCrlEncoded:       PBYTE;
    cbCrlEncoded:       DWORD;
    pCrlInfo:           PCRL_INFO;
    hCertStore:         HCERTSTORE;
  end;
  PCRL_CONTEXT = ^CRL_CONTEXT;
  PCCRL_CONTEXT = ^CRL_CONTEXT;
  PPCCRL_CONTEXT = ^PCCRL_CONTEXT;

  //+-------------------------------------------------------------------------
  //  Certificate Trust List (CTL) context.
  //
  //  A CTL context contains both the encoded and decoded representation
  //  of a CTL. Also contains an opened HCRYPTMSG handle to the decoded
  //  cryptographic signed message containing the CTL_INFO as its inner content.
  //  pbCtlContent is the encoded inner content of the signed message.
  //
  //  The CryptMsg APIs can be used to extract additional signer information.
  //--------------------------------------------------------------------------
type
  CTL_CONTEXT = record
    dwMsgAndCertEncodingType: DWORD;
    pbCtlEncoded:             PBYTE;
    cbCtlEncoded:             DWORD;
    pCtlInfo:                 PCTL_INFO;
    hCertStore:               HCERTSTORE;
    hCryptMsg:                HCRYPTMSG;
    pbCtlContent:             PBYTE;
    cbCtlContent:             DWORD;
  end;
  PCTL_CONTEXT = ^CTL_CONTEXT;
  PCCTL_CONTEXT = ^CTL_CONTEXT;
  PPCCTL_CONTEXT = ^PCCTL_CONTEXT;

  //+-------------------------------------------------------------------------
  //  Certificate, CRL and CTL property IDs
  //
  //  See CertSetCertificateContextProperty or CertGetCertificateContextProperty
  //  for usage information.
  //--------------------------------------------------------------------------
const
  CERT_KEY_PROV_HANDLE_PROP_ID               = 1;
  CERT_KEY_PROV_INFO_PROP_ID                 = 2;
  CERT_SHA1_HASH_PROP_ID                     = 3;
  CERT_MD5_HASH_PROP_ID                      = 4;
  CERT_HASH_PROP_ID                          = CERT_SHA1_HASH_PROP_ID;
  CERT_KEY_CONTEXT_PROP_ID                   = 5;
  CERT_KEY_SPEC_PROP_ID                      = 6;
  CERT_IE30_RESERVED_PROP_ID                 = 7;
  CERT_PUBKEY_HASH_RESERVED_PROP_ID          = 8;
  CERT_ENHKEY_USAGE_PROP_ID                  = 9;
  CERT_CTL_USAGE_PROP_ID                     = CERT_ENHKEY_USAGE_PROP_ID;
  CERT_NEXT_UPDATE_LOCATION_PROP_ID          = 10;
  CERT_FRIENDLY_NAME_PROP_ID                 = 11;
  CERT_PVK_FILE_PROP_ID                      = 12;
  CERT_DESCRIPTION_PROP_ID                   = 13;
  CERT_ACCESS_STATE_PROP_ID                  = 14;
  CERT_SIGNATURE_HASH_PROP_ID                = 15;
  CERT_SMART_CARD_DATA_PROP_ID               = 16;
  CERT_EFS_PROP_ID                           = 17;
  CERT_FORTEZZA_DATA_PROP_ID                 = 18;
  CERT_ARCHIVED_PROP_ID                      = 19;
  CERT_KEY_IDENTIFIER_PROP_ID                = 20;
  CERT_AUTO_ENROLL_PROP_ID                   = 21;
  CERT_PUBKEY_ALG_PARA_PROP_ID               = 22;

  CERT_CROSS_CERT_DIST_POINTS_PROP_ID        = 23;
  CERT_ISSUER_PUBLIC_KEY_MD5_HASH_PROP_ID    = 24;
  CERT_SUBJECT_PUBLIC_KEY_MD5_HASH_PROP_ID   = 25;
  CERT_ENROLLMENT_PROP_ID                    = 26;
  CERT_DATE_STAMP_PROP_ID                    = 27;
  CERT_ISSUER_SERIAL_NUMBER_MD5_HASH_PROP_ID = 28;
  CERT_SUBJECT_NAME_MD5_HASH_PROP_ID         = 29;
  CERT_EXTENDED_ERROR_INFO_PROP_ID           = 30;

// Note, 32 - 35 are reserved for the CERT, CRL, CTL and KeyId file element IDs.
//       36 - 63 are reserved for future element IDs.

  CERT_RENEWAL_PROP_ID                       = 64;
  CERT_ARCHIVED_KEY_HASH_PROP_ID             = 65;
  CERT_FIRST_RESERVED_PROP_ID                = 66;

  CERT_LAST_RESERVED_PROP_ID = $00007FFF;
  CERT_FIRST_USER_PROP_ID    = $00008000;
  CERT_LAST_USER_PROP_ID     = $0000FFFF;

function IS_CERT_HASH_PROP_ID(X: DWORD): boolean;
function IS_PUBKEY_HASH_PROP_ID(X: DWORD): boolean;
function IS_CHAIN_HASH_PROP_ID(X: DWORD): boolean;

//+-------------------------------------------------------------------------
//  Property OIDs
//--------------------------------------------------------------------------
// The OID component following the prefix contains the PROP_ID (decimal)
const
  szOID_CERT_PROP_ID_PREFIX                        = '1.3.6.1.4.1.311.10.11.';

  szOID_CERT_KEY_IDENTIFIER_PROP_ID                = '1.3.6.1.4.1.311.10.11.20';
  szOID_CERT_ISSUER_SERIAL_NUMBER_MD5_HASH_PROP_ID = '1.3.6.1.4.1.311.10.11.28';
  szOID_CERT_SUBJECT_NAME_MD5_HASH_PROP_ID         = '1.3.6.1.4.1.311.10.11.29';

//+-------------------------------------------------------------------------
//  Access State flags returned by CERT_ACCESS_STATE_PROP_ID. Note,
//  CERT_ACCESS_PROP_ID is read only.
//--------------------------------------------------------------------------

// Set if context property writes are persisted. For instance, not set for
// memory store contexts. Set for registry based stores opened as read or write.
// Not set for registry based stores opened as read only.
const
  CERT_ACCESS_STATE_WRITE_PERSIST_FLAG = $1;

  // Set if context resides in a SYSTEM or SYSTEM_REGISTRY store.
  CERT_ACCESS_STATE_SYSTEM_STORE_FLAG  = $2;

  //+-------------------------------------------------------------------------
  //  Cryptographic Key Provider Information
  //
  //  CRYPT_KEY_PROV_INFO defines the CERT_KEY_PROV_INFO_PROP_ID's pvData.
  //
  //  The CRYPT_KEY_PROV_INFO fields are passed to CryptAcquireContext
  //  to get a HCRYPTPROV handle. The optional CRYPT_KEY_PROV_PARAM fields are
  //  passed to CryptSetProvParam to further initialize the provider.
  //
  //  The dwKeySpec field identifies the private key to use from the container
  //  For example, AT_KEYEXCHANGE or AT_SIGNATURE.
  //--------------------------------------------------------------------------
type
  CRYPT_KEY_PROV_PARAM = record
    dwParam: DWORD;
    pbData:  PBYTE;
    cbData:  DWORD;
    dwFlags: DWORD;
  end;
  PCRYPT_KEY_PROV_PARAM = ^CRYPT_KEY_PROV_PARAM;

type
  CRYPT_KEY_PROV_INFO = record
    pwszContainerName: LPWSTR;
    pwszProvName:      LPWSTR;
    dwProvType:        DWORD;
    dwFlags:           DWORD;
    cProvParam:        DWORD;
    rgProvParam:       PCRYPT_KEY_PROV_PARAM;
    dwKeySpec:         DWORD;
  end;
  PCRYPT_KEY_PROV_INFO = ^CRYPT_KEY_PROV_INFO;

  //+-------------------------------------------------------------------------
  //  The following flag should be set in the above dwFlags to enable
  //  a CertSetCertificateContextProperty(CERT_KEY_CONTEXT_PROP_ID) after a
  //  CryptAcquireContext is done in the Sign or Decrypt Message functions.
  //
  //  The following define must not collide with any of the
  //  CryptAcquireContext dwFlag defines.
  //--------------------------------------------------------------------------
const
  CERT_SET_KEY_PROV_HANDLE_PROP_ID = $00000001;
  CERT_SET_KEY_CONTEXT_PROP_ID     = $00000001;

  //+-------------------------------------------------------------------------
  //  Certificate Key Context
  //
  //  CERT_KEY_CONTEXT defines the CERT_KEY_CONTEXT_PROP_ID's pvData.
  //--------------------------------------------------------------------------
type
  CERT_KEY_CONTEXT = record
    cbSize:     DWORD; // sizeof(CERT_KEY_CONTEXT)
    hCryptProv: HCRYPTPROV;
    dwKeySpec:  DWORD;
  end;
  PCERT_KEY_CONTEXT = ^CERT_KEY_CONTEXT;

  //+-------------------------------------------------------------------------
  //  Certificate Store Provider Types
  //--------------------------------------------------------------------------
const
  CERT_STORE_PROV_MSG               = LPCSTR(1);
  CERT_STORE_PROV_MEMORY            = LPCSTR(2);
  CERT_STORE_PROV_FILE              = LPCSTR(3);
  CERT_STORE_PROV_REG               = LPCSTR(4);

  CERT_STORE_PROV_PKCS7             = LPCSTR(5);
  CERT_STORE_PROV_SERIALIZED        = LPCSTR(6);
  CERT_STORE_PROV_FILENAME_A        = LPCSTR(7);
  CERT_STORE_PROV_FILENAME_W        = LPCSTR(8);
  CERT_STORE_PROV_FILENAME          = CERT_STORE_PROV_FILENAME_W;
  CERT_STORE_PROV_SYSTEM_A          = LPCSTR(9);
  CERT_STORE_PROV_SYSTEM_W          = LPCSTR(10);
  CERT_STORE_PROV_SYSTEM            = CERT_STORE_PROV_SYSTEM_W;

  CERT_STORE_PROV_COLLECTION        = LPCSTR(11);
  CERT_STORE_PROV_SYSTEM_REGISTRY_A = LPCSTR(12);
  CERT_STORE_PROV_SYSTEM_REGISTRY_W = LPCSTR(13);
  CERT_STORE_PROV_SYSTEM_REGISTRY   = CERT_STORE_PROV_SYSTEM_REGISTRY_W;
  CERT_STORE_PROV_PHYSICAL_W        = LPCSTR(14);
  CERT_STORE_PROV_PHYSICAL          = CERT_STORE_PROV_PHYSICAL_W;
  CERT_STORE_PROV_SMART_CARD_W      = LPCSTR(15);
  CERT_STORE_PROV_SMART_CARD        = CERT_STORE_PROV_SMART_CARD_W;
  CERT_STORE_PROV_LDAP_W            = LPCSTR(16);
  CERT_STORE_PROV_LDAP              = CERT_STORE_PROV_LDAP_W;

  sz_CERT_STORE_PROV_MEMORY     = 'Memory';
  sz_CERT_STORE_PROV_FILENAME_W = 'File';
  sz_CERT_STORE_PROV_FILENAME   = sz_CERT_STORE_PROV_FILENAME_W;
  sz_CERT_STORE_PROV_SYSTEM_W   = 'System';
  sz_CERT_STORE_PROV_SYSTEM     = sz_CERT_STORE_PROV_SYSTEM_W;
  sz_CERT_STORE_PROV_PKCS7      = 'PKCS7';
  sz_CERT_STORE_PROV_SERIALIZED = 'Serialized';

  sz_CERT_STORE_PROV_COLLECTION        = 'Collection';
  sz_CERT_STORE_PROV_SYSTEM_REGISTRY_W = 'SystemRegistry';
  sz_CERT_STORE_PROV_SYSTEM_REGISTRY   = sz_CERT_STORE_PROV_SYSTEM_REGISTRY_W;
  sz_CERT_STORE_PROV_PHYSICAL_W        = 'Physical';
  sz_CERT_STORE_PROV_PHYSICAL          = sz_CERT_STORE_PROV_PHYSICAL_W;
  sz_CERT_STORE_PROV_SMART_CARD_W      = 'SmartCard';
  sz_CERT_STORE_PROV_SMART_CARD        = sz_CERT_STORE_PROV_SMART_CARD_W;
  sz_CERT_STORE_PROV_LDAP_W            = 'Ldap';
  sz_CERT_STORE_PROV_LDAP              = sz_CERT_STORE_PROV_LDAP_W;

  //+-------------------------------------------------------------------------
  //  Certificate Store verify/results flags
  //--------------------------------------------------------------------------
  CERT_STORE_SIGNATURE_FLAG     = $00000001;
  CERT_STORE_TIME_VALIDITY_FLAG = $00000002;
  CERT_STORE_REVOCATION_FLAG    = $00000004;
  CERT_STORE_NO_CRL_FLAG        = $00010000;
  CERT_STORE_NO_ISSUER_FLAG     = $00020000;

  CERT_STORE_BASE_CRL_FLAG      = $00000100;
  CERT_STORE_DELTA_CRL_FLAG     = $00000200;

  //+-------------------------------------------------------------------------
  //  Certificate Store open/property flags
  //--------------------------------------------------------------------------
  CERT_STORE_NO_CRYPT_RELEASE_FLAG            = $00000001;
  CERT_STORE_SET_LOCALIZED_NAME_FLAG          = $00000002;
  CERT_STORE_DEFER_CLOSE_UNTIL_LAST_FREE_FLAG = $00000004;
  CERT_STORE_DELETE_FLAG                      = $00000010;
  CERT_STORE_SHARE_STORE_FLAG                 = $00000040;
  CERT_STORE_SHARE_CONTEXT_FLAG               = $00000080;
  CERT_STORE_MANIFOLD_FLAG                    = $00000100;
  CERT_STORE_ENUM_ARCHIVED_FLAG               = $00000200;
  CERT_STORE_UPDATE_KEYID_FLAG                = $00000400;
  CERT_STORE_BACKUP_RESTORE_FLAG              = $00000800;
  CERT_STORE_READONLY_FLAG                    = $00008000;
  CERT_STORE_OPEN_EXISTING_FLAG               = $00004000;
  CERT_STORE_CREATE_NEW_FLAG                  = $00002000;
  CERT_STORE_MAXIMUM_ALLOWED_FLAG             = $00001000;

  //+-------------------------------------------------------------------------
  //  Certificate Store Provider flags are in the HiWord (0xFFFF0000)
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  Certificate System Store Flag Values
  //--------------------------------------------------------------------------
  // Includes flags and location
  CERT_SYSTEM_STORE_MASK = $FFFF0000;

  // Set if pvPara points to a CERT_SYSTEM_STORE_RELOCATE_PARA structure
  CERT_SYSTEM_STORE_RELOCATE_FLAG = $80000000;

type
  CERT_SYSTEM_STORE_RELOCATE_PARA = record
    case integer of
      1:
      (hKeyBase: HKEY;
        case integer of
          1: (pvSystemStore:   pointer);
          2: (pszSystemStore:  LPCSTR);
          3: (pwszSystemStore: LPCWSTR));
      2:
      (pvBase: pointer);
  end;
  PCERT_SYSTEM_STORE_RELOCATE_PARA = ^CERT_SYSTEM_STORE_RELOCATE_PARA;

  // By default, when the CurrentUser "Root" store is opened, any SystemRegistry
  // roots not also on the protected root list are deleted from the cache before
  // CertOpenStore() returns. Set the following flag to return all the roots
  // in the SystemRegistry without checking the protected root list.
const
  CERT_SYSTEM_STORE_UNPROTECTED_FLAG = $40000000;

  // Location of the system store:
  CERT_SYSTEM_STORE_LOCATION_MASK  = $00FF0000;
  CERT_SYSTEM_STORE_LOCATION_SHIFT = 16;

  //  Registry: HKEY_CURRENT_USER or HKEY_LOCAL_MACHINE
  CERT_SYSTEM_STORE_CURRENT_USER_ID    = 1;
  CERT_SYSTEM_STORE_LOCAL_MACHINE_ID   = 2;
  //  Registry: HKEY_LOCAL_MACHINE\Software\Microsoft\Cryptography\Services
  CERT_SYSTEM_STORE_CURRENT_SERVICE_ID = 4;
  CERT_SYSTEM_STORE_SERVICES_ID        = 5;
  //  Registry: HKEY_USERS
  CERT_SYSTEM_STORE_USERS_ID           = 6;

  //  Registry: HKEY_CURRENT_USER\Software\Policies\Microsoft\SystemCertificates
  CERT_SYSTEM_STORE_CURRENT_USER_GROUP_POLICY_ID  = 7;
  //  Registry: HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\SystemCertificates
  CERT_SYSTEM_STORE_LOCAL_MACHINE_GROUP_POLICY_ID = 8;

  //  Registry: HKEY_LOCAL_MACHINE\Software\Microsoft\EnterpriseCertificates
  CERT_SYSTEM_STORE_LOCAL_MACHINE_ENTERPRISE_ID   = 9;

  CERT_SYSTEM_STORE_CURRENT_USER =
    (CERT_SYSTEM_STORE_CURRENT_USER_ID shl CERT_SYSTEM_STORE_LOCATION_SHIFT);
  CERT_SYSTEM_STORE_LOCAL_MACHINE =
    (CERT_SYSTEM_STORE_LOCAL_MACHINE_ID shl CERT_SYSTEM_STORE_LOCATION_SHIFT);
  CERT_SYSTEM_STORE_CURRENT_SERVICE =
    (CERT_SYSTEM_STORE_CURRENT_SERVICE_ID shl CERT_SYSTEM_STORE_LOCATION_SHIFT);
  CERT_SYSTEM_STORE_SERVICES =
    (CERT_SYSTEM_STORE_SERVICES_ID shl CERT_SYSTEM_STORE_LOCATION_SHIFT);
  CERT_SYSTEM_STORE_USERS =
    (CERT_SYSTEM_STORE_USERS_ID shl CERT_SYSTEM_STORE_LOCATION_SHIFT);

  CERT_SYSTEM_STORE_CURRENT_USER_GROUP_POLICY =
    (CERT_SYSTEM_STORE_CURRENT_USER_GROUP_POLICY_ID shl
    CERT_SYSTEM_STORE_LOCATION_SHIFT);
  CERT_SYSTEM_STORE_LOCAL_MACHINE_GROUP_POLICY =
    (CERT_SYSTEM_STORE_LOCAL_MACHINE_GROUP_POLICY_ID shl
    CERT_SYSTEM_STORE_LOCATION_SHIFT);

  CERT_SYSTEM_STORE_LOCAL_MACHINE_ENTERPRISE =
    (CERT_SYSTEM_STORE_LOCAL_MACHINE_ENTERPRISE_ID shl
    CERT_SYSTEM_STORE_LOCATION_SHIFT);

  //+-------------------------------------------------------------------------
  //  Group Policy Store Defines
  //--------------------------------------------------------------------------
  // Registry path to the Group Policy system stores
  CERT_GROUP_POLICY_SYSTEM_STORE_REGPATH
    = WideString('Software\\Policies\\Microsoft\\SystemCertificates');

  //+-------------------------------------------------------------------------
  //  EFS Defines
  //--------------------------------------------------------------------------
  // Registry path to the EFS EFSBlob SubKey - Value type is REG_BINARY
  CERT_EFSBLOB_REGPATH =
    CERT_GROUP_POLICY_SYSTEM_STORE_REGPATH + WideString('\\EFS');
  CERT_EFSBLOB_VALUE_NAME = WideString('EFSBlob');

  //+-------------------------------------------------------------------------
  //  Protected Root Defines
  //--------------------------------------------------------------------------
  // Registry path to the Protected Roots Flags SubKey
  CERT_PROT_ROOT_FLAGS_REGPATH =
    CERT_GROUP_POLICY_SYSTEM_STORE_REGPATH +
    WideString('\\Root\\ProtectedRoots');
  CERT_PROT_ROOT_FLAGS_VALUE_NAME = WideString('Flags');

  // Set the following flag to inhibit the opening of the CurrentUser's
  // .Default physical store when opening the CurrentUser's "Root" system store.
  // The .Default physical store open's the CurrentUser SystemRegistry "Root"
  // store.
  CERT_PROT_ROOT_DISABLE_CURRENT_USER_FLAG = $1;

  // Set the following flag to inhibit the adding of roots from the
  // CurrentUser SystemRegistry "Root" store to the protected root list
  // when the "Root" store is initially protected.
  CERT_PROT_ROOT_INHIBIT_ADD_AT_INIT_FLAG  = $2;

  // Set the following flag to inhibit the purging of protected roots from the
  // CurrentUser SystemRegistry "Root" store that are
  // also in the LocalMachine SystemRegistry "Root" store. Note, when not
  // disabled, the purging is done silently without UI.
  CERT_PROT_ROOT_INHIBIT_PURGE_LM_FLAG     = $4;

  // Set the following flag to inhibit the opening of the LocalMachine's
  // .AuthRoot physical store when opening the LocalMachine's "Root" system store.
  // The .AuthRoot physical store open's the LocalMachine SystemRegistry
  // "AuthRoot" store. The "AuthRoot" store contains the pre-installed
  // SSL ServerAuth and the ActiveX Authenticode "root" certificates.
  CERT_PROT_ROOT_DISABLE_LM_AUTH_FLAG      = $8;

  // The semantics for the following legacy definition has been changed to be
  // the same as for the CERT_PROT_ROOT_DISABLE_LM_AUTH_FLAG.
  CERT_PROT_ROOT_ONLY_LM_GPT_FLAG          = $8;

  // Set the following flag to disable the requiring of the issuing CA
  // certificate being in the "NTAuth" system registry store found in the
  // CERT_SYSTEM_STORE_LOCAL_MACHINE_ENTERPRISE store location.
  //
  // When set, CertVerifyCertificateChainPolicy(CERT_CHAIN_POLICY_NT_AUTH)
  // will check that the chain has a valid name constraint for all name
  // spaces, including UPN if the issuing CA isn't in the "NTAuth" store.
  CERT_PROT_ROOT_DISABLE_NT_AUTH_REQUIRED_FLAG = $10;

  //+-------------------------------------------------------------------------
  //  Trusted Publisher Definitions
  //--------------------------------------------------------------------------
  // Registry path to the trusted publisher "Safer" group policy subkey
  CERT_TRUST_PUB_SAFER_GROUP_POLICY_REGPATH =
    CERT_GROUP_POLICY_SYSTEM_STORE_REGPATH + WideString('\\TrustedPublisher\\Safer');

  // Registry path to the Local Machine system stores
  CERT_LOCAL_MACHINE_SYSTEM_STORE_REGPATH =
    WideString('Software\\Microsoft\\SystemCertificates');

  // Registry path to the trusted publisher "Safer" local machine subkey
  CERT_TRUST_PUB_SAFER_LOCAL_MACHINE_REGPATH =
    CERT_LOCAL_MACHINE_SYSTEM_STORE_REGPATH + WideString('\\TrustedPublisher\\Safer');

  // "Safer" subkey value names. All values are DWORDs.
  CERT_TRUST_PUB_AUTHENTICODE_FLAGS_VALUE_NAME = WideString('AuthenticodeFlags');

  // AuthenticodeFlags definitions

  // Definition of who is allowed to trust publishers
  //
  // Setting allowed trust to MACHINE_ADMIN or ENTERPRISE_ADMIN disables UI,
  // only trusts publishers in the "TrustedPublisher" system store and
  // inhibits the opening of the CurrentUser's .Default physical store when
  // opening the CurrentUsers's "TrustedPublisher" system store.
  //
  // The .Default physical store open's the CurrentUser SystemRegistry
  // "TrustedPublisher" store.
  //
  // Setting allowed trust to ENTERPRISE_ADMIN only opens the
  // LocalMachine's .GroupPolicy and .Enterprise physical stores when opening
  // the CurrentUser's "TrustedPublisher" system store or when opening the
  // LocalMachine's "TrustedPublisher" system store.

  CERT_TRUST_PUB_ALLOW_TRUST_MASK                 = $00000003;
  CERT_TRUST_PUB_ALLOW_END_USER_TRUST             = $00000000;
  CERT_TRUST_PUB_ALLOW_MACHINE_ADMIN_TRUST        = $00000001;
  CERT_TRUST_PUB_ALLOW_ENTERPRISE_ADMIN_TRUST     = $00000002;

  // Set the following flag to enable revocation checking of the publisher
  // chain.
  CERT_TRUST_PUB_CHECK_PUBLISHER_REV_FLAG         = $00000100;

  // Set the following flag to enable revocation checking of the time stamp
  // chain.
  CERT_TRUST_PUB_CHECK_TIMESTAMP_REV_FLAG         = $00000200;

  //+-------------------------------------------------------------------------
  //  OCM Subcomponents Definitions
  //--------------------------------------------------------------------------

  // Registry path to the OCM Subcomponents local machine subkey
  CERT_OCM_SUBCOMPONENTS_LOCAL_MACHINE_REGPATH =
    WideString('SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\OC Manager\\Subcomponents');

  // REG_DWORD, 1 is installed, 0 is NOT installed
  CERT_OCM_SUBCOMPONENTS_ROOT_AUTO_UPDATE_VALUE_NAME = WideString('RootAutoUpdate');

  //+-------------------------------------------------------------------------
  //  AuthRoot Auto Update Definitions
  //--------------------------------------------------------------------------

  // Registry path to the AuthRoot "Auto Update" local machine subkey
  CERT_AUTH_ROOT_AUTO_UPDATE_LOCAL_MACHINE_REGPATH =
    CERT_LOCAL_MACHINE_SYSTEM_STORE_REGPATH + WideString('\\AuthRoot\\AutoUpdate');

  // AuthRoot Auto Update subkey value names.

  // REG_SZ, URL to the directory containing the AuthRoots, CTL and Seq files
  CERT_AUTH_ROOT_AUTO_UPDATE_ROOT_DIR_URL_VALUE_NAME = WideString('RootDirUrl');

  // REG_DWORD, seconds between syncs. 0 implies use default.
  CERT_AUTH_ROOT_AUTO_UPDATE_SYNC_DELTA_TIME_VALUE_NAME = WideString('SyncDeltaTime');

  // REG_DWORD, misc flags
  CERT_AUTH_ROOT_AUTO_UPDATE_FLAGS_VALUE_NAME = WideString('Flags');

  CERT_AUTH_ROOT_AUTO_UPDATE_DISABLE_UNTRUSTED_ROOT_LOGGING_FLAG  = $1;
  CERT_AUTH_ROOT_AUTO_UPDATE_DISABLE_PARTIAL_CHAIN_LOGGING_FLAG   = $2;

  // AuthRoot Auto Update filenames

  // CTL containing the list of certs in the AuthRoot store
  CERT_AUTH_ROOT_CTL_FILENAME                    = WideString('authroot.stl');
  CERT_AUTH_ROOT_CTL_FILENAME_A                  = 'authroot.stl';

  // Cab containing the above CTL
  CERT_AUTH_ROOT_CAB_FILENAME                = WideString('authrootstl.cab');

  // SequenceNumber (Formatted as big endian ascii hex)
  CERT_AUTH_ROOT_SEQ_FILENAME                = WideString('authrootseq.txt');

  // Root certs extension
  CERT_AUTH_ROOT_CERT_EXT                    = WideString('.crt');

  //+-------------------------------------------------------------------------
  //  Certificate Registry Store Flag Values (CERT_STORE_REG)
  //--------------------------------------------------------------------------

  // Set this flag if the HKEY passed in pvPara points to a remote computer
  // registry key.
  CERT_REGISTRY_STORE_REMOTE_FLAG = $10000;

  // Set this flag if the contexts are to be persisted as a single serialized
  // store in the registry. Mainly used for stores downloaded from the GPT.
  // Such as the CurrentUserGroupPolicy or LocalMachineGroupPolicy stores.
  CERT_REGISTRY_STORE_SERIALIZED_FLAG = $20000;

  // The following flags are for internal use. When set, the
  // pvPara parameter passed to CertOpenStore is a pointer to the following
  // data structure and not the HKEY. The above CERT_REGISTRY_STORE_REMOTE_FLAG
  // is also set if hKeyBase was obtained via RegConnectRegistry().
  CERT_REGISTRY_STORE_CLIENT_GPT_FLAG = $80000000;
  CERT_REGISTRY_STORE_LM_GPT_FLAG     = $01000000;

type
  CERT_REGISTRY_STORE_CLIENT_GPT_PARA = record
    hKeyBase:    HKEY;
    pwszRegPath: LPWSTR;
  end;
  PCERT_REGISTRY_STORE_CLIENT_GPT_PARA = ^CERT_REGISTRY_STORE_CLIENT_GPT_PARA;

  // The following flag is for internal use. When set, the contexts are
  // persisted into roaming files instead of the registry. Such as, the
  // CurrentUser "My" store. When this flag is set, the following data structure
  // is passed to CertOpenStore instead of HKEY.
const
  CERT_REGISTRY_STORE_ROAMING_FLAG = $40000;

  // hKey may be NULL or non-NULL. When non-NULL, existing contexts are
  // moved from the registry to roaming files.
type
  CERT_REGISTRY_STORE_ROAMING_PARA = record
    hKey:               HKEY;
    pwszStoreDirectory: LPWSTR;
  end;
  PCERT_REGISTRY_STORE_ROAMING_PARA = ^CERT_REGISTRY_STORE_ROAMING_PARA;

  // The following flag is for internal use. When set, the "My" DWORD value
  // at HKLM\Software\Microsoft\Cryptography\IEDirtyFlags is set to 0x1
  // whenever a certificate is added to the registry store.
const
  CERT_REGISTRY_STORE_MY_IE_DIRTY_FLAG = $80000;

  // Registry path to the subkey containing the "My" DWORD value to be set
  CERT_IE_DIRTY_FLAGS_REGPATH
    = WideString('Software\\Microsoft\\Cryptography\\IEDirtyFlags');

  //+-------------------------------------------------------------------------
  //  Certificate File Store Flag Values for the providers:
  //      CERT_STORE_PROV_FILE
  //      CERT_STORE_PROV_FILENAME
  //      CERT_STORE_PROV_FILENAME_A
  //      CERT_STORE_PROV_FILENAME_W
  //      sz_CERT_STORE_PROV_FILENAME_W
  //--------------------------------------------------------------------------

  // Set this flag if any store changes are to be committed to the file.
  // The changes are committed at CertCloseStore or by calling
  // CertControlStore(CERT_STORE_CTRL_COMMIT).
  //
  // The open fails with E_INVALIDARG if both CERT_FILE_STORE_COMMIT_ENABLE_FLAG
  // and CERT_STORE_READONLY_FLAG are set in dwFlags.
  //
  // For the FILENAME providers:  if the file contains an X509 encoded
  // certificate, the open fails with ERROR_ACCESS_DENIED.
  //
  // For the FILENAME providers: if CERT_STORE_CREATE_NEW_FLAG is set, the
  // CreateFile uses CREATE_NEW. If CERT_STORE_OPEN_EXISTING is set, uses
  // OPEN_EXISTING. Otherwise, defaults to OPEN_ALWAYS.
  //
  // For the FILENAME providers:  the file is committed as either a PKCS7 or
  // serialized store depending on the type read at open. However, if the
  // file is empty then, if the filename has either a ".p7c" or ".spc"
  // extension its committed as a PKCS7. Otherwise, its committed as a
  // serialized store.
  //
  // For CERT_STORE_PROV_FILE, the file handle is duplicated. Its always
  // committed as a serialized store.
  //
  CERT_FILE_STORE_COMMIT_ENABLE_FLAG = $10000;

  //+-------------------------------------------------------------------------
  //  Certificate LDAP Store Flag Values for the providers:
  //      CERT_STORE_PROV_LDAP
  //      CERT_STORE_PROV_LDAP_W
  //      sz_CERT_STORE_PROV_LDAP_W
  //      sz_CERT_STORE_PROV_LDAP
  //--------------------------------------------------------------------------

  // Set this flag to digitally sign all of the ldap traffic to and from a
  // Windows 2000 LDAP server using the Kerberos authentication protocol.
  // This feature provides integrity required by some applications.
  //
  CERT_LDAP_STORE_SIGN_FLAG          = $10000;

  // Performs an A-Record only DNS lookup on the supplied host string.
  // This prevents bogus DNS queries from being generated when resolving host
  // names. Use this flag whenever passing a hostname as opposed to a
  // domain name for the hostname parameter.
  //
  // See LDAP_OPT_AREC_EXCLUSIVE defined in winldap.h for more details.
  CERT_LDAP_STORE_AREC_EXCLUSIVE_FLAG = $20000;

  //+-------------------------------------------------------------------------
  //  Open the cert store using the specified store provider.
  //
  //  If CERT_STORE_DELETE_FLAG is set, then, the store is deleted. NULL is
  //  returned for both success and failure. However, GetLastError() returns 0
  //  for success and nonzero for failure.
  //
  //  If CERT_STORE_SET_LOCALIZED_NAME_FLAG is set, then, if supported, the
  //  provider sets the store's CERT_STORE_LOCALIZED_NAME_PROP_ID property.
  //  The store's localized name can be retrieved by calling
  //  CertSetStoreProperty(dwPropID = CERT_STORE_LOCALIZED_NAME_PROP_ID).
  //  This flag is supported by the following providers (and their sz_
  //  equivalent):
  //      CERT_STORE_PROV_FILENAME_A
  //      CERT_STORE_PROV_FILENAME_W
  //      CERT_STORE_PROV_SYSTEM_A
  //      CERT_STORE_PROV_SYSTEM_W
  //      CERT_STORE_PROV_SYSTEM_REGISTRY_A
  //      CERT_STORE_PROV_SYSTEM_REGISTRY_W
  //      CERT_STORE_PROV_PHYSICAL_W
  //
  //  If CERT_STORE_DEFER_CLOSE_UNTIL_LAST_FREE_FLAG is set, then, the
  //  closing of the store's provider is deferred until all certificate,
  //  CRL and CTL contexts obtained from the store are freed. Also,
  //  if a non NULL HCRYPTPROV was passed, then, it will continue to be used.
  //  By default, the store's provider is closed on the final CertCloseStore.
  //  If this flag isn't set, then, any property changes made to previously
  //  duplicated contexts after the final CertCloseStore will not be persisted.
  //  By setting this flag, property changes made
  //  after the CertCloseStore will be persisted. Note, setting this flag
  //  causes extra overhead in doing context duplicates and frees.
  //  If CertCloseStore is called with CERT_CLOSE_STORE_FORCE_FLAG, then,
  //  the CERT_STORE_DEFER_CLOSE_UNTIL_LAST_FREE_FLAG flag is ignored.
  //
  //  CERT_STORE_MANIFOLD_FLAG can be set to check for certificates having the
  //  manifold extension and archive the "older" certificates with the same
  //  manifold extension value. A certificate is archived by setting the
  //  CERT_ARCHIVED_PROP_ID.
  //
  //  By default, contexts having the CERT_ARCHIVED_PROP_ID, are skipped
  //  during enumeration. CERT_STORE_ENUM_ARCHIVED_FLAG can be set to include
  //  archived contexts when enumerating. Note, contexts having the
  //  CERT_ARCHIVED_PROP_ID are still found for explicit finds, such as,
  //  finding a context with a specific hash or finding a certificate having
  //  a specific issuer and serial number.
  //
  //  CERT_STORE_UPDATE_KEYID_FLAG can be set to also update the Key Identifier's
  //  CERT_KEY_PROV_INFO_PROP_ID property whenever a certificate's
  //  CERT_KEY_IDENTIFIER_PROP_ID or CERT_KEY_PROV_INFO_PROP_ID property is set
  //  and the other property already exists. If the Key Identifier's
  //  CERT_KEY_PROV_INFO_PROP_ID already exists, it isn't updated. Any
  //  errors encountered are silently ignored.
  //
  //  By default, this flag is implicitly set for the "My\.Default" CurrentUser
  //  and LocalMachine physical stores.
  //
  //  CERT_STORE_READONLY_FLAG can be set to open the store as read only.
  //  Otherwise, the store is opened as read/write.
  //
  //  CERT_STORE_OPEN_EXISTING_FLAG can be set to only open an existing
  //  store. CERT_STORE_CREATE_NEW_FLAG can be set to create a new store and
  //  fail if the store already exists. Otherwise, the default is to open
  //  an existing store or create a new store if it doesn't already exist.
  //
  //  hCryptProv specifies the crypto provider to use to create the hash
  //  properties or verify the signature of a subject certificate or CRL.
  //  The store doesn't need to use a private
  //  key. If the CERT_STORE_NO_CRYPT_RELEASE_FLAG isn't set, hCryptProv is
  //  CryptReleaseContext'ed on the final CertCloseStore.
  //
  //  Note, if the open fails, hCryptProv is released if it would have been
  //  released when the store was closed.
  //
  //  If hCryptProv is zero, then, the default provider and container for the
  //  PROV_RSA_FULL provider type is CryptAcquireContext'ed with
  //  CRYPT_VERIFYCONTEXT access. The CryptAcquireContext is deferred until
  //  the first create hash or verify signature. In addition, once acquired,
  //  the default provider isn't released until process exit when crypt32.dll
  //  is unloaded. The acquired default provider is shared across all stores
  //  and threads.
  //
  //  After initializing the store's data structures and optionally acquiring a
  //  default crypt provider, CertOpenStore calls CryptGetOIDFunctionAddress to
  //  get the address of the CRYPT_OID_OPEN_STORE_PROV_FUNC specified by
  //  lpszStoreProvider. Since a store can contain certificates with different
  //  encoding types, CryptGetOIDFunctionAddress is called with dwEncodingType
  //  set to 0 and not the dwEncodingType passed to CertOpenStore.
  //  PFN_CERT_DLL_OPEN_STORE_FUNC specifies the signature of the provider's
  //  open function. This provider open function is called to load the
  //  store's certificates and CRLs. Optionally, the provider may return an
  //  array of functions called before a certificate or CRL is added or deleted
  //  or has a property that is set.
  //
  //  Use of the dwEncodingType parameter is provider dependent. The type
  //  definition for pvPara also depends on the provider.
  //
  //  Store providers are installed or registered via
  //  CryptInstallOIDFunctionAddress or CryptRegisterOIDFunction, where,
  //  dwEncodingType is 0 and pszFuncName is CRYPT_OID_OPEN_STORE_PROV_FUNC.
  //
  //  Here's a list of the predefined provider types (implemented in crypt32.dll):
  //
  //  CERT_STORE_PROV_MSG:
  //      Gets the certificates and CRLs from the specified cryptographic message.
  //      dwEncodingType contains the message and certificate encoding types.
  //      The message's handle is passed in pvPara. Given,
  //          HCRYPTMSG hCryptMsg; pvPara = (const void *) hCryptMsg;
  //
  //  CERT_STORE_PROV_MEMORY
  //  sz_CERT_STORE_PROV_MEMORY:
  //      Opens a store without any initial certificates or CRLs. pvPara
  //      isn't used.
  //
  //  CERT_STORE_PROV_FILE:
  //      Reads the certificates and CRLs from the specified file. The file's
  //      handle is passed in pvPara. Given,
  //          HANDLE hFile; pvPara = (const void *) hFile;
  //
  //      For a successful open, the file pointer is advanced past
  //      the certificates and CRLs and their properties read from the file.
  //      Note, only expects a serialized store and not a file containing
  //      either a PKCS #7 signed message or a single encoded certificate.
  //
  //      The hFile isn't closed.
  //
  //  CERT_STORE_PROV_REG:
  //      Reads the certificates and CRLs from the registry. The registry's
  //      key handle is passed in pvPara. Given,
  //          HKEY hKey; pvPara = (const void *) hKey;
  //
  //      The input hKey isn't closed by the provider. Before returning, the
  //      provider opens it own copy of the hKey.
  //
  //      If CERT_STORE_READONLY_FLAG is set, then, the registry subkeys are
  //      RegOpenKey'ed with KEY_READ_ACCESS. Otherwise, the registry subkeys
  //      are RegCreateKey'ed with KEY_ALL_ACCESS.
  //
  //      This provider returns the array of functions for reading, writing,
  //      deleting and property setting certificates and CRLs.
  //      Any changes to the opened store are immediately pushed through to
  //      the registry. However, if CERT_STORE_READONLY_FLAG is set, then,
  //      writing, deleting or property setting results in a
  //      SetLastError(E_ACCESSDENIED).
  //
  //      Note, all the certificates and CRLs are read from the registry
  //      when the store is opened. The opened store serves as a write through
  //      cache.
  //
  //      If CERT_REGISTRY_STORE_SERIALIZED_FLAG is set, then, the
  //      contexts are persisted as a single serialized store subkey in the
  //      registry.
  //
  //  CERT_STORE_PROV_PKCS7:
  //  sz_CERT_STORE_PROV_PKCS7:
  //      Gets the certificates and CRLs from the encoded PKCS #7 signed message.
  //      dwEncodingType specifies the message and certificate encoding types.
  //      The pointer to the encoded message's blob is passed in pvPara. Given,
  //          CRYPT_DATA_BLOB EncodedMsg; pvPara = (const void *) &EncodedMsg;
  //
  //      Note, also supports the IE3.0 special version of a
  //      PKCS #7 signed message referred to as a "SPC" formatted message.
  //
  //  CERT_STORE_PROV_SERIALIZED:
  //  sz_CERT_STORE_PROV_SERIALIZED:
  //      Gets the certificates and CRLs from memory containing a serialized
  //      store.  The pointer to the serialized memory blob is passed in pvPara.
  //      Given,
  //          CRYPT_DATA_BLOB Serialized; pvPara = (const void *) &Serialized;
  //
  //  CERT_STORE_PROV_FILENAME_A:
  //  CERT_STORE_PROV_FILENAME_W:
  //  CERT_STORE_PROV_FILENAME:
  //  sz_CERT_STORE_PROV_FILENAME_W:
  //  sz_CERT_STORE_PROV_FILENAME:
  //      Opens the file and first attempts to read as a serialized store. Then,
  //      as a PKCS #7 signed message. Finally, as a single encoded certificate.
  //      The filename is passed in pvPara. The filename is UNICODE for the
  //      "_W" provider and ASCII for the "_A" provider. For "_W": given,
  //          LPCWSTR pwszFilename; pvPara = (const void *) pwszFilename;
  //      For "_A": given,
  //          LPCSTR pszFilename; pvPara = (const void *) pszFilename;
  //
  //      Note, the default (without "_A" or "_W") is unicode.
  //
  //      Note, also supports the reading of the IE3.0 special version of a
  //      PKCS #7 signed message file referred to as a "SPC" formatted file.
  //
  //  CERT_STORE_PROV_SYSTEM_A:
  //  CERT_STORE_PROV_SYSTEM_W:
  //  CERT_STORE_PROV_SYSTEM:
  //  sz_CERT_STORE_PROV_SYSTEM_W:
  //  sz_CERT_STORE_PROV_SYSTEM:
  //      Opens the specified logical "System" store. The upper word of the
  //      dwFlags parameter is used to specify the location of the system store.
  //
  //      A "System" store is a collection consisting of one or more "Physical"
  //      stores. A "Physical" store is registered via the
  //      CertRegisterPhysicalStore API. Each of the registered physical stores
  //      is CertStoreOpen'ed and added to the collection via
  //      CertAddStoreToCollection.
  //
  //      The CERT_SYSTEM_STORE_CURRENT_USER, CERT_SYSTEM_STORE_LOCAL_MACHINE,
  //      CERT_SYSTEM_STORE_CURRENT_SERVICE, CERT_SYSTEM_STORE_SERVICES,
  //      CERT_SYSTEM_STORE_USERS, CERT_SYSTEM_STORE_CURRENT_USER_GROUP_POLICY,
  //      CERT_SYSTEM_STORE_LOCAL_MACHINE_GROUP_POLICY and
  //      CERT_SYSTEM_STORE_LOCAL_MACHINE_ENTERPRSE
  //      system stores by default have a "SystemRegistry" store that is
  //      opened and added to the collection.
  //
  //      The system store name is passed in pvPara. The name is UNICODE for the
  //      "_W" provider and ASCII for the "_A" provider. For "_W": given,
  //          LPCWSTR pwszSystemName; pvPara = (const void *) pwszSystemName;
  //      For "_A": given,
  //          LPCSTR pszSystemName; pvPara = (const void *) pszSystemName;
  //
  //      Note, the default (without "_A" or "_W") is UNICODE.
  //
  //      The system store name can't contain any backslashes.
  //
  //      If CERT_SYSTEM_STORE_RELOCATE_FLAG is set in dwFlags, pvPara
  //      points to a CERT_SYSTEM_STORE_RELOCATE_PARA data structure instead
  //      of pointing to a null terminated UNICODE or ASCII string.
  //      Sibling physical stores are also opened as relocated using
  //      pvPara's hKeyBase.
  //
  //      The CERT_SYSTEM_STORE_SERVICES or CERT_SYSTEM_STORE_USERS system
  //      store name must be prefixed with the ServiceName or UserName.
  //      For example, "ServiceName\Trust".
  //
  //      Stores on remote computers can be accessed for the
  //      CERT_SYSTEM_STORE_LOCAL_MACHINE, CERT_SYSTEM_STORE_SERVICES,
  //      CERT_SYSTEM_STORE_USERS, CERT_SYSTEM_STORE_LOCAL_MACHINE_GROUP_POLICY
  //      or CERT_SYSTEM_STORE_LOCAL_MACHINE_ENTERPRISE
  //      locations by prepending the computer name. For example, a remote
  //      local machine store is accessed via "\\ComputerName\Trust" or
  //      "ComputerName\Trust". A remote service store is accessed via
  //      "\\ComputerName\ServiceName\Trust". The leading "\\" backslashes are
  //      optional in the ComputerName.
  //
  //      If CERT_STORE_READONLY_FLAG is set, then, the registry is
  //      RegOpenKey'ed with KEY_READ_ACCESS. Otherwise, the registry is
  //      RegCreateKey'ed with KEY_ALL_ACCESS.
  //
  //      The "root" store is treated differently from the other system
  //      stores. Before a certificate is added to or deleted from the "root"
  //      store, a pop up message box is displayed. The certificate's subject,
  //      issuer, serial number, time validity, sha1 and md5 thumbprints are
  //      displayed. The user is given the option to do the add or delete.
  //      If they don't allow the operation, LastError is set to E_ACCESSDENIED.
  //
  //  CERT_STORE_PROV_SYSTEM_REGISTRY_A
  //  CERT_STORE_PROV_SYSTEM_REGISTRY_W
  //  CERT_STORE_PROV_SYSTEM_REGISTRY
  //  sz_CERT_STORE_PROV_SYSTEM_REGISTRY_W
  //  sz_CERT_STORE_PROV_SYSTEM_REGISTRY
  //      Opens the "System" store's default "Physical" store residing in the
  //      registry. The upper word of the dwFlags
  //      parameter is used to specify the location of the system store.
  //
  //      After opening the registry key associated with the system name,
  //      the CERT_STORE_PROV_REG provider is called to complete the open.
  //
  //      The system store name is passed in pvPara. The name is UNICODE for the
  //      "_W" provider and ASCII for the "_A" provider. For "_W": given,
  //          LPCWSTR pwszSystemName; pvPara = (const void *) pwszSystemName;
  //      For "_A": given,
  //          LPCSTR pszSystemName; pvPara = (const void *) pszSystemName;
  //
  //      Note, the default (without "_A" or "_W") is UNICODE.
  //
  //      If CERT_SYSTEM_STORE_RELOCATE_FLAG is set in dwFlags, pvPara
  //      points to a CERT_SYSTEM_STORE_RELOCATE_PARA data structure instead
  //      of pointing to a null terminated UNICODE or ASCII string.
  //
  //      See above for details on prepending a ServiceName and/or ComputerName
  //      to the store name.
  //
  //      If CERT_STORE_READONLY_FLAG is set, then, the registry is
  //      RegOpenKey'ed with KEY_READ_ACCESS. Otherwise, the registry is
  //      RegCreateKey'ed with KEY_ALL_ACCESS.
  //
  //      The "root" store is treated differently from the other system
  //      stores. Before a certificate is added to or deleted from the "root"
  //      store, a pop up message box is displayed. The certificate's subject,
  //      issuer, serial number, time validity, sha1 and md5 thumbprints are
  //      displayed. The user is given the option to do the add or delete.
  //      If they don't allow the operation, LastError is set to E_ACCESSDENIED.
  //
  //  CERT_STORE_PROV_PHYSICAL_W
  //  CERT_STORE_PROV_PHYSICAL
  //  sz_CERT_STORE_PROV_PHYSICAL_W
  //  sz_CERT_STORE_PROV_PHYSICAL
  //      Opens the specified "Physical" store in the "System" store.
  //
  //      Both the system store and physical names are passed in pvPara. The
  //      names are separated with an intervening "\". For example,
  //      "Root\.Default". The string is UNICODE.
  //
  //      The system and physical store names can't contain any backslashes.
  //
  //      If CERT_SYSTEM_STORE_RELOCATE_FLAG is set in dwFlags, pvPara
  //      points to a CERT_SYSTEM_STORE_RELOCATE_PARA data structure instead
  //      of pointing to a null terminated UNICODE string.
  //      The specified physical store is opened as relocated using pvPara's
  //      hKeyBase.
  //
  //      For CERT_SYSTEM_STORE_SERVICES or CERT_SYSTEM_STORE_USERS,
  //      the system and physical store names
  //      must be prefixed with the ServiceName or UserName. For example,
  //      "ServiceName\Root\.Default".
  //
  //      Physical stores on remote computers can be accessed for the
  //      CERT_SYSTEM_STORE_LOCAL_MACHINE, CERT_SYSTEM_STORE_SERVICES,
  //      CERT_SYSTEM_STORE_USERS, CERT_SYSTEM_STORE_LOCAL_MACHINE_GROUP_POLICY
  //      or CERT_SYSTEM_STORE_LOCAL_MACHINE_ENTERPRISE
  //      locations by prepending the computer name. For example, a remote
  //      local machine store is accessed via "\\ComputerName\Root\.Default"
  //      or "ComputerName\Root\.Default". A remote service store is
  //      accessed via "\\ComputerName\ServiceName\Root\.Default". The
  //      leading "\\" backslashes are optional in the ComputerName.
  //
  //  CERT_STORE_PROV_COLLECTION
  //  sz_CERT_STORE_PROV_COLLECTION
  //      Opens a store that is a collection of other stores. Stores are
  //      added or removed to/from the collection via the CertAddStoreToCollection
  //      and CertRemoveStoreFromCollection APIs.
  //
  //  CERT_STORE_PROV_SMART_CARD_W
  //  CERT_STORE_PROV_SMART_CARD
  //  sz_CERT_STORE_PROV_SMART_CARD_W
  //  sz_CERT_STORE_PROV_SMART_CARD
  //      Opens a store instantiated over a particular smart card storage.  pvPara
  //      identifies where on the card the store is located and is of the
  //      following format:
  //
  //                Card Name\Provider Name\Provider Type[\Container Name]
  //
  //      Container Name is optional and if NOT specified the Card Name is used
  //      as the Container Name.  Future versions of the provider will support
  //      instantiating the store over the entire card in which case just
  //      Card Name ( or id ) will be sufficient.
  //
  //  Here's a list of the predefined provider types (implemented in
  //  cryptnet.dll):
  //
  //  CERT_STORE_PROV_LDAP_W
  //  CERT_STORE_PROV_LDAP
  //  sz_CERT_STORE_PROV_LDAP_W
  //  sz_CERT_STORE_PROV_LDAP
  //      Opens a store over the results of the query specified by and LDAP
  //      URL which is passed in via pvPara.  In order to do writes to the
  //      store the URL must specify a BASE query, no filter and a single
  //      attribute.
  //
  //--------------------------------------------------------------------------
function CertOpenStore(
  lpszStoreProvider: LPCSTR;
  dwEncodingType: DWORD;
  hCryptProv: HCRYPTPROV;
  dwFlags: DWORD;
  pvPara: pointer
  ): HCERTSTORE; stdcall;

//+-------------------------------------------------------------------------
//  OID Installable Certificate Store Provider Data Structures
//--------------------------------------------------------------------------

// Handle returned by the store provider when opened.
type
  HCERTSTOREPROV = pointer;

  // Store Provider OID function's pszFuncName.
const
  CRYPT_OID_OPEN_STORE_PROV_FUNC = 'CertDllOpenStoreProv';

  // Note, the Store Provider OID function's dwEncodingType is always 0.

  // The following information is returned by the provider when opened. Its
  // zeroed with cbSize set before the provider is called. If the provider
  // doesn't need to be called again after the open it doesn't need to
  // make any updates to the CERT_STORE_PROV_INFO.
type
  CERT_STORE_PROV_INFO = record
    cbSize:              DWORD;
    cStoreProvFunc:      DWORD;
    rgpvStoreProvFunc:   pointer;
    hStoreProv:          HCERTSTOREPROV;
    dwStoreProvFlags:    DWORD;
    hStoreProvFuncAddr2: HCRYPTOIDFUNCADDR;
  end;
  PCERT_STORE_PROV_INFO = ^CERT_STORE_PROV_INFO;

  // Definition of the store provider's open function.
  //
  // *pStoreProvInfo has been zeroed before the call.
  //
  // Note, pStoreProvInfo->cStoreProvFunc should be set last.  Once set,
  // all subsequent store calls, such as CertAddSerializedElementToStore will
  // call the appropriate provider callback function.
type
  PFN_CERT_DLL_OPEN_STORE_PROV_FUNC = function(
    lpszStoreProvider: LPCSTR;
    dwEncodingType: DWORD;
    hCryptProv: HCRYPTPROV;
    dwFlags: DWORD;
    pvPara: pointer;
    hCertStore: HCERTSTORE;
    var pStoreProvInfo: CERT_STORE_PROV_INFO
    ): BOOL; stdcall;

  // The open callback sets the following flag, if it maintains its
  // contexts externally and not in the cached store.
const
  CERT_STORE_PROV_EXTERNAL_FLAG     = $1;

  // The open callback sets the following flag for a successful delete.
  // When set, the close callback isn't called.
  CERT_STORE_PROV_DELETED_FLAG      = $2;

  // The open callback sets the following flag if it doesn't persist store
  // changes.
  CERT_STORE_PROV_NO_PERSIST_FLAG   = $4;

  // The open callback sets the following flag if the contexts are persisted
  // to a system store.
  CERT_STORE_PROV_SYSTEM_STORE_FLAG = $8;

  // Indices into the store provider's array of callback functions.
  //
  // The provider can implement any subset of the following functions. It
  // sets pStoreProvInfo->cStoreProvFunc to the last index + 1 and any
  // preceding not implemented functions to NULL.
  CERT_STORE_PROV_CLOSE_FUNC             = 0;
  CERT_STORE_PROV_READ_CERT_FUNC         = 1;
  CERT_STORE_PROV_WRITE_CERT_FUNC        = 2;
  CERT_STORE_PROV_DELETE_CERT_FUNC       = 3;
  CERT_STORE_PROV_SET_CERT_PROPERTY_FUNC = 4;
  CERT_STORE_PROV_READ_CRL_FUNC          = 5;
  CERT_STORE_PROV_WRITE_CRL_FUNC         = 6;
  CERT_STORE_PROV_DELETE_CRL_FUNC        = 7;
  CERT_STORE_PROV_SET_CRL_PROPERTY_FUNC  = 8;
  CERT_STORE_PROV_READ_CTL_FUNC          = 9;
  CERT_STORE_PROV_WRITE_CTL_FUNC         = 10;
  CERT_STORE_PROV_DELETE_CTL_FUNC        = 11;
  CERT_STORE_PROV_SET_CTL_PROPERTY_FUNC  = 12;
  CERT_STORE_PROV_CONTROL_FUNC           = 13;
  CERT_STORE_PROV_FIND_CERT_FUNC         = 14;
  CERT_STORE_PROV_FREE_FIND_CERT_FUNC    = 15;
  CERT_STORE_PROV_GET_CERT_PROPERTY_FUNC = 16;
  CERT_STORE_PROV_FIND_CRL_FUNC          = 17;
  CERT_STORE_PROV_FREE_FIND_CRL_FUNC     = 18;
  CERT_STORE_PROV_GET_CRL_PROPERTY_FUNC  = 19;
  CERT_STORE_PROV_FIND_CTL_FUNC          = 20;
  CERT_STORE_PROV_FREE_FIND_CTL_FUNC     = 21;
  CERT_STORE_PROV_GET_CTL_PROPERTY_FUNC  = 22;

  // Called by CertCloseStore when the store's reference count is
  // decremented to 0.
type
  PFN_CERT_STORE_PROV_CLOSE = procedure(
    hStoreProv: HCERTSTOREPROV;
    dwFlags: DWORD
    ); stdcall;

  // Currently not called directly by the store APIs. However, may be exported
  // to support other providers based on it.
  //
  // Reads the provider's copy of the certificate context. If it exists,
  // creates a new certificate context.
type
  PFN_CERT_STORE_PROV_READ_CERT = function(
    hStoreProv: HCERTSTOREPROV;
    pStoreCertContext: PCCERT_CONTEXT;
    dwFlags: DWORD;
    var ppProvCertContext: PCCERT_CONTEXT
    ): BOOL; stdcall;

const
  CERT_STORE_PROV_WRITE_ADD_FLAG = $1;

  // Called by CertAddEncodedCertificateToStore,
  // CertAddCertificateContextToStore or CertAddSerializedElementToStore before
  // adding to the store. The CERT_STORE_PROV_WRITE_ADD_FLAG is set. In
  // addition to the encoded certificate, the added pCertContext might also
  // have properties.
  //
  // Returns TRUE if its OK to update the the store.
type
  PFN_CERT_STORE_PROV_WRITE_CERT = function(
    hStoreProv: HCERTSTOREPROV;
    pCertContext: PCCERT_CONTEXT;
    dwFlags: DWORD
    ): BOOL; stdcall;

  // Called by CertDeleteCertificateFromStore before deleting from the
  // store.
  //
  // Returns TRUE if its OK to delete from the store.
type
  PFN_CERT_STORE_PROV_DELETE_CERT = function(
    hStoreProv: HCERTSTOREPROV;
    pCertContext: PCCERT_CONTEXT;
    dwFlags: DWORD
    ): BOOL; stdcall;

  // Called by CertSetCertificateContextProperty before setting the
  // certificate's property. Also called by CertGetCertificateContextProperty,
  // when getting a hash property that needs to be created and then persisted
  // via the set.
  //
  // Upon input, the property hasn't been set for the pCertContext parameter.
  //
  // Returns TRUE if its OK to set the property.
type
  PFN_CERT_STORE_PROV_SET_CERT_PROPERTY = function(
    hStoreProv: HCERTSTOREPROV;
    pCertContext: PCCERT_CONTEXT;
    dwPropId: DWORD;
    dwFlags: DWORD;
    pvData: pointer
    ): BOOL; stdcall;

  // Currently not called directly by the store APIs. However, may be exported
  // to support other providers based on it.
  //
  // Reads the provider's copy of the CRL context. If it exists,
  // creates a new CRL context.
type
  PFN_CERT_STORE_PROV_READ_CRL = function(
    hStoreProv: HCERTSTOREPROV;
    pStoreCrlContext: PCCRL_CONTEXT;
    dwFlags: DWORD;
    var ppProvCrlContext: PCCRL_CONTEXT
    ): BOOL; stdcall;

  // Called by CertAddEncodedCRLToStore,
  // CertAddCRLContextToStore or CertAddSerializedElementToStore before
  // adding to the store. The CERT_STORE_PROV_WRITE_ADD_FLAG is set. In
  // addition to the encoded CRL, the added pCertContext might also
  // have properties.
  //
  // Returns TRUE if its OK to update the the store.
type
  PFN_CERT_STORE_PROV_WRITE_CRL = function(
    hStoreProv: HCERTSTOREPROV;
    pCrlContext: PCCRL_CONTEXT;
    dwFlags: DWORD
    ): BOOL; stdcall;

  // Called by CertDeleteCRLFromStore before deleting from the store.
  //
  // Returns TRUE if its OK to delete from the store.
type
  PFN_CERT_STORE_PROV_DELETE_CRL = function(
    hStoreProv: HCERTSTOREPROV;
    pCrlContext: PCCRL_CONTEXT;
    dwFlags: DWORD
    ): BOOL; stdcall;

  // Called by CertSetCRLContextProperty before setting the
  // CRL's property. Also called by CertGetCRLContextProperty,
  // when getting a hash property that needs to be created and then persisted
  // via the set.
  //
  // Upon input, the property hasn't been set for the pCrlContext parameter.
  //
  // Returns TRUE if its OK to set the property.
type
  PFN_CERT_STORE_PROV_SET_CRL_PROPERTY = function(
    hStoreProv: HCERTSTOREPROV;
    pCrlContext: PCCRL_CONTEXT;
    dwPropId: DWORD;
    dwFlags: DWORD;
    pvData: pointer
    ): BOOL; stdcall;

  // Currently not called directly by the store APIs. However, may be exported
  // to support other providers based on it.
  //
  // Reads the provider's copy of the CTL context. If it exists,
  // creates a new CTL context.
type
  PFN_CERT_STORE_PROV_READ_CTL = function(
    hStoreProv: HCERTSTOREPROV;
    pStoreCtlContext: PCCTL_CONTEXT;
    dwFlags: DWORD;
    var ppProvCtlContext: PCCTL_CONTEXT
    ): BOOL; stdcall;

  // Called by CertAddEncodedCTLToStore,
  // CertAddCTLContextToStore or CertAddSerializedElementToStore before
  // adding to the store. The CERT_STORE_PROV_WRITE_ADD_FLAG is set. In
  // addition to the encoded CTL, the added pCertContext might also
  // have properties.
  //
  // Returns TRUE if its OK to update the the store.
type
  PFN_CERT_STORE_PROV_WRITE_CTL = function(
    hStoreProv: HCERTSTOREPROV;
    pCtlContext: PCCTL_CONTEXT;
    dwFlags: DWORD
    ): BOOL; stdcall;

  // Called by CertDeleteCTLFromStore before deleting from the store.
  //
  // Returns TRUE if its OK to delete from the store.
type
  PFN_CERT_STORE_PROV_DELETE_CTL = function(
    hStoreProv: HCERTSTOREPROV;
    pCtlContext: PCCTL_CONTEXT;
    dwFlags: DWORD): BOOL; stdcall;

  // Called by CertSetCTLContextProperty before setting the
  // CTL's property. Also called by CertGetCTLContextProperty,
  // when getting a hash property that needs to be created and then persisted
  // via the set.
  //
  // Upon input, the property hasn't been set for the pCtlContext parameter.
  //
  // Returns TRUE if its OK to set the property.
type
  PFN_CERT_STORE_PROV_SET_CTL_PROPERTY = function(
    hStoreProv: HCERTSTOREPROV;
    pCtlContext: PCCTL_CONTEXT;
    dwPropId: DWORD;
    dwFlags: DWORD;
    pvData: pointer
    ): BOOL; stdcall;

type
  PFN_CERT_STORE_PROV_CONTROL = function(
    hStoreProv: HCERTSTOREPROV;
    dwFlags: DWORD;
    dwCtrlType: DWORD;
    pvCtrlPara: pointer
    ): BOOL; stdcall;

type
  CERT_STORE_PROV_FIND_INFO = record
    cbSize:                   DWORD;
    dwMsgAndCertEncodingType: DWORD;
    dwFindFlags:              DWORD;
    dwFindType:               DWORD;
    pvFindPara:               pointer;
  end;
  PCERT_STORE_PROV_FIND_INFO = ^CERT_STORE_PROV_FIND_INFO;
  CCERT_STORE_PROV_FIND_INFO = CERT_STORE_PROV_FIND_INFO;
  PCCERT_STORE_PROV_FIND_INFO = ^CCERT_STORE_PROV_FIND_INFO;

type
  PFN_CERT_STORE_PROV_FIND_CERT = function(
    hStoreProv: HCERTSTOREPROV;
    pFindInfo: PCCERT_STORE_PROV_FIND_INFO;
    pPrevCertContext: PCCERT_CONTEXT;
    dwFlags: DWORD;
    var ppvStoreProvFindInfo: pointer;
    var ppProvCertContext: PCCERT_CONTEXT
    ): BOOL; stdcall;

type
  PFN_CERT_STORE_PROV_FREE_FIND_CERT = function(
    hStoreProv: HCERTSTOREPROV;
    pCertContext: PCCERT_CONTEXT;
    pvStoreProvFindInfo: pointer;
    dwFlags: DWORD
    ): BOOL; stdcall;

type
  PFN_CERT_STORE_PROV_GET_CERT_PROPERTY = function(
    hStoreProv: HCERTSTOREPROV;
    pCertContext: PCCERT_CONTEXT;
    dwPropId: DWORD;
    dwFlags: DWORD;
    pvData: pointer;
    var pcbData: DWORD
    ): BOOL; stdcall;

type
  PFN_CERT_STORE_PROV_FIND_CRL = function(
    hStoreProv: HCERTSTOREPROV;
    pFindInfo: PCCERT_STORE_PROV_FIND_INFO;
    pPrevCrlContext: PCCRL_CONTEXT;
    dwFlags: DWORD;
    var ppvStoreProvFindInfo: pointer;
    var ppProvCrlContext: PCCRL_CONTEXT
    ): BOOL; stdcall;

type
  PFN_CERT_STORE_PROV_FREE_FIND_CRL = function(
    hStoreProv: HCERTSTOREPROV;
    pCrlContext: PCCRL_CONTEXT;
    pvStoreProvFindInfo: pointer;
    dwFlags: DWORD
    ): BOOL; stdcall;

type
  PFN_CERT_STORE_PROV_GET_CRL_PROPERTY = function(
    hStoreProv: HCERTSTOREPROV;
    pCrlContext: PCCRL_CONTEXT;
    dwPropId: DWORD;
    dwFlags: DWORD;
    pvData: pointer;
    var pcbData: DWORD
    ): BOOL; stdcall;

type
  PFN_CERT_STORE_PROV_FIND_CTL = function(
    hStoreProv: HCERTSTOREPROV;
    pFindInfo: PCCERT_STORE_PROV_FIND_INFO;
    pPrevCtlContext: PCCTL_CONTEXT;
    dwFlags: DWORD;
    var ppvStoreProvFindInfo: pointer;
    var ppProvCtlContext: PCCTL_CONTEXT
    ): BOOL; stdcall;

type
  PFN_CERT_STORE_PROV_FREE_FIND_CTL = function(
    hStoreProv: HCERTSTOREPROV;
    pCtlContext: PCCTL_CONTEXT;
    pvStoreProvFindInfo: pointer;
    dwFlags: DWORD
    ): BOOL; stdcall;

type
  PFN_CERT_STORE_PROV_GET_CTL_PROPERTY = function(
    hStoreProv: HCERTSTOREPROV;
    pCtlContext: PCCTL_CONTEXT;
    dwPropId: DWORD;
    dwFlags: DWORD;
    pvData: pointer;
    var pcbData: DWORD
    ): BOOL; stdcall;

  //+-------------------------------------------------------------------------
  //  Duplicate a cert store handle
  //--------------------------------------------------------------------------
function CertDuplicateStore(
  hCertStore: HCERTSTORE
  ): HCERTSTORE; stdcall;

const
  CERT_STORE_SAVE_AS_STORE =      1;
  CERT_STORE_SAVE_AS_PKCS7 =      2;

  CERT_STORE_SAVE_TO_FILE =       1;
  CERT_STORE_SAVE_TO_MEMORY =     2;
  CERT_STORE_SAVE_TO_FILENAME_A = 3;
  CERT_STORE_SAVE_TO_FILENAME_W = 4;
  CERT_STORE_SAVE_TO_FILENAME =   CERT_STORE_SAVE_TO_FILENAME_W;

  //+-------------------------------------------------------------------------
  //  Save the cert store. Extended version with lots of options.
  //
  //  According to the dwSaveAs parameter, the store can be saved as a
  //  serialized store (CERT_STORE_SAVE_AS_STORE) containing properties in
  //  addition to encoded certificates, CRLs and CTLs or the store can be saved
  //  as a PKCS #7 signed message (CERT_STORE_SAVE_AS_PKCS7) which doesn't
  //  include the properties or CTLs.
  //
  //  Note, the CERT_KEY_CONTEXT_PROP_ID property (and its
  //  CERT_KEY_PROV_HANDLE_PROP_ID or CERT_KEY_SPEC_PROP_ID) isn't saved into
  //  a serialized store.
  //
  //  For CERT_STORE_SAVE_AS_PKCS7, the dwEncodingType specifies the message
  //  encoding type. The dwEncodingType parameter isn't used for
  //  CERT_STORE_SAVE_AS_STORE.
  //
  //  The dwFlags parameter currently isn't used and should be set to 0.
  //
  //  The dwSaveTo and pvSaveToPara parameters specify where to save the
  //  store as follows:
  //    CERT_STORE_SAVE_TO_FILE:
  //      Saves to the specified file. The file's handle is passed in
  //      pvSaveToPara. Given,
  //          HANDLE hFile; pvSaveToPara = (void *) hFile;
  //
  //      For a successful save, the file pointer is positioned after the
  //      last write.
  //
  //    CERT_STORE_SAVE_TO_MEMORY:
  //      Saves to the specified memory blob. The pointer to
  //      the memory blob is passed in pvSaveToPara. Given,
  //          CRYPT_DATA_BLOB SaveBlob; pvSaveToPara = (void *) &SaveBlob;
  //      Upon entry, the SaveBlob's pbData and cbData need to be initialized.
  //      Upon return, cbData is updated with the actual length.
  //      For a length only calculation, pbData should be set to NULL. If
  //      pbData is non-NULL and cbData isn't large enough, FALSE is returned
  //      with a last error of ERRROR_MORE_DATA.
  //
  //    CERT_STORE_SAVE_TO_FILENAME_A:
  //    CERT_STORE_SAVE_TO_FILENAME_W:
  //    CERT_STORE_SAVE_TO_FILENAME:
  //      Opens the file and saves to it. The filename is passed in pvSaveToPara.
  //      The filename is UNICODE for the "_W" option and ASCII for the "_A"
  //      option. For "_W": given,
  //          LPCWSTR pwszFilename; pvSaveToPara = (void *) pwszFilename;
  //      For "_A": given,
  //          LPCSTR pszFilename; pvSaveToPara = (void *) pszFilename;
  //
  //      Note, the default (without "_A" or "_W") is UNICODE.
  //
  //--------------------------------------------------------------------------
function CertSaveStore(
  hCertStore: HCERTSTORE;
  dwEncodingType: DWORD;
  dwSaveAs: DWORD;
  dwSaveTo: DWORD;
  pvSaveToPara: pointer;
  dwFlags: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Certificate Store close flags
//--------------------------------------------------------------------------
const
  CERT_CLOSE_STORE_FORCE_FLAG = $00000001;
  CERT_CLOSE_STORE_CHECK_FLAG = $00000002;

  //+-------------------------------------------------------------------------
  //  Close a cert store handle.
  //
  //  There needs to be a corresponding close for each open and duplicate.
  //
  //  Even on the final close, the cert store isn't freed until all of its
  //  certificate and CRL contexts have also been freed.
  //
  //  On the final close, the hCryptProv passed to CertStoreOpen is
  //  CryptReleaseContext'ed.
  //
  //  To force the closure of the store with all of its memory freed, set the
  //  CERT_STORE_CLOSE_FORCE_FLAG. This flag should be set when the caller does
  //  its own reference counting and wants everything to vanish.
  //
  //  To check if all the store's certificates and CRLs have been freed and that
  //  this is the last CertCloseStore, set the CERT_CLOSE_STORE_CHECK_FLAG. If
  //  set and certs, CRLs or stores still need to be freed/closed, FALSE is
  //  returned with LastError set to CRYPT_E_PENDING_CLOSE. Note, for FALSE,
  //  the store is still closed. This is a diagnostic flag.
  //
  //  LastError is preserved unless CERT_CLOSE_STORE_CHECK_FLAG is set and FALSE
  //  is returned.
  //--------------------------------------------------------------------------
function CertCloseStore(
  hCertStore: HCERTSTORE;
  dwFlags: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Get the subject certificate context uniquely identified by its Issuer and
//  SerialNumber from the store.
//
//  If the certificate isn't found, NULL is returned. Otherwise, a pointer to
//  a read only CERT_CONTEXT is returned. CERT_CONTEXT must be freed by calling
//  CertFreeCertificateContext. CertDuplicateCertificateContext can be called to make a
//  duplicate.
//
//  The returned certificate might not be valid. Normally, it would be
//  verified when getting its issuer certificate (CertGetIssuerCertificateFromStore).
//--------------------------------------------------------------------------
function CertGetSubjectCertificateFromStore(
  hCertStore: HCERTSTORE;
  dwCertEncodingType: DWORD;
  pCertId: PCERT_INFO // Only the Issuer and SerialNumber
  // fields are used
  ): PCCERT_CONTEXT; stdcall;

//+-------------------------------------------------------------------------
//  Enumerate the certificate contexts in the store.
//
//  If a certificate isn't found, NULL is returned.
//  Otherwise, a pointer to a read only CERT_CONTEXT is returned. CERT_CONTEXT
//  must be freed by calling CertFreeCertificateContext or is freed when passed as the
//  pPrevCertContext on a subsequent call. CertDuplicateCertificateContext
//  can be called to make a duplicate.
//
//  pPrevCertContext MUST BE NULL to enumerate the first
//  certificate in the store. Successive certificates are enumerated by setting
//  pPrevCertContext to the CERT_CONTEXT returned by a previous call.
//
//  NOTE: a NON-NULL pPrevCertContext is always CertFreeCertificateContext'ed by
//  this function, even for an error.
//--------------------------------------------------------------------------
function CertEnumCertificatesInStore(
  hCertStore: HCERTSTORE;
  pPrevCertContext: PCCERT_CONTEXT
  ): PCCERT_CONTEXT; stdcall;

//+-------------------------------------------------------------------------
//  Find the first or next certificate context in the store.
//
//  The certificate is found according to the dwFindType and its pvFindPara.
//  See below for a list of the find types and its parameters.
//
//  Currently dwFindFlags is only used for CERT_FIND_SUBJECT_ATTR,
//  CERT_FIND_ISSUER_ATTR or CERT_FIND_CTL_USAGE. Otherwise, must be set to 0.
//
//  Usage of dwCertEncodingType depends on the dwFindType.
//
//  If the first or next certificate isn't found, NULL is returned.
//  Otherwise, a pointer to a read only CERT_CONTEXT is returned. CERT_CONTEXT
//  must be freed by calling CertFreeCertificateContext or is freed when passed as the
//  pPrevCertContext on a subsequent call. CertDuplicateCertificateContext
//  can be called to make a duplicate.
//
//  pPrevCertContext MUST BE NULL on the first
//  call to find the certificate. To find the next certificate, the
//  pPrevCertContext is set to the CERT_CONTEXT returned by a previous call.
//
//  NOTE: a NON-NULL pPrevCertContext is always CertFreeCertificateContext'ed by
//  this function, even for an error.
//--------------------------------------------------------------------------
function CertFindCertificateInStore(
  hCertStore: HCERTSTORE;
  dwCertEncodingType: DWORD;
  dwFindFlags: DWORD;
  dwFindType: DWORD;
  pvFindPara: pointer;
  pPrevCertContext: PCCERT_CONTEXT
  ): PCCERT_CONTEXT; stdcall;

//+-------------------------------------------------------------------------
// Certificate comparison functions
//--------------------------------------------------------------------------
const
  CERT_COMPARE_MASK                   = $FFFF;
  CERT_COMPARE_SHIFT                  = 16;
  CERT_COMPARE_ANY                    = 0;
  CERT_COMPARE_SHA1_HASH              = 1;
  CERT_COMPARE_NAME                   = 2;
  CERT_COMPARE_ATTR                   = 3;
  CERT_COMPARE_MD5_HASH               = 4;
  CERT_COMPARE_PROPERTY               = 5;
  CERT_COMPARE_PUBLIC_KEY             = 6;
  CERT_COMPARE_HASH                   = CERT_COMPARE_SHA1_HASH;
  CERT_COMPARE_NAME_STR_A             = 7;
  CERT_COMPARE_NAME_STR_W             = 8;
  CERT_COMPARE_KEY_SPEC               = 9;
  CERT_COMPARE_ENHKEY_USAGE           = 10;
  CERT_COMPARE_CTL_USAGE              = CERT_COMPARE_ENHKEY_USAGE;
  CERT_COMPARE_SUBJECT_CERT           = 11;
  CERT_COMPARE_ISSUER_OF              = 12;
  CERT_COMPARE_EXISTING               = 13;
  CERT_COMPARE_SIGNATURE_HASH         = 14;
  CERT_COMPARE_KEY_IDENTIFIER         = 15;
  CERT_COMPARE_CERT_ID                = 16;

  CERT_COMPARE_CROSS_CERT_DIST_POINTS = 17;

  CERT_COMPARE_PUBKEY_MD5_HASH        = 18;

  //+-------------------------------------------------------------------------
  //  dwFindType
  //
  //  The dwFindType definition consists of two components:
  //   - comparison function
  //   - certificate information flag
  //--------------------------------------------------------------------------
  CERT_FIND_ANY = (CERT_COMPARE_ANY shl CERT_COMPARE_SHIFT);
  CERT_FIND_SHA1_HASH = (CERT_COMPARE_SHA1_HASH shl CERT_COMPARE_SHIFT);
  CERT_FIND_MD5_HASH = (CERT_COMPARE_MD5_HASH shl CERT_COMPARE_SHIFT);
  CERT_FIND_SIGNATURE_HASH = (CERT_COMPARE_SIGNATURE_HASH shl
    CERT_COMPARE_SHIFT);
  CERT_FIND_KEY_IDENTIFIER = (CERT_COMPARE_KEY_IDENTIFIER shl
    CERT_COMPARE_SHIFT);
  CERT_FIND_HASH = CERT_FIND_SHA1_HASH;
  CERT_FIND_PROPERTY = (CERT_COMPARE_PROPERTY shl CERT_COMPARE_SHIFT);
  CERT_FIND_PUBLIC_KEY = (CERT_COMPARE_PUBLIC_KEY shl CERT_COMPARE_SHIFT);
  CERT_FIND_SUBJECT_NAME = (CERT_COMPARE_NAME shl CERT_COMPARE_SHIFT or
    CERT_INFO_SUBJECT_FLAG);
  CERT_FIND_SUBJECT_ATTR = (CERT_COMPARE_ATTR shl CERT_COMPARE_SHIFT or
    CERT_INFO_SUBJECT_FLAG);
  CERT_FIND_ISSUER_NAME = (CERT_COMPARE_NAME shl CERT_COMPARE_SHIFT or
    CERT_INFO_ISSUER_FLAG);
  CERT_FIND_ISSUER_ATTR = (CERT_COMPARE_ATTR shl CERT_COMPARE_SHIFT or
    CERT_INFO_ISSUER_FLAG);
  CERT_FIND_SUBJECT_STR_A = (CERT_COMPARE_NAME_STR_A shl CERT_COMPARE_SHIFT or
    CERT_INFO_SUBJECT_FLAG);
  CERT_FIND_SUBJECT_STR_W = (CERT_COMPARE_NAME_STR_W shl CERT_COMPARE_SHIFT or
    CERT_INFO_SUBJECT_FLAG);
  CERT_FIND_SUBJECT_STR = CERT_FIND_SUBJECT_STR_W;
  CERT_FIND_ISSUER_STR_A = (CERT_COMPARE_NAME_STR_A shl CERT_COMPARE_SHIFT or
    CERT_INFO_ISSUER_FLAG);
  CERT_FIND_ISSUER_STR_W = (CERT_COMPARE_NAME_STR_W shl CERT_COMPARE_SHIFT or
    CERT_INFO_ISSUER_FLAG);
  CERT_FIND_ISSUER_STR = CERT_FIND_ISSUER_STR_W;
  CERT_FIND_KEY_SPEC = (CERT_COMPARE_KEY_SPEC shl CERT_COMPARE_SHIFT);
  CERT_FIND_ENHKEY_USAGE = (CERT_COMPARE_ENHKEY_USAGE shl CERT_COMPARE_SHIFT);
  CERT_FIND_CTL_USAGE = CERT_FIND_ENHKEY_USAGE;

  CERT_FIND_SUBJECT_CERT = (CERT_COMPARE_SUBJECT_CERT shl CERT_COMPARE_SHIFT);
  CERT_FIND_ISSUER_OF = (CERT_COMPARE_ISSUER_OF shl CERT_COMPARE_SHIFT);
  CERT_FIND_EXISTING = (CERT_COMPARE_EXISTING shl CERT_COMPARE_SHIFT);
  CERT_FIND_CERT_ID = (CERT_COMPARE_CERT_ID shl CERT_COMPARE_SHIFT);

  CERT_FIND_CROSS_CERT_DIST_POINTS =
    (CERT_COMPARE_CROSS_CERT_DIST_POINTS shl CERT_COMPARE_SHIFT);
  CERT_FIND_PUBKEY_MD5_HASH =
    (CERT_COMPARE_PUBKEY_MD5_HASH shl CERT_COMPARE_SHIFT);

  //+-------------------------------------------------------------------------
  //  CERT_FIND_ANY
  //
  //  Find any certificate.
  //
  //  pvFindPara isn't used.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_FIND_HASH
  //
  //  Find a certificate with the specified hash.
  //
  //  pvFindPara points to a CRYPT_HASH_BLOB.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_FIND_KEY_IDENTIFIER
  //
  //  Find a certificate with the specified KeyIdentifier. Gets the
  //  CERT_KEY_IDENTIFIER_PROP_ID property and compares with the input
  //  CRYPT_HASH_BLOB.
  //
  //  pvFindPara points to a CRYPT_HASH_BLOB.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_FIND_PROPERTY
  //
  //  Find a certificate having the specified property.
  //
  //  pvFindPara points to a DWORD containing the PROP_ID
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_FIND_PUBLIC_KEY
  //
  //  Find a certificate matching the specified public key.
  //
  //  pvFindPara points to a CERT_PUBLIC_KEY_INFO containing the public key
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_FIND_SUBJECT_NAME
  //  CERT_FIND_ISSUER_NAME
  //
  //  Find a certificate with the specified subject/issuer name. Does an exact
  //  match of the entire name.
  //
  //  Restricts search to certificates matching the dwCertEncodingType.
  //
  //  pvFindPara points to a CERT_NAME_BLOB.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_FIND_SUBJECT_ATTR
  //  CERT_FIND_ISSUER_ATTR
  //
  //  Find a certificate with the specified subject/issuer attributes.
  //
  //  Compares the attributes in the subject/issuer name with the
  //  Relative Distinguished Name's (CERT_RDN) array of attributes specified in
  //  pvFindPara. The comparison iterates through the CERT_RDN attributes and looks
  //  for an attribute match in any of the subject/issuer's RDNs.
  //
  //  The CERT_RDN_ATTR fields can have the following special values:
  //    pszObjId == NULL              - ignore the attribute object identifier
  //    dwValueType == RDN_ANY_TYPE   - ignore the value type
  //    Value.pbData == NULL          - match any value
  //
  //  CERT_CASE_INSENSITIVE_IS_RDN_ATTRS_FLAG should be set in dwFindFlags to do
  //  a case insensitive match. Otherwise, defaults to an exact, case sensitive
  //  match.
  //
  //  CERT_UNICODE_IS_RDN_ATTRS_FLAG should be set in dwFindFlags if the RDN was
  //  initialized with unicode strings as for
  //  CryptEncodeObject(X509_UNICODE_NAME).
  //
  //  Restricts search to certificates matching the dwCertEncodingType.
  //
  //  pvFindPara points to a CERT_RDN (defined in wincert.h).
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_FIND_SUBJECT_STR_A
  //  CERT_FIND_SUBJECT_STR_W | CERT_FIND_SUBJECT_STR
  //  CERT_FIND_ISSUER_STR_A
  //  CERT_FIND_ISSUER_STR_W  | CERT_FIND_ISSUER_STR
  //
  //  Find a certificate containing the specified subject/issuer name string.
  //
  //  First, the certificate's subject/issuer is converted to a name string
  //  via CertNameToStrA/CertNameToStrW(CERT_SIMPLE_NAME_STR). Then, a
  //  case insensitive substring within string match is performed.
  //
  //  Restricts search to certificates matching the dwCertEncodingType.
  //
  //  For *_STR_A, pvFindPara points to a null terminated character string.
  //  For *_STR_W, pvFindPara points to a null terminated wide character string.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_FIND_KEY_SPEC
  //
  //  Find a certificate having a CERT_KEY_SPEC_PROP_ID property matching
  //  the specified KeySpec.
  //
  //  pvFindPara points to a DWORD containing the KeySpec.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_FIND_ENHKEY_USAGE
  //
  //  Find a certificate having the szOID_ENHANCED_KEY_USAGE extension or
  //  the CERT_ENHKEY_USAGE_PROP_ID and matching the specified pszUsageIdentifers.
  //
  //  pvFindPara points to a CERT_ENHKEY_USAGE data structure. If pvFindPara
  //  is NULL or CERT_ENHKEY_USAGE's cUsageIdentifier is 0, then, matches any
  //  certificate having enhanced key usage.
  //
  //  If the CERT_FIND_VALID_ENHKEY_USAGE_FLAG is set, then, only does a match
  //  for certificates that are valid for the specified usages. By default,
  //  the ceriticate must be valid for all usages. CERT_FIND_OR_ENHKEY_USAGE_FLAG
  //  can be set, if the certificate only needs to be valid for one of the
  //  specified usages. Note, CertGetValidUsages() is called to get the
  //  certificate's list of valid usages. Only the CERT_FIND_OR_ENHKEY_USAGE_FLAG
  //  is applicable when this flag is set.
  //
  //  The CERT_FIND_OPTIONAL_ENHKEY_USAGE_FLAG can be set in dwFindFlags to
  //  also match a certificate without either the extension or property.
  //
  //  If CERT_FIND_NO_ENHKEY_USAGE_FLAG is set in dwFindFlags, finds
  //  certificates without the key usage extension or property. Setting this
  //  flag takes precedence over pvFindPara being NULL.
  //
  //  If the CERT_FIND_EXT_ONLY_ENHKEY_USAGE_FLAG is set, then, only does a match
  //  using the extension. If pvFindPara is NULL or cUsageIdentifier is set to
  //  0, finds certificates having the extension. If
  //  CERT_FIND_OPTIONAL_ENHKEY_USAGE_FLAG is set, also matches a certificate
  //  without the extension. If CERT_FIND_NO_ENHKEY_USAGE_FLAG is set, finds
  //  certificates without the extension.
  //
  //  If the CERT_FIND_PROP_ONLY_ENHKEY_USAGE_FLAG is set, then, only does a match
  //  using the property. If pvFindPara is NULL or cUsageIdentifier is set to
  //  0, finds certificates having the property. If
  //  CERT_FIND_OPTIONAL_ENHKEY_USAGE_FLAG is set, also matches a certificate
  //  without the property. If CERT_FIND_NO_ENHKEY_USAGE_FLAG is set, finds
  //  certificates without the property.
  //
  //  If CERT_FIND_OR_ENHKEY_USAGE_FLAG is set, does an "OR" match of any of
  //  the specified pszUsageIdentifiers. If not set, then, does an "AND" match
  //  of all of the specified pszUsageIdentifiers.
  //--------------------------------------------------------------------------
const
  CERT_FIND_OPTIONAL_ENHKEY_USAGE_FLAG  = $1;
  CERT_FIND_EXT_ONLY_ENHKEY_USAGE_FLAG  = $2;
  CERT_FIND_PROP_ONLY_ENHKEY_USAGE_FLAG = $4;
  CERT_FIND_NO_ENHKEY_USAGE_FLAG        = $8;
  CERT_FIND_OR_ENHKEY_USAGE_FLAG        = $10;
  CERT_FIND_VALID_ENHKEY_USAGE_FLAG     = $20;

  CERT_FIND_OPTIONAL_CTL_USAGE_FLAG = CERT_FIND_OPTIONAL_ENHKEY_USAGE_FLAG;

  CERT_FIND_EXT_ONLY_CTL_USAGE_FLAG =
    CERT_FIND_EXT_ONLY_ENHKEY_USAGE_FLAG;

  CERT_FIND_PROP_ONLY_CTL_USAGE_FLAG =
    CERT_FIND_PROP_ONLY_ENHKEY_USAGE_FLAG;

  CERT_FIND_NO_CTL_USAGE_FLAG = CERT_FIND_NO_ENHKEY_USAGE_FLAG;
  CERT_FIND_OR_CTL_USAGE_FLAG = CERT_FIND_OR_ENHKEY_USAGE_FLAG;
  CERT_FIND_VALID_CTL_USAGE_FLAG = CERT_FIND_VALID_ENHKEY_USAGE_FLAG;

  //+-------------------------------------------------------------------------
  //  CERT_FIND_CERT_ID
  //
  //  Find a certificate with the specified CERT_ID.
  //
  //  pvFindPara points to a CERT_ID.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_FIND_CROSS_CERT_DIST_POINTS
  //
  //  Find a certificate having either a cross certificate distribution
  //  point extension or property.
  //
  //  pvFindPara isn't used.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  Get the certificate context from the store for the first or next issuer
  //  of the specified subject certificate. Perform the enabled
  //  verification checks on the subject. (Note, the checks are on the subject
  //  using the returned issuer certificate.)
  //
  //  If the first or next issuer certificate isn't found, NULL is returned.
  //  Otherwise, a pointer to a read only CERT_CONTEXT is returned. CERT_CONTEXT
  //  must be freed by calling CertFreeCertificateContext or is freed when passed as the
  //  pPrevIssuerContext on a subsequent call. CertDuplicateCertificateContext
  //  can be called to make a duplicate.
  //
  //  For a self signed subject certificate, NULL is returned with LastError set
  //  to CERT_STORE_SELF_SIGNED. The enabled verification checks are still done.
  //
  //  The pSubjectContext may have been obtained from this store, another store
  //  or created by the caller application. When created by the caller, the
  //  CertCreateCertificateContext function must have been called.
  //
  //  An issuer may have multiple certificates. This may occur when the validity
  //  period is about to change. pPrevIssuerContext MUST BE NULL on the first
  //  call to get the issuer. To get the next certificate for the issuer, the
  //  pPrevIssuerContext is set to the CERT_CONTEXT returned by a previous call.
  //
  //  NOTE: a NON-NULL pPrevIssuerContext is always CertFreeCertificateContext'ed by
  //  this function, even for an error.
  //
  //  The following flags can be set in *pdwFlags to enable verification checks
  //  on the subject certificate context:
  //      CERT_STORE_SIGNATURE_FLAG     - use the public key in the returned
  //                                      issuer certificate to verify the
  //                                      signature on the subject certificate.
  //                                      Note, if pSubjectContext->hCertStore ==
  //                                      hCertStore, the store provider might
  //                                      be able to eliminate a redo of
  //                                      the signature verify.
  //      CERT_STORE_TIME_VALIDITY_FLAG - get the current time and verify that
  //                                      its within the subject certificate's
  //                                      validity period
  //      CERT_STORE_REVOCATION_FLAG    - check if the subject certificate is on
  //                                      the issuer's revocation list
  //
  //  If an enabled verification check fails, then, its flag is set upon return.
  //  If CERT_STORE_REVOCATION_FLAG was enabled and the issuer doesn't have a
  //  CRL in the store, then, CERT_STORE_NO_CRL_FLAG is set in addition to
  //  the CERT_STORE_REVOCATION_FLAG.
  //
  //  If CERT_STORE_SIGNATURE_FLAG or CERT_STORE_REVOCATION_FLAG is set, then,
  //  CERT_STORE_NO_ISSUER_FLAG is set if it doesn't have an issuer certificate
  //  in the store.
  //
  //  For a verification check failure, a pointer to the issuer's CERT_CONTEXT
  //  is still returned and SetLastError isn't updated.
  //--------------------------------------------------------------------------
function CertGetIssuerCertificateFromStore(
  hCertStore: HCERTSTORE;
  pSubjectContext: PCCERT_CONTEXT;
  pPrevIssuerContext: PCCERT_CONTEXT;
  var pdwFlags: DWORD
  ): PCCERT_CONTEXT; stdcall;

//+-------------------------------------------------------------------------
//  Perform the enabled verification checks on the subject certificate
//  using the issuer. Same checks and flags definitions as for the above
//  CertGetIssuerCertificateFromStore.
//
//  If you are only checking CERT_STORE_TIME_VALIDITY_FLAG, then, the
//  issuer can be NULL.
//
//  For a verification check failure, SUCCESS is still returned.
//--------------------------------------------------------------------------
function CertVerifySubjectCertificateContext(
  pSubject: PCCERT_CONTEXT;
  pIssuer: PCCERT_CONTEXT;
  var pdwFlags: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Duplicate a certificate context
//--------------------------------------------------------------------------
function CertDuplicateCertificateContext(
  pCertContext: PCCERT_CONTEXT
  ): PCCERT_CONTEXT; stdcall;

//+-------------------------------------------------------------------------
//  Create a certificate context from the encoded certificate. The created
//  context isn't put in a store.
//
//  Makes a copy of the encoded certificate in the created context.
//
//  If unable to decode and create the certificate context, NULL is returned.
//  Otherwise, a pointer to a read only CERT_CONTEXT is returned.
//  CERT_CONTEXT must be freed by calling CertFreeCertificateContext.
//  CertDuplicateCertificateContext can be called to make a duplicate.
//
//  CertSetCertificateContextProperty and CertGetCertificateContextProperty can be called
//  to store properties for the certificate.
//--------------------------------------------------------------------------
function CertCreateCertificateContext(
  dwCertEncodingType: DWORD;
  pbCertEncoded: PBYTE;
  cbCertEncoded: DWORD
  ): PCCERT_CONTEXT; stdcall;

//+-------------------------------------------------------------------------
//  Free a certificate context
//
//  There needs to be a corresponding free for each context obtained by a
//  get, find, duplicate or create.
//--------------------------------------------------------------------------
function CertFreeCertificateContext(
  pCertContext: PCCERT_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Set the property for the specified certificate context.
//
//  The type definition for pvData depends on the dwPropId value. There are
//  five predefined types:
//      CERT_KEY_PROV_HANDLE_PROP_ID - a HCRYPTPROV for the certificate's
//      private key is passed in pvData. Updates the hCryptProv field
//      of the CERT_KEY_CONTEXT_PROP_ID. If the CERT_KEY_CONTEXT_PROP_ID
//      doesn't exist, its created with all the other fields zeroed out. If
//      CERT_STORE_NO_CRYPT_RELEASE_FLAG isn't set, HCRYPTPROV is implicitly
//      released when either the property is set to NULL or on the final
//      free of the CertContext.
//
//      CERT_KEY_PROV_INFO_PROP_ID - a PCRYPT_KEY_PROV_INFO for the certificate's
//      private key is passed in pvData.
//
//      CERT_SHA1_HASH_PROP_ID       -
//      CERT_MD5_HASH_PROP_ID        -
//      CERT_SIGNATURE_HASH_PROP_ID  - normally, a hash property is implicitly
//      set by doing a CertGetCertificateContextProperty. pvData points to a
//      CRYPT_HASH_BLOB.
//
//      CERT_KEY_CONTEXT_PROP_ID - a PCERT_KEY_CONTEXT for the certificate's
//      private key is passed in pvData. The CERT_KEY_CONTEXT contains both the
//      hCryptProv and dwKeySpec for the private key.
//      See the CERT_KEY_PROV_HANDLE_PROP_ID for more information about
//      the hCryptProv field and dwFlags settings. Note, more fields may
//      be added for this property. The cbSize field value will be adjusted
//      accordingly.
//
//      CERT_KEY_SPEC_PROP_ID - the dwKeySpec for the private key. pvData
//      points to a DWORD containing the KeySpec
//
//      CERT_ENHKEY_USAGE_PROP_ID - enhanced key usage definition for the
//      certificate. pvData points to a CRYPT_DATA_BLOB containing an
//      ASN.1 encoded CERT_ENHKEY_USAGE (encoded via
//      CryptEncodeObject(X509_ENHANCED_KEY_USAGE).
//
//      CERT_NEXT_UPDATE_LOCATION_PROP_ID - location of the next update.
//      Currently only applicable to CTLs. pvData points to a CRYPT_DATA_BLOB
//      containing an ASN.1 encoded CERT_ALT_NAME_INFO (encoded via
//      CryptEncodeObject(X509_ALTERNATE_NAME)).
//
//      CERT_FRIENDLY_NAME_PROP_ID - friendly name for the cert, CRL or CTL.
//      pvData points to a CRYPT_DATA_BLOB. pbData is a pointer to a NULL
//      terminated unicode, wide character string.
//      cbData = (wcslen((LPWSTR) pbData) + 1) * sizeof(WCHAR).
//
//      CERT_DESCRIPTION_PROP_ID - description for the cert, CRL or CTL.
//      pvData points to a CRYPT_DATA_BLOB. pbData is a pointer to a NULL
//      terminated unicode, wide character string.
//      cbData = (wcslen((LPWSTR) pbData) + 1) * sizeof(WCHAR).
//
//      CERT_ARCHIVED_PROP_ID - when this property is set, the certificate
//      is skipped during enumeration. Note, certificates having this property
//      are still found for explicit finds, such as, finding a certificate
//      with a specific hash or finding a certificate having a specific issuer
//      and serial number. pvData points to a CRYPT_DATA_BLOB. This blob
//      can be NULL (pbData = NULL, cbData = 0).
//
//      CERT_PUBKEY_ALG_PARA_PROP_ID - for public keys supporting
//      algorithm parameter inheritance. pvData points to a CRYPT_OBJID_BLOB
//      containing the ASN.1 encoded PublicKey Algorithm Parameters. For
//      DSS this would be the parameters encoded via
//      CryptEncodeObject(X509_DSS_PARAMETERS). This property may be set
//      by CryptVerifyCertificateSignatureEx().
//
//      CERT_CROSS_CERT_DIST_POINTS_PROP_ID - location of the cross certs.
//      Currently only applicable to certs. pvData points to a CRYPT_DATA_BLOB
//      containing an ASN.1 encoded CROSS_CERT_DIST_POINTS_INFO (encoded via
//      CryptEncodeObject(X509_CROSS_CERT_DIST_POINTS)).
//
//      CERT_ENROLLMENT_PROP_ID - enrollment information of the pending request.
//      It contains RequestID, CADNSName, CAName, and FriendlyName.
//      The data format is defined as, the first 4 bytes - pending request ID,
//      next 4 bytes - CADNSName size in characters including null-terminator
//      followed by CADNSName string with null-terminator,
//      next 4 bytes - CAName size in characters including null-terminator
//      followed by CAName string with null-terminator,
//      next 4 bytes - FriendlyName size in characters including null-terminator
//      followed by FriendlyName string with null-terminator.
//
//      CERT_DATE_STAMP_PROP_ID - contains the time when added to the store
//      by an admin tool. pvData points to a CRYPT_DATA_BLOB containing
//      the FILETIME.
//
//      CERT_RENEWAL_PROP_ID - contains the hash of renewed certificate
//
//  For all the other PROP_IDs: an encoded PCRYPT_DATA_BLOB is passed in pvData.
//
//  If the property already exists, then, the old value is deleted and silently
//  replaced. Setting, pvData to NULL, deletes the property.
//
//  CERT_SET_PROPERTY_IGNORE_PERSIST_ERROR_FLAG can be set to ignore any
//  provider write errors and always update the cached context's property.
//--------------------------------------------------------------------------
function CertSetCertificateContextProperty(
  pCertContext: PCCERT_CONTEXT;
  dwPropId: DWORD;
  dwFlags: DWORD;
  pvData: pointer
  ): BOOL; stdcall;

// Set this flag to ignore any store provider write errors and always update
// the cached context's property
const
  CERT_SET_PROPERTY_IGNORE_PERSIST_ERROR_FLAG = $80000000;

// Set this flag to inhibit the persisting of this property
  CERT_SET_PROPERTY_INHIBIT_PERSIST_FLAG      = $40000000;

  //+-------------------------------------------------------------------------
  //  Get the property for the specified certificate context.
  //
  //  For CERT_KEY_PROV_HANDLE_PROP_ID, pvData points to a HCRYPTPROV.
  //
  //  For CERT_KEY_PROV_INFO_PROP_ID, pvData points to a CRYPT_KEY_PROV_INFO structure.
  //  Elements pointed to by fields in the pvData structure follow the
  //  structure. Therefore, *pcbData may exceed the size of the structure.
  //
  //  For CERT_KEY_CONTEXT_PROP_ID, pvData points to a CERT_KEY_CONTEXT structure.
  //
  //  For CERT_KEY_SPEC_PROP_ID, pvData points to a DWORD containing the KeySpec.
  //  If the CERT_KEY_CONTEXT_PROP_ID exists, the KeySpec is obtained from there.
  //  Otherwise, if the CERT_KEY_PROV_INFO_PROP_ID exists, its the source
  //  of the KeySpec.
  //
  //  For CERT_SHA1_HASH_PROP_ID or CERT_MD5_HASH_PROP_ID, if the hash
  //  doesn't already exist, then, its computed via CryptHashCertificate()
  //  and then set. pvData points to the computed hash. Normally, the length
  //  is 20 bytes for SHA and 16 for MD5.
  //
  //  For CERT_SIGNATURE_HASH_PROP_ID, if the hash
  //  doesn't already exist, then, its computed via CryptHashToBeSigned()
  //  and then set. pvData points to the computed hash. Normally, the length
  //  is 20 bytes for SHA and 16 for MD5.
  //
  //  For CERT_ACCESS_STATE_PROP_ID, pvData points to a DWORD containing the
  //  access state flags. The appropriate CERT_ACCESS_STATE_*_FLAG's are set
  //  in the returned DWORD. See the CERT_ACCESS_STATE_*_FLAG definitions
  //  above. Note, this property is read only. It can't be set.
  //
  //  For CERT_KEY_IDENTIFIER_PROP_ID, if property doesn't already exist,
  //  first searches for the szOID_SUBJECT_KEY_IDENTIFIER extension. Next,
  //  does SHA1 hash of the certficate's SubjectPublicKeyInfo. pvData
  //  points to the key identifier bytes. Normally, the length is 20 bytes.
  //
  //  For CERT_PUBKEY_ALG_PARA_PROP_ID, pvPara points to the ASN.1 encoded
  //  PublicKey Algorithm Parameters. This property will only be set
  //  for public keys supporting algorithm parameter inheritance and when the
  //  parameters have been omitted from the encoded and signed certificate.
  //
  //  For CERT_DATE_STAMP_PROP_ID, pvPara points to a FILETIME updated by
  //  an admin tool to indicate when the certificate was added to the store.
  //
  //  For all other PROP_IDs, pvData points to an encoded array of bytes.
  //--------------------------------------------------------------------------
function CertGetCertificateContextProperty(
  pCertContext: PCCERT_CONTEXT;
  dwPropId: DWORD;
  pvData: pointer;
  var pcbData: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Enumerate the properties for the specified certificate context.
//
//  To get the first property, set dwPropId to 0. The ID of the first
//  property is returned. To get the next property, set dwPropId to the
//  ID returned by the last call. To enumerate all the properties continue
//  until 0 is returned.
//
//  CertGetCertificateContextProperty is called to get the property's data.
//
//  Note, since, the CERT_KEY_PROV_HANDLE_PROP_ID and CERT_KEY_SPEC_PROP_ID
//  properties are stored as fields in the CERT_KEY_CONTEXT_PROP_ID
//  property, they aren't enumerated individually.
//--------------------------------------------------------------------------
function CertEnumCertificateContextProperties(
  pCertContext: PCCERT_CONTEXT;
  dwPropId: DWORD
  ): DWORD; stdcall;

//+-------------------------------------------------------------------------
//  Creates a CTL entry whose attributes are the certificate context's
//  properties.
//
//  The SubjectIdentifier in the CTL entry is the SHA1 hash of the certificate.
//
//  The certificate properties are added as attributes. The property attribute 
//  OID is the decimal PROP_ID preceded by szOID_CERT_PROP_ID_PREFIX. Each
//  property value is copied as a single attribute value.
//
//  Any additional attributes to be included in the CTL entry can be passed
//  in via the cOptAttr and rgOptAttr parameters.
//
//  CTL_ENTRY_FROM_PROP_CHAIN_FLAG can be set in dwFlags, to force the
//  inclusion of the chain building hash properties as attributes.
//--------------------------------------------------------------------------
function CertCreateCTLEntryFromCertificateContextProperties(
  pCertContext: PCCERT_CONTEXT;
  cOptAttr: DWORD;
  rgOptAttr: PCRYPT_ATTRIBUTE;
  dwFlags: DWORD;
  pvReserved: pointer;
  pCtlEntry: PCTL_ENTRY;
  var pcbCtlEntry: DWORD
  ): BOOL; stdcall;

// Set this flag to get and include the chain building hash properties
// as attributes in the CTL entry
const
  CTL_ENTRY_FROM_PROP_CHAIN_FLAG = $1;

//+-------------------------------------------------------------------------
//  Sets properties on the certificate context using the attributes in
//  the CTL entry.
//
//  The property attribute OID is the decimal PROP_ID preceded by
//  szOID_CERT_PROP_ID_PREFIX. Only attributes containing such an OID are
//  copied.
//
//  CERT_SET_PROPERTY_IGNORE_PERSIST_ERROR_FLAG may be set in dwFlags.
//--------------------------------------------------------------------------
function CertSetCertificateContextPropertiesFromCTLEntry(
  pCertContext: PCCERT_CONTEXT;
  pCtlEntry: PCTL_ENTRY;
  dwFlags: DWORD
  ): BOOL; stdcall

//+-------------------------------------------------------------------------
//  Get the first or next CRL context from the store for the specified
//  issuer certificate. Perform the enabled verification checks on the CRL.
//
//  If the first or next CRL isn't found, NULL is returned.
//  Otherwise, a pointer to a read only CRL_CONTEXT is returned. CRL_CONTEXT
//  must be freed by calling CertFreeCRLContext. However, the free must be
//  pPrevCrlContext on a subsequent call. CertDuplicateCRLContext
//  can be called to make a duplicate.
//
//  The pIssuerContext may have been obtained from this store, another store
//  or created by the caller application. When created by the caller, the
//  CertCreateCertificateContext function must have been called.
//
//  If pIssuerContext == NULL, finds all the CRLs in the store.
//
//  An issuer may have multiple CRLs. For example, it generates delta CRLs
//  using a X.509 v3 extension. pPrevCrlContext MUST BE NULL on the first
//  call to get the CRL. To get the next CRL for the issuer, the
//  pPrevCrlContext is set to the CRL_CONTEXT returned by a previous call.
//
//  NOTE: a NON-NULL pPrevCrlContext is always CertFreeCRLContext'ed by
//  this function, even for an error.
//
//  The following flags can be set in *pdwFlags to enable verification checks
//  on the returned CRL:
//      CERT_STORE_SIGNATURE_FLAG     - use the public key in the
//                                      issuer's certificate to verify the
//                                      signature on the returned CRL.
//                                      Note, if pIssuerContext->hCertStore ==
//                                      hCertStore, the store provider might
//                                      be able to eliminate a redo of
//                                      the signature verify.
//      CERT_STORE_TIME_VALIDITY_FLAG - get the current time and verify that
//                                      its within the CRL's ThisUpdate and
//                                      NextUpdate validity period.
//
//  If an enabled verification check fails, then, its flag is set upon return.
//
//  If pIssuerContext == NULL, then, an enabled CERT_STORE_SIGNATURE_FLAG
//  always fails and the CERT_STORE_NO_ISSUER_FLAG is also set.
//
//  For a verification check failure, a pointer to the first or next
//  CRL_CONTEXT is still returned and SetLastError isn't updated.
//--------------------------------------------------------------------------
function CertGetCRLFromStore(
  hCertStore: HCERTSTORE;
  pIssuerContext: PCCERT_CONTEXT;
  pPrevCrlContext: PCCRL_CONTEXT;
  var pdwFlags: DWORD
  ): PCCRL_CONTEXT; stdcall;

//+-------------------------------------------------------------------------
//  Enumerate the CRL contexts in the store.
//
//  If a CRL isn't found, NULL is returned.
//  Otherwise, a pointer to a read only CRL_CONTEXT is returned. CRL_CONTEXT
//  must be freed by calling CertFreeCRLContext or is freed when passed as the
//  pPrevCrlContext on a subsequent call. CertDuplicateCRLContext
//  can be called to make a duplicate.
//
//  pPrevCrlContext MUST BE NULL to enumerate the first
//  CRL in the store. Successive CRLs are enumerated by setting
//  pPrevCrlContext to the CRL_CONTEXT returned by a previous call.
//
//  NOTE: a NON-NULL pPrevCrlContext is always CertFreeCRLContext'ed by
//  this function, even for an error.
//--------------------------------------------------------------------------
function CertEnumCRLsInStore(
  hCertStore: HCERTSTORE;
  pPrevCrlContext: PCCRL_CONTEXT
  ): PCCRL_CONTEXT; stdcall;

//+-------------------------------------------------------------------------
//  Find the first or next CRL context in the store.
//
//  The CRL is found according to the dwFindType and its pvFindPara.
//  See below for a list of the find types and its parameters.
//
//  Currently dwFindFlags isn't used and must be set to 0.
//
//  Usage of dwCertEncodingType depends on the dwFindType.
//
//  If the first or next CRL isn't found, NULL is returned.
//  Otherwise, a pointer to a read only CRL_CONTEXT is returned. CRL_CONTEXT
//  must be freed by calling CertFreeCRLContext or is freed when passed as the
//  pPrevCrlContext on a subsequent call. CertDuplicateCRLContext
//  can be called to make a duplicate.
//
//  pPrevCrlContext MUST BE NULL on the first
//  call to find the CRL. To find the next CRL, the
//  pPrevCrlContext is set to the CRL_CONTEXT returned by a previous call.
//
//  NOTE: a NON-NULL pPrevCrlContext is always CertFreeCRLContext'ed by
//  this function, even for an error.
//--------------------------------------------------------------------------
function CertFindCRLInStore(
  hCertStore: HCERTSTORE;
  dwCertEncodingType: DWORD;
  dwFindFlags: DWORD;
  dwFindType: DWORD;
  pvFindPara: pointer;
  pPrevCrlContext: PCCRL_CONTEXT
  ): PCCRL_CONTEXT; stdcall;

const
  CRL_FIND_ANY        = 0;
  CRL_FIND_ISSUED_BY  = 1;
  CRL_FIND_EXISTING   = 2;
  CRL_FIND_ISSUED_FOR = 3;

  //+-------------------------------------------------------------------------
  //  CRL_FIND_ANY
  //
  //  Find any CRL.
  //
  //  pvFindPara isn't used.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CRL_FIND_ISSUED_BY
  //
  //  Find CRL matching the specified issuer.
  //
  //  pvFindPara is the PCCERT_CONTEXT of the CRL issuer.
  //
  //  By default, only does issuer name matching. The following flags can be
  //  set in dwFindFlags to do additional filtering.
  //
  //  If CRL_FIND_ISSUED_BY_AKI_FLAG is set in dwFindFlags, then, checks if the
  //  CRL has an Authority Key Identifier (AKI) extension. If the CRL has an
  //  AKI, then, only returns a CRL whose AKI matches the issuer.
  //
  //  Note, the AKI extension has the following OID:
  //  szOID_AUTHORITY_KEY_IDENTIFIER2 and its corresponding data structure.
  //
  //  If CRL_FIND_ISSUED_BY_SIGNATURE_FLAG is set in dwFindFlags, then,
  //  uses the public key in the issuer's certificate to verify the
  //  signature on the CRL. Only returns a CRL having a valid signature.
  //--------------------------------------------------------------------------
const
  CRL_FIND_ISSUED_BY_AKI_FLAG       = $1;
  CRL_FIND_ISSUED_BY_SIGNATURE_FLAG = $2;
  CRL_FIND_ISSUED_BY_DELTA_FLAG     = $4;
  CRL_FIND_ISSUED_BY_BASE_FLAG      = $8;

  //+-------------------------------------------------------------------------
  //  CRL_FIND_EXISTING
  //
  //  Find existing CRL in the store.
  //
  //  pvFindPara is the PCCRL_CONTEXT of the CRL to check if it already
  //  exists in the store.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CRL_FIND_ISSUED_FOR
  //
  //  Find CRL for the specified subject and its issuer.
  //
  //  pvFindPara points to the following CRL_FIND_ISSUED_FOR_PARA which contains
  //  both the subject and issuer certificates. Not optional.
  //
  //  The subject's issuer name is used to match the CRL's issuer name. Otherwise,
  //  the issuer's certificate is used the same as in the above
  //  CRL_FIND_ISSUED_BY.
  //
  //  Note, when cross certificates are used, the subject name in the issuer's
  //  certificate may not match the issuer name in the subject certificate and
  //  its corresponding CRL.
  //
  //  All of the above CRL_FIND_ISSUED_BY_*_FLAGS apply to this find type.
  //--------------------------------------------------------------------------
type
  CRL_FIND_ISSUED_FOR_PARA = record
    pSubjectCert: PCCERT_CONTEXT;
    pIssuerCert:  PCCERT_CONTEXT;
  end;
  PCRL_FIND_ISSUED_FOR_PARA = ^CRL_FIND_ISSUED_FOR_PARA;


//+-------------------------------------------------------------------------
  //  Duplicate a CRL context
  //--------------------------------------------------------------------------
function CertDuplicateCRLContext(
  pCrlContext: PCCRL_CONTEXT
  ): PCCRL_CONTEXT; stdcall;

//+-------------------------------------------------------------------------
//  Create a CRL context from the encoded CRL. The created
//  context isn't put in a store.
//
//  Makes a copy of the encoded CRL in the created context.
//
//  If unable to decode and create the CRL context, NULL is returned.
//  Otherwise, a pointer to a read only CRL_CONTEXT is returned.
//  CRL_CONTEXT must be freed by calling CertFreeCRLContext.
//  CertDuplicateCRLContext can be called to make a duplicate.
//
//  CertSetCRLContextProperty and CertGetCRLContextProperty can be called
//  to store properties for the CRL.
//--------------------------------------------------------------------------
function CertCreateCRLContext(
  dwCertEncodingType: DWORD;
  pbCrlEncoded: PBYTE;
  cbCrlEncoded: DWORD
  ): PCCRL_CONTEXT; stdcall;

//+-------------------------------------------------------------------------
//  Free a CRL context
//
//  There needs to be a corresponding free for each context obtained by a
//  get, duplicate or create.
//--------------------------------------------------------------------------
function CertFreeCRLContext(
  pCrlContext: PCCRL_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Set the property for the specified CRL context.
//
//  Same Property Ids and semantics as CertSetCertificateContextProperty.
//--------------------------------------------------------------------------
function CertSetCRLContextProperty(
  pCrlContext: PCCRL_CONTEXT;
  dwPropId: DWORD;
  dwFlags: DWORD;
  pvData: pointer
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Get the property for the specified CRL context.
//
//  Same Property Ids and semantics as CertGetCertificateContextProperty.
//
//  CERT_SHA1_HASH_PROP_ID, CERT_MD5_HASH_PROP_ID or
//  CERT_SIGNATURE_HASH_PROP_ID is the predefined property of most interest.
//--------------------------------------------------------------------------
function CertGetCRLContextProperty(
  pCrlContext: PCCRL_CONTEXT;
  dwPropId: DWORD;
  pvData: pointer;
  var pcbData: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Enumerate the properties for the specified CRL context.
//
//  To get the first property, set dwPropId to 0. The ID of the first
//  property is returned. To get the next property, set dwPropId to the
//  ID returned by the last call. To enumerate all the properties continue
//  until 0 is returned.
//
//  CertGetCRLContextProperty is called to get the property's data.
//--------------------------------------------------------------------------
function CertEnumCRLContextProperties(
  pCrlContext: PCCRL_CONTEXT;
  dwPropId: DWORD
  ): DWORD; stdcall;

//+-------------------------------------------------------------------------
//  Search the CRL's list of entries for the specified certificate.
//
//  TRUE is returned if we were able to search the list. Otherwise, FALSE is
//  returned,
//
//  For success, if the certificate was found in the list, *ppCrlEntry is
//  updated with a pointer to the entry. Otherwise, *ppCrlEntry is set to NULL.
//  The returned entry isn't allocated and must not be freed.
//
//  dwFlags and pvReserved currently aren't used and must be set to 0 or NULL.
//--------------------------------------------------------------------------
function CertFindCertificateInCRL(
  pCert: PCCERT_CONTEXT;
  pCrlContext: PCCRL_CONTEXT;
  dwFlags: DWORD;
  pvReserved: pointer;
  var ppCrlEntry: PCRL_ENTRY
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Is the specified CRL valid for the certificate.
//
//  Returns TRUE if the CRL's list of entries would contain the certificate
//  if it was revoked. Note, doesn't check that the certificate is in the
//  list of entries.
//
//  If the CRL has an Issuing Distribution Point (IDP) extension, checks
//  that it's valid for the subject certificate.
//
//  dwFlags and pvReserved currently aren't used and must be set to 0 and NULL.
//--------------------------------------------------------------------------
function CertIsValidCRLForCertificate(
  pCert: PCCERT_CONTEXT;
  pCrl: PCCRL_CONTEXT;
  dwFlags: DWORD;
  pvReserved: pointer
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
// Add certificate/CRL, encoded, context or element disposition values.
//--------------------------------------------------------------------------
const
  CERT_STORE_ADD_NEW                                 = 1;
  CERT_STORE_ADD_USE_EXISTING                        = 2;
  CERT_STORE_ADD_REPLACE_EXISTING                    = 3;
  CERT_STORE_ADD_ALWAYS                              = 4;
  CERT_STORE_ADD_REPLACE_EXISTING_INHERIT_PROPERTIES = 5;
  CERT_STORE_ADD_NEWER                               = 6;
  CERT_STORE_ADD_NEWER_INHERIT_PROPERTIES            = 7;

  //+-------------------------------------------------------------------------
  //  Add the encoded certificate to the store according to the specified
  //  disposition action.
  //
  //  Makes a copy of the encoded certificate before adding to the store.
  //
  //  dwAddDispostion specifies the action to take if the certificate
  //  already exists in the store. This parameter must be one of the following
  //  values:
  //    CERT_STORE_ADD_NEW
  //      Fails if the certificate already exists in the store. LastError
  //      is set to CRYPT_E_EXISTS.
  //    CERT_STORE_ADD_USE_EXISTING
  //      If the certifcate already exists, then, its used and if ppCertContext
  //      is non-NULL, the existing context is duplicated.
  //    CERT_STORE_ADD_REPLACE_EXISTING
  //      If the certificate already exists, then, the existing certificate
  //      context is deleted before creating and adding the new context.
  //    CERT_STORE_ADD_ALWAYS
  //      No check is made to see if the certificate already exists. A
  //      new certificate context is always created. This may lead to
  //      duplicates in the store.
  //    CERT_STORE_ADD_REPLACE_EXISTING_INHERIT_PROPERTIES
  //      If the certificate already exists, then, its used.
  //    CERT_STORE_ADD_NEWER
  //      Fails if the certificate already exists in the store AND the NotBefore
  //      time of the existing certificate is equal to or greater than the
  //      NotBefore time of the new certificate being added. LastError
  //      is set to CRYPT_E_EXISTS.
  //
  //      If an older certificate is replaced, same as
  //      CERT_STORE_ADD_REPLACE_EXISTING.
  //
  //      For CRLs or CTLs compares the ThisUpdate times.
  //
  //    CERT_STORE_ADD_NEWER_INHERIT_PROPERTIES
  //      Same as CERT_STORE_ADD_NEWER. However, if an older certificate is
  //      replaced, same as CERT_STORE_ADD_REPLACE_EXISTING_INHERIT_PROPERTIES.
  //
  //  CertGetSubjectCertificateFromStore is called to determine if the
  //  certificate already exists in the store.
  //
  //  ppCertContext can be NULL, indicating the caller isn't interested
  //  in getting the CERT_CONTEXT of the added or existing certificate.
  //--------------------------------------------------------------------------
function CertAddEncodedCertificateToStore(
  hCertStore: HCERTSTORE;
  dwCertEncodingType: DWORD;
  pbCertEncoded: PBYTE;
  cbCertEncoded: DWORD;
  dwAddDisposition: DWORD;
  ppCertContext: PPCCERT_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Add the certificate context to the store according to the specified
//  disposition action.
//
//  In addition to the encoded certificate, the context's properties are
//  also copied.  Note, the CERT_KEY_CONTEXT_PROP_ID property (and its
//  CERT_KEY_PROV_HANDLE_PROP_ID or CERT_KEY_SPEC_PROP_ID) isn't copied.
//
//  Makes a copy of the certificate context before adding to the store.
//
//  dwAddDispostion specifies the action to take if the certificate
//  already exists in the store. This parameter must be one of the following
//  values:
//    CERT_STORE_ADD_NEW
//      Fails if the certificate already exists in the store. LastError
//      is set to CRYPT_E_EXISTS.
//    CERT_STORE_ADD_USE_EXISTING
//      If the certifcate already exists, then, its used and if ppStoreContext
//      is non-NULL, the existing context is duplicated. Iterates
//      through pCertContext's properties and only copies the properties
//      that don't already exist. The SHA1 and MD5 hash properties aren't
//      copied.
//    CERT_STORE_ADD_REPLACE_EXISTING
//      If the certificate already exists, then, the existing certificate
//      context is deleted before creating and adding a new context.
//      Properties are copied before doing the add.
//    CERT_STORE_ADD_ALWAYS
//      No check is made to see if the certificate already exists. A
//      new certificate context is always created and added. This may lead to
//      duplicates in the store. Properties are
//      copied before doing the add.
//    CERT_STORE_ADD_REPLACE_EXISTING_INHERIT_PROPERTIES
//      If the certificate already exists, then, the existing certificate
//      context is used. Properties from the added context are copied and
//      replace existing properties. However, any existing properties not
//      in the added context remain and aren't deleted.
//    CERT_STORE_ADD_NEWER
//      Fails if the certificate already exists in the store AND the NotBefore
//      time of the existing context is equal to or greater than the
//      NotBefore time of the new context being added. LastError
//      is set to CRYPT_E_EXISTS.
//
//      If an older context is replaced, same as
//      CERT_STORE_ADD_REPLACE_EXISTING.
//
//      For CRLs or CTLs compares the ThisUpdate times.
//
//    CERT_STORE_ADD_NEWER_INHERIT_PROPERTIES
//      Same as CERT_STORE_ADD_NEWER. However, if an older context is
//      replaced, same as CERT_STORE_ADD_REPLACE_EXISTING_INHERIT_PROPERTIES.
//
//  CertGetSubjectCertificateFromStore is called to determine if the
//  certificate already exists in the store.
//
//  ppStoreContext can be NULL, indicating the caller isn't interested
//  in getting the CERT_CONTEXT of the added or existing certificate.
//--------------------------------------------------------------------------
function CertAddCertificateContextToStore(
  hCertStore: HCERTSTORE;
  pCertContext: PCCERT_CONTEXT;
  dwAddDisposition: DWORD;
  ppStoreContext: PPCCERT_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Certificate Store Context Types
//--------------------------------------------------------------------------
const
  CERT_STORE_CERTIFICATE_CONTEXT = 1;
  CERT_STORE_CRL_CONTEXT         = 2;
  CERT_STORE_CTL_CONTEXT         = 3;

  //+-------------------------------------------------------------------------
  //  Certificate Store Context Bit Flags
  //--------------------------------------------------------------------------
  CERT_STORE_ALL_CONTEXT_FLAG = (not DWORD(0));
  CERT_STORE_CERTIFICATE_CONTEXT_FLAG =
    (1 shl CERT_STORE_CERTIFICATE_CONTEXT);
  CERT_STORE_CRL_CONTEXT_FLAG =
    (1 shl CERT_STORE_CRL_CONTEXT);
  CERT_STORE_CTL_CONTEXT_FLAG =
    (1 shl CERT_STORE_CTL_CONTEXT);

  //+-------------------------------------------------------------------------
  //  Add the serialized certificate or CRL element to the store.
  //
  //  The serialized element contains the encoded certificate, CRL or CTL and
  //  its properties, such as, CERT_KEY_PROV_INFO_PROP_ID.
  //
  //  If hCertStore is NULL, creates a certificate, CRL or CTL context not
  //  residing in any store.
  //
  //  dwAddDispostion specifies the action to take if the certificate or CRL
  //  already exists in the store. See CertAddCertificateContextToStore for a
  //  list of and actions taken.
  //
  //  dwFlags currently isn't used and should be set to 0.
  //
  //  dwContextTypeFlags specifies the set of allowable contexts. For example, to
  //  add either a certificate or CRL, set dwContextTypeFlags to:
  //      CERT_STORE_CERTIFICATE_CONTEXT_FLAG | CERT_STORE_CRL_CONTEXT_FLAG
  //
  //  *pdwContextType is updated with the type of the context returned in
  //  *ppvContxt. pdwContextType or ppvContext can be NULL, indicating the
  //  caller isn't interested in getting the output. If *ppvContext is
  //  returned it must be freed by calling CertFreeCertificateContext or
  //  CertFreeCRLContext.
  //--------------------------------------------------------------------------
function CertAddSerializedElementToStore(
  hCertStore: HCERTSTORE;
  pbElement: PBYTE;
  cbElement: DWORD;
  dwAddDisposition: DWORD;
  dwFlags: DWORD;
  dwContextTypeFlags: DWORD;
  pdwContextType: PDWORD;
  ppvContext: pointer
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Delete the specified certificate from the store.
//
//  All subsequent gets or finds for the certificate will fail. However,
//  memory allocated for the certificate isn't freed until all of its contexts
//  have also been freed.
//
//  The pCertContext is obtained from a get, enum, find or duplicate.
//
//  Some store provider implementations might also delete the issuer's CRLs
//  if this is the last certificate for the issuer in the store.
//
//  NOTE: the pCertContext is always CertFreeCertificateContext'ed by
//  this function, even for an error.
//--------------------------------------------------------------------------
function CertDeleteCertificateFromStore(
  pCertContext: PCCERT_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Add the encoded CRL to the store according to the specified
//  disposition option.
//
//  Makes a copy of the encoded CRL before adding to the store.
//
//  dwAddDispostion specifies the action to take if the CRL
//  already exists in the store. See CertAddEncodedCertificateToStore for a
//  list of and actions taken.
//
//  Compares the CRL's Issuer to determine if the CRL already exists in the
//  store.
//
//  ppCrlContext can be NULL, indicating the caller isn't interested
//  in getting the CRL_CONTEXT of the added or existing CRL.
//--------------------------------------------------------------------------
function CertAddEncodedCRLToStore(
  hCertStore: HCERTSTORE;
  dwCertEncodingType: DWORD;
  pbCrlEncoded: PBYTE;
  cbCrlEncoded: DWORD;
  dwAddDisposition: DWORD;
  ppCrlContext: PPCCRL_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Add the CRL context to the store according to the specified
//  disposition option.
//
//  In addition to the encoded CRL, the context's properties are
//  also copied.  Note, the CERT_KEY_CONTEXT_PROP_ID property (and its
//  CERT_KEY_PROV_HANDLE_PROP_ID or CERT_KEY_SPEC_PROP_ID) isn't copied.
//
//  Makes a copy of the encoded CRL before adding to the store.
//
//  dwAddDispostion specifies the action to take if the CRL
//  already exists in the store. See CertAddCertificateContextToStore for a
//  list of and actions taken.
//
//  Compares the CRL's Issuer, ThisUpdate and NextUpdate to determine
//  if the CRL already exists in the store.
//
//  ppStoreContext can be NULL, indicating the caller isn't interested
//  in getting the CRL_CONTEXT of the added or existing CRL.
//--------------------------------------------------------------------------
function CertAddCRLContextToStore(
  hCertStore: HCERTSTORE;
  pCrlContext: PCCRL_CONTEXT;
  dwAddDisposition: DWORD;
  ppStoreContext: PPCCRL_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Delete the specified CRL from the store.
//
//  All subsequent gets for the CRL will fail. However,
//  memory allocated for the CRL isn't freed until all of its contexts
//  have also been freed.
//
//  The pCrlContext is obtained from a get or duplicate.
//
//  NOTE: the pCrlContext is always CertFreeCRLContext'ed by
//  this function, even for an error.
//--------------------------------------------------------------------------
function CertDeleteCRLFromStore(
  pCrlContext: PCCRL_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Serialize the certificate context's encoded certificate and its
//  properties.
//--------------------------------------------------------------------------
function CertSerializeCertificateStoreElement(
  pCertContext: PCCERT_CONTEXT;
  dwFlags: DWORD;
  pbElement: PBYTE;
  var pcbElement: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Serialize the CRL context's encoded CRL and its properties.
//--------------------------------------------------------------------------
function CertSerializeCRLStoreElement(
  pCrlContext: PCCRL_CONTEXT;
  dwFlags: DWORD;
  pbElement: PBYTE;
  var pcbElement: DWORD
  ): BOOL; stdcall;

//+=========================================================================
//  Certificate Trust List (CTL) Store Data Structures and APIs
//==========================================================================

//+-------------------------------------------------------------------------
//  Duplicate a CTL context
//--------------------------------------------------------------------------
function CertDuplicateCTLContext(
  pCtlContext: PCCTL_CONTEXT
  ): PCCTL_CONTEXT; stdcall;

//+-------------------------------------------------------------------------
//  Create a CTL context from the encoded CTL. The created
//  context isn't put in a store.
//
//  Makes a copy of the encoded CTL in the created context.
//
//  If unable to decode and create the CTL context, NULL is returned.
//  Otherwise, a pointer to a read only CTL_CONTEXT is returned.
//  CTL_CONTEXT must be freed by calling CertFreeCTLContext.
//  CertDuplicateCTLContext can be called to make a duplicate.
//
//  CertSetCTLContextProperty and CertGetCTLContextProperty can be called
//  to store properties for the CTL.
//--------------------------------------------------------------------------
function CertCreateCTLContext(
  dwMsgAndCertEncodingType: DWORD;
  pbCtlEncoded: PBYTE;
  cbCtlEncoded: DWORD
  ): PCCTL_CONTEXT; stdcall;

//+-------------------------------------------------------------------------
//  Free a CTL context
//
//  There needs to be a corresponding free for each context obtained by a
//  get, duplicate or create.
//--------------------------------------------------------------------------
function CertFreeCTLContext(
  pCtlContext: PCCTL_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Set the property for the specified CTL context.
//
//  Same Property Ids and semantics as CertSetCertificateContextProperty.
//--------------------------------------------------------------------------
function CertSetCTLContextProperty(
  pCtlContext: PCCTL_CONTEXT;
  dwPropId: DWORD;
  dwFlags: DWORD;
  pvData: pointer
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Get the property for the specified CTL context.
//
//  Same Property Ids and semantics as CertGetCertificateContextProperty.
//
//  CERT_SHA1_HASH_PROP_ID or CERT_NEXT_UPDATE_LOCATION_PROP_ID are the
//  predefined properties of most interest.
//--------------------------------------------------------------------------
function CertGetCTLContextProperty(
  pCtlContext: PCCTL_CONTEXT;
  dwPropId: DWORD;
  pvData: pointer;
  var pcbData: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Enumerate the properties for the specified CTL context.
//--------------------------------------------------------------------------
function CertEnumCTLContextProperties(
  pCtlContext: PCCTL_CONTEXT;
  dwPropId: DWORD
  ): DWORD; stdcall;

//+-------------------------------------------------------------------------
//  Enumerate the CTL contexts in the store.
//
//  If a CTL isn't found, NULL is returned.
//  Otherwise, a pointer to a read only CTL_CONTEXT is returned. CTL_CONTEXT
//  must be freed by calling CertFreeCTLContext or is freed when passed as the
//  pPrevCtlContext on a subsequent call. CertDuplicateCTLContext
//  can be called to make a duplicate.
//
//  pPrevCtlContext MUST BE NULL to enumerate the first
//  CTL in the store. Successive CTLs are enumerated by setting
//  pPrevCtlContext to the CTL_CONTEXT returned by a previous call.
//
//  NOTE: a NON-NULL pPrevCtlContext is always CertFreeCTLContext'ed by
//  this function, even for an error.
//--------------------------------------------------------------------------
function CertEnumCTLsInStore(
  hCertStore: HCERTSTORE;
  pPrevCtlContext: PCCTL_CONTEXT
  ): PCCTL_CONTEXT; stdcall;

//+-------------------------------------------------------------------------
//  Attempt to find the specified subject in the CTL.
//
//  For CTL_CERT_SUBJECT_TYPE, pvSubject points to a CERT_CONTEXT. The CTL's
//  SubjectAlgorithm is examined to determine the representation of the
//  subject's identity. Initially, only SHA1 or MD5 hash will be supported.
//  The appropriate hash property is obtained from the CERT_CONTEXT.
//
//  For CTL_ANY_SUBJECT_TYPE, pvSubject points to the CTL_ANY_SUBJECT_INFO
//  structure which contains the SubjectAlgorithm to be matched in the CTL
//  and the SubjectIdentifer to be matched in one of the CTL entries.
//
//  The certificate's hash or the CTL_ANY_SUBJECT_INFO's SubjectIdentifier
//  is used as the key in searching the subject entries. A binary
//  memory comparison is done between the key and the entry's SubjectIdentifer.
//
//  dwEncodingType isn't used for either of the above SubjectTypes.
//--------------------------------------------------------------------------
function CertFindSubjectInCTL(
  dwEncodingType: DWORD;
  dwSubjectType: DWORD;
  pvSubject: pointer;
  pCtlContext: PCCTL_CONTEXT;
  dwFlags: DWORD
  ): PCTL_ENTRY; stdcall;

// Subject Types:
//  CTL_ANY_SUBJECT_TYPE, pvSubject points to following CTL_ANY_SUBJECT_INFO.
//  CTL_CERT_SUBJECT_TYPE, pvSubject points to CERT_CONTEXT.
const
  CTL_ANY_SUBJECT_TYPE  = 1;
  CTL_CERT_SUBJECT_TYPE = 2;

type
  CTL_ANY_SUBJECT_INFO = record
    SubjectAlgorithm:  CRYPT_ALGORITHM_IDENTIFIER;
    SubjectIdentifier: CRYPT_DATA_BLOB
  end;
  PCTL_ANY_SUBJECT_INFO = ^CTL_ANY_SUBJECT_INFO;

  //+-------------------------------------------------------------------------
  //  Find the first or next CTL context in the store.
  //
  //  The CTL is found according to the dwFindType and its pvFindPara.
  //  See below for a list of the find types and its parameters.
  //
  //  Currently dwFindFlags isn't used and must be set to 0.
  //
  //  Usage of dwMsgAndCertEncodingType depends on the dwFindType.
  //
  //  If the first or next CTL isn't found, NULL is returned.
  //  Otherwise, a pointer to a read only CTL_CONTEXT is returned. CTL_CONTEXT
  //  must be freed by calling CertFreeCTLContext or is freed when passed as the
  //  pPrevCtlContext on a subsequent call. CertDuplicateCTLContext
  //  can be called to make a duplicate.
  //
  //  pPrevCtlContext MUST BE NULL on the first
  //  call to find the CTL. To find the next CTL, the
  //  pPrevCtlContext is set to the CTL_CONTEXT returned by a previous call.
  //
  //  NOTE: a NON-NULL pPrevCtlContext is always CertFreeCTLContext'ed by
  //  this function, even for an error.
  //--------------------------------------------------------------------------
function CertFindCTLInStore(
  hCertStore: HCERTSTORE;
  dwMsgAndCertEncodingType: DWORD;
  dwFindFlags: DWORD;
  dwFindType: DWORD;
  pvFindPara: pointer;
  pPrevCtlContext: PCCTL_CONTEXT
  ): PCCTL_CONTEXT; stdcall;

const
  CTL_FIND_ANY       = 0;
  CTL_FIND_SHA1_HASH = 1;
  CTL_FIND_MD5_HASH  = 2;
  CTL_FIND_USAGE     = 3;
  CTL_FIND_SUBJECT   = 4;
  CTL_FIND_EXISTING  = 5;

type
  CTL_FIND_USAGE_PARA = record
    cbSize:         DWORD;
    SubjectUsage:   CTL_USAGE; // optional
    ListIdentifier: CRYPT_DATA_BLOB; // optional
    pSigner:        PCERT_INFO; // optional
  end;
  PCTL_FIND_USAGE_PARA = ^CTL_FIND_USAGE_PARA;

const
  CTL_FIND_NO_LIST_ID_CBDATA = $FFFFFFFF;
  CTL_FIND_NO_SIGNER_PTR     = (PCERT_INFO(-1));

  CTL_FIND_SAME_USAGE_FLAG   = $1;

type
  CTL_FIND_SUBJECT_PARA = record
    cbSize:        DWORD;
    pUsagePara:    PCTL_FIND_USAGE_PARA; // optional
    dwSubjectType: DWORD;
    pvSubject:     pointer;
  end;
  PCTL_FIND_SUBJECT_PARA = ^CTL_FIND_SUBJECT_PARA;

  //+-------------------------------------------------------------------------
  //  CTL_FIND_ANY
  //
  //  Find any CTL.
  //
  //  pvFindPara isn't used.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CTL_FIND_SHA1_HASH
  //  CTL_FIND_MD5_HASH
  //
  //  Find a CTL with the specified hash.
  //
  //  pvFindPara points to a CRYPT_HASH_BLOB.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CTL_FIND_USAGE
  //
  //  Find a CTL having the specified usage identifiers, list identifier or
  //  signer. The CertEncodingType of the signer is obtained from the
  //  dwMsgAndCertEncodingType parameter.
  //
  //  pvFindPara points to a CTL_FIND_USAGE_PARA data structure. The
  //  SubjectUsage.cUsageIdentifer can be 0 to match any usage. The
  //  ListIdentifier.cbData can be 0 to match any list identifier. To only match
  //  CTLs without a ListIdentifier, cbData must be set to
  //  CTL_FIND_NO_LIST_ID_CBDATA. pSigner can be NULL to match any signer. Only
  //  the Issuer and SerialNumber fields of the pSigner's PCERT_INFO are used.
  //  To only match CTLs without a signer, pSigner must be set to
  //  CTL_FIND_NO_SIGNER_PTR.
  //
  //  The CTL_FIND_SAME_USAGE_FLAG can be set in dwFindFlags to
  //  only match CTLs with the same usage identifiers. CTLs having additional
  //  usage identifiers aren't matched. For example, if only "1.2.3" is specified
  //  in CTL_FIND_USAGE_PARA, then, for a match, the CTL must only contain
  //  "1.2.3" and not any additional usage identifers.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CTL_FIND_SUBJECT
  //
  //  Find a CTL having the specified subject. CertFindSubjectInCTL can be
  //  called to get a pointer to the subject's entry in the CTL.  pUsagePara can
  //  optionally be set to enable the above CTL_FIND_USAGE matching.
  //
  //  pvFindPara points to a CTL_FIND_SUBJECT_PARA data structure.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  Add the encoded CTL to the store according to the specified
  //  disposition option.
  //
  //  Makes a copy of the encoded CTL before adding to the store.
  //
  //  dwAddDispostion specifies the action to take if the CTL
  //  already exists in the store. See CertAddEncodedCertificateToStore for a
  //  list of and actions taken.
  //
  //  Compares the CTL's SubjectUsage, ListIdentifier and any of its signers
  //  to determine if the CTL already exists in the store.
  //
  //  ppCtlContext can be NULL, indicating the caller isn't interested
  //  in getting the CTL_CONTEXT of the added or existing CTL.
  //--------------------------------------------------------------------------
function CertAddEncodedCTLToStore(
  hCertStore: HCERTSTORE;
  dwMsgAndCertEncodingType: DWORD;
  pbCtlEncoded: PBYTE;
  cbCtlEncoded: DWORD;
  dwAddDisposition: DWORD;
  ppCtlContext: PPCCTL_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Add the CTL context to the store according to the specified
//  disposition option.
//
//  In addition to the encoded CTL, the context's properties are
//  also copied.  Note, the CERT_KEY_CONTEXT_PROP_ID property (and its
//  CERT_KEY_PROV_HANDLE_PROP_ID or CERT_KEY_SPEC_PROP_ID) isn't copied.
//
//  Makes a copy of the encoded CTL before adding to the store.
//
//  dwAddDispostion specifies the action to take if the CTL
//  already exists in the store. See CertAddCertificateContextToStore for a
//  list of and actions taken.
//
//  Compares the CTL's SubjectUsage, ListIdentifier and any of its signers
//  to determine if the CTL already exists in the store.
//
//  ppStoreContext can be NULL, indicating the caller isn't interested
//  in getting the CTL_CONTEXT of the added or existing CTL.
//--------------------------------------------------------------------------
function CertAddCTLContextToStore(
  hCertStore: HCERTSTORE;
  pCtlContext: PCCTL_CONTEXT;
  dwAddDisposition: DWORD;
  ppStoreContext: PPCCTL_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Serialize the CTL context's encoded CTL and its properties.
//--------------------------------------------------------------------------
function CertSerializeCTLStoreElement(
  pCtlContext: PCCTL_CONTEXT;
  dwFlags: DWORD;
  pbElement: PBYTE;
  var pcbElement: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Delete the specified CTL from the store.
//
//  All subsequent gets for the CTL will fail. However,
//  memory allocated for the CTL isn't freed until all of its contexts
//  have also been freed.
//
//  The pCtlContext is obtained from a get or duplicate.
//
//  NOTE: the pCtlContext is always CertFreeCTLContext'ed by
//  this function, even for an error.
//--------------------------------------------------------------------------
function CertDeleteCTLFromStore(
  pCtlContext: PCCTL_CONTEXT
  ): BOOL; stdcall;

function CertAddCertificateLinkToStore(
  hCertStore: HCERTSTORE;
  pCertContext: PCCERT_CONTEXT;
  dwAddDisposition: DWORD;
  ppStoreContext: PPCCERT_CONTEXT
  ): BOOL; stdcall;

function CertAddCRLLinkToStore(
  hCertStore: HCERTSTORE;
  pCrlContext: PCCRL_CONTEXT;
  dwAddDisposition: DWORD;
  ppStoreContext: PPCCRL_CONTEXT
  ): BOOL; stdcall;

function CertAddCTLLinkToStore(
  hCertStore: HCERTSTORE;
  pCtlContext: PCCTL_CONTEXT;
  dwAddDisposition: DWORD;
  ppStoreContext: PPCCTL_CONTEXT
  ): BOOL; stdcall;

function CertAddStoreToCollection(
  hCollectionStore: HCERTSTORE;
  hSiblingStore: HCERTSTORE;
  dwUpdateFlags: DWORD;
  dwPriority: DWORD
  ): BOOL; stdcall;

procedure CertRemoveStoreFromCollection(
  hCollectionStore: HCERTSTORE;
  hSiblingStore: HCERTSTORE
  ); stdcall;

function CertControlStore(
  hCertStore: HCERTSTORE;
  dwFlags: DWORD;
  dwCtrlType: DWORD;
  pvCtrlPara: pointer
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Certificate Store control types
//--------------------------------------------------------------------------
const
  CERT_STORE_CTRL_RESYNC        = 1;
  CERT_STORE_CTRL_NOTIFY_CHANGE = 2;
  CERT_STORE_CTRL_COMMIT        = 3;
  CERT_STORE_CTRL_AUTO_RESYNC   = 4;
  CERT_STORE_CTRL_CANCEL_NOTIFY = 5;

  CERT_STORE_CTRL_INHIBIT_DUPLICATE_HANDLE_FLAG = $1;

  //+-------------------------------------------------------------------------
  //  CERT_STORE_CTRL_RESYNC
  //
  //  Re-synchronize the store.
  //
  //  The pvCtrlPara points to the event HANDLE to be signaled on
  //  the next store change. Normally, this would be the same
  //  event HANDLE passed to CERT_STORE_CTRL_NOTIFY_CHANGE during initialization.
  //
  //  If pvCtrlPara is NULL, no events are re-armed.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_STORE_CTRL_NOTIFY_CHANGE
  //
  //  Signal the event when the underlying store is changed.
  //
  //  pvCtrlPara points to the event HANDLE to be signaled.
  //
  //  pvCtrlPara can be NULL to inform the store of a subsequent
  //  CERT_STORE_CTRL_RESYNC and allow it to optimize by only doing a resync
  //  if the store has changed. For the registry based stores, an internal
  //  notify change event is created and registered to be signaled.
  //
  //  Recommend calling CERT_STORE_CTRL_NOTIFY_CHANGE once for each event to
  //  be passed to CERT_STORE_CTRL_RESYNC. This should only happen after
  //  the event has been created. Not after each time the event is signaled.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_STORE_CTRL_AUTO_RESYNC
  //
  //  At the start of every enumeration or find store API call, check if the
  //  underlying store has changed. If it has changed, re-synchronize.
  //
  //  This check is only done in the enumeration or find APIs when the
  //  pPrevContext is NULL.
  //
  //  The pvCtrlPara isn't used and must be set to NULL.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_STORE_CTRL_COMMIT
  //
  //  If any changes have been to the cached store, they are committed to
  //  persisted storage. If no changes have been made since the store was
  //  opened or the last commit, this call is ignored. May also be ignored by
  //  store providers that persist changes immediately.
  //
  //  CERT_STORE_CTRL_COMMIT_FORCE_FLAG can be set to force the store
  //  to be committed even if it hasn't been touched.
  //
  //  CERT_STORE_CTRL_COMMIT_CLEAR_FLAG can be set to inhibit a commit on
  //  store close.
  //--------------------------------------------------------------------------
const
  CERT_STORE_CTRL_COMMIT_FORCE_FLAG = $1;
  CERT_STORE_CTRL_COMMIT_CLEAR_FLAG = $2;

  //+=========================================================================
  //  Cert Store Property Defines and APIs
  //==========================================================================

  //+-------------------------------------------------------------------------
  //  Store property IDs. This is a property applicable to the entire store.
  //  Its not a property on an individual certificate, CRL or CTL context.
  //
  //  Currently, no store properties are persisted. (This differs from
  //  most context properties which are persisted.)
  //
  //  See CertSetStoreProperty or CertGetStoreProperty for usage information.
  //
  //  Note, the range for predefined store properties should be outside
  //  the range of predefined context properties. We will start at 4096.
  //--------------------------------------------------------------------------
  CERT_STORE_LOCALIZED_NAME_PROP_ID = $1000;

  //+-------------------------------------------------------------------------
  //  Set a store property.
  //
  //  The type definition for pvData depends on the dwPropId value.
  //      CERT_STORE_LOCALIZED_NAME_PROP_ID - localized name of the store.
  //      pvData points to a CRYPT_DATA_BLOB. pbData is a pointer to a NULL
  //      terminated unicode, wide character string.
  //      cbData = (wcslen((LPWSTR) pbData) + 1) * sizeof(WCHAR).
  //
  //  For all the other PROP_IDs: an encoded PCRYPT_DATA_BLOB is passed in pvData.
  //
  //  If the property already exists, then, the old value is deleted and silently
  //  replaced. Setting, pvData to NULL, deletes the property.
  //--------------------------------------------------------------------------
function CertSetStoreProperty(
  hCertStore: HCERTSTORE;
  dwPropId: DWORD;
  dwFlags: DWORD;
  pvData: pointer
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Get a store property.
//
//  The type definition for pvData depends on the dwPropId value.
//      CERT_STORE_LOCALIZED_NAME_PROP_ID - localized name of the store.
//      pvData points to a NULL terminated unicode, wide character string.
//      cbData = (wcslen((LPWSTR) pvData) + 1) * sizeof(WCHAR).
//
//  For all other PROP_IDs, pvData points to an array of bytes.
//
//  If the property doesn't exist, returns FALSE and sets LastError to
//  CRYPT_E_NOT_FOUND.
//--------------------------------------------------------------------------
function CertGetStoreProperty(
  hCertStore: HCERTSTORE;
  dwPropId: DWORD;
  pvData: pointer;
  var pcbData: DWORD
  ): BOOL; stdcall;

type
  CERT_CREATE_CONTEXT_PARA = record
    cbSize:  DWORD;
    pfnFree: PFN_CRYPT_FREE; // OPTIONAL
    pvFree:  pointer; // OPTIONAL
  end;
  PCERT_CREATE_CONTEXT_PARA = ^CERT_CREATE_CONTEXT_PARA;

  //+-------------------------------------------------------------------------
  //  Creates the specified context from the encoded bytes. The created
  //  context isn't put in a store.
  //
  //  dwContextType values:
  //      CERT_STORE_CERTIFICATE_CONTEXT
  //      CERT_STORE_CRL_CONTEXT
  //      CERT_STORE_CTL_CONTEXT
  //
  //  If CERT_CREATE_CONTEXT_NOCOPY_FLAG is set, the created context points
  //  directly to the pbEncoded instead of an allocated copy. See flag
  //  definition for more details.
  //
  //  If CERT_CREATE_CONTEXT_SORTED_FLAG is set, the context is created
  //  with sorted entries. This flag may only be set for CERT_STORE_CTL_CONTEXT.
  //  Setting this flag implicitly sets CERT_CREATE_CONTEXT_NO_HCRYPTMSG_FLAG and
  //  CERT_CREATE_CONTEXT_NO_ENTRY_FLAG. See flag definition for
  //  more details.
  //
  //  If CERT_CREATE_CONTEXT_NO_HCRYPTMSG_FLAG is set, the context is created
  //  without creating a HCRYPTMSG handle for the context. This flag may only be
  //  set for CERT_STORE_CTL_CONTEXT.  See flag definition for more details.
  //
  //  If CERT_CREATE_CONTEXT_NO_ENTRY_FLAG is set, the context is created
  //  without decoding the entries. This flag may only be set for
  //  CERT_STORE_CTL_CONTEXT.  See flag definition for more details.
  //
  //  If unable to decode and create the context, NULL is returned.
  //  Otherwise, a pointer to a read only CERT_CONTEXT, CRL_CONTEXT or
  //  CTL_CONTEXT is returned. The context must be freed by the appropriate
  //  free context API. The context can be duplicated by calling the
  //  appropriate duplicate context API.
  //--------------------------------------------------------------------------
function CertCreateContext(
  dwContextType: DWORD;
  dwEncodingType: DWORD;
  pbEncoded: PBYTE;
  cbEncoded: DWORD;
  dwFlags: DWORD;
  pCreatePara: PCERT_CREATE_CONTEXT_PARA
  ): pointer; stdcall;

// When the following flag is set, the created context points directly to the
// pbEncoded instead of an allocated copy. If pCreatePara and
// pCreatePara->pfnFree are non-NULL, then, pfnFree is called to free
// the pbEncoded when the context is last freed. Otherwise, no attempt is
// made to free the pbEncoded. If pCreatePara->pvFree is non-NULL, then its
// passed to pfnFree instead of pbEncoded.
//
// Note, if CertCreateContext fails, pfnFree is still called.
const
  CERT_CREATE_CONTEXT_NOCOPY_FLAG = $1;

  // When the following flag is set, a context with sorted entries is created.
  // Currently only applicable to a CTL context.
  //
  // For CTLs: the cCTLEntry in the returned CTL_INFO is always
  // 0. CertFindSubjectInSortedCTL and CertEnumSubjectInSortedCTL must be called
  // to find or enumerate the CTL entries.
  //
  // The Sorted CTL TrustedSubjects extension isn't returned in the created
  // context's CTL_INFO.
  CERT_CREATE_CONTEXT_SORTED_FLAG = $2;

  // By default when a CTL context is created, a HCRYPTMSG handle to its
  // SignedData message is created. This flag can be set to improve performance
  // by not creating the HCRYPTMSG handle.
  //
  // This flag is only applicable to a CTL context.
  CERT_CREATE_CONTEXT_NO_HCRYPTMSG_FLAG = $4;

  // By default when a CTL context is created, its entries are decoded.
  // This flag can be set to improve performance by not decoding the
  // entries.
  //
  // This flag is only applicable to a CTL context.
  CERT_CREATE_CONTEXT_NO_ENTRY_FLAG = $8;

  //+=========================================================================
  //  Certificate System Store Data Structures and APIs
  //==========================================================================

  //+-------------------------------------------------------------------------
  //  System Store Information
  //
  //  Currently, no system store information is persisted.
  //--------------------------------------------------------------------------
type
  CERT_SYSTEM_STORE_INFO = record
    cbSize: DWORD;
  end;
  PCERT_SYSTEM_STORE_INFO = ^CERT_SYSTEM_STORE_INFO;

  //+-------------------------------------------------------------------------
  //  Physical Store Information
  //
  //  The Open fields are passed directly to CertOpenStore() to open
  //  the physical store.
  //
  //  By default all system stores located in the registry have an
  //  implicit SystemRegistry physical store that is opened. To disable the
  //  opening of this store, the SystemRegistry
  //  physical store corresponding to the System store must be registered with
  //  CERT_PHYSICAL_STORE_OPEN_DISABLE_FLAG set in dwFlags. Alternatively,
  //  a physical store with the name of ".Default" may be registered.
  //
  //  Depending on the store location and store name, additional predefined
  //  physical stores may be opened. For example, system stores in
  //  CURRENT_USER have the predefined physical store, .LocalMachine.
  //  To disable the opening of these predefined physical stores, the
  //  corresponding physical store must be registered with
  //  CERT_PHYSICAL_STORE_OPEN_DISABLE_FLAG set in dwFlags.
  //
  //  The CERT_PHYSICAL_STORE_ADD_ENABLE_FLAG must be set in dwFlags
  //  to enable the adding of a context to the store.
  //
  //  When a system store is opened via the SERVICES or USERS store location,
  //  the ServiceName\ is prepended to the OpenParameters
  //  for CERT_SYSTEM_STORE_CURRENT_USER or CERT_SYSTEM_STORE_CURRENT_SERVICE
  //  physical stores and the dwOpenFlags store location is changed to
  //  CERT_SYSTEM_STORE_USERS or CERT_SYSTEM_STORE_SERVICES.
  //
  //  By default the SYSTEM, SYSTEM_REGISTRY and PHYSICAL provider
  //  stores are also opened remotely when the outer system store is opened.
  //  The CERT_PHYSICAL_STORE_REMOTE_OPEN_DISABLE_FLAG may be set in dwFlags
  //  to disable remote opens.
  //
  //  When opened remotely, the \\ComputerName is implicitly prepended to the
  //  OpenParameters for the SYSTEM, SYSTEM_REGISTRY and PHYSICAL provider types.
  //  To also prepend the \\ComputerName to other provider types, set the
  //  CERT_PHYSICAL_STORE_INSERT_COMPUTER_NAME_ENABLE_FLAG in dwFlags.
  //
  //  When the system store is opened, its physical stores are ordered
  //  according to the dwPriority. A larger dwPriority indicates higher priority.
  //--------------------------------------------------------------------------
type
  CERT_PHYSICAL_STORE_INFO = record
    cbSize:               DWORD;
    pszOpenStoreProvider: LPSTR; // REG_SZ
    dwOpenEncodingType:   DWORD; // REG_DWORD
    dwOpenFlags:          DWORD; // REG_DWORD
    OpenParameters:       CRYPT_DATA_BLOB; // REG_BINARY
    dwFlags:              DWORD; // REG_DWORD
    dwPriority:           DWORD; // REG_DWORD
  end;
  PCERT_PHYSICAL_STORE_INFO = ^CERT_PHYSICAL_STORE_INFO;

  //+-------------------------------------------------------------------------
  //  Physical Store Information dwFlags
  //--------------------------------------------------------------------------
const
  CERT_PHYSICAL_STORE_ADD_ENABLE_FLAG                  = $1;
  CERT_PHYSICAL_STORE_OPEN_DISABLE_FLAG                = $2;
  CERT_PHYSICAL_STORE_REMOTE_OPEN_DISABLE_FLAG         = $4;
  CERT_PHYSICAL_STORE_INSERT_COMPUTER_NAME_ENABLE_FLAG = $8;

  //+-------------------------------------------------------------------------
  //  Register a system store.
  //
  //  The upper word of the dwFlags parameter is used to specify the location of
  //  the system store.
  //
  //  If CERT_SYSTEM_STORE_RELOCATE_FLAG is set in dwFlags, pvSystemStore
  //  points to a CERT_SYSTEM_STORE_RELOCATE_PARA data structure. Otherwise,
  //  pvSystemStore points to a null terminated UNICODE string.
  //
  //  The CERT_SYSTEM_STORE_SERVICES or CERT_SYSTEM_STORE_USERS system store
  //  name must be prefixed with the ServiceName or UserName. For example,
  //  "ServiceName\Trust".
  //
  //  Stores on remote computers can be registered for the
  //  CERT_SYSTEM_STORE_LOCAL_MACHINE, CERT_SYSTEM_STORE_SERVICES,
  //  CERT_SYSTEM_STORE_USERS, CERT_SYSTEM_STORE_LOCAL_MACHINE_GROUP_POLICY
  //  or CERT_SYSTEM_STORE_LOCAL_MACHINE_ENTERPRISE
  //  locations by prepending the computer name. For example, a remote
  //  local machine store is registered via "\\ComputerName\Trust" or
  //  "ComputerName\Trust". A remote service store is registered via
  //  "\\ComputerName\ServiceName\Trust". The leading "\\" backslashes are
  //  optional in the ComputerName.
  //
  //  Set CERT_STORE_CREATE_NEW_FLAG to cause a failure if the system store
  //  already exists in the store location.
  //--------------------------------------------------------------------------
function CertRegisterSystemStore(
  pvSystemStore: pointer;
  dwFlags: DWORD;
  pStoreInfo: PCERT_SYSTEM_STORE_INFO;
  pvReserved: pointer
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Register a physical store for the specified system store.
//
//  The upper word of the dwFlags parameter is used to specify the location of
//  the system store.
//
//  If CERT_SYSTEM_STORE_RELOCATE_FLAG is set in dwFlags, pvSystemStore
//  points to a CERT_SYSTEM_STORE_RELOCATE_PARA data structure. Otherwise,
//  pvSystemStore points to a null terminated UNICODE string.
//
//  See CertRegisterSystemStore for details on prepending a ServiceName
//  and/or ComputerName to the system store name.
//
//  Set CERT_STORE_CREATE_NEW_FLAG to cause a failure if the physical store
//  already exists in the system store.
//--------------------------------------------------------------------------
function CertRegisterPhysicalStore(
  pvSystemStore: pointer;
  dwFlags: DWORD;
  pwszStoreName: LPCWSTR;
  pStoreInfo: PCERT_PHYSICAL_STORE_INFO;
  pvReserved: pointer
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Unregister the specified system store.
//
//  The upper word of the dwFlags parameter is used to specify the location of
//  the system store.
//
//  If CERT_SYSTEM_STORE_RELOCATE_FLAG is set in dwFlags, pvSystemStore
//  points to a CERT_SYSTEM_STORE_RELOCATE_PARA data structure. Otherwise,
//  pvSystemStore points to a null terminated UNICODE string.
//
//  See CertRegisterSystemStore for details on prepending a ServiceName
//  and/or ComputerName to the system store name.
//
//  CERT_STORE_DELETE_FLAG can optionally be set in dwFlags.
//--------------------------------------------------------------------------
function CertUnregisterSystemStore(
  pvSystemStore: pointer;
  dwFlags: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Unregister the physical store from the specified system store.
//
//  The upper word of the dwFlags parameter is used to specify the location of
//  the system store.
//
//  If CERT_SYSTEM_STORE_RELOCATE_FLAG is set in dwFlags, pvSystemStore
//  points to a CERT_SYSTEM_STORE_RELOCATE_PARA data structure. Otherwise,
//  pvSystemStore points to a null terminated UNICODE string.
//
//  See CertRegisterSystemStore for details on prepending a ServiceName
//  and/or ComputerName to the system store name.
//
//  CERT_STORE_DELETE_FLAG can optionally be set in dwFlags.
//--------------------------------------------------------------------------
function CertUnregisterPhysicalStore(
  pvSystemStore: pointer;
  dwFlags: DWORD;
  pwszStoreName: LPCWSTR
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Enum callbacks
//
//  The CERT_SYSTEM_STORE_LOCATION_MASK bits in the dwFlags parameter
//  specifies the location of the system store
//
//  If CERT_SYSTEM_STORE_RELOCATE_FLAG is set in dwFlags, pvSystemStore
//  points to a CERT_SYSTEM_STORE_RELOCATE_PARA data structure. Otherwise,
//  pvSystemStore points to a null terminated UNICODE string.
//
//  The callback returns FALSE and sets LAST_ERROR to stop the enumeration.
//  The LAST_ERROR is returned to the caller of the enumeration.
//
//  The pvSystemStore passed to the callback has leading ComputerName and/or
//  ServiceName prefixes where appropriate.
//--------------------------------------------------------------------------

type
  PFN_CERT_ENUM_SYSTEM_STORE_LOCATION = function(
    pwszStoreLocation: LPCWSTR;
    dwFlags: DWORD;
    pvReserved: pointer;
    pvArg: pointer
    ): BOOL; stdcall;

type
  PFN_CERT_ENUM_SYSTEM_STORE = function(
    pvSystemStore: pointer;
    dwFlags: DWORD;
    pStoreInfo: PCERT_SYSTEM_STORE_INFO;
    pvReserved: pointer;
    pvArg: pointer
    ): BOOL; stdcall;

type
  PFN_CERT_ENUM_PHYSICAL_STORE = function(
    pvSystemStore: pointer;
    dwFlags: DWORD;
    pwszStoreName: LPCWSTR;
    pStoreInfo: PCERT_PHYSICAL_STORE_INFO;
    pvReserved: pointer;
    pvArg: pointer
    ): BOOL; stdcall;

  // In the PFN_CERT_ENUM_PHYSICAL_STORE callback the following flag is
  // set if the physical store wasn't registered and is an implicitly created
  // predefined physical store.
const
  CERT_PHYSICAL_STORE_PREDEFINED_ENUM_FLAG = $1;

  // Names of implicitly created predefined physical stores
  CERT_PHYSICAL_STORE_DEFAULT_NAME             = WideString('.Default');
  CERT_PHYSICAL_STORE_GROUP_POLICY_NAME        = WideString('.GroupPolicy');
  CERT_PHYSICAL_STORE_LOCAL_MACHINE_NAME       = WideString('.LocalMachine');
  CERT_PHYSICAL_STORE_DS_USER_CERTIFICATE_NAME = WideString('.UserCertificate');
  CERT_PHYSICAL_STORE_LOCAL_MACHINE_GROUP_POLICY_NAME
    = WideString('.LocalMachineGroupPolicy');
  CERT_PHYSICAL_STORE_ENTERPRISE_NAME          = WideString('.Enterprise');
  CERT_PHYSICAL_STORE_AUTH_ROOT_NAME           = WideString('.AuthRoot');

  //+-------------------------------------------------------------------------
  //  Enumerate the system store locations.
  //--------------------------------------------------------------------------
function CertEnumSystemStoreLocation(
  dwFlags: DWORD;
  pvArg: pointer;
  pfnEnum: PFN_CERT_ENUM_SYSTEM_STORE_LOCATION
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Enumerate the system stores.
//
//  The upper word of the dwFlags parameter is used to specify the location of
//  the system store.
//
//  If CERT_SYSTEM_STORE_RELOCATE_FLAG is set in dwFlags,
//  pvSystemStoreLocationPara points to a CERT_SYSTEM_STORE_RELOCATE_PARA
//  data structure. Otherwise, pvSystemStoreLocationPara points to a null
//  terminated UNICODE string.
//
//  For CERT_SYSTEM_STORE_LOCAL_MACHINE,
//  CERT_SYSTEM_STORE_LOCAL_MACHINE_GROUP_POLICY or
//  CERT_SYSTEM_STORE_LOCAL_MACHINE_ENTERPRISE, pvSystemStoreLocationPara can
//  optionally be set to a unicode computer name for enumerating local machine
//  stores on a remote computer. For example, "\\ComputerName" or
//  "ComputerName".  The leading "\\" backslashes are optional in the
//  ComputerName.
//
//  For CERT_SYSTEM_STORE_SERVICES or CERT_SYSTEM_STORE_USERS,
//  if pvSystemStoreLocationPara is NULL, then,
//  enumerates both the service/user names and the stores for each service/user
//  name. Otherwise, pvSystemStoreLocationPara is a unicode string specifying a
//  remote computer name and/or service/user name. For example:
//      "ServiceName"
//      "\\ComputerName" or "ComputerName\"
//      "ComputerName\ServiceName"
//  Note, if only the ComputerName is specified, then, it must have either
//  the leading "\\" backslashes or a trailing backslash. Otherwise, its
//  interpretted as the ServiceName or UserName.
//--------------------------------------------------------------------------
function CertEnumSystemStore(
  dwFlags: DWORD;
  pvSystemStoreLocationPara: pointer;
  pvArg: pointer;
  pfnEnum: PFN_CERT_ENUM_SYSTEM_STORE
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Enumerate the physical stores for the specified system store.
//
//  The upper word of the dwFlags parameter is used to specify the location of
//  the system store.
//
//  If CERT_SYSTEM_STORE_RELOCATE_FLAG is set in dwFlags, pvSystemStore
//  points to a CERT_SYSTEM_STORE_RELOCATE_PARA data structure. Otherwise,
//  pvSystemStore points to a null terminated UNICODE string.
//
//  See CertRegisterSystemStore for details on prepending a ServiceName
//  and/or ComputerName to the system store name.
//
//  If the system store location only supports system stores and doesn't
//  support physical stores, LastError is set to ERROR_CALL_NOT_IMPLEMENTED.
//--------------------------------------------------------------------------
function CertEnumPhysicalStore(
  pvSystemStore: pointer;
  dwFlags: DWORD;
  pvArg: pointer;
  pfnEnum: PFN_CERT_ENUM_PHYSICAL_STORE
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Certificate System Store Installable Functions
//
//  The CERT_SYSTEM_STORE_LOCATION_MASK bits in the dwFlags parameter passed
//  to the CertOpenStore(for "System", "SystemRegistry" or "Physical"
//  Provider), CertRegisterSystemStore,
//  CertUnregisterSystemStore, CertEnumSystemStore, CertRegisterPhysicalStore,
//  CertUnregisterPhysicalStore and CertEnumPhysicalStore APIs is used as the
//  constant pszOID value passed to the OID installable functions.
//  Therefore, the pszOID is restricted to a constant <= (LPCSTR) 0x0FFF.
//
//  The EncodingType is 0.
//--------------------------------------------------------------------------

// Installable System Store Provider OID pszFuncNames.
const
  CRYPT_OID_OPEN_SYSTEM_STORE_PROV_FUNC    = 'CertDllOpenSystemStoreProv';
  CRYPT_OID_REGISTER_SYSTEM_STORE_FUNC     = 'CertDllRegisterSystemStore';
  CRYPT_OID_UNREGISTER_SYSTEM_STORE_FUNC   = 'CertDllUnregisterSystemStore';
  CRYPT_OID_ENUM_SYSTEM_STORE_FUNC         = 'CertDllEnumSystemStore';
  CRYPT_OID_REGISTER_PHYSICAL_STORE_FUNC   = 'CertDllRegisterPhysicalStore';
  CRYPT_OID_UNREGISTER_PHYSICAL_STORE_FUNC = 'CertDllUnregisterPhysicalStore';
  CRYPT_OID_ENUM_PHYSICAL_STORE_FUNC       = 'CertDllEnumPhysicalStore';

  // CertDllOpenSystemStoreProv has the same function signature as the
  // installable "CertDllOpenStoreProv" function. See CertOpenStore for
  // more details.

  // CertDllRegisterSystemStore has the same function signature as
  // CertRegisterSystemStore.
  //
  // The "SystemStoreLocation" REG_SZ value must also be set for registered
  // CertDllEnumSystemStore OID functions.
  CRYPT_OID_SYSTEM_STORE_LOCATION_VALUE_NAME =
    WideString('SystemStoreLocation');

  // The remaining Register, Enum and Unregister OID installable functions
  // have the same signature as their Cert Store API counterpart.

  //+=========================================================================
  //  Enhanced Key Usage Helper Functions
  //==========================================================================

  //+-------------------------------------------------------------------------
  //  Get the enhanced key usage extension or property from the certificate
  //  and decode.
  //
  //  If the CERT_FIND_EXT_ONLY_ENHKEY_USAGE_FLAG is set, then, only get the
  //  extension.
  //
  //  If the CERT_FIND_PROP_ONLY_ENHKEY_USAGE_FLAG is set, then, only get the
  //  property.
  //--------------------------------------------------------------------------
function CertGetEnhancedKeyUsage(
  pCertContext: PCCERT_CONTEXT;
  dwFlags: DWORD;
  pUsage: PCERT_ENHKEY_USAGE;
  var pcbUsage: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Set the enhanced key usage property for the certificate.
//--------------------------------------------------------------------------
function CertSetEnhancedKeyUsage(
  pCertContext: PCCERT_CONTEXT;
  pUsage: PCERT_ENHKEY_USAGE
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Add the usage identifier to the certificate's enhanced key usage property.
//--------------------------------------------------------------------------
function CertAddEnhancedKeyUsageIdentifier(
  pCertContext: PCCERT_CONTEXT;
  pszUsageIdentifier: LPCSTR
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Remove the usage identifier from the certificate's enhanced key usage
//  property.
//--------------------------------------------------------------------------
function CertRemoveEnhancedKeyUsageIdentifier(
  pCertContext: PCCERT_CONTEXT;
  pszUsageIdentifier: LPCSTR
  ): BOOL; stdcall;

//+---------------------------------------------------------------------------
//  Takes an array of certs and returns an array of usages
//  which consists of the intersection of the valid usages for each cert.
//  If each cert is good for all possible usages then the cNumOIDs is set to -1.
//----------------------------------------------------------------------------
function CertGetValidUsages(
  cCerts: DWORD;
  rghCerts: PPCCERT_CONTEXT;
  var cNumOIDs: integer;
  rghOIDs: PLPSTR;
  var pcbOIDs: DWORD
  ): BOOL; stdcall;

//+=========================================================================
//  Cryptographic Message helper functions for verifying and signing a
//  CTL.
//==========================================================================

//+-------------------------------------------------------------------------
//  Get and verify the signer of a cryptographic message.
//
//  To verify a CTL, the hCryptMsg is obtained from the CTL_CONTEXT's
//  hCryptMsg field.
//
//  If CMSG_TRUSTED_SIGNER_FLAG is set, then, treat the Signer stores as being
//  trusted and only search them to find the certificate corresponding to the
//  signer's issuer and serial number.  Otherwise, the SignerStores are
//  optionally provided to supplement the message's store of certificates.
//  If a signer certificate is found, its public key is used to verify
//  the message signature. The CMSG_SIGNER_ONLY_FLAG can be set to
//  return the signer without doing the signature verify.
//
//  If CMSG_USE_SIGNER_INDEX_FLAG is set, then, only get the signer specified
//  by *pdwSignerIndex. Otherwise, iterate through all the signers
//  until a signer verifies or no more signers.
//
//  For a verified signature, *ppSigner is updated with certificate context
//  of the signer and *pdwSignerIndex is updated with the index of the signer.
//  ppSigner and/or pdwSignerIndex can be NULL, indicating the caller isn't
//  interested in getting the CertContext and/or index of the signer.
//--------------------------------------------------------------------------
type
  PHCERTSTORE = ^HCERTSTORE;
function CryptMsgGetAndVerifySigner(
  hCryptMsg: HCRYPTMSG;
  cSignerStore: DWORD;
  rghSignerStore: PHCERTSTORE;
  dwFlags: DWORD;
  ppSigner: PPCCERT_CONTEXT;
  var pdwSignerIndex: DWORD
  ): BOOL; stdcall;

const
  CMSG_TRUSTED_SIGNER_FLAG   = $1;
  CMSG_SIGNER_ONLY_FLAG      = $2;
  CMSG_USE_SIGNER_INDEX_FLAG = $4;

  //+-------------------------------------------------------------------------
  //  Sign an encoded CTL.
  //
  //  The pbCtlContent can be obtained via a CTL_CONTEXT's pbCtlContent
  //  field or via a CryptEncodeObject(PKCS_CTL or PKCS_SORTED_CTL).
  //
  //  CMSG_CMS_ENCAPSULATED_CTL_FLAG can be set to encode a CMS compatible
  //  V3 SignedData message.
  //--------------------------------------------------------------------------
function CryptMsgSignCTL(
  dwMsgEncodingType: DWORD;
  pbCtlContent: PBYTE;
  cbCtlContent: DWORD;
  pSignInfo: PCMSG_SIGNED_ENCODE_INFO;
  dwFlags: DWORD;
  pbEncoded: PBYTE;
  var pcbEncoded: DWORD
  ): BOOL; stdcall;

// When set, CTL inner content is encapsulated within an OCTET STRING
const
  CMSG_CMS_ENCAPSULATED_CTL_FLAG = $00008000;

  //+-------------------------------------------------------------------------
  //  Encode the CTL and create a signed message containing the encoded CTL.
  //
  //  Set CMSG_ENCODE_SORTED_CTL_FLAG if the CTL entries are to be sorted
  //  before encoding. This flag should be set, if the
  //  CertFindSubjectInSortedCTL or CertEnumSubjectInSortedCTL APIs will
  //  be called. If the identifier for the CTL entries is a hash, such as,
  //  MD5 or SHA1, then, CMSG_ENCODE_HASHED_SUBJECT_IDENTIFIER_FLAG should
  //  also be set.
  //
  //  CMSG_CMS_ENCAPSULATED_CTL_FLAG can be set to encode a CMS compatible
  //  V3 SignedData message.
  //--------------------------------------------------------------------------
function CryptMsgEncodeAndSignCTL(
  dwMsgEncodingType: DWORD;
  pCtlInfo: PCTL_INFO;
  pSignInfo: PCMSG_SIGNED_ENCODE_INFO;
  dwFlags: DWORD;
  pbEncoded: PBYTE;
  var pcbEncoded: DWORD
  ): BOOL; stdcall;

//  The following flag is set if the CTL is to be encoded with sorted
//  trusted subjects and the szOID_SORTED_CTL extension is inserted containing
//  sorted offsets to the encoded subjects.
const
  CMSG_ENCODE_SORTED_CTL_FLAG = $1;

  //  If the above sorted flag is set, then, the following flag should also
  //  be set if the identifier for the TrustedSubjects is a hash,
  //  such as, MD5 or SHA1.
  CMSG_ENCODE_HASHED_SUBJECT_IDENTIFIER_FLAG = $2;

  //+-------------------------------------------------------------------------
  //  Returns TRUE if the SubjectIdentifier exists in the CTL. Optionally
  //  returns a pointer to and byte count of the Subject's encoded attributes.
  //--------------------------------------------------------------------------
function CertFindSubjectInSortedCTL(
  pSubjectIdentifier: PCRYPT_DATA_BLOB;
  pCtlContext: PCCTL_CONTEXT;
  dwFlags: DWORD;
  pvReserved: pointer;
  var pEncodedAttributes: CRYPT_DER_BLOB
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Enumerates through the sequence of TrustedSubjects in a CTL context
//  created with CERT_CREATE_CONTEXT_SORTED_FLAG set.
//
//  To start the enumeration, *ppvNextSubject must be NULL. Upon return,
//  *ppvNextSubject is updated to point to the next TrustedSubject in
//  the encoded sequence.
//
//  Returns FALSE for no more subjects or invalid arguments.
//
//  Note, the returned DER_BLOBs point directly into the encoded
//  bytes (not allocated, and must not be freed).
//--------------------------------------------------------------------------
function CertEnumSubjectInSortedCTL(
  pCtlContext: PCCTL_CONTEXT;
  var ppvNextSubject: pointer;
  var pSubjectIdentifier: CRYPT_DER_BLOB;
  var pEncodedAttributes: CRYPT_DER_BLOB
  ): BOOL; stdcall;

//+=========================================================================
//  Certificate Verify CTL Usage Data Structures and APIs
//==========================================================================

type
  CTL_VERIFY_USAGE_PARA = record
    cbSize:         DWORD;
    ListIdentifier: CRYPT_DATA_BLOB; // OPTIONAL
    cCtlStore:      DWORD;
    rghCtlStore:    PHCERTSTORE; // OPTIONAL
    cSignerStore:   DWORD;
    rghSignerStore: PHCERTSTORE; // OPTIONAL
  end;
  PCTL_VERIFY_USAGE_PARA = ^CTL_VERIFY_USAGE_PARA;

type
  CTL_VERIFY_USAGE_STATUS = record
    cbSize:          DWORD;
    dwError:         DWORD;
    dwFlags:         DWORD;
    ppCtl:           ^PCCTL_CONTEXT; // IN OUT OPTIONAL
    dwCtlEntryIndex: DWORD;
    ppSigner:        PPCCERT_CONTEXT; // IN OUT OPTIONAL
    dwSignerIndex:   DWORD;
  end;
  PCTL_VERIFY_USAGE_STATUS = ^CTL_VERIFY_USAGE_STATUS;

const
  CERT_VERIFY_INHIBIT_CTL_UPDATE_FLAG = $1;
  CERT_VERIFY_TRUSTED_SIGNERS_FLAG    = $2;
  CERT_VERIFY_NO_TIME_CHECK_FLAG      = $4;
  CERT_VERIFY_ALLOW_MORE_USAGE_FLAG   = $8;

  CERT_VERIFY_UPDATED_CTL_FLAG        = $1;

  //+-------------------------------------------------------------------------
  //  Verify that a subject is trusted for the specified usage by finding a
  //  signed and time valid CTL with the usage identifiers and containing the
  //  the subject. A subject can be identified by either its certificate context
  //  or any identifier such as its SHA1 hash.
  //
  //  See CertFindSubjectInCTL for definition of dwSubjectType and pvSubject
  //  parameters.
  //
  //  Via pVerifyUsagePara, the caller can specify the stores to be searched
  //  to find the CTL. The caller can also specify the stores containing
  //  acceptable CTL signers. By setting the ListIdentifier, the caller
  //  can also restrict to a particular signer CTL list.
  //
  //  Via pVerifyUsageStatus, the CTL containing the subject, the subject's
  //  index into the CTL's array of entries, and the signer of the CTL
  //  are returned. If the caller is not interested, ppCtl and ppSigner can be set
  //  to NULL. Returned contexts must be freed via the store's free context APIs.
  //
  //  If the CERT_VERIFY_INHIBIT_CTL_UPDATE_FLAG isn't set, then, a time
  //  invalid CTL in one of the CtlStores may be replaced. When replaced, the
  //  CERT_VERIFY_UPDATED_CTL_FLAG is set in pVerifyUsageStatus->dwFlags.
  //
  //  If the CERT_VERIFY_TRUSTED_SIGNERS_FLAG is set, then, only the
  //  SignerStores specified in pVerifyUsageStatus are searched to find
  //  the signer. Otherwise, the SignerStores provide additional sources
  //  to find the signer's certificate.
  //
  //  If CERT_VERIFY_NO_TIME_CHECK_FLAG is set, then, the CTLs aren't checked
  //  for time validity.
  //
  //  If CERT_VERIFY_ALLOW_MORE_USAGE_FLAG is set, then, the CTL may contain
  //  additional usage identifiers than specified by pSubjectUsage. Otherwise,
  //  the found CTL will contain the same usage identifers and no more.
  //
  //  CertVerifyCTLUsage will be implemented as a dispatcher to OID installable
  //  functions. First, it will try to find an OID function matching the first
  //  usage object identifier in the pUsage sequence. Next, it will dispatch
  //  to the default CertDllVerifyCTLUsage functions.
  //
  //  If the subject is trusted for the specified usage, then, TRUE is
  //  returned. Otherwise, FALSE is returned with dwError set to one of the
  //  following:
  //      CRYPT_E_NO_VERIFY_USAGE_DLL
  //      CRYPT_E_NO_VERIFY_USAGE_CHECK
  //      CRYPT_E_VERIFY_USAGE_OFFLINE
  //      CRYPT_E_NOT_IN_CTL
  //      CRYPT_E_NO_TRUSTED_SIGNER
  //--------------------------------------------------------------------------
function CertVerifyCTLUsage(
  dwEncodingType: DWORD;
  dwSubjectType: DWORD;
  pvSubject: pointer;
  pSubjectUsage: PCTL_USAGE;
  dwFlags: DWORD;
  pVerifyUsagePara: PCTL_VERIFY_USAGE_PARA;
  var pVerifyUsageStatus: CTL_VERIFY_USAGE_STATUS
  ): BOOL; stdcall;

//+=========================================================================
//  Certificate Revocation Data Structures and APIs
//==========================================================================

//+-------------------------------------------------------------------------
//  This data structure is updated by a CRL revocation type handler
//  with the base and possibly the delta CRL used.
//--------------------------------------------------------------------------
type
  CERT_REVOCATION_CRL_INFO = record
    cbSize:           DWORD;
    pBaseCrlContext:  PCCRL_CONTEXT;
    pDeltaCrlContext: PCCRL_CONTEXT;
    // When revoked, points to entry in either of the above CRL contexts.
    // Don't free.
    pCrlEntry:        PCRL_ENTRY;
    fDeltaCrlEntry:   BOOL; // TRUE if in pDeltaCrlContext
  end;
  PCERT_REVOCATION_CRL_INFO = ^CERT_REVOCATION_CRL_INFO;

//+-------------------------------------------------------------------------
//  The following data structure may be passed to CertVerifyRevocation to
//  assist in finding the issuer of the context to be verified.
//
//  When pIssuerCert is specified, pIssuerCert is the issuer of
//  rgpvContext[cContext - 1].
//
//  When cCertStore and rgCertStore are specified, these stores may contain
//  an issuer certificate.
//
//  When hCrlStore is specified then a handler which uses CRLs can search this
//  store for them
//
//  When pftTimeToUse is specified then the handler (if possible) must determine
//  revocation status relative to the time given otherwise the answer may be
//  independent of time or relative to current time
//--------------------------------------------------------------------------
type
  LPFILETIME = ^FILETIME;
  CERT_REVOCATION_PARA = record
    cbSize:       DWORD;
    pIssuerCert:  PCCERT_CONTEXT;
    cCertStore:   DWORD;
    rgCertStore:  PHCERTSTORE;
    hCrlStore:    HCERTSTORE;
    pftTimeToUse: LPFILETIME;
{$IFDEF CERT_REVOCATION_PARA_HAS_EXTRA_FIELDS}
    // Note, if you #define CERT_REVOCATION_PARA_HAS_EXTRA_FIELDS, then, you
    // must zero all unused fields in this data structure.
    // More fields could be added in a future release.
    // 0 uses revocation handler's default timeout.
    dwUrlRetrievalTimeout: DWORD;  // milliseconds
    // When set, checks and attempts to retrieve a CRL where
    // ThisUpdate >= (CurrentTime - dwFreshnessTime). Otherwise, defaults
    // to using the CRL's NextUpdate.
    fCheckFreshnessTime:   BOOL;
    dwFreshnessTime:       DWORD;        // seconds
    // If NULL, revocation handler gets the current time
    pftCurrentTime:        LPFILETIME;
    // If nonNULL, a CRL revocation type handler updates with the base and
    // possibly the delta CRL used. Note, *pCrlInfo must be initialized
    // by the caller. Any nonNULL CRL contexts are freed. Any updated
    // CRL contexts must be freed by the caller.
    //
    // The CRL info is only applicable to the last context checked. If
    // interested in this information, then, CertVerifyRevocation should be
    // called with cContext = 1.
    pCrlInfo: PCERT_REVOCATION_CRL_INFO;
{$ENDIF}
  end;
  PCERT_REVOCATION_PARA = ^CERT_REVOCATION_PARA;

  //+-------------------------------------------------------------------------
  //  The following data structure is returned by CertVerifyRevocation to
  //  specify the status of the revoked or unchecked context. Review the
  //  following CertVerifyRevocation comments for details.
  //
  //  Upon input to CertVerifyRevocation, cbSize must be set to a size
  //  >= sizeof(CERT_REVOCATION_STATUS). Otherwise, CertVerifyRevocation
  //  returns FALSE and sets LastError to E_INVALIDARG.
  //
  //  Upon input to the installed or registered CRYPT_OID_VERIFY_REVOCATION_FUNC
  //  functions, the dwIndex, dwError and dwReason have been zero'ed.
  //--------------------------------------------------------------------------
type
  CERT_REVOCATION_STATUS = record
    cbSize:   DWORD;
    dwIndex:  DWORD;
    dwError:  DWORD;
    dwReason: DWORD;
    // Depending on cbSize, the following fields may optionally be returned.
    // The Freshness time is only applicable to the last context checked. If
    // interested in this information, then, CertVerifyRevocation should be
    // called with cContext = 1.
    //
    // fHasFreshnessTime is only set if we are able to retrieve revocation
    // information. For a CRL its CurrentTime - ThisUpdate.
    fHasFreshnessTime: BOOL;
    dwFreshnessTime:   DWORD;    // seconds
  end;
  PCERT_REVOCATION_STATUS = ^CERT_REVOCATION_STATUS;

  //+-------------------------------------------------------------------------
  //  Verifies the array of contexts for revocation. The dwRevType parameter
  //  indicates the type of the context data structure passed in rgpvContext.
  //  Currently only the revocation of certificates is defined.
  //
  //  If the CERT_VERIFY_REV_CHAIN_FLAG flag is set, then, CertVerifyRevocation
  //  is verifying a chain of certs where, rgpvContext[i + 1] is the issuer
  //  of rgpvContext[i]. Otherwise, CertVerifyRevocation makes no assumptions
  //  about the order of the contexts.
  //
  //  To assist in finding the issuer, the pRevPara may optionally be set. See
  //  the CERT_REVOCATION_PARA data structure for details.
  //
  //  The contexts must contain enough information to allow the
  //  installable or registered revocation DLLs to find the revocation server. For
  //  certificates, this information would normally be conveyed in an
  //  extension such as the IETF's AuthorityInfoAccess extension.
  //
  //  CertVerifyRevocation returns TRUE if all of the contexts were successfully
  //  checked and none were revoked. Otherwise, returns FALSE and updates the
  //  returned pRevStatus data structure as follows:
  //    dwIndex
  //      Index of the first context that was revoked or unable to
  //      be checked for revocation
  //    dwError
  //      Error status. LastError is also set to this error status.
  //      dwError can be set to one of the following error codes defined
  //      in winerror.h:
  //        ERROR_SUCCESS - good context
  //        CRYPT_E_REVOKED - context was revoked. dwReason contains the
  //           reason for revocation
  //        CRYPT_E_REVOCATION_OFFLINE - unable to connect to the
  //           revocation server
  //        CRYPT_E_NOT_IN_REVOCATION_DATABASE - the context to be checked
  //           was not found in the revocation server's database.
  //        CRYPT_E_NO_REVOCATION_CHECK - the called revocation function
  //           wasn't able to do a revocation check on the context
  //        CRYPT_E_NO_REVOCATION_DLL - no installed or registered Dll was
  //           found to verify revocation
  //    dwReason
  //      The dwReason is currently only set for CRYPT_E_REVOKED and contains
  //      the reason why the context was revoked. May be one of the following
  //      CRL reasons defined by the CRL Reason Code extension ("2.5.29.21")
  //          CRL_REASON_UNSPECIFIED              0
  //          CRL_REASON_KEY_COMPROMISE           1
  //          CRL_REASON_CA_COMPROMISE            2
  //          CRL_REASON_AFFILIATION_CHANGED      3
  //          CRL_REASON_SUPERSEDED               4
  //          CRL_REASON_CESSATION_OF_OPERATION   5
  //          CRL_REASON_CERTIFICATE_HOLD         6
  //
  //  For each entry in rgpvContext, CertVerifyRevocation iterates
  //  through the CRYPT_OID_VERIFY_REVOCATION_FUNC
  //  function set's list of installed DEFAULT functions.
  //  CryptGetDefaultOIDFunctionAddress is called with pwszDll = NULL. If no
  //  installed functions are found capable of doing the revocation verification,
  //  CryptVerifyRevocation iterates through CRYPT_OID_VERIFY_REVOCATION_FUNC's
  //  list of registered DEFAULT Dlls. CryptGetDefaultOIDDllList is called to
  //  get the list. CryptGetDefaultOIDFunctionAddress is called to load the Dll.
  //
  //  The called functions have the same signature as CertVerifyRevocation. A
  //  called function returns TRUE if it was able to successfully check all of
  //  the contexts and none were revoked. Otherwise, the called function returns
  //  FALSE and updates pRevStatus. dwIndex is set to the index of
  //  the first context that was found to be revoked or unable to be checked.
  //  dwError and LastError are updated. For CRYPT_E_REVOKED, dwReason
  //  is updated. Upon input to the called function, dwIndex, dwError and
  //  dwReason have been zero'ed. cbSize has been checked to be >=
  //  sizeof(CERT_REVOCATION_STATUS).
  //
  //  If the called function returns FALSE, and dwError isn't set to
  //  CRYPT_E_REVOKED, then, CertVerifyRevocation either continues on to the
  //  next DLL in the list for a returned dwIndex of 0 or for a returned
  //  dwIndex > 0, restarts the process of finding a verify function by
  //  advancing the start of the context array to the returned dwIndex and
  //  decrementing the count of remaining contexts.
  //--------------------------------------------------------------------------
function CertVerifyRevocation(
  dwEncodingType: DWORD;
  dwRevType: DWORD;
  cContext: DWORD;
  rgpvContext: pointer;
  dwFlags: DWORD;
  pRevPara: PCERT_REVOCATION_PARA;
  var pRevStatus: CERT_REVOCATION_STATUS
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Revocation types
//--------------------------------------------------------------------------
const
  CERT_CONTEXT_REVOCATION_TYPE = 1;

  //+-------------------------------------------------------------------------
  //  When the following flag is set, rgpvContext[] consists of a chain
  //  of certificates, where rgpvContext[i + 1] is the issuer of rgpvContext[i].
  //--------------------------------------------------------------------------
  CERT_VERIFY_REV_CHAIN_FLAG = $00000001;

  //+-------------------------------------------------------------------------
  // CERT_VERIFY_CACHE_ONLY_BASED_REVOCATION prevents the revocation handler from
  // accessing any network based resources for revocation checking
  //--------------------------------------------------------------------------
  CERT_VERIFY_CACHE_ONLY_BASED_REVOCATION = $00000002;

  //+-------------------------------------------------------------------------
  //  By default, the dwUrlRetrievalTimeout in pRevPara is the timeout used
  //  for each URL wire retrieval. When the following flag is set,
  //  dwUrlRetrievalTimeout is the accumulative timeout across all URL wire
  //  retrievals.
  //--------------------------------------------------------------------------
  CERT_VERIFY_REV_ACCUMULATIVE_TIMEOUT_FLAG  = $00000004;

  //+-------------------------------------------------------------------------
  //  CERT_CONTEXT_REVOCATION_TYPE
  //
  //  pvContext points to a const CERT_CONTEXT.
  //--------------------------------------------------------------------------

  //+=========================================================================
  //  Certificate Helper APIs
  //==========================================================================

  //+-------------------------------------------------------------------------
  //  Compare two multiple byte integer blobs to see if they are identical.
  //
  //  Before doing the comparison, leading zero bytes are removed from a
  //  positive number and leading 0xFF bytes are removed from a negative
  //  number.
  //
  //  The multiple byte integers are treated as Little Endian. pbData[0] is the
  //  least significant byte and pbData[cbData - 1] is the most significant
  //  byte.
  //
  //  Returns TRUE if the integer blobs are identical after removing leading
  //  0 or 0xFF bytes.
  //--------------------------------------------------------------------------
function CertCompareIntegerBlob(
  pInt1: PCRYPT_INTEGER_BLOB;
  pInt2: PCRYPT_INTEGER_BLOB
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Compare two certificates to see if they are identical.
//
//  Since a certificate is uniquely identified by its Issuer and SerialNumber,
//  these are the only fields needing to be compared.
//
//  Returns TRUE if the certificates are identical.
//--------------------------------------------------------------------------
function CertCompareCertificate(
  dwCertEncodingType: DWORD;
  pCertId1: PCERT_INFO;
  pCertId2: PCERT_INFO
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Compare two certificate names to see if they are identical.
//
//  Returns TRUE if the names are identical.
//--------------------------------------------------------------------------
function CertCompareCertificateName(
  dwCertEncodingType: DWORD;
  pCertName1: PCERT_NAME_BLOB;
  pCertName2: PCERT_NAME_BLOB
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Compare the attributes in the certificate name with the specified
//  Relative Distinguished Name's (CERT_RDN) array of attributes.
//  The comparison iterates through the CERT_RDN attributes and looks for an
//  attribute match in any of the certificate name's RDNs.
//  Returns TRUE if all the attributes are found and match.
//
//  The CERT_RDN_ATTR fields can have the following special values:
//    pszObjId == NULL              - ignore the attribute object identifier
//    dwValueType == RDN_ANY_TYPE   - ignore the value type
//
//  CERT_CASE_INSENSITIVE_IS_RDN_ATTRS_FLAG should be set to do
//  a case insensitive match. Otherwise, defaults to an exact, case sensitive
//  match.
//
//  CERT_UNICODE_IS_RDN_ATTRS_FLAG should be set if the pRDN was initialized
//  with unicode strings as for CryptEncodeObject(X509_UNICODE_NAME).
//--------------------------------------------------------------------------
function CertIsRDNAttrsInCertificateName(
  dwCertEncodingType: DWORD;
  dwFlags: DWORD;
  pCertName: PCERT_NAME_BLOB;
  pRDN: PCERT_RDN
  ): BOOL; stdcall;

const
  CERT_UNICODE_IS_RDN_ATTRS_FLAG          = $1;
  CERT_CASE_INSENSITIVE_IS_RDN_ATTRS_FLAG = $2;

  //+-------------------------------------------------------------------------
  //  Compare two public keys to see if they are identical.
  //
  //  Returns TRUE if the keys are identical.
  //--------------------------------------------------------------------------
function CertComparePublicKeyInfo(
  dwCertEncodingType: DWORD;
  pPublicKey1: PCERT_PUBLIC_KEY_INFO;
  pPublicKey2: PCERT_PUBLIC_KEY_INFO
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Get the public/private key's bit length.
//
//  Returns 0 if unable to determine the key's length.
//--------------------------------------------------------------------------
function CertGetPublicKeyLength(
  dwCertEncodingType: DWORD;
  pPublicKey: PCERT_PUBLIC_KEY_INFO
  ): DWORD; stdcall;

//+-------------------------------------------------------------------------
//  Verify the signature of a subject certificate or a CRL using the
//  public key info
//
//  Returns TRUE for a valid signature.
//
//  hCryptProv specifies the crypto provider to use to verify the signature.
//  It doesn't need to use a private key.
//--------------------------------------------------------------------------
function CryptVerifyCertificateSignature(
  hCryptProv: HCRYPTPROV;
  dwCertEncodingType: DWORD;
  pbEncoded: PBYTE;
  cbEncoded: DWORD;
  pPublicKey: PCERT_PUBLIC_KEY_INFO
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Verify the signature of a subject certificate, CRL, certificate request
//  or keygen request using the issuer's public key.
//
//  Returns TRUE for a valid signature.
//
//  The subject can be an encoded blob or a context for a certificate or CRL.
//  For a subject certificate context, if the certificate is missing
//  inheritable PublicKey Algorithm Parameters, the context's
//  CERT_PUBKEY_ALG_PARA_PROP_ID is updated with the issuer's public key
//  algorithm parameters for a valid signature.
//
//  The issuer can be a pointer to a CERT_PUBLIC_KEY_INFO, certificate
//  context or a chain context.
//
//  hCryptProv specifies the crypto provider to use to verify the signature.
//  Its private key isn't used. If hCryptProv is NULL, a default
//  provider is picked according to the PublicKey Algorithm OID.
//--------------------------------------------------------------------------
function CryptVerifyCertificateSignatureEx(
  hCryptProv: HCRYPTPROV;
  dwCertEncodingType: DWORD;
  dwSubjectType: DWORD;
  pvSubject: pointer;
  dwIssuerType: DWORD;
  pvIssuer: pointer;
  dwFlags: DWORD;
  pvReserved: pointer
  ): BOOL; stdcall;

// Subject Types
const
  CRYPT_VERIFY_CERT_SIGN_SUBJECT_BLOB = 1;
  // pvSubject :: PCRYPT_DATA_BLOB
  CRYPT_VERIFY_CERT_SIGN_SUBJECT_CERT = 2;
  // pvSubject :: PCCERT_CONTEXT
  CRYPT_VERIFY_CERT_SIGN_SUBJECT_CRL  = 3;
  // pvSubject :: PCCRL_CONTEXT

// Issuer Types
  CRYPT_VERIFY_CERT_SIGN_ISSUER_PUBKEY = 1;
  // pvIssuer :: PCERT_PUBLIC_KEY_INFO
  CRYPT_VERIFY_CERT_SIGN_ISSUER_CERT   = 2;
  // pvIssuer :: PCCERT_CONTEXT
  CRYPT_VERIFY_CERT_SIGN_ISSUER_CHAIN  = 3;
  // pvIssuer :: PCCERT_CHAIN_CONTEXT
  CRYPT_VERIFY_CERT_SIGN_ISSUER_NULL   = 4;
  // pvIssuer :: NULL

//+-------------------------------------------------------------------------
//  Compute the hash of the "to be signed" information in the encoded
//  signed content (CERT_SIGNED_CONTENT_INFO).
//
//  hCryptProv specifies the crypto provider to use to compute the hash.
//  It doesn't need to use a private key.
//--------------------------------------------------------------------------
function CryptHashToBeSigned(
  hCryptProv: HCRYPTPROV;
  dwCertEncodingType: DWORD;
  pbEncoded: PBYTE;
  cbEncoded: DWORD;
  pbComputedHash: PBYTE;
  var pcbComputedHash: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Hash the encoded content.
//
//  hCryptProv specifies the crypto provider to use to compute the hash.
//  It doesn't need to use a private key.
//
//  Algid specifies the CAPI hash algorithm to use. If Algid is 0, then, the
//  default hash algorithm (currently SHA1) is used.
//--------------------------------------------------------------------------
function CryptHashCertificate(
  hCryptProv: HCRYPTPROV;
  Algid: ALG_ID;
  dwFlags: DWORD;
  pbEncoded: PBYTE;
  cbEncoded: DWORD;
  pbComputedHash: PBYTE;
  var pcbComputedHash: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Sign the "to be signed" information in the encoded signed content.
//
//  hCryptProv specifies the crypto provider to use to do the signature.
//  It uses the specified private key.
//--------------------------------------------------------------------------
function CryptSignCertificate(
  hCryptProv: HCRYPTPROV;
  dwKeySpec: DWORD;
  dwCertEncodingType: DWORD;
  pbEncodedToBeSigned: PBYTE;
  cbEncodedToBeSigned: DWORD;
  pSignatureAlgorithm: PCRYPT_ALGORITHM_IDENTIFIER;
  pvHashAuxInfo: pointer;
  pbSignature: PBYTE;
  var pcbSignature: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Encode the "to be signed" information. Sign the encoded "to be signed".
//  Encode the "to be signed" and the signature.
//
//  hCryptProv specifies the crypto provider to use to do the signature.
//  It uses the specified private key.
//--------------------------------------------------------------------------
function CryptSignAndEncodeCertificate(
  hCryptProv: HCRYPTPROV;
  dwKeySpec: DWORD;
  dwCertEncodingType: DWORD;
  lpszStructType: LPCSTR; // "to be signed"
  pvStructInfo: pointer;
  pSignatureAlgorithm: PCRYPT_ALGORITHM_IDENTIFIER;
  pvHashAuxInfo: pointer;
  pbEncoded: PBYTE;
  var pcbEncoded: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Verify the time validity of a certificate.
//
//  Returns -1 if before NotBefore, +1 if after NotAfter and otherwise 0 for
//  a valid certificate
//
//  If pTimeToVerify is NULL, uses the current time.
//--------------------------------------------------------------------------
function CertVerifyTimeValidity(
  pTimeToVerify: LPFILETIME;
  pCertInfo: PCERT_INFO
  ): longint; stdcall;

//+-------------------------------------------------------------------------
//  Verify the time validity of a CRL.
//
//  Returns -1 if before ThisUpdate, +1 if after NextUpdate and otherwise 0 for
//  a valid CRL
//
//  If pTimeToVerify is NULL, uses the current time.
//--------------------------------------------------------------------------
function CertVerifyCRLTimeValidity(
  pTimeToVerify: LPFILETIME;
  pCrlInfo: PCRL_INFO
  ): longint; stdcall;

//+-------------------------------------------------------------------------
//  Verify that the subject's time validity nests within the issuer's time
//  validity.
//
//  Returns TRUE if it nests. Otherwise, returns FALSE.
//--------------------------------------------------------------------------
function CertVerifyValidityNesting(
  pSubjectInfo: PCERT_INFO;
  pIssuerInfo: PCERT_INFO
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Verify that the subject certificate isn't on its issuer CRL.
//
//  Returns true if the certificate isn't on the CRL.
//--------------------------------------------------------------------------
type
  TARR_PCRL_INFO = ^PCRL_INFO;
function CertVerifyCRLRevocation(
  dwCertEncodingType: DWORD;
  pCertId: PCERT_INFO; // Only the Issuer and SerialNumber
  // fields are used
  cCrlInfo: DWORD;
  rgpCrlInfo: TARR_PCRL_INFO
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Convert the CAPI AlgId to the ASN.1 Object Identifier string
//
//  Returns NULL if there isn't an ObjId corresponding to the AlgId.
//--------------------------------------------------------------------------
function CertAlgIdToOID(
  dwAlgId: DWORD
  ): LPCSTR; stdcall;

//+-------------------------------------------------------------------------
//  Convert the ASN.1 Object Identifier string to the CAPI AlgId.
//
//  Returns 0 if there isn't an AlgId corresponding to the ObjId.
//--------------------------------------------------------------------------
function CertOIDToAlgId(
  pszObjId: LPCSTR
  ): DWORD; stdcall;

//+-------------------------------------------------------------------------
//  Find an extension identified by its Object Identifier.
//
//  If found, returns pointer to the extension. Otherwise, returns NULL.
//--------------------------------------------------------------------------
function CertFindExtension(
  pszObjId: LPCSTR;
  cExtensions: DWORD;
  rgExtensions: TARR_CERT_EXTENSION
  ): PCERT_EXTENSION; stdcall;

//+-------------------------------------------------------------------------
//  Find the first attribute identified by its Object Identifier.
//
//  If found, returns pointer to the attribute. Otherwise, returns NULL.
//--------------------------------------------------------------------------
type
  TARR_CRYPT_ATTRIBUTE = ^CRYPT_ATTRIBUTE;
function CertFindAttribute(
  pszObjId: LPCSTR;
  cAttr: DWORD;
  rgAttr: TARR_CRYPT_ATTRIBUTE
  ): PCRYPT_ATTRIBUTE; stdcall;

//+-------------------------------------------------------------------------
//  Find the first CERT_RDN attribute identified by its Object Identifier in
//  the name's list of Relative Distinguished Names.
//
//  If found, returns pointer to the attribute. Otherwise, returns NULL.
//--------------------------------------------------------------------------
function CertFindRDNAttr(
  pszObjId: LPCSTR;
  pName: PCERT_NAME_INFO
  ): PCERT_RDN_ATTR; stdcall;

//+-------------------------------------------------------------------------
//  Get the intended key usage bytes from the certificate.
//
//  If the certificate doesn't have any intended key usage bytes, returns FALSE
//  and *pbKeyUsage is zeroed. Otherwise, returns TRUE and up through
//  cbKeyUsage bytes are copied into *pbKeyUsage. Any remaining uncopied
//  bytes are zeroed.
//--------------------------------------------------------------------------
function CertGetIntendedKeyUsage(
  dwCertEncodingType: DWORD;
  pCertInfo: PCERT_INFO;
  pbKeyUsage: PBYTE;
  cbKeyUsage: DWORD
  ): BOOL; stdcall;

type
  HCRYPTDEFAULTCONTEXT = pointer;

  //+-------------------------------------------------------------------------
  //  Install a previously CryptAcquiredContext'ed HCRYPTPROV to be used as
  //  a default context.
  //
  //  dwDefaultType and pvDefaultPara specify where the default context is used.
  //  For example, install the HCRYPTPROV to be used to verify certificate's
  //  having szOID_OIWSEC_md5RSA signatures.
  //
  //  By default, the installed HCRYPTPROV is only applicable to the current
  //  thread. Set CRYPT_DEFAULT_CONTEXT_PROCESS_FLAG to allow the HCRYPTPROV
  //  to be used by all threads in the current process.
  //
  //  For a successful install, TRUE is returned and *phDefaultContext is
  //  updated with the HANDLE to be passed to CryptUninstallDefaultContext.
  //
  //  The installed HCRYPTPROVs are stack ordered (the last installed
  //  HCRYPTPROV is checked first). All thread installed HCRYPTPROVs are
  //  checked before any process HCRYPTPROVs.
  //
  //  The installed HCRYPTPROV remains available for default usage until
  //  CryptUninstallDefaultContext is called or the thread or process exits.
  //
  //  If CRYPT_DEFAULT_CONTEXT_AUTO_RELEASE_FLAG is set, then, the HCRYPTPROV
  //  is CryptReleaseContext'ed at thread or process exit. However,
  //  not CryptReleaseContext'ed if CryptUninstallDefaultContext is
  //  called.
  //--------------------------------------------------------------------------
function CryptInstallDefaultContext(
  hCryptProv: HCRYPTPROV;
  dwDefaultType: DWORD;
  pvDefaultPara: pointer;
  dwFlags: DWORD;
  pvReserved: pointer;
  var phDefaultContext: HCRYPTDEFAULTCONTEXT
  ): BOOL; stdcall;

// dwFlags
const
  CRYPT_DEFAULT_CONTEXT_AUTO_RELEASE_FLAG = $00000001;
  CRYPT_DEFAULT_CONTEXT_PROCESS_FLAG      = $00000002;

  // List of dwDefaultType's
  CRYPT_DEFAULT_CONTEXT_CERT_SIGN_OID       = 1;
  CRYPT_DEFAULT_CONTEXT_MULTI_CERT_SIGN_OID = 2;

  //+-------------------------------------------------------------------------
  //  CRYPT_DEFAULT_CONTEXT_CERT_SIGN_OID
  //
  //  Install a default HCRYPTPROV used to verify a certificate
  //  signature. pvDefaultPara points to the szOID of the certificate
  //  signature algorithm, for example, szOID_OIWSEC_md5RSA. If
  //  pvDefaultPara is NULL, then, the HCRYPTPROV is used to verify all
  //  certificate signatures. Note, pvDefaultPara can't be NULL when
  //  CRYPT_DEFAULT_CONTEXT_PROCESS_FLAG is set.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CRYPT_DEFAULT_CONTEXT_MULTI_CERT_SIGN_OID
  //
  //  Same as CRYPT_DEFAULT_CONTEXT_CERT_SIGN_OID. However, the default
  //  HCRYPTPROV is to be used for multiple signature szOIDs. pvDefaultPara
  //  points to a CRYPT_DEFAULT_CONTEXT_MULTI_OID_PARA structure containing
  //  an array of szOID pointers.
  //--------------------------------------------------------------------------

type
  CRYPT_DEFAULT_CONTEXT_MULTI_OID_PARA = record
    cOID:     DWORD;
    rgpszOID: TARR_LPSTR;
  end;
  PCRYPT_DEFAULT_CONTEXT_MULTI_OID_PARA = ^CRYPT_DEFAULT_CONTEXT_MULTI_OID_PARA;

  //+-------------------------------------------------------------------------
  //  Uninstall a default context previously installed by
  //  CryptInstallDefaultContext.
  //
  //  For a default context installed with CRYPT_DEFAULT_CONTEXT_PROCESS_FLAG
  //  set, if any other threads are currently using this context,
  //  this function will block until they finish.
  //--------------------------------------------------------------------------
function CryptUninstallDefaultContext(
  hDefaultContext: HCRYPTDEFAULTCONTEXT;
  dwFlags: DWORD;
  pvReserved: pointer
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Export the public key info associated with the provider's corresponding
//  private key.
//
//  Calls CryptExportPublicKeyInfo with pszPublicKeyObjId = szOID_RSA_RSA,
//  dwFlags = 0 and pvAuxInfo = NULL.
//--------------------------------------------------------------------------
function CryptExportPublicKeyInfo(
  hCryptProv: HCRYPTPROV;
  dwKeySpec: DWORD;
  dwCertEncodingType: DWORD;
  pInfo: PCERT_PUBLIC_KEY_INFO;
  var pcbInfo: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Export the public key info associated with the provider's corresponding
//  private key.
//
//  Uses the dwCertEncodingType and pszPublicKeyObjId to call the
//  installable CRYPT_OID_EXPORT_PUBLIC_KEY_INFO_FUNC. The called function
//  has the same signature as CryptExportPublicKeyInfoEx.
//
//  If unable to find an installable OID function for the pszPublicKeyObjId,
//  attempts to export as a RSA Public Key (szOID_RSA_RSA).
//
//  The dwFlags and pvAuxInfo aren't used for szOID_RSA_RSA.
//--------------------------------------------------------------------------
const
  CRYPT_OID_EXPORT_PUBLIC_KEY_INFO_FUNC = 'CryptDllExportPublicKeyInfoEx';

function CryptExportPublicKeyInfoEx(
  hCryptProv: HCRYPTPROV;
  dwKeySpec: DWORD;
  dwCertEncodingType: DWORD;
  pszPublicKeyObjId: LPSTR;
  dwFlags: DWORD;
  pvAuxInfo: pointer;
  pInfo: PCERT_PUBLIC_KEY_INFO;
  var pcbInfo: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Convert and import the public key info into the provider and return a
//  handle to the public key.
//
//  Calls CryptImportPublicKeyInfoEx with aiKeyAlg = 0, dwFlags = 0 and
//  pvAuxInfo = NULL.
//--------------------------------------------------------------------------
function CryptImportPublicKeyInfo(
  hCryptProv: HCRYPTPROV;
  dwCertEncodingType: DWORD;
  pInfo: PCERT_PUBLIC_KEY_INFO;
  var phKey: HCRYPTKEY
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Convert and import the public key info into the provider and return a
//  handle to the public key.
//
//  Uses the dwCertEncodingType and pInfo->Algorithm.pszObjId to call the
//  installable CRYPT_OID_IMPORT_PUBLIC_KEY_INFO_FUNC. The called function
//  has the same signature as CryptImportPublicKeyInfoEx.
//
//  If unable to find an installable OID function for the pszObjId,
//  attempts to import as a RSA Public Key (szOID_RSA_RSA).
//
//  For szOID_RSA_RSA: aiKeyAlg may be set to CALG_RSA_SIGN or CALG_RSA_KEYX.
//  Defaults to CALG_RSA_KEYX. The dwFlags and pvAuxInfo aren't used.
//--------------------------------------------------------------------------
const
  CRYPT_OID_IMPORT_PUBLIC_KEY_INFO_FUNC = 'CryptDllImportPublicKeyInfoEx';

function CryptImportPublicKeyInfoEx(
  hCryptProv: HCRYPTPROV;
  dwCertEncodingType: DWORD;
  pInfo: PCERT_PUBLIC_KEY_INFO;
  aiKeyAlg: ALG_ID;
  dwFlags: DWORD;
  pvAuxInfo: pointer;
  var phKey: HCRYPTKEY
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Acquire a HCRYPTPROV handle and dwKeySpec for the specified certificate
//  context. Uses the certificate's CERT_KEY_PROV_INFO_PROP_ID property.
//  The returned HCRYPTPROV handle may optionally be cached using the
//  certificate's CERT_KEY_CONTEXT_PROP_ID property.
//
//  If CRYPT_ACQUIRE_CACHE_FLAG is set, then, if an already acquired and
//  cached HCRYPTPROV exists for the certificate, its returned. Otherwise,
//  a HCRYPTPROV is acquired and then cached via the certificate's
//  CERT_KEY_CONTEXT_PROP_ID.
//
//  The CRYPT_ACQUIRE_USE_PROV_INFO_FLAG can be set to use the dwFlags field of
//  the certificate's CERT_KEY_PROV_INFO_PROP_ID property's CRYPT_KEY_PROV_INFO
//  data structure to determine if the returned HCRYPTPROV should be cached.
//  HCRYPTPROV caching is enabled if the CERT_SET_KEY_CONTEXT_PROP_ID flag was
//  set.
//
//  If CRYPT_ACQUIRE_COMPARE_KEY_FLAG is set, then,
//  the public key in the certificate is compared with the public
//  key returned by the cryptographic provider. If the keys don't match, the
//  acquire fails and LastError is set to NTE_BAD_PUBLIC_KEY. Note, if
//  a cached HCRYPTPROV is returned, the comparison isn't done. We assume the
//  comparison was done on the initial acquire.
//
//  *pfCallerFreeProv is returned set to FALSE for:
//    - Acquire or public key comparison fails.
//    - CRYPT_ACQUIRE_CACHE_FLAG is set.
//    - CRYPT_ACQUIRE_USE_PROV_INFO_FLAG is set AND
//      CERT_SET_KEY_CONTEXT_PROP_ID flag is set in the dwFlags field of the
//      certificate's CERT_KEY_PROV_INFO_PROP_ID property's
//      CRYPT_KEY_PROV_INFO data structure.
//  When *pfCallerFreeProv is FALSE, the caller must not release. The
//  returned HCRYPTPROV will be released on the last free of the certificate
//  context.
//
//  Otherwise, *pfCallerFreeProv is TRUE and the returned HCRYPTPROV must
//  be released by the caller by calling CryptReleaseContext.
//--------------------------------------------------------------------------
function CryptAcquireCertificatePrivateKey(
  pCert: PCCERT_CONTEXT;
  dwFlags: DWORD;
  pvReserved: pointer;
  var phCryptProv: HCRYPTPROV;
  var pdwKeySpec: DWORD;
  var pfCallerFreeProv: BOOL
  ): BOOL; stdcall;

const
  CRYPT_ACQUIRE_CACHE_FLAG         = $00000001;
  CRYPT_ACQUIRE_USE_PROV_INFO_FLAG = $00000002;
  CRYPT_ACQUIRE_COMPARE_KEY_FLAG   = $00000004;

  CRYPT_ACQUIRE_SILENT_FLAG        = $00000040;

  //+-------------------------------------------------------------------------
  //  Enumerates the cryptographic providers and their containers to find the
  //  private key corresponding to the certificate's public key. For a match,
  //  the certificate's CERT_KEY_PROV_INFO_PROP_ID property is updated.
  //
  //  If the CERT_KEY_PROV_INFO_PROP_ID is already set, then, its checked to
  //  see if it matches the provider's public key. For a match, the above
  //  enumeration is skipped.
  //
  //  By default both the user and machine key containers are searched.
  //  The CRYPT_FIND_USER_KEYSET_FLAG or CRYPT_FIND_MACHINE_KEYSET_FLAG
  //  can be set in dwFlags to restrict the search to either of the containers.
  //
  //  If a container isn't found, returns FALSE with LastError set to
  //  NTE_NO_KEY.
  //--------------------------------------------------------------------------
function CryptFindCertificateKeyProvInfo(
  pCert: PCCERT_CONTEXT;
  dwFlags: DWORD;
  pvReserved: pointer
  ): BOOL; stdcall;

const
  CRYPT_FIND_USER_KEYSET_FLAG    = $00000001;
  CRYPT_FIND_MACHINE_KEYSET_FLAG = $00000002;
  CRYPT_FIND_SILENT_KEYSET_FLAG  = $00000040;

  //+-------------------------------------------------------------------------
  //  This is the prototype for the installable function which is called to
  //  actually import a key into a CSP.  an installable of this type is called
  //  from CryptImportPKCS8.  the algorithm OID of the private key is used
  //  to look up the proper installable function to call.
  //
  //  hCryptProv - the provider to import the key to
  //  pPrivateKeyInfo - describes the key to be imported
  //  dwFlags - The available flags are:
  //              CRYPT_EXPORTABLE
  //              this flag is used when importing private keys, for a full
  //              explanation please see the documentation for CryptImportKey.
  //  pvAuxInfo - reserved for future, must be NULL
  //--------------------------------------------------------------------------
type
  PFN_IMPORT_PRIV_KEY_FUNC = function(
    hCryptProv: HCRYPTPROV; // in
    pPrivateKeyInfo: PCRYPT_PRIVATE_KEY_INFO; // in
    dwFlags: DWORD; // in, optional
    pvAuxInfo: pointer // in, optional
    ): BOOL; stdcall;

const
  CRYPT_OID_IMPORT_PRIVATE_KEY_INFO_FUNC = 'CryptDllImportPrivateKeyInfoEx';

  //+-------------------------------------------------------------------------
  // Convert (from PKCS8 format) and import the private key into a provider
  // and return a handle to the provider as well as the KeySpec used to import to.
  //
  // This function will call the PRESOLVE_HCRYPTPROV_FUNC in the
  // privateKeyAndParams to obtain a handle of provider to import the key to.
  // if the PRESOLVE_HCRYPTPROV_FUNC is NULL then the default provider will be used.
  //
  // privateKeyAndParams - private key blob and corresponding parameters
  // dwFlags - The available flags are:
  //              CRYPT_EXPORTABLE
  //              this flag is used when importing private keys, for a full
  //              explanation please see the documentation for CryptImportKey.
  // phCryptProv - filled in with the handle of the provider the key was
  //               imported to, the caller is responsible for freeing it
  // pvAuxInfo - This parameter is reserved for future use and should be set
  //             to NULL in the interim.
  //--------------------------------------------------------------------------
function CryptImportPKCS8(
  sImportParams: CRYPT_PKCS8_IMPORT_PARAMS; // in
  dwFlags: DWORD; // in, optional
  var phCryptProv: HCRYPTPROV; // out, optional
  pvAuxInfo: pointer // in, optional
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
// this is the prototype for installable functions for exporting the private key
//--------------------------------------------------------------------------
type
  PFN_EXPORT_PRIV_KEY_FUNC = function(
    hCryptProv: HCRYPTPROV; // in
    dwKeySpec: DWORD; // in
    pszPrivateKeyObjId: LPSTR; // in
    dwFlags: DWORD; // in
    pvAuxInfo: pointer; // in
    var pPrivateKeyInfo: CRYPT_PRIVATE_KEY_INFO; // out
    var pcbPrivateKeyBlob: DWORD // in, out
    ): BOOL; stdcall;

const
  CRYPT_OID_EXPORT_PRIVATE_KEY_INFO_FUNC = 'CryptDllExportPrivateKeyInfoEx';

  CRYPT_DELETE_KEYSET = $0001;
  //+-------------------------------------------------------------------------
  //  CryptExportPKCS8 -- superseded by CryptExportPKCS8Ex
  //
  //  Export the private key in PKCS8 format
  //--------------------------------------------------------------------------
function CryptExportPKCS8(
  hCryptProv: HCRYPTPROV; // in
  dwKeySpec: DWORD; // in
  pszPrivateKeyObjId: LPSTR; // in
  dwFlags: DWORD; // in
  pvAuxInfo: pointer; // in
  pbPrivateKeyBlob: PBYTE; // out
  var pcbPrivateKeyBlob: DWORD // in, out
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
// CryptExportPKCS8Ex
//
//  Export the private key in PKCS8 format
//
//
//  Uses the pszPrivateKeyObjId to call the
//  installable CRYPT_OID_EXPORT_PRIVATE_KEY_INFO_FUNC. The called function
//  has the signature defined by PFN_EXPORT_PRIV_KEY_FUNC.
//
//  If unable to find an installable OID function for the pszPrivateKeyObjId,
//  attempts to export as a RSA Private Key (szOID_RSA_RSA).
//
// psExportParams - specifies information about the key to export
// dwFlags - The flag values. None currently supported
// pvAuxInfo - This parameter is reserved for future use and should be set to
//			   NULL in the interim.
// pbPrivateKeyBlob - A pointer to the private key blob.  It will be encoded
//					  as a PKCS8 PrivateKeyInfo.
// pcbPrivateKeyBlob - A pointer to a DWORD that contains the size, in bytes,
//					   of the private key blob being exported.
//+-------------------------------------------------------------------------
function CryptExportPKCS8Ex(
  psExportParams: PCRYPT_PKCS8_EXPORT_PARAMS; // in
  dwFlags: DWORD; // in
  pvAuxInfo: pointer; // in
  pbPrivateKeyBlob: PBYTE; // out
  var pcbPrivateKeyBlob: DWORD // in, out
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Compute the hash of the encoded public key info.
//
//  The public key info is encoded and then hashed.
//--------------------------------------------------------------------------
function CryptHashPublicKeyInfo(
  hCryptProv: HCRYPTPROV;
  Algid: ALG_ID;
  dwFlags: DWORD;
  dwCertEncodingType: DWORD;
  pInfo: PCERT_PUBLIC_KEY_INFO;
  pbComputedHash: PBYTE;
  var pcbComputedHash: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Convert a Name Value to a null terminated char string
//
//  Returns the number of characters converted including the terminating null
//  character. If psz is NULL or csz is 0, returns the required size of the
//  destination string (including the terminating null char).
//
//  If psz != NULL && csz != 0, returned psz is always NULL terminated.
//
//  Note: csz includes the NULL char.
//--------------------------------------------------------------------------
function CertRDNValueToStrA(
  dwValueType: DWORD;
  pValue: PCERT_RDN_VALUE_BLOB;
  psz: LPSTR;
  csz: DWORD
  ): DWORD; stdcall;
//+-------------------------------------------------------------------------
//  Convert a Name Value to a null terminated char string
//
//  Returns the number of characters converted including the terminating null
//  character. If psz is NULL or csz is 0, returns the required size of the
//  destination string (including the terminating null char).
//
//  If psz != NULL && csz != 0, returned psz is always NULL terminated.
//
//  Note: csz includes the NULL char.
//--------------------------------------------------------------------------
function CertRDNValueToStrW(
  dwValueType: DWORD;
  pValue: PCERT_RDN_VALUE_BLOB;
  psz: LPWSTR;
  csz: DWORD
  ): DWORD; stdcall;
{$IFDEF UNICODE}
function CertRDNValueToStr(
  dwValueType: DWORD;
  pValue: PCERT_RDN_VALUE_BLOB;
  psz: LPWSTR;
  csz: DWORD
  ): DWORD; stdcall;
{$ELSE}
function CertRDNValueToStr(
  dwValueType: DWORD;
  pValue: PCERT_RDN_VALUE_BLOB;
  psz: LPSTR;
  csz: DWORD
  ): DWORD; stdcall;
{$ENDIF} // !UNICODE

//+-------------------------------------------------------------------------
//  Convert the certificate name blob to a null terminated char string.
//
//  Follows the string representation of distinguished names specified in
//  RFC 1779. (Note, added double quoting "" for embedded quotes, quote
//  empty strings and don't quote strings containing consecutive spaces).
//  RDN values of type CERT_RDN_ENCODED_BLOB or CERT_RDN_OCTET_STRING are
//  formatted in hexadecimal (e.g. #0A56CF).
//
//  The name string is formatted according to the dwStrType:
//    CERT_SIMPLE_NAME_STR
//      The object identifiers are discarded. CERT_RDN entries are separated
//      by ", ". Multiple attributes per CERT_RDN are separated by " + ".
//      For example:
//          Microsoft, Joe Cool + Programmer
//    CERT_OID_NAME_STR
//      The object identifiers are included with a "=" separator from their
//      attribute value. CERT_RDN entries are separated by ", ".
//      Multiple attributes per CERT_RDN are separated by " + ". For example:
//          2.5.4.11=Microsoft, 2.5.4.3=Joe Cool + 2.5.4.12=Programmer
//    CERT_X500_NAME_STR
//      The object identifiers are converted to their X500 key name. Otherwise,
//      same as CERT_OID_NAME_STR. If the object identifier doesn't have
//      a corresponding X500 key name, then, the object identifier is used with
//      a "OID." prefix. For example:
//          OU=Microsoft, CN=Joe Cool + T=Programmer, OID.1.2.3.4.5.6=Unknown
//
//  We quote the RDN value if it contains leading or trailing whitespace
//  or one of the following characters: ",", "+", "=", """, "\n",  "<", ">",
//  "#" or ";". The quoting character is ". If the the RDN Value contains
//  a " it is double quoted (""). For example:
//      OU="  Microsoft", CN="Joe ""Cool""" + T="Programmer, Manager"
//
//  CERT_NAME_STR_SEMICOLON_FLAG can be or'ed into dwStrType to replace
//  the ", " separator with a "; " separator.
//
//  CERT_NAME_STR_CRLF_FLAG can be or'ed into dwStrType to replace
//  the ", " separator with a "\r\n" separator.
//
//  CERT_NAME_STR_NO_PLUS_FLAG can be or'ed into dwStrType to replace the
//  " + " separator with a single space, " ".
//
//  CERT_NAME_STR_NO_QUOTING_FLAG can be or'ed into dwStrType to inhibit
//  the above quoting.
//
//  CERT_NAME_STR_REVERSE_FLAG can be or'ed into dwStrType to reverse the
//  order of the RDNs before converting to the string.
//
//  By default, CERT_RDN_T61_STRING encoded values are initially decoded
//  as UTF8. If the UTF8 decoding fails, then, decoded as 8 bit characters.
//  CERT_NAME_STR_DISABLE_IE4_UTF8_FLAG can be or'ed into dwStrType to
//  skip the initial attempt to decode as UTF8.
//
//  Returns the number of characters converted including the terminating null
//  character. If psz is NULL or csz is 0, returns the required size of the
//  destination string (including the terminating null char).
//
//  If psz != NULL && csz != 0, returned psz is always NULL terminated.
//
//  Note: csz includes the NULL char.
//--------------------------------------------------------------------------

//+-------------------------------------------------------------------------
//--------------------------------------------------------------------------
function CertNameToStrA(
  dwCertEncodingType: DWORD;
  var pName: CERT_NAME_BLOB;
  dwStrType: DWORD;
  psz: LPSTR;
  csz: DWORD
  ): DWORD; stdcall;
//+-------------------------------------------------------------------------
//--------------------------------------------------------------------------
function CertNameToStrW(
  dwCertEncodingType: DWORD;
  var pName: CERT_NAME_BLOB;
  dwStrType: DWORD;
  psz: LPWSTR;
  csz: DWORD
  ): DWORD; stdcall;
{$IFDEF UNICODE}
function CertNameToStr(
  dwCertEncodingType: DWORD;
  var pName: CERT_NAME_BLOB;
  dwStrType: DWORD;
  psz: LPWSTR;
  csz: DWORD
  ): DWORD; stdcall;
{$ELSE}
function CertNameToStr(
  dwCertEncodingType: DWORD;
  var pName: CERT_NAME_BLOB;
  dwStrType: DWORD;
  psz: LPSTR;
  csz: DWORD
  ): DWORD; stdcall;
{$ENDIF} // !UNICODE

//+-------------------------------------------------------------------------
//  Certificate name string types
//--------------------------------------------------------------------------
const
  CERT_SIMPLE_NAME_STR = 1;
  CERT_OID_NAME_STR    = 2;
  CERT_X500_NAME_STR   = 3;

  //+-------------------------------------------------------------------------
  //  Certificate name string type flags OR'ed with the above types
  //--------------------------------------------------------------------------
  CERT_NAME_STR_SEMICOLON_FLAG  = $40000000;
  CERT_NAME_STR_NO_PLUS_FLAG    = $20000000;
  CERT_NAME_STR_NO_QUOTING_FLAG = $10000000;
  CERT_NAME_STR_CRLF_FLAG       = $08000000;
  CERT_NAME_STR_COMMA_FLAG      = $04000000;
  CERT_NAME_STR_REVERSE_FLAG    = $02000000;

  CERT_NAME_STR_DISABLE_IE4_UTF8_FLAG    = $00010000;
  CERT_NAME_STR_ENABLE_T61_UNICODE_FLAG  = $00020000;
  CERT_NAME_STR_ENABLE_UTF8_UNICODE_FLAG = $00040000;

  //+-------------------------------------------------------------------------
  //  Convert the null terminated X500 string to an encoded certificate name.
  //
  //  The input string is expected to be formatted the same as the output
  //  from the above CertNameToStr API.
  //
  //  The CERT_SIMPLE_NAME_STR type isn't supported. Otherwise, when dwStrType
  //  is set to 0, CERT_OID_NAME_STR or CERT_X500_NAME_STR, allow either a
  //  case insensitive X500 key (CN=), case insensitive "OID." prefixed
  //  object identifier (OID.1.2.3.4.5.6=) or an object identifier (1.2.3.4=).
  //
  //  If no flags are OR'ed into dwStrType, then, allow "," or ";" as RDN
  //  separators and "+" as the multiple RDN value separator. Quoting is
  //  supported. A quote may be included in a quoted value by double quoting,
  //  for example (CN="Joe ""Cool"""). A value starting with a "#" is treated
  //  as ascii hex and converted to a CERT_RDN_OCTET_STRING. Embedded whitespace
  //  is skipped (1.2.3 = # AB CD 01  is the same as 1.2.3=#ABCD01).
  //
  //  Whitespace surrounding the keys, object identifers and values is removed.
  //
  //  CERT_NAME_STR_COMMA_FLAG can be or'ed into dwStrType to only allow the
  //  "," as the RDN separator.
  //
  //  CERT_NAME_STR_SEMICOLON_FLAG can be or'ed into dwStrType to only allow the
  //  ";" as the RDN separator.
  //
  //  CERT_NAME_STR_CRLF_FLAG can be or'ed into dwStrType to only allow
  //  "\r" or "\n" as the RDN separator.
  //
  //  CERT_NAME_STR_NO_PLUS_FLAG can be or'ed into dwStrType to ignore "+"
  //  as a separator and not allow multiple values per RDN.
  //
  //  CERT_NAME_STR_NO_QUOTING_FLAG can be or'ed into dwStrType to inhibit
  //  quoting.
  //
  //  CERT_NAME_STR_REVERSE_FLAG can be or'ed into dwStrType to reverse the
  //  order of the RDNs after converting from the string and before encoding.
  //
  //  CERT_NAME_STR_ENABLE_T61_UNICODE_FLAG can be or'ed into dwStrType to
  //  to select the CERT_RDN_T61_STRING encoded value type instead of
  //  CERT_RDN_UNICODE_STRING if all the UNICODE characters are <= 0xFF.
  //
  //  CERT_NAME_STR_ENABLE_UTF8_UNICODE_FLAG can be or'ed into dwStrType to
  //  to select the CERT_RDN_UTF8_STRING encoded value type instead of
  //  CERT_RDN_UNICODE_STRING.
  //
  //  Support the following X500 Keys:
  //
  //  Key         Object Identifier               RDN Value Type(s)
  //  ---         -----------------               -----------------
  //  CN          szOID_COMMON_NAME               Printable, Unicode
  //  L           szOID_LOCALITY_NAME             Printable, Unicode
  //  O           szOID_ORGANIZATION_NAME         Printable, Unicode
  //  OU          szOID_ORGANIZATIONAL_UNIT_NAME  Printable, Unicode
  //  E           szOID_RSA_emailAddr             Only IA5
  //  Email       szOID_RSA_emailAddr             Only IA5
  //  C           szOID_COUNTRY_NAME              Only Printable
  //  S           szOID_STATE_OR_PROVINCE_NAME    Printable, Unicode
  //  ST          szOID_STATE_OR_PROVINCE_NAME    Printable, Unicode
  //  STREET      szOID_STREET_ADDRESS            Printable, Unicode
  //  T           szOID_TITLE                     Printable, Unicode
  //  Title       szOID_TITLE                     Printable, Unicode
  //  G           szOID_GIVEN_NAME                Printable, Unicode
  //  GivenName   szOID_GIVEN_NAME                Printable, Unicode
  //  I           szOID_INITIALS                  Printable, Unicode
  //  Initials    szOID_INITIALS                  Printable, Unicode
  //  SN          szOID_SUR_NAME                  Printable, Unicode
  //  DC          szOID_DOMAIN_COMPONENT          IA5, UTF8
  //
  //  Note, T61 is selected instead of Unicode if
  //  CERT_NAME_STR_ENABLE_T61_UNICODE_FLAG is set and all the unicode
  //  characters are <= 0xFF.
  //
  //  Note, UTF8 is selected instead of Unicode if
  //  CERT_NAME_STR_ENABLE_UTF8_UNICODE_FLAG is set.
  //
  //  Returns TRUE if successfully parsed the input string and encoded
  //  the name.
  //
  //  If the input string is detected to be invalid, *ppszError is updated
  //  to point to the beginning of the invalid character sequence. Otherwise,
  //  *ppszError is set to NULL. *ppszError is updated with a non-NULL pointer
  //  for the following errors:
  //      CRYPT_E_INVALID_X500_STRING
  //      CRYPT_E_INVALID_NUMERIC_STRING
  //      CRYPT_E_INVALID_PRINTABLE_STRING
  //      CRYPT_E_INVALID_IA5_STRING
  //
  //  ppszError can be set to NULL if not interested in getting a pointer
  //  to the invalid character sequence.
  //--------------------------------------------------------------------------
type
  PLPCSTR = ^LPCSTR;
  PLPCWSTR = ^LPCWSTR;
  //+-------------------------------------------------------------------------
  //--------------------------------------------------------------------------
function CertStrToNameA(
  dwCertEncodingType: DWORD;
  pszX500: LPCSTR;
  dwStrType: DWORD;
  pvReserved: pointer;
  pbEncoded: PBYTE;
  var pcbEncoded: DWORD;
  ppszError: PLPCSTR
  ): BOOL; stdcall;
//+-------------------------------------------------------------------------
//--------------------------------------------------------------------------
function CertStrToNameW(
  dwCertEncodingType: DWORD;
  pszX500: LPCWSTR;
  dwStrType: DWORD;
  pvReserved: pointer;
  pbEncoded: PBYTE;
  var pcbEncoded: DWORD;
  ppszError: PLPCWSTR
  ): BOOL; stdcall;
{$IFDEF UNICODE}
function CertStrToName(
  dwCertEncodingType: DWORD;
  pszX500: LPCWSTR;
  dwStrType: DWORD;
  pvReserved: pointer;
  pbEncoded: PBYTE;
  var pcbEncoded: DWORD;
  ppszError: PLPCWSTR
  ): BOOL; stdcall;
{$ELSE}
function CertStrToName(
  dwCertEncodingType: DWORD;
  pszX500: LPCSTR;
  dwStrType: DWORD;
  pvReserved: pointer;
  pbEncoded: PBYTE;
  var pcbEncoded: DWORD;
  ppszError: PLPCSTR
  ): BOOL; stdcall;
{$ENDIF} // !UNICODE

//+-------------------------------------------------------------------------
//  Get the subject or issuer name from the certificate and
//  according to the specified format type, convert to a null terminated
//  character string.
//
//  CERT_NAME_ISSUER_FLAG can be set to get the issuer's name. Otherwise,
//  gets the subject's name.
//
//  By default, CERT_RDN_T61_STRING encoded values are initially decoded
//  as UTF8. If the UTF8 decoding fails, then, decoded as 8 bit characters.
//  CERT_NAME_DISABLE_IE4_UTF8_FLAG can be set in dwFlags to
//  skip the initial attempt to decode as UTF8.
//
//  The name string is formatted according to the dwType:
//    CERT_NAME_EMAIL_TYPE
//      If the certificate has a Subject Alternative Name extension (for
//      issuer, Issuer Alternative Name), searches for first rfc822Name choice.
//      If the rfc822Name choice isn't found in the extension, searches the
//      Subject Name field for the Email OID, "1.2.840.113549.1.9.1".
//      If the rfc822Name or Email OID is found, returns the string. Otherwise,
//      returns an empty string (returned character count is 1).
//    CERT_NAME_RDN_TYPE
//      Converts the Subject Name blob by calling CertNameToStr. pvTypePara
//      points to a DWORD containing the dwStrType passed to CertNameToStr.
//      If the Subject Name field is empty and the certificate has a
//      Subject Alternative Name extension, searches for and converts
//      the first directoryName choice.
//    CERT_NAME_ATTR_TYPE
//      pvTypePara points to the Object Identifier specifying the name attribute
//      to be returned. For example, to get the CN,
//      pvTypePara = szOID_COMMON_NAME ("2.5.4.3"). Searches, the Subject Name
//      field for the attribute.
//      If the Subject Name field is empty and the certificate has a
//      Subject Alternative Name extension, checks for
//      the first directoryName choice and searches it.
//
//      Note, searches the RDNs in reverse order.
//
//    CERT_NAME_SIMPLE_DISPLAY_TYPE
//      Iterates through the following list of name attributes and searches
//      the Subject Name and then the Subject Alternative Name extension
//      for the first occurrence of:
//          szOID_COMMON_NAME ("2.5.4.3")
//          szOID_ORGANIZATIONAL_UNIT_NAME ("2.5.4.11")
//          szOID_ORGANIZATION_NAME ("2.5.4.10")
//          szOID_RSA_emailAddr ("1.2.840.113549.1.9.1")
//
//      If none of the above attributes is found, then, searches the
//      Subject Alternative Name extension for a rfc822Name choice.
//
//      If still no match, then, returns the first attribute.
//
//      Note, like CERT_NAME_ATTR_TYPE, searches the RDNs in reverse order.
//
//    CERT_NAME_FRIENDLY_DISPLAY_TYPE
//      First checks if the certificate has a CERT_FRIENDLY_NAME_PROP_ID
//      property. If it does, then, this property is returned. Otherwise,
//      returns the above CERT_NAME_SIMPLE_DISPLAY_TYPE.
//
//  Returns the number of characters converted including the terminating null
//  character. If pwszNameString is NULL or cchNameString is 0, returns the
//  required size of the destination string (including the terminating null
//  char). If the specified name type isn't found. returns an empty string
//  with a returned character count of 1.
//
//  If pwszNameString != NULL && cwszNameString != 0, returned pwszNameString
//  is always NULL terminated.
//
//  Note: cchNameString includes the NULL char.
//--------------------------------------------------------------------------

//+-------------------------------------------------------------------------
//--------------------------------------------------------------------------
function CertGetNameStringA(
  pCertContext: PCCERT_CONTEXT;
  dwType: DWORD;
  dwFlags: DWORD;
  pvTypePara: pointer;
  pszNameString: LPSTR;
  cchNameString: DWORD
  ): DWORD; stdcall;
//+-------------------------------------------------------------------------
//--------------------------------------------------------------------------
function CertGetNameStringW(
  pCertContext: PCCERT_CONTEXT;
  dwType: DWORD;
  dwFlags: DWORD;
  pvTypePara: pointer;
  pszNameString: LPWSTR;
  cchNameString: DWORD
  ): DWORD; stdcall;
{$IFDEF UNICODE}
function CertGetNameString(
  pCertContext: PCCERT_CONTEXT;
  dwType: DWORD;
  dwFlags: DWORD;
  pvTypePara: pointer;
  pszNameString: LPWSTR;
  cchNameString: DWORD
  ): DWORD; stdcall;
{$ELSE}
function CertGetNameString(
  pCertContext: PCCERT_CONTEXT;
  dwType: DWORD;
  dwFlags: DWORD;
  pvTypePara: pointer;
  pszNameString: LPSTR;
  cchNameString: DWORD
  ): DWORD; stdcall;
{$ENDIF} // !UNICODE

//+-------------------------------------------------------------------------
//  Certificate name types
//--------------------------------------------------------------------------
const
  CERT_NAME_EMAIL_TYPE            = 1;
  CERT_NAME_RDN_TYPE              = 2;
  CERT_NAME_ATTR_TYPE             = 3;
  CERT_NAME_SIMPLE_DISPLAY_TYPE   = 4;
  CERT_NAME_FRIENDLY_DISPLAY_TYPE = 5;
  CERT_NAME_DNS_TYPE              = 6;
  CERT_NAME_URL_TYPE              = 7;
  CERT_NAME_UPN_TYPE              = 8;

  //+-------------------------------------------------------------------------
  //  Certificate name flags
  //--------------------------------------------------------------------------
  CERT_NAME_ISSUER_FLAG           = $1;
  CERT_NAME_DISABLE_IE4_UTF8_FLAG = $00010000;

  //+=========================================================================
  //  Simplified Cryptographic Message Data Structures and APIs
  //==========================================================================

  //+-------------------------------------------------------------------------
  //              Conventions for the *pb and *pcb output parameters:
  //
  //              Upon entry to the function:
  //                  if pcb is OPTIONAL && pcb == NULL, then,
  //                      No output is returned
  //                  else if pb == NULL && pcb != NULL, then,
  //                      Length only determination. No length error is
  //                      returned.
  //                  otherwise where (pb != NULL && pcb != NULL && *pcb != 0)
  //                      Output is returned. If *pcb isn't big enough a
  //                      length error is returned. In all cases *pcb is updated
  //                      with the actual length needed/returned.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  Type definitions of the parameters used for doing the cryptographic
  //  operations.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  Callback to get and verify the signer's certificate.
  //
  //  Passed the CertId of the signer (its Issuer and SerialNumber) and a
  //  handle to its cryptographic signed message's cert store.
  //
  //  For CRYPT_E_NO_SIGNER, called with pSignerId == NULL.
  //
  //  For a valid signer certificate, returns a pointer to a read only
  //  CERT_CONTEXT. The returned CERT_CONTEXT is either obtained from a
  //  cert store or was created via CertCreateCertificateContext. For either case,
  //  its freed via CertFreeCertificateContext.
  //
  //  If a valid certificate isn't found, this callback returns NULL with
  //  LastError set via SetLastError().
  //
  //  The NULL implementation tries to get the Signer certificate from the
  //  message cert store. It doesn't verify the certificate.
  //
  //  Note, if the KEYID choice was selected for a CMS SignerId, then, the
  //  SerialNumber is 0 and the Issuer is encoded containing a single RDN with a
  //  single Attribute whose OID is szOID_KEYID_RDN, value type is
  //  CERT_RDN_OCTET_STRING and value is the KEYID. When the
  //  CertGetSubjectCertificateFromStore and
  //  CertFindCertificateInStore(CERT_FIND_SUBJECT_CERT) APIs see this
  //  special KEYID Issuer and SerialNumber, they do a KEYID match.
  //--------------------------------------------------------------------------
type
  PFN_CRYPT_GET_SIGNER_CERTIFICATE = function(
    pvGetArg: pointer;
    dwCertEncodingType: DWORD;
    pSignerId: PCERT_INFO; // Only the Issuer and SerialNumber
    // fields have been updated
    hMsgCertStore: HCERTSTORE
    ): PCCERT_CONTEXT; stdcall;

  //+-------------------------------------------------------------------------
  //  The CRYPT_SIGN_MESSAGE_PARA are used for signing messages using the
  //  specified signing certificate context.
  //
  //  Either the CERT_KEY_PROV_HANDLE_PROP_ID or CERT_KEY_PROV_INFO_PROP_ID must
  //  be set for each rgpSigningCert[]. Either one specifies the private
  //  signature key to use.
  //
  //  If any certificates and/or CRLs are to be included in the signed message,
  //  then, the MsgCert and MsgCrl parameters need to be updated. If the
  //  rgpSigningCerts are to be included, then, they must also be in the
  //  rgpMsgCert array.
  //
  //  cbSize must be set to the sizeof(CRYPT_SIGN_MESSAGE_PARA) or else
  //  LastError will be updated with E_INVALIDARG.
  //
  //  pvHashAuxInfo currently isn't used and must be set to NULL.
  //
  //  dwFlags normally is set to 0. However, if the encoded output
  //  is to be a CMSG_SIGNED inner content of an outer cryptographic message,
  //  such as a CMSG_ENVELOPED, then, the CRYPT_MESSAGE_BARE_CONTENT_OUT_FLAG
  //  should be set. If not set, then it would be encoded as an inner content
  //  type of CMSG_DATA.
  //
  //  dwInnerContentType is normally set to 0. It needs to be set if the
  //  ToBeSigned input is the encoded output of another cryptographic
  //  message, such as, an CMSG_ENVELOPED. When set, it's one of the cryptographic
  //  message types, for example, CMSG_ENVELOPED.
  //
  //  If the inner content of a nested cryptographic message is data (CMSG_DATA
  //  the default), then, neither dwFlags or dwInnerContentType need to be set.
  //
  //  For CMS messages, CRYPT_MESSAGE_ENCAPSULATED_CONTENT_OUT_FLAG may be
  //  set to encapsulate nonData inner content within an OCTET STRING.
  //
  //  For CMS messages, CRYPT_MESSAGE_KEYID_SIGNER_FLAG may be set to identify
  //  signers by their Key Identifier and not their Issuer and Serial Number.
  //
  //  If HashEncryptionAlgorithm is present and not NULL its used instead of
  //  the SigningCert's PublicKeyInfo.Algorithm.
  //
  //  Note, for RSA, the hash encryption algorithm is normally the same as
  //  the public key algorithm. For DSA, the hash encryption algorithm is
  //  normally a DSS signature algorithm.
  //
  //  pvHashEncryptionAuxInfo currently isn't used and must be set to NULL if
  //  present in the data structure.
  //--------------------------------------------------------------------------
type
  TARR_PCCRL_CONTEXT = ^PCCRL_CONTEXT; {My type. Oleg}
  CRYPT_SIGN_MESSAGE_PARA = record
    cbSize:                  DWORD;
    dwMsgEncodingType:       DWORD;
    pSigningCert:            PCCERT_CONTEXT;
    HashAlgorithm:           CRYPT_ALGORITHM_IDENTIFIER;
    pvHashAuxInfo:           pointer;
    cMsgCert:                DWORD;
    rgpMsgCert:              PPCCERT_CONTEXT;
    cMsgCrl:                 DWORD;
    rgpMsgCrl:               TARR_PCCRL_CONTEXT;
    cAuthAttr:               DWORD;
    rgAuthAttr:              PCRYPT_ATTRIBUTE;
    cUnauthAttr:             DWORD;
    rgUnauthAttr:            PCRYPT_ATTRIBUTE;
    dwFlags:                 DWORD;
    dwInnerContentType:      DWORD;
    HashEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    pvHashEncryptionAuxInfo: pointer;
  end;
  PCRYPT_SIGN_MESSAGE_PARA = ^CRYPT_SIGN_MESSAGE_PARA;

const
  CRYPT_MESSAGE_BARE_CONTENT_OUT_FLAG         = $00000001;

  // When set, nonData type inner content is encapsulated within an
  // OCTET STRING
  CRYPT_MESSAGE_ENCAPSULATED_CONTENT_OUT_FLAG = $00000002;

  // When set, signers are identified by their Key Identifier and not
  // their Issuer and Serial Number.
  CRYPT_MESSAGE_KEYID_SIGNER_FLAG             = $00000004;

  // When set, suppresses any UI by the CSP.
  // See CryptAcquireContext's CRYPT_SILENT flag for more details.
  CRYPT_MESSAGE_SILENT_KEYSET_FLAG            = $00000040;

  //+-------------------------------------------------------------------------
  //  The CRYPT_VERIFY_MESSAGE_PARA are used to verify signed messages.
  //
  //  hCryptProv is used to do hashing and signature verification.
  //
  //  The dwCertEncodingType specifies the encoding type of the certificates
  //  and/or CRLs in the message.
  //
  //  pfnGetSignerCertificate is called to get and verify the message signer's
  //  certificate.
  //
  //  cbSize must be set to the sizeof(CRYPT_VERIFY_MESSAGE_PARA) or else
  //  LastError will be updated with E_INVALIDARG.
  //--------------------------------------------------------------------------
type
  CRYPT_VERIFY_MESSAGE_PARA = record
    cbSize:                   DWORD;
    dwMsgAndCertEncodingType: DWORD;
    hCryptProv:               HCRYPTPROV;
    pfnGetSignerCertificate:  PFN_CRYPT_GET_SIGNER_CERTIFICATE;
    pvGetArg:                 pointer;
  end;
  PCRYPT_VERIFY_MESSAGE_PARA = ^CRYPT_VERIFY_MESSAGE_PARA;

  //+-------------------------------------------------------------------------
  //  The CRYPT_ENCRYPT_MESSAGE_PARA are used for encrypting messages.
  //
  //  hCryptProv is used to do content encryption, recipient key
  //  encryption, and recipient key export. Its private key
  //  isn't used.
  //
  //  Currently, pvEncryptionAuxInfo is only defined for RC2 or RC4 encryption
  //  algorithms. Otherwise, its not used and must be set to NULL.
  //  See CMSG_RC2_AUX_INFO for the RC2 encryption algorithms.
  //  See CMSG_RC4_AUX_INFO for the RC4 encryption algorithms.
  //
  //  To enable SP3 compatible encryption, pvEncryptionAuxInfo should point to
  //  a CMSG_SP3_COMPATIBLE_AUX_INFO data structure.
  //
  //  cbSize must be set to the sizeof(CRYPT_ENCRYPT_MESSAGE_PARA) or else
  //  LastError will be updated with E_INVALIDARG.
  //
  //  dwFlags normally is set to 0. However, if the encoded output
  //  is to be a CMSG_ENVELOPED inner content of an outer cryptographic message,
  //  such as a CMSG_SIGNED, then, the CRYPT_MESSAGE_BARE_CONTENT_OUT_FLAG
  //  should be set. If not set, then it would be encoded as an inner content
  //  type of CMSG_DATA.
  //
  //  dwInnerContentType is normally set to 0. It needs to be set if the
  //  ToBeEncrypted input is the encoded output of another cryptographic
  //  message, such as, an CMSG_SIGNED. When set, it's one of the cryptographic
  //  message types, for example, CMSG_SIGNED.
  //
  //  If the inner content of a nested cryptographic message is data (CMSG_DATA
  //  the default), then, neither dwFlags or dwInnerContentType need to be set.
  //
  //  For CMS messages, CRYPT_MESSAGE_ENCAPSULATED_CONTENT_OUT_FLAG may be
  //  set to encapsulate nonData inner content within an OCTET STRING before
  //  encrypting.
  //
  //  For CMS messages, CRYPT_MESSAGE_KEYID_RECIPIENT_FLAG may be set to identify
  //  recipients by their Key Identifier and not their Issuer and Serial Number.
  //--------------------------------------------------------------------------
type
  CRYPT_ENCRYPT_MESSAGE_PARA = record
    cbSize:                     DWORD;
    dwMsgEncodingType:          DWORD;
    hCryptProv:                 HCRYPTPROV;
    ContentEncryptionAlgorithm: CRYPT_ALGORITHM_IDENTIFIER;
    pvEncryptionAuxInfo:        pointer;
    dwFlags:                    DWORD;
    dwInnerContentType:         DWORD;
  end;
  PCRYPT_ENCRYPT_MESSAGE_PARA = ^CRYPT_ENCRYPT_MESSAGE_PARA;

  // When set, recipients are identified by their Key Identifier and not
  // their Issuer and Serial Number.
const
  CRYPT_MESSAGE_KEYID_RECIPIENT_FLAG = $4;

  //+-------------------------------------------------------------------------
  //  The CRYPT_DECRYPT_MESSAGE_PARA are used for decrypting messages.
  //
  //  The CertContext to use for decrypting a message is obtained from one
  //  of the specified cert stores. An encrypted message can have one or
  //  more recipients. The recipients are identified by their CertId (Issuer
  //  and SerialNumber). The cert stores are searched to find the CertContext
  //  corresponding to the CertId.
  //
  //  For CMS, the recipients may also be identified by their KeyId.
  //  CMS also allows Key Agreement (Diffie Hellman) in addition to
  //  Key Transport (RSA) recipients.
  //
  //  Only CertContexts in the store with either
  //  the CERT_KEY_PROV_HANDLE_PROP_ID or CERT_KEY_PROV_INFO_PROP_ID set
  //  can be used. Either property specifies the private exchange key to use.
  //
  //  cbSize must be set to the sizeof(CRYPT_DECRYPT_MESSAGE_PARA) or else
  //  LastError will be updated with E_INVALIDARG.
  //--------------------------------------------------------------------------
type
  CRYPT_DECRYPT_MESSAGE_PARA = record
    cbSize:                   DWORD;
    dwMsgAndCertEncodingType: DWORD;
    cCertStore:               DWORD;
    rghCertStore:             PHCERTSTORE;
{$IFDEF CRYPT_DECRYPT_MESSAGE_PARA_HAS_EXTRA_FIELDS}
    // The above defined, CRYPT_MESSAGE_SILENT_KEYSET_FLAG, can be set to
    // suppress UI by the CSP.  See CryptAcquireContext's CRYPT_SILENT
    // flag for more details.
    dwFlags:                  DWORD;
{$ENDIF}
  end;
  PCRYPT_DECRYPT_MESSAGE_PARA = ^CRYPT_DECRYPT_MESSAGE_PARA;

  //+-------------------------------------------------------------------------
  //  The CRYPT_HASH_MESSAGE_PARA are used for hashing or unhashing
  //  messages.
  //
  //  hCryptProv is used to compute the hash.
  //
  //  pvHashAuxInfo currently isn't used and must be set to NULL.
  //
  //  cbSize must be set to the sizeof(CRYPT_HASH_MESSAGE_PARA) or else
  //  LastError will be updated with E_INVALIDARG.
  //--------------------------------------------------------------------------
type
  CRYPT_HASH_MESSAGE_PARA = record
    cbSize:            DWORD;
    dwMsgEncodingType: DWORD;
    hCryptProv:        HCRYPTPROV;
    HashAlgorithm:     CRYPT_ALGORITHM_IDENTIFIER;
    pvHashAuxInfo:     pointer;
  end;
  PCRYPT_HASH_MESSAGE_PARA = ^CRYPT_HASH_MESSAGE_PARA;

  //+-------------------------------------------------------------------------
  //  The CRYPT_KEY_SIGN_MESSAGE_PARA are used for signing messages until a
  //  certificate has been created for the signature key.
  //
  //  pvHashAuxInfo currently isn't used and must be set to NULL.
  //
  //  If PubKeyAlgorithm isn't set, defaults to szOID_RSA_RSA.
  //
  //  cbSize must be set to the sizeof(CRYPT_KEY_SIGN_MESSAGE_PARA) or else
  //  LastError will be updated with E_INVALIDARG.
  //--------------------------------------------------------------------------
type
  CRYPT_KEY_SIGN_MESSAGE_PARA = record
    cbSize:                   DWORD;
    dwMsgAndCertEncodingType: DWORD;
    hCryptProv:               HCRYPTPROV;
    dwKeySpec:                DWORD;
    HashAlgorithm:            CRYPT_ALGORITHM_IDENTIFIER;
    pvHashAuxInfo:            pointer;
    PubKeyAlgorithm:          CRYPT_ALGORITHM_IDENTIFIER;
  end;
  PCRYPT_KEY_SIGN_MESSAGE_PARA = ^CRYPT_KEY_SIGN_MESSAGE_PARA;

  //+-------------------------------------------------------------------------
  //  The CRYPT_KEY_VERIFY_MESSAGE_PARA are used to verify signed messages without
  //  a certificate for the signer.
  //
  //  Normally used until a certificate has been created for the key.
  //
  //  hCryptProv is used to do hashing and signature verification.
  //
  //  cbSize must be set to the sizeof(CRYPT_KEY_VERIFY_MESSAGE_PARA) or else
  //  LastError will be updated with E_INVALIDARG.
  //--------------------------------------------------------------------------
type
  CRYPT_KEY_VERIFY_MESSAGE_PARA = record
    cbSize:            DWORD;
    dwMsgEncodingType: DWORD;
    hCryptProv:        HCRYPTPROV;
  end;
  PCRYPT_KEY_VERIFY_MESSAGE_PARA = ^CRYPT_KEY_VERIFY_MESSAGE_PARA;

  //+-------------------------------------------------------------------------
  //  Sign the message.
  //
  //  If fDetachedSignature is TRUE, the "to be signed" content isn't included
  //  in the encoded signed blob.
  //--------------------------------------------------------------------------
function CryptSignMessage(
  pSignPara: PCRYPT_SIGN_MESSAGE_PARA;
  fDetachedSignature: BOOL;
  cToBeSigned: DWORD;
  rgpbToBeSigned: TARR_PBYTE;
  rgcbToBeSigned: TARR_DWORD;
  pbSignedBlob: PBYTE;
  var pcbSignedBlob: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Verify a signed message.
//
//  If pbDecoded == NULL, then, *pcbDecoded is implicitly set to 0 on input.
//  For *pcbDecoded == 0 && ppSignerCert == NULL on input, the signer isn't
//  verified.
//
//  A message might have more than one signer. Set dwSignerIndex to iterate
//  through all the signers. dwSignerIndex == 0 selects the first signer.
//
//  pVerifyPara's pfnGetSignerCertificate is called to get the signer's
//  certificate.
//
//  For a verified signer and message, *ppSignerCert is updated
//  with the CertContext of the signer. It must be freed by calling
//  CertFreeCertificateContext. Otherwise, *ppSignerCert is set to NULL.
//
//  ppSignerCert can be NULL, indicating the caller isn't interested
//  in getting the CertContext of the signer.
//
//  pcbDecoded can be NULL, indicating the caller isn't interested in getting
//  the decoded content. Furthermore, if the message doesn't contain any
//  content or signers, then, pcbDecoded must be set to NULL, to allow the
//  pVerifyPara->pfnGetCertificate to be called. Normally, this would be
//  the case when the signed message contains only certficates and CRLs.
//  If pcbDecoded is NULL and the message doesn't have the indicated signer,
//  pfnGetCertificate is called with pSignerId set to NULL.
//
//  If the message doesn't contain any signers || dwSignerIndex > message's
//  SignerCount, then, an error is returned with LastError set to
//  CRYPT_E_NO_SIGNER. Also, for CRYPT_E_NO_SIGNER, pfnGetSignerCertificate
//  is still called with pSignerId set to NULL.
//
//  Note, an alternative way to get the certificates and CRLs from a
//  signed message is to call CryptGetMessageCertificates.
//--------------------------------------------------------------------------
function CryptVerifyMessageSignature(
  pVerifyPara: PCRYPT_VERIFY_MESSAGE_PARA;
  dwSignerIndex: DWORD;
  pbSignedBlob: PBYTE;
  cbSignedBlob: DWORD;
  pbDecoded: PBYTE;
  var pcbDecoded: DWORD;
  ppSignerCert: PPCCERT_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Returns the count of signers in the signed message. For no signers, returns
//  0. For an error returns -1 with LastError updated accordingly.
//--------------------------------------------------------------------------
function CryptGetMessageSignerCount(
  dwMsgEncodingType: DWORD;
  pbSignedBlob: PBYTE;
  cbSignedBlob: DWORD
  ): longint; stdcall;

//+-------------------------------------------------------------------------
//  Returns the cert store containing the message's certs and CRLs.
//  For an error, returns NULL with LastError updated.
//--------------------------------------------------------------------------
function CryptGetMessageCertificates(
  dwMsgAndCertEncodingType: DWORD;
  hCryptProv: HCRYPTPROV; // passed to CertOpenStore
  dwFlags: DWORD; // passed to CertOpenStore
  pbSignedBlob: PBYTE;
  cbSignedBlob: DWORD
  ): HCERTSTORE; stdcall;

//+-------------------------------------------------------------------------
//  Verify a signed message containing detached signature(s).
//  The "to be signed" content is passed in separately. No
//  decoded output. Otherwise, identical to CryptVerifyMessageSignature.
//--------------------------------------------------------------------------
function CryptVerifyDetachedMessageSignature(
  pVerifyPara: PCRYPT_VERIFY_MESSAGE_PARA;
  dwSignerIndex: DWORD;
  pbDetachedSignBlob: PBYTE;
  cbDetachedSignBlob: DWORD;
  cToBeSigned: DWORD;
  rgpbToBeSigned: TARR_PBYTE;
  rgcbToBeSigned: TARR_DWORD;
  ppSignerCert: PPCCERT_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Encrypts the message for the recipient(s).
//--------------------------------------------------------------------------
type
  TARR_PCCERT_CONTEXT = ^PCCERT_CONTEXT;
function CryptEncryptMessage(
  pEncryptPara: PCRYPT_ENCRYPT_MESSAGE_PARA;
  cRecipientCert: DWORD;
  rgpRecipientCert: TARR_PCCERT_CONTEXT;
  pbToBeEncrypted: PBYTE;
  cbToBeEncrypted: DWORD;
  pbEncryptedBlob: PBYTE;
  var pcbEncryptedBlob: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Decrypts the message.
//
//  If pbDecrypted == NULL, then, *pcbDecrypted is implicitly set to 0 on input.
//  For *pcbDecrypted == 0 && ppXchgCert == NULL on input, the message isn't
//  decrypted.
//
//  For a successfully decrypted message, *ppXchgCert is updated
//  with the CertContext used to decrypt. It must be freed by calling
//  CertStoreFreeCert. Otherwise, *ppXchgCert is set to NULL.
//
//  ppXchgCert can be NULL, indicating the caller isn't interested
//  in getting the CertContext used to decrypt.
//--------------------------------------------------------------------------
function CryptDecryptMessage(
  pDecryptPara: PCRYPT_DECRYPT_MESSAGE_PARA;
  pbEncryptedBlob: PBYTE;
  cbEncryptedBlob: DWORD;
  pbDecrypted: PBYTE;
  var pcbDecrypted: DWORD;
  ppXchgCert: PPCCERT_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Sign the message and encrypt for the recipient(s). Does a CryptSignMessage
//  followed with a CryptEncryptMessage.
//
//  Note: this isn't the CMSG_SIGNED_AND_ENVELOPED. Its a CMSG_SIGNED
//  inside of an CMSG_ENVELOPED.
//--------------------------------------------------------------------------
function CryptSignAndEncryptMessage(
  pSignPara: PCRYPT_SIGN_MESSAGE_PARA;
  pEncryptPara: PCRYPT_ENCRYPT_MESSAGE_PARA;
  cRecipientCert: DWORD;
  rgpRecipientCert: TARR_PCCERT_CONTEXT;
  pbToBeSignedAndEncrypted: PBYTE;
  cbToBeSignedAndEncrypted: DWORD;
  pbSignedAndEncryptedBlob: PBYTE;
  var pcbSignedAndEncryptedBlob: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Decrypts the message and verifies the signer. Does a CryptDecryptMessage
//  followed with a CryptVerifyMessageSignature.
//
//  If pbDecrypted == NULL, then, *pcbDecrypted is implicitly set to 0 on input.
//  For *pcbDecrypted == 0 && ppSignerCert == NULL on input, the signer isn't
//  verified.
//
//  A message might have more than one signer. Set dwSignerIndex to iterate
//  through all the signers. dwSignerIndex == 0 selects the first signer.
//
//  The pVerifyPara's VerifySignerPolicy is called to verify the signer's
//  certificate.
//
//  For a successfully decrypted and verified message, *ppXchgCert and
//  *ppSignerCert are updated. They must be freed by calling
//  CertStoreFreeCert. Otherwise, they are set to NULL.
//
//  ppXchgCert and/or ppSignerCert can be NULL, indicating the
//  caller isn't interested in getting the CertContext.
//
//  Note: this isn't the CMSG_SIGNED_AND_ENVELOPED. Its a CMSG_SIGNED
//  inside of an CMSG_ENVELOPED.
//
//  The message always needs to be decrypted to allow access to the
//  signed message. Therefore, if ppXchgCert != NULL, its always updated.
//--------------------------------------------------------------------------
function CryptDecryptAndVerifyMessageSignature(
  pDecryptPara: PCRYPT_DECRYPT_MESSAGE_PARA;
  pVerifyPara: PCRYPT_VERIFY_MESSAGE_PARA;
  dwSignerIndex: DWORD;
  pbEncryptedBlob: PBYTE;
  cbEncryptedBlob: DWORD;
  pbDecrypted: PBYTE;
  var pcbDecrypted: DWORD;
  ppXchgCert: PPCCERT_CONTEXT;
  ppSignerCert: PPCCERT_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Decodes a cryptographic message which may be one of the following types:
//    CMSG_DATA
//    CMSG_SIGNED
//    CMSG_ENVELOPED
//    CMSG_SIGNED_AND_ENVELOPED
//    CMSG_HASHED
//
//  dwMsgTypeFlags specifies the set of allowable messages. For example, to
//  decode either SIGNED or ENVELOPED messages, set dwMsgTypeFlags to:
//      CMSG_SIGNED_FLAG | CMSG_ENVELOPED_FLAG.
//
//  dwProvInnerContentType is only applicable when processing nested
//  crytographic messages. When processing an outer crytographic message
//  it must be set to 0. When decoding a nested cryptographic message
//  its the dwInnerContentType returned by a previous CryptDecodeMessage
//  of the outer message. The InnerContentType can be any of the CMSG types,
//  for example, CMSG_DATA, CMSG_SIGNED, ...
//
//  The optional *pdwMsgType is updated with the type of message.
//
//  The optional *pdwInnerContentType is updated with the type of the inner
//  message. Unless there is cryptographic message nesting, CMSG_DATA
//  is returned.
//
//  For CMSG_DATA: returns decoded content.
//  For CMSG_SIGNED: same as CryptVerifyMessageSignature.
//  For CMSG_ENVELOPED: same as CryptDecryptMessage.
//  For CMSG_SIGNED_AND_ENVELOPED: same as CryptDecryptMessage plus
//      CryptVerifyMessageSignature.
//  For CMSG_HASHED: verifies the hash and returns decoded content.
//--------------------------------------------------------------------------
function CryptDecodeMessage(
  dwMsgTypeFlags: DWORD;
  pDecryptPara: PCRYPT_DECRYPT_MESSAGE_PARA;
  pVerifyPara: PCRYPT_VERIFY_MESSAGE_PARA;
  dwSignerIndex: DWORD;
  pbEncodedBlob: PBYTE;
  cbEncodedBlob: DWORD;
  dwPrevInnerContentType: DWORD;
  var pdwMsgType: DWORD;
  var pdwInnerContentType: DWORD;
  pbDecoded: PBYTE;
  var pcbDecoded: DWORD;
  ppXchgCert: PPCCERT_CONTEXT;
  ppSignerCert: PPCCERT_CONTEXT
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Hash the message.
//
//  If fDetachedHash is TRUE, only the ComputedHash is encoded in the
//  pbHashedBlob. Otherwise, both the ToBeHashed and ComputedHash
//  are encoded.
//
//  pcbHashedBlob or pcbComputedHash can be NULL, indicating the caller
//  isn't interested in getting the output.
//--------------------------------------------------------------------------
function CryptHashMessage(
  pHashPara: PCRYPT_HASH_MESSAGE_PARA;
  fDetachedHash: BOOL;
  cToBeHashed: DWORD;
  rgpbToBeHashed: TARR_PBYTE;
  rgcbToBeHashed: TARR_DWORD;
  pbHashedBlob: PBYTE;
  pcbHashedBlob: PDWORD;
  pbComputedHash: PBYTE;
  pcbComputedHash: PDWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Verify a hashed message.
//
//  pcbToBeHashed or pcbComputedHash can be NULL,
//  indicating the caller isn't interested in getting the output.
//--------------------------------------------------------------------------
function CryptVerifyMessageHash(
  pHashPara: PCRYPT_HASH_MESSAGE_PARA;
  pbHashedBlob: PBYTE;
  cbHashedBlob: DWORD;
  pbToBeHashed: PBYTE;
  pcbToBeHashed: PDWORD;
  pbComputedHash: PBYTE;
  pcbComputedHash: PDWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Verify a hashed message containing a detached hash.
//  The "to be hashed" content is passed in separately. No
//  decoded output. Otherwise, identical to CryptVerifyMessageHash.
//
//  pcbComputedHash can be NULL, indicating the caller isn't interested
//  in getting the output.
//--------------------------------------------------------------------------
function CryptVerifyDetachedMessageHash(
  pHashPara: PCRYPT_HASH_MESSAGE_PARA;
  pbDetachedHashBlob: PBYTE;
  cbDetachedHashBlob: DWORD;
  cToBeHashed: DWORD;
  rgpbToBeHashed: TARR_PBYTE;
  rgcbToBeHashed: TARR_DWORD;
  pbComputedHash: PBYTE;
  pcbComputedHash: PDWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Sign the message using the provider's private key specified in the
//  parameters. A dummy SignerId is created and stored in the message.
//
//  Normally used until a certificate has been created for the key.
//--------------------------------------------------------------------------
function CryptSignMessageWithKey(
  pSignPara: PCRYPT_KEY_SIGN_MESSAGE_PARA;
  pbToBeSigned: PBYTE;
  cbToBeSigned: DWORD;
  pbSignedBlob: PBYTE;
  var pcbSignedBlob: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Verify a signed message using the specified public key info.
//
//  Normally called by a CA until it has created a certificate for the
//  key.
//
//  pPublicKeyInfo contains the public key to use to verify the signed
//  message. If NULL, the signature isn't verified (for instance, the decoded
//  content may contain the PublicKeyInfo).
//
//  pcbDecoded can be NULL, indicating the caller isn't interested
//  in getting the decoded content.
//--------------------------------------------------------------------------
function CryptVerifyMessageSignatureWithKey(
  pVerifyPara: PCRYPT_KEY_VERIFY_MESSAGE_PARA;
  pPublicKeyInfo: PCERT_PUBLIC_KEY_INFO;
  pbSignedBlob: PBYTE;
  cbSignedBlob: DWORD;
  pbDecoded: PBYTE;
  pcbDecoded: PDWORD
  ): BOOL; stdcall;

//+=========================================================================
//  System Certificate Store Data Structures and APIs
//==========================================================================

//+-------------------------------------------------------------------------
//  Get a system certificate store based on a subsystem protocol.
//
//  Current examples of subsystems protocols are:
//      "MY"    Cert Store hold certs with associated Private Keys
//      "CA"    Certifying Authority certs
//      "ROOT"  Root Certs
//      "SPC"   Software publisher certs
//
//
//  If hProv is NULL the default provider "1" is opened for you.
//  When the store is closed the provider is release. Otherwise
//  if hProv is not NULL, no provider is created or released.
//
//  The returned Cert Store can be searched for an appropriate Cert
//  using the Cert Store API's (see certstor.h)
//
//  When done, the cert store should be closed using CertStoreClose
//--------------------------------------------------------------------------
function CertOpenSystemStoreA(
  hProv: HCRYPTPROV;
  szSubsystemProtocol: LPCSTR
  ): HCERTSTORE; stdcall;
function CertOpenSystemStoreW(
  hProv: HCRYPTPROV;
  szSubsystemProtocol: LPCWSTR
  ): HCERTSTORE; stdcall;
{$IFDEF UNICODE}
function CertOpenSystemStore(
  hProv: HCRYPTPROV;
  szSubsystemProtocol: LPCWSTR
  ): HCERTSTORE; stdcall;
{$ELSE}
function CertOpenSystemStore(
  hProv: HCRYPTPROV;
  szSubsystemProtocol: LPCSTR
  ): HCERTSTORE; stdcall;
{$ENDIF} // !UNICODE

function CertAddEncodedCertificateToSystemStoreA(
  szCertStoreName: LPCSTR;
  pbCertEncoded: PBYTE;
  cbCertEncoded: DWORD
  ): BOOL; stdcall;
function CertAddEncodedCertificateToSystemStoreW(
  szCertStoreName: LPCWSTR;
  pbCertEncoded: PBYTE;
  cbCertEncoded: DWORD
  ): BOOL; stdcall;
{$IFDEF UNICODE}
function CertAddEncodedCertificateToSystemStore(
  szCertStoreName: LPCWSTR;
  pbCertEncoded: PBYTE;
  cbCertEncoded: DWORD
  ): BOOL; stdcall;
{$ELSE}
function CertAddEncodedCertificateToSystemStore(
  szCertStoreName: LPCSTR;
  pbCertEncoded: PBYTE;
  cbCertEncoded: DWORD
  ): BOOL; stdcall;
{$ENDIF} // !UNICODE

//+-------------------------------------------------------------------------
//  Find all certificate chains tying the given issuer name to any certificate
//  that the current user has a private key for.
//
//  If no certificate chain is found, FALSE is returned with LastError set
//  to CRYPT_E_NOT_FOUND and the counts zeroed.
//
//  IE 3.0 ASSUMPTION:
//   The client certificates are in the "My" system store. The issuer
//   cerificates may be in the "Root", "CA" or "My" system stores.
//--------------------------------------------------------------------------
type
  CERT_CHAIN = record
    cCerts:         DWORD; // number of certs in chain
    certs:          PCERT_BLOB; // pointer to array of cert chain blobs
    // representing the certs
    keyLocatorInfo: CRYPT_KEY_PROV_INFO; // key locator for cert
  end;
  PCERT_CHAIN = ^CERT_CHAIN;

// WINCRYPT32API    This is not exported by crypt32, it is exported by softpub
function FindCertsByIssuer(
  pCertChains:         PCERT_CHAIN;
  var pcbCertChains:   DWORD;
  var pcCertChains:    DWORD; // count of certificates chains returned
  pbEncodedIssuerName: PBYTE; // DER encoded issuer name
  cbEncodedIssuerName: DWORD; // count in bytes of encoded issuer name
  pwszPurpose:         LPCWSTR; // "ClientAuth" or "CodeSigning"
  dwKeySpec:           DWORD // only return signers supporting this
  // keyspec
  ): HRESULT; stdcall;

//-------------------------------------------------------------------------
//
//  CryptQueryObject takes a CERT_BLOB or a file name and returns the
//  information about the content in the blob or in the file.
//
//  Parameters:
//  INPUT   dwObjectType:
//                       Indicate the type of the object.  Should be one of the
//                       following:
//                          CERT_QUERY_OBJECT_FILE
//                          CERT_QUERY_OBJECT_BLOB
//
//  INPUT   pvObject:
//                        If dwObjectType == CERT_QUERY_OBJECT_FILE, it is a
//                        LPWSTR, that is, the pointer to a wchar file name
//                        if dwObjectType == CERT_QUERY_OBJECT_BLOB, it is a
//                        PCERT_BLOB, that is, a pointer to a CERT_BLOB
//
//  INPUT   dwExpectedContentTypeFlags:
//                        Indicate the expected contenet type.
//                        Can be one of the following:
//                              CERT_QUERY_CONTENT_FLAG_ALL  (the content can be any type)
//                              CERT_QUERY_CONTENT_FLAG_CERT
//                              CERT_QUERY_CONTENT_FLAG_CTL
//                              CERT_QUERY_CONTENT_FLAG_CRL
//                              CERT_QUERY_CONTENT_FLAG_SERIALIZED_STORE
//                              CERT_QUERY_CONTENT_FLAG_SERIALIZED_CERT
//                              CERT_QUERY_CONTENT_FLAG_SERIALIZED_CTL
//                              CERT_QUERY_CONTENT_FLAG_SERIALIZED_CRL
//                              CERT_QUERY_CONTENT_FLAG_PKCS7_SIGNED
//                              CERT_QUERY_CONTENT_FLAG_PKCS7_UNSIGNED
//                              CERT_QUERY_CONTENT_FLAG_PKCS7_SIGNED_EMBED
//                              CERT_QUERY_CONTNET_FLAG_PKCS10
//                              CERT_QUERY_CONTNET_FLAG_PFX
//
//  INPUT   dwExpectedFormatTypeFlags:
//                        Indicate the expected format type.
//                        Can be one of the following:
//                              CERT_QUERY_FORMAT_FLAG_ALL (the content can be any format)
//                              CERT_QUERY_FORMAT_FLAG_BINARY
//                              CERT_QUERY_FORMAT_FLAG_BASE64_ENCODED
//
//
//  INPUT   dwFlags
//                        Reserved flag.  Should always set to 0
//
//  OUTPUT  pdwMsgAndCertEncodingType
//                        Optional output.  If NULL != pdwMsgAndCertEncodingType,
//                        it contains the encoding type of the content as any
//                        combination of the following:
//                              X509_ASN_ENCODING
//                              PKCS_7_ASN_ENCODING
//
//  OUTPUT  pdwContentType
//                        Optional output.  If NULL!=pdwContentType, it contains
//                        the content type as one of the the following:
//                              CERT_QUERY_CONTENT_CERT
//                              CERT_QUERY_CONTENT_CTL
//                              CERT_QUERY_CONTENT_CRL
//                              CERT_QUERY_CONTENT_SERIALIZED_STORE
//                              CERT_QUERY_CONTENT_SERIALIZED_CERT
//                              CERT_QUERY_CONTENT_SERIALIZED_CTL
//                              CERT_QUERY_CONTENT_SERIALIZED_CRL
//                              CERT_QUERY_CONTENT_PKCS7_SIGNED
//                              CERT_QUERY_CONTENT_PKCS7_UNSIGNED
//                              CERT_QUERY_CONTENT_PKCS7_SIGNED_EMBED
//                              CERT_QUERY_CONTENT_PKCS10
//                              CERT_QUERY_CONTENT_PFX
//
//  OUTPUT  pdwFormatType
//                        Optional output.  If NULL !=pdwFormatType, it
//                        contains the format type of the content as one of the
//                        following:
//                              CERT_QUERY_FORMAT_BINARY
//                              CERT_QUERY_FORMAT_BASE64_ENCODED
//
//
//  OUTPUT  phCertStore
//                        Optional output.  If NULL !=phStore,
//                        it contains a cert store that includes all of certificates,
//                        CRL, and CTL in the object if the object content type is
//                        one of the following:
//                              CERT_QUERY_CONTENT_CERT
//                              CERT_QUERY_CONTENT_CTL
//                              CERT_QUERY_CONTENT_CRL
//                              CERT_QUERY_CONTENT_SERIALIZED_STORE
//                              CERT_QUERY_CONTENT_SERIALIZED_CERT
//                              CERT_QUERY_CONTENT_SERIALIZED_CTL
//                              CERT_QUERY_CONTENT_SERIALIZED_CRL
//                              CERT_QUERY_CONTENT_PKCS7_SIGNED
//                              CERT_QUERY_CONTENT_PKCS7_SIGNED_EMBED
//
//                       Caller should free *phCertStore via CertCloseStore.
//
//
//  OUTPUT  phMsg        Optional output.  If NULL != phMsg,
//                        it contains a handle to a opened message if
//                        the content type is one of the following:
//                              CERT_QUERY_CONTENT_PKCS7_SIGNED
//                              CERT_QUERY_CONTENT_PKCS7_UNSIGNED
//                              CERT_QUERY_CONTENT_PKCS7_SIGNED_EMBED
//
//                       Caller should free *phMsg via CryptMsgClose.
//
//  OUTPUT pContext     Optional output.  If NULL != pContext,
//                      it contains either a PCCERT_CONTEXT or PCCRL_CONTEXT,
//                      or PCCTL_CONTEXT based on the content type.
//
//                      If the content type is CERT_QUERY_CONTENT_CERT or
//                      CERT_QUERY_CONTENT_SERIALIZED_CERT, it is a PCCERT_CONTEXT;
//                      Caller should free the pContext via CertFreeCertificateContext.
//
//                      If the content type is CERT_QUERY_CONTENT_CRL or
//                      CERT_QUERY_CONTENT_SERIALIZED_CRL, it is a PCCRL_CONTEXT;
//                      Caller should free the pContext via CertFreeCRLContext.
//
//                      If the content type is CERT_QUERY_CONTENT_CTL or
//                      CERT_QUERY_CONTENT_SERIALIZED_CTL, it is a PCCTL_CONTEXT;
//                      Caller should free the pContext via CertFreeCTLContext.
//
//  If the *pbObject is of type CERT_QUERY_CONTENT_PKCS10 or CERT_QUERY_CONTENT_PFX, CryptQueryObject
//  will not return anything in *phCertstore, *phMsg, or *ppvContext.
//--------------------------------------------------------------------------
type
  PDWORD = ^DWORD;
  PHCRYPTMSG = ^PHCRYPTMSG;
function CryptQueryObject(
  dwObjectType: DWORD;
  pvObject: pointer;
  dwExpectedContentTypeFlags: DWORD;
  dwExpectedFormatTypeFlags: DWORD;
  dwFlags: DWORD;
  pdwMsgAndCertEncodingType: PDWORD;
  pdwContentType: PDWORD;
  pdwFormatType: PDWORD;
  phCertStore: PHCERTSTORE;
  phMsg: PHCRYPTMSG;
  ppvContext: pointer
  ): BOOL; stdcall;

//-------------------------------------------------------------------------
//dwObjectType for CryptQueryObject
//-------------------------------------------------------------------------
const
  CERT_QUERY_OBJECT_FILE = $00000001;
  CERT_QUERY_OBJECT_BLOB = $00000002;

  //-------------------------------------------------------------------------
  //dwConentType for CryptQueryObject
  //-------------------------------------------------------------------------
  //encoded single certificate
  CERT_QUERY_CONTENT_CERT               = 1;
  //encoded single CTL
  CERT_QUERY_CONTENT_CTL                = 2;
  //encoded single CRL
  CERT_QUERY_CONTENT_CRL                = 3;
  //serialized store
  CERT_QUERY_CONTENT_SERIALIZED_STORE   = 4;
  //serialized single certificate
  CERT_QUERY_CONTENT_SERIALIZED_CERT    = 5;
  //serialized single CTL
  CERT_QUERY_CONTENT_SERIALIZED_CTL     = 6;
  //serialized single CRL
  CERT_QUERY_CONTENT_SERIALIZED_CRL     = 7;
  //a PKCS#7 signed message
  CERT_QUERY_CONTENT_PKCS7_SIGNED       = 8;
  //a PKCS#7 message, such as enveloped message.  But it is not a signed message,
  CERT_QUERY_CONTENT_PKCS7_UNSIGNED     = 9;
  //a PKCS7 signed message embedded in a file
  CERT_QUERY_CONTENT_PKCS7_SIGNED_EMBED = 10;
  //an encoded PKCS#10
  CERT_QUERY_CONTENT_PKCS10             = 11;
  //an encoded PKX BLOB
  CERT_QUERY_CONTENT_PFX                = 12;
  //an encoded CertificatePair (contains forward and/or reverse cross certs)
  CERT_QUERY_CONTENT_CERT_PAIR          = 13;

  //-------------------------------------------------------------------------
  //dwExpectedConentTypeFlags for CryptQueryObject
  //-------------------------------------------------------------------------

  //encoded single certificate
  CERT_QUERY_CONTENT_FLAG_CERT = 1 shl CERT_QUERY_CONTENT_CERT;

  //encoded single CTL
  CERT_QUERY_CONTENT_FLAG_CTL =  1 shl CERT_QUERY_CONTENT_CTL;

  //encoded single CRL
  CERT_QUERY_CONTENT_FLAG_CRL =  1 shl CERT_QUERY_CONTENT_CRL;

  //serialized store
  CERT_QUERY_CONTENT_FLAG_SERIALIZED_STORE =
    1 shl CERT_QUERY_CONTENT_SERIALIZED_STORE;

  //serialized single certificate
  CERT_QUERY_CONTENT_FLAG_SERIALIZED_CERT =
    1 shl CERT_QUERY_CONTENT_SERIALIZED_CERT;

  //serialized single CTL
  CERT_QUERY_CONTENT_FLAG_SERIALIZED_CTL =
    1 shl CERT_QUERY_CONTENT_SERIALIZED_CTL;

  //serialized single CRL
  CERT_QUERY_CONTENT_FLAG_SERIALIZED_CRL =
    1 shl CERT_QUERY_CONTENT_SERIALIZED_CRL;

  //an encoded PKCS#7 signed message
  CERT_QUERY_CONTENT_FLAG_PKCS7_SIGNED =
    1 shl CERT_QUERY_CONTENT_PKCS7_SIGNED;

  //an encoded PKCS#7 message.  But it is not a signed message
  CERT_QUERY_CONTENT_FLAG_PKCS7_UNSIGNED =
    1 shl CERT_QUERY_CONTENT_PKCS7_UNSIGNED;

  //the content includes an embedded PKCS7 signed message
  CERT_QUERY_CONTENT_FLAG_PKCS7_SIGNED_EMBED =
    1 shl CERT_QUERY_CONTENT_PKCS7_SIGNED_EMBED;

  //an encoded PKCS#10
  CERT_QUERY_CONTENT_FLAG_PKCS10 =
    1 shl CERT_QUERY_CONTENT_PKCS10;

  //an encoded PFX BLOB
  CERT_QUERY_CONTENT_FLAG_PFX =
    1 shl CERT_QUERY_CONTENT_PFX;

  //an encoded CertificatePair (contains forward and/or reverse cross certs)
  CERT_QUERY_CONTENT_FLAG_CERT_PAIR =
    1 shl CERT_QUERY_CONTENT_CERT_PAIR;

  //content can be any type
  CERT_QUERY_CONTENT_FLAG_ALL =
    CERT_QUERY_CONTENT_FLAG_CERT or
    CERT_QUERY_CONTENT_FLAG_CTL or
    CERT_QUERY_CONTENT_FLAG_CRL or
    CERT_QUERY_CONTENT_FLAG_SERIALIZED_STORE or
    CERT_QUERY_CONTENT_FLAG_SERIALIZED_CERT or
    CERT_QUERY_CONTENT_FLAG_SERIALIZED_CTL or
    CERT_QUERY_CONTENT_FLAG_SERIALIZED_CRL or
    CERT_QUERY_CONTENT_FLAG_PKCS7_SIGNED or
    CERT_QUERY_CONTENT_FLAG_PKCS7_UNSIGNED or
    CERT_QUERY_CONTENT_FLAG_PKCS7_SIGNED_EMBED or
    CERT_QUERY_CONTENT_FLAG_PKCS10 or
    CERT_QUERY_CONTENT_FLAG_PFX or
    CERT_QUERY_CONTENT_FLAG_CERT_PAIR;

  //-------------------------------------------------------------------------
  //dwFormatType for CryptQueryObject
  //-------------------------------------------------------------------------
  //the content is in binary format
  CERT_QUERY_FORMAT_BINARY                = 1;
  //the content is base64 encoded
  CERT_QUERY_FORMAT_BASE64_ENCODED        = 2;
  //the content is ascii hex encoded with "{ASN}" prefix
  CERT_QUERY_FORMAT_ASN_ASCII_HEX_ENCODED = 3;

  //-------------------------------------------------------------------------
  //dwExpectedFormatTypeFlags for CryptQueryObject
  //-------------------------------------------------------------------------
  //the content is in binary format
  CERT_QUERY_FORMAT_FLAG_BINARY =
    1 shl CERT_QUERY_FORMAT_BINARY;

  //the content is base64 encoded
  CERT_QUERY_FORMAT_FLAG_BASE64_ENCODED =
    1 shl CERT_QUERY_FORMAT_BASE64_ENCODED;

  //the content is ascii hex encoded with "{ASN}" prefix
  CERT_QUERY_FORMAT_FLAG_ASN_ASCII_HEX_ENCODED =
    1 shl CERT_QUERY_FORMAT_ASN_ASCII_HEX_ENCODED;

  //the content can be of any format
  CERT_QUERY_FORMAT_FLAG_ALL =
    CERT_QUERY_FORMAT_FLAG_BINARY or
    CERT_QUERY_FORMAT_FLAG_BASE64_ENCODED or
    CERT_QUERY_FORMAT_FLAG_ASN_ASCII_HEX_ENCODED;

  //
  // Crypt32 Memory Management Routines.  All Crypt32 API which return allocated
  // buffers will do so via CryptMemAlloc, CryptMemRealloc.  Clients can free
  // those buffers using CryptMemFree.  Also included is CryptMemSize
  //

function CryptMemAlloc(
  cbSize: ULONG
  ): pointer; stdcall;

function CryptMemRealloc(
  pv: pointer;
  cbSize: ULONG
  ): pointer; stdcall;

procedure CryptMemFree(
  pv: pointer
  ); stdcall;

//
// Crypt32 Asynchronous Parameter Management Routines.  All Crypt32 API which
// expose asynchronous mode operation use a Crypt32 Async Handle to pass
// around information about the operation e.g. callback routines.  The
// following API are used for manipulation of the async handle
//

type
  HCRYPTASYNC = THANDLE;
  PHCRYPTASYNC = ^HCRYPTASYNC;

type
  PFN_CRYPT_ASYNC_PARAM_FREE_FUNC = procedure(
    pszParamOid: LPSTR;
    pvParam: pointer
    ); stdcall;

function CryptCreateAsyncHandle(
  dwFlags: DWORD;
  phAsync: PHCRYPTASYNC
  ): BOOL; stdcall;

function CryptSetAsyncParam(
  hAsync: HCRYPTASYNC;
  pszParamOid: LPSTR;
  pvParam: pointer;
  pfnFree: PFN_CRYPT_ASYNC_PARAM_FREE_FUNC
  ): BOOL; stdcall;

function CryptGetAsyncParam(
  hAsync: HCRYPTASYNC;
  pszParamOid: LPSTR;
  var ppvParam: pointer;
  var ppfnFree: PFN_CRYPT_ASYNC_PARAM_FREE_FUNC
  ): BOOL; stdcall;

function CryptCloseAsyncHandle(
  hAsync: HCRYPTASYNC
  ): BOOL; stdcall;

//
// Crypt32 Remote Object Retrieval Routines.  This API allows retrieval of
// remote PKI objects where the location is given by an URL.  The remote
// object retrieval manager exposes two provider models.  One is the "Scheme
// Provider" model which allows for installable protocol providers as defined
// by the URL scheme e.g. ldap, http, ftp.  The scheme provider entry point is
// the same as the CryptRetrieveObjectByUrl however the *ppvObject returned
// is ALWAYS a counted array of encoded bits (one per object retrieved).  The
// second provider model is the "Context Provider" model which allows for
// installable creators of CAPI2 context handles (objects) based on the
// retrieved encoded bits.  These are dispatched based on the object OID given
// in the call to CryptRetrieveObjectByUrl.
//

type
  CRYPT_BLOB_ARRAY = record
    cBlob:  DWORD;
    rgBlob: PCRYPT_DATA_BLOB;
  end;
  PCRYPT_BLOB_ARRAY = ^CRYPT_BLOB_ARRAY;

type
  CRYPT_CREDENTIALS = record
    cbSize:            DWORD;
    pszCredentialsOid: LPCSTR;
    pvCredentials:     pointer;
  end;
  PCRYPT_CREDENTIALS = ^CRYPT_CREDENTIALS;

const
  CREDENTIAL_OID_PASSWORD_CREDENTIALS_A = LPCSTR(1);
  CREDENTIAL_OID_PASSWORD_CREDENTIALS_W = LPCSTR(2);

{$IFDEF UNICODE}
  CREDENTIAL_OID_PASSWORD_CREDENTIALS = CREDENTIAL_OID_PASSWORD_CREDENTIALS_W;
{$ELSE}
  CREDENTIAL_OID_PASSWORD_CREDENTIALS = CREDENTIAL_OID_PASSWORD_CREDENTIALS_A;
{$ENDIF} //UNICODE

type
  CRYPT_PASSWORD_CREDENTIALSA = record
    cbSize:      DWORD;
    pszUsername: LPSTR;
    pszPassword: LPSTR;
  end;
  PCRYPT_PASSWORD_CREDENTIALSA = ^CRYPT_PASSWORD_CREDENTIALSA;
type
  CRYPT_PASSWORD_CREDENTIALSW = record
    cbSize:      DWORD;
    pszUsername: LPWSTR;
    pszPassword: LPWSTR;
  end;
  PCRYPT_PASSWORD_CREDENTIALSW = ^CRYPT_PASSWORD_CREDENTIALSW;
{$IFDEF UNICODE}
  CRYPT_PASSWORD_CREDENTIALS = CRYPT_PASSWORD_CREDENTIALSW;
  PCRYPT_PASSWORD_CREDENTIALS = PCRYPT_PASSWORD_CREDENTIALSW;
{$ELSE}
  CRYPT_PASSWORD_CREDENTIALS = CRYPT_PASSWORD_CREDENTIALSA;
  PCRYPT_PASSWORD_CREDENTIALS = PCRYPT_PASSWORD_CREDENTIALSA;
{$ENDIF} // UNICODE

  //
  // Scheme Provider Signatures
  //

const
  SCHEME_OID_RETRIEVE_ENCODED_OBJECT_FUNC = 'SchemeDllRetrieveEncodedObject';

type
  PFN_FREE_ENCODED_OBJECT_FUNC = procedure(
    pszObjectOid: LPCSTR;
    pObject: PCRYPT_BLOB_ARRAY;
    pvFreeContext: pointer
    ); stdcall;

  //
  // SchemeDllRetrieveEncodedObject has the following signature:
  //
  // BOOL WINAPI SchemeDllRetrieveEncodedObject (
  //                   IN LPCSTR pszUrl,
  //                   IN LPCSTR pszObjectOid,
  //                   IN DWORD dwRetrievalFlags,
  //                   IN DWORD dwTimeout,
  //                   OUT PCRYPT_BLOB_ARRAY pObject,
  //                   OUT PFN_FREE_ENCODED_OBJECT_FUNC* ppfnFreeObject,
  //                   OUT LPVOID* ppvFreeContext,
  //                   IN HCRYPTASYNC hAsyncRetrieve,
  //                   IN PCRYPT_CREDENTIALS pCredentials,
  //                   IN LPVOID pvReserved
  //                   )
  //

// Context Provider Signatures
const
  CONTEXT_OID_CREATE_OBJECT_CONTEXT_FUNC = 'ContextDllCreateObjectContext';

  CONTEXT_OID_CERTIFICATE = LPCSTR(1);
  CONTEXT_OID_CRL         = LPCSTR(2);
  CONTEXT_OID_CTL         = LPCSTR(3);
  CONTEXT_OID_PKCS7       = LPCSTR(4);
  CONTEXT_OID_CAPI2_ANY   = LPCSTR(5);

  //
  // ContextDllCreateObjectContext has the following signature:
  //
  // BOOL WINAPI ContextDllCreateObjectContext (
  //                    IN LPCSTR pszObjectOid,
  //                    IN DWORD dwRetrievalFlags,
  //                    IN PCRYPT_BLOB_ARRAY pObject,
  //                    OUT LPVOID* ppvContext
  //                    )
  //

  //
  // Remote Object Retrieval API
  //

  //
  // Retrieval flags
  //

  CRYPT_RETRIEVE_MULTIPLE_OBJECTS      = $00000001;
  CRYPT_CACHE_ONLY_RETRIEVAL           = $00000002;
  CRYPT_WIRE_ONLY_RETRIEVAL            = $00000004;
  CRYPT_DONT_CACHE_RESULT              = $00000008;
  CRYPT_ASYNC_RETRIEVAL                = $00000010;
  CRYPT_STICKY_CACHE_RETRIEVAL         = $00001000;
  CRYPT_LDAP_SCOPE_BASE_ONLY_RETRIEVAL = $00002000;
  CRYPT_OFFLINE_CHECK_RETRIEVAL        = $00004000;

  // When the following flag is set, the following 2 NULL terminated ascii
  // strings are inserted at the beginning of each returned blob:
  //  "%d\0%s\0", dwEntryIndex, pszAttribute
  //
  //  The first dwEntryIndex is 0, "0\0".
  //
  // When set, pszObjectOid must be NULL, so that a PCRYPT_BLOB_ARRAY is returned.
  CRYPT_LDAP_INSERT_ENTRY_ATTRIBUTE    = $00008000;

  // Set this flag to digitally sign all of the ldap traffic to and from a
  // Windows 2000 LDAP server using the Kerberos authentication protocol.
  // This feature provides integrity required by some applications.
  CRYPT_LDAP_SIGN_RETRIEVAL            = $00010000;

  // Set this flag to inhibit automatic authentication handling. See the
  // wininet flag, INTERNET_FLAG_NO_AUTH, for more details.
  CRYPT_NO_AUTH_RETRIEVAL              = $00020000;

  // Performs an A-Record only DNS lookup on the supplied host string.
  // This prevents bogus DNS queries from being generated when resolving host
  // names. Use this flag whenever passing a hostname as opposed to a
  // domain name for the hostname parameter.
  //
  // See LDAP_OPT_AREC_EXCLUSIVE defined in winldap.h for more details.
  CRYPT_LDAP_AREC_EXCLUSIVE_RETRIEVAL  = $00040000;

  //
  // Data verification retrieval flags
  //
  // CRYPT_VERIFY_CONTEXT_SIGNATURE is used to get signature verification
  // on the context created.  In this case pszObjectOid must be non-NULL and
  // pvVerify points to the signer certificate context
  //
  // CRYPT_VERIFY_DATA_HASH is used to get verification of the blob data
  // retrieved by the protocol.  The pvVerify points to an URL_DATA_HASH
  // structure (TBD)
  //

  CRYPT_VERIFY_CONTEXT_SIGNATURE = $00000020;
  CRYPT_VERIFY_DATA_HASH         = $00000040;

  //
  // Time Valid Object flags
  //

  CRYPT_KEEP_TIME_VALID          = $00000080;
  CRYPT_DONT_VERIFY_SIGNATURE    = $00000100;
  CRYPT_DONT_CHECK_TIME_VALIDITY = $00000200;

  // The default checks if ftNextUpdate >= ftValidFor. Set this flag to
  // check if ftThisUpdate >= ftValidFor.
  CRYPT_CHECK_FRESHNESS_TIME_VALIDITY = $00000400;

  CRYPT_ACCUMULATIVE_TIMEOUT          = $00000800;

type
  CRYPT_RETRIEVE_AUX_INFO = record
    cbSize:        DWORD;
    pLastSyncTime: LPFILETIME;
  end;
  PCRYPT_RETRIEVE_AUX_INFO = ^CRYPT_RETRIEVE_AUX_INFO;

function CryptRetrieveObjectByUrlA(
  pszUrl: LPCSTR;
  pszObjectOid: LPCSTR;
  dwRetrievalFlags: DWORD;
  dwTimeout: DWORD;
  var ppvObject: pointer;
  hAsyncRetrieve: HCRYPTASYNC;
  pCredentials: PCRYPT_CREDENTIALS;
  pvVerify: pointer;
  pAuxInfo: PCRYPT_RETRIEVE_AUX_INFO
  ): BOOL; stdcall;
function CryptRetrieveObjectByUrlW(
  pszUrl: LPCWSTR;
  pszObjectOid: LPCSTR;
  dwRetrievalFlags: DWORD;
  dwTimeout: DWORD;
  var ppvObject: pointer;
  hAsyncRetrieve: HCRYPTASYNC;
  pCredentials: PCRYPT_CREDENTIALS;
  pvVerify: pointer;
  pAuxInfo: PCRYPT_RETRIEVE_AUX_INFO
  ): BOOL; stdcall;
{$IFDEF UNICODE}
function CryptRetrieveObjectByUrl(
  pszUrl: LPCWSTR;
  pszObjectOid: LPCSTR;
  dwRetrievalFlags: DWORD;
  dwTimeout: DWORD;
  var ppvObject: pointer;
  hAsyncRetrieve: HCRYPTASYNC;
  pCredentials: PCRYPT_CREDENTIALS;
  pvVerify: pointer;
  pAuxInfo: PCRYPT_RETRIEVE_AUX_INFO
  ): BOOL; stdcall;
{$ELSE}
function CryptRetrieveObjectByUrl(
  pszUrl: LPCSTR;
  pszObjectOid: LPCSTR;
  dwRetrievalFlags: DWORD;
  dwTimeout: DWORD;
  var ppvObject: pointer;
  hAsyncRetrieve: HCRYPTASYNC;
  pCredentials: PCRYPT_CREDENTIALS;
  pvVerify: pointer;
  pAuxInfo: PCRYPT_RETRIEVE_AUX_INFO
  ): BOOL; stdcall;
{$ENDIF} // !UNICODE

//
// Call back function to cancel object retrieval
//
// The function can be installed on a per thread basis.
// If CryptInstallCancelRetrieval is called for multiple times, only the most recent
// installation will be kept.
//
// This is only effective for http, https, gopher, and ftp protocol.
// It is ignored by the rest of the protocols.

type
  PFN_CRYPT_CANCEL_RETRIEVAL = function(
    dwFlags: DWORD;
    pvArg: pointer
    ): BOOL; stdcall;

  //
  // PFN_CRYPT_CANCEL_RETRIEVAL
  //
  // This function should return FALSE when the object retrieval should be continued
  // and return TRUE when the object retrieval should be cancelled.
  //

function CryptInstallCancelRetrieval(
  pfnCancel: PFN_CRYPT_CANCEL_RETRIEVAL;
  pvArg: pointer;
  dwFlags: DWORD;
  pvReserved: pointer
  ): BOOL; stdcall;

function CryptUninstallCancelRetrieval(
  dwFlags: DWORD;
  pvReserved: pointer
  ): BOOL; stdcall;

function CryptCancelAsyncRetrieval(
  hAsyncRetrieval: HCRYPTASYNC
  ): BOOL; stdcall;

//
// Remote Object Async Retrieval parameters
//

//
// A client that wants to be notified of asynchronous object retrieval
// completion sets this parameter on the async handle
//
const
  CRYPT_PARAM_ASYNC_RETRIEVAL_COMPLETION = LPCSTR(1);

type
  PFN_CRYPT_ASYNC_RETRIEVAL_COMPLETION_FUNC = procedure(
    pvCompletion: pointer;
    dwCompletionCode: DWORD;
    pszUrl: LPCSTR;
    pszObjectOid: LPSTR;
    pvObject: pointer
    ); stdcall;

type
  CRYPT_ASYNC_RETRIEVAL_COMPLETION = record
    pfnCompletion: PFN_CRYPT_ASYNC_RETRIEVAL_COMPLETION_FUNC;
    pvCompletion:  pointer;
  end;
  PCRYPT_ASYNC_RETRIEVAL_COMPLETION = ^CRYPT_ASYNC_RETRIEVAL_COMPLETION;

  //
  // This function is set on the async handle by a scheme provider that
  // supports asynchronous retrieval
  //
const
  CRYPT_PARAM_CANCEL_ASYNC_RETRIEVAL = LPCSTR(2);

type
  PFN_CANCEL_ASYNC_RETRIEVAL_FUNC = function(
    hAsyncRetrieve: HCRYPTASYNC
    ): BOOL; stdcall;

  //
  // Get the locator for a CAPI object
  //
const
  CRYPT_GET_URL_FROM_PROPERTY         = $00000001;
  CRYPT_GET_URL_FROM_EXTENSION        = $00000002;
  CRYPT_GET_URL_FROM_UNAUTH_ATTRIBUTE = $00000004;
  CRYPT_GET_URL_FROM_AUTH_ATTRIBUTE   = $00000008;

type
  TARR_LPWSTR = ^LPWSTR;
  CRYPT_URL_ARRAY = record
    cUrl:     DWORD;
    rgwszUrl: TARR_LPWSTR;
  end;
  PCRYPT_URL_ARRAY = ^CRYPT_URL_ARRAY;

type
  CRYPT_URL_INFO = record
    cbSize:          DWORD;
    // Seconds between syncs
    dwSyncDeltaTime: DWORD;
    // Returned URLs may be grouped. For instance, groups of cross cert
    // distribution points. Each distribution point may have multiple
    // URLs, (LDAP and HTTP scheme).
    cGroup:          DWORD;
    rgcGroupEntry:   TARR_DWORD;
  end;
  PCRYPT_URL_INFO = ^CRYPT_URL_INFO;

function CryptGetObjectUrl(
  pszUrlOid: LPCSTR;
  pvPara: pointer;
  dwFlags: DWORD;
  pUrlArray: PCRYPT_URL_ARRAY;
  var pcbUrlArray: DWORD;
  pUrlInfo: PCRYPT_URL_INFO;
  var pcbUrlInfo: DWORD;
  pvReserved: pointer
  ): BOOL; stdcall;

const
  URL_OID_GET_OBJECT_URL_FUNC = 'UrlDllGetObjectUrl';

  //
  // UrlDllGetObjectUrl has the same signature as CryptGetObjectUrl
  //

  //
  // URL_OID_CERTIFICATE_ISSUER
  //
  // pvPara == PCCERT_CONTEXT, certificate whose issuer's URL is being requested
  //
  // This will be retrieved from the authority info access extension or property
  // on the certificate
  //
  // URL_OID_CERTIFICATE_CRL_DIST_POINT
  //
  // pvPara == PCCERT_CONTEXT, certificate whose CRL distribution point is being
  // requested
  //
  // This will be retrieved from the CRL distribution point extension or property
  // on the certificate
  //
  // URL_OID_CTL_ISSUER
  //
  // pvPara == PCCTL_CONTEXT, Signer Index, CTL whose issuer's URL (identified
  // by the signer index) is being requested
  //
  // This will be retrieved from an authority info access attribute method encoded
  // in each signer info in the PKCS7 (CTL)
  //
  // URL_OID_CTL_NEXT_UPDATE
  //
  // pvPara == PCCTL_CONTEXT, Signer Index, CTL whose next update URL is being
  // requested and an optional signer index in case we need to check signer
  // info attributes
  //
  // This will be retrieved from an authority info access CTL extension, property,
  // or signer info attribute method
  //
  // URL_OID_CRL_ISSUER
  //
  // pvPara == PCCRL_CONTEXT, CRL whose issuer's URL is being requested
  //
  // This will be retrieved from a property on the CRL which has been inherited
  // from the subject cert (either from the subject cert issuer or the subject
  // cert distribution point extension).  It will be encoded as an authority
  // info access extension method.
  //
const
  URL_OID_CERTIFICATE_ISSUER         = LPCSTR(1);
  URL_OID_CERTIFICATE_CRL_DIST_POINT = LPCSTR(2);
  URL_OID_CTL_ISSUER                 = LPCSTR(3);
  URL_OID_CTL_NEXT_UPDATE            = LPCSTR(4);
  URL_OID_CRL_ISSUER                 = LPCSTR(5);
  URL_OID_CERTIFICATE_FRESHEST_CRL   = LPCSTR(6);
  URL_OID_CRL_FRESHEST_CRL           = LPCSTR(7);
  URL_OID_CROSS_CERT_DIST_POINT      = LPCSTR(8);

type
  CERT_CRL_CONTEXT_PAIR = record
    pCertContext: PCCERT_CONTEXT;
    pCrlContext:  PCCRL_CONTEXT;
  end;
  PCERT_CRL_CONTEXT_PAIR = ^CERT_CRL_CONTEXT_PAIR;
  PCCERT_CRL_CONTEXT_PAIR = ^CERT_CRL_CONTEXT_PAIR;

  //
  // Get a time valid CAPI2 object
  //

function CryptGetTimeValidObject(
  pszTimeValidOid: LPCSTR;
  pvPara: pointer;
  pIssuer: PCCERT_CONTEXT;
  pftValidFor: LPFILETIME;
  dwFlags: DWORD;
  dwTimeout: DWORD;
  var ppvObject: pointer;
  pCredentials: PCRYPT_CREDENTIALS;
  pvReserved: pointer
  ): BOOL; stdcall;

const
  TIME_VALID_OID_GET_OBJECT_FUNC = 'TimeValidDllGetObject';

  //
  // TimeValidDllGetObject has the same signature as CryptGetTimeValidObject
  //

  //
  // TIME_VALID_OID_GET_CTL
  //
  // pvPara == PCCTL_CONTEXT, the current CTL
  //
  // TIME_VALID_OID_GET_CRL
  //
  // pvPara == PCCRL_CONTEXT, the current CRL
  //
  // TIME_VALID_OID_GET_CRL_FROM_CERT
  //
  // pvPara == PCCERT_CONTEXT, the subject cert
  //

  TIME_VALID_OID_GET_CTL                    = LPCSTR(1);
  TIME_VALID_OID_GET_CRL                    = LPCSTR(2);
  TIME_VALID_OID_GET_CRL_FROM_CERT          = LPCSTR(3);
  TIME_VALID_OID_GET_FRESHEST_CRL_FROM_CERT = LPCSTR(4);
  TIME_VALID_OID_GET_FRESHEST_CRL_FROM_CRL  = LPCSTR(5);

function CryptFlushTimeValidObject(
  pszFlushTimeValidOid: LPCSTR;
  pvPara: pointer;
  pIssuer: PCCERT_CONTEXT;
  dwFlags: DWORD;
  pvReserved: pointer
  ): BOOL; stdcall;

const
  TIME_VALID_OID_FLUSH_OBJECT_FUNC = 'TimeValidDllFlushObject';

  //
  // TimeValidDllFlushObject has the same signature as CryptFlushTimeValidObject
  //

  //
  // TIME_VALID_OID_FLUSH_CTL
  //
  // pvPara == PCCTL_CONTEXT, the CTL to flush
  //
  // TIME_VALID_OID_FLUSH_CRL
  //
  // pvPara == PCCRL_CONTEXT, the CRL to flush
  //
  // TIME_VALID_OID_FLUSH_CRL_FROM_CERT
  //

  TIME_VALID_OID_FLUSH_CTL                    = LPCSTR(1);
  TIME_VALID_OID_FLUSH_CRL                    = LPCSTR(2);
  TIME_VALID_OID_FLUSH_CRL_FROM_CERT          = LPCSTR(3);
  TIME_VALID_OID_FLUSH_FRESHEST_CRL_FROM_CERT = LPCSTR(4);
  TIME_VALID_OID_FLUSH_FRESHEST_CRL_FROM_CRL  = LPCSTR(5);

  //-------------------------------------------------------------------------
  // Data Protection APIs
  //-------------------------------------------------------------------------

  //
  // Data protection APIs enable applications to easily secure data.
  //
  // The base provider provides protection based on the users' logon
  // credentials. The data secured with these APIs follow the same
  // roaming characteristics as HKCU -- if HKCU roams, the data
  // protected by the base provider may roam as well. This makes
  // the API ideal for the munging of data stored in the registry.
  //

  //
  // Prompt struct -- what to tell users about the access
  //
type
  CRYPTPROTECT_PROMPTSTRUCT = record
    cbSize:        DWORD;
    dwPromptFlags: DWORD;
    hwndApp:       HWND;
    szPrompt:      LPCWSTR;
  end;
  PCRYPTPROTECT_PROMPTSTRUCT = ^CRYPTPROTECT_PROMPTSTRUCT;

  //
  // base provider action
  //
const
  CRYPTPROTECT_DEFAULT_PROVIDER: TGUID =
  (D1: $DF9D8CD0; D2: $1501; D3: $11D1;
    D4: ($8C, $7A, $00, $C0, $4F, $C2, $97, $EB));

  //
  // CryptProtect PromptStruct dwPromtFlags
  //
  //
  // prompt on unprotect
  CRYPTPROTECT_PROMPT_ON_UNPROTECT = $1; // 1<<0
  //
  // prompt on protect
  CRYPTPROTECT_PROMPT_ON_PROTECT   = $2; // 1<<1
  CRYPTPROTECT_PROMPT_RESERVED     = $04; // reserved, do not use.

  //
  // only allow strong variant UI protection (user supplied password currently).
  CRYPTPROTECT_PROMPT_STRONG       = $08; // 1<<3

  //
  // CryptProtectData and CryptUnprotectData dwFlags
  //
  // for remote-access situations where ui is not an option
  // if UI was specified on protect or unprotect operation, the call
  // will fail and GetLastError() will indicate ERROR_PASSWORD_RESTRICTION
  CRYPTPROTECT_UI_FORBIDDEN        = $1;

  // per machine protected data -- any user on machine where CryptProtectData
  // took place may CryptUnprotectData
  CRYPTPROTECT_LOCAL_MACHINE       = $4;

  // force credential synchronize during CryptProtectData()
  // Synchronize is only operation that occurs during this operation
  CRYPTPROTECT_CRED_SYNC           = $8;

  // Generate an Audit on protect and unprotect operations
  CRYPTPROTECT_AUDIT               = $10;

  // Protect data with a non-recoverable key
  CRYPTPROTECT_NO_RECOVERY         = $20;

  // Verify the protection of a protected blob
  CRYPTPROTECT_VERIFY_PROTECTION   = $40;

  // flags reserved for system use
  CRYPTPROTECT_FIRST_RESERVED_FLAGVAL = $0FFFFFFF;
  CRYPTPROTECT_LAST_RESERVED_FLAGVAL  = $FFFFFFFF;

  // flags specific to base provider

function CryptProtectData(
  pDataIn: PDATA_BLOB;
  szDataDescr: LPCWSTR;
  pOptionalEntropy: PDATA_BLOB;
  pvReserved: pointer;
  pPromptStruct: PCRYPTPROTECT_PROMPTSTRUCT;
  dwFlags: DWORD;
  var pDataOut: DATA_BLOB // out encr blob
  ): BOOL; stdcall;

function CryptUnprotectData(
  pDataIn: PDATA_BLOB; // in encr blob
  var ppszDataDescr: LPWSTR; // out
  pOptionalEntropy: PDATA_BLOB;
  pvReserved: pointer;
  pPromptStruct: PCRYPTPROTECT_PROMPTSTRUCT;
  dwFlags: DWORD;
  var pDataOut: DATA_BLOB
  ): BOOL; stdcall;

//+=========================================================================
//  Helper functions to build certificates
//==========================================================================

//+-------------------------------------------------------------------------
//
// Builds a self-signed certificate and returns a PCCERT_CONTEXT representing
// the certificate. A hProv must be specified to build the cert context.
//
// pSubjectIssuerBlob is the DN for the certifcate. If an alternate subject
// name is desired it must be specified as an extension in the pExtensions
// parameter. pSubjectIssuerBlob can NOT be NULL, so minimually an empty DN
// must be specified.
//
// By default:
// pKeyProvInfo - The CSP is queried for the KeyProvInfo parameters. Only the Provider,
// Provider Type and Container is queried. Many CSPs don't support these
// queries and will cause a failure. In such cases the pKeyProvInfo
// must be specified (RSA BASE works fine).
//
// pSignatureAlgorithm - will default to SHA1RSA
// pStartTime will default to the current time
// pEndTime will default to 1 year
// pEntensions will be empty.
//
// The returned PCCERT_CONTEXT will reference the private keys by setting the
// CERT_KEY_PROV_INFO_PROP_ID. However, if this property is not desired specify the
// CERT_CREATE_SELFSIGN_NO_KEY_INFO in dwFlags.
//
// If the cert being built is only a dummy placeholder cert for speed it may not
// need to be signed. Signing of the cert is skipped if CERT_CREATE_SELFSIGN_NO_SIGN
// is specified in dwFlags.
//
//--------------------------------------------------------------------------
function CertCreateSelfSignCertificate(
  hProv: HCRYPTPROV;
  var pSubjectIssuerBlob: CERT_NAME_BLOB;
  dwFlags: DWORD;
  pKeyProvInfo: PCRYPT_KEY_PROV_INFO;
  pSignatureAlgorithm: PCRYPT_ALGORITHM_IDENTIFIER;
  pStartTime: PSYSTEMTIME;
  pEndTime: PSYSTEMTIME;
  pExtensions: PCERT_EXTENSIONS
  ): PCCERT_CONTEXT; stdcall;

const
  CERT_CREATE_SELFSIGN_NO_SIGN     = 1;
  CERT_CREATE_SELFSIGN_NO_KEY_INFO = 2;

  //+=========================================================================
  //  Key Identifier Property Data Structures and APIs
  //==========================================================================

  //+-------------------------------------------------------------------------
  //  Get the property for the specified Key Identifier.
  //
  //  The Key Identifier is the SHA1 hash of the encoded CERT_PUBLIC_KEY_INFO.
  //  The Key Identifier for a certificate can be obtained by getting the
  //  certificate's CERT_KEY_IDENTIFIER_PROP_ID. The
  //  CryptCreateKeyIdentifierFromCSP API can be called to create the Key
  //  Identifier from a CSP Public Key Blob.
  //
  //  A Key Identifier can have the same properties as a certificate context.
  //  CERT_KEY_PROV_INFO_PROP_ID is the property of most interest.
  //  For CERT_KEY_PROV_INFO_PROP_ID, pvData points to a CRYPT_KEY_PROV_INFO
  //  structure. Elements pointed to by fields in the pvData structure follow the
  //  structure. Therefore, *pcbData will exceed the size of the structure.
  //
  //  If CRYPT_KEYID_ALLOC_FLAG is set, then, *pvData is updated with a
  //  pointer to allocated memory. LocalFree() must be called to free the
  //  allocated memory.
  //
  //  By default, searches the CurrentUser's list of Key Identifiers.
  //  CRYPT_KEYID_MACHINE_FLAG can be set to search the LocalMachine's list
  //  of Key Identifiers. When CRYPT_KEYID_MACHINE_FLAG is set, pwszComputerName
  //  can also be set to specify the name of a remote computer to be searched
  //  instead of the local machine.
  //--------------------------------------------------------------------------
function CryptGetKeyIdentifierProperty(
  pKeyIdentifier: PCRYPT_HASH_BLOB;
  dwPropId: DWORD;
  dwFlags: DWORD;
  pwszComputerName: LPCWSTR;
  pvReserved: pointer;
  pvData: pointer;
  var pcbData: DWORD
  ): BOOL; stdcall;

// When the following flag is set, searches the LocalMachine instead of the
// CurrentUser. This flag is applicable to all the KeyIdentifierProperty APIs.
const
  CRYPT_KEYID_MACHINE_FLAG = $00000020;

  // When the following flag is set, *pvData is updated with a pointer to
  // allocated memory. LocalFree() must be called to free the allocated memory.
  CRYPT_KEYID_ALLOC_FLAG   = $00008000;

  //+-------------------------------------------------------------------------
  //  Set the property for the specified Key Identifier.
  //
  //  For CERT_KEY_PROV_INFO_PROP_ID pvData points to the
  //  CRYPT_KEY_PROV_INFO data structure. For all other properties, pvData
  //  points to a CRYPT_DATA_BLOB.
  //
  //  Setting pvData == NULL, deletes the property.
  //
  //  Set CRYPT_KEYID_MACHINE_FLAG to set the property for a LocalMachine
  //  Key Identifier. Set pwszComputerName, to select a remote computer.
  //
  //  If CRYPT_KEYID_DELETE_FLAG is set, the Key Identifier and all its
  //  properties is deleted.
  //
  //  If CRYPT_KEYID_SET_NEW_FLAG is set, the set fails if the property already
  //  exists. For an existing property, FALSE is returned with LastError set to
  //  CRYPT_E_EXISTS.
  //--------------------------------------------------------------------------
function CryptSetKeyIdentifierProperty(
  pKeyIdentifier: PCRYPT_HASH_BLOB;
  dwPropId: DWORD;
  dwFlags: DWORD;
  pwszComputerName: LPCWSTR;
  pvReserved: pointer;
  pvData: pointer
  ): BOOL; stdcall;

// When the following flag is set, the Key Identifier and all its properties
// are deleted.
const
  CRYPT_KEYID_DELETE_FLAG  = $00000010;

  // When the following flag is set, the set fails if the property already
  // exists.
  CRYPT_KEYID_SET_NEW_FLAG = $00002000;

  //+-------------------------------------------------------------------------
  //  For CERT_KEY_PROV_INFO_PROP_ID, rgppvData[] points to a
  //  CRYPT_KEY_PROV_INFO.
  //
  //  Return FALSE to stop the enumeration.
  //--------------------------------------------------------------------------
type
  PFN_CRYPT_ENUM_KEYID_PROP = function(
    pKeyIdentifier: PCRYPT_HASH_BLOB;
    dwFlags: DWORD;
    pvReserved: pointer;
    pvArg: pointer;
    cProp: DWORD;
    rgdwPropId: PDWORD;
    rgpvData: pointer;
    rgcbData: PDWORD
    ): BOOL; stdcall;

  //+-------------------------------------------------------------------------
  //  Enumerate the Key Identifiers.
  //
  //  If pKeyIdentifier is NULL, enumerates all Key Identifers. Otherwise,
  //  calls the callback for the specified KeyIdentifier. If dwPropId is
  //  0, calls the callback with all the properties. Otherwise, only calls
  //  the callback with the specified property (cProp = 1).
  //  Furthermore, when dwPropId is specified, skips KeyIdentifiers not
  //  having the property.
  //
  //  Set CRYPT_KEYID_MACHINE_FLAG to enumerate the LocalMachine
  //  Key Identifiers. Set pwszComputerName, to enumerate Key Identifiers on
  //  a remote computer.
  //--------------------------------------------------------------------------
function CryptEnumKeyIdentifierProperties(
  pKeyIdentifier: PCRYPT_HASH_BLOB;
  dwPropId: DWORD;
  dwFlags: DWORD;
  pwszComputerName: LPCWSTR;
  pvReserved: pointer;
  pvArg: pointer;
  pfnEnum: PFN_CRYPT_ENUM_KEYID_PROP
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//  Create a KeyIdentifier from the CSP Public Key Blob.
//
//  Converts the CSP PUBLICKEYSTRUC into a X.509 CERT_PUBLIC_KEY_INFO and
//  encodes. The encoded CERT_PUBLIC_KEY_INFO is SHA1 hashed to obtain
//  the Key Identifier.
//
//  By default, the pPubKeyStruc->aiKeyAlg is used to find the appropriate
//  public key Object Identifier. pszPubKeyOID can be set to override
//  the default OID obtained from the aiKeyAlg.
//--------------------------------------------------------------------------
type
  PPUBLICKEYSTRUC = ^PUBLICKEYSTRUC;
function CryptCreateKeyIdentifierFromCSP(
  dwCertEncodingType: DWORD;
  pszPubKeyOID: LPCSTR;
  pPubKeyStruc: PPUBLICKEYSTRUC;
  cbPubKeyStruc: DWORD;
  dwFlags: DWORD;
  pvReserved: pointer;
  pbHash: PBYTE;
  var pcbHash: DWORD
  ): BOOL; stdcall;

//+=========================================================================
//  Certificate Chaining Infrastructure
//==========================================================================

//
// The chain engine defines the store namespace and cache partitioning for
// the Certificate Chaining infrastructure.  A default chain engine
// is defined for the process which uses all default system stores e.g.
// Root, CA, Trust, for chain building and caching.  If an application
// wishes to define its own store namespace or have its own partitioned
// cache then it can create its own chain engine.  It is advisable to create
// a chain engine at application startup and use it throughout the lifetime
// of the application in order to get optimal caching behavior
//

type
  HCERTCHAINENGINE   = THANDLE;

const
  HCCE_CURRENT_USER  = HCERTCHAINENGINE(nil);
  HCCE_LOCAL_MACHINE = HCERTCHAINENGINE($1);

  //
  // Create a certificate chain engine.
  //

  //
  // Configuration parameters for the certificate chain engine
  //
  //      hRestrictedRoot - restrict the root store (must be a subset of "Root")
  //
  //      hRestrictedTrust - restrict the store for CTLs
  //
  //      hRestrictedOther - restrict the store for certs and CRLs
  //
  //      cAdditionalStore, rghAdditionalStore - additional stores
  //
  //      NOTE: The algorithm used to define the stores for the engine is as
  //            follows:
  //
  //            hRoot = hRestrictedRoot or System Store "Root"
  //
  //            hTrust = hRestrictedTrust or hWorld (defined later)
  //
  //            hOther = hRestrictedOther or (hRestrictedTrust == NULL) ? hWorld :
  //                     hRestrictedTrust + hWorld
  //
  //            hWorld = hRoot + "CA" + "My" + "Trust" + rghAdditionalStore
  //
  //      dwFlags  - flags
  //
  //          CERT_CHAIN_CACHE_END_CERT - information will be cached on
  //                                      the end cert as well as the other
  //                                      certs in the chain
  //
  //          CERT_CHAIN_THREAD_STORE_SYNC - use separate thread for store syncs
  //                                         and related cache updates
  //
  //          CERT_CHAIN_CACHE_ONLY_URL_RETRIEVAL - don't hit the wire to get
  //                                                URL based objects
  //
  //      dwUrlRetrievalTimeout - timeout for wire based URL object retrievals
  //
const
  CERT_CHAIN_CACHE_END_CERT           = $00000001;
  CERT_CHAIN_THREAD_STORE_SYNC        = $00000002;
  CERT_CHAIN_CACHE_ONLY_URL_RETRIEVAL = $00000004;
  CERT_CHAIN_USE_LOCAL_MACHINE_STORE  = $00000008;
  CERT_CHAIN_ENABLE_CACHE_AUTO_UPDATE = $00000010;
  CERT_CHAIN_ENABLE_SHARE_STORE       = $00000020;

type
  CERT_CHAIN_ENGINE_CONFIG = record
    cbSize:                    DWORD;
    hRestrictedRoot:           HCERTSTORE;
    hRestrictedTrust:          HCERTSTORE;
    hRestrictedOther:          HCERTSTORE;
    cAdditionalStore:          DWORD;
    rghAdditionalStore:        PHCERTSTORE;
    dwFlags:                   DWORD;
    dwUrlRetrievalTimeout:     DWORD;
    MaximumCachedCertificates: DWORD;
    CycleDetectionModulus:     DWORD;
  end;
  PCERT_CHAIN_ENGINE_CONFIG = ^CERT_CHAIN_ENGINE_CONFIG;

function CertCreateCertificateChainEngine(
  pConfig: PCERT_CHAIN_ENGINE_CONFIG;
  var phChainEngine: HCERTCHAINENGINE
  ): BOOL; stdcall;

//
// Free a certificate trust engine
//

procedure CertFreeCertificateChainEngine(
  hChainEngine: HCERTCHAINENGINE
  ); stdcall;

//
// Resync the certificate chain engine.  This resync's the stores backing
// the engine and updates the engine caches.
//

function CertResyncCertificateChainEngine(
  hChainEngine: HCERTCHAINENGINE
  ): BOOL; stdcall;

//
// When an application requests a certificate chain, the data structure
// returned is in the form of a CERT_CHAIN_CONTEXT.  This contains
// an array of CERT_SIMPLE_CHAIN where each simple chain goes from
// an end cert to a self signed cert and the chain context connects simple
// chains via trust lists.  Each simple chain contains the chain of
// certificates, summary trust information about the chain and trust information
// about each certificate element in the chain.
//

//
// Trust status bits
//

type
  CERT_TRUST_STATUS = record
    dwErrorStatus: DWORD;
    dwInfoStatus:  DWORD;
  end;
  PCERT_TRUST_STATUS = ^CERT_TRUST_STATUS;

  //
  // The following are error status bits
  //

  // These can be applied to certificates and chains
const
  CERT_TRUST_NO_ERROR                          = $00000000;
  CERT_TRUST_IS_NOT_TIME_VALID                 = $00000001;
  CERT_TRUST_IS_NOT_TIME_NESTED                = $00000002;
  CERT_TRUST_IS_REVOKED                        = $00000004;
  CERT_TRUST_IS_NOT_SIGNATURE_VALID            = $00000008;
  CERT_TRUST_IS_NOT_VALID_FOR_USAGE            = $00000010;
  CERT_TRUST_IS_UNTRUSTED_ROOT                 = $00000020;
  CERT_TRUST_REVOCATION_STATUS_UNKNOWN         = $00000040;
  CERT_TRUST_IS_CYCLIC                         = $00000080;
  CERT_TRUST_INVALID_EXTENSION                 = $00000100;
  CERT_TRUST_INVALID_POLICY_CONSTRAINTS        = $00000200;
  CERT_TRUST_INVALID_BASIC_CONSTRAINTS         = $00000400;
  CERT_TRUST_INVALID_NAME_CONSTRAINTS          = $00000800;
  CERT_TRUST_HAS_NOT_SUPPORTED_NAME_CONSTRAINT = $00001000;
  CERT_TRUST_HAS_NOT_DEFINED_NAME_CONSTRAINT   = $00002000;
  CERT_TRUST_HAS_NOT_PERMITTED_NAME_CONSTRAINT = $00004000;
  CERT_TRUST_HAS_EXCLUDED_NAME_CONSTRAINT      = $00008000;

  CERT_TRUST_IS_OFFLINE_REVOCATION             = $01000000;
  CERT_TRUST_NO_ISSUANCE_CHAIN_POLICY          = $02000000;

  // These can be applied to chains only

  CERT_TRUST_IS_PARTIAL_CHAIN           = $00010000;
  CERT_TRUST_CTL_IS_NOT_TIME_VALID      = $00020000;
  CERT_TRUST_CTL_IS_NOT_SIGNATURE_VALID = $00040000;
  CERT_TRUST_CTL_IS_NOT_VALID_FOR_USAGE = $00080000;

  //
  // The following are info status bits
  //

  // These can be applied to certificates only

  CERT_TRUST_HAS_EXACT_MATCH_ISSUER = $00000001;
  CERT_TRUST_HAS_KEY_MATCH_ISSUER   = $00000002;
  CERT_TRUST_HAS_NAME_MATCH_ISSUER  = $00000004;
  CERT_TRUST_IS_SELF_SIGNED         = $00000008;

  // These can be applied to certificates and chains

  CERT_TRUST_HAS_PREFERRED_ISSUER       = $00000100;
  CERT_TRUST_HAS_ISSUANCE_CHAIN_POLICY  = $00000200;
  CERT_TRUST_HAS_VALID_NAME_CONSTRAINTS = $00000400;

  // These can be applied to chains only

  CERT_TRUST_IS_COMPLEX_CHAIN = $00010000;

  //
  // Each certificate context in a simple chain has a corresponding chain element
  // in the simple chain context
  //
  // dwErrorStatus has CERT_TRUST_IS_REVOKED, pRevocationInfo set
  // dwErrorStatus has CERT_TRUST_REVOCATION_STATUS_UNKNOWN, pRevocationInfo set

  //
  // BUGBUG: Note that the post processing revocation supported in the first
  //         version only sets cbSize and dwRevocationResult.  Everything else
  //         is NULL
  //

  //
  // Revocation Information
  //

type
  CERT_REVOCATION_INFO = record
    cbSize:             DWORD;
    dwRevocationResult: DWORD;
    pszRevocationOid:   LPCSTR;
    pvOidSpecificInfo:  pointer;
    // fHasFreshnessTime is only set if we are able to retrieve revocation
    // information. For a CRL its CurrentTime - ThisUpdate.
    fHasFreshnessTime:  BOOL;
    dwFreshnessTime:    DWORD;    // seconds
    // NonNULL for CRL base revocation checking
    pCrlInfo:           PCERT_REVOCATION_CRL_INFO;
  end;
  PCERT_REVOCATION_INFO = ^CERT_REVOCATION_INFO;

  //
  // Trust List Information
  //

type
  CERT_TRUST_LIST_INFO = record
    cbSize:      DWORD;
    pCtlEntry:   PCTL_ENTRY;
    pCtlContext: PCCTL_CONTEXT;
  end;
  PCERT_TRUST_LIST_INFO = ^CERT_TRUST_LIST_INFO;

  //
  // Chain Element
  //

type
  CERT_CHAIN_ELEMENT = record
    cbSize:                DWORD;
    pCertContext:          PCCERT_CONTEXT;
    TrustStatus:           CERT_TRUST_STATUS;
    pRevocationInfo:       PCERT_REVOCATION_INFO;
    pIssuanceUsage:        PCERT_ENHKEY_USAGE;    // If NULL, any
    pApplicationUsage:     PCERT_ENHKEY_USAGE; // If NULL, any
    pwszExtendedErrorInfo: LPCWSTR         // If NULL, none
  end;
  PCERT_CHAIN_ELEMENT = ^CERT_CHAIN_ELEMENT;

  //
  // The simple chain is an array of chain elements and a summary trust status
  // for the chain
  //
  // rgpElements[0] is the end certificate chain element
  //
  // rgpElements[cElement-1] is the self-signed "root" certificate chain element
  //

type
  TARR_PCERT_CHAIN_ELEMENT = ^PCERT_CHAIN_ELEMENT; {My type. Oleg}
  CERT_SIMPLE_CHAIN = record
    cbSize:                      DWORD;
    TrustStatus:                 CERT_TRUST_STATUS;
    cElement:                    DWORD;
    rgpElement:                  TARR_PCERT_CHAIN_ELEMENT;
    pTrustListInfo:              PCERT_TRUST_LIST_INFO;
    // fHasRevocationFreshnessTime is only set if we are able to retrieve
    // revocation information for all elements checked for revocation.
    // For a CRL its CurrentTime - ThisUpdate.
    //
    // dwRevocationFreshnessTime is the largest time across all elements
    // checked.
    fHasRevocationFreshnessTime: BOOL;
    dwRevocationFreshnessTime:   DWORD;    // seconds
  end;
  PCERT_SIMPLE_CHAIN = ^CERT_SIMPLE_CHAIN;

  //
  // And the chain context contains an array of simple chains and summary trust
  // status for all the connected simple chains
  //
  // rgpChains[0] is the end certificate simple chain
  //
  // rgpChains[cChain-1] is the final (possibly trust list signer) chain which
  // ends in a certificate which is contained in the root store
  //
type
  PCCERT_CHAIN_CONTEXT = ^CERT_CHAIN_CONTEXT;
  TARR_PCERT_SIMPLE_CHAIN = ^PCERT_SIMPLE_CHAIN; {My type. Oleg}
  TARR_PCCERT_CHAIN_CONTEXT = ^PCCERT_CHAIN_CONTEXT;
  CERT_CHAIN_CONTEXT = record
    cbSize:                      DWORD;
    TrustStatus:                 CERT_TRUST_STATUS;
    cChain:                      DWORD;
    rgpChain:                    TARR_PCERT_SIMPLE_CHAIN;
    // Following is returned when CERT_CHAIN_RETURN_LOWER_QUALITY_CONTEXTS
    // is set in dwFlags
    cLowerQualityChainContext:   DWORD;
    rgpLowerQualityChainContext: TARR_PCCERT_CHAIN_CONTEXT;
    // fHasRevocationFreshnessTime is only set if we are able to retrieve
    // revocation information for all elements checked for revocation.
    // For a CRL its CurrentTime - ThisUpdate.
    //
    // dwRevocationFreshnessTime is the largest time across all elements
    // checked.
    fHasRevocationFreshnessTime: BOOL;
    dwRevocationFreshnessTime:   DWORD;    // seconds
  end;
  PCERT_CHAIN_CONTEXT = ^CERT_CHAIN_CONTEXT;

  //
  // When building a chain, the there are various parameters used for finding
  // issuing certificates and trust lists.  They are identified in the
  // following structure
  //

  // Default usage match type is AND with value zero
const
  USAGE_MATCH_TYPE_AND = $00000000;
  USAGE_MATCH_TYPE_OR  = $00000001;

type
  CERT_USAGE_MATCH = record
    dwType: DWORD;
    Usage:  CERT_ENHKEY_USAGE;
  end;
  PCERT_USAGE_MATCH = ^CERT_USAGE_MATCH;

type
  CTL_USAGE_MATCH = record
    dwType: DWORD;
    Usage:  CTL_USAGE;
  end;
  PCTL_USAGE_MATCH = ^CTL_USAGE_MATCH;

type
  CERT_CHAIN_PARA = record
    cbSize:         DWORD;
    RequestedUsage: CERT_USAGE_MATCH;
{$IFDEF CERT_CHAIN_PARA_HAS_EXTRA_FIELDS}
    // Note, if you #define CERT_CHAIN_PARA_HAS_EXTRA_FIELDS, then, you
    // must zero all unused fields in this data structure.
    // More fields could be added in a future release.
    RequestedIssuancePolicy: CERT_USAGE_MATCH;
    dwUrlRetrievalTimeout: DWORD;     // milliseconds
    fCheckRevocationFreshnessTime: BOOL;
    dwRevocationFreshnessTime: DWORD; // seconds
{$ENDIF}
  end;
  PCERT_CHAIN_PARA = ^CERT_CHAIN_PARA;

  //
  // The following API is used for retrieving certificate chains
  //
  // Parameters:
  //
  //      hChainEngine     - the chain engine (namespace and cache) to use, NULL
  //                         mean use the default chain engine
  //
  //      pCertContext     - the context we are retrieving the chain for, it
  //                         will be the zero index element in the chain
  //
  //      pTime            - the point in time that we want the chain validated
  //                         for.  Note that the time does not affect trust list,
  //                         revocation, or root store checking.  NULL means use
  //                         the current system time
  //
  //      hAdditionalStore - additional store to use when looking up objects
  //
  //      pChainPara       - parameters for chain building
  //
  //      dwFlags          - flags such as should revocation checking be done
  //                         on the chain?
  //
  //      pvReserved       - reserved parameter, must be NULL
  //
  //      ppChainContext   - chain context returned
  //

  // CERT_CHAIN_CACHE_END_CERT can be used here as well
  // Revocation flags are in the high nibble
const
  CERT_CHAIN_REVOCATION_CHECK_END_CERT           = $10000000;
  CERT_CHAIN_REVOCATION_CHECK_CHAIN              = $20000000;
  CERT_CHAIN_REVOCATION_CHECK_CHAIN_EXCLUDE_ROOT = $40000000;
  CERT_CHAIN_REVOCATION_CHECK_CACHE_ONLY         = $80000000;

  // By default, the dwUrlRetrievalTimeout in pChainPara is the timeout used
  // for each revocation URL wire retrieval. When the following flag is set,
  // dwUrlRetrievalTimeout is the accumulative timeout across all
  // revocation URL wire retrievals.
  CERT_CHAIN_REVOCATION_ACCUMULATIVE_TIMEOUT = $08000000;

  // First pass determines highest quality based upon:
  //  - Chain signature valid (higest quality bit of this set)
  //  - Complete chain
  //  - Trusted root          (lowestest quality bit of this set)
  // By default, second pass only considers paths >= highest first pass quality
  CERT_CHAIN_DISABLE_PASS1_QUALITY_FILTERING = $00000040;
  CERT_CHAIN_RETURN_LOWER_QUALITY_CONTEXTS   = $00000080;
  CERT_CHAIN_DISABLE_AUTH_ROOT_AUTO_UPDATE   = $00000100;

  // When this flag is set, pTime will be used as the timestamp time.
  // pTime will be used to determine if the end certificate was valid at this
  // time. Revocation checking will be relative to pTime.
  // In addition, current time will also be used
  // to determine if the certificate is still time valid. All remaining
  // CA and root certificates will be checked using current time and not pTime.
  //
  // This flag was added 4/5/01 in WXP.
  CERT_CHAIN_TIMESTAMP_TIME                  = $00000200;

function CertGetCertificateChain(
  hChainEngine: HCERTCHAINENGINE;
  pCertContext: PCCERT_CONTEXT;
  pTime: LPFILETIME;
  hAdditionalStore: HCERTSTORE;
  pChainPara: PCERT_CHAIN_PARA;
  dwFlags: DWORD;
  pvReserved: pointer;
  var ppChainContext: PCCERT_CHAIN_CONTEXT
  ): BOOL; stdcall;

//
// Free a certificate chain
//

procedure CertFreeCertificateChain(
  pChainContext: PCCERT_CHAIN_CONTEXT
  ); stdcall;

//
// Duplicate (add a reference to) a certificate chain
//

function CertDuplicateCertificateChain(
  pChainContext: PCCERT_CHAIN_CONTEXT
  ): PCCERT_CHAIN_CONTEXT; stdcall;

//
// Specific Revocation Type OID and structure definitions
//

//
// CRL Revocation OID
//
const
  REVOCATION_OID_CRL_REVOCATION = LPCSTR(1);

  //
  // For the CRL revocation OID the pvRevocationPara is NULL
  //

  //
  // CRL Revocation Info
  //

type
  CRL_REVOCATION_INFO = record
    pCrlEntry:       PCRL_ENTRY;
    pCrlContext:     PCCRL_CONTEXT;
    pCrlIssuerChain: PCCERT_CHAIN_CONTEXT;
  end;
  PCRL_REVOCATION_INFO = ^CRL_REVOCATION_INFO;

  //+-------------------------------------------------------------------------
  //  Find the first or next certificate chain context in the store.
  //
  //  The chain context is found according to the dwFindFlags, dwFindType and
  //  its pvFindPara. See below for a list of the find types and its parameters.
  //
  //  If the first or next chain context isn't found, NULL is returned.
  //  Otherwise, a pointer to a read only CERT_CHAIN_CONTEXT is returned.
  //  CERT_CHAIN_CONTEXT must be freed by calling CertFreeCertificateChain
  //  or is freed when passed as the
  //  pPrevChainContext on a subsequent call. CertDuplicateCertificateChain
  //  can be called to make a duplicate.
  //
  //  pPrevChainContext MUST BE NULL on the first
  //  call to find the chain context. To find the next chain context, the
  //  pPrevChainContext is set to the CERT_CHAIN_CONTEXT returned by a previous
  //  call.
  //
  //  NOTE: a NON-NULL pPrevChainContext is always CertFreeCertificateChain'ed by
  //  this function, even for an error.
  //--------------------------------------------------------------------------
function CertFindChainInStore(
  hCertStore: HCERTSTORE;
  dwCertEncodingType: DWORD;
  dwFindFlags: DWORD;
  dwFindType: DWORD;
  pvFindPara: pointer;
  pPrevChainContext: PCCERT_CHAIN_CONTEXT
  ): PCCERT_CHAIN_CONTEXT; stdcall;

const
  CERT_CHAIN_FIND_BY_ISSUER = 1;

  //+-------------------------------------------------------------------------
  //  CERT_CHAIN_FIND_BY_ISSUER
  //
  //  Find a certificate chain having a private key for the end certificate and
  //  matching one of the given issuer names. A matching dwKeySpec and
  //  enhanced key usage can also be specified. Additionally a callback can
  //  be provided for even more caller provided filtering before building the
  //  chain.
  //
  //  By default, only the issuers in the first simple chain are compared
  //  for a name match. CERT_CHAIN_FIND_BY_ISSUER_COMPLEX_CHAIN_FLAG can
  //  be set in dwFindFlags to match issuers in all the simple chains.
  //
  //  CERT_CHAIN_FIND_BY_ISSUER_NO_KEY_FLAG can be set in dwFindFlags to
  //  not check if the end certificate has a private key.
  //
  //  CERT_CHAIN_FIND_BY_ISSUER_COMPARE_KEY_FLAG can be set in dwFindFlags
  //  to compare the public key in the end certificate with the crypto
  //  provider's public key. The dwAcquirePrivateKeyFlags can be set
  //  in CERT_CHAIN_FIND_BY_ISSUER_PARA to enable caching of the private key's
  //  HKEY returned by the CSP.
  //
  //  If dwCertEncodingType == 0, defaults to X509_ASN_ENCODING for the
  //  array of encoded issuer names.
  //
  //  By default, the hCertStore passed to CertFindChainInStore, is passed
  //  as an additional store to CertGetCertificateChain.
  //  CERT_CHAIN_FIND_BY_ISSUER_CACHE_ONLY_FLAG can be set in dwFindFlags
  //  to improve performance by only searching the cached system stores
  //  (root, my, ca, trust) to find the issuer certificates. If you are doing
  //  a find in the "my" system store, than, this flag should be set to
  //  improve performance.
  //
  //  Setting CERT_CHAIN_FIND_BY_ISSUER_LOCAL_MACHINE_FLAG in dwFindFlags
  //  restricts CertGetCertificateChain to search the Local Machine
  //  cached system stores instead of the Current User's.
  //
  //  Setting CERT_CHAIN_FIND_BY_ISSUER_CACHE_ONLY_URL_FLAG in dwFindFlags
  //  restricts CertGetCertificateChain to only search the URL cache
  //  and not hit the wire.
  //--------------------------------------------------------------------------

  // Returns FALSE to skip this certificate. Otherwise, returns TRUE to
  // build a chain for this certificate.
type
  PFN_CERT_CHAIN_FIND_BY_ISSUER_CALLBACK = function(
    pCert: PCCERT_CONTEXT;
    pvFindArg: pointer
    ): BOOL; stdcall;

type
  CERT_CHAIN_FIND_BY_ISSUER_PARA = record
    cbSize: DWORD;
    // If pszUsageIdentifier == NULL, matches any usage.
    pszUsageIdentifier: LPCSTR;
    // If dwKeySpec == 0, matches any KeySpec
    dwKeySpec: DWORD;
    // When CERT_CHAIN_FIND_BY_ISSUER_COMPARE_KEY_FLAG is set in dwFindFlags,
    // CryptAcquireCertificatePrivateKey is called to do the public key
    // comparison. The following flags can be set to enable caching
    // of the acquired private key. See the API for more details on these
    // flags.
    dwAcquirePrivateKeyFlags: DWORD;
    // Pointer to an array of X509, ASN.1 encoded issuer name blobs. If
    // cIssuer == 0, matches any issuer
    cIssuer: DWORD;
    rgIssuer: PCERT_NAME_BLOB;
    // If NULL or Callback returns TRUE, builds the chain for the end
    // certificate having a private key with the specified KeySpec and
    // enhanced key usage.
    pfnFindCallback: PFN_CERT_CHAIN_FIND_BY_ISSUER_CALLBACK;
    pvFindArg: pointer;
{$IFDEF CERT_CHAIN_FIND_BY_ISSUER_PARA_HAS_EXTRA_FIELDS}
    // Note, if you #define CERT_CHAIN_FIND_BY_ISSUER_PARA_HAS_EXTRA_FIELDS,
    // then, you must zero all unused fields in this data structure.
    // More fields could be added in a future release.

    // If the following pointers are nonNull, returns the index of the
    // matching issuer certificate, which is at:
    // pChainContext->
    //      rgpChain[*pdwIssuerChainIndex]->rgpElement[*pdwIssuerElementIndex].
    //
    // The issuer name blob is compared against the Issuer field in the
    // certificate. The *pdwIssuerElementIndex is set to the index of this
    // subject certificate + 1. Therefore, its possible for a partial chain or
    // a self signed certificate matching the name blob, where
    // *pdwIssuerElementIndex points past the last certificate in the chain.
    //
    // Note, not updated if the above cIssuer == 0.
    pdwIssuerChainIndex: PDWORD;
    pdwIssuerElementIndex: PDWORD;
{$ENDIF}
  end;
  PCERT_CHAIN_FIND_ISSUER_PARA = ^CERT_CHAIN_FIND_BY_ISSUER_PARA;

  // The following dwFindFlags can be set for CERT_CHAIN_FIND_BY_ISSUER

  // If set, compares the public key in the end certificate with the crypto
  // provider's public key. This comparison is the last check made on the
  // build chain.
const
  CERT_CHAIN_FIND_BY_ISSUER_COMPARE_KEY_FLAG    = $0001;

  // If not set, only checks the first simple chain for an issuer name match.
  // When set, also checks second and subsequent simple chains.
  CERT_CHAIN_FIND_BY_ISSUER_COMPLEX_CHAIN_FLAG  = $0002;

  // If set, CertGetCertificateChain only searches the URL cache and
  // doesn't hit the wire.
  CERT_CHAIN_FIND_BY_ISSUER_CACHE_ONLY_URL_FLAG = $0004;

  // If set, CertGetCertificateChain only opens the Local Machine
  // certificate stores instead of the Current User's.
  CERT_CHAIN_FIND_BY_ISSUER_LOCAL_MACHINE_FLAG  = $0008;

  // If set, no check is made to see if the end certificate has a private
  // key associated with it.
  CERT_CHAIN_FIND_BY_ISSUER_NO_KEY_FLAG         = $4000;

  // By default, the hCertStore passed to CertFindChainInStore, is passed
  // as the additional store to CertGetCertificateChain. This flag can be
  // set to improve performance by only searching the cached system stores
  // (root, my, ca, trust) to find the issuer certificates. If not set, then,
  // the hCertStore is always searched in addition to the cached system
  // stores.
  CERT_CHAIN_FIND_BY_ISSUER_CACHE_ONLY_FLAG     = $8000;

  //+=========================================================================
  //  Certificate Chain Policy Data Structures and APIs
  //==========================================================================
type
  CERT_CHAIN_POLICY_PARA = record
    cbSize:  DWORD;
    dwFlags: DWORD;
    pvExtraPolicyPara: pointer; // pszPolicyOID specific
  end;
  PCERT_CHAIN_POLICY_PARA = ^CERT_CHAIN_POLICY_PARA;

  // If both lChainIndex and lElementIndex are set to -1, the dwError applies
  // to the whole chain context. If only lElementIndex is set to -1, the
  // dwError applies to the lChainIndex'ed chain. Otherwise, the dwError applies
  // to the certificate element at
  // pChainContext->rgpChain[lChainIndex]->rgpElement[lElementIndex].
type
  CERT_CHAIN_POLICY_STATUS = record
    cbSize:              DWORD;
    dwError:             DWORD;
    lChainIndex:         longint;
    lElementIndex:       longint;
    pvExtraPolicyStatus: pointer; // pszPolicyOID specific
  end;
  PCERT_CHAIN_POLICY_STATUS = ^CERT_CHAIN_POLICY_STATUS;

  // Common chain policy flags
const
  CERT_CHAIN_POLICY_IGNORE_NOT_TIME_VALID_FLAG            = $00000001;
  CERT_CHAIN_POLICY_IGNORE_CTL_NOT_TIME_VALID_FLAG        = $00000002;
  CERT_CHAIN_POLICY_IGNORE_NOT_TIME_NESTED_FLAG           = $00000004;
  CERT_CHAIN_POLICY_IGNORE_INVALID_BASIC_CONSTRAINTS_FLAG = $00000008;

  CERT_CHAIN_POLICY_IGNORE_ALL_NOT_TIME_VALID_FLAGS =
    (CERT_CHAIN_POLICY_IGNORE_NOT_TIME_VALID_FLAG or
    CERT_CHAIN_POLICY_IGNORE_CTL_NOT_TIME_VALID_FLAG or
    CERT_CHAIN_POLICY_IGNORE_NOT_TIME_NESTED_FLAG);

  CERT_CHAIN_POLICY_ALLOW_UNKNOWN_CA_FLAG   = $00000010;
  CERT_CHAIN_POLICY_IGNORE_WRONG_USAGE_FLAG = $00000020;

  CERT_CHAIN_POLICY_IGNORE_END_REV_UNKNOWN_FLAG        = $00000100;
  CERT_CHAIN_POLICY_IGNORE_CTL_SIGNER_REV_UNKNOWN_FLAG = $00000200;
  CERT_CHAIN_POLICY_IGNORE_CA_REV_UNKNOWN_FLAG         = $00000400;
  CERT_CHAIN_POLICY_IGNORE_ROOT_REV_UNKNOWN_FLAG       = $00000800;
  CERT_CHAIN_POLICY_IGNORE_INVALID_NAME_FLAG           = $00000040;
  CERT_CHAIN_POLICY_IGNORE_INVALID_POLICY_FLAG         = $00000080;

  CERT_CHAIN_POLICY_IGNORE_ALL_REV_UNKNOWN_FLAGS =
    (CERT_CHAIN_POLICY_IGNORE_END_REV_UNKNOWN_FLAG or
    CERT_CHAIN_POLICY_IGNORE_CTL_SIGNER_REV_UNKNOWN_FLAG or
    CERT_CHAIN_POLICY_IGNORE_CA_REV_UNKNOWN_FLAG or
    CERT_CHAIN_POLICY_IGNORE_ROOT_REV_UNKNOWN_FLAG);

  CERT_CHAIN_POLICY_ALLOW_TESTROOT_FLAG = $00008000;
  CERT_CHAIN_POLICY_TRUST_TESTROOT_FLAG = $00004000;

  //+-------------------------------------------------------------------------
  //  Verify that the certificate chain satisfies the specified policy
  //  requirements. If we were able to verify the chain policy, TRUE is returned
  //  and the dwError field of the pPolicyStatus is updated. A dwError of 0
  //  (ERROR_SUCCESS, S_OK) indicates the chain satisfies the specified policy.
  //
  //  If dwError applies to the entire chain context, both lChainIndex and
  //  lElementIndex are set to -1. If dwError applies to a simple chain,
  //  lElementIndex is set to -1 and lChainIndex is set to the index of the
  //  first offending chain having the error. If dwError applies to a
  //  certificate element, lChainIndex and lElementIndex are updated to
  //  index the first offending certificate having the error, where, the
  //  the certificate element is at:
  //      pChainContext->rgpChain[lChainIndex]->rgpElement[lElementIndex].
  //
  //  The dwFlags in pPolicyPara can be set to change the default policy checking
  //  behaviour. In addition, policy specific parameters can be passed in
  //  the pvExtraPolicyPara field of pPolicyPara.
  //
  //  In addition to returning dwError, in pPolicyStatus, policy OID specific
  //  extra status may be returned via pvExtraPolicyStatus.
  //--------------------------------------------------------------------------
function CertVerifyCertificateChainPolicy(
  pszPolicyOID: LPCSTR;
  pChainContext: PCCERT_CHAIN_CONTEXT;
  pPolicyPara: PCERT_CHAIN_POLICY_PARA;
  pPolicyStatus: PCERT_CHAIN_POLICY_STATUS
  ): BOOL; stdcall;

// Predefined OID Function Names
const
  CRYPT_OID_VERIFY_CERTIFICATE_CHAIN_POLICY_FUNC =
    'CertDllVerifyCertificateChainPolicy';

  // CertDllVerifyCertificateChainPolicy has same function signature as
  // CertVerifyCertificateChainPolicy.

  //+-------------------------------------------------------------------------
  //  Predefined verify chain policies
  //--------------------------------------------------------------------------
  CERT_CHAIN_POLICY_BASE              = LPCSTR(1);
  CERT_CHAIN_POLICY_AUTHENTICODE      = LPCSTR(2);
  CERT_CHAIN_POLICY_AUTHENTICODE_TS   = LPCSTR(3);
  CERT_CHAIN_POLICY_SSL               = LPCSTR(4);
  CERT_CHAIN_POLICY_BASIC_CONSTRAINTS = LPCSTR(5);
  CERT_CHAIN_POLICY_NT_AUTH           = LPCSTR(6);
  CERT_CHAIN_POLICY_MICROSOFT_ROOT    = LPCSTR(7);

  //+-------------------------------------------------------------------------
  //  CERT_CHAIN_POLICY_BASE
  //
  //  Implements the base chain policy verification checks. dwFlags can
  //  be set in pPolicyPara to alter the default policy checking behaviour.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_CHAIN_POLICY_AUTHENTICODE
  //
  //  Implements the Authenticode chain policy verification checks.
  //
  //  pvExtraPolicyPara may optionally be set to point to the following
  //  AUTHENTICODE_EXTRA_CERT_CHAIN_POLICY_PARA.
  //
  //  pvExtraPolicyStatus may optionally be set to point to the following
  //  AUTHENTICODE_EXTRA_CERT_CHAIN_POLICY_STATUS.
  //--------------------------------------------------------------------------

  // dwRegPolicySettings are defined in wintrust.h
type
  AUTHENTICODE_EXTRA_CERT_CHAIN_POLICY_PARA = record
    cbSize:              DWORD;
    dwRegPolicySettings: DWORD;
    pSignerInfo:         PCMSG_SIGNER_INFO; // optional
  end;
  PAUTHENTICODE_EXTRA_CERT_CHAIN_POLICY_PARA =
    ^AUTHENTICODE_EXTRA_CERT_CHAIN_POLICY_PARA;

type
  AUTHENTICODE_EXTRA_CERT_CHAIN_POLICY_STATUS = record
    cbSize:      DWORD;
    fCommercial: BOOL; // obtained from signer statement
  end;
  PAUTHENTICODE_EXTRA_CERT_CHAIN_POLICY_STATUS =
    ^AUTHENTICODE_EXTRA_CERT_CHAIN_POLICY_STATUS;

  //+-------------------------------------------------------------------------
  //  CERT_CHAIN_POLICY_AUTHENTICODE_TS
  //
  //  Implements the Authenticode Time Stamp chain policy verification checks.
  //
  //  pvExtraPolicyPara may optionally be set to point to the following
  //  AUTHENTICODE_TS_EXTRA_CERT_CHAIN_POLICY_PARA.
  //
  //  pvExtraPolicyStatus isn't used and must be set to NULL.
  //--------------------------------------------------------------------------

  // dwRegPolicySettings are defined in wintrust.h
type
  AUTHENTICODE_TS_EXTRA_CERT_CHAIN_POLICY_PARA = record
    cbSize:              DWORD;
    dwRegPolicySettings: DWORD;
    fCommercial:         BOOL;
  end;
  PAUTHENTICODE_TS_EXTRA_CERT_CHAIN_POLICY_PARA =
    ^AUTHENTICODE_TS_EXTRA_CERT_CHAIN_POLICY_PARA;

  //+-------------------------------------------------------------------------
  //  CERT_CHAIN_POLICY_SSL
  //
  //  Implements the SSL client/server chain policy verification checks.
  //
  //  pvExtraPolicyPara may optionally be set to point to the following
  //  SSL_EXTRA_CERT_CHAIN_POLICY_PARA data structure
  //--------------------------------------------------------------------------

  // fdwChecks flags are defined in wininet.h
const
  AUTHTYPE_CLIENT = 1;
  AUTHTYPE_SERVER = 2;
type
  HTTPSPolicyCallbackData = record
    case integer of
      1:
      (cbStruct:         DWORD; // sizeof(HTTPSPolicyCallbackData);
        dwAuthType:      DWORD;
        fdwChecks:       DWORD;
        pwszServerName:  PWCHAR); // used to check against CN=xxxx
      2:
      (cbSize:           DWORD); // sizeof(HTTPSPolicyCallbackData);
  end;
  PHTTPSPolicyCallbackData = ^HTTPSPolicyCallbackData;
  SSL_EXTRA_CERT_CHAIN_POLICY_PARA = HTTPSPolicyCallbackData;
  PSSL_EXTRA_CERT_CHAIN_POLICY_PARA = ^SSL_EXTRA_CERT_CHAIN_POLICY_PARA;

  //+-------------------------------------------------------------------------
  //  CERT_CHAIN_POLICY_BASIC_CONSTRAINTS
  //
  //  Implements the basic constraints chain policy.
  //
  //  Iterates through all the certificates in the chain checking for either
  //  a szOID_BASIC_CONSTRAINTS or a szOID_BASIC_CONSTRAINTS2 extension. If
  //  neither extension is present, the certificate is assumed to have
  //  valid policy. Otherwise, for the first certificate element, checks if
  //  it matches the expected CA_FLAG or END_ENTITY_FLAG specified in
  //  pPolicyPara->dwFlags. If neither or both flags are set, then, the first
  //  element can be either a CA or END_ENTITY. All other elements must be
  //  a CA. If the PathLenConstraint is present in the extension, its
  //  checked.
  //
  //  The first elements in the remaining simple chains (ie, the certificate
  //  used to sign the CTL) are checked to be an END_ENTITY.
  //
  //  If this verification fails, dwError will be set to
  //  TRUST_E_BASIC_CONSTRAINTS.
  //--------------------------------------------------------------------------
const
  BASIC_CONSTRAINTS_CERT_CHAIN_POLICY_CA_FLAG         = $80000000;
  BASIC_CONSTRAINTS_CERT_CHAIN_POLICY_END_ENTITY_FLAG = $40000000;

  //+-------------------------------------------------------------------------
  //  CERT_CHAIN_POLICY_NT_AUTH
  //
  //  Implements the NT Authentication chain policy.
  //
  //  The NT Authentication chain policy consists of 3 distinct chain
  //  verifications in the following order:
  //      [1] CERT_CHAIN_POLICY_BASE - Implements the base chain policy
  //          verification checks. The LOWORD of dwFlags can be set in
  //          pPolicyPara to alter the default policy checking behaviour. See
  //          CERT_CHAIN_POLICY_BASE for more details.
  //
  //      [2] CERT_CHAIN_POLICY_BASIC_CONSTRAINTS - Implements the basic
  //          constraints chain policy. The HIWORD of dwFlags can be set
  //          to specify if the first element must be either a CA or END_ENTITY.
  //          See CERT_CHAIN_POLICY_BASIC_CONSTRAINTS for more details.
  //
  //      [3] Checks if the second element in the chain, the CA that issued
  //          the end certificate, is a trusted CA for NT
  //          Authentication. A CA is considered to be trusted if it exists in
  //          the "NTAuth" system registry store found in the
  //          CERT_SYSTEM_STORE_LOCAL_MACHINE_ENTERPRISE store location.
  //          If this verification fails, whereby the CA isn't trusted,n
  //          dwError is set to CERT_E_UNTRUSTEDCA.
  //
  //          If CERT_PROT_ROOT_DISABLE_NT_AUTH_REQUIRED_FLAG is set
  //          in the "Flags" value of the HKLM policy "ProtectedRoots" subkey
  //          defined by CERT_PROT_ROOT_FLAGS_REGPATH, then,
  //          if the above check fails, checks if the chain
  //          has CERT_TRUST_HAS_VALID_NAME_CONSTRAINTS set in dwInfoStatus. This
  //          will only be set if there was a valid name constraint for all
  //          name spaces including UPN. If the chain doesn't have this info
  //          status set, dwError is set to CERT_E_UNTRUSTEDCA.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  //  CERT_CHAIN_POLICY_MICROSOFT_ROOT
  //
  //  Checks if the last element of the first simple chain contains a
  //  Microsoft root public key. If it doesn't contain a Microsoft root
  //  public key, dwError is set to CERT_E_UNTRUSTEDROOT.
  //
  //  pvExtraPolicyPara and pvExtraPolicyStatus aren't used and must be set
  //  to NULL.
  //--------------------------------------------------------------------------

  //+-------------------------------------------------------------------------
  // convert formatted string to binary
  // If cchString is 0, then pszString is NULL terminated and
  // cchString is obtained via strlen() + 1.
  // dwFlags defines string format
  // if pbBinary is NULL, *pcbBinary returns the size of required memory
  // *pdwSkip returns the character count of skipped strings, optional
  // *pdwFlags returns the actual format used in the conversion, optional
  //--------------------------------------------------------------------------
function CryptStringToBinaryA(
  pszString: LPCSTR;
  cchString: DWORD;
  dwFlags: DWORD;
  pbBinary: PBYTE;
  var pcbBinary: DWORD;
  pdwSkip: PDWORD;    //OPTIONAL
  pdwFlags: PDWORD    //OPTIONAL
  ): BOOL; stdcall;
  //+-------------------------------------------------------------------------
  // convert formatted string to binary
  // If cchString is 0, then pszString is NULL terminated and
  // cchString is obtained via strlen() + 1.
  // dwFlags defines string format
  // if pbBinary is NULL, *pcbBinary returns the size of required memory
  // *pdwSkip returns the character count of skipped strings, optional
  // *pdwFlags returns the actual format used in the conversion, optional
  //--------------------------------------------------------------------------
function CryptStringToBinaryW(
  pszString: LPCWSTR;
  cchString: DWORD;
  dwFlags: DWORD;
  pbBinary: PBYTE;
  var pcbBinary: DWORD;
  pdwSkip: PDWORD;    //OPTIONAL
  pdwFlags: PDWORD    //OPTIONAL
  ): BOOL; stdcall;
{$IFDEF UNICODE}
function CryptStringToBinary(
  pszString: LPCWSTR;
  cchString: DWORD;
  dwFlags: DWORD;
  pbBinary: PBYTE;
  var pcbBinary: DWORD;
  pdwSkip: PDWORD;    //OPTIONAL
  pdwFlags: PDWORD    //OPTIONAL
  ): BOOL; stdcall;
{$ELSE}
function CryptStringToBinary(
  pszString: LPCSTR;
  cchString: DWORD;
  dwFlags: DWORD;
  pbBinary: PBYTE;
  var pcbBinary: DWORD;
  pdwSkip: PDWORD;    //OPTIONAL
  pdwFlags: PDWORD    //OPTIONAL
  ): BOOL; stdcall;
{$ENDIF} // !UNICODE

//+-------------------------------------------------------------------------
// convert binary to formatted string
// dwFlags defines string format
// if pszString is NULL, *pcchString returns the size of required memory in byte
//--------------------------------------------------------------------------
function CryptBinaryToStringA(
  pbBinary: PBYTE;
  cbBinary: DWORD;
  dwFlags: DWORD;
  pszString: LPSTR;
  var pcchString: DWORD
  ): BOOL; stdcall;
//+-------------------------------------------------------------------------
// convert binary to formatted string
// dwFlags defines string format
// if pszString is NULL, *pcchString returns the size of required memory in byte
//--------------------------------------------------------------------------
function CryptBinaryToStringW(
  pbBinary: PBYTE;
  cbBinary: DWORD;
  dwFlags: DWORD;
  pszString: LPWSTR;
  var pcchString: DWORD
  ): BOOL; stdcall;
{$IFDEF UNICODE}
function CryptBinaryToString(
  pbBinary: PBYTE;
  cbBinary: DWORD;
  dwFlags: DWORD;
  pszString: LPWSTR;
  var pcchString: DWORD
  ): BOOL; stdcall;
{$ELSE}
function CryptBinaryToString(
  pbBinary: PBYTE;
  cbBinary: DWORD;
  dwFlags: DWORD;
  pszString: LPSTR;
  var pcchString: DWORD
  ): BOOL; stdcall;
{$ENDIF} // !UNICODE

// dwFlags has the following defines
const
  CRYPT_STRING_BASE64HEADER          = $00000000;
  CRYPT_STRING_BASE64                = $00000001;
  CRYPT_STRING_BINARY                = $00000002;
  CRYPT_STRING_BASE64REQUESTHEADER   = $00000003;
  CRYPT_STRING_HEX                   = $00000004;
  CRYPT_STRING_HEXASCII              = $00000005;
  CRYPT_STRING_BASE64_ANY            = $00000006;
  CRYPT_STRING_ANY                   = $00000007;
  CRYPT_STRING_HEX_ANY               = $00000008;
  CRYPT_STRING_BASE64X509CRLHEADER   = $00000009;
  CRYPT_STRING_HEXADDR               = $0000000a;
  CRYPT_STRING_HEXASCIIADDR          = $0000000b;

  CRYPT_STRING_NOCR                  = $80000000;

// CryptBinaryToString uses the following flags
// CRYPT_STRING_BASE64HEADER - base64 format with certificate begin
//                             and end headers
// CRYPT_STRING_BASE64 - only base64 without headers
// CRYPT_STRING_BINARY - pure binary copy
// CRYPT_STRING_BASE64REQUESTHEADER - base64 format with request begin
//                                    and end headers
// CRYPT_STRING_BASE64X509CRLHEADER - base64 format with x509 crl begin
//                                    and end headers
// CRYPT_STRING_HEX - only hex format
// CRYPT_STRING_HEXASCII - hex format with ascii char display
// CRYPT_STRING_HEXADDR - hex format with address display
// CRYPT_STRING_HEXASCIIADDR - hex format with ascii char and address display
//
// CryptBinaryToString accepts CRYPT_STRING_NOCR or'd into one of the above.
// When set, line breaks contain only LF, instead of CR-LF pairs.

// CryptStringToBinary uses the following flags
// CRYPT_STRING_BASE64_ANY tries the following, in order:
//    CRYPT_STRING_BASE64HEADER
//    CRYPT_STRING_BASE64
// CRYPT_STRING_ANY tries the following, in order:
//    CRYPT_STRING_BASE64_ANY
//    CRYPT_STRING_BINARY -- should always succeed
// CRYPT_STRING_HEX_ANY tries the following, in order:
//    CRYPT_STRING_HEXADDR
//    CRYPT_STRING_HEXASCIIADDR
//    CRYPT_STRING_HEXASCII
//    CRYPT_STRING_HEX


//+=========================================================================
//  PFX (PKCS #12) function defintions and types
//==========================================================================


//+-------------------------------------------------------------------------
//      PFXImportCertStore
//
//  Import the PFX blob and return a store containing certificates
//
//  If the password parameter is incorrect or any other problems decoding
//  the PFX blob are encountered, the function will return NULL and the
//      error code can be found from GetLastError().
//
//  The dwFlags parameter may be set to the following:
//  CRYPT_EXPORTABLE - specify that any imported keys should be marked as
//                     exportable (see documentation on CryptImportKey)
//  CRYPT_USER_PROTECTED - (see documentation on CryptImportKey)
//  CRYPT_MACHINE_KEYSET - used to force the private key to be stored in the
//                        the local machine and not the current user.
//  CRYPT_USER_KEYSET - used to force the private key to be stored in the
//                      the current user and not the local machine, even if
//                      the pfx blob specifies that it should go into local
//                      machine.
//--------------------------------------------------------------------------
function PFXImportCertStore(
  var PFX: CRYPT_DATA_BLOB;
  szPassword: LPCWSTR;
  dwFlags: DWORD
  ): HCERTSTORE; stdcall;

// dwFlags definitions for PFXImportCertStore
//#define CRYPT_EXPORTABLE        0x00000001  // CryptImportKey dwFlags
//#define CRYPT_USER_PROTECTED    0x00000002  // CryptImportKey dwFlags
//#define CRYPT_MACHINE_KEYSET    0x00000020  // CryptAcquireContext dwFlags

const
  CRYPT_USER_KEYSET             = $00001000;

  PKCS12_IMPORT_RESERVED_MASK   = $ffff0000;

//+-------------------------------------------------------------------------
//      PFXIsPFXBlob
//
//  This function will try to decode the outer layer of the blob as a pfx
//  blob, and if that works it will return TRUE, it will return FALSE otherwise
//
//--------------------------------------------------------------------------
function PFXIsPFXBlob(
  var PFX: CRYPT_DATA_BLOB
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//      PFXVerifyPassword
//
//  This function will attempt to decode the outer layer of the blob as a pfx
//  blob and decrypt with the given password. No data from the blob will be
//  imported.
//
//  Return value is TRUE if password appears correct, FALSE otherwise.
//
//--------------------------------------------------------------------------
function PFXVerifyPassword(
  var PFX: CRYPT_DATA_BLOB;
  szPassword: LPCWSTR;
  dwFlags: DWORD
  ): BOOL; stdcall;

//+-------------------------------------------------------------------------
//      PFXExportCertStoreEx
//
//  Export the certificates and private keys referenced in the passed-in store
//
//  This API encodes the blob under a stronger algorithm. The resulting
//  PKCS12 blobs are incompatible with the earlier PFXExportCertStore API.
//
//  The value passed in the password parameter will be used to encrypt and
//  verify the integrity of the PFX packet. If any problems encoding the store
//  are encountered, the function will return FALSE and the error code can
//  be found from GetLastError().
//
//  The dwFlags parameter may be set to any combination of
//      EXPORT_PRIVATE_KEYS
//      REPORT_NO_PRIVATE_KEY
//      REPORT_NOT_ABLE_TO_EXPORT_PRIVATE_KEY
//
//  The encoded PFX blob is returned in *pPFX. If pPFX->pbData is NULL upon
//  input, this is a length only calculation, whereby, pPFX->cbData is updated
//  with the number of bytes required for the encoded blob. Otherwise,
//  the memory pointed to by pPFX->pbData is updated with the encoded bytes
//  and pPFX->cbData is updated with the encoded byte length.
//--------------------------------------------------------------------------
function PFXExportCertStoreEx(
  hStore: HCERTSTORE;
  var pPFX: CRYPT_DATA_BLOB;
  szPassword: LPCWSTR;
  pvReserved: pointer;
  dwFlags: DWORD
  ): BOOL; stdcall;

// dwFlags definitions for PFXExportCertStoreEx
const
  REPORT_NO_PRIVATE_KEY                  = $0001;
  REPORT_NOT_ABLE_TO_EXPORT_PRIVATE_KEY  = $0002;
  EXPORT_PRIVATE_KEYS                    = $0004;
  PKCS12_EXPORT_RESERVED_MASK            = $ffff0000;

//+-------------------------------------------------------------------------
//      PFXExportCertStore
//
//  Export the certificates and private keys referenced in the passed-in store
//
//  This is an old API kept for compatibility with IE4 clients. New applications
//  should call the above PfxExportCertStoreEx for enhanced security.
//--------------------------------------------------------------------------
function PFXExportCertStore(
  hStore: HCERTSTORE;
  var pPFX: CRYPT_DATA_BLOB;
  szPassword: LPCWSTR;
  dwFlags: DWORD
  ): BOOL; stdcall;

//--------------------------------------------------------------------------

implementation

function GET_ALG_CLASS(x: DWORD): DWORD;
begin
  Result:= x and (7 shl 13);
end;

function GET_ALG_TYPE(x: DWORD): DWORD;
begin
  Result:= x and (15 shl 9);
end;

function GET_ALG_SID(x: DWORD): DWORD;
begin
  Result:= x and 511;
end;

function RCRYPT_SUCCEEDED(rt: BOOL): boolean;
begin
  Result:= rt = CRYPT_SUCCEED;
end;

function RCRYPT_FAILED(rt: BOOL): boolean;
begin
  Result:= rt = CRYPT_FAILED;
end;

function IS_CERT_RDN_CHAR_STRING(X: DWORD): boolean;
begin
  Result:= (X and CERT_RDN_TYPE_MASK) >= CERT_RDN_NUMERIC_STRING;
end;

function GET_CERT_ENCODING_TYPE(X: DWORD): DWORD;
begin
  Result:= X and CERT_ENCODING_TYPE_MASK;
end;

function GET_CMSG_ENCODING_TYPE(X: DWORD): DWORD;
begin
  Result:= X and CMSG_ENCODING_TYPE_MASK;
end;

function GET_CERT_UNICODE_RDN_ERR_INDEX(X: DWORD): DWORD;
begin
  Result:= (X shr CERT_UNICODE_RDN_ERR_INDEX_SHIFT) and
    CERT_UNICODE_RDN_ERR_INDEX_MASK;
end;

function GET_CERT_UNICODE_ATTR_ERR_INDEX(X: DWORD): DWORD;
begin
  Result:= (X shr CERT_UNICODE_ATTR_ERR_INDEX_SHIFT) and
    CERT_UNICODE_ATTR_ERR_INDEX_MASK;
end;

function GET_CERT_UNICODE_VALUE_ERR_INDEX(X: DWORD): DWORD;
begin
  Result:= X and CERT_UNICODE_VALUE_ERR_INDEX_MASK;
end;

function GET_CERT_ALT_NAME_ENTRY_ERR_INDEX(X: DWORD): DWORD;
begin
  Result:= (X shr CERT_ALT_NAME_ENTRY_ERR_INDEX_SHIFT) and
    CERT_ALT_NAME_ENTRY_ERR_INDEX_MASK;
end;

function GET_CERT_ALT_NAME_VALUE_ERR_INDEX(X: DWORD): DWORD;
begin
  Result:= X and CERT_ALT_NAME_VALUE_ERR_INDEX_MASK;
end;

function GET_CRL_DIST_POINT_ERR_INDEX(X: DWORD): DWORD;
begin
  Result:= (X shr CRL_DIST_POINT_ERR_INDEX_SHIFT)
    and CRL_DIST_POINT_ERR_INDEX_MASK;
end;

function IS_CRL_DIST_POINT_ERR_CRL_ISSUER(X: DWORD): boolean;
begin
  Result:= 0 <> (X and CRL_DIST_POINT_ERR_CRL_ISSUER_BIT);
end;

function IS_CERT_HASH_PROP_ID(X: DWORD): boolean;
begin
  Result:= (CERT_SHA1_HASH_PROP_ID = X) or
           (CERT_MD5_HASH_PROP_ID = X) or
           (CERT_SIGNATURE_HASH_PROP_ID = X);
end;

function GET_CROSS_CERT_DIST_POINT_ERR_INDEX(X: DWORD): DWORD;
begin
  Result:= (X shr CROSS_CERT_DIST_POINT_ERR_INDEX_SHIFT)
    and CROSS_CERT_DIST_POINT_ERR_INDEX_MASK;
end;

function IS_CERT_EXCLUDED_SUBTREE(X: DWORD): boolean;
begin
  Result:= 0 <> (X and CERT_EXCLUDED_SUBTREE_BIT);
end;

function IS_PUBKEY_HASH_PROP_ID(X: DWORD): boolean;
begin
  Result:= (CERT_ISSUER_PUBLIC_KEY_MD5_HASH_PROP_ID = X) or
           (CERT_SUBJECT_PUBLIC_KEY_MD5_HASH_PROP_ID = X);
end;

function IS_CHAIN_HASH_PROP_ID(X: DWORD): boolean;
begin
  Result:= (CERT_ISSUER_PUBLIC_KEY_MD5_HASH_PROP_ID = X) or
           (CERT_SUBJECT_PUBLIC_KEY_MD5_HASH_PROP_ID = X) or
           (CERT_ISSUER_SERIAL_NUMBER_MD5_HASH_PROP_ID = X) or
           (CERT_SUBJECT_NAME_MD5_HASH_PROP_ID = X);
end;

const
  ADVAPI32 = 'advapi32.dll';
  CRYPT32  = 'crypt32.dll';
  SOFTPUB  = 'softpub.dll';

function CryptAcquireContextA; external ADVAPI32;
function CryptAcquireContextW; external ADVAPI32;
{$IFDEF UNICODE}
function CryptAcquireContext; external ADVAPI32 name 'CryptAcquireContextW';
{$ELSE}
function CryptAcquireContext; external ADVAPI32 name 'CryptAcquireContextA';
{$ENDIF} // !UNICODE
function CryptReleaseContext; external ADVAPI32;
function CryptGenKey; external ADVAPI32;
function CryptDeriveKey; external ADVAPI32;
function CryptDestroyKey; external ADVAPI32;
function CryptSetKeyParam; external ADVAPI32;
function CryptGetKeyParam; external ADVAPI32;
function CryptSetHashParam; external ADVAPI32;
function CryptGetHashParam; external ADVAPI32;
function CryptSetProvParam; external ADVAPI32;
function CryptGetProvParam; external ADVAPI32;
function CryptGenRandom; external ADVAPI32;
function CryptGetUserKey; external ADVAPI32;
function CryptExportKey; external ADVAPI32;
function CryptImportKey; external ADVAPI32;
function CryptEncrypt; external ADVAPI32;
function CryptDecrypt; external ADVAPI32;
function CryptCreateHash; external ADVAPI32;
function CryptHashData; external ADVAPI32;
function CryptHashSessionKey; external ADVAPI32;
function CryptDestroyHash; external ADVAPI32;
function CryptSignHashA; external ADVAPI32;
function CryptSignHashW; external ADVAPI32;
{$IFDEF UNICODE}
function CryptSignHash; external ADVAPI32 name 'CryptSignHashW';
{$ELSE}
function CryptSignHash; external ADVAPI32 name 'CryptSignHashA';
{$ENDIF} // !UNICODE
function CryptVerifySignatureA; external ADVAPI32;
function CryptVerifySignatureW; external ADVAPI32;
{$IFDEF UNICODE}
function CryptVerifySignature; external ADVAPI32 name 'CryptVerifySignatureW';
{$ELSE}
function CryptVerifySignature; external ADVAPI32 name 'CryptVerifySignatureA';
{$ENDIF} // !UNICODE
function CryptSetProviderA; external ADVAPI32;
function CryptSetProviderW; external ADVAPI32;
{$IFDEF UNICODE}
function CryptSetProvider; external ADVAPI32 name 'CryptSetProviderW';
{$ELSE}
function CryptSetProvider; external ADVAPI32 name 'CryptSetProviderA';
{$ENDIF} // !UNICODE
function CryptSetProviderExA; external ADVAPI32;
function CryptSetProviderExW; external ADVAPI32;
{$IFDEF UNICODE}
function CryptSetProviderEx; external ADVAPI32 name 'CryptSetProviderExW';
{$ELSE}
function CryptSetProviderEx; external ADVAPI32 name 'CryptSetProviderExA';
{$ENDIF} // !UNICODE
function CryptGetDefaultProviderA; external ADVAPI32;
function CryptGetDefaultProviderW; external ADVAPI32;
{$IFDEF UNICODE}
function CryptGetDefaultProvider; external ADVAPI32 name
  'CryptGetDefaultProviderW';
{$ELSE}
function CryptGetDefaultProvider; external ADVAPI32 name
  'CryptGetDefaultProviderA';
{$ENDIF} // !UNICODE
function CryptEnumProviderTypesA; external ADVAPI32;
function CryptEnumProviderTypesW; external ADVAPI32;
{$IFDEF UNICODE}
function CryptEnumProviderTypes; external ADVAPI32 name
  'CryptEnumProviderTypesW';
{$ELSE}
function CryptEnumProviderTypes; external ADVAPI32 name
  'CryptEnumProviderTypesA';
{$ENDIF} // !UNICODE
function CryptEnumProvidersA; external ADVAPI32;
function CryptEnumProvidersW; external ADVAPI32;
{$IFDEF UNICODE}
function CryptEnumProviders; external ADVAPI32 name 'CryptEnumProvidersW';
{$ELSE}
function CryptEnumProviders; external ADVAPI32 name 'CryptEnumProvidersA';
{$ENDIF} // !UNICODE
function CryptContextAddRef; external ADVAPI32;
function CryptDuplicateKey; external ADVAPI32;
function CryptDuplicateHash; external ADVAPI32;
function CryptGetLocalKeyLimits; external ADVAPI32;

function CryptFormatObject; external CRYPT32;
function CryptEncodeObjectEx; external CRYPT32;
function CryptEncodeObject; external CRYPT32;
function CryptDecodeObjectEx; external CRYPT32;
function CryptDecodeObject; external CRYPT32;
function CryptInstallOIDFunctionAddress; external CRYPT32;
function CryptInitOIDFunctionSet; external CRYPT32;
function CryptGetOIDFunctionAddress; external CRYPT32;
function CryptGetDefaultOIDDllList; external CRYPT32;
function CryptGetDefaultOIDFunctionAddress; external CRYPT32;
function CryptFreeOIDFunctionAddress; external CRYPT32;
function CryptRegisterOIDFunction; external CRYPT32;
function CryptUnregisterOIDFunction; external CRYPT32;
function CryptRegisterDefaultOIDFunction; external CRYPT32;
function CryptUnregisterDefaultOIDFunction; external CRYPT32;
function CryptSetOIDFunctionValue; external CRYPT32;
function CryptGetOIDFunctionValue; external CRYPT32;
function CryptEnumOIDFunction; external CRYPT32;
function CryptFindOIDInfo; external CRYPT32;
function CryptRegisterOIDInfo; external CRYPT32;
function CryptUnregisterOIDInfo; external CRYPT32;
function CryptEnumOIDInfo; external CRYPT32;
function CryptFindLocalizedName; external CRYPT32;
function CryptMsgOpenToEncode; external CRYPT32;
function CryptMsgCalculateEncodedLength; external CRYPT32;
function CryptMsgOpenToDecode; external CRYPT32;
function CryptMsgDuplicate; external CRYPT32;
function CryptMsgClose; external CRYPT32;
function CryptMsgUpdate; external CRYPT32;
function CryptMsgGetParam; external CRYPT32;
function CryptMsgControl; external CRYPT32;
function CryptMsgVerifyCountersignatureEncoded; external CRYPT32;
function CryptMsgVerifyCountersignatureEncodedEx; external CRYPT32;
function CryptMsgCountersign; external CRYPT32;
function CryptMsgCountersignEncoded; external CRYPT32;
function CertOpenStore; external CRYPT32;
function CertDuplicateStore; external CRYPT32;
function CertSaveStore; external CRYPT32;
function CertCloseStore; external CRYPT32;
function CertGetSubjectCertificateFromStore; external CRYPT32;
function CertEnumCertificatesInStore; external CRYPT32;
function CertFindCertificateInStore; external CRYPT32;
function CertGetIssuerCertificateFromStore; external CRYPT32;
function CertVerifySubjectCertificateContext; external CRYPT32;
function CertDuplicateCertificateContext; external CRYPT32;
function CertCreateCertificateContext; external CRYPT32;
function CertFreeCertificateContext; external CRYPT32;
function CertSetCertificateContextProperty; external CRYPT32;
function CertGetCertificateContextProperty; external CRYPT32;
function CertEnumCertificateContextProperties; external CRYPT32;
function CertGetCRLFromStore; external CRYPT32;
function CertEnumCRLsInStore; external CRYPT32;
function CertFindCRLInStore; external CRYPT32;
function CertDuplicateCRLContext; external CRYPT32;
function CertCreateCRLContext; external CRYPT32;
function CertFreeCRLContext; external CRYPT32;
function CertSetCRLContextProperty; external CRYPT32;
function CertGetCRLContextProperty; external CRYPT32;
function CertEnumCRLContextProperties; external CRYPT32;
function CertFindCertificateInCRL; external CRYPT32;
function CertAddEncodedCertificateToStore; external CRYPT32;
function CertAddCertificateContextToStore; external CRYPT32;
function CertAddSerializedElementToStore; external CRYPT32;
function CertDeleteCertificateFromStore; external CRYPT32;
function CertAddEncodedCRLToStore; external CRYPT32;
function CertAddCRLContextToStore; external CRYPT32;
function CertDeleteCRLFromStore; external CRYPT32;
function CertSerializeCertificateStoreElement; external CRYPT32;
function CertSerializeCRLStoreElement; external CRYPT32;
function CertDuplicateCTLContext; external CRYPT32;
function CertCreateCTLContext; external CRYPT32;
function CertFreeCTLContext; external CRYPT32;
function CertSetCTLContextProperty; external CRYPT32;
function CertGetCTLContextProperty; external CRYPT32;
function CertEnumCTLContextProperties; external CRYPT32;
function CertEnumCTLsInStore; external CRYPT32;
function CertFindSubjectInCTL; external CRYPT32;
function CertFindCTLInStore; external CRYPT32;
function CertAddEncodedCTLToStore; external CRYPT32;
function CertAddCTLContextToStore; external CRYPT32;
function CertSerializeCTLStoreElement; external CRYPT32;
function CertDeleteCTLFromStore; external CRYPT32;
function CertAddCertificateLinkToStore; external CRYPT32;
function CertAddCRLLinkToStore; external CRYPT32;
function CertAddCTLLinkToStore; external CRYPT32;
function CertAddStoreToCollection; external CRYPT32;
procedure CertRemoveStoreFromCollection; external CRYPT32;
function CertControlStore; external CRYPT32;
function CertSetStoreProperty; external CRYPT32;
function CertGetStoreProperty; external CRYPT32;
function CertCreateContext; external CRYPT32;
function CertRegisterSystemStore; external CRYPT32;
function CertRegisterPhysicalStore; external CRYPT32;
function CertUnregisterSystemStore; external CRYPT32;
function CertUnregisterPhysicalStore; external CRYPT32;
function CertEnumSystemStoreLocation; external CRYPT32;
function CertEnumSystemStore; external CRYPT32;
function CertEnumPhysicalStore; external CRYPT32;
function CertGetEnhancedKeyUsage; external CRYPT32;
function CertSetEnhancedKeyUsage; external CRYPT32;
function CertAddEnhancedKeyUsageIdentifier; external CRYPT32;
function CertRemoveEnhancedKeyUsageIdentifier; external CRYPT32;
function CertGetValidUsages; external CRYPT32;

function CryptMsgGetAndVerifySigner; external CRYPT32;
function CryptMsgSignCTL; external CRYPT32;
function CryptMsgEncodeAndSignCTL; external CRYPT32;
function CertFindSubjectInSortedCTL; external CRYPT32;
function CertEnumSubjectInSortedCTL; external CRYPT32;
function CertVerifyCTLUsage; external CRYPT32;
function CertVerifyRevocation; external CRYPT32;
function CertCompareIntegerBlob; external CRYPT32;
function CertCompareCertificate; external CRYPT32;
function CertCompareCertificateName; external CRYPT32;
function CertIsRDNAttrsInCertificateName; external CRYPT32;
function CertComparePublicKeyInfo; external CRYPT32;
function CertGetPublicKeyLength; external CRYPT32;
function CryptVerifyCertificateSignature; external CRYPT32;
function CryptVerifyCertificateSignatureEx; external CRYPT32;
function CryptHashToBeSigned; external CRYPT32;
function CryptHashCertificate; external CRYPT32;
function CryptSignCertificate; external CRYPT32;
function CryptSignAndEncodeCertificate; external CRYPT32;
function CertVerifyTimeValidity; external CRYPT32;
function CertVerifyCRLTimeValidity; external CRYPT32;
function CertVerifyValidityNesting; external CRYPT32;
function CertVerifyCRLRevocation; external CRYPT32;
function CertAlgIdToOID; external CRYPT32;
function CertOIDToAlgId; external CRYPT32;
function CertFindExtension; external CRYPT32;
function CertFindAttribute; external CRYPT32;
function CertFindRDNAttr; external CRYPT32;
function CertGetIntendedKeyUsage; external CRYPT32;
function CryptInstallDefaultContext; external CRYPT32;
function CryptUninstallDefaultContext; external CRYPT32;
function CryptExportPublicKeyInfo; external CRYPT32;
function CryptExportPublicKeyInfoEx; external CRYPT32;
function CryptImportPublicKeyInfo; external CRYPT32;
function CryptImportPublicKeyInfoEx; external CRYPT32;
function CryptAcquireCertificatePrivateKey; external CRYPT32;
function CryptFindCertificateKeyProvInfo; external CRYPT32;
function CryptImportPKCS8; external CRYPT32;
function CryptExportPKCS8; external CRYPT32;
function CryptExportPKCS8Ex; external CRYPT32;
function CryptHashPublicKeyInfo; external CRYPT32;
function CertRDNValueToStrA; external CRYPT32;
function CertRDNValueToStrW; external CRYPT32;
{$IFDEF UNICODE}
function CertRDNValueToStr; external CRYPT32 name 'CertRDNValueToStrW';
{$ELSE}
function CertRDNValueToStr; external CRYPT32 name 'CertRDNValueToStrA';
{$ENDIF} // !UNICODE
function CertNameToStrA; external CRYPT32;
function CertNameToStrW; external CRYPT32;
{$IFDEF UNICODE}
function CertNameToStr; external CRYPT32 name 'CertNameToStrW';
{$ELSE}
function CertNameToStr; external CRYPT32 name 'CertNameToStrA';
{$ENDIF} // !UNICODE
function CertStrToNameA; external CRYPT32;
function CertStrToNameW; external CRYPT32;
{$IFDEF UNICODE}
function CertStrToName; external CRYPT32 name 'CertStrToNameW';
{$ELSE}
function CertStrToName; external CRYPT32 name 'CertStrToNameA';
{$ENDIF} // !UNICODE
function CertGetNameStringA; external CRYPT32;
function CertGetNameStringW; external CRYPT32;
{$IFDEF UNICODE}
function CertGetNameString; external CRYPT32 name 'CertGetNameStringW';
{$ELSE}
function CertGetNameString; external CRYPT32 name 'CertGetNameStringA';
{$ENDIF} // !UNICODE
function CryptSignMessage; external CRYPT32;
function CryptVerifyMessageSignature; external CRYPT32;
function CryptGetMessageSignerCount; external CRYPT32;
function CryptGetMessageCertificates; external CRYPT32;
function CryptVerifyDetachedMessageSignature; external CRYPT32;
function CryptEncryptMessage; external CRYPT32;
function CryptDecryptMessage; external CRYPT32;
function CryptSignAndEncryptMessage; external CRYPT32;
function CryptDecryptAndVerifyMessageSignature; external CRYPT32;
function CryptDecodeMessage; external CRYPT32;
function CryptHashMessage; external CRYPT32;
function CryptVerifyMessageHash; external CRYPT32;
function CryptVerifyDetachedMessageHash; external CRYPT32;
function CryptSignMessageWithKey; external CRYPT32;
function CryptVerifyMessageSignatureWithKey; external CRYPT32;
function CertOpenSystemStoreA; external CRYPT32;
function CertOpenSystemStoreW; external CRYPT32;
{$IFDEF UNICODE}
function CertOpenSystemStore; external CRYPT32 name 'CertOpenSystemStoreW';
{$ELSE}
function CertOpenSystemStore; external CRYPT32 name 'CertOpenSystemStoreA';
{$ENDIF} // !UNICODE
function CertAddEncodedCertificateToSystemStoreA; external CRYPT32;
function CertAddEncodedCertificateToSystemStoreW; external CRYPT32;
{$IFDEF UNICODE}
function CertAddEncodedCertificateToSystemStore; external CRYPT32 name
  'CertAddEncodedCertificateToSystemStoreW';
{$ELSE}
function CertAddEncodedCertificateToSystemStore; external CRYPT32 name
  'CertAddEncodedCertificateToSystemStoreA';
{$ENDIF} // !UNICODE
function FindCertsByIssuer; external SOFTPUB;
function CryptQueryObject; external CRYPT32;
function CryptMemAlloc; external CRYPT32;
function CryptMemRealloc; external CRYPT32;
procedure CryptMemFree; external CRYPT32;
function CryptCreateAsyncHandle; external CRYPT32;
function CryptSetAsyncParam; external CRYPT32;
function CryptGetAsyncParam; external CRYPT32;
function CryptCloseAsyncHandle; external CRYPT32;
function CryptRetrieveObjectByUrlA; external CRYPT32;
function CryptRetrieveObjectByUrlW; external CRYPT32;
{$IFDEF UNICODE}
function CryptRetrieveObjectByUrl; external CRYPT32 name
  'CryptRetrieveObjectByUrlW';
{$ELSE}
function CryptRetrieveObjectByUrl; external CRYPT32 name
  'CryptRetrieveObjectByUrlA';
{$ENDIF} // !UNICODE
function CryptInstallCancelRetrieval; external CRYPT32;
function CryptUninstallCancelRetrieval; external CRYPT32;
function CryptCancelAsyncRetrieval; external CRYPT32;
function CryptGetObjectUrl; external CRYPT32;
function CryptGetTimeValidObject; external CRYPT32;
function CryptFlushTimeValidObject; external CRYPT32;
function CryptProtectData; external CRYPT32;
function CryptUnprotectData; external CRYPT32;
function CertCreateSelfSignCertificate; external CRYPT32;
function CryptGetKeyIdentifierProperty; external CRYPT32;
function CryptSetKeyIdentifierProperty; external CRYPT32;
function CryptEnumKeyIdentifierProperties; external CRYPT32;
function CryptCreateKeyIdentifierFromCSP; external CRYPT32;
function CertCreateCertificateChainEngine; external CRYPT32;
procedure CertFreeCertificateChainEngine; external CRYPT32;
function CertResyncCertificateChainEngine; external CRYPT32;
function CertGetCertificateChain; external CRYPT32;
procedure CertFreeCertificateChain; external CRYPT32;
function CertDuplicateCertificateChain; external CRYPT32;
function CertFindChainInStore; external CRYPT32;
function CertVerifyCertificateChainPolicy; external CRYPT32;
function CertCreateCTLEntryFromCertificateContextProperties; external CRYPT32;
function CertSetCertificateContextPropertiesFromCTLEntry; external CRYPT32;
function CertIsValidCRLForCertificate; external CRYPT32;
function CryptStringToBinaryA; external CRYPT32;
function CryptStringToBinaryW; external CRYPT32;
{$IFDEF UNICODE}
function CryptStringToBinary; external CRYPT32 name 'CryptStringToBinaryW';
{$ELSE}
function CryptStringToBinary; external CRYPT32 name 'CryptStringToBinaryA';
{$ENDIF} // !UNICODE
function CryptBinaryToStringA; external CRYPT32;
function CryptBinaryToStringW; external CRYPT32;
{$IFDEF UNICODE}
function CryptBinaryToString; external CRYPT32 name 'CryptBinaryToStringW';
{$ELSE}
function CryptBinaryToString; external CRYPT32 name 'CryptBinaryToStringA';
{$ENDIF} // !UNICODE
function PFXImportCertStore; external CRYPT32;
function PFXIsPFXBlob; external CRYPT32;
function PFXVerifyPassword; external CRYPT32;
function PFXExportCertStore; external CRYPT32;
function PFXExportCertStoreEx; external CRYPT32;

end.

