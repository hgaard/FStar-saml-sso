module SamlProtocol

open Crypto

type assertiontoken = string (*Add refinements*)
type signedtoken = string (*Add refinements*)
type id = string
type endpoint = string
type uri = string

type AuthnRequest = 
  | MkAuthnRequest: id:string -> IssueInstant:string ->
                    Destination:endpoint -> Issuer:prin ->
                    message:string -> sig:dsig ->
                    AuthnRequest

type LoginData = 
  | MkLoginData:  user:prin -> signature:dsig ->
                  cert:pubkey user -> challenge:nonce ->
                  site:string -> data:string ->
                  LoginData

type Assertion =
  | SignedAssertion: assertiontoken -> dsig -> Assertion
  | EncryptedAssertion: cypher -> Assertion

type SamlStatus =
  | Success: SamlStatus
  | Requester: SamlStatus
  | Responder: SamlStatus

type SamlMessage =
  | Login: uri -> SamlMessage
  | LoginResponse: string -> SamlMessage
  | AuthnRequestMessage: issuer:prin ->  destination:endpoint -> message:string -> dsig -> SamlMessage
  | AuthResponseMessage: issuer:prin -> destination:endpoint -> Assertion -> SamlMessage
  | UserAuthenticated: status:string -> loginData:LoginData -> authnRequest:AuthnRequest -> SamlMessage
  | UserCredRequest: challenge:nonce -> SamlMessage
  | Failed: SamlStatus -> SamlMessage
  | DisplayError: int -> SamlMessage


val SendSaml: prin -> SamlMessage -> unit
val ReceiveSaml: prin -> SamlMessage 

val CreateAuthnRequestMessage: issuer:prin -> destination:prin -> string
val IssueAssertion: issuer:prin -> subject:prin -> audience:prin -> inresto:id -> assertiontoken
val AddSignatureToAssertion: assertiontoken -> dsig -> signedtoken
val EncryptAssertion: receiver:prin -> pubkey receiver -> signedtoken -> Assertion
val DecryptAssertion: receiver:prin -> privkey receiver -> Assertion -> (signedtoken * dsig)