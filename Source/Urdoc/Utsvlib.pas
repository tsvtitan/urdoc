unit Utsvlib;

interface

uses SysUtils, dialogs, UUnited, Controls;

function QuantityTextFromExtended(Value: Extended; TypeTranslate: TTypeTranslate): String;

implementation

const
  ValueNames_Count=2;
  ValueNames: array [0..ValueNames_Count-1] of string =
  ('одна','две');
  ValueNamesMoney: array [0..ValueNames_Count-1] of string =
  ('один','два');

  ValueNamesIn20_Count=20;
  ValueNamesIn20: array [0..ValueNamesIn20_Count-1] of string =
              ('ноль',
               'один',
               'два',
               'три',
               'четыре',
               'пять',
               'шесть',
               'семь',
               'восемь',
               'девять',
               'десять',
               'одиннадцать',
               'двенадцать',
               'тринадцать',
               'четырнадцать',
               'пятнадцать',
               'шестнадцать',
               'семнадцать',
               'восемнадцать',
               'девятнадцать');

 ValueNamesIn100_Count=8;
 ValueNamesIn100: array [0..ValueNamesIn100_Count-1] of string =
 ('двадцать',
  'тридцать',
  'сорок',
  'пятьдесят',
  'шестьдесят',
  'семьдесят',
  'восемьдесят',
  'девяносто');
 ValueNamesIn1000_Count=9;
 ValueNamesIn1000: array [0..ValueNamesIn1000_Count-1] of string =
 ('сто',
  'двести',
  'триста',
  'четыреста',
  'пятьсот',
  'шестьсот',
  'семьсот',
  'восемьсот',
  'девятьсот');
 ValueNamesIn1e9_count=8;
 ValueNamesIn1e9: array [0..ValueNamesIn1e9_count-1] of string =
 ('тысяча','тысячи',
  'тысяч',
  'миллион','миллиона',
  'миллионов',
  'миллиард',
  'миллиардов');
 ValueSeparator_Count=6;
 ValueSeparator: array [0..ValueSeparator_Count-1] of string =
 ('десятая',
  'десятые',
  'десятых',
  'сотая',
  'сотые',
  'сотых');

 Separator1='целых';
 Separator2='целая';
 prefix=' ';

