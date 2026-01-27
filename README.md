# Repositorio VasakOS Debian

Este es un repositorio Debian simple para instalar paquetes VasakOS.

## Instalación

### 1. Agregar la clave GPG (opcional, si usas firma)
```bash
wget -qO - https://repo.vasakos.net.ar/debian/vasakos-key.gpg | sudo apt-key add -
```

### 2. Agregar el repositorio a tu sistema

Opción A: Crear archivo de lista de repositorio:
```bash
echo "deb [trusted=yes] https://repo.vasakos.net.ar/debian/ vasakos main" | sudo tee /etc/apt/sources.list.d/vasakos.list
```

Opción B: Si prefieres con verificación GPG:
```bash
echo "deb https://repo.vasakos.net.ar/debian/ vasakos main" | sudo tee /etc/apt/sources.list.d/vasakos.list
```

### 3. Actualizar lista de paquetes
```bash
sudo apt update
```

### 4. Instalar paquetes
```bash
sudo apt install vasak-desktop vasak-desktop-settings vasakos-icons-settings
```

## Estructura del repositorio

```
output/
├── dists/
│   └── vasakos/
│       ├── Release           # Archivo de metadatos
│       └── main/
│           └── binary-all/
│               ├── Packages      # Índice de paquetes (texto)
│               └── Packages.gz   # Índice de paquetes (comprimido)
├── pool/                     # Carpeta con los archivos .deb
│   ├── vasak-desktop_*.deb
│   ├── vasak-desktop-settings_*.deb
│   └── vasakos-icons-settings_*.deb
└── README.md                # Este archivo

```

## Instrucciones para el servidor FTP

1. Sube toda la carpeta `output/` a tu servidor FTP
2. Asegúrate de que el contenido sea accesible públicamente
3. Cambia `https://tu-servidor.com/vasakos` por la URL real de tu servidor

Ejemplo con un servidor web:
- URL del repositorio: `https://repo.vasakos.net.ar/debian/`
- URL del Packages: `https://repo.vasakos.net.ar/debian/dists/vasakos/main/binary-all/Packages.gz`

## Solución de problemas

Si reciben errores de "Packages not found", verifica:
1. Que los archivos `Packages` y `Packages.gz` existan en el servidor
2. Que el archivo `Release` esté en la ubicación correcta
3. Que los permisos permitan lectura pública

## Actualizar el repositorio

Cuando quieras agregar nuevos paquetes:
1. Coloca los nuevos `.deb` en la carpeta `pool/`
2. Ejecuta: `dpkg-scanpackages pool/ /dev/null | gzip -9c > dists/vasakos/main/binary-all/Packages.gz`
3. Sube los cambios al servidor FTP