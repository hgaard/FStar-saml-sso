module CertStore

open Crypto

val GetPublicKey: p:prin -> pubkey p

(*Prin needs to be updated to include credentials*)
val GetPrivateKey: p:prin -> privkey p 