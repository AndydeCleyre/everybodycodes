USING: assocs interpolate io.encodings.utf8 io.files math.parser
math.statistics sequences sets sorting splitting ;
IN: everybodycodes.2025.03

: get-input ( part# -- nums )
  I"vocab:everybodycodes/2025/03/everybody_codes_e2025_q03_p${}.txt"
  utf8 file-contents

  "," split [ string>number ] map ;

: part1 ( -- result )
  1 get-input members sum ;

: part2 ( -- result )
  2 get-input members sort 20 head sum ;

: part3 ( -- result )
  3 get-input histogram values maximum ;
