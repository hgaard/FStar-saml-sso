MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`

all: bin bin/hello.dll

refinements:
	$(FSTAR) refinements.fst

bin/hello.dll: bin hello.fst
	fstar --dotnet4 --genIL --odir bin --writePrims hello.fst

bin:
	mkdir -p bin
	cp $(MY_FSTAR_HOME)/bin/*.dll bin/

clean: 
	rm -rf bin *~
