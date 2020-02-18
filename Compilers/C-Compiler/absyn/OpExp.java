package absyn;

import symbol.*;
import Assembler.*;

public class OpExp extends Exp {
  public final static int PLUS  	=  0;
  public final static int MINUS 	=  1;
  public final static int TIMES 	=  2;
  public final static int OVER  	=  3;
  public final static int EQ    	=  4;
  public final static int LT    	=  5;
  public final static int GT    	=  6;
  public final static int ASSIGN	=  7;
  public final static int NEQ		  =  8;
  public final static int LEQ		  =  9;
  public final static int GEQ		  = 10;

  public Exp left;
  public int op;
  public Exp right;

  public OpExp( int row, int col, Exp left, int op, Exp right ) {
    this.row = row;
    this.col = col;
    this.left = left;
    this.op = op;
    this.right = right;
  }

  public void accept( AbsynVisitor visitor, int level ) {
    visitor.visit( this, level );
  }

  public int accept( SemanticVisitor visitor) {
    return visitor.visit( this );
  }

  public int accept( AssemblerVisitor visitor) {
    return visitor.visit( this );
  }
}
