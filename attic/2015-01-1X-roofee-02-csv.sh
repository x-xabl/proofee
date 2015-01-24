#!/bin/bash
#
# 2015-01-15 [+] make softlink-based tag cloud (-;
#

#PHOTODIR=/home/ark/photo/alb/photo/2012/
#PHOTODIR=/home/ark/photo/alb/mobile/
PHOTODIR=/home/ark/photo/alb/
#ROOFEE_CSV=/tmp/ROOFEE_CSV
ROOFEE_CSV=/dev/shm/roofee.csv
#ERRORLOG=$ROOFEE_CSV/error.log
#ERRORLOG=/tmp/ROOFEE_CSVerror.log
ERRORLOG=/dev/null

## [ -f "$ERRORLOG" ] && rm $ERRORLOG

[ -d "$PHOTODIR" ] || exit

[ -d "$ROOFEE_CSV" ] && rm "$ROOFEE_CSV"
[ -d "$ROOFEE_CSV" ] || touch "$ROOFEE_CSV"

TIME_BEFORE=`date +%Y.%m.%d.%H.%M.%S`
TS1=$(date +%s)

c=0
find "$PHOTODIR" -type f -name '*' | while read _filename ; do
  c=$(( $c + 1 ))
  _ext="${_filename##*.}"
  i=0
  line=()
  line[$i]="\"$_filename\""
  i=$(( $i + 1 ))

  case "${_ext}" in
    [jJ][pP][gG] | [jJ][pP][eE][gG] )
      line[$i]="JPG"
      i=$(( $i + 1 ))
      cam=`exiv2 "$_filename" 2>> $ERRORLOG | strings | grep Camera\ model | awk '{ print $4 " " $5 " " $6 " " $7 " " $8 " " $9 }'`
      cam=`echo $cam` # trim $cam variable
      case $cam in
        "PENTAX K-5")
          cam='K5';
          ;;
        "Canon EOS 5D Mark II")
          cam='5D';
          ;;
        "Canon EOS-1D Mark III")
          cam='1DM3';
          ;;
        "Canon EOS-1D Mark IV")
          cam='1DM4';
          ;;
        "Canon EOS 50D")
          cam='50D';
          ;;
        "Canon EOS 400D DIGITAL")
          cam='400D';
          ;;
        "Canon EOS 1000D")
          cam='1000D'
          ;;
        "Canon EOS 1100D")
          cam='1100D'
          ;;
        "Canon PowerShot SX110 IS")
          cam='SX110';
          ;;
        "6700c-1") # Nokia 6700
          cam='N6700';
          ;;
        "DMC-FZ28")
          cam='FZ28';
          ;;
        "FinePix F31fd")
          cam='F31';
          ;;
        "DSLR-A700") # Sony Alpha a700
          cam=A700;
          ;;
        "DSC-H20") # Sony DHC H-20
          cam=H20;
          ;;
        "COOLPIX S6150") # Nikon COOLPIX S6150
          cam=S6150;
          ;;
        "NIKON D3000")
          cam=D3000;
          ;;
        "NIKON D60")
          cam=D60;
          ;;
        "NIKON D7000")
          cam=D7000;
          ;;
        "HTC Sensation Z710e")
          cam=Z710e;
          ;;
        "Nexus 5")
          cam=Nexus5;
          ;;
        "GT-I8190")
          cam=GTI8190;
          ;;
        *)
          cam=''
          echo "No camera model for $_filename" >> "$ERRORLOG"
          ;;
      esac

      if [ ! -z "$cam" ] ; then
        line[$i]="$cam"
        i=$(( $i + 1 ))
      fi
      ;;

    [dD][nN][gG] | [pP][eE][fF] | [nN][eE][fF])
      line[$i]="RAW"
      i=$(( $i + 1 ))
      ;;
    *)
      echo "No action for $_filename" >> "$ERRORLOG"
      ;;
  esac


  cnt=${#line[@]}
  i=0
  while (( i < cnt )) ; do
    printf "%s," "${line[$i]}" >> $ROOFEE_CSV
    i=$(( $i + 1 ))
  done
  printf "\n" >> $ROOFEE_CSV

done

echo ""
echo ""
[ -f "$ERRORLOG" ] && tail -n 3 "$ERRORLOG"
echo ""
echo ""

TIME_AFTER=`date +%Y.%m.%d.%H.%M.%S`
TS2=$(date +%s)
TIME_DIFF=$(( $TS2 - $TS1 ))
TIME_UNIT="sec"

## TIME_DIFF=$(expr $TIME_DIFF / 60)
## TIME_UNIT="min"

ROOFEE_SIZE=`du -sh $ROOFEE_CSV`
PHOTOSIZE=`du -sh $PHOTODIR`

echo ""
echo "Complete at $TIME_DIFF $TIME_UNIT ($TIME_BEFORE..$TIME_AFTER)"
echo ""
echo "File count : $c"
echo "Data size  : $PHOTOSIZE"
echo "Index size : $ROOFEE_SIZE"
echo ""


