package absyn;

import symbol.*;
import Assembler.*;

public class ReturnExp extends Exp {
  public Exp exp;

  public ReturnExp( int row, int col, Exp exp ) {
    this.row = row;
    this.col = col;
    this.exp = exp;
  }

  public void accept( AbsynVisitor visitor, int level ) {
    visitor.visit( this, level );
  }

  public int accept( SemanticVisitor visitor) {
    return visitor.visit( this );
  }

  public void accept( AssemblerVisitor visitor) {
    return visitor.visit( this );
  }
}
