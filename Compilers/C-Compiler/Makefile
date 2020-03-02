JAVA=java
JAVAC=javac
JFLEX=jflex
C1=C1_TestFiles
C2=C2_TestFiles
C3=C3_TestFiles
C1TEST = $(wildcard $(C1:=/*.cm))
C2TEST = $(wildcard $(C2:=/*.cm))
C3TEST = $(wildcard $(C3:=/*.cm))

all: parser CM.class

CM.class: Lexer.java absyn/*.java symbol/*.java parser.java sym.java Scanner.java CM.java ShowTreeVisitor.java

%.class: %.java
	$(JAVAC) -target 1.8 -source 1.8 $^

Lexer.java: cminus.flex
	$(JFLEX) cminus.flex

parser: cminus.cup
	$(JAVA) java_cup.Main cminus.cup

run:
	$(JAVA) Main -s C1_TestFiles/test1.cm

test_c1:
	echo ----------------------- ; \
	for file in $(C1TEST) ; do \
		echo PROGRAM $$file: ; \
		$(JAVA) CM -a $$file ; \
		echo ----------------------- ; \
	done

test_c2:
	echo ----------------------- ; \
	for file in $(C2TEST) ; do \
		echo PROGRAM $$file: ; \
		$(JAVA) CM -s $$file ; \
		echo ----------------------- ; \
	done

test_c3:
	echo ----------------------- ; \
	for file in $(C3TEST) ; do \
		echo PROGRAM $$file: ; \
		$(JAVA) CM -c $$file ; \
		echo ----------------------- ; \
	done

clean:
	rm -f parser.java Lexer.java sym.java *.class absyn/*.class symbol/*.class *~

test_clean:
	rm -f C2_TestFiles/*.ast C2_TestFiles/*.smb C1_TestFiles/*.smb C3_TestFiles/*.tm
