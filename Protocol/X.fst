module X

open Lib
open Protocol
open Network

let printReq p url params cookies =
	println (Concat "Prin: " p);
	println (Concat "url: " url);
	print_string "params: ";
	printlist params;
	print_string "cookies: ";
	printlist cookies;
	()

val test1: string -> unit
let test1 s = 
	let req = Recieve s in
	match req with
	| Get (prin, url, params, cookies) ->
		printReq prin url params cookies;()

	| Response(status,body) ->
		print_string "Response status: ";
		print_int status;
		println (Concat "message: " body);()

val test2: string -> unit
let test2 s = 
	let params = ["param=value"] in
	let cookie = ["Cookeie=valueCookie"] in
	let msg = Get "prin" "dest" params cookie in
	Send msg;
	println "message sent";
	()