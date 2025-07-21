unit CafeterosDM;

interface

uses
  System.SysUtils, System.Classes, System.JSON, Data.DB, Data.Win.ADODB;

type
  TDataModule1 = class(TDataModule)
    ADOConnection1: TADOConnection;
    ADOSPCrearCaficultor: TADOStoredProc;
    ADOQueryCaficultores: TADOQuery;
    ADOSPCrearProducto: TADOStoredProc;
    ADOSPCrearAbono: TADOStoredProc;
    ADOSPBorrarCaficultor: TADOStoredProc;
    ADOSPBorrarProducto: TADOStoredProc;
    ADOQueryProductos: TADOQuery;
    ADOSPEditarCaficultor: TADOStoredProc;
    ADOQueryAbonos: TADOQuery;
    ADOQuerySaldoMonedero: TADOQuery;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

procedure SetError( OpDesc : String; Parameters : TParameters; Error : TJsonObject );

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

procedure SetError( OpDesc : String; Parameters : TParameters; Error : TJsonObject );
var
  ErrMsg : String;
begin
  if Parameters.ParamByName('@errorcode').Value = 0 then
  begin
    Error.AddPair('ErrCode', '00');
    Error.AddPair('ErrMsg', OpDesc + ' exitosa: ' + IntToStr(Parameters.ParamByName('@id').Value));
  end
  else
  begin
    ErrMsg := Parameters.ParamByName('@errormsg').Value;
    Error.AddPair('ErrCode', IntToStr(Parameters.ParamByName('@errorcode').Value));
    Error.AddPair('ErrMsg', ErrMsg);
  end
end;


end.
