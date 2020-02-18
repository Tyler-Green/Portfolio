package absyn;

import symbol.*;
import Assembler.*;

public class SimpleVarExp extends Exp {
  public String name;

  public SimpleVarExp( int row, int col, String name ) {
    this.row = row;
    this.col = col;
    this.name = name;
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
