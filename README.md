# Repositorio VasakOS Debian

Este es un repositorio Debian simple para instalar paquetes VasakOS.

## Instalación

### 1. Importar la clave GPG del repositorio
```bash
sudo gpg --keyserver keys.openpgp.org/ --recv-keys 307E04B769840811099F4077ED5D59DA704DEBE2
sudo gpg --export 307E04B769840811099F4077ED5D59DA704DEBE2 | sudo apt-key add -
```

### 2. Agregar el repositorio a tu sistema

Opción B: Si prefieres con verificación GPG:
```bash
echo "deb https://repo.vasak.net.ar/debian/ vasakos main" | sudo tee /etc/apt/sources.list.d/vasakos.list
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
│       ├── InRelease         # Release + firma integrada (IMPORTANTE)
│       ├── Release.gpg       # Firma detachada (backup)
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

### Error: "The repository is not signed"
El repositorio debe tener un archivo `InRelease` válido:
```bash
# Verificar que exista:
ls -l output/dists/vasakos/InRelease

# Si falta, regenera el repositorio:
./generaterepo.sh
```

### Error: "The following signatures couldn't be verified"
La clave GPG no está instalada en el sistema del usuario. Asegúrate de que siga los pasos 1 y 2 de instalación.

### Verificar la firma del repositorio (local)
```bash
gpg --verify output/dists/vasakos/InRelease
```

### Packages not found
Verifica que existan:
1. `Packages` y `Packages.gz` en `dists/vasakos/main/binary-all/`
2. `Release`, `InRelease` y `Release.gpg` en `dists/vasakos/`
3. Los permisos de lectura pública en el servidor web

## Actualizar el repositorio

Cuando quieras agregar nuevos paquetes:
1. Coloca los nuevos `.deb` en la carpeta `pool/`
2. Ejecuta: `dpkg-scanpackages pool/ /dev/null | gzip -9c > dists/vasakos/main/binary-all/Packages.gz`
3. Sube los cambios al servidor FTP