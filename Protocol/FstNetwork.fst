module FstNetwork
open Protocol

type method = string
type queryparams = string
type cookies = string
type messagebody = string

extern reference Network {language="F#";
						dll="Network";
						namespace="";
						classname="Network"}
extern Network val SendX: prin -> message -> SamlStatus
extern Network val RecieveX: prin -> message
extern Network val CreateSamlProtocolMessage: samlmessage -> dsig -> string