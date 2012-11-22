module Set
(* This example uses (list 'a) to model a set of 'a-typed elements. *)
type set :: * => * = list

(* Axiomatizing set membership using the predicate In *)
type In :: 'a::* => 'a => list 'a => E
assume In_hd: forall (hd:'a) (tl:list 'a). (In hd (Cons hd tl))
assume In_tl: forall (hd:'a) (x:'a) (tl:list 'a). (In x tl) => (In x (Cons hd tl))
assume notinNil: forall (x:'a). not (In x Nil)
assume notinCons: forall (x:'a) (y:'a) (tl:list 'a). ((not (In x tl)) && (not (x=y))) => not (In x (Cons y tl))

(*   
   A function to decide set membership 
*)
val member: x:'a -> s:set 'a -> (b:bool{b=true <=> In x s})
let rec member x = function
  | [] -> false
  | hd::tl -> if hd=x then true else member x tl

(*
   We can define set union as list append, and give it a specification that
   (union x y) contains all the elements from x and y, and nothing else.
*)
val union: x:set 'a -> y:set 'a -> z:set 'a{forall a. In a z <=> (In a x || In a y)}
let rec union x y = match x with
  | [] -> y
  | a::tl -> a::(union tl y)

(*
   It's often convenient to use abbreviations for big refined types:
   (isect x y) is the type of a set that's the intersection of x and y
*)
type isect 'a (x:set 'a) (y:set 'a) = z:set 'a{forall a. In a z <=> (In a x && In a y)}
val intersect: x:set 'a -> y:set 'a -> isect x y
let rec intersect x y = match x with
  | [] -> []
  | hd::tl ->
      if member hd y
      then hd::(intersect tl y)
      else intersect tl y

(* A tail recursive version of intersect *)
type isectplus 'a (x:set 'a) (y:set 'a) (o:set 'a) =
    z:set 'a{forall a. In a z <=> ((In a o) || (In a x && In a y))}

val aux: out:set 'a -> x:set 'a -> y:set 'a -> isectplus x y out
let rec aux out x y =
  match x with
    | [] -> out
    | hd::tl ->
        if member hd y
        then aux (hd::out) tl y
        else aux out tl y

val intersect' : x:set 'a -> y:set 'a -> isect x y
let intersect' x y = aux [] x y

end
