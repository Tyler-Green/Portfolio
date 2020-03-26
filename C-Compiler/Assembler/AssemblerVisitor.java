package Assembler;

import absyn.*;

public interface AssemblerVisitor {

  public void visit( ArrayDec exp);

  public void visit( AssignExp exp);

  public void visit( CallExp exp);

  public void visit( CompoundExp exp);

  public void visit( DecList decList);

  public void visit( ExpList expList);

  public void visit ( FunctionDec exp);

  public void visit( IfExp exp);

  public void visit( IntExp exp);

  public void visit( OpExp exp);

  public void visit( ReturnExp exp);

  public void visit( SimpleDec exp);

  public void visit( VarExp exp);

  public void visit ( WhileExp exp);

  public void visit ( SimpleVarExp exp);

  public void visit ( IndexVarExp exp);

  public void visit ( NillExp exp);

  public void visit ( TypeSpec exp);

  public void visit( ExpList exp, int blah);
}
