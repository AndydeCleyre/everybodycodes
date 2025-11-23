USING: combinators.syntax interpolate io.encodings.utf8 io.files
kernel make math math.order sequences splitting unicode ;
IN: everybodycodes.2025.06

: get-input ( part# -- notes )
  I"vocab:everybodycodes/2025/06/everybody_codes_e2025_q06_p${}.txt"
  utf8 file-contents ;

: count-pairs ( notes novice-char -- #pairs )
  &[
    '[ _ = ] split-when but-last |
    ch>upper '[ [ _ = ] count ] map
  ] 0 [ + ] accumulate* sum ;

: part1 ( -- #pairs )
  1 get-input
  CHAR: a count-pairs ;

: part2 ( -- #pairs )
  2 get-input
  CHAR: a CHAR: b CHAR: c [ '[ _ count-pairs ] ] tri@
  tri + + ;

:: count-pairs* ( expanded-notes novice-char -- #pairs )
  novice-char ch>upper               :> mentor-char
  novice-char expanded-notes indices :> novice-indices
  expanded-notes length 1 -          :> max-index
  novice-indices [
    &[ 1,000 - 0 max | 1,001 + max-index min ]
    expanded-notes <slice>
    [ mentor-char = ] count
  ] map-sum ;

! I suspect I shouldn't be expanding this literally.
! Hopefully I'll replace this with something faster and smarter.
: part3 ( -- #pairs )
  3 get-input
  '[ 1,000 [ _ % ] times ] "" make
  CHAR: a CHAR: b CHAR: c [ '[ _ count-pairs* ] ] tri@
  tri + + ;
