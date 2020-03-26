package Assembler;

import absyn.*;
import java.util.*;

public class Assembler implements AssemblerVisitor {
  private int instructionCnt;
  private int varCnt;
  private int patchCount = 0;
  private int scopeCount = 0;
  private ArrayList<APatchLine> stack;
  private ArrayList<HashMap<String, Integer>> MapList;
  private HashMap<String, Integer> functionMap;

  /* Registers */
  static private final int AC1 = 1;
  static private final int AC = 0;
  static private final int VAL = 3;
  static private final int ADR = 4;
  static private final int FP = 5; // FP
  static private final int GP = 6; // GP
  static private final int PC = 7; // PC

  public enum Operations {HALT, IN, OUT, ADD, SUB, MUL, DIV, LD, ST, LDA, LDC, JLT, JLE, JGT, JGE, JEQ, JNE;}

  private List<Operations> registerOnly = Arrays.asList(Operations.HALT, Operations.IN, Operations.OUT, Operations.ADD, Operations.SUB, Operations.MUL, Operations.DIV);

  // id -- unique id for backpatch, what you are looking for
  // curInstruct -- current instruction count
  private void checkPatchLine(String id, int curInstruct) {
    for (int i = 0; i < stack.size(); i++) {
      APatchLine tmp = stack.get(i);
      // System.err.println(tmp.waitingForString);
      if (tmp.waitingForString.compareTo(id) == 0) {
        // System.err.println(curInstruct);
        writeAsm(tmp.lineNum, tmp.instruction,tmp.param1,(curInstruct-tmp.lineNum-1),tmp.param3,tmp.comment);
        stack.remove(tmp);
        i--;
      }
    }
  }

  public void addScope() {
    HashMap<String,Integer> newMap = new HashMap<String, Integer>();
    MapList.add(newMap);
  }

  // Add a symbol to the current scope's hashmap
  public void addToScope(String name, Integer offset) {
    if ((MapList.get(MapList.size()-1)).get(name) == null) (MapList.get(MapList.size()-1)).put(name, offset);
  }

  // Clears the hashmap of the current scope and deletes it
  public void deleteScope() {
    (MapList.get(MapList.size()-1)).clear();
    MapList.remove(MapList.size()-1);
  }

  public Integer[] isDeclared(String key) {
    int currentScope = MapList.size()-1;
    for (int i=currentScope; i>=0; i--) {
      if (MapList.get(i).get(key) != null){
        Integer[] values = new Integer[2];
        values[1] = MapList.get(i).get(key);
        values[0] = currentScope - i;
        return values;
      }
    }
    return null;
  }

  public Assembler(String filename) {
    System.out.println("* C-Minus Compilation to TM Code");
    System.out.println("* File: " + (filename.substring(0, filename.length()-2) + "tm"));
    System.out.println("* Standard prelude:\n"+
    "  0:     LD  6,0(0) 	load gp with maxaddress\n"+
    "  1:    LDA  5,0(6) 	copy to gp to fp\n"+
    "  2:     ST  0,0(0) 	clear location 0\n"+
    "* Jump around i/o routines here\n"+
    "* code for input routine\n"+
    "  4:     ST  0,-1(5) 	store return\n"+
    "  5:     IN  0,0,0 	input\n"+
    "  6:     LD  7,-1(5) 	return to caller\n"+
    "* code for output routine\n"+
    "  7:     ST  0,-1(5) 	store return\n"+
    "  8:     LD  0,-2(5) 	load output value\n"+
    "  9:    OUT  0,0,0 	output\n"+
    " 10:     LD  7,-1(5) 	return to caller\n"+
    "  3:    LDA  7,7(7) 	jump around i/o code\n"+
    "* End of standard prelude.");
    stack = new ArrayList<APatchLine>();
    instructionCnt = 11;
    varCnt = 0;
    this.MapList = new ArrayList<HashMap<String,Integer>>();
    functionMap = new HashMap<String, Integer>();
    functionMap.put("input", 4);
    functionMap.put("output", 7);
    addScope();
  }

