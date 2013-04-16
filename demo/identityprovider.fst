module Identityprovider

open SamlProtocol
open Crypto

let handleUserAudhenticated me user client authnrequest =
  match authnrequest with | MkAuthnRequest(reqid,issueinst,dest,sp,msg,sigSP) ->
      let pubksp = CertStore.GetPublicKey sp in
      
      if (VerifySignature sp pubksp msg sigSP) then
        (assert (Log sp msg);
        let assertion = IssueAssertion me user sp reqid in
        let myprivk = CertStore.GetPrivateKey me in
        assume(Log me assertion);
        let sigAs = Sign me myprivk assertion in
        let signAssertion = AddSignatureToAssertion assertion sigAs in
        let encryptedAssertion = EncryptAssertion sp pubksp signAssertion in
        let resp = AuthResponseMessage me sp encryptedAssertion in
        SendSaml client resp) (*10*)
      else
        SendSaml client (Failed Requester)(*10.2*)

val identityprovider: me:prin -> client:prin -> unit
let rec identityprovider me client =
	let req = ReceiveSaml client in (*3 & 11*)
	match req with
	| AuthnRequestMessage (issuer, destination, message, sigSP) ->
    let pubkissuer = CertStore.GetPublicKey issuer in
    if (VerifySignature issuer pubkissuer message sigSP) then
      (assert (Log issuer message);
      let challenge = GenerateNonce me in
      let resp = UserCredRequest challenge in
      SendSaml client resp; (*4*)
      identityprovider me client (*Start over*))
    else
      SendSaml client (Failed Requester);(*4.1*)
      identityprovider me client (*Start over*)

  | UserAuthenticated (status, logindata, authnrequest) ->
    match logindata with | MkLoginData (user,sig,cert,challenge,site,data) ->
    if (status = "OK") && (VerifySignature user cert data sig) then
      (assert (Log user data);
        handleUserAudhenticated me user client authnrequest;
        identityprovider me client (*Start over*)
      )
    else
      SendSaml client (DisplayError 400);(*10.1*)
      identityprovider me client (*Start over*)

  | _ -> SendSaml client (DisplayError 400);(*10.1*)
        identityprovider me client (*Start over*)

