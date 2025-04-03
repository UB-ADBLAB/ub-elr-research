#!/bin/bash


mkdir -p out

REGULAR_SUBST='
        /<!-- @HEADER@ -->/{
            r contents/header.html
            d
        }
'

for i in pages/*.html; do
    echo "Processing page $i"
    BASENAME="`basename "$i"`"
    
    sed "$REGULAR_SUBST" "pages/$BASENAME" > out/"$BASENAME"
done

mkdir -p out.tmp

MARKDOWN="markdown_py -x markdown3_newtab"

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
    echo "Processing semester $SEMESTER ($S)"
    rm -f "out.tmp/${S}_prjids.txt"
    rm -f "out.tmp/${S}_prj_list.txt"
    PRJLIST="`find "contents/prjs/$S" -name '*.txt' | sort`"
    if [ -n "$PRJLIST" ]; then
        for j in $PRJLIST; do
            echo "Processing project $j"
            ID="$(grep '^ID=' $j | head -n 1 | sed 's/^ID=\([0-9]*\).*$/\1/')"
            TITLE="$(grep '^TITLE=' $j | head -n 1 | sed 's/^TITLE=[ \t]*//' | sed 's/\//\\\//g')"
            KEYWORDS="$(grep '^KEYWORDS=' $j | head -n 1 | sed 's/^KEYWORDS=[ \t]*//' | sed 's/\//\\\//g')"
            MENTORS="$(grep '^MENTORS=' $j | head -n 1 | sed 's/^MENTORS=[ \t]*//' | sed 's/\//\\\//g')"
            CAPACITY="$(grep '^CAPACITY=' $j | head -n 1 | sed 's/^CAPACITY=[ \t]*//' | sed 's/\//\\\//g' )"
            echo "$ID" >> out.tmp/${S}_prjids.txt
            echo "$ID - $TITLE (mentored by $MENTORS)" | sed 's/\\//g' | sed 's/<[^<>]*>//g' >> out.tmp/${S}_prj_list.txt
            
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
             
            echo "$DESC" | $MARKDOWN > "out.tmp/${S}_${ID}_desc.txt"
            echo "$DETAILS" | $MARKDOWN > "out.tmp/${S}_${ID}_details.txt"
            
            cd out.tmp
            sed -e "s/<!-- @PRJ_ID@ -->/$ID/" \
                -e "s/<!-- @PRJ_TITLE@ -->/$TITLE/" \
                -e "s/<!-- @MENTORS@ -->/$MENTORS/" \
                -e "s/<!-- @KEYWORD@ -->/$KEYWORDS/" \
                -e "s/<!-- @CAPACITY@ -->/$CAPACITY/" \
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
    else
        touch "out.tmp/${S}_prjids.txt"
        touch "out.tmp/${S}_prj_list.txt"
        touch "out.tmp/${S}_prj_cat.html"
    fi
    sed -e "$REGULAR_SUBST" \
        -e "/<!-- @PRJS@ -->/{
            r out.tmp/${S}_prj_cat.html
            d
        }" \
        -e "s/<!-- @SEMESTER@ -->/${SEMESTER}/" \
        templates/prj.html > out/prj_${S}.html
done

echo "Copying images..."
mkdir -p out/imgs
cp contents/imgs/* out/imgs

echo "Copying files..."
mkdir -p out/files
cp contents/files/* out/files

