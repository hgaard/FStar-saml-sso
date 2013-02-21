module Crypto

open Protocol
type prin = string
type pubkey :: prin => *
type privkey :: prin => *
type dsig
type nonce
type cypher

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


val Encrypt: p:prin
        -> pubkey p
        -> msg:string{Log p msg}
        -> cypher

val Decrypt: p:prin
        -> p privkey
        -> cypher
        -> msg:string

val GenerateNonce: prin -> nonce (*Add refinement to ensure unqueness*)

val AuthenticateUser: user:string
        -> password:string
        -> challenge:nonce 
        -> b:bool{b=true ==> Log user challenge}


(*Crypto functions*)
extern reference Crypto {language="F#";
            dll="Crypto";
            namespace="";
            classname="Crypto"}

extern Crypto val KeyGenExt: p:prin
          -> (string * string)

