-- Crear tabla de archivos (versión simple)
CREATE TABLE IF NOT EXISTS archivos (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  nombre VARCHAR NOT NULL,
  nombre_original VARCHAR NOT NULL,
  tipo VARCHAR NOT NULL,
  tamano INTEGER NOT NULL,
  url_storage VARCHAR NOT NULL,
  usuario_id UUID NOT NULL,
  materia_id UUID,
  grupo_id UUID,
  descripcion TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Crear índices básicos
CREATE INDEX IF NOT EXISTS idx_archivos_usuario_id ON archivos(usuario_id);
CREATE INDEX IF NOT EXISTS idx_archivos_tipo ON archivos(tipo);
CREATE INDEX IF NOT EXISTS idx_archivos_created_at ON archivos(created_at);

-- Habilitar RLS
ALTER TABLE archivos ENABLE ROW LEVEL SECURITY;

-- Políticas RLS básicas
CREATE POLICY "Permitir lectura de archivos a usuarios autenticados" ON archivos
  FOR SELECT USING (auth.role() = 'authenticated');

CREATE POLICY "Permitir inserción de archivos a usuarios autenticados" ON archivos
  FOR INSERT WITH CHECK (auth.uid() = usuario_id);

CREATE POLICY "Permitir actualización de archivos al propietario" ON archivos
  FOR UPDATE USING (auth.uid() = usuario_id);

CREATE POLICY "Permitir eliminación de archivos al propietario" ON archivos
  FOR DELETE USING (auth.uid() = usuario_id);

-- Función para actualizar updated_at
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