function QuantityTextFromExtended(Value: Extended; TypeTranslate: TTypeTranslate): String;

  function IsPresentSeparator(InValue: string): Boolean;
  var
   APos: Integer;
  begin
    result:=false;
    APos:=Pos(DecimalSeparator,InValue);
    if APos=0 then exit;
    Result:=true;
  end;
  
  function GetStringIn20(InValue: string): string;
  var
    APos: Integer;
    ch: char;
    addstr: string;
    tmps: string;
  begin
   if not IsPresentSeparator(InValue) then begin
    result:=ValueNamesIn20[strtoint(InValue)];
   end else begin
    APos:=Pos(DecimalSeparator,InValue);
    ch:=Copy(InValue,APos-1,1)[1];
    tmps:=Copy(InValue,1,APos-1);
    if strtofloat(InValue)<11 then begin
     case strtoint(ch) of
      1: begin
       case TypeTranslate of
         ttNormal: addstr:=ValueNames[0];
         ttMoney: addstr:=ValueNamesMoney[0];
         ttMoneyLongShort: addstr:=ValueNamesMoney[0];
       end;
      end;
      2: begin
       case TypeTranslate of
         ttNormal: addstr:=ValueNames[1];
         ttMoney: addstr:=ValueNamesMoney[1];
         ttMoneyLongShort: addstr:=ValueNamesMoney[1];
       end;
      end;
      else begin
       addstr:=ValueNamesIn20[strtoint(tmps)];
      end;
     end;
     end else begin
      addstr:=ValueNamesIn20[strtoint(tmps)];
     end;
    Result:=addstr;
   end;
  end;

  function GetStringIn100Ex(InValue: string): string;
  var
    firstChar: Char;
    lastChar: char;
    tmps: string;
    addstr: string;
  begin
    firstChar:=InValue[1];
    lastChar:=InValue[2];
    case strtoint(LastChar)of
      1,2: addstr:=ValueNames[strtoint(LastChar)-1];
      else begin
        addstr:=ValueNamesIn20[strtoint(lastChar)];
      end;
    end;
    if firstchar='0' then begin
     if lastchar<>'0' then
      tmps:=addstr;
    end else begin
      if strtofloat(Invalue)<=19.99 then begin
       tmps:=ValueNamesIn20[round(strtofloat(InValue))];
       if InValue='1' then begin
        case TypeTranslate of
          ttNormal: tmps:=ValueNames[0];
          ttMoney: tmps:=ValueNamesMoney[0];
          ttMoneyLongShort: addstr:=ValueNamesMoney[0];
        end;
       end;
       if InValue='2' then begin
        case TypeTranslate of
          ttNormal: tmps:=ValueNames[1];
          ttMoney: tmps:=ValueNamesMoney[1];
          ttMoneyLongShort: addstr:=ValueNamesMoney[1];
        end;
       end;
      end else begin
       if LastChar<>'0' then
        tmps:=ValueNamesIn100[strtoint(firstChar)-2]+prefix+addstr
       else tmps:=ValueNamesIn100[strtoint(firstChar)-2];
      end;
    end;
    result:=trim(tmps);
  end;

  function GetStringIn100(InValue: string): string;
  var
    firstChar: Char;
    lastChar: char;
    tmps: string;
    addstr: string;
  begin
    firstChar:=InValue[1];
    lastChar:=InValue[2];
    if firstchar='0' then begin
     if lastchar<>'0' then
      if not IsPresentSeparator(InValue) then begin
       tmps:=ValueNamesIn20[strtoint(lastChar)];
      end else begin
       if strtofloat(Invalue)<11 then begin
        case strtoint(lastChar) of
          1: begin
            case TypeTranslate of
              ttNormal: addstr:=ValueNames[0];
              ttMoney: addstr:=ValueNamesMoney[0];
              ttMoneyLongShort: addstr:=ValueNamesMoney[0];
            end;
          end;
          2: begin
            case TypeTranslate of
              ttNormal: addstr:=ValueNames[1];
              ttMoney: addstr:=ValueNamesMoney[1];
              ttMoneyLongShort: addstr:=ValueNamesMoney[1];
            end;
          end;
          else begin
           addstr:=ValueNamesIn20[strtoint(lastChar)];
          end;
        end;
       end else begin
         addstr:=ValueNamesIn20[strtoint(lastChar)];;
       end;
        tmps:=addstr;
      end;
    end else begin
      if strtofloat(Invalue)<=19.99 then begin
       if not IsPresentSeparator(InValue) then begin
        tmps:=ValueNamesIn20[strtoint(InValue)];
       end else begin
        tmps:=ValueNamesIn20[strtoint(Copy(inValue,1,Pos(DecimalSeparator,InValue)-1))];
       end;
      end else begin
       if LastChar<>'0' then begin
        if not IsPresentSeparator(InValue) then begin
          tmps:=ValueNamesIn100[strtoint(firstChar)-2]+prefix+ValueNamesIn20[strtoint(lastChar)];
         end else begin
          case strtoint(lastChar) of
           1: begin
            case TypeTranslate of
              ttNormal: addstr:=ValueNames[0];
              ttMoney: addstr:=ValueNamesMoney[0];
              ttMoneyLongShort: addstr:=ValueNamesMoney[0];
            end;
           end;
           2: begin
            case TypeTranslate of
              ttNormal: addstr:=ValueNames[1];
              ttMoney: addstr:=ValueNamesMoney[1];
              ttMoneyLongShort: addstr:=ValueNamesMoney[1];
            end;
           end;
           else begin
             addstr:=ValueNamesIn20[strtoint(lastChar)];
           end;
          end;
          tmps:=ValueNamesIn100[strtoint(firstChar)-2]+prefix+addstr;
         end;
       end else begin
        tmps:=ValueNamesIn100[strtoint(firstChar)-2];
       end;
      end;
    end;
    result:=trim(tmps);
  end;

  function GetStringIn1000Ex(InValue: string): string;
  var
     firstChar: Char;
     InValueS: string;
     tmps: string;
  begin
    InValueS:=InValue;
    firstChar:=InValueS[1];
    if firstchar<>'0' then
     tmps:=ValueNamesIn1000[strtoint(FirstChar)-1]+prefix+GetStringIn100Ex(Copy(InValueS,2,Length(InvalueS)-1))
    else
     tmps:=GetStringIn100Ex(Copy(InValueS,2,Length(InvalueS)-1));
    result:=trim(tmps);
  end;

  function GetStringIn1000(InValue: string): string;
  var
     firstChar: Char;
     InValueS: string;
     tmps: string;
  begin
    InValueS:=InValue;
    firstChar:=InValueS[1];
    if firstchar<>'0' then
     tmps:=ValueNamesIn1000[strtoint(FirstChar)-1]+prefix+GetStringIn100(Copy(InValueS,2,Length(InvalueS)-1))
    else
     tmps:=GetStringIn100(Copy(InValueS,2,Length(InvalueS)-1));
    result:=trim(tmps);
  end;

  function GetStringIn1000000(InValue: string): string;
  var
     firstChar,nextChar,nextnextChar: Char;
     InValueS,Newvalue: string;
     tmps: string;
     lv: integer;
     pristavka: string;
     addstr: string;
     str: string;
  begin
    InValueS:=InValue;
    firstChar:=InValueS[1];
    if firstChar='0' then begin
      str:=Copy(InValueS,1,pos(Decimalseparator,InValueS)-1);
      if Length(str)=0 then str:=InValue;
      if length(str)>4 then
       tmps:=GetStringIn1000000(Copy(InValueS,2,Length(InvalueS)-1))
      else
       tmps:=GetStringIn1000(Copy(InValueS,2,Length(InvalueS)-1));
      result:=trim(tmps);
      exit;
    end;
    if not IsPresentSeparator(InValue) then begin
    lv:=Length(InValueS);
     case lv of
       4:begin
        case strtoint(firstChar) of
          1: begin
            pristavka:=ValueNames[strtoint(firstchar)-1];
            addstr:=ValueNamesIn1e9[0];
          end;
          2: begin
            pristavka:=ValueNames[strtoint(firstchar)-1];
            addstr:=ValueNamesIn1e9[1];
          end;
          3: begin
            pristavka:=ValueNamesIn20[strtoint(firstchar)];
            addstr:=ValueNamesIn1e9[1];
          end;
          4: begin
            pristavka:=ValueNamesIn20[strtoint(firstchar)];
            addstr:=ValueNamesIn1e9[1];
          end;

          else begin
            pristavka:=ValueNamesIn20[strtoint(firstchar)];
            addstr:=ValueNamesIn1e9[2];
          end;
        end;
        tmps:=pristavka+prefix+addstr+prefix+
         GetStringIn1000(Copy(InValueS,2,Length(InvalueS)-1));
       end;
       5:begin
        nextChar:=InValueS[2];
        case strtoint(firstChar) of
           1: begin
             pristavka:=ValueNamesIn20[strtoint(FirstChar+nextChar)];
             addstr:=ValueNamesIn1e9[2];
           end;
           else begin
             case strtoint(NextChar) of
               1:begin
                 addstr:=ValueNamesIn1e9[0];
               end;
               2,3,4:begin
                 addstr:=ValueNamesIn1e9[1];
               end;
               else begin
                 addstr:=ValueNamesIn1e9[2];
               end;
             end;
             pristavka:=GetStringIn100Ex(Copy(InValueS,1,3));
           end;
        end;
        tmps:=pristavka+prefix+addstr+prefix+
              GetStringIn1000(Copy(InValueS,3,Length(InvalueS)-1));
       end;
       6:begin
        nextChar:=InValueS[2];
        nextnextChar:=InValueS[3];
        case strtoint(nextnextChar) of
           1:begin
             case strtoint(nextChar)of
               1: addstr:=ValueNamesIn1e9[2];
               else addstr:=ValueNamesIn1e9[0]
             end;
           end;
           2,3,4:begin
              addstr:=ValueNamesIn1e9[1]
           end;
           else begin
               addstr:=ValueNamesIn1e9[2]
           end;
        end;
        pristavka:=GetStringIn1000Ex(Copy(InValueS,1,3));
        tmps:=pristavka+prefix+addstr+prefix+
          GetStringIn1000(Copy(InValueS,4,Length(InvalueS)-1));
       end;
      end;
     end else begin
     Newvalue:=Copy(InValue,1,(pos(DecimalSeparator,InValue))-1);
     lv:=Length(Newvalue);
     case lv of
       4:begin
        case strtoint(firstChar) of
          1: begin
            pristavka:=ValueNames[strtoint(firstchar)-1];
            addstr:=ValueNamesIn1e9[0];
          end;
          2: begin
            pristavka:=ValueNames[strtoint(firstchar)-1];
            addstr:=ValueNamesIn1e9[1];
          end;
          3: begin
            pristavka:=ValueNamesIn20[strtoint(firstchar)];
            addstr:=ValueNamesIn1e9[1];
          end;
          4: begin
            pristavka:=ValueNamesIn20[strtoint(firstchar)];
            addstr:=ValueNamesIn1e9[1];
          end;

          else begin
            pristavka:=ValueNamesIn20[strtoint(firstchar)];
            addstr:=ValueNamesIn1e9[2];
          end;
        end;
        tmps:=pristavka+prefix+addstr+prefix+
         GetStringIn1000(Copy(InValueS,2,Length(InValueS)-1));
       end;
       5:begin
        nextChar:=Newvalue[2];
        case strtoint(firstChar) of
           1: begin
             pristavka:=ValueNamesIn20[strtoint(FirstChar+nextChar)];
             addstr:=ValueNamesIn1e9[2];
           end;
           else begin
             case strtoint(NextChar) of
               1:begin
                 addstr:=ValueNamesIn1e9[0];
               end;
               2,3,4:begin
                 addstr:=ValueNamesIn1e9[1];
               end;
               else begin
                 addstr:=ValueNamesIn1e9[2];
               end;
             end;
             pristavka:=GetStringIn100Ex(Copy(InValueS,1,3));
           end;
        end;
        tmps:=pristavka+prefix+addstr+prefix+
              GetStringIn1000(Copy(InValueS,3,Length(InValueS)-1));
       end;
       6:begin
        nextChar:=InValueS[2];
        nextnextChar:=InValueS[3];
        case strtoint(nextnextChar) of
           1:begin
             case strtoint(nextChar)of
               1: addstr:=ValueNamesIn1e9[2];
               else addstr:=ValueNamesIn1e9[0]
             end;
           end;
           2,3,4:begin
              addstr:=ValueNamesIn1e9[1]
           end;
           else begin
               addstr:=ValueNamesIn1e9[2]
           end;
        end;
        pristavka:=GetStringIn1000Ex(Copy(InValueS,1,3));
        tmps:=pristavka+prefix+addstr+prefix+
          GetStringIn1000(Copy(InValueS,4,Length(InValueS)-1));
       end;
     end;
    end;
    result:=trim(tmps);
  end;

  function GetStringIn1000000000(InValue: string): string;
  var
    tmps: string;
    InValueS: string;
    firstChar,NextChar,nextNextChar: char;
    addstr:string;
    lv: integer;
    pristavka: string;
    Newvalue: string;
  begin
    InValueS:=InValue;
    firstChar:=InValueS[1];
    if not IsPresentSeparator(InValue) then begin
     lv:=Length(InValueS);
     case lv of
      7: begin
       case strtoint(firstChar) of
           1:begin
              addstr:=ValueNamesIn1e9[3];
           end;
           2,3,4:begin
              addstr:=ValueNamesIn1e9[4];
           end;
           else begin
              addstr:=ValueNamesIn1e9[5];
          end;
        end;
        pristavka:=ValueNamesIn20[strtoint(firstchar)];
       tmps:=pristavka+prefix+addstr+prefix+
             GetStringIn1000000(Copy(InValueS,2,Length(InvalueS)-1));
      end;
      8: begin
       NextChar:=InValueS[2];
       case strtoint(NextChar)of
         1: begin
           if FirstChar<>'1' then begin
             addstr:=ValueNamesIn1e9[3];
           end else begin
             addstr:=ValueNamesIn1e9[5];
           end;
         end;
         2,3,4: begin
           if FirstChar<>'1' then begin
            addstr:=ValueNamesIn1e9[4];
           end else begin
            addstr:=ValueNamesIn1e9[5];
           end;
         end;
         else begin
           addstr:=ValueNamesIn1e9[5];
         end;
       end;
       pristavka:=GetStringIn100(Copy(InValueS,1,2));
       tmps:=pristavka+prefix+addstr+prefix+
             GetStringIn1000000(Copy(InValueS,3,Length(InvalueS)-1));
      end;
      9: begin
        nextChar:=InValueS[2];
        nextnextChar:=InValueS[3];
        case strtoint(nextnextChar) of
           1:begin
             case strtoint(nextChar)of
               1: addstr:=ValueNamesIn1e9[5]
               else addstr:=ValueNamesIn1e9[3];
             end;
           end;
           2,3,4:begin
              addstr:=ValueNamesIn1e9[4];
           end;
           else begin
               addstr:=ValueNamesIn1e9[5];
           end;
        end;
        pristavka:=GetStringIn1000(Copy(InValueS,1,3));
        tmps:=pristavka+prefix+addstr+prefix+
             GetStringIn1000000(Copy(InValueS,4,Length(InvalueS)-1));
      end;
     end;
    end else begin
     Newvalue:=Copy(InValue,1,(pos(DecimalSeparator,InValue))-1);
     lv:=Length(Newvalue);
     case lv of
      7: begin
       case strtoint(firstChar) of
           1:begin
              addstr:=ValueNamesIn1e9[3];
           end;
           2,3,4:begin
              addstr:=ValueNamesIn1e9[4];
           end;
           else begin
              addstr:=ValueNamesIn1e9[5];
          end;
        end;
        pristavka:=ValueNamesIn20[strtoint(firstchar)];
       tmps:=pristavka+prefix+addstr+prefix+
             GetStringIn1000000(Copy(InValueS,2,Length(InvalueS)-1));
      end;
      8: begin
       NextChar:=InValueS[2];
       case strtoint(NextChar)of
         1: begin
           if FirstChar<>'1' then begin
             addstr:=ValueNamesIn1e9[3];
           end else begin
             addstr:=ValueNamesIn1e9[5];
           end;
         end;
         2,3,4: begin
           addstr:=ValueNamesIn1e9[4];
         end;
         else begin
           addstr:=ValueNamesIn1e9[5];
         end;
       end;
       pristavka:=GetStringIn100(Copy(InValueS,1,2));
       tmps:=pristavka+prefix+addstr+prefix+
             GetStringIn1000000(Copy(InValueS,3,Length(InvalueS)-1));
      end;
      9: begin
        nextChar:=InValueS[2];
        nextnextChar:=InValueS[3];
        case strtoint(nextnextChar) of
           1:begin
             case strtoint(nextChar)of
               1: addstr:=ValueNamesIn1e9[5]
               else addstr:=ValueNamesIn1e9[3];
             end;
           end;
           2,3,4:begin
              addstr:=ValueNamesIn1e9[4];
           end;
           else begin
               addstr:=ValueNamesIn1e9[5];
           end;
        end;
        pristavka:=GetStringIn1000(Copy(InValueS,1,3));
        tmps:=pristavka+prefix+addstr+prefix+
             GetStringIn1000000(Copy(InValueS,4,Length(InvalueS)-1));
      end;
     end;
    end;
    result:=Trim(tmps);
  end;

  function GetAfterSeparator(InValue: string): string;
  var
    lv: Integer;
    APos: Integer;
    tmps: String;
    InValueS: string;
    FirstChar: Char;
    nextChar: Char;
    newValue: string;
    addstr: string;
  begin
    result:=tmps;
    APos:=Pos(DecimalSeparator,InValue);
    if APos=0 then exit;
    InValueS:=Copy(InValue,Apos+1,Length(InValue)-1);
    if strtofloat(InValueS)=0 then exit;
    lv:=Length(InValues);
    FirstChar:=InValues[1];
    case lv of
      1: begin
        case strtoint(FirstChar)of
          1: begin
            addstr:=ValueSeparator[0];
            newValue:=ValueNames[0];
          end;
          2,3,4: begin
            addstr:=ValueSeparator[2];
            if strtoint(FirstChar)=2 then
             newValue:=ValueNames[1]
            else newValue:=ValueNamesIn20[strtoint(FirstChar)];
          end;
          else begin
            addstr:=ValueSeparator[2];
            newValue:=ValueNamesIn20[strtoint(FirstChar)];
          end;
        end;
      end;
      2: begin
        nextChar:=InValueS[2];
        case strtoint(FirstChar) of
          0: begin
            case strtoint(nextChar)of
              1:begin
               addstr:=ValueSeparator[3];
               newValue:=ValueNames[0];
              end;
              2: begin
               addstr:=ValueSeparator[4];
               newValue:=ValueNames[1];
              end;
              3,4:begin
               addstr:=ValueSeparator[5];
               newValue:=ValueNamesIn20[strtoint(nextChar)];
              end;
              else begin
               addstr:=ValueSeparator[5];
               newValue:=ValueNamesIn20[strtoint(nextChar)];
              end;
            end;
          end;
          1: begin
            addstr:=ValueSeparator[5];
            newValue:=ValueNamesIn20[strtoint(firstChar+nextChar)];
          end;
          else begin
            case strtoint(nextChar)of
              1:begin
               addstr:=ValueSeparator[3];
               newValue:=ValueNamesIn100[strtoint(firstchar)-2]+prefix+ValueNames[0];
              end;
              2,3,4:begin
               addstr:=ValueSeparator[4];
               if strtoint(nextChar)=2 then
                newValue:=ValueNamesIn100[strtoint(firstchar)-2]+prefix+ValueNames[1]
               else
                newValue:=ValueNamesIn100[strtoint(firstchar)-2]+prefix+ValueNamesIn20[strtoint(nextchar)];
              end;
              else begin
               addstr:=ValueSeparator[5];
               newValue:=ValueNamesIn100[strtoint(firstchar)-2]+prefix+ValueNamesIn20[strtoint(nextchar)];
              end;
            end;
          end;
        end;
      end;
    end;
    tmps:=newValue+prefix+addstr;
    result:=Trim(tmps);
  end;

  function GetSeparator(inValue: string): string;
  var
    APos: Integer;
    ch: char;
    tmps: string;
  begin
   APos:=Pos(DecimalSeparator,InValue);
   if APos=0 then exit;
   ch:=Copy(InValue,APos-1,1)[1];
   if strtofloat(InValue)<11 then begin
    if ch='1'then
     Result:=Separator2
    else Result:=Separator1;
   end else begin
    tmps:=Copy(Invalue,APos-2,2);
    if (strtoint(tmps)>=11)and(strtoint(tmps)<=19) then
      Result:=Separator1
     else begin
       if ch='1' then
        Result:=Separator2
       else Result:=Separator1;
     end;
   end;
  end;

  function GetAfterSeparatorMoney(InString: string): String;
  var
    APos: Integer;
    InValueS: string;
  const
    Pref=' коп.';
  begin
    result:='';
    APos:=Pos(DecimalSeparator,InString);
    if APos=0 then exit;
    InValueS:=Copy(InString,Apos+1,Length(InString)-1);
    Result:=InValueS+Pref;
  end;

  function GetSeparatorMoney(inValue: string): string;
  var
    APos: Integer;
    ch: char;
    tmps: string;
    NewValue: Integer;
    ch1,ch2: Char;
  const
    SeparatorMoney1='рубль';
    SeparatorMoney2='рубля';
    SeparatorMoney3='рублей';
  begin
   APos:=Pos(DecimalSeparator,InValue);
   if APos=0 then begin
    NewValue:=StrToint(inValue);
    case NewValue of
      1: begin
       Result:=SeparatorMoney1;
       exit;
      end;
      2..4: begin
       Result:=SeparatorMoney2;
       exit;
      end;
      0,5..20: begin
       Result:=SeparatorMoney3;
       exit;
      end; 
    end;
    ch1:=Invalue[Length(Invalue)];
    ch2:=Invalue[Length(Invalue)-1];
    NewValue:=Strtoint(ch2+ch1);
    case NewValue of
      1: begin
       Result:=SeparatorMoney1;
       exit;
      end;
      2..4: begin
       Result:=SeparatorMoney2;
       exit;
      end;
      0,5..20: begin
       Result:=SeparatorMoney3;
       exit;
      end; 
    end;
    case Strtoint(ch1) of
      1: Result:=SeparatorMoney1;
      2..4: Result:=SeparatorMoney2;
      0,5..9: Result:=SeparatorMoney3;
    end;
    exit;
   end;
   ch:=Copy(InValue,APos-1,1)[1];
   if strtofloat(InValue)<11 then begin
    if ch='1'then
     Result:=SeparatorMoney1
    else case strtoint(ch) of
           2,3,4: Result:=SeparatorMoney2;
           else Result:=SeparatorMoney3;
         end;
   end else begin
    tmps:=Copy(Invalue,APos-2,2);
    if (strtoint(tmps)>=11)and(strtoint(tmps)<=19) then
      Result:=SeparatorMoney3
     else begin
      if ch='1'then
       Result:=SeparatorMoney1
       else case strtoint(ch) of
              2,3,4: Result:=SeparatorMoney2;
             else Result:=SeparatorMoney3;
            end;
     end;
   end;
  end;

  function GetDateDayStr(Day: Word):String;
  var
    tmps: string;
  begin
    tmps:='';
    case Day of
     1: tmps:='первое';
     2: tmps:='второе';
     3: tmps:='третье';
     4: tmps:='четвертое';
     5: tmps:='пятое';
     6: tmps:='шестое';
     7: tmps:='седьмое';
     8: tmps:='восьмое';
     9: tmps:='девятое';
     10: tmps:='десятое';
     11: tmps:='одиннадцатое';
     12: tmps:='двенадцатое';
     13: tmps:='тринадцатое';
     14: tmps:='четырнадцатое';
     15: tmps:='пятнадцатое';
     16: tmps:='шестнадцатое';
     17: tmps:='семнадцатое';
     18: tmps:='восемнадцатое';
     19: tmps:='девятнадцатое';
     20: tmps:='двадцатое';
     21: tmps:='двадцать первое';
     22: tmps:='двадцать второе';
     23: tmps:='двадцать третье';
     24: tmps:='двадцать четвертое';
     25: tmps:='двадцать пятое';
     26: tmps:='двадцать шестое';
     27: tmps:='двадцать седьмое';
     28: tmps:='двадцать восьмое';
     29: tmps:='двадцать девятое';
     30: tmps:='тридцатое';
     31: tmps:='тридцать первое';
    end;
    Result:=tmps;
  end;

  function GetDateDayStrRodit(Day: Word):String;
  var
    tmps: string;
  begin
    tmps:='';
    case Day of
     1: tmps:='первого';
     2: tmps:='второго';
     3: tmps:='третьего';
     4: tmps:='четвертого';
     5: tmps:='пятого';
     6: tmps:='шестого';
     7: tmps:='седьмого';
     8: tmps:='восьмого';
     9: tmps:='девятого';
     10: tmps:='десятого';
     11: tmps:='одиннадцатого';
     12: tmps:='двенадцатого';
     13: tmps:='тринадцатого';
     14: tmps:='четырнадцатого';
     15: tmps:='пятнадцатого';
     16: tmps:='шестнадцатого';
     17: tmps:='семнадцатого';
     18: tmps:='восемнадцатого';
     19: tmps:='девятнадцатого';
     20: tmps:='двадцатого';
     21: tmps:='двадцать первого';
     22: tmps:='двадцать второго';
     23: tmps:='двадцать третьего';
     24: tmps:='двадцать четвертого';
     25: tmps:='двадцать пятого';
     26: tmps:='двадцать шестого';
     27: tmps:='двадцать седьмого';
     28: tmps:='двадцать восьмого';
     29: tmps:='двадцать девятого';
     30: tmps:='тридцатого';
     31: tmps:='тридцать первого';
    end;
    Result:=tmps;
  end;
  
  function GetDateMonthStr(Month:Word): String;
  var
    tmps: string;
  begin
    tmps:='';
    case Month of
      1: tmps:='января';
      2: tmps:='февраля';
      3: tmps:='марта';
      4: tmps:='апреля';
      5: tmps:='мая';
      6: tmps:='июня';
      7: tmps:='июля';
      8: tmps:='августа';
      9: tmps:='сентября';
      10: tmps:='октября';
      11: tmps:='ноября';
      12: tmps:='декабря';
    end;
    Result:=tmps;
  end;

