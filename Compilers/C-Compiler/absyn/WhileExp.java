package absyn;

import symbol.*;
import Assembler.*;

public class WhileExp extends Exp {
  public Exp condition;
  public Exp body;

  public WhileExp(int row, int col, Exp condition, Exp body ) {
    this.row = row;
    this.col = col;
    this.condition = condition;
    this.body = body;
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
