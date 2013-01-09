module Saml

open System
open System.Security.Cryptography

let CreateAuthnRequest sp idp = 
    "<AuthnRequest id=\"123456\"><Destination>" + idp + "</Destination><Issuer>" + sp + "</Issuer></AuthnRequest>"

let CreateChallenge prin = 
    let provider = new RNGCryptoServiceProvider()
    let randBytes = Array.create 10 (byte 0)
    let _ = provider.GetNonZeroBytes randBytes
    BitConverter.ToString (randBytes)

let CreateSamlResponse idp sp status =
   "<samlp:Response xmlns:samlp=\"urn:oasis:names:tc:SAML:2.0:protocol\"
    xmlns:saml=\"urn:oasis:names:tc:SAML:2.0:assertion\"
    ID=\"identifier_2\"
    InResponseTo=\"identifier_1\"
    Version=\"2.0\"
    IssueInstant=\"" + DateTime.UtcNow.ToString() + "\"
    Destination=\"" + sp + "\">
    <saml:Issuer>" + idp + "</saml:Issuer>
    <samlp:Status>
    <samlp:StatusCode Value=\"" + status + "\"/>
  </samlp:Status>
  </samlp:Response>" 