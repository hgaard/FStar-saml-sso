MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`
FSTAR=fstar --genIL --writePrims --odir bin --dotnet4 --parallel --logQueries

all: clean dirs protocol

dirs:
	mkdir -p queries bin

protocol:
	rm -rf bin queries
	mkdir -p queries bin
	$(FSTAR) crypto.fst samlprotocol.fst serviceprovider.fst identityprovider.fst main.fst

clean:
	rm -rf bin queries