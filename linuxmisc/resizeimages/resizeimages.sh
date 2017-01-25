#! /bin/bash
# vim:ts=4:sw=4:et:ft=sh
# Redimensionar imágenes. Usar como parámetro de find.
# Created: 2017-01-25

# Copyright (c) 2017: Hilario J. Montoliu <hmontoliu@gmail.com>
 
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2 of the License, or (at your
# option) any later version.  See http://www.gnu.org/copyleft/gpl.html for
# the full text of the license.

cIMAGEN="$1"

MAXALTO=1300
MAXANCHO=1300

# debug 
TEMPORAL=$(mktemp -d)
echo $TEMPORAL

getsize () {
    # obtenemos ancho y alto de la imagen 
    IMAGEN="$1"
    identify -format "%w %h" "$IMAGEN"
}

escalarimagenalto () {
    IMAGEN=$1
    convert -geometry x${MAXALTO} "$IMAGEN" "$TEMPORAL/$(basename $IMAGEN)"
    mv "$TEMPORAL/$(basename $IMAGEN)" "$IMAGEN"
    }

escalarimagenancho () {
    IMAGEN=$1
    convert -geometry ${MAXANCHO}x "$IMAGEN" "$TEMPORAL/$(basename $IMAGEN)"
    mv "$TEMPORAL/$(basename $IMAGEN)" "$IMAGEN"
    }

read ANCHO ALTO <<<$(getsize $1)

if (($MAXANCHO<$ANCHO)); then
    escalarimagenancho "$cIMAGEN"
    rm -f "TEMPORAL"
elif (($MAXALTO<$ALTO)); then
    escalarimagenalto "$cIMAGEN"
    rm -f "TEMPORAL"
fi

