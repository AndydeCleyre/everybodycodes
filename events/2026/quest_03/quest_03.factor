USING: circular combinators.extras combinators.syntax
interpolate io.encodings.utf8 io.files kernel lists lists.lazy
math math.functions math.parser math.vectors sequences splitting ;
IN: everybodycodes.events.2026.quest_03

: get-input ( part# -- lines )
  I"vocab:everybodycodes/events/2026/quest_03/input/input_p${}.txt"
  utf8 file-lines ;

: reversed-digits ( str -- digits )
  string>number >digits reverse ;

: iso>multipliers ( str -- ints )
  reversed-digits
  [ ^ dup fp-nan? [ drop 1 ] when ] map-index ;

: pad-iso-str ( iso-str num-str -- iso-str' )
  dupd 2 @[ length ]
  [ < ] keep-under [
    *[ reverse <circular> | ltake ]
    list>array reverse
  ] [ drop ] if ;

: line>iso-str-and-num-str ( str -- iso-str num-str )
  " -" split last2
  [ pad-iso-str ] keep ;

: line>score ( str -- n )
  line>iso-str-and-num-str
  *[ iso>multipliers | reversed-digits ]
  v* sum ;

: part-1 ( -- n )
  1 get-input [ line>score ] map-sum ;

: part-2 ( -- n )
  2 get-input [ line>score ] map-sum ;

: part-3 ( -- n ) 0 ;
