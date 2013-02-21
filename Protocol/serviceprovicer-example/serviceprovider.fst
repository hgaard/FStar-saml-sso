module Crypto

type prin = string
type pubkey :: prin => *
type privkey :: prin => *
type dsig

(*Verification*)
type Log :: prin => string => E

val Keygen:  p:prin
          -> (pubkey p * privkey p)

val Sign:  p:prin
        -> privkey p
        -> msg:string{Log p msg}
        -> dsig

val VerifySignature: p:prin
        -> pubkey p 
        -> msg:string
        -> dsig
        -> b:bool{b=true ==> Log p msg}
end



module SamlProtocol

open Crypto

type uri

type SamlMessage =
  | Login: uri -> SamlMessage
  | AuthnRequest: issuer:prin ->  destination:prin -> message:string -> dsig -> SamlMessage
  | Failed: int -> SamlMessage

val SendSaml: prin -> SamlMessage -> unit
val ReceiveSaml: prin -> SamlMessage 

val CreateAuthnRequestMessage: issuer:prin -> destination:prin -> string

end

module Serviceprovider

open Crypto
open SamlProtocol

val serviceprovider:  me:prin -> pubkey me -> privkey me ->
                      client:prin -> idp:prin -> pubkey idp -> unit 
let serviceprovider me pubk privk client idp pubkidp = 
 let req = ReceiveSaml client in (*1*)
 match req with
  | Login (url) -> 
    let authnReq = CreateAuthnRequestMessage me idp in
    assume(Log me authnReq);
    let sigSP = Sign me privk authnReq in
    let resp = AuthnRequest me idp authnReq sigSP in 
    SendSaml client resp (*2*)
  | _ -> SendSaml client (Failed 400)(*2.1*)
