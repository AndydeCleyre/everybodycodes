USING: circular circular.private combinators.syntax interpolate
io.encodings.utf8 io.files kernel math math.order math.parser
sequences sequences.extras splitting ;
IN: everybodycodes.2025.01

: str-steps>int-steps ( str-steps -- int-steps )
  [ unclip *[
    string>number |
    CHAR: L = [ -1 * ] when
  ] ] map ;

: get-input ( part# -- names steps )
  I"vocab:everybodycodes/2025/01/everybody_codes_e2025_q01_p${}.txt"
  utf8 file-contents

  split-lines harvest
  [ "," split ] map
  first2

  str-steps>int-steps ;

: n-or-valid-index ( n max-index -- n' )
  [ 0 max ] dip min ;

: part1 ( -- name )
  1 get-input

  0 swap
  pick length 1 -
  '[ + _ n-or-valid-index ] each

  nth-of ;

: part2 ( -- name )
  2 get-input

  [ <circular> ] dip
  0 swap
  [ + ] each

  nth-of ;

: part3 ( -- name )
  3 get-input

  [ <circular> ] dip
  [ over circular-wrap [ 0 ] dip exchange ] each

  first ;
