USING: interpolate io.encodings.utf8 io.files kernel math
math.functions math.parser sequences splitting ;
IN: everybodycodes.events.2026.quest_01

: get-input ( part# -- notes )
  I"vocab:everybodycodes/events/2026/quest_01/input/input_p${}.txt"
  utf8 file-contents ;

: initial-outposts ( part# -- outposts )
  get-input
  "," split
  [ string>number ] map ;

: #cones-total-needed-1 ( #enchanted-cones -- #total-needed )
  sqrt ceiling >integer sq ;

MEMO: #cones-more-needed-1 ( #enchanted-cones -- #new-cones )
  [ #cones-total-needed-1 ] keep - ;

: part-1 ( -- #new-cones )
  1 initial-outposts
  [ #cones-more-needed-1 ] map-sum ;

: 4ish-ceiling ( n -- n' )
  [ dup 4 divisor? ] [ 1 + ] until ;

: floor-and-difference ( #enchanted-cones quot: ( #enchanted-cones -- #total-needed ) -- #new-cones )
  '[ dup 8 <= [ drop 8 ] _ if ] keep - ; inline

MEMO: #cones-more-needed-2 ( #enchanted-cones -- #new-cones )
  [ 4ish-ceiling ] floor-and-difference ;

: part-2 ( -- #new-cones )
  2 initial-outposts
  [ #cones-more-needed-2 ] map-sum ;

: #cones-total-needed-3 ( #enchanted-cones -- #total-needed )
  sqrt [ ceiling ] keep
  dupd number= [ 1 + ] when
  >integer [ even? ] [ 1 + ] 1when
  sq 1 - ;

MEMO: #cones-more-needed-3 ( #enchanted-cones -- #new-cones )
  [ #cones-total-needed-3 ] floor-and-difference ;

: part-3 ( -- #new-cones )
  3 initial-outposts
  [ #cones-more-needed-3 ] map-sum ;
