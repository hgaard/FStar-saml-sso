module Lib

val ConcatList: string -> list string -> string
let ConcatList sep l = match l with 
  | [] -> ""
  | hd::tl -> 
      let tl = ConcatList sep tl in
        if tl="" then hd
        else Concat (Concat hd sep) tl

val ConcatTupleList: string -> list (string * string) -> string
let ConcatTupleList sep l = match l with 
  | [] -> ""
  | (k,v)::tl -> 
      let tl = ConcatTupleList sep tl in
        if tl="" then Concatkv k "=" v
        else 
        (Concat (Concat (Concatkv k "=" v) sep) tl)

val Concatkv: string -> string -> string -> string
let Concatkv k sep v = 
	let ks = Concat k sep in
	Concat ks v

val printlist: list (string*string) -> unit
let printlist l = match l with
	| [] -> ()
	| (k,v)::tl -> println (Concatkv k "=" v);
		printlist tl

val getStrInList: list string -> string -> string
let getStrInList l str = match l with
	| [] -> ""
	| hd::tl ->
		if strStartsWith hd str then hd
		else getStrInList tl str

val getStrInTupleList: list (string*string) -> string -> string
let getStrInTupleList l str = match l with
	| [] -> ""
	| (k,v)::tl ->
		if k = str then v
		else getStrInTupleList tl str

val isEmptyStr: string -> bool
let isEmptyStr str = match str with
      | "" -> false
      | _ -> true

val getListItem: list string -> string -> option string
let getListItem l item = match l with
	| [] -> None
	| hd::tl -> 
		if strStartsWith hd item then Some hd
		else getListItem tl item