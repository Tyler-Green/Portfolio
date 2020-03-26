package absyn;

import symbol.*;
import Assembler.*;

public class NillExp extends Exp {

  public NillExp( int row, int col) {
    this.row = row;
    this.col = col;
  }

  public void accept( AbsynVisitor visitor, int level ) {
    visitor.visit( this, level );
  }

  public int accept( SemanticVisitor visitor) {
    return visitor.visit( this );
  }

  public void accept( AssemblerVisitor visitor) {
    visitor.visit( this );
  }
}
