MY_FSTAR_HOME=`cygpath "$(FSTAR_HOME)"`
FSTAR=fstar --genIL --writePrims --odir bin --dotnet4 --parallel --logQueries

all: clean dirs sp

dirs:
	mkdir -p queries bin

sp:
	$(FSTAR) serviceprovider.fst

clean:
	rm -rf bin queries