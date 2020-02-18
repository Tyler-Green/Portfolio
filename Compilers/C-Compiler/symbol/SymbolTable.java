package symbol;

import absyn.*;
import java.util.*;
import java.io.PrintStream;
import java.io.FileNotFoundException;

public class SymbolTable implements SemanticVisitor {
  List<HashMap<String,Symbol>> MapList;
  private boolean printFlag;
  public boolean errorFlag;
  final static int SPACES = 4;
  private Symbol lastFunc;


  public SymbolTable(boolean flag) {
    this.MapList = new ArrayList<>();
    this.printFlag = flag;
    addScope("Global");
    this.lastFunc = null;
    List<Integer> paramsa = new ArrayList<>();
    Symbol input = new FuncSymbol(0, 0, "input", Symbol.INT, paramsa);
    List<Integer> paramsb = new ArrayList<>();
    paramsb.add(Symbol.INT);
    Symbol output = new FuncSymbol(0, 0, "output", Symbol.VOID, paramsb);
    addToScope(input);
    addToScope(output);
  }

  private void printErr(String err) {
    errorFlag = true;
    System.err.println(err);
  }

  // adds another hashmap to the hashmap list
  public void addScope(String openMsg) {
    HashMap<String,Symbol> newMap = new HashMap<String, Symbol>();
    MapList.add(newMap);
    if (printFlag) {
      indent();
      System.out.println("Entering "+openMsg+" scope:");
    }
  }

  // Prints all the symbols in the current scope
  public void printScope() {
    for (String key: (MapList.get(MapList.size()-1)).keySet()) {
      indent();
      (MapList.get(MapList.size()-1)).get(key).printSymbol();
    }
  }

  // Add a symbol to the current scope's hashmap
  public void addToScope(Symbol toAdd) {
    if (MapList.get(MapList.size()-1).get(toAdd.getID()) == null) {
      (MapList.get(MapList.size()-1)).put(toAdd.getID(), toAdd);
    } else {
      printErr("Row: " +(toAdd.getRow()+1)+ ", Col: "+toAdd.getCol()+" Redeclaration of "+toAdd.getID());
    }
  }

  // Clears the hashmap of the current scope and deletes it
  public void deleteScope(String openMsg) {
    if (printFlag) {
      printScope();
      indent();
      System.out.println("Leaving the "+openMsg+":");
    }
    (MapList.get(MapList.size()-1)).clear();
    MapList.remove(MapList.size()-1);
  }

  // check if the variable found is in a hash map of the current scope or lower
  public Symbol isDeclared(String key) {
    int currentScope = MapList.size()-1;
    int i;

    for (i=currentScope; i>=0; i--) {
      if (MapList.get(i).get(key) != null){
        return MapList.get(i).get(key);
      }
    }
    return null;
  }

  // Check is the type of two symbols is the same
  public boolean typeCheck(int type, Symbol s) {
    if (s.getType() == type) {
      return true;
    }
    return false;
  }

  // Indents according to scope level
  private void indent() {
    int level = MapList.size()-1;
    for( int i = 0; i < level * SPACES; i++ ) System.out.print( " " );
  }

  private void printType(int type) {
	  switch(type) {
		  case Symbol.INT:
		  System.out.println("INT");
		  break;
		  case Symbol.VOID:
		  System.out.println("VOID");
		  break;
		  default :
		  System.out.println("UNKNOWN");
		  break;
	  };
  }

  private String typeToStr(int type) {
	  if (type == Symbol.INT)
		  return "INT";
		if (type == Symbol.VOID)
		  return "VOID";
    else
		  return "UNKNOWN";
  }

/*
    ------------------------Declarations------------------------

    Declarations add a Symbol object to the current scopes hashmap
    for later semantic checking

*/
  public int visit ( ArrayDec exp ) {

    Symbol s = new ArraySymbol(exp.row, exp.col, exp.ID, Symbol.ARRAY, exp.size);
    addToScope(s);
    return s.getType();
  }

