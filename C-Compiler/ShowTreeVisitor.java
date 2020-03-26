import absyn.*;

public class ShowTreeVisitor implements AbsynVisitor {

  final static int SPACES = 4;

  private void indent( int level ) {
    for( int i = 0; i < level * SPACES; i++ ) System.out.print( " " );
  }

  private void printType(int type) {
	  switch(type) {
		  case Dec.INT:
		  System.out.println("INT");
		  break;
		  case Dec.VOID:
		  System.out.println("VOID");
		  break;
		  default :
		  System.out.println("UNKNOWN");
		  break;
	  };
  }

  public void visit ( ArrayDec exp, int level) {
	  indent(level);
    if (exp.size != 0)
	     System.out.print("ArrayDec: "+exp.ID+"["+exp.size+"] - ");
    else
       System.out.print("ArrayDec: "+exp.ID+"[] - ");
	  printType(exp.type.type);
  }

  public void visit( AssignExp exp, int level ) {
    indent( level );
    System.out.println( "AssignExp:" );
    level++;
    if (exp.lhs != null) exp.lhs.accept( this, level );
    if (exp.rhs != null) exp.rhs.accept( this, level );
  }

  public void visit(CallExp exp, int level) {
	indent(level);
	System.out.println("CallExp: " + exp.ID);
	if (exp.args != null) exp.args.accept(this, ++level);
  }

  public void visit(CompoundExp exp, int level) {
	  indent(level);
	  System.out.println("CompoundExp:");
	  level++;
	  if (exp.vars != null) exp.vars.accept(this, level);
	  if (exp.exps != null) exp.exps.accept(this, level);
  }

  public void visit( DecList expList, int level ) {
	  while( expList != null ) {
      expList.head.accept( this, level );
      expList = expList.tail;
    }
  }

  public void visit( ExpList expList, int level ) {
    while( expList != null ) {
      expList.head.accept( this, level );
      expList = expList.tail;
    }
  }

  public void visit( FunctionDec exp, int level ) {
	  indent(level);
	  System.out.print("FunctionDec: "+exp.ID+" - ");
	  printType(exp.type.type);
	  level++;
	  if (exp.params != null) exp.params.accept(this, level);
	  if (exp.exps != null) exp.exps.accept(this, level);
  }

  public void visit( IfExp exp, int level ) {
    indent( level );
    System.out.println( "IfExp:" );
    level++;
    if (exp.ifpart != null) exp.ifpart.accept( this, level );
    if (exp.thenpart != null) exp.thenpart.accept( this, level );
    if (exp.elsepart != null ) exp.elsepart.accept( this, level );
  }

  public void visit( IntExp exp, int level ) {
    indent( level );
    System.out.println( "IntExp: " + exp.value );
  }

  public void visit( OpExp exp, int level ) {
    indent( level );
    System.out.print( "OpExp: " );
    switch( exp.op ) {
      case OpExp.PLUS:
        System.out.println( " + " );
        break;
      case OpExp.MINUS:
        System.out.println( " - " );
        break;
      case OpExp.TIMES:
        System.out.println( " * " );
        break;
      case OpExp.OVER:
        System.out.println( " / " );
        break;
      case OpExp.EQ:
        System.out.println( " == " );
        break;
      case OpExp.LT:
        System.out.println( " < " );
        break;
      case OpExp.GT:
        System.out.println( " > " );
        break;
      case OpExp.ASSIGN:
        System.out.println( " = " );
        break;
      case OpExp.NEQ:
        System.out.println( " != " );
        break;
      case OpExp.LEQ:
        System.out.println( " <= " );
        break;
      case OpExp.GEQ:
        System.out.println( " >= " );
        break;
      default:
        System.out.println( "Unrecognized operator at line " + exp.row + " and column " + exp.col);
    }
    level++;
    if (exp.left != null) exp.left.accept( this, level );
    if (exp.right != null) exp.right.accept( this, level );
  }

  public void visit(ReturnExp exp, int level) {
	  indent(level);
	  System.out.println("ReturnExp:");
	  if (exp.exp != null) exp.exp.accept(this, ++level);
  }

  public void visit( SimpleDec exp, int level ) {
	  indent(level);
	  System.out.print("SimpleDec: "+exp.ID+" - ");
	  printType(exp.type.type);
  }

  public void visit( VarExp exp, int level ) {
    indent( level );
    System.out.println( "VarExp: ");
	if (exp.var != null) exp.var.accept(this, ++level);
  }

  public void visit( WhileExp exp, int level ) {
	  indent(level);
	  System.out.println("WhileExp:");
	  level++;
	  if (exp.condition != null) exp.condition.accept(this, level);
	  if (exp.body != null) exp.body.accept(this, level);
  }

  public void visit (SimpleVarExp exp, int level) {
	  indent(level);
	  System.out.println("SimpleVar: "+exp.name);
  }
  public void visit(IndexVarExp exp, int level) {
	  indent(level);
	  System.out.println("IndexVar: "+exp.name);
	  if (exp.index != null) exp.index.accept(this, ++level);
  }

  public void visit( NillExp exp, int level ) {
    indent( level );
    System.out.println( "NilExp: ");
  }

  public void visit(TypeSpec exp, int level){
    indent( level );
  }
}
