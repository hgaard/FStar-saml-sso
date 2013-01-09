module Main

open Protocol
open Browser
open Serviceprovider
open Identityprovider
open ModelUtil

let main attacker =
	let sppk, spsk = Keygen "https://serviceprovider.org" in 
	let idppk, idpsk = Keygen "https://identityprovider.org" in 
	Fork [	attacker;
		(fun () -> browser "browser" "https://serviceprovider.org/protectedresource" "me" "myPassword");
		(fun () -> serviceprovider "https://serviceprovider.org" sppk spsk "browser" "https://identityprovider.org" idppk);
		(fun () -> identityprovider "https://identityprovider.org" idppk idpsk "browser" "https://serviceprovider.org" sppk)]
