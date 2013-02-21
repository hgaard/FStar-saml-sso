module CRYPTO
type prin = string
type pubkey :: prin => *
type privkey :: prin => *
type dsig 

val keygen:  p:prin
          -> (pubkey p * privkey p)

type samlmessage =
  | AuthnRequest: samlmessage
  | Response: samlmessage

type message =
  | SamlProtocolMessage: prin -> samlmessage -> dsig -> message
  | Failed: int -> message

type Says :: prin => samlmessage => E

val sign:  p:prin
        -> privkey p
        -> msg:samlmessage{Says p msg}
        -> dsig

val verify: p:prin
        -> pubkey p 
        -> msg:samlmessage
        -> dsig
        -> b:bool{b=true ==> Says p msg}

end(* crypto *)

module UTIL
open CRYPTO

val send: prin -> message -> unit
val recieve: prin -> message 

val createRequest: prin -> samlmessage
val createResponse: prin -> samlmessage

val fork: list (unit -> unit) -> unit

(* val send: prin -> (samlmessage * dsig) -> unit
val recv: prin -> (samlmessage * dsig) 
val string2bytes: string -> samlmessage*)

end(* util *)

module Serviceprovider
open CRYPTO
open UTIL
val serviceprovider: me:prin -> pubkey me -> privkey me 
         -> idp:prin -> pubkey idp -> unit
let serviceprovider me mypk mysk idp serverpk = 
   let req = createRequest idp in 
    assume (Says me req); (* protocol event *)
    let dsig = sign me mysk req in 
      let authreq = SamlProtocolMessage idp req dsig in
      send idp authreq;
      let samlresp = recieve idp in 
      match samlresp with
      | SamlProtocolMessage (me', resp, dsig') -> 
        if verify idp serverpk resp dsig'
        then (assert (Says idp resp); ())
        else ()
      | _ -> ()

end(* Serviceprovider *)

module Identityprovider
open CRYPTO
open UTIL

val identityprovider: me:prin -> pubkey me -> privkey me 
                      -> browser:prin -> sp:prin -> pubkey sp
                      -> unit
let identityprovider me pubk privk browser serviceprovider pubksp =
 
   let samlreq = recieve serviceprovider in 
   match samlreq with
   | SamlProtocolMessage (me', message, dsig) -> 
 
    if verify serviceprovider pubksp message dsig
     then 
       (assert (Says serviceprovider message);
        let resp = createResponse serviceprovider in 
        assume (Says me resp);
        let dsig = sign me privk resp in 
        let samlresp = SamlProtocolMessage serviceprovider resp dsig in
        send serviceprovider samlresp)
     else ()
   | _ -> ()
   

end(* identityprovider *)

module MAIN
open CRYPTO
open UTIL
open Serviceprovider
open Identityprovider
let main attacker =
  let sppk, spsk = keygen "serviceprovider" in 
  let idppk, idpsk = keygen "identityprovider" in 
  fork [attacker;
        (fun () -> serviceprovider "serviceprovider" sppk spsk "identityprovider" idppk);
        (fun () -> identityprovider "identityprovider" idppk idpsk "browser" "serviceprovider" sppk)]
