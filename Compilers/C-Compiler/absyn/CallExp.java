package absyn;

import symbol.*;
import Assembler.*;

public class CallExp extends Exp {
  public String ID;
  public ExpList args;

  public CallExp( int row, int col, String ID, ExpList args ) {
    this.row = row;
    this.col = col;
    this.ID = ID;
    this.args = args;
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
