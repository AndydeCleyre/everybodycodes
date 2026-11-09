USING: accessors assocs assocs.extras combinators.extras
combinators.syntax interpolate io.encodings.utf8 io.files kernel
make math math.order math.parser sequences sequences.extras
sorting sorting.specification splitting ;
IN: everybodycodes.events.2026.quest_04

: get-input ( part# -- lines )
  I"vocab:everybodycodes/events/2026/quest_04/input/input_p${}.txt"
  utf8 file-lines ;

TUPLE: result id quest part time ;
C: <result> result

: line>result ( str -- result )
  " =" split <odds>
  [ string>number ] map
  first4 <result> ;

: input>results ( part# -- results )
  get-input [ line>result ] map ;

TUPLE: participant id #completed total-time ;
C: <participant> participant

: results>participants ( results -- participants )
  [ id>> ] collect-by
  [
    &[ length | [ time>> ] map-sum ] <participant>
  ] { } assoc>map ;

: checksum-by-index ( sorted-participants -- n )
  [ *[ total-time>> | 1 + ] * ] map-index sum ;

: part-1 ( -- n )
  1 input>results results>participants
  [ total-time>> ] sort-by
  checksum-by-index ;

: part-2 ( -- n )
  2 input>results results>participants
  { { #completed>> >=< } { total-time>> <=> } } sort-with-spec
  checksum-by-index ;

TUPLE: timed-participant id part-times ;
C: <timed-participant> timed-participant

: participant's-quest-results>timed-participant ( results -- timed-participant )
  &[ first id>> | [ part>> ] sort-by ]
  [ time>> ] map
  0 [ + ] accumulate*
  <timed-participant> ;

: quest-results>timed-participants ( results -- timed-participants )
  [ id>> ] collect-by values
  [ participant's-quest-results>timed-participant ] map ;

: part-ranking ( timed-participants part-index -- part-ranking )
  swap dupd [ part-times>> ?nth ] with filter
  [ part-times>> nth ] with collect-by
  sort-keys values ;

! scored-participant: assoc of id-score pairs

:: score-ranking ( ranking top-score -- scored-participants )
  0 :> rank!
  [
    ranking [
      top-score rank - 0 max swap
      [
        id>> ,,
        rank 1 + rank!
      ] with each
    ] each
  ] H{ } make ;

: merge-scored-participants ( seq-of-scored-participants -- merged-scored-participants )
  H{ } clone [ [ + ] assoc-merge ] reduce ;

: timed-participants>scored-participants ( timed-participants -- scored-participants )
  {
    [ 0 part-ranking  50 score-ranking ]
    [ 1 part-ranking 100 score-ranking ]
    [ 2 part-ranking 150 score-ranking ]
  } cleave-array merge-scored-participants ;

: quest-results>scored-participants ( results -- scored-participants )
  quest-results>timed-participants timed-participants>scored-participants ;

:: checksum-by-rank ( ranked-scored-participants -- n )
  1 :> rank!
  0 :> checksum!
  ranked-scored-participants [
    rank swap
    [
      * nip
      checksum + checksum!
      rank 1 + rank!
    ] with assoc-each
  ] each
  checksum ;

: results>scored-participants ( results -- scored-participants )
  [ quest>> ] collect-by values
  [ quest-results>scored-participants ] map
  merge-scored-participants ;

: part-3 ( -- n )
  3 input>results results>scored-participants
  >alist [ second ] collect-by inv-sort-keys values
  checksum-by-rank ;
