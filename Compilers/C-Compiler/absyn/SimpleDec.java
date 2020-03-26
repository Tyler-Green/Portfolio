package absyn;

import symbol.*;
import Assembler.*;

public class SimpleDec extends Dec{

  public SimpleDec(int row, int col, String ID, TypeSpec type){
    super(row,col,ID,type);
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
