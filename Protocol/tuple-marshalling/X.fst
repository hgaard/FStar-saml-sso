module X

type prin = string

extern reference Network {language="F#";
			  dll="RuntimeExt";
			  namespace="";
			  classname="Network"}
extern Network val Send: prin -> string -> bool
extern Network val Recieve: prin -> (string * string)

let test server =
  Send server "the message";
  let resp, status = Recieve server in
  
  println (Concat "response: " resp);	
  println (Concat "status: " status);
  ()
