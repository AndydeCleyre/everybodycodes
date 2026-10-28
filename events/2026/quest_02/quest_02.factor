USING: arrays assocs combinators.extras combinators.syntax
interpolate io.encodings.utf8 io.files kernel math math.order
math.parser path-finding sequences sets sorting splitting
strings ;
IN: everybodycodes.events.2026.quest_02

: get-input ( part# -- notes )
  I"vocab:everybodycodes/events/2026/quest_02/input/input_p${}.txt"
  utf8 file-contents ;

: line>comparisons ( str -- pairs )
  " " split
  [
    first3 swap CHAR: < = [ swap ] when
    2 @[ 1string ] 2array
  ] map ;

: compare-alloys ( a b comparison-pairs -- <=> )
  2over 2array '[ _ set= ] find nip
  index nip
  zero? +gt+ +lt+ ? ;

: line>sorted-alloys ( str -- alloys )
  line>comparisons
  &[ concat members | '[ _ compare-alloys ] ] sort-with ;

: checksum ( part# line>sorted-alloys-quot -- checksum )
  [ get-input split-lines ] dip
  '[ @ concat string>number ] map-sum ; inline

: part-1 ( -- checksum )
  1 [ line>sorted-alloys ] checksum ;

: forward-neighbors ( pairs key -- forward-neighbors )
  '[ _ = ] filter-keys values ;

: comparisons>astar ( pairs -- astar )
  dup keys members
  [ [ forward-neighbors ] keep-under ] with map>alist
  <bfs> ;

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
