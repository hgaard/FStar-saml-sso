module Network

open System
open System.Net
open System.Text

let listener = new HttpListener()

let GetMsg (msg:Protocol.message) = 
    match msg with
    | :? Protocol.SamlProtocolMessage -> (msg :?> Protocol.SamlProtocolMessage).field_2
    | _ -> "<html><head><title>Server</title></head><body><h1>Message from: %s not valid</h1></body></html>"

let StartListen  = 
    listener.Prefixes.Add("http://localhost:8080/")
    listener.Start()
    printfn "listening...."

let GetContext = listener.GetContext()

let SendX (prin:string) (msg:Protocol.message) = 
    let resp = GetContext.Response
    let cookie = new Cookie("AuthnTicket", "12 02 002 020 22")
    resp.AppendCookie(cookie)
    let respmsg = GetMsg msg
    let buffer = System.Text.Encoding.UTF8.GetBytes(respmsg)
    resp.ContentLength64 <- int64 buffer.Length
    let output = resp.OutputStream;
    output.Write(buffer,0,buffer.Length)
    output.Close();
    true

let RecieveX (prin:string) : (Protocol.message) =
    let req = GetContext.Request
    match prin with
    | "sp" ->  Protocol.HttpGet ("Request to sp: " + req.RawUrl) :> Protocol.message
    | "idp" -> Protocol.HttpGet "This is a idp reply" :> Protocol.message
    | "browser" -> Protocol.HttpGet "This is a browserreply" :> Protocol.message
    | _ -> Protocol.Failed 400 :> Protocol.message