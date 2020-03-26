package absyn;

import symbol.*;
import Assembler.*;

public class TypeSpec extends Absyn{

  public int type;

  public TypeSpec(int row, int col, int type){
    this.row = row;
    this.col = col;
    this.type = type;
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
