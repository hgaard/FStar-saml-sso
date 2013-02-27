MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`
FSTAR=fstar --genIL --writePrims --odir bin --dotnet4 --parallel --logQueries

all: clean dirs x

dirs:
	mkdir -p queries bin

x:
	rm -rf bin queries
	mkdir -p queries bin
	$(FSTAR) samlProtocol.fst interop.fst x.fst

clean:
	rm -rf bin queries