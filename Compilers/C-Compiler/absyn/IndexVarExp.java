package absyn;

import symbol.*;
import Assembler.*;

public class IndexVarExp extends Exp {
  public String name;
  public Exp index;


  public IndexVarExp( int row, int col, String name, Exp index) {
    this.row = row;
    this.col = col;
    this.name = name;
    this.index = index;
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
