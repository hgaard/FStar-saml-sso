MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`

all: samlProtocol

samlProtocol:
	mkdir -p bin
	fstar --genIL --writePrims --odir bin --dotnet4 --parallel samlProtocol.fst

simple:
	mkdir -p bin
	fstar --genIL --writePrims --odir bin --dotnet4 --parallel simpleSaml.fst	

crypto:
	mkdir -p bin
	fstar --genIL --writePrims --odir bin --dotnet4 --parallel simplecrypto.fst

clean:
	rm -rf bin