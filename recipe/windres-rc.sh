#!/bin/sh
# Taken and adapted from:
# https://github.com/jgaskins/crystal/blob/614aea7ec62ed426602b2a86fbbda789dc969a47/etc/win-ci/windres-rc.sh

# Minimal wrapper for Microsoft rc.exe

# The build will call something like:
#
#   libtool: compile:  $windres
#     -DPACKAGE_VERSION_STRING=\"0.22.5\" 
#     -DPACKAGE_VERSION_MAJOR=0 
#     -DPACKAGE_VERSION_MINOR=22 
#     -DPACKAGE_VERSION_SUBMINOR=5 
#     -i ./libintl.rc 
#     --output-format=coff  
#     -o .libs/libintl.res.obj
#
# the corresponding rc.exe invocation is:
#
#     rc.exe /NOLOGO 
#       -DPACKAGE_VERSION_STRING=\"0.22.5\" 
#       -DPACKAGE_VERSION_MAJOR=0 
#       -DPACKAGE_VERSION_MINOR=22 
#       -DPACKAGE_VERSION_SUBMINOR=5 
#       /FO .libs/libintl.res.obj libintl.rc

RC=$1
input=
output=
defines=""

while [ $# -gt 0 ]; do
  case $1 in
    -D* | -d*)
      defines="$1 ${defines}"
      shift
      ;;
    -i)
      shift
      input=$1
      shift
      ;;
    -o)
      shift
      output=$1
      shift
      ;;
    *)
      # ignore --output-format=coff as it is the default already
      shift
      ;;
  esac
done

exec rc.exe -NOLOGO $defines -FO "$output" "$input"
