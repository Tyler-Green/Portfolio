package absyn;

public interface AbsynVisitor {

  public void visit( ArrayDec exp, int level );

  public void visit( AssignExp exp, int level );

  public void visit( CallExp exp, int level );

  public void visit( CompoundExp exp, int level );

  public void visit( DecList decList, int level );

  public void visit( ExpList expList, int level );

  public void visit ( FunctionDec exp, int level );

  public void visit( IfExp exp, int level );

  public void visit( IntExp exp, int level );

  public void visit( OpExp exp, int level );

  public void visit( ReturnExp exp, int level );

  public void visit( SimpleDec exp, int level );

  public void visit( VarExp exp, int level );

  public void visit ( WhileExp exp, int Level );

  public void visit ( SimpleVarExp exp, int Level );

  public void visit ( IndexVarExp exp, int Level );

  public void visit ( NillExp exp, int Level );

  public void visit ( TypeSpec exp, int Level );
}
