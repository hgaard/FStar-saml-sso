MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`

all: bin bin/hello.dll

refinements:
	fstar --genIL --writePrims --odir bin --dotnet4 --logQueries refinements.fst

sum:
	fstar --genIL --writePrims --odir bin --dotnet4 --logQueries sum.fst

sp:
	fstar --genIL --writePrims --odir bin --dotnet4 --logQueries serviceprovider.fst

bin/hello.dll: bin hello.fst
	fstar --dotnet4 --genIL --odir bin --writePrims hello.fst

bin:
	mkdir -p bin
	cp $(MY_FSTAR_HOME)/bin/*.dll bin/

clean: 
	rm -rf bin *~
