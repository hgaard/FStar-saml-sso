module Main

open SamlProtocol
open Crypto
open Serviceprovider
open Identityprovider

val Fork: list (unit -> unit) -> unit

let main attacker =
	let sppk, spsk = Keygen "https://serviceprovider.org" in 
	let idppk, idpsk = Keygen "https://identityprovider.org" in 
	Fork [	attacker;
		(fun () -> serviceprovider "https://serviceprovider.org" "browser" "https://identityprovider.org");
		(fun () -> identityprovider "https://identityprovider.org" "browser")]
