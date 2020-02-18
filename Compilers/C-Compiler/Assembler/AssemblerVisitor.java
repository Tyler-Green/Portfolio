package Assembler;

import absyn.*;

public interface AssemblerVisitor {

  public int visit( ArrayDec exp);

  public int visit( AssignExp exp);

  public int visit( CallExp exp);

  public int visit( CompoundExp exp);

  public int visit( DecList decList);

  public int visit( ExpList expList);

  public int visit ( FunctionDec exp);

  public int visit( IfExp exp);

  public int visit( IntExp exp);

  public int visit( OpExp exp);

  public int visit( ReturnExp exp);

  public int visit( SimpleDec exp);

  public int visit( VarExp exp);

  public int visit ( WhileExp exp);

  public int visit ( SimpleVarExp exp);

  public int visit ( IndexVarExp exp);

  public int visit ( NillExp exp);

  public int visit ( TypeSpec exp);

  public int visit( ExpList exp, int blah);
}
