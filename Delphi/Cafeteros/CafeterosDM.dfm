object DataModule1: TDataModule1
  Height = 480
  Width = 640
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLNCLI11.1;Persist Security Info=False;User ID=desarro' +
      'llo;Initial Catalog=FNC;Data Source=localhost;Initial File Name=' +
      '"";Server SPN="";'
    LoginPrompt = False
    Provider = 'SQLNCLI11.1'
    Left = 72
    Top = 40
  end
  object ADOSPCrearCaficultor: TADOStoredProc
    Connection = ADOConnection1
    ProcedureName = 'CrearCaficultor;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
        Value = Null
      end
      item
        Name = '@id'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
        Value = 900003
      end
      item
        Name = '@nombre'
        Attributes = [paNullable]
        DataType = ftString
        Size = 100
        Value = 'Gema Requena'
      end
      item
        Name = '@identificacion'
        Attributes = [paNullable]
        DataType = ftString
        Size = 20
        Value = '1900100234'
      end
      item
        Name = '@ciudad'
        Attributes = [paNullable]
        DataType = ftString
        Size = 50
        Value = 'Turbo'
      end
      item
        Name = '@errorcode'
        DataType = ftInteger
        Direction = pdOutput
        Precision = 8
        Value = Null
      end
      item
        Name = '@errormsg'
        DataType = ftString
        Direction = pdOutput
        Size = 200
        Value = Null
      end>
    Left = 192
    Top = 40
  end
  object ADOQueryCaficultores: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM CAFICULTORES')
    Left = 192
    Top = 208
  end
  object ADOSPCrearProducto: TADOStoredProc
    Connection = ADOConnection1
    ProcedureName = 'CrearProducto;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
      end
      item
        Name = '@id'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
      end
      item
        Name = '@id_caficultor'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
      end
      item
        Name = '@tipo_producto'
        Attributes = [paNullable]
        DataType = ftString
        Size = 50
      end
      item
        Name = '@numero_cuenta'
        Attributes = [paNullable]
        DataType = ftString
        Size = 20
      end
      item
        Name = '@errorcode'
        Attributes = [paNullable]
        DataType = ftInteger
        Direction = pdInputOutput
        Precision = 10
      end
      item
        Name = '@errormsg'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 200
      end>
    Left = 320
    Top = 40
  end
  object ADOSPCrearAbono: TADOStoredProc
    Connection = ADOConnection1
    ProcedureName = 'CrearAbono;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
      end
      item
        Name = '@id'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
      end
      item
        Name = '@id_caficultor'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
      end
      item
        Name = '@valor'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
      end
      item
        Name = '@fecha'
        Attributes = [paNullable]
        DataType = ftDate
      end
      item
        Name = '@errorcode'
        Attributes = [paNullable]
        DataType = ftInteger
        Direction = pdInputOutput
        Precision = 10
      end
      item
        Name = '@errormsg'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 200
      end>
    Left = 440
    Top = 40
  end
  object ADOSPBorrarCaficultor: TADOStoredProc
    Connection = ADOConnection1
    ProcedureName = 'BorrarCaficultor;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
      end
      item
        Name = '@id'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
      end
      item
        Name = '@errorcode'
        Attributes = [paNullable]
        DataType = ftInteger
        Direction = pdInputOutput
        Precision = 10
      end
      item
        Name = '@errormsg'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 200
      end>
    Left = 192
    Top = 152
  end
  object ADOSPBorrarProducto: TADOStoredProc
    Connection = ADOConnection1
    ProcedureName = 'BorrarProducto;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
      end
      item
        Name = '@id'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
      end
      item
        Name = '@errorcode'
        Attributes = [paNullable]
        DataType = ftInteger
        Direction = pdInputOutput
        Precision = 10
      end
      item
        Name = '@errormsg'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 200
      end>
    Left = 320
    Top = 152
  end
  object ADOQueryProductos: TADOQuery
    Connection = ADOConnection1
    Parameters = <
      item
        Name = 'ID'
        Value = Null
      end>
    SQL.Strings = (
      'SELECT * FROM PRODUCTOS_CLIENTE'
      '  WHERE ID_CAFICULTOR = :ID')
    Left = 320
    Top = 208
  end
  object ADOSPEditarCaficultor: TADOStoredProc
    Connection = ADOConnection1
    ProcedureName = 'ActualizarCaficultor;1'
    Parameters = <
      item
        Name = '@RETURN_VALUE'
        DataType = ftInteger
        Direction = pdReturnValue
        Precision = 10
      end
      item
        Name = '@id'
        Attributes = [paNullable]
        DataType = ftInteger
        Precision = 10
      end
      item
        Name = '@nombre'
        Attributes = [paNullable]
        DataType = ftString
        Size = 100
      end
      item
        Name = '@identificacion'
        Attributes = [paNullable]
        DataType = ftString
        Size = 20
      end
      item
        Name = '@ciudad'
        Attributes = [paNullable]
        DataType = ftString
        Size = 50
      end
      item
        Name = '@errorcode'
        Attributes = [paNullable]
        DataType = ftInteger
        Direction = pdInputOutput
        Precision = 10
      end
      item
        Name = '@errormsg'
        Attributes = [paNullable]
        DataType = ftString
        Direction = pdInputOutput
        Size = 200
      end>
    Left = 192
    Top = 96
  end
  object ADOQueryAbonos: TADOQuery
    Connection = ADOConnection1
    Parameters = <
      item
        Name = 'ID'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'SELECT * FROM ABONOS_MONEDERO'
      '  WHERE ID_CAFICULTOR = :ID'
      '  ORDER BY FECHA, ID')
    Left = 440
    Top = 208
  end
  object ADOQuerySaldoMonedero: TADOQuery
    Connection = ADOConnection1
    Parameters = <
      item
        Name = 'ID'
        Size = -1
        Value = Null
      end>
    SQL.Strings = (
      'SELECT ID_CAFICULTOR, SUM(VALOR) AS SALDO FROM ABONOS_MONEDERO'
      '  WHERE ID_CAFICULTOR = :ID'
      '  GROUP BY ID_CAFICULTOR')
    Left = 440
    Top = 264
  end
end
