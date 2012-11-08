MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`

all: SamlProtocol

SamlProtocol:
	mkdir -p bin
	fstar --genIL --writePrims --odir bin --dotnet4 SamlProtocol.fst	
	fstar --genIL --writePrims --odir bin --dotnet4 SimpleCrypto.fst
