package absyn;

import symbol.*;
import Assembler.*;

public class CompoundExp extends Exp{
  public DecList vars;
  public ExpList exps;

  public CompoundExp(int row, int col, DecList vars, ExpList exps) {
    this.row = row;
    this.col = col;
    this. vars = vars;
    this.exps = exps;
  }

  public void accept( AbsynVisitor visitor, int level ) {
    visitor.visit( this, level );
  }

  public int accept( SemanticVisitor visitor, int isBlock) {
    return visitor.visit( this , isBlock );
  }

  public int accept( SemanticVisitor visitor) {
    return visitor.visit( this );
  }

  public int accept( AssemblerVisitor visitor) {
    return visitor.visit( this );
  }
}
