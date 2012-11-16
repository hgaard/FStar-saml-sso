module ILIST1

type ilist :: int => * => * = 
   | INil  : ilist 0 'a
   | ICons : x:'a -> n:int -> ilist n 'a -> ilist (n + 1) 'a

val iappend: n1:int -> ilist n1 'a -> n2:int -> ilist n2 'a -> ilist (n1 + n2) 'a
let rec iappend n1 l1 n2 l2 = match l1 with
   | INil -> l2
   | ICons x n1_minus_1 l1tl ->
     ICons x (n1_minus_1 + n2) (iappend n1_minus_1 l1tl n2 l2)