  public void finale() {


      String temp = "Call"+patchCount++;
      //move pc to reg 0
      writeAsm(instructionCnt++, Operations.LDA, 0, 0, 7, "PC stuff");
      //move val to reg 1
      stack.add(new APatchLine(instructionCnt++, Operations.LDC, 1, 0, temp, "Creating Offset"));
      //add reg 1 to pc
      writeAsm(instructionCnt++, Operations.ADD, 0, 0, 1, "More PC Stuff");
      //move reg 0 to stack;
      writeAsm(instructionCnt++, Operations.ST, 0, varCnt-1, 5, "Storing Pc");
      writeAsm(instructionCnt++, Operations.ST, 5, varCnt-3, 5, "Storing FP");
      writeAsm(instructionCnt++, Operations.LDA, 5, varCnt-3, 5, "Updating FP");
      addScope();
      int lineNum = functionMap.get("main");
      writeAsm(instructionCnt++, Operations.LDA, 7, lineNum - instructionCnt, 7, "jumping to function");
      checkPatchLine(temp, instructionCnt+1);
      writeAsm(instructionCnt++, Operations.LD, 5, 1, 5, "load old fp");
      writeAsm(instructionCnt++, Operations.HALT, 0, 0, 0,"HALLTTTT");
  }

  /* add assembly line to output StringBuilder */
  private void writeAsm(int address, Operations oper, int r, int s, int t, String comment) {
    String addr = String.format("%1$3s", Integer.toString(address));
    String op = String.format("%1$6s", oper.name());
    if(registerOnly.contains(oper)) {
      System.out.println(addr + ": " + op + "  " + r + "," + s + "," + t + " \t" + comment);
    }
    else {
      System.out.println(addr + ": " + op + "  " + r + "," + s + "(" + t + ")" + " \t"  +  comment);
    }
  }

  private void writeComment(String comment) {
    System.out.println("* " + comment);
  }

  public int visit( ArrayDec exp) {
    varCnt-=exp.size;
    addToScope(exp.ID, varCnt);
    varCnt--;
    writeAsm(instructionCnt++, Operations.LDC, VAL, exp.size,0, "Load array sive into reg 3");
    writeAsm(instructionCnt++, Operations.ST, VAL, varCnt,5, "Storing array size");
    return 2;
  }

  public int visit( AssignExp exp) {
    writeComment("Assign Exp");
    int cmd = 3;
    cmd += exp.rhs.accept(this);
    writeAsm(instructionCnt++, Operations.ST, VAL, --varCnt, FP, "Saving  rhs result to stack");
    cmd += exp.lhs.accept(this);
    // store into address of lhs var
    writeAsm(instructionCnt++, Operations.LD, AC, varCnt++, FP, "Saving rhs back to reg 0");
    writeAsm(instructionCnt++, Operations.ST, AC, 0, ADR, "Assigning rhs to lhs");
    return cmd;
  }

