MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`
FSTAR=fstar --genIL --writePrims --odir bin --dotnet4 --parallel --logQueries
FSTAR_SRC= Lib.fst Protocol.fst DummyNetwork.fst ContentServer.fst Crypto.fst Network.fst Saml.fst serviceprovider.fst
X_SRC= Lib.fst Protocol.fst DummyNetwork.fst ContentServer.fst Crypto.fst Network.fst Saml.fst xserver.fst

all: clean dirs protocol

dirs:
	mkdir -p queries bin

protocol:
	$(FSTAR) $(FSTAR_SRC)

x:
	rm -rf bin queries
	mkdir -p queries bin
	$(FSTAR) $(X_SRC)

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