{******************************************************************************}
{**                                                                          **}
{**  Compiler options and derectives for AntComp componets set.              **}
{**                                                                          **}
{**  Author:    KARPOLAN                                                     **}
{**  E-Mail:    karpolan@yahoo.com , karpolan@utilmind.com                   **}
{**  Home Page: http://karpolan.i.am, http://www.utilmind.com                **}
{**  Copyright © 1996-99 by KARPOLAN.                                        **}
{**                                                                          **}
{******************************************************************************}
{**  History:                                                                **}
{**                                                                          **}
{**  31 aug 1999 - Last modified... Prepared for public release.             **}
{******************************************************************************}

{*******************************************************************************
  This is determination of Delphi/CBC version.
*******************************************************************************}
{$IfDef VER80}  {$Define Delphi2andLower} {$EndIf}
{$IfDef VER90}  {$Define Delphi2andLower} {$EndIf}
{$IfDef VER93}  {$Define Delphi2andLower} {$EndIf}

{$IfDef VER100}  {$Define Delphi3} {$EndIf}
{$IfDef VER110}  {$Define Delphi3} {$EndIf}

{$IfNdef Delphi2andLower}
  {$Define Delphi3andHigher}

  {$IfNDef Delphi3}
    {$Define Delphi4andHigher}
  {$EndIf Delphi3}
{$EndIf}

{*******************************************************************************
  DEDUG turn on/off some Debug messages and additional routines
*******************************************************************************}
// {$Define DEBUG}