  public int visit( SimpleDec exp ) {
    Symbol s = new Symbol(exp.row, exp.col, exp.ID, exp.type.type);
    addToScope(s);
    return s.getType();
  }

  public int visit( FunctionDec exp ) {
    DecList params = exp.params;
    Symbol s = new FuncSymbol(exp.row, exp.col, exp.ID, exp.type.type, params);
    addToScope(s);
    lastFunc = s;
    String msg = "Function " + exp.ID;
    addScope(msg);
    // System.out.println("creating function: "+exp.ID);
    if (exp.params != null) exp.params.accept(this);
    if (exp.exps != null) exp.exps.accept(this,0);
    deleteScope("Function scope");
    return s.getType();
  }

  /*
      ------------------------Expressions------------------------

      Expressions must be checked for type errors

  */

  public int visit( AssignExp exp ) {
    //type check
    int lType = exp.lhs.accept(this);
    int rType = exp.rhs.accept(this);
    if (lType == rType) {
      return lType;
    }
    //error message
    printErr("Row: " +(exp.row+1)+ ", Col: "+exp.col+" Cannot assign type " + typeToStr(rType)+ " to type "+typeToStr(lType));
    return -1;
  }

  public int visit(CompoundExp exp, int isBlock) {
    if (isBlock == 1) {
       addScope("A New Block");
    }
    if (exp.vars != null) {
      exp.vars.accept(this); }
    if (exp.exps != null) { exp.exps.accept(this); }
    if (isBlock == 1) {
      //print block
       deleteScope("A New Block");
    }
    return -1; // i dont think anything will want a type from This
  }

  public int visit(CompoundExp exp) {
    addScope("A New Block");
    if (exp.vars != null) { exp.vars.accept(this); }
    if (exp.exps != null) { exp.exps.accept(this); }
    deleteScope("A New Block");
    return -1;
  }

  public int visit( DecList expList ) {
    while( expList != null ) {
      expList.head.accept( this);
      expList = expList.tail;
    }
    return -1;
  }

  public int visit( ExpList expList ) {
    while( expList != null ) {
      expList.head.accept( this);
      expList = expList.tail;
    }
    return -1;
  }

  public int visit( IfExp exp ) {

    if (exp.ifpart != null) {
      addScope("An If Exp");
      int type = exp.ifpart.accept(this);
      if (type != Symbol.INT) {
        printErr("Row: " +(exp.row+1)+ ", Col: "+exp.col+" Incorrect comparison type");
      }
      if (exp.thenpart instanceof CompoundExp) {
        ((CompoundExp)exp.thenpart).accept(this,0);
      } else {
        exp.thenpart.accept(this);
      }

      deleteScope("An If Exp");

      if (exp.elsepart != null) {
        addScope("An Else Exp");
        exp.elsepart.accept(this);
        deleteScope("An Else Exp");
      }
    }
    return -1;
  }

  public int visit( IntExp exp ) {
    return Symbol.INT;
  }

  public int visit( OpExp exp ) {
    //check the LHS type same as RHS type
    //type check
    int lType = exp.left.accept(this);
    int rType = exp.right.accept(this);
    if (lType == rType) {
      return lType;
    }
    //error message
    if (exp.op == exp.ASSIGN) {
      printErr("Row: " +(exp.row+1)+ ", Col: "+exp.col+" Cannot assign type " + typeToStr(rType)+ " to type "+typeToStr(lType));
    } else if(exp.op == exp.PLUS){
      printErr("Row: " +(exp.row+1)+ ", Col: "+exp.col+" Cannot add type " + typeToStr(rType)+ " to type "+typeToStr(lType));
    } else if(exp.op == exp.MINUS){
      printErr("Row: " +(exp.row+1)+ ", Col: "+exp.col+" Cannot subtract type " + typeToStr(rType)+ " to type "+typeToStr(lType));
    } else if(exp.op == exp.TIMES){
      printErr("Row: " +(exp.row+1)+ ", Col: "+exp.col+" Cannot multiply type " + typeToStr(rType)+ " to type "+typeToStr(lType));
    } else if(exp.op == exp.OVER){
      printErr("Row: " +(exp.row+1)+ ", Col: "+exp.col+" Cannot divide type " + typeToStr(rType)+ " to type "+typeToStr(lType));
    } else {
      printErr("Row: " +(exp.row+1)+ ", Col: "+exp.col+" Cannot compare type " + typeToStr(rType)+ " to type "+typeToStr(lType));
    }
    return lType;

  }

