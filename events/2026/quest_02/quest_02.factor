USING: arrays assocs.extras combinators.syntax interpolate
io.encodings.utf8 io.files kernel math.order math.parser
path-finding sequences sets sorting splitting strings ;
IN: everybodycodes.events.2026.quest_02

: get-input ( part# -- lines )
  I"vocab:everybodycodes/events/2026/quest_02/input/input_p${}.txt"
  utf8 file-lines ;

: str>pair ( str -- sorted-pair )
  first3 swap
  CHAR: < = [ swap ] when
  2 @[ 1string ] 2array ;

: line>comparisons ( str -- pairs )
  " " split [ str>pair ] map ;

: compare-alloys ( a b comparison-pairs -- <=> )
  [ 2array ] dip
  in? +lt+ +gt+ ? ;

: line>sorted-alloys ( str -- alloys )
  line>comparisons
  &[ concat members | '[ _ compare-alloys ] ] sort-with ;

: checksum ( part# line>sorted-alloys-quot -- checksum )
  [ get-input ] dip
  '[ @ concat string>number ] map-sum ; inline

: part-1 ( -- checksum )
  1 [ line>sorted-alloys ] checksum ;

: comparisons>astar ( pairs -- astar )
  [ drop ] collect-value-by <bfs> ;

: compare-alloys-2 ( a b astar -- <=> )
  find-path +lt+ +gt+ ? ;

: line>sorted-alloys-2 ( str -- alloys )
  line>comparisons
  &[ concat members | comparisons>astar ]
  '[ _ compare-alloys-2 ] sort-with ;

: part-2 ( -- checksum )
  2 [ line>sorted-alloys-2 ] checksum ;

: part-3 ( -- checksum )
  3 [ line>sorted-alloys-2 ] checksum ;
