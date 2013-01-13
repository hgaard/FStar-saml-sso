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

let KeyGen prin : (string * string) = 
    let cspParams = new CspParameters()
    cspParams.ProviderType <- 1
    cspParams.Flags <- CspProviderFlags.UseArchivableKey
    cspParams.KeyNumber <- int KeyNumber.Exchange
    let rsaProvicer = GetCryptoProvider

    // Export Public Key
    let pubkey = rsaProvicer.ToXmlString false

    // save to file
    let pubFilename = "pubkey-" + prin + ".xml"
    WriteKeyToFile pubFilename pubkey 
    
    // Export private key
    let privkey = rsaProvicer.ToXmlString true

    let privFilename = "privkey-" + prin + ".xml"
    WriteKeyToFile privFilename privkey

    (privkey, pubkey)

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

