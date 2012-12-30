MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`
FSTAR=fstar --genIL --writePrims --odir bin --dotnet4 --parallel
FSTAR_SRC= samlProtocol.fst browser.fst serviceprovider.fst identityprovider.fst main.fst

all: clean dirs samlProtocol

dirs:
	mkdir -p queries bin

samlProtocol:
	$(FSTAR) $(FSTAR_SRC)

print:
	$(FSTAR) print.fst
	fsc -r bin/print.dll -o bin/do.exe --platform:x86 print.fs

test:
	cp $(MY_FSTAR_HOME)/bin/*.dll bin/
	(cd bin; ./do.exe "jojoda")

basic:
	$(FSTAR) basic-example.fst	

crypto:
	$(FSTAR) cryptoexample.fst	

clean:
	rm -rf bin queries