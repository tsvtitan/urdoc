{$B-} {- Complete Boolean Evaluation }
{$R-} {- Range-Checking }
{$V-} {- Var-String Checking }
{$T-} {- Typed @ operator }
{$X+} {- Extended syntax }
{$P+} {- Open string params }


{$IFDEF VER93}  { Borland C++Builder 1.0 }
  {$DEFINE CBUILDER}
{$ENDIF}

{$IFDEF VER100} {Borland Delphi 3.0 }
  {$DEFINE YU_D3}
{$ENDIF}

{$IFDEF VER110} { Borland C++Builder 3.0 }
  {$DEFINE CBUILDER}
  {$ObjExportAll On}
{$ENDIF}

{$IFDEF VER120} {Borland Delphi 4.0 }
  {$DEFINE YU_D3}
  {$DEFINE YU_D4}
{$ENDIF}

{$IFNDEF VER80}           { Delphi 1.0     }
 {$IFNDEF VER90}          { Delphi 2.0     }
  {$IFNDEF VER93}         { C++Builder 1.0 }
    {$DEFINE YU_D3}       { Delphi 3.0 or higher }
    {$IFNDEF VER100}
      {$DEFINE YU_V110}   { C++Builder 3.0 or higher }
      {$IFNDEF VER110}
        {$DEFINE YU_D4}   { Delphi 4.0 or higher }
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
 {$ENDIF}
{$ENDIF}


