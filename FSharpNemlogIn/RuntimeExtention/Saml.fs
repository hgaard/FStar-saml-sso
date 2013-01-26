module Saml

open System
open System.Security.Cryptography

let CreateChallenge prin = 
    let provider = new RNGCryptoServiceProvider()
    let randBytes = Array.create 10 (byte 0)
    let _ = provider.GetNonZeroBytes randBytes
    BitConverter.ToString (randBytes)

let CreateAuthnRequest sp idp = 
    let authnReq = new dk.nita.saml20.Saml20AuthnRequest()
    authnReq.Destination <- idp
    authnReq.Issuer <- sp
    let doc = authnReq.GetXml()
    doc.InnerXml

let CreateSamlAssertion user issuer destination = 
    let assertion = new dk.nita.saml20.Schema.Core.Assertion()
    assertion.Issuer <- issuer
    "assertion"

let CreateSamlResponse user issuer destination status =
    let response = new dk.nita.saml20.Schema.Protocol.Response()
    response.Issuer <- issuer
    response.IssueInstant <- Nullable(DateTime.UtcNow)
    response.Destination <- destination
    response

