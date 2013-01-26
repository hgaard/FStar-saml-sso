module DummyNetwork

open Lib
open Protocol

val SendResponse: prin -> list string -> string -> bool
let SendResponse prin cookies messagebody =
	println "Response to prin:";
	println prin;
	println "cookies:";
	printlist cookies;
	println "messagebody:";
	println messagebody

val SendRequest: uri -> list string -> string -> bool
let SendRequest dest cookies messagebody =
	println "MessageDestination:";
	println dest;
	println "cookies:";
	printlist cookies;
	println "messagebody:";
	println messagebody

val RecieveResponse: prin -> (int *string * list string)
let RecieveResponse prin =
	let status = 200 in
	let body = "The message" in 
	let cookies = ["cookie1=someval"; "cookie2=somotherval"] in
	(status, body, cookies)

val RecieveRequest: prin -> (string * string * string * list string)
let RecieveRequest prin =
	let verb = "GET" in
	let url = "https://sp.dk?samlMessage=SGVyZSBpcyBhIHNhbWwgbWVzc2FnZQ==" in (*Here is a saml message*)
	let body = "The message if post" in 
	let cookies = ["cookie1=someval"; "cookie2=somotherval"] in
	(verb, url, body, cookies)
