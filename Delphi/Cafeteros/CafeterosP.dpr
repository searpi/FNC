program CafeterosP;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.JSON,
  Horse,
  Horse.CORS,
  ActiveX,
  CafeterosDM in 'CafeterosDM.pas' {DataModule1: TDataModule};


procedure APIServer;
begin
  WriteLn('Servidor Horse activo...');

  THorse.Get('/caficultores',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      JsonRow : TJsonObject;
      JsonRsp : TJsonArray;
    begin
      WriteLn('GET /caficultores => ' + Req.Body);

      DataModule1.ADOQueryCaficultores.Open;
      JsonRsp := TJsonArray.Create;

      if DataModule1.ADOQueryCaficultores.RecordCount > 0 then
      begin
        // Procesa los resultados
        while not DataModule1.ADOQueryCaficultores.Eof do
        begin
          JsonRow := TJsonObject.Create;
          JsonRow.AddPair('id_caficultor', DataModule1.ADOQueryCaficultores.FieldByName('id').AsString);
          JsonRow.AddPair('nombre', DataModule1.ADOQueryCaficultores.FieldByName('nombre').AsString);
          JsonRow.AddPair('identificacion', DataModule1.ADOQueryCaficultores.FieldByName('identificacion').AsString);
          JsonRow.AddPair('ciudad', DataModule1.ADOQueryCaficultores.FieldByName('ciudad').AsString);
          JsonRsp.Add(JsonRow);
          DataModule1.ADOQueryCaficultores.Next;
        end;
      end;
      DataModule1.ADOQueryCaficultores.Close;

      Res.Send(JsonRsp.ToString);
    end
  );

  THorse.Get('/productos/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      JsonRow : TJsonObject;
      JsonRsp : TJsonArray;
    begin
      WriteLn('GET /productos => ' + Req.Body);

      DataModule1.ADOQueryProductos.Parameters.ParamByName('id').Value := Req.Params['id'];
      DataModule1.ADOQueryProductos.Open;
      JsonRsp := TJsonArray.Create;

      if DataModule1.ADOQueryProductos.RecordCount > 0 then
      begin
        // Procesa los resultados
        while not DataModule1.ADOQueryProductos.Eof do
        begin
          JsonRow := TJsonObject.Create;
          JsonRow.AddPair('id', DataModule1.ADOQueryProductos.FieldByName('id').AsString);
          JsonRow.AddPair('id_caficultor', DataModule1.ADOQueryProductos.FieldByName('id_caficultor').AsString);
          JsonRow.AddPair('tipo_producto', DataModule1.ADOQueryProductos.FieldByName('tipo_producto').AsString);
          JsonRow.AddPair('numero_cuenta', DataModule1.ADOQueryProductos.FieldByName('numero_cuenta').AsString);
          JsonRsp.Add(JsonRow);
          DataModule1.ADOQueryProductos.Next;
        end;
      end;
      DataModule1.ADOQueryProductos.Close;

      Res.Send(JsonRsp.ToString);
    end
  );

  THorse.Get('/abonos/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      JsonRow : TJsonObject;
      JsonRsp : TJsonArray;
    begin
      WriteLn('GET /abonos => ' + Req.Body);

      DataModule1.ADOQueryAbonos.Parameters.ParamByName('id').Value := Req.Params['id'];
      DataModule1.ADOQueryAbonos.Open;
      JsonRsp := TJsonArray.Create;

      if DataModule1.ADOQueryAbonos.RecordCount > 0 then
      begin
        // Procesa los resultados
        while not DataModule1.ADOQueryAbonos.Eof do
        begin
          JsonRow := TJsonObject.Create;
          JsonRow.AddPair('id', DataModule1.ADOQueryAbonos.FieldByName('id').AsString);
          JsonRow.AddPair('id_caficultor', DataModule1.ADOQueryAbonos.FieldByName('id_caficultor').AsString);
          JsonRow.AddPair('valor_abono', DataModule1.ADOQueryAbonos.FieldByName('valor').AsString);
          JsonRow.AddPair('fecha_abono', DataModule1.ADOQueryAbonos.FieldByName('fecha').AsString);
          JsonRsp.Add(JsonRow);
          DataModule1.ADOQueryAbonos.Next;
        end;
      end;
      DataModule1.ADOQueryAbonos.Close;

      Res.Send(JsonRsp.ToString);
    end
  );

  THorse.Get('/saldo-monedero/:id',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      JsonRsp : TJsonObject;
    begin
      WriteLn('GET /saldo-monedero => ' + Req.Body);

      DataModule1.ADOQuerySaldoMonedero.Parameters.ParamByName('id').Value := Req.Params['id'];
      DataModule1.ADOQuerySaldoMonedero.Open;
      JsonRsp := TJsonObject.Create;

      if DataModule1.ADOQuerySaldoMonedero.RecordCount > 0 then
      begin
        // Procesa los resultados
        JsonRsp.AddPair('id_caficultor', DataModule1.ADOQuerySaldoMonedero.FieldByName('id_caficultor').AsString);
        JsonRsp.AddPair('saldo_monedero', DataModule1.ADOQuerySaldoMonedero.FieldByName('saldo').AsString);
      end
      else
      begin
        JsonRsp.AddPair('id_caficultor', Req.Params['id']);
        JsonRsp.AddPair('saldo_monedero', '0');
      end;
      DataModule1.ADOQuerySaldoMonedero.Close;

      Res.Send(JsonRsp.ToString);
    end
  );

  THorse.Post('/crear-caficultor',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      JsonReq,
      JsonRsp : TJsonObject;
    begin
      WriteLn('POST /crear-caficultor => ' + Req.Body);
      JsonReq := nil;
      JsonRsp := TJsonObject.Create;
      try
        JSONReq := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) as TJSONObject;
        if Assigned(JSONReq) then
        begin
          DataModule1.ADOSPCrearCaficultor.Parameters.ParamByName('@id').Value :=
            JSONReq.GetValue('id_caficultor').Value;
          DataModule1.ADOSPCrearCaficultor.Parameters.ParamByName('@nombre').Value :=
            JSONReq.GetValue('nombre').Value;
          DataModule1.ADOSPCrearCaficultor.Parameters.ParamByName('@identificacion').Value :=
            JSONReq.GetValue('identificacion').Value;
          DataModule1.ADOSPCrearCaficultor.Parameters.ParamByName('@ciudad').Value :=
            JSONReq.GetValue('ciudad').Value;

          DataModule1.ADOSPCrearCaficultor.ExecProc;
          SetError( 'Creacion', DataModule1.ADOSPCrearCaficultor.Parameters, JsonRsp );
        end
        else
        begin
          JsonRsp.AddPair('ErrCode', '99');
          JsonRsp.AddPair('ErrMsg', 'Error en contenido del body del request');
        end;
      finally
        if Assigned(JSONReq) then
          JSONReq.Free;
      end;
      Res.Send(JsonRsp.ToString);
    end
  );

  THorse.Post('/crear-producto',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      JsonReq,
      JsonRsp : TJsonObject;
    begin
      WriteLn('POST /crear-producto => ' + Req.Body);
      JsonReq := nil;
      JsonRsp := TJsonObject.Create;
      try
        JSONReq := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) as TJSONObject;
        if Assigned(JSONReq) then
        begin
          DataModule1.ADOSPCrearProducto.Parameters.ParamByName('@id').Value :=
            JSONReq.GetValue('id_producto').Value;
          DataModule1.ADOSPCrearProducto.Parameters.ParamByName('@id_caficultor').Value :=
            JSONReq.GetValue('id_caficultor').Value;
          DataModule1.ADOSPCrearProducto.Parameters.ParamByName('@tipo_producto').Value :=
            JSONReq.GetValue('tipo_producto').Value;
          DataModule1.ADOSPCrearProducto.Parameters.ParamByName('@numero_cuenta').Value :=
            JSONReq.GetValue('numero_cuenta').Value;

          DataModule1.ADOSPCrearProducto.ExecProc;
          SetError( 'Creacion', DataModule1.ADOSPCrearProducto.Parameters, JsonRsp );
        end
        else
        begin
          JsonRsp.AddPair('ErrCode', '99');
          JsonRsp.AddPair('ErrMsg', 'Error en contenido del body del request');
        end;
      finally
        if Assigned(JSONReq) then
          JSONReq.Free;
      end;
      Res.Send(JsonRsp.ToString);
    end
  );

  THorse.Post('/crear-abono',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      JsonReq,
      JsonRsp : TJsonObject;
    begin
      WriteLn('POST /crear-abono => ' + Req.Body);
      JsonReq := nil;
      JsonRsp := TJsonObject.Create;
      try
        JSONReq := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) as TJSONObject;
        if Assigned(JSONReq) then
        begin
          DataModule1.ADOSPCrearAbono.Parameters.ParamByName('@id').Value :=
            JSONReq.GetValue('id_abono').Value;
          DataModule1.ADOSPCrearAbono.Parameters.ParamByName('@id_caficultor').Value :=
            JSONReq.GetValue('id_caficultor').Value;
          DataModule1.ADOSPCrearAbono.Parameters.ParamByName('@valor').Value :=
            JSONReq.GetValue('valor').Value;
          DataModule1.ADOSPCrearAbono.Parameters.ParamByName('@fecha').Value :=
            JSONReq.GetValue('fecha').Value;

          DataModule1.ADOSPCrearAbono.ExecProc;
          SetError( 'Creacion', DataModule1.ADOSPCrearAbono.Parameters, JsonRsp );
        end
        else
        begin
          JsonRsp.AddPair('ErrCode', '99');
          JsonRsp.AddPair('ErrMsg', 'Error en contenido del body del request');
        end;
      finally
        if Assigned(JSONReq) then
          JSONReq.Free;
      end;
      Res.Send(JsonRsp.ToString);
    end
  );

  THorse.Put('/editar-caficultor',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      JsonReq,
      JsonRsp : TJsonObject;
    begin
      WriteLn('PUT /editar-caficultor => ' + Req.Body);
      JsonReq := nil;
      JsonRsp := TJsonObject.Create;
      try
        JSONReq := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) as TJSONObject;
        if Assigned(JSONReq) then
        begin
          DataModule1.ADOSPEditarCaficultor.Parameters.ParamByName('@id').Value :=
            JSONReq.GetValue('id_caficultor').Value;
          DataModule1.ADOSPEditarCaficultor.Parameters.ParamByName('@nombre').Value :=
            JSONReq.GetValue('nombre').Value;
          DataModule1.ADOSPEditarCaficultor.Parameters.ParamByName('@identificacion').Value :=
            JSONReq.GetValue('identificacion').Value;
          DataModule1.ADOSPEditarCaficultor.Parameters.ParamByName('@ciudad').Value :=
            JSONReq.GetValue('ciudad').Value;

          DataModule1.ADOSPEditarCaficultor.ExecProc;
          SetError( 'Actualizacion', DataModule1.ADOSPEditarCaficultor.Parameters, JsonRsp );
        end
        else
        begin
          JsonRsp.AddPair('ErrCode', '99');
          JsonRsp.AddPair('ErrMsg', 'Error en contenido del body del request');
        end;
      finally
        if Assigned(JSONReq) then
          JSONReq.Free;
      end;
      Res.Send(JsonRsp.ToString);
    end
  );

  THorse.Delete('/borrar-caficultor',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      JsonReq,
      JsonRsp : TJsonObject;
    begin
      WriteLn('DELETE /borrar-caficultor => ' + Req.Body);
      JsonReq := nil;
      JsonRsp := TJsonObject.Create;
      try
        JSONReq := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) as TJSONObject;
        if Assigned(JSONReq) then
        begin
          DataModule1.ADOSPBorrarCaficultor.Parameters.ParamByName('@id').Value :=
            JSONReq.GetValue('id_caficultor').Value;

          DataModule1.ADOSPBorrarCaficultor.ExecProc;
          SetError( 'Borrado', DataModule1.ADOSPBorrarCaficultor.Parameters, JsonRsp );
        end
        else
        begin
          JsonRsp.AddPair('ErrCode', '99');
          JsonRsp.AddPair('ErrMsg', 'Error en contenido del body del request');
        end;
      finally
        if Assigned(JSONReq) then
          JSONReq.Free;
      end;
      Res.Send(JsonRsp.ToString);
    end
  );

  THorse.Delete('/borrar-producto',
    procedure(Req: THorseRequest; Res: THorseResponse)
    var
      JsonReq,
      JsonRsp : TJsonObject;
    begin
      WriteLn('DELETE /borrar-producto => ' + Req.Body);
      JsonReq := nil;
      JsonRsp := TJsonObject.Create;
      try
        JSONReq := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) as TJSONObject;
        if Assigned(JSONReq) then
        begin
          DataModule1.ADOSPBorrarProducto.Parameters.ParamByName('@id').Value :=
            JSONReq.GetValue('id_producto').Value;

          DataModule1.ADOSPBorrarProducto.ExecProc;
          SetError( 'Borrado', DataModule1.ADOSPBorrarProducto.Parameters, JsonRsp );
        end
        else
        begin
          JsonRsp.AddPair('ErrCode', '99');
          JsonRsp.AddPair('ErrMsg', 'Error en contenido del body del request');
        end;
      finally
        if Assigned(JSONReq) then
          JSONReq.Free;
      end;
      Res.Send(JsonRsp.ToString);
    end
  );

  THorse.Listen(9000);
end;


begin
  try
    try
      { TODO -oUser -cConsole Main : Insert code here }
      CoInitialize(nil);
      DataModule1 := TDataModule1.Create(Nil);
      DataModule1.ADOConnection1.Open('desarrollo', 'desarrollo');
      THorse.Use(CORS);
      APIServer;
    except
      on E: Exception do
        Writeln(E.ClassName, ': ', E.Message);
    end;
  finally
    if DataModule1 <> nil then
    begin
      DataModule1.ADOConnection1.Close;
      DataModule1.Free;
    end;
  end;
end.