  public int visit( CallExp exp) {

    writeComment("Call Exp");
    int cmds = 0;
    int tmps2 = 0;
    //check if call is input or output
    if (exp.ID.compareTo("input") == 0) {
      writeAsm(instructionCnt++, Operations.ST, 0, --varCnt, 5, "Store reg 0");
      writeAsm(instructionCnt++, Operations.ST, 5, --varCnt, 5, "Store the fp");
      writeAsm(instructionCnt++, Operations.LDA, 5, varCnt, 5, "Create new fp");
      writeAsm(instructionCnt++, Operations.LDA, 0, 1, 7, "Store Pc with offset");
      int offset = functionMap.get("input");
      writeAsm(instructionCnt++, Operations.LDA, 7, offset-instructionCnt,7, "move return add to reg 0");
      writeAsm(instructionCnt++, Operations.LD, 5, 0, 5, "Reload the fp");
      varCnt++;
      writeAsm(instructionCnt++, Operations.LDA, 3, 0, 0, "Store results");
      writeAsm(instructionCnt++, Operations.LD, 0, varCnt, 5, "Restore reg 0");
    } else if (exp.ID.compareTo("output") == 0) {
      exp.args.accept(this);
      //output
      writeAsm(instructionCnt++, Operations.ST, 0, --varCnt, 5, "Store reg 0");
      writeAsm(instructionCnt++, Operations.ST, 5, --varCnt, 5, "Store the fp");
      writeAsm(instructionCnt++, Operations.LDA, 5, varCnt, 5, "Create new fp");
      writeAsm(instructionCnt++, Operations.ST, 3, -2, 5, "Storing outputn value");
      writeAsm(instructionCnt++, Operations.LDA, 0, 1, 7, "Store Pc with offset");
      int offset = functionMap.get("output");
      writeAsm(instructionCnt++, Operations.LDA, 7, offset-instructionCnt,7, "move return add to reg 0");
      writeAsm(instructionCnt++, Operations.LD, 5, 0, 5, "Reload the fp");
      varCnt++;
      writeAsm(instructionCnt++, Operations.LD, 0, varCnt, 5, "Restore reg 0");
    } else {
      String temp = "Call"+patchCount++;
      writeAsm(instructionCnt++, Operations.ST, 0, --varCnt, 5, "Store reg 0");
      writeAsm(instructionCnt++, Operations.ST, 1, --varCnt, 5, "Store reg 1");
      cmds+=11;
      //move pc to reg 0
      writeAsm(instructionCnt++, Operations.LDA, 0, 0, 7, "PC stuff");
      //move val to reg 1
      stack.add(new APatchLine(instructionCnt++, Operations.LDC, 1, 0, temp, "Creating Offset"));
      //add reg 1 to pc
      writeAsm(instructionCnt++, Operations.ADD, 0, 0, 1, "More PC Stuff");
      //move reg 0 to stack;
      writeAsm(instructionCnt++, Operations.ST, 0, --varCnt, 5, "Storing Pc");
      --varCnt;
      writeAsm(instructionCnt++, Operations.ST, 5, --varCnt, 5, "Storing FP");
      writeAsm(instructionCnt++, Operations.LDA, 5, varCnt, 5, "UPdating FP");
      addScope();
      tmps2 = varCnt;
      varCnt=0;
      if (exp.args != null) cmds += exp.args.accept(this, 1);
      int lineNum = functionMap.get(exp.ID);
      writeAsm(instructionCnt++, Operations.LDA, 7, lineNum - instructionCnt, 7, "jumping to function");
      varCnt = tmps2;
      checkPatchLine(temp, instructionCnt+1);
      writeAsm(instructionCnt++, Operations.LD, 2, 2, 5, "Load returna");
      writeAsm(instructionCnt++, Operations.LD, 5, 0, 5, "load old fp");
      varCnt+=3;
      writeAsm(instructionCnt++, Operations.LD, 1, varCnt++, 5, "restore reg 1");
      writeAsm(instructionCnt++, Operations.LD, 0, varCnt++, 5, "restore reg 0");
      cmds+=3;
    }
    return cmds;
  }
  public int visit( CompoundExp exp) {
    int cmds = 0;
    if (exp.vars != null) {cmds = exp.vars.accept(this);}
    if (exp.exps != null) {cmds = cmds + exp.exps.accept(this);}
    return cmds;
  }
  public int visit( DecList decList) {
    int cmds = 0;
    while( decList != null ) {
      cmds += decList.head.accept( this);
      decList = decList.tail;
    }
    return cmds;
  }

  public int visit( ExpList expList) {
    int cmds = 0;
    while( expList != null ) {
      cmds += expList.head.accept( this);
      expList = expList.tail;
    }
    return cmds;
  }

  public int visit( ExpList expList, int blah) {
    int cmds = 0;
    while( expList != null ) {
      cmds += expList.head.accept( this);
      writeAsm(instructionCnt++, Operations.ST, 3, --varCnt, 5, "add params");
      expList = expList.tail;
    }
    return cmds;
  }


