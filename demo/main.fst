module Main

open SamlProtocol
open Crypto
open Serviceprovider
open Identityprovider

val Fork: list (unit -> unit) -> unit

let main attacker =
	Fork [	attacker;
		(fun () -> serviceprovider "serviceprovider.org" "browser" "identityprovider.org");
		(fun () -> identityprovider "identityprovider.org" "browser")]
