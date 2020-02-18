package absyn;

import symbol.*;
import Assembler.*;

public class AssignExp extends Exp {
  public Exp lhs;
  public Exp rhs;

  public AssignExp( int row, int col, Exp lhs, Exp rhs ) {
    this.row = row;
    this.col = col;
    this.lhs = lhs;
    this.rhs = rhs;
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