  public int visit(ReturnExp exp) {
    if (lastFunc != null) {
      int type = exp.exp.accept(this);
      if (typeCheck(type, lastFunc)) {
        return type;
      } else {
        printErr("Row: " +(exp.row+1)+ ", Col: "+exp.col+" Function "+lastFunc.getID()+" requires return type "+typeToStr(lastFunc.getType())+" but "+typeToStr(type)+" was found");
      }
    }
    return -1;
  }

  public int visit( VarExp exp ) {
    if (exp.var != null){
      return exp.var.accept(this);
    }
    return -1;
  }

  public int visit( WhileExp exp ) {
    //type check comparison
    addScope("A While Exp");
    if (exp.condition != null) {
      int type = exp.condition.accept(this);
      if (type != Symbol.INT) {
        printErr("Row: " +(exp.row+1)+ ", Col: "+exp.col+" Incorrect comparison type");
      }
    }
    if (exp.body != null) {
      if (exp.body instanceof CompoundExp) {
        ((CompoundExp)exp.body).accept(this,0);
      } else {
        exp.body.accept(this);
      }
    }
    deleteScope("A While Exp");
    return -1;
  }



  // base level

  public int visit(CallExp exp) {

    Symbol sym = isDeclared(exp.ID);
    // make sure the function has been declared before type checking
    if (sym != null && sym instanceof FuncSymbol){
      ExpList args = exp.args;
      List<Integer> types = ((FuncSymbol)sym).getParamTypes();
      int i = 0;
      // type checking the arguments of the function
      if (args != null){
        do {
          int type = args.head.accept(this);
          if (types.size() <= i) {
            // there are more args in the call exp than in the function declarations
            printErr("Row: " +(exp.row+1)+ ", Col: "+exp.col+"  Incorrect number of arguments for function "+exp.ID);
            return sym.getType();
          }
          if (type != types.get(i)) {
            printErr( "Row: "+(exp.row+1)+", Col: "+exp.col+ "  Arguement "+i+" of function"+exp.ID+" is undeclared");
          }
          args = args.tail;
          i++;

        } while (args != null);

      }
      return sym.getType();
    }
    //the function was never declared or has not been declared yet
    printErr("Row: "+exp.row+", Col: "+exp.col+ " Function "+exp.ID+" is undeclared");
    return -1;
  }

  public int visit (SimpleVarExp exp) {
    //check if the variable has been declared
    Symbol symbol = isDeclared(exp.name);
    if (symbol!=null){
        return symbol.getType();
    }  else {
      printErr("Row: "+exp.row+", Col: "+exp.col+ " Symbol "+exp.name+ " is undeclared");
    }
    return -1;
  }

  public int visit(IndexVarExp exp) {

    int indexType = exp.index.accept(this);
    //check if the variable has been declared
    Symbol symbol = isDeclared(exp.name);
    if (symbol!=null && indexType == Symbol.INT){
        return Symbol.INT;
    }  else {
      printErr("Row: "+exp.row+", Col: "+exp.col+ " Symbol "+exp.name+ " is undeclared");
    }
    return -1;
  }

  public int visit( NillExp exp) {return -1;}
  public int visit( TypeSpec exp) {return -1;}
}
