-- Ampliación propuesta para cubrir menciones de la rúbrica.
-- INSTEAD OF reemplaza la operación; no es un trigger BEFORE.
CREATE TRIGGER dbo.trg_Validar_Actualizacion ON dbo.Productos INSTEAD OF UPDATE
AS
BEGIN
 SET NOCOUNT ON;
 IF EXISTS(SELECT 1 FROM inserted WHERE Nombre IS NULL OR LEN(LTRIM(RTRIM(Nombre)))=0
  OR Stock IS NULL OR Stock<0 OR Precio IS NULL OR Precio<0)
  THROW 50005, 'Actualización rechazada: nombre, stock o precio inválidos.', 1;
 UPDATE p SET Nombre=i.Nombre, Stock=i.Stock, Precio=i.Precio
 FROM dbo.Productos p JOIN inserted i ON p.IdProducto=i.IdProducto;
END;
GO
CREATE TRIGGER dbo.trg_Auditoria_ActualizarProducto ON dbo.Productos AFTER UPDATE
AS
BEGIN
 SET NOCOUNT ON;
 -- Condicional: no registrar una actualización sin cambios efectivos.
 INSERT dbo.AuditoriaInventario(IdProducto,Accion)
 SELECT i.IdProducto,'UPD' FROM inserted i JOIN deleted d ON i.IdProducto=d.IdProducto
 WHERE i.Nombre<>d.Nombre OR i.Stock<>d.Stock OR i.Precio<>d.Precio;
END;
GO
CREATE PROCEDURE dbo.sp_ConsultarInventarioCursor
AS
BEGIN
 SET NOCOUNT ON;
 DECLARE @Id INT,@Nombre NVARCHAR(100),@Stock INT;
 -- Demostración académica de recorrido. Para listar inventario se prefiere SELECT.
 DECLARE inventario CURSOR LOCAL FAST_FORWARD FOR
 SELECT IdProducto,Nombre,Stock FROM dbo.Productos ORDER BY IdProducto;
 BEGIN TRY
  OPEN inventario;
  FETCH NEXT FROM inventario INTO @Id,@Nombre,@Stock;
  WHILE @@FETCH_STATUS=0
  BEGIN
   PRINT CONCAT('ID=',@Id,'; Nombre=',@Nombre,'; Stock=',@Stock);
   FETCH NEXT FROM inventario INTO @Id,@Nombre,@Stock;
  END;
  CLOSE inventario;
  DEALLOCATE inventario;
 END TRY
 BEGIN CATCH
  IF CURSOR_STATUS('local','inventario')>=0 CLOSE inventario;
  IF CURSOR_STATUS('local','inventario')>=-1 DEALLOCATE inventario;
  THROW;
 END CATCH
END;
GO
