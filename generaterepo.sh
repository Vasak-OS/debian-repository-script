#!/bin/sh

# Limpieza y preparación
echo 'VasakOS: Preparando repositorio'
rm -rf ./output
mkdir -p ./output/debian/pool
mkdir -p ./output/debian/dists/vasakos/main/binary-amd64
mkdir -p ./output/debian/dists/vasakos/main/binary-all

# Copiar .deb al repositorio
echo 'VasakOS: Copiando paquetes'
cp debinstall/*.deb ./output/debian/pool/

# Generar índice de paquetes desde el directorio raíz
echo 'VasakOS: Generando índice de paquetes'
cd ./output/debian

# Generar índices para binary-amd64 (todos los paquetes)
dpkg-scanpackages -a amd64 pool /dev/null | gzip -9c > dists/vasakos/main/binary-amd64/Packages.gz
dpkg-scanpackages -a amd64 pool /dev/null > dists/vasakos/main/binary-amd64/Packages

# Generar índices para binary-all (solo paquetes Architecture: all)
dpkg-scanpackages -a all pool /dev/null | gzip -9c > dists/vasakos/main/binary-all/Packages.gz
dpkg-scanpackages -a all pool /dev/null > dists/vasakos/main/binary-all/Packages

cd ../..

# Generar archivo Release con hashes y metadatos
echo 'VasakOS: Generando archivo Release'

# Calcular hashes de los archivos Packages para binary-amd64
PACKAGES_AMD64="output/debian/dists/vasakos/main/binary-amd64/Packages"
PACKAGES_GZ_AMD64="output/debian/dists/vasakos/main/binary-amd64/Packages.gz"
MD5_AMD64=$(md5sum "$PACKAGES_AMD64" | awk '{print $1}')
MD5_GZ_AMD64=$(md5sum "$PACKAGES_GZ_AMD64" | awk '{print $1}')
SHA1_AMD64=$(sha1sum "$PACKAGES_AMD64" | awk '{print $1}')
SHA1_GZ_AMD64=$(sha1sum "$PACKAGES_GZ_AMD64" | awk '{print $1}')
SHA256_AMD64=$(sha256sum "$PACKAGES_AMD64" | awk '{print $1}')
SHA256_GZ_AMD64=$(sha256sum "$PACKAGES_GZ_AMD64" | awk '{print $1}')
SIZE_AMD64=$(stat -c%s "$PACKAGES_AMD64")
SIZE_GZ_AMD64=$(stat -c%s "$PACKAGES_GZ_AMD64")

# Calcular hashes de los archivos Packages para binary-all
PACKAGES_ALL="output/debian/dists/vasakos/main/binary-all/Packages"
PACKAGES_GZ_ALL="output/debian/dists/vasakos/main/binary-all/Packages.gz"
MD5_ALL=$(md5sum "$PACKAGES_ALL" | awk '{print $1}')
MD5_GZ_ALL=$(md5sum "$PACKAGES_GZ_ALL" | awk '{print $1}')
SHA1_ALL=$(sha1sum "$PACKAGES_ALL" | awk '{print $1}')
SHA1_GZ_ALL=$(sha1sum "$PACKAGES_GZ_ALL" | awk '{print $1}')
SHA256_ALL=$(sha256sum "$PACKAGES_ALL" | awk '{print $1}')
SHA256_GZ_ALL=$(sha256sum "$PACKAGES_GZ_ALL" | awk '{print $1}')
SIZE_ALL=$(stat -c%s "$PACKAGES_ALL")
SIZE_GZ_ALL=$(stat -c%s "$PACKAGES_GZ_ALL")

# Generar Release con formato correcto
cat > output/debian/dists/vasakos/Release << EOF
Origin: VasakOS
Label: VasakOS
Suite: vasakos
Codename: vasakos
Architectures: amd64 all
Components: main
Description: VasakOS Repository
Date: $(date -R -u)
MD5Sum:
 $MD5_AMD64 $(printf "%8d" $SIZE_AMD64) main/binary-amd64/Packages
 $MD5_GZ_AMD64 $(printf "%8d" $SIZE_GZ_AMD64) main/binary-amd64/Packages.gz
 $MD5_ALL $(printf "%8d" $SIZE_ALL) main/binary-all/Packages
 $MD5_GZ_ALL $(printf "%8d" $SIZE_GZ_ALL) main/binary-all/Packages.gz
SHA1:
 $SHA1_AMD64 $(printf "%8d" $SIZE_AMD64) main/binary-amd64/Packages
 $SHA1_GZ_AMD64 $(printf "%8d" $SIZE_GZ_AMD64) main/binary-amd64/Packages.gz
 $SHA1_ALL $(printf "%8d" $SIZE_ALL) main/binary-all/Packages
 $SHA1_GZ_ALL $(printf "%8d" $SIZE_GZ_ALL) main/binary-all/Packages.gz
SHA256:
 $SHA256_AMD64 $(printf "%8d" $SIZE_AMD64) main/binary-amd64/Packages
 $SHA256_GZ_AMD64 $(printf "%8d" $SIZE_GZ_AMD64) main/binary-amd64/Packages.gz
 $SHA256_ALL $(printf "%8d" $SIZE_ALL) main/binary-all/Packages
 $SHA256_GZ_ALL $(printf "%8d" $SIZE_GZ_ALL) main/binary-all/Packages.gz
EOF

# Firmar el repositorio con GPG
echo 'VasakOS: Firmando repositorio con GPG'
KEY_ID="307E04B769840811"

# Crear archivo InRelease (Release + firma integrada)
gpg2 --default-key $KEY_ID --clearsign --output output/debian/dists/vasakos/InRelease output/debian/dists/vasakos/Release

# Crear Release.gpg (firma detachada - backup)
gpg2 --default-key $KEY_ID --detach-sign --armor --output output/debian/dists/vasakos/Release.gpg output/debian/dists/vasakos/Release

echo 'VasakOS: Repositorio firmado exitosamente'


echo ''
echo 'VasakOS: Repositorio generado exitosamente en carpeta "output"'
echo ''
echo 'Estructura generada:'
tree -L 3 ./output/ 2>/dev/null || find ./output -type f -o -type d | sort
echo ''
echo 'Paquetes en repositorio:'
ls -1 ./output/debian/pool/*.deb 2>/dev/null | wc -l
echo 'paquetes encontrados'
echo ''
echo 'Contenido de Packages binary-amd64 (primeras líneas):'
head -30 ./output/debian/dists/vasakos/main/binary-amd64/Packages
echo ''
echo 'Contenido de Packages binary-all (primeras líneas):'
head -30 ./output/debian/dists/vasakos/main/binary-all/Packages


