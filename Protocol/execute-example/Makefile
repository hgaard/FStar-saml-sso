MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`
all: bin bin/FSexecute.dll bin/execute.dll

bin/FSexecute.dll: execute.fs
	fsc -o bin/FSexecute.dll -a execute.fs

bin/execute.dll: bin prims.fst execute.fst
	fstar --dotnet4 --genIL --odir bin --writePrims execute.fst

bin:
	mkdir -p bin
	cp $(MY_FSTAR_HOME)/bin/*.dll bin/

clean: 
	rm -rf bin *~
