MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`
FSTAR=fstar --genIL --writePrims --odir bin --dotnet4 --parallel
FSTAR_SRC= samlProtocol.fst client.fst serviceprovider.fst identityprovider.fst main.fst

all: dirs samlProtocol

dirs:
	mkdir -p queries bin

samlProtocol:
	$(FSTAR) $(FSTAR_SRC)

clean:
	rm -rf bin queries