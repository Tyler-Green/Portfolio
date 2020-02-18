package absyn;

import symbol.*;
import Assembler.*;

public class VarExp extends Exp {
  public Exp var;

  public VarExp( int row, int col, Exp var ) {
    this.row = row;
    this.col = col;
    this.var = var;
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
