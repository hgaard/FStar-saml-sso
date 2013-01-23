module Crypto

open System.Security.Cryptography
open System.Text
open System
open System.IO

let GetEncoder = new ASCIIEncoding()

let GetHashProvicer = new SHA1CryptoServiceProvider()

let GetCryptoProvider = new RSACryptoServiceProvider()

let WriteKeyToFile (filename:string) (key:string) = 
    // save to file
    let fn = filename.Replace("://", "-")
    let file = File.CreateText(fn)
    file.Write key |>  file.Close

let KeyGenExt prin : Prims.DepTuple<Protocol.pubkey,Protocol.privkey> = 
    let cspParams = new CspParameters()
    cspParams.ProviderType <- 1
    cspParams.Flags <- CspProviderFlags.UseArchivableKey
    cspParams.KeyNumber <- int KeyNumber.Exchange
    let rsaProvicer = GetCryptoProvider

    // Export Public Key
    let pubkey = Protocol.pubkey(0,rsaProvicer.ToXmlString false)

    // Export private key
    let privkey = Protocol.privkey(0,rsaProvicer.ToXmlString true)

    new Prims.DconDepTuple<Protocol.pubkey,Protocol.privkey>(pubkey, privkey) :> Prims.DepTuple<Protocol.pubkey,Protocol.privkey>

let SignMessage (prin:string) (key:string) (msg:string) : string = 
    let ByteConverter = GetEncoder
    let msgData = ByteConverter.GetBytes(msg)
    let alg = GetCryptoProvider
    alg.FromXmlString key
    let signedData = alg.SignData(msgData, GetHashProvicer)

    Convert.ToBase64String(signedData)

let ValidateMessage (prin:string) (key:string) (msg:string) (signature:string) : bool = 
    let ByteConverter = GetEncoder
    let dataToVerify = ByteConverter.GetBytes msg
    let sign = Convert.FromBase64String signature
    let alg = GetCryptoProvider
    alg.FromXmlString key

    alg.VerifyData(dataToVerify, GetHashProvicer, sign)

