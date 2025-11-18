USING: accessors arrays combinators.syntax interpolate
io.encodings.utf8 io.files kernel math math.functions
math.matrices math.order math.parser math.vectors sequences
splitting sequences.extras ;
IN: everybodycodes.2025.02

: get-input ( part# -- c )
  I"vocab:everybodycodes/2025/02/everybody_codes_e2025_q02_p${}.txt"
  utf8 file-contents

  "[,]" split
  { 1 2 } nths-of
  [ string>number ] map ;

: c* ( c1 c2 -- c3 )
  2 n&[
    v* first2 - |
    reverse v* sum
  ] 2array ;

: c/ ( c1 c2 -- c3 )
  v/ [ truncate ] map ;

: part1-step ( c result divisor-size -- result' )
  [ dup c* ] dip
  dup 2array c/
  v+ ;

: part1 ( -- result )
  1 get-input { 0 0 }
  [ dupd 10 part1-step ]
  3 swap times nip ;

TUPLE: point coords result ;
: <point> ( coords -- point )
  point new
  swap >>coords
  { 0 0 } >>result ;

: check-point-step ( point -- point'/f )
  dup &[ coords>> | result>> ] 100_000 part1-step
  dup [ -1_000_000 1_000_000 between? ] all?
  [ >>result ] [ 2drop f ] if ;

: engrave? ( point -- ? )
  100 swap
  [ over 0 > ] [
    check-point-step
    dup [ [ 1 - ] dip ] [ nip 0 swap ] if
  ] while nip >boolean ;

:: part2-matrix ( size -- matrix )
  1_000 size 1 - / :> step
  size <cartesian-square-indices>
  2 get-input
  '[ reverse { step step } v* _ v+ <point> ] matrix-map ;

: (part2) ( size -- #points )
  part2-matrix [ engrave? ] matrix-map
  ! visualize:
  ! dup [ [ f = " " "." ? ] map-concat ] map [ print ] each
  [ sift ] map-concat length ;

: part2 ( -- #points )
  101 (part2) ;

: part3 ( -- #points )
  ! This works but is slow enough to confirm there's a much better way.
  1_001 (part2) ;
