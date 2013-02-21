module X

(* Declare a type pos of positive numbers *)
type pos = i:int{i>0}

let x:pos = 1
let y:pos = 0 (* Will not type-check*)
