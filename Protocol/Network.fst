module Network

open Lib
open Protocol

(*Dummy implementation of actual networking*)
open DummyNetwork

(*This is the reference to the implementation in F#
	This ic commented out for now to avoid struggeling with interop
extern reference Network {language="F#";
						dll="RuntimeExtention";
						namespace="";
						classname="Network"}
extern Network val SendResponse: prin -> list string -> string -> bool
extern Network val SendRequest: uri -> list string -> string -> bool
extern Network val RecieveResponse: prin -> (int *string * list string)
extern Network val RecieveRequest: prin -> (string * string * string * list string)
*)

type HttpMessage =
	| Get: prin -> string -> list (string * string) -> list (string * string) -> HttpMessage
 	| Post: prin -> list (string * string) -> list (string * string) -> HttpMessage
 	| Redirect: prin -> string -> list (string * string) -> list (string * string) -> HttpMessage
	| Response: int -> body:string -> list (string * string) -> HttpMessage

val buildDestination: string -> list (string * string) -> string
let buildDestination url params =
	 let paramStr = ConcatTupleList ";" params in
	 Concatkv url "?" paramStr

val Send: HttpMessage -> unit
let Send message =
	match message with
	| Get (prin,url,params,cookies) -> 
		let dest = buildDestination url params in
		let cl = map (fun (k,v)-> Concatkv k "=" v) cookies in
		SendRequest dest cl "hello";()
	| _ -> println "Not yet implemented";
		()

val Recieve: prin -> HttpMessage
let Recieve client =
	let (verb,url,body,cookies) = RecieveRequest client in
	match verb with
	| "GET" -> 
		let params = [("here query", "params should be")] in
		let c = [("atemp","cookie")]
in		Get client url params c
	| _ -> Response 400 "failed" []