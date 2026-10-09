-- Actividad semana 9. Ejecutar en una base exclusiva de pruebas.
-- Las validaciones son decisiones de diseño, no reglas textuales del PDF.
CREATE TABLE dbo.Productos (
 IdProducto INT PRIMARY KEY IDENTITY,
 Nombre NVARCHAR(100), Stock INT, Precio DECIMAL(10,2),
 CONSTRAINT CK_Productos_Nombre CHECK (Nombre IS NOT NULL AND LEN(LTRIM(RTRIM(Nombre))) > 0),
 CONSTRAINT CK_Productos_Stock CHECK (Stock IS NOT NULL AND Stock >= 0),
 CONSTRAINT CK_Productos_Precio CHECK (Precio IS NOT NULL AND Precio >= 0)
);
CREATE TABLE dbo.AuditoriaInventario (
 IdAuditoria INT PRIMARY KEY IDENTITY,
 IdProducto INT, Accion NVARCHAR(10), Fecha DATETIME DEFAULT GETDATE()
);
-- Sin FK a Productos: la auditoría debe conservar las bajas.
GO
CREATE PROCEDURE dbo.sp_AltaProducto
 @Nombre NVARCHAR(100), @Stock INT, @Precio DECIMAL(10,2)
AS
BEGIN
 SET NOCOUNT ON;
 BEGIN TRY
  IF @Nombre IS NULL OR LEN(LTRIM(RTRIM(@Nombre)))=0
   THROW 50001, 'El nombre no puede estar vacío.', 1;
  IF @Stock IS NULL OR @Stock < 0 THROW 50002, 'El stock debe ser no negativo.', 1;
  IF @Precio IS NULL OR @Precio < 0 THROW 50003, 'El precio debe ser no negativo.', 1;
  INSERT dbo.Productos(Nombre,Stock,Precio) VALUES(@Nombre,@Stock,@Precio);
  PRINT 'Producto insertado correctamente.';
 END TRY
 BEGIN CATCH
  PRINT 'Error al insertar el producto: ' + ERROR_MESSAGE();
  THROW;
 END CATCH
END;
GO
CREATE TRIGGER dbo.trg_Auditoria_AltaProducto ON dbo.Productos AFTER INSERT
AS
BEGIN
 SET NOCOUNT ON;
 INSERT dbo.AuditoriaInventario(IdProducto,Accion)
 SELECT IdProducto,'INS' FROM inserted;
END;
GO
CREATE TRIGGER dbo.trg_Auditoria_BajaProducto ON dbo.Productos AFTER DELETE
AS
BEGIN
 SET NOCOUNT ON;
 INSERT dbo.AuditoriaInventario(IdProducto,Accion)
 SELECT IdProducto,'DEL' FROM deleted;
END;
GO
CREATE PROCEDURE dbo.sp_BajaProducto @IdProducto INT
AS
BEGIN
 SET NOCOUNT ON;
 BEGIN TRY
  IF @IdProducto IS NULL OR @IdProducto <= 0
   THROW 50004, 'El identificador debe ser positivo.', 1;
  -- DELETE y @@ROWCOUNT evitan separar la comprobación de la operación.
  DELETE dbo.Productos WHERE IdProducto=@IdProducto;
  IF @@ROWCOUNT=0 PRINT 'Producto no existe.';
  ELSE PRINT 'Producto eliminado correctamente.';
 END TRY
 BEGIN CATCH
  PRINT 'Error al eliminar el producto: ' + ERROR_MESSAGE();
  THROW;
 END CATCH
END;
GO
