(* Specifying and verifying higher-order programs *)
module HigherOrder

(* Axiomatizing set membership using the predicate In *)
type In :: 'a::* => 'a => list 'a => E
assume In_hd: forall (hd:'a) (tl:list 'a). (In hd (Cons hd tl))
assume In_tl: forall (hd:'a) (x:'a) (tl:list 'a). (In x tl) => (In x (Cons hd tl))
assume notinNil: forall (x:'a). not (In x Nil)
assume notinCons: forall (x:'a) (y:'a) (tl:list 'a). ((not (In x tl)) && (not (x=y))) => not (In x (Cons y tl))
  
(* 
   The traditional type of for_all in F# is (f:('a -> bool) -> l:list<'a> -> bool )
   It returns true iff f returns true on every element of the list l.

   We can give a specification to for_all in F* by quantifying 
   over the property 'Pred that f decides. 

   'a is the type of the list elements; 
   'Pred is a property over 'a-typed elements decided by f
*)
val for_all: 'a::*
          -> 'Pred::('a => P)
          -> f:(x:'a -> b:bool{b=true <=> 'Pred x})
          -> l:list 'a
          -> b:bool{b=true <=> (forall x. In x l => 'Pred x)}
let rec for_all f l = match l with 
  | [] -> true
  | hd::tl -> if f hd then for_all f tl else false

end

module Client
open HigherOrder
(* We can then use this to verify a client program that checks to see if
   every element of a list is greater than zero. *)

(* We define a binary relation GT on integers *) 
type GT :: int => int => P

(* And give a type to the primitive comparison on integers *)
(* Note: This is usually buried in the std. library; but shown here for illustration *)
val gt: x:int -> y:int -> b:bool{b=true <=> GT x y}

(* We give implement all_gt_zero by calling for_all and can give it the type shown.
   Note: In general when calling functions that are predicate-parametric, 
         we need to instantiate those predicates explicitly at the call site. 
   
         Here, the notation (for_all<int, GT 0>) instantiates for_all's 
             type variable 'a to int
             pred variable 'Pred to (GT 0)
*)
val all_gt_zero : l:list int -> b:bool{(b=true) <=> (forall (x:int). In x l => GT 0 x)}
let all_gt_zero l = for_all<int, GT 0> (fun x -> gt 0 x) l
end