package absyn;

import symbol.*;
import Assembler.*;

public class ArrayDec extends Dec{

  public  int size;

  public ArrayDec(int row, int col, String ID, int size, TypeSpec type){
    super(row,col,ID,type);
    this.size = size;
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
