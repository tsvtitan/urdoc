unit tsvInterbase;

interface

uses Classes, Controls, Forms, IBQuery, IBDatabase;

procedure ExecSql(IBDB: TIBDatabase; SqlValue: string);

implementation

uses UDM;

procedure ExecSql(IBDB: TIBDatabase; SqlValue: string);
var
  qr: TIBQuery;
  tran: TIBTransaction;
  sqls: string;
begin
  Screen.Cursor:=crHourGlass;
  qr:=TIBQuery.Create(nil);
  tran:=TIBTransaction.Create(nil);
  try
   qr.Database:=IBDB;
   tran.AddDatabase(IBDB);
   IBDB.AddTransaction(tran);
   tran.Params.Text:=DefaultTransactionParamsTwo;
   qr.ParamCheck:=false;
   qr.Transaction:=tran;
   qr.Transaction.Active:=true;
   sqls:=SqlValue;
   qr.SQL.Text:=sqls;
   qr.ExecSQL;
   qr.Transaction.Commit;
  finally
   qr.Free;
   tran.Free;
   Screen.Cursor:=crDefault;
  end;
end;

end.
