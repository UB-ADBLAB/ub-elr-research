#!/bin/bash


mkdir -p out

REGULAR_SUBST='
        /<!-- @HEADER@ -->/{
            r contents/header.html
            d
        }
'

for i in pages/*.html; do
    echo $i
    BASENAME="`basename "$i"`"
    
    sed "$REGULAR_SUBST" "pages/$BASENAME" > out/"$BASENAME"
done

mkdir -p out.tmp

for i in contents/prjs/*; do
    S="`basename $i`"
    case "$S" in
        sp*)
            SEMESTER="Spring 20`echo "$S" | sed 's/^sp//'`";;
        fa*)
            SEMESTER="Fall 20`echo "$S" | sed 's/^fa//'`";;
        *)
            SEMESTER="$S"
    esac
    rm -f "out.tmp/${S}_prjids.txt"
    rm -f "out.tmp/${S}_prj_list.txt"
    for j in contents/prjs/$S/*; do
        ID="$(grep '^ID=' $j | head -n 1 | sed 's/^ID=\([0-9]*\).*$/\1/')"
        TITLE="$(grep '^TITLE=' $j | head -n 1 | sed 's/^TITLE=[ \t]*//' | sed 's/\//\\\//g')"
        KEYWORDS="$(grep '^KEYWORDS=' $j | head -n 1 | sed 's/^KEYWORDS=[ \t]*//' | sed 's/\//\\\//g')"
        MENTORS="$(grep '^MENTORS=' $j | head -n 1 | sed 's/^MENTORS=[ \t]*//' | sed 's/\//\\\//g')"
        echo "$ID" >> out.tmp/${S}_prjids.txt
        echo "$ID - $TITLE (mentored by $MENTORS)" >> out.tmp/${S}.prj_list.txt
        
        DESC="$(sed -n '
            /^DESC_START/,/^DESC_END/ {
                /^\(DESC_START\|DESC_END\)/d
                p
            }
        ' $j)"
        DETAILS="$(sed -n '
            /^DESC_MORE_DETAILS_START/,/^DESC_MORE_DETAILS_END/ {
                /^\(DESC_MORE_DETAILS_START\|DESC_MORE_DETAILS_END\)/d
                p
            }
        ' $j)"
         
        echo "$DESC" > "out.tmp/${S}_${ID}_desc.txt"
        echo "$DETAILS" > "out.tmp/${S}_${ID}_details.txt"
        
        cd out.tmp
        sed -e "s/<!-- @PRJ_ID@ -->/$ID/" \
            -e "s/<!-- @PRJ_TITLE@ -->/$TITLE/" \
            -e "s/<!-- @MENTORS@ -->/$MENTORS/" \
            -e "s/<!-- @KEYWORD@ -->/$KEYWORDS/" \
            -e "/<!-- @SHORTDESC@ -->/{
                r ${S}_${ID}_desc.txt
                d
            }" \
            -e "/<!-- @LONGDESC@ -->/{
                r ${S}_${ID}_details.txt
                d
            }" \
            ../templates/prj_item.html > "${S}_${ID}.html"
        cd ..
    done
    cat `sort -n "out.tmp/${S}_prjids.txt" | sed -e "s/^/out.tmp\/${S}_/" -e "s/$/.html/"` \
        > "out.tmp/${S}_prj_cat.html"
    sed -e "$REGULAR_SUBST" \
        -e "/<!-- @PRJS@ -->/{
            r out.tmp/${S}_prj_cat.html
            d
        }" \
        -e "s/<!-- @SEMESTER@ -->/${SEMESTER}/" \
        templates/prj.html > out/prj_${S}.html
done

