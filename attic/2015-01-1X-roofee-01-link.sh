#!/bin/bash
#
# 2015-01-15 [+] make softlink-based tag cloud (-;
#

PHOTODIR=/home/user/photo/alb/photo/2012/
#PHOTODIR=/home/user/photo/alb/mobile/
#PHOTODIR=/home/user/photo/alb/
#RUBRDIR=/tmp/rubrdir
RUBRDIR=/dev/shm/rubrdir
#ERRORLOG=$RUBRDIR/error.log
#ERRORLOG=/tmp/rubrdirerror.log
ERRORLOG=/dev/null

## [ -f "$ERRORLOG" ] && rm $ERRORLOG

[ -d "$PHOTODIR" ] || exit

[ -d "$RUBRDIR" ] && rm -rf "$RUBRDIR"
[ -d "$RUBRDIR" ] || mkdir -p "$RUBRDIR"

TIME_BEFORE=`date +%Y.%m.%d.%H.%M.%S`
TS1=$(date +%s)

TOTAL_FILE_COUNT=0
TOTAL_LINK_COUNT=0
TOTAL_TAG_COUNT=0

find "$PHOTODIR" -type f -name '*' | while read _filename ; do
  _ext="${_filename##*.}"
  _name=$(basename "$_filename")

  #echo "$_ext $_name $_filename"
  #TOTAL_FILE_COUNT=$(expr $TOTAL_FILE_COUNT + 1)
  #echo $TOTAL_FILE_COUNT
  #continue
  case "${_ext}" in
    [jJ][pP][gG] | [jJ][pP][eE][gG] )
      TOTAL_FILE_COUNT=$(expr $TOTAL_FILE_COUNT + 1)
      tagdir=$RUBRDIR/JPG/_
      [ -d "$tagdir" ] || mkdir -p "$tagdir"
      [ -f "$tagdir/$_name" ] || ln -s "$_filename" "$tagdir/$_name"
      TOTAL_LINK_COUNT=$(expr $TOTAL_LINK_COUNT + 1)
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
        tagdir=$RUBRDIR/$cam/_
        [ -d "$tagdir" ] || mkdir -p "$tagdir"
        [ -f "$tagdir/$_name" ] || ln -s "$_filename" "$tagdir/$_name"
        TOTAL_LINK_COUNT=$(expr $TOTAL_LINK_COUNT + 1)

        tagdir=$RUBRDIR/JPG/$cam/_
        [ -d "$tagdir" ] || mkdir -p "$tagdir"
        [ -f "$tagdir/$_name" ] || ln -s "$_filename" "$tagdir/$_name"
        TOTAL_LINK_COUNT=$(expr $TOTAL_LINK_COUNT + 1)
      fi
      ;;

    [dD][nN][gG] | [pP][eE][fF] | [nN][eE][fF])
      TOTAL_FILE_COUNT=$(expr $TOTAL_FILE_COUNT + 1)
      tagdir=$RUBRDIR/RAW/_
      [ -d "$tagdir" ] || mkdir -p "$tagdir"
      [ -f "$tagdir/$_name" ] || ln -s "$_filename" "$tagdir/$_name"
      TOTAL_LINK_COUNT=$(expr $TOTAL_LINK_COUNT + 1)
      ;;
    *)
      echo "No action for $_filename" >> "$ERRORLOG"
      ;;
  esac

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

RUBRSIZE=`du -sh $RUBRDIR`
PHOTOSIZE=`du -sh $PHOTODIR`

echo "Tag"
find "$RUBRDIR" -type d -name '*' | while read _rubrname ; do
  filecount=`ls "$_rubrname" | wc -l`
  echo "  '$(basename "$_rubrname")': $filecount "
  TOTAL_TAG_COUNT=$(expr $TOTAL_TAG_COUNT + $filecount)
done

echo ""
echo "Complete at $TIME_DIFF $TIME_UNIT ($TIME_BEFORE..$TIME_AFTER)"
echo ""
echo "File count : $TOTAL_FILE_COUNT"
echo "Link count : $TOTAL_LINK_COUNT"
echo "Tag count : $TOTAL_TAG_COUNT"
echo "Data size  : $PHOTOSIZE"
echo "Index size : $RUBRSIZE"
echo ""


