USING: accessors circular combinators.syntax
interpolate io.encodings.utf8 io.files kernel lists
lists.circular lists.lazy math math.functions math.parser
math.vectors sequences sequences.extras splitting ;
IN: everybodycodes.events.2026.quest_03

! digits are stored in reverse

: get-input ( part# -- lines )
  I"vocab:everybodycodes/events/2026/quest_03/input/input_p${}.txt"
  utf8 file-lines ;

: pad-iso-digits ( iso-digits vote-length -- iso-digits' )
  2dup *[ length | < ] [
    *[ <circular> | ltake ] list>array
  ] [ drop ] if ;

TUPLE: vote iso-digits vote-digits ;

: <vote> ( iso-digits vote-digits -- vote )
  [ length pad-iso-digits ] keep
  vote boa ;

: line>vote ( str -- vote )
  " -" split last2
  2 @[ string>number >digits <reversed> ]
  <vote> ;

: iso>multipliers ( digits -- ints )
  [ ^ [ fp-nan? ] [ drop 1 ] 1when ] map-index ;

: score-vote ( vote -- n )
  &[ iso-digits>> iso>multipliers | vote-digits>> ]
  v* sum ;

: line>score ( str -- n )
  line>vote score-vote ;

: part-1 ( -- n )
  1 get-input [ line>score ] map-sum ;

: part-2 ( -- n )
  2 get-input [ line>score ] map-sum ;

: vote-number ( vote -- n )
  vote-digits>> <reversed> digits> ;

: smaller-vote ( vote -- vote' )
  &[ iso-digits>> | vote-number ]
  1 - >digits <reversed>
  [ length head ] keep <vote> ;

:: smallest? ( vote -- ? )
  f :> smaller-found?!
  vote score-vote :> target-score
  vote smaller-vote :> candidate!
  [ ||[ smaller-found? | candidate vote-number 1 < ] ] [
    candidate score-vote target-score =
    [ t smaller-found?! ] [ candidate smaller-vote candidate! ] if
  ] until
  smaller-found? not ;

: part-3 ( -- n )
  3 get-input [ line>vote ] [ smallest? ] map-filter
  [ score-vote ] map-sum ;