  public int visit ( FunctionDec exp) {
    varCnt = 0;
    int cmds = 1;
    scopeCount = 0;
    addScope();
    stack.add(new APatchLine(instructionCnt++, Operations.LDA, PC, PC, "function", "jump around fn body"));
    functionMap.put(exp.ID, instructionCnt);
    writeComment("processing function: "+exp.ID);
    if (exp.params!=null)cmds += exp.params.accept(this);
    if (exp.exps!=null)cmds += exp.exps.accept(this);
    writeAsm(instructionCnt++, Operations.LD, 7, 2, 5, "Loading PC");
    checkPatchLine("function", instructionCnt);
    deleteScope();
    return cmds;
  }

  public int visit( IfExp exp) {
    writeComment("If Exp");
    int cmds = 0;
    writeComment("If Part");
    cmds += exp.ifpart.accept(this);
    String temp = "if"+patchCount++;
    String comment = "Jump to ";
    if (!(exp.elsepart instanceof NillExp)) {
      comment = comment + "else";
    } else {
      comment = comment + "end if";
    }
    stack.add(new APatchLine(instructionCnt++, Operations.JLE, VAL, PC, temp, comment));
    cmds++;
    addScope();
    scopeCount++;
    writeAsm(instructionCnt++, Operations.ST, 5, --varCnt, 5, "Storing FP");
    writeAsm(instructionCnt++, Operations.LDA, 5, varCnt, 5, "Loading new FP");
    cmds =+ 2;
    cmds += exp.thenpart.accept(this);
    deleteScope();
    scopeCount--;
    writeAsm(instructionCnt++, Operations.LD, 5, 0, 5, "reloading FP");
    cmds ++;
    varCnt++;
    if (!(exp.elsepart instanceof NillExp)) {
      writeComment("Else Part");
      String temp2 = "else"+patchCount++;
      addScope();
      scopeCount++;
      writeAsm(instructionCnt++, Operations.ST, 5, --varCnt, 5, "Storing FP");
      writeAsm(instructionCnt++, Operations.LDA, 5, varCnt, 5, "Loading new FP");
      cmds += 2;
      stack.add(new APatchLine(instructionCnt++, Operations.LDA,PC,PC,temp2, "Jump to end if"));
      cmds++;
      checkPatchLine(temp, instructionCnt);
      cmds += exp.elsepart.accept(this);
      checkPatchLine(temp2, instructionCnt);
      deleteScope();
      scopeCount--;
      writeAsm(instructionCnt++, Operations.LD, 5, 0, 5, "reloading FP");
    } else {
      checkPatchLine(temp, instructionCnt);
    }
    return cmds;
  }

  public int visit( IntExp exp) {
    writeComment("Int Exp");
    writeAsm(instructionCnt++, Operations.LDC, VAL, Integer.parseInt(exp.value), 0, "loading constant to reg 3");
    return 1;
  }

