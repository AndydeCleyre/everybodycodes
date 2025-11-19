USING: combinators.syntax grouping interpolate io.encodings.utf8
io.files kernel math math.functions math.parser sequences
sequences.extras splitting ;
IN: everybodycodes.2025.04

: get-input ( part# -- gears )
  I"vocab:everybodycodes/2025/04/everybody_codes_e2025_q04_p${}.txt"
  utf8 file-lines
  [ "|" split [ string>number ] map ] map ;

: gear-ratio-simple ( gears -- ratio )
  &[ first | last ] *[ first | last ] / ;

: part1 ( -- #turns )
  1 get-input gear-ratio-simple
  2025 * truncate ;

: part2 ( -- #turns )
  2 get-input gear-ratio-simple
  10_000_000_000_000 swap / ceiling ;

: gear-ratio ( gears -- ratio )
  2 clump [ first2 *[ last | first ] / ] map-product ;

: part3 ( -- result )
  3 get-input gear-ratio
  100 * truncate ;
