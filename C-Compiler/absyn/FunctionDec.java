package absyn;

import symbol.*;
import Assembler.*;

public class FunctionDec extends Dec{

  public CompoundExp exps;
  public DecList params;

  public FunctionDec(int row, int col, String ID, TypeSpec type, DecList params, CompoundExp exps){
    super(row,col,ID,type);
    this.params = params;
    this.exps = exps;
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
