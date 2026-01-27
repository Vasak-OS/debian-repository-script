#!/bin/sh

# Configuracion de reprepro
echo 'VasakOS: Se Configura reprepro'
mkdir ./pkgs/
mkdir ./pkgs/debs/
mkdir ./pkgs/debs/conf
touch ./pkgs/debs/conf/{option,distributions}
echo 'Codename: vasakos' >> pkgs/debs/conf/distributions
echo 'Components: main' >> pkgs/debs/conf/distributions
echo 'Architectures: amd64 arm64 armhf' >> pkgs/debs/conf/distributions
echo 'SignWith: 307E04B769840811' >> pkgs/debs/conf/distributions

# Revisando clave
echo -e "VasakOS: Firma de Repositorio"
expect -c "spawn gpg2 --edit-key 307E04B769840811099F4077ED5D59DA704DEBE2 trust quit; send \"5\ry\r\"; expect eof"

# generation of new deb repository
echo 'VasakOS: Inicio de Configuracion del Repo'
reprepro -V -b pkgs/debs includedeb vasakos debinstall/*deb
echo 'VasakOS: Fin de Configuracion del Repo'

ls pkgs/debs/dists/vasakos/main


