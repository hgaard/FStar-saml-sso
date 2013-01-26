module Lib

val ConcatList: string -> list string -> string
let ConcatList sep l = match l with 
  | [] -> ""
  | hd::tl -> 
      let tl = ConcatList sep tl in
        if tl="" then hd
        else Concat (Concat hd sep) tl

val Concatkv: string -> string -> string -> string
let Concatkv k sep v = 
	let ks = Concat k sep in
	Concat ks v

val printlist: list string -> unit
let printlist l = match l with
	| [] -> ()
	| hd::tl -> println hd;
		printlist tl

val getStrInList: list string -> string -> string
let getStrInList l str = match l with
	| [] -> ""
	| hd::tl ->
		if strStartsWith hd str then hd
		else getStrInList tl str

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