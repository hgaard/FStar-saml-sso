module SamlProtocol

open Crypto
(*open Network*)

type assertiontoken = string (*Add refinements*)
type signedtoken = string (*Add refinements*)
type id = string
type endpoint = string
type uri = string

type Assertion =
  | SignedAssertion: assertiontoken -> dsig -> Assertion
  | EncryptedAssertion: encrypter:prin -> prinencryptedtoken:string -> Assertion

type SamlMessage =
  | Login: uri -> SamlMessage
  | LoginResponse: string -> SamlMessage
  | AuthnRequest: issuer:prin ->  destination:endpoint -> message:string -> dsig -> SamlMessage
  | AuthResponseMessage: issuer:prin -> destination:endpoint -> Assertion -> SamlMessage
  | UserCredRequest: challenge:nonce -> SamlMessage
  | Failed: int -> SamlMessage

type SamlStatus =
  | Success: SamlStatus
  | Requester: SamlStatus
  | Responder: SamlStatus


val SendSaml: prin -> SamlMessage -> unit
val ReceiveSaml: prin -> SamlMessage 

val IssuerAssertion: issuer:prin -> subject:prin -> audience:prin -> inresto:id -> assertiontoken
val AddSignatureToAssertion: assertiontoken -> dsig -> signedtoken
val CreateAuthnRequestMessage: issuer:prin -> destination:prin -> string