USING: accessors arrays combinators combinators.syntax
interpolate io.encodings.utf8 io.files kernel math math.order
math.parser math.statistics sequences sequences.extras
sorting.specification splitting ;
IN: everybodycodes.2025.05

TUPLE: sword id nums quality scores ;
: <sword> ( id nums -- sword )
  sword new &[ nums<< | id<< | ] ;

: get-input ( part# -- swords )
  I"vocab:everybodycodes/2025/05/everybody_codes_e2025_q05_p${}.txt"
  utf8 file-lines [
    ":," split [ string>number ] map
    &[ first | rest ] <sword>
  ] map ;

TUPLE: rung left center right ;
: <rung> ( center -- rung )
  rung new swap >>center ;

: insert-into-rung? ( n rung -- ? )
  2dup center>> <=> {
    { +lt+ [ dup  left>> [ 2drop f ] [  left<< t ] if ] }
    { +gt+ [ dup right>> [ 2drop f ] [ right<< t ] if ] }
    { +eq+ [ 2drop f ] }
  } case ;

: insert-into-existing-rung? ( rungs n -- ? )
  swap [ insert-into-rung? ] with find drop >boolean ;

: insert-or-append! ( rungs n -- )
  2dup insert-into-existing-rung?
  [ drop ] [ <rung> suffix! ] if drop ;

: nums>rungs ( nums -- rungs )
  V{ } clone swap dupd
  [ insert-or-append! ] with each ;

: rungs>quality ( rungs -- n )
  [ center>> number>string ] map-concat string>number ;

: sword>quality ( sword -- n )
  nums>> nums>rungs rungs>quality ;

: part1 ( -- quality )
  1 get-input first sword>quality ;

: part2 ( -- quality-difference )
  2 get-input [ sword>quality ] map
  minmax swap - ;

: rung>score ( rung -- n )
  &[ left>> | center>> | right>> ]
  3array sift [ number>string ] map-concat string>number ;

: complete-sword ( sword -- sword' )
  dup nums>> nums>rungs &[
    rungs>quality >>quality |
    [ rung>score ] map >>scores
  ] ;

: part3 ( -- quality-difference )
  3 get-input [ complete-sword ] map
  { { quality>> >=< } { scores>> >=< } { id>> >=< } } sort-with-spec
  [ *[ id>> | 1 + ] * ] map-index sum ;
