MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`
all: bin bin/FSCrypto.dll bin/Crypto.dll

bin/FSCrypto.dll: crypto.fs
	fsc -o bin/FSCrypto.dll -a crypto.fs

bin/Crypto.dll: bin prims.fst crypto.fst
	fstar --dotnet4 --genIL --odir bin --writePrims crypto.fst

bin:
	mkdir -p bin
	cp $(MY_FSTAR_HOME)/bin/*.dll bin/

clean: 
	rm -rf bin *~
