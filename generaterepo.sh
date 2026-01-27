#!/bin/sh

# Limpieza y preparación
echo 'VasakOS: Preparando repositorio'
rm -rf ./output
mkdir -p ./output/pool
mkdir -p ./output/dists/vasakos/main/binary-all

# Copiar .deb al repositorio
echo 'VasakOS: Copiando paquetes'
cp debinstall/*.deb ./output/pool/

# Cambiar a directorio
cd ./output/pool

# Generar índice de paquetes
echo 'VasakOS: Generando índice de paquetes'
dpkg-scanpackages . /dev/null | gzip -9c > ../dists/vasakos/main/binary-all/Packages.gz
dpkg-scanpackages . /dev/null > ../dists/vasakos/main/binary-all/Packages

cd ../..

# Generar archivo Release
echo 'VasakOS: Generando archivo Release'
cat > ./output/dists/vasakos/Release << 'EOF'
Origin: VasakOS
Label: VasakOS
Suite: vasakos
Codename: vasakos
Architectures: amd64 arm64 armhf
Components: main
Description: VasakOS Repository
Date: $(date -R)
EOF

# Firmar el repositorio con GPG
echo 'VasakOS: Firma de Repositorio'
expect -c "spawn gpg2 --edit-key 307E04B769840811099F4077ED5D59DA704DEBE2 trust quit; send \"5\ry\r\"; expect eof" 2>/dev/null || true

# Crear Release.gpg (firma detachada)
echo 'VasakOS: Generando firma GPG'
gpg2 --default-key 307E04B769840811 --detach-sign --armor ./output/dists/vasakos/Release || true


echo ''
echo 'VasakOS: Repositorio generado exitosamente en carpeta "output"'
echo ''
echo 'Estructura generada:'
tree -L 3 ./output/ 2>/dev/null || find ./output -type f -o -type d | sort
echo ''
echo 'Paquetes en repositorio:'
ls -1 ./output/pool/*.deb | wc -l
echo 'paquetes encontrados'
echo ''
echo 'Contenido de Packages (primeras líneas):'
head -30 ./output/dists/vasakos/main/binary-all/Packages


