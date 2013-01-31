MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`
all: test

bin:
	mkdir -p bin

bin/X.dll: bin X.fst
	fstar --genIL --writePrims --odir bin --dotnet4 X.fst
	cp $(MY_FSTAR_HOME)/bin/*.dll bin

bin/RuntimeExt.dll: bin bin/X.dll Network.fs
	fsc -a -o bin/RuntimeExt.dll -r bin/Prims.dll -r bin/runtime.dll Network.fs

bin/Program.exe: bin bin/RuntimeExt.dll Program.fs
	fsc -o bin/Program.exe -r bin/X.dll Program.fs

test: bin/Program.exe
	bin/Program.exe

clean: 
	rm -rf bin
	rm -f *~