const
  YearIn20Count=20;
  YearIn20Value: array [1..YearIn20Count] of string =
  ('первого',
  'второго',
  'третьего',
  'четвертого',
  'пятого',
  'шестого',
  'седьмого',
  'восьмого',
  'девятого',
  'десятого',
  'одиннадцатого',
  'двенадцатого',
  'тринадцатого',
  'четырнадцатого',
  'пятнадцатого',
  'шестнадцатого',
  'семнадцатого',
  'восемнадцатого',
  'девятнадцатого',
  'двадцатого');

  YearIn1000Count=9;
  YearIn1000Value: array [1..YearIn1000Count] of string =
  ('сотого',
  'двухсотого',
  'трехсотого',
  'четырехсотого',
  'пятисотого',
  'шестисотого',
  'семисотого',
  'восьмисотого',
  'девятисотого');

  YearT='тысячного';

  YearIn10000TCount=9;
  YearIn10000TValue: array [1..YearIn10000TCount] of string =
  ('одна',
  'двух',
  'трех',
  'четырех',
  'пяти',
  'шести',
  'семи',
  'восьми',
  'девяти');

  function GetDateYearIn20(Year: Word): string;
  begin
    result:=YearIn20Value[Year];
  end;

  function GetDateYearIn100(Year: Word): string;
  var
    tmps: string;
    lch,fch: char;
    tmpF,tmpL: String;
  begin
    tmps:=inttostr(Year);
    lch:=tmps[Length(tmps)];
    fch:=tmps[Length(tmps)-1];
    if (Strtoint(fch+lch)>=1)and(Strtoint(fch+lch)<=20) then begin
     tmpL:=YearIn20Value[Strtoint(fch+lch)];
    end else begin
     case Strtoint(lch) of
       1..9: tmpL:=YearIn20Value[Strtoint(lch)];
     end;
     case Strtoint(fch) of
       2..9: tmpF:=ValueNamesIn100[Strtoint(fch)-2];
     end;
    end;
    result:=Trim(tmpF+' '+tmpL);
  end;

  function GetDateYearIn1000(Year: Word): string;
  var
    tmps: string;
    fch,lch,llch: char;
    tmpF,tmpL: String;
  begin
    tmps:=inttostr(Year);
    fch:=tmps[Length(tmps)-2];
    lch:=tmps[Length(tmps)-1];
    llch:=tmps[Length(tmps)];
    if (Strtoint(lch)=0)and(Strtoint(llch)=0) then begin
      if Strtoint(fch)<>0 then
       tmpL:=YearIn1000Value[StrToInt(fch)];
    end else begin
     case Strtoint(lch) of
      0..9: tmpL:=GetDateYearIn100(Year);
     end;
     case StrToInt(fch) of
      1..9: tmpF:=ValueNamesIn1000[StrToInt(fch)-1];
     end;
    end;
    result:=Trim(tmpF+' '+tmpL);
  end;

  function GetDateYearIn10000(Year: Word): string;
  var
    tmps: string;
    fch: char;
    tmpF,tmpL: String;
    ch1,ch2,ch3: char;
    isT: Boolean;
  begin
    tmps:=inttostr(Year);
    fch:=tmps[Length(tmps)-3];
    ch1:=tmps[Length(tmps)];
    ch2:=tmps[Length(tmps)-1];
    ch3:=tmps[Length(tmps)-2];
    isT:=(ch1='0')and(ch2='0')and(ch3='0');
    tmpL:=GetDateYearIn1000(Year);
    case StrToInt(fch) of
      1: begin
       if not isT then
        tmpF:=ValueNames[0]+' '+ValueNamesIn1e9[0]
       else tmpF:=YearIn10000TValue[1]+' '+YearT;
      end;
      2..4: begin
       case StrToInt(fch) of
        2: begin
         if not isT then
          tmpF:=ValueNames[1]+' '+ValueNamesIn1e9[1]
         else tmpF:=YearIn10000TValue[2]+' '+YearT;
        end;
        3..4: begin
         if not isT then
          tmpF:=ValueNamesIn20[StrToInt(fch)]+' '+ValueNamesIn1e9[1]
         else tmpF:=YearIn10000TValue[StrToInt(fch)]+' '+YearT;
        end;
       end;
      end;
      5..9: begin
       if not isT then
        tmpF:=ValueNamesIn20[StrToInt(fch)]+' '+ValueNamesIn1e9[2]
       else tmpF:=YearIn10000TValue[StrToInt(fch)]+' '+YearT;
      end;
    end;
    result:=Trim(tmpF+' '+tmpL);
  end;

  function GetDateYearStr(Year:Word): String;
  var
    tmps: string;
  begin
    tmps:='';
    case Year of
      1..20: tmps:=GetDateYearIn20(Year);
      21..99: tmps:=GetDateYearIn100(Year);
      100..999: tmps:=GetDateYearIn1000(Year);
      1000..9999: tmps:=GetDateYearIn10000(Year);
    end;
    Result:=tmps;
  end;

  function GetTimeHourStr(Hour: Word):String;
  var
    tmps,tmpsF,tmpsL: string;
    ch1,ch2: char;
  const
    MinF='час';
    MinFF='часа';
    MinFFF='часов';
  begin
    tmps:='';
    case Hour of
      1,21,31,41,51: tmps:=MinF;
      2..4,22..24,32..34,42..44,52..54: tmps:=MinFF;
      0,5..20,25..30,35..40,45..50,55..60: tmps:=MinFFF;
    end;
    if (Hour<=20) then begin
     tmps:=ValueNamesIn20[Hour]+' '+tmps;
    end else begin
     ch1:=Inttostr(Hour)[Length(Inttostr(Hour))];
     ch2:=Inttostr(Hour)[Length(Inttostr(Hour))-1];
     case Strtoint(ch1) of
       1..2: begin
        if ch2='0' then
         tmpsL:=ValueNames[Strtoint(ch1)-1]
        else tmpsL:=ValueNamesIn20[Strtoint(ch1)];
       end;
       3..4: tmpsL:=ValueNamesIn20[Strtoint(ch1)];
       5..9: tmpsL:=ValueNamesIn20[Strtoint(ch1)];
     end;
     tmpsF:=ValueNamesIn100[Strtoint(ch2)-2];
     tmps:=Trim(tmpsF+' '+tmpsL+' '+tmps);
    end;
    Result:=tmps;
  end;

  function GetTimeMinStr(Min: Word):String;
  var
    tmps,tmpsF,tmpsL: string;
    ch1,ch2: char;
  const
    MinF='минута';
    MinFF='минуты';
    MinFFF='минут';
  begin
    tmps:='';
    case Min of
      1,21,31,41,51: tmps:=MinF;
      2..4,22..24,32..34,42..44,52..54: tmps:=MinFF;
      0,5..20,25..30,35..40,45..50,55..60: tmps:=MinFFF;
    end;
    if (Min<=20) then begin
      case Min of
       1..2: begin
        tmpsL:=ValueNames[Min-1];
       end;
       else begin
        tmpsL:=ValueNamesIn20[Min];
       end;
      end;
    end else begin
     ch1:=Inttostr(Min)[Length(Inttostr(Min))];
     ch2:=Inttostr(Min)[Length(Inttostr(Min))-1];
     case Strtoint(ch1) of
       1..2: begin
        tmpsL:=ValueNames[Strtoint(ch1)-1];
       end;
       3..4: tmpsL:=ValueNamesIn20[Strtoint(ch1)];
       5..9: tmpsL:=ValueNamesIn20[Strtoint(ch1)];
     end;
     tmpsF:=ValueNamesIn100[Strtoint(ch2)-2];
    end;
    tmps:=Trim(tmpsF+' '+tmpsL+' '+tmps);
    Result:=tmps;
  end;

  function GetTimeSecStr(Sec: Word):String;
  var
    tmps,tmpsF,tmpsL: string;
    ch1,ch2: char;
  const
    MinF='секунда';
    MinFF='секунды';
    MinFFF='секунд';
  begin
    tmps:='';
    case Sec of
      1,21,31,41,51: tmps:=MinF;
      2..4,22..24,32..34,42..44,52..54: tmps:=MinFF;
      0,5..20,25..30,35..40,45..50,55..60: tmps:=MinFFF;
    end;
    if (Sec<=20) then begin
      case Sec of
       1..2: begin
        tmpsL:=ValueNames[Sec-1];
       end;
       else begin
        tmpsL:=ValueNamesIn20[Sec];
       end;
      end;   
    end else begin
     ch1:=Inttostr(Sec)[Length(Inttostr(Sec))];
     ch2:=Inttostr(Sec)[Length(Inttostr(Sec))-1];
     case Strtoint(ch1) of
       1..2: begin
        tmpsL:=ValueNames[Strtoint(ch1)-1];
       end;
       3..4: tmpsL:=ValueNamesIn20[Strtoint(ch1)];
       5..9: tmpsL:=ValueNamesIn20[Strtoint(ch1)];
     end;
     tmpsF:=ValueNamesIn100[Strtoint(ch2)-2];
    end;
    tmps:=Trim(tmpsF+' '+tmpsL+' '+tmps);
    Result:=tmps;
  end;

