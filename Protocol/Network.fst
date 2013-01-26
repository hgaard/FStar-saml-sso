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
	| Get: prin -> string -> list string -> list string -> HttpMessage
 	| Post: prin -> list string -> list string -> HttpMessage
 	| Redirect: prin -> string -> list string -> list string -> HttpMessage
	| Response: int -> body:string -> HttpMessage

val buildDestination: string -> list string -> string
let buildDestination url params =
	 let paramStr = ConcatList ";" params in
	 Concatkv url "?" paramStr

val Send: HttpMessage -> unit
let Send message =
	match message with
	| Get (prin,url,params,cookies) -> 
		let dest = buildDestination url params in
		SendRequest dest cookies "hello";()
	| _ -> println "Not yet implemented";
		()

val Recieve: prin -> HttpMessage
let Recieve client =
	let (verb,url,body,cookies) = RecieveRequest client in
	match verb with
	| "GET" -> 
		let params = ["here query=params should be"] in
		Get client url params cookies
	| _ -> Response 400 "failed"