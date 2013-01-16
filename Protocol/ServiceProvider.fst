module Serviceprovider
open Protocol

val serviceprovider:  me:prin -> pubkey me -> privkey me ->
                      browser:prin -> idp:prin -> pubkey idp -> unit 
let serviceprovider me pubk privk browser idp pubkidp = 
  let reqRes = Recieve browser in (*1*) (*7*)
  match reqRes with
  | HttpGet (uri) -> 

    let authnReq = CreateAuthnRequest me idp in 
    assume(Log me authnReq) (*Protocol event*);
    let sigSP = Sign me privk authnReq in
      
    let authnReqest = SamlProtocolMessage idp authnReq sigSP in 
    Send browser authnReqest (*2*)  

  | SamlProtocolMessage (sp, msg, sigIDP) -> 
      if VerifySignature idp pubkidp msg sigIDP
      then
        (assert(Log idp msg);
          let resource = Resource "uri" in
          Send browser resource)  (*8*)
      else Send browser (Failed (403))(*8.1*)
  
  | _ -> Send browser (Failed (400))(*2.1*)
