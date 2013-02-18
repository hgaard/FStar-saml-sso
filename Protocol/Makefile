MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`
FSTAR=fstar --genIL --writePrims --odir bin --dotnet4 --parallel --logQueries
FSTAR_SRC= Lib.fst Protocol.fst SessionManager.fst DummyNetwork.fst ContentServer.fst Crypto.fst Network.fst Saml.fst serviceprovider.fst identityprovider.fst
SERVER_SRC= Lib.fst Protocol.fst SessionManager.fst DummyNetwork.fst ContentServer.fst Crypto.fst Network.fst Saml.fst xserver.fst
NETWORK_SRC = Lib.fst Protocol.fst Network.fst x.fst

all: clean dirs protocol

dirs:
	mkdir -p queries bin

protocol:
	$(FSTAR) $(FSTAR_SRC)

server:
	rm -rf bin queries
	mkdir -p queries bin
	$(FSTAR) $(SERVER_SRC)

nw:
	rm -rf bin queries
	mkdir -p queries bin
	$(FSTAR) $(NETWORK_SRC)	

x: 
	rm -rf bin queries
	mkdir -p queries bin
	$(FSTAR) crypto.fst samlprotocol.fst xserver.fst xidentityprovider.fst xmain.fst

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