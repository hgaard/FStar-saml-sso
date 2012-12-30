module Serviceprovider
open Protocol

val serviceprovider:  me:prin -> pubkey me -> privkey me ->
                      browser:prin -> idp:prin -> pubkey idp -> unit 
let serviceprovider me pubk privk browser idp pubkidp = 
  let reqRes = recieve browser in (*1*)
  match reqRes with
  | HttpGet (uri) -> 
  
    let authnReq = createAuthnRequest me idp in 
    assume(Log me authnReq) (*Protocol event*);
    let sigSP = sign me privk authnReq in
      
    let authnReqest = SamlProtocolMessage idp authnReq sigSP in 
    send browser authnReqest; (*2*)  
    let authResponse = recieve browser in (*7*)
    match authResponse with
    | SamlProtocolMessage (sp, msg, sigIDP) -> 
      (if verify idp pubkidp msg sigIDP
      then
        (assert(Log idp msg);
          let resource = Resource uri in
          send browser resource)  (*8*)
      else ())
    | _ ->  send browser (Failed (403))(*8.1*)     
  
  | _ -> send browser (Failed (400))(*2.1*)

end (* Serviceprovider *)