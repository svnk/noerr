# noerr

## Introduction

You're reading the documentation for noerr. noerr is a tool, helping you to use noerr with programming languages that don't understand `#line` commands. I assume that you understood this sentence. If not, read about literate programming, noweb, and try to use it with e.g. Java.

## General Description

noerr is a filter for noweb. It changes error messages from pointing to noweb-generated files to pointing to noweb-files. It does so by emulating the #line command of C as close als poosible while retaining flexibility.

If you put the option -L on the noweb-commandline, it expands to `#line %L "%F"%N`

This option inserts #line lines to point errors from included header-files back into the original. I'm going to do the same for tracing errors in source-files back to noweb-files.

The -L option generates `#line %L "%F"%N`, with %L being replaced by the referenced line and %F with the referenced file. This freely configurable. For examples look in my Makefile (Section [->]).

## Usage

If you use noweb and have perl installed, you can use noerr.

noerr needs the line option you use with noweb and the compiler output as input. The line option is noerr's only command-line option. The Compiler-output comes from standard in.

## Example

Here is a little Java Program I used to test noerr.

```
<example.java>=
//-*- java -*-
<Importe>
public class example
{
    <Main>
}
```

This code is written to a file (or else not used).
some text

```
<Importe>=
fasel dummes Zeug;
Used below.
<Main>=
public static void main(String argv[])
{
    hier gehts schief;
}
Used below.
some more Text.
```

### The Java-Code

A simple 
```
notangle -L'//line %L "%F"%N' -Rexample.java noerr.nw > example.java
```
leads to

```
<the tangled example.java>=
//line 299 "noerr.nw"
fasel dummes Zeug;
//line 292 "noerr.nw"
public class example
{
//line 302 "noerr.nw"
public static void main(String argv[])
{hier gehts schief;}
//line 293 "noerr.nw"
         }
```

Let's watch a usual compilation:

```
<Fehlermeldungen ohne noerr>=
sven@home:/home/sven/uni/noerr > javac example.java
example.java:3: Class or interface declaration expected.
asdkbj;
^
example.java:9: ';' expected.
{hier gehts schief;}
           ^
2 errors                               

This code is written to a file (or else not used).
```

I've got to go to example.java just to find the line-line telling me, where to look in noerr.nw. I know we can do better. Let's watch noerr at work:

```
<Compilation with noerr>=
cd ~/uni/noerr/
make test
notangle -L -RMakefile noerr.nw > Makefile
notangle -L -Rnoerr.pl noerr.nw > noerr.pl
notangle -L'//line %L "%F"%N' -Rexample.java noerr.nw > example.java
javac example.java 2>&1 | perl noerr.pl -L'//line %L "%F"%N'
noerr.nw:299: Class or interface declaration expected.
fasel dummes Zeug;
^
noerr.nw:303: ';' expected.
{hier gehts schief;}
           ^
2 errors

Compilation finished at Wed Dec  9 20:01:08

This code is written to a file (or else not used).
```

This looks better, doesn't it?
