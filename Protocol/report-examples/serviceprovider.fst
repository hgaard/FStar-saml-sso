module Serviceprovider

type principal
type pubkey :: principal => *
type privkey :: principal => *
type dsig
type uri
type SamlMessage =
  | Login: uri -> SamlMessage
  | AuthnRequest: issuer:principal ->  destination:principal -> message:string -> dsig -> SamlMessage
  | Failed: int -> SamlMessage

type Log :: principal => string => E

val Send: principal 
        -> SamlMessage 
        -> unit
val Receive: principal 
        -> SamlMessage 
val CreateAuthnRequestMessage: issuer:principal 
        -> destination:principal -> string
val Sign:  p:principal
        -> privkey p
        -> msg:string{Log p msg}
        -> dsig
val VerifySignature: p:principal
        -> pubkey p 
        -> msg:string
        -> dsig
        -> b:bool{b=true ==> Log p msg}


val serviceprovider:  me:principal -> pubkey me -> privkey me ->
                      client:principal -> idp:principal -> pubkey idp -> unit 
let serviceprovider me pubk privk client idp pubkidp = 
 let req = Receive client in (*1*)
 match req with
  | Login (url) -> 
    let authnReq = CreateAuthnRequestMessage me idp in
    assume(Log me authnReq);
    let sigSP = Sign me privk authnReq in
    let resp = AuthnRequest me idp authnReq sigSP in 
    Send client resp (*2*)
  | _ -> Send client (Failed 400)(*2.1*)
