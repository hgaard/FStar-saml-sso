module CRYPTO

type prin = string
type pubkey :: prin => *
type privkey :: prin => *
type dsig 

val keygen:  p:prin
          -> (pubkey p * privkey p)

type Says :: prin => bytes => E
val sign:  p:prin
        -> privkey p
        -> msg:bytes{Says p msg}
        -> dsig

val verify: p:prin
        -> pubkey p 
        -> msg:bytes
        -> dsig
        -> b:bool{b=true ==> Says p msg}