var
  tmps: string;
  addstr: string;
  NewDate: TDate;
  NewTime: TTime;
  Year,Month,Day: Word;
  YearStr,MonthStr,DayStr: String;
  Hour, Min, Sec, MSec: Word;
  HourStr,MinStr,SecStr: String;
  ValueStr: String;
const
  YearConst='';
//  YearConst='года';

begin

 result:='Ошибка перевода.';
 case TypeTranslate of
  ttNormal,ttMoney,ttMoneyLongShort: begin
  ValueStr:=Trim(Format('%15.2f',[Value]));
  Value:=Strtofloat(Trim(ValueStr));
  if (value>=0) and (value<=19.99) then begin
    case TypeTranslate of
      ttNormal: begin
       tmps:=GetAfterSeparator(FloatToStr(Value));
       if Trim(tmps)<>'' then
        addstr:=prefix+GetSeparator(ValueStr)+prefix;
       Result:=trim(GetStringIn20(ValueStr)+addstr+tmps);
      end;
      ttMoney: begin
       tmps:=GetAfterSeparatorMoney(ValueStr);
       addstr:=prefix+GetSeparatorMoney(ValueStr)+prefix;
       Result:=trim(GetStringIn20(ValueStr)+addstr+tmps);
      end;
      ttMoneyLongShort: begin
       tmps:=GetAfterSeparatorMoney(ValueStr);
       addstr:=prefix+GetSeparatorMoney(ValueStr)+prefix;
       Result:=Trim(floattostr(Trunc(Value))+' ('+trim(GetStringIn20(ValueStr))+') '+addstr+' '+tmps);
      end;
    end;
    exit;
  end;
  if (value>=20)and(value<=99.99)then begin
    case TypeTranslate of
      ttNormal: begin
       tmps:=GetAfterSeparator(FloatToStr(Value));
       if Trim(tmps)<>'' then
        addstr:=prefix+GetSeparator(ValueStr)+prefix;
       result:=Trim(GetStringIn100(ValueStr)+addstr+tmps);
      end;
      ttMoney: begin
       tmps:=GetAfterSeparatorMoney(ValueStr);
       addstr:=prefix+GetSeparatorMoney(ValueStr)+prefix;
       result:=Trim(GetStringIn100(ValueStr)+addstr+tmps);
      end;
      ttMoneyLongShort: begin
       tmps:=GetAfterSeparatorMoney(ValueStr);
       addstr:=prefix+GetSeparatorMoney(ValueStr)+prefix;
       Result:=Trim(floattostr(Trunc(Value))+' ('+trim(GetStringIn100(ValueStr))+') '+addstr+' '+tmps);
      end;
    end;

    exit;
  end;
  if (value>=100)and(value<=999.99)then begin
    case TypeTranslate of
      ttNormal: begin
       tmps:=GetAfterSeparator(FloatToStr(Value));
       if Trim(tmps)<>'' then
        addstr:=prefix+GetSeparator(ValueStr)+prefix;
       Result:=trim(GetStringIn1000(ValueStr)+addstr+tmps);
      end;
      ttMoney: begin
       tmps:=GetAfterSeparatorMoney(ValueStr);
       addstr:=prefix+GetSeparatorMoney(ValueStr)+prefix;
       Result:=trim(GetStringIn1000(ValueStr)+addstr+tmps);
      end;
      ttMoneyLongShort: begin
       tmps:=GetAfterSeparatorMoney(ValueStr);
       addstr:=prefix+GetSeparatorMoney(ValueStr)+prefix;
       Result:=Trim(floattostr(Trunc(Value))+' ('+trim(GetStringIn1000(ValueStr))+') '+addstr+' '+tmps);
      end;
    end;
    exit;
  end;
  if (value>=1000)and(value<=999999.99)then begin
    case TypeTranslate of
      ttNormal: begin
       tmps:=GetAfterSeparator(FloatToStr(Value));
       if Trim(tmps)<>'' then
        addstr:=prefix+GetSeparator(ValueStr)+prefix;
       Result:=trim(GetStringIn1000000(ValueStr)+addstr+tmps);
      end;
      ttMoney: begin
       tmps:=GetAfterSeparatorMoney(ValueStr);
       addstr:=prefix+GetSeparatorMoney(ValueStr)+prefix;
       Result:=trim(GetStringIn1000000(ValueStr)+addstr+tmps);
      end;
      ttMoneyLongShort: begin
       tmps:=GetAfterSeparatorMoney(ValueStr);
       addstr:=prefix+GetSeparatorMoney(ValueStr)+prefix;
       Result:=Trim(floattostr(Trunc(Value))+' ('+trim(GetStringIn1000000(ValueStr))+') '+addstr+' '+tmps);
      end;
    end;
    exit;
  end;
  if (value>=1000000)and(value<=999999999.99)then begin
    case TypeTranslate of
      ttNormal: begin
       tmps:=GetAfterSeparator(FloatToStr(Value));
       if Trim(tmps)<>'' then
        addstr:=prefix+GetSeparator(ValueStr)+prefix;
       Result:=trim(GetStringIn1000000000(ValueStr)+addstr+tmps);
      end;
      ttMoney: begin
       tmps:=GetAfterSeparatorMoney(ValueStr);
       addstr:=prefix+GetSeparatorMoney(ValueStr)+prefix;
       Result:=trim(GetStringIn1000000000(ValueStr)+addstr+tmps);
      end;
      ttMoneyLongShort: begin
       tmps:=GetAfterSeparatorMoney(ValueStr);
       addstr:=prefix+GetSeparatorMoney(ValueStr)+prefix;
       Result:=Trim(floattostr(Trunc(Value))+' ('+trim(GetStringIn1000000000(ValueStr))+') '+addstr+' '+tmps);
      end;
    end;
    exit;
  end;
  end;
  ttDate: begin
   NewDate:=Value;
   DecodeDate(NewDate,Year,Month,Day);
   if (Year>=1)and(Year<=9999) then begin
    DayStr:=GetDateDayStr(Day);
    MonthStr:=GetDateMonthStr(Month);
    YearStr:=GetDateYearStr(Year);
    Result:=DayStr+' '+MonthStr+' '+YearStr+' '+YearConst;
    Result:=Trim(Result);
   end;
  end;
  ttDateMonth: begin
   NewDate:=Value;
   DecodeDate(NewDate,Year,Month,Day);
   if (Year>=1)and(Year<=9999) then begin
    DayStr:=IntToStr(Day);
    MonthStr:=GetDateMonthStr(Month);
    YearStr:=IntToStr(Year);
    Result:=DayStr+' '+MonthStr+' '+YearStr+' '+YearConst;
    Result:=Trim(Result);
   end;
  end;
  ttDateRodit: begin
   NewDate:=Value;
   DecodeDate(NewDate,Year,Month,Day);
   if (Year>=1)and(Year<=9999) then begin
     DayStr:=GetDateDayStrRodit(Day);
     MonthStr:=GetDateMonthStr(Month);
     YearStr:=GetDateYearStr(Year);
     Result:=DayStr+' '+MonthStr+' '+YearStr+' '+YearConst;
     Result:=Trim(Result);
   end;
  end;
  ttDateRoditMonth: begin
   NewDate:=Value;
   DecodeDate(NewDate,Year,Month,Day);
   if (Year>=1)and(Year<=9999) then begin
     DayStr:=IntToStr(Day);
     MonthStr:=GetDateMonthStr(Month);
     YearStr:=IntToStr(Year);
     Result:=DayStr+' '+MonthStr+' '+YearStr+' '+YearConst;
     Result:=Trim(Result);
   end;
  end;
  ttTime: begin
    NewTime:=Value;
    DecodeTime(NewTime,Hour,Min,Sec,MSec);
    HourStr:=GetTimeHourStr(Hour);
    MinStr:=GetTimeMinStr(Min);
//    SecStr:=GetTimeSecStr(Sec);    Special for VAV
    result:=HourStr+' '+MinStr+' '+SecStr;
    Result:=Trim(Result);
  end;
  ttMoneyShort: begin
    Result:=FloatToStr(Value)+prefix+'руб.'+prefix;
  end;
  ttMoneyTariff: begin
    if Round(Value)=0 then begin
     Result:='освобождено';
    end else begin
      ValueStr:=Trim(Format('%15.2f',[Value]));
      addstr:='руб.';
      if Trunc(Value)<>Value then begin
        tmps:=GetAfterSeparatorMoney(ValueStr);
      end;  
      Result:=Trim(floattostr(Trunc(Value))+' '+addstr+' '+tmps);
//      ShowMessage(Result);
    end;
  end;
 end; // case
end;

end.
