JAVA=java
JAVAC=javac
JFLEX=jflex

all: parser Main.class run

Main.class: Lexer.java absyn/*.java parser.java sym.java ShowTreeVisitor.java Scanner.java Main.java

%.class: %.java
	$(JAVAC) $^

Lexer.java: tiny.flex
	$(JFLEX) tiny.flex

parser: tiny.cup
	$(JAVA) java_cup.Main tiny.cup

run:
	$(JAVA) Main fac.tiny

clean:
	rm -f parser.java Lexer.java sym.java *.class absyn/*.class *~
