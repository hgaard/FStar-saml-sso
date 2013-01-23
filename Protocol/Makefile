MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`
FSTAR=fstar --genIL --writePrims --odir bin --dotnet4 --parallel --logQueries
FSTAR_SRC= samlProtocol.fst FstNetwork.fst browser.fst serviceprovider.fst identityprovider.fst ModelUtil.fst main.fst

all: clean dirs samlProtocol

dirs:
	mkdir -p queries bin

samlProtocol:
	$(FSTAR) $(FSTAR_SRC)

x:
	rm -rf bin queries
	mkdir -p queries bin
	$(FSTAR) samlProtocol.fst FstNetwork.fst X.fst xserver.fst

test:
	cp $(MY_FSTAR_HOME)/bin/*.dll bin/
	(cd bin; ./do.exe "jojoda")

basic:
	$(FSTAR) basic-example.fst	

crypto:
	$(FSTAR) cryptoexample.fst	

network:
	$(FSTAR) network.fst

clean:
	rm -rf bin queries