cc=g++
all:token


auto_token:
	sh ./auto_keywords.sh
	sh ./auto_type.sh
token:token.l parser.y main.cpp
	bison -r all -d parser.y
	flex token.l 
	${cc} -c lex.yy.c 
	${cc} -c parser.tab.c
	${cc} -c main.cpp
	${cc} -o main lex.yy.o parser.tab.o main.o 

clean:
	rm -rf lex.yy.c parser.tab.* *.o main parser.output
