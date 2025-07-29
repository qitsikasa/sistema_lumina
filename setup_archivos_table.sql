-- Crear tabla de archivos
CREATE TABLE IF NOT EXISTS archivos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nombre VARCHAR NOT NULL,
  nombre_original VARCHAR NOT NULL,
  tipo VARCHAR NOT NULL,
  tamano INTEGER NOT NULL,
  url_storage VARCHAR NOT NULL,
  usuario_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  materia_id UUID,
  grupo_id UUID,
  descripcion TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear índices para mejorar el rendimiento
CREATE INDEX IF NOT EXISTS idx_archivos_usuario_id ON archivos(usuario_id);
CREATE INDEX IF NOT EXISTS idx_archivos_materia_id ON archivos(materia_id);
CREATE INDEX IF NOT EXISTS idx_archivos_grupo_id ON archivos(grupo_id);
CREATE INDEX IF NOT EXISTS idx_archivos_tipo ON archivos(tipo);
CREATE INDEX IF NOT EXISTS idx_archivos_created_at ON archivos(created_at);

-- Habilitar RLS
ALTER TABLE archivos ENABLE ROW LEVEL SECURITY;

-- Políticas RLS para archivos
-- Permitir lectura a todos los usuarios autenticados
CREATE POLICY "Permitir lectura de archivos a usuarios autenticados" ON archivos
  FOR SELECT USING (auth.role() = 'authenticated');

-- Permitir inserción solo a usuarios autenticados
CREATE POLICY "Permitir inserción de archivos a usuarios autenticados" ON archivos
  FOR INSERT WITH CHECK (auth.uid() = usuario_id);

-- Permitir actualización solo al propietario del archivo
CREATE POLICY "Permitir actualización de archivos al propietario" ON archivos
  FOR UPDATE USING (auth.uid() = usuario_id);

-- Permitir eliminación solo al propietario del archivo
CREATE POLICY "Permitir eliminación de archivos al propietario" ON archivos
  FOR DELETE USING (auth.uid() = usuario_id);

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_archivos_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para actualizar updated_at
CREATE TRIGGER update_archivos_updated_at_trigger
  BEFORE UPDATE ON archivos
  FOR EACH ROW
  EXECUTE FUNCTION update_archivos_updated_at();

-- Comentarios sobre la tabla
COMMENT ON TABLE archivos IS 'Tabla para almacenar información de archivos subidos por los usuarios';
COMMENT ON COLUMN archivos.nombre IS 'Nombre único del archivo en storage';
COMMENT ON COLUMN archivos.nombre_original IS 'Nombre original del archivo subido por el usuario';
COMMENT ON COLUMN archivos.tipo IS 'Tipo de archivo (PDF, DOC, XLS, etc.)';
COMMENT ON COLUMN archivos.tamano IS 'Tamaño del archivo en bytes';
COMMENT ON COLUMN archivos.url_storage IS 'URL pública del archivo en Supabase Storage';
COMMENT ON COLUMN archivos.usuario_id IS 'ID del usuario que subió el archivo';
COMMENT ON COLUMN archivos.materia_id IS 'ID de la materia asociada (opcional)';
COMMENT ON COLUMN archivos.grupo_id IS 'ID del grupo asociado (opcional)';
COMMENT ON COLUMN archivos.descripcion IS 'Descripción opcional del archivo';

-- Insertar algunos archivos de ejemplo (sin referencias a tablas que pueden no existir)
INSERT INTO archivos (nombre, nombre_original, tipo, tamano, url_storage, usuario_id, descripcion) VALUES
('ejemplo1.pdf', 'Apuntes de Algebra Lineal.pdf', 'PDF', 2500000, 'https://ejemplo.com/archivo1.pdf', (SELECT id FROM auth.users LIMIT 1), 'Apuntes completos de algebra lineal'),
('ejemplo2.png', 'Diagrama de Flujo Proyecto.png', 'PNG', 800000, 'https://ejemplo.com/archivo2.png', (SELECT id FROM auth.users LIMIT 1), 'Diagrama de flujo del proyecto final'),
('ejemplo3.xlsx', 'Presupuesto Semestral.xlsx', 'XLSX', 1200000, 'https://ejemplo.com/archivo3.xlsx', (SELECT id FROM auth.users LIMIT 1), 'Presupuesto detallado del semestre'),
('ejemplo4.zip', 'Recursos de Programacion.zip', 'ZIP', 15000000, 'https://ejemplo.com/archivo4.zip', (SELECT id FROM auth.users LIMIT 1), 'Recursos y codigos de programacion')
ON CONFLICT DO NOTHING; 