#line 567 "noerr.nw"
#-------------------------------------------
#Variables
#-------------------------------------------

# das kann sowieso weg
DEFAULTCRAP = *~ *.aux *.log *.idx *.toc

# das kann alles noch weg
CRAP = noerr.html noerr.tex noerr.dvi example.java example.class hello*

LATEX = latex 

#--------------------------------------------
#Targets
#--------------------------------------------

# was soll normal rauskommen?
default: noerr.pl
	perl -c -w noerr.pl

test:	noerr.pl example.class

test_eiffel: noerr.pl hello_world.e hello_world

tangle: noerr.pl hello_world.e example.java Makefile

weave:	noerr.tex

doc:	noerr.dvi 

html:	noerr.html

clean:
	rm -f $(DEFAULTCRAP) $(CRAP)

#--------------------------------------------
# Single Dependencies
#--------------------------------------------

Makefile: noerr.nw
	notangle -L -RMakefile noerr.nw > Makefile

noerr.pl: noerr.nw Makefile
	notangle -L -Rnoerr.pl noerr.nw > noerr.pl

LINEJ = -L'//line %L "%F"%N'
example.java: noerr.nw
	notangle $(LINEJ) -Rexample.java noerr.nw > example.java
example.class: example.java
	javac example.java 2>&1 | perl noerr.pl $(LINEJ)

LINEE = -L'--line %L "%F"%N'
hello_world.e: noerr.nw
	notangle $(LINEE) -Rhello-world.e noerr.nw > hello_world.e

hello_world:
	/usr/lib/SmallEiffel/bin/compile hello_world.e 2>&1 | perl noerr.pl $(LINEE)
	mv a.out hello_world
noerr.dvi: noerr.tex

#--------------------------------------------
# Pattern Rules:
#--------------------------------------------

%.tex : %.nw
	noweave -index -delay $< > $@

%.html : %.nw
	noweave -html -filter l2h -option longxref -x $< > $@

%.dvi : %.tex
	$(LATEX) $<
	$(LATEX) $<