  public int visit( OpExp exp) {
    writeComment("Op Exp");
    int cmds = 3;
    cmds += exp.left.accept(this);
    //move reg 3 to 0 LD
    // save reg 0 to reg 2 because rhs will use reg 0
    writeAsm(instructionCnt++, Operations.ST, 3, --varCnt, 5, "saving reg 0 to stack");
    cmds += exp.right.accept(this);
    //move 3 to 1
    writeAsm(instructionCnt++, Operations.LD, 0,varCnt++,5, "saving lhs back to reg 0");
    writeAsm(instructionCnt++, Operations.LDA, AC1, AC, VAL,"moving rhs");
    // do op on 0and 1 and move to 3
    switch (exp.op) {
      case OpExp.PLUS:
        writeAsm(instructionCnt++, Operations.ADD, VAL, AC, AC1, "adding rhs to lhs");
        cmds++;
        break;
      case OpExp.MINUS:
        writeAsm(instructionCnt++, Operations.SUB, VAL, AC, AC1, "substracting rsh from lhs");
        cmds++;
        break;
      case OpExp.TIMES:
        writeAsm(instructionCnt++, Operations.MUL, VAL, AC, AC1, "multiplying lsh and rhs");
        cmds++;
        break;
      case OpExp.OVER:
        writeAsm(instructionCnt++, Operations.DIV, VAL, AC, AC1, "dividing lhs by rhs");
        cmds++;
        break;
      case OpExp.EQ:
        writeAsm(instructionCnt++, Operations.SUB, AC, AC, AC1, "substracting rsh from lhs");
        writeAsm(instructionCnt++, Operations.MUL, AC, AC, AC, "multiplying lsh and rhs");
        writeAsm(instructionCnt++, Operations.LDC, AC1, -1, 0, "moving -1 to reg 1");
        writeAsm(instructionCnt++, Operations.MUL, AC, AC, AC1, "multiplying lsh and rhs");
        writeAsm(instructionCnt++, Operations.SUB, VAL, AC, AC1, "subtracting rhs from lhs");
        cmds+=5;
        break;
      case OpExp.NEQ:
        writeAsm(instructionCnt++, Operations.SUB, AC, AC, AC1, "substracting rsh from lhs");
        writeAsm(instructionCnt++, Operations.MUL, VAL, AC, AC, "multiplying lsh and rhs");
        cmds+=2;
        break;
      case OpExp.LT:
        writeAsm(instructionCnt++, Operations.SUB, VAL, AC1, AC, "substracting lhs from rhs");
        cmds++;
        break;
      case OpExp.LEQ:
        writeAsm(instructionCnt++, Operations.SUB, AC, AC1, AC, "substracting lhs from rhs");
        writeAsm(instructionCnt++, Operations.LDC, AC1, 1, 0, "moving 1 to reg 1");
        writeAsm(instructionCnt++, Operations.ADD, VAL, AC, AC1, "adding rhs to lhs");
        cmds+=3;
        break;
      case OpExp.GT:
        writeAsm(instructionCnt++, Operations.SUB, VAL, AC, AC1, "substracting rsh from lhs");
        cmds++;
        break;
      case OpExp.GEQ:
        writeAsm(instructionCnt++, Operations.SUB, AC, AC, AC1, "substracting lhs from rhs");
        writeAsm(instructionCnt++, Operations.LDC, AC1, 1, 0, "moving 1 to reg 1");
        writeAsm(instructionCnt++, Operations.ADD, VAL, AC, AC1, "adding rhs to lhs");
        cmds+=3;
        break;
      default:
      System.err.println("Y'ALL FUCKING BROKE SHIT");
        break;
    }
    writeComment("End Op Exp");
    return cmds;
  }

  public int visit( ReturnExp exp) {
    writeComment("Return exp");
    int cmds = exp.exp.accept(this);
    writeAsm(instructionCnt++, Operations.LDA, 4, 0, 5, "loading fp to reg 4");
    for (int i=0;i<scopeCount;i++){
      writeAsm(instructionCnt++, Operations.LD, 4, 0, 4, "going to scope");
    }
    writeAsm(instructionCnt++, Operations.ST, 3, 1, 4, "Storing the return value");

    writeAsm(instructionCnt++, Operations.LDA, 5, 0, 4, "load old fp");
    writeAsm(instructionCnt++, Operations.LD, 2, 2, 5, "Load return address");
    varCnt+=3;
    //  writeAsm(instructionCnt++, Operations.LD, 1, varCnt++, 5, "restore reg 1");
    //  writeAsm(instructionCnt++, Operations.LD, 0, varCnt++, 5, "restore reg 0");
      writeAsm(instructionCnt++, Operations.LDA, 7, 0, 2, "Loading return add");
      cmds+=3;
    return cmds + 1;
  }

  public int visit( SimpleDec exp) {
    addToScope(exp.ID, --varCnt);
    return 0;
  }

  public int visit( VarExp exp) {
    return exp.var.accept(this);
  }

