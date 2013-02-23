MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`
FSTAR=fstar --genIL --writePrims --odir bin --dotnet4 --parallel --logQueries
FSTAR_SRC= crypto.fst certstore.fst samlprotocol.fst serviceprovider.fst identityprovider.fst main.fst

all: clean dirs protocol

dirs:
	mkdir -p queries bin

protocol:
	$(FSTAR) $(FSTAR_SRC)

clean:
	rm -rf bin queries