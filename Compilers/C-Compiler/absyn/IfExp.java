package absyn;

import symbol.*;
import Assembler.*;

public class IfExp extends Exp {
  public Exp ifpart;
  public Exp thenpart;
  public Exp elsepart;

  public IfExp( int row, int col, Exp ifpart, Exp thenpart, Exp elsepart ) {
    this.row = row;
    this.col = col;
    this.ifpart = ifpart;
    this.thenpart = thenpart;
    this.elsepart = elsepart;
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