  public int visit ( WhileExp exp) {
    writeComment("While Exp");
    int cmds = 1;
    cmds += exp.condition.accept(this);
    String temp = "while"+patchCount++;
    stack.add(new APatchLine(instructionCnt++, Operations.JLE, VAL, PC, temp, "while condition"));
    writeAsm(instructionCnt++, Operations.ST, 5, --varCnt, 5, "Storing FP");
    writeAsm(instructionCnt++, Operations.LDA, 5, varCnt, 5, "Storing FP");
    cmds+=2;
    addScope();
    scopeCount++;
    cmds += exp.body.accept(this);
    deleteScope();
    scopeCount--;
    writeAsm(instructionCnt++, Operations.LD, 5, 0, 5, "Storing FP");
    cmds++;
    varCnt++;
    writeAsm(instructionCnt++, Operations.LDA, PC, 0-cmds-1, PC, "While end");
    cmds++;
    checkPatchLine(temp, instructionCnt);
    return cmds;
  }

  public int visit ( SimpleVarExp exp) {
    writeComment("Simple Var Exp");
    int cmds = 3;
    Integer[] vals = isDeclared(exp.name);
    writeAsm(instructionCnt++, Operations.LDA, ADR, 0, FP, "Loading FP");
    for (int i = 0; i < vals[0] ; i++) {
      writeAsm(instructionCnt++, Operations.LD, ADR, 0, ADR, "Loading Old FP");
      cmds++;
    }
    writeAsm(instructionCnt++, Operations.LDA, ADR, vals[1], ADR, "Loading Variable Address To Reg 4");
    writeAsm(instructionCnt++, Operations.LD, VAL, 0, ADR, "Loading varialble value");
    return cmds;
  }

  public int visit ( IndexVarExp exp) {
    writeComment("Index Var Exp");
    int cmds = 9;
    cmds += exp.index.accept(this);
    // get index exp value into 3
    writeAsm(instructionCnt++, Operations.LDA, AC, 0, VAL,"Moving rhs");
    Integer[] vals = isDeclared(exp.name);
    writeAsm(instructionCnt++, Operations.LDA, ADR, 0, FP, "Loading FP");
    for (int i = 0; i < vals[0] ; i++) {
      writeAsm(instructionCnt++, Operations.LDA, ADR, 0, ADR, "Loading Old FP");
      cmds++;
    }
    writeAsm(instructionCnt++, Operations.LDA, ADR, vals[1], ADR, "Loading Address of array size to Reg 4");
    writeAsm(instructionCnt++, Operations.LD, VAL, -1, ADR, "Loading array size to reg 3");
    writeAsm(instructionCnt++, Operations.SUB, AC1, VAL, AC, "Sub reg 3 by reg 0");
    writeAsm(instructionCnt++,Operations.JGT, AC1, 1, 7, "Jump past halt if index < array size");


      writeAsm(instructionCnt++, Operations.ST, 5, --varCnt, 5, "Store the fp");
      writeAsm(instructionCnt++, Operations.LDA, 5, varCnt, 5, "Create new fp");
      writeAsm(instructionCnt++, Operations.LDC, 3, 69420, 0, "Loading Error value");
      writeAsm(instructionCnt++, Operations.ST, 3, -2, 5, "Storing outputn value");
      writeAsm(instructionCnt++, Operations.LDA, 0, 1, 7, "Store Pc with offset");
      int offset = functionMap.get("output");
      writeAsm(instructionCnt++, Operations.LDA, 7, offset-instructionCnt,7, "move return add to reg 0");
      writeAsm(instructionCnt++, Operations.LD, 5, 0, 5, "Reload the fp");
    writeAsm(instructionCnt++, Operations.HALT, 0, 0, 0, "Kill");

    writeAsm(instructionCnt++, Operations.ADD, ADR, AC, ADR, "add index to array address");
    writeAsm(instructionCnt++, Operations.LD, VAL, 0, ADR, "load value at array index to reg 3");
    return cmds;
  }

  public int visit ( NillExp exp) {
    scopeCount++;
    writeAsm(instructionCnt++, Operations.LDC, 3, 0, 0, "Set return var");
    writeAsm(instructionCnt++, Operations.ST, 3, 2, 5, "Set return var");
    scopeCount--;
    return 2;
  }

  public int visit ( TypeSpec exp) {return 0;}
}
