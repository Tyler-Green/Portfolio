package absyn;

import symbol.*;
import Assembler.*;

abstract public class Absyn {
  public int row, col;

  abstract public void accept( AbsynVisitor visitor, int level );
  abstract public int accept( SemanticVisitor visitor);
  abstract public void accept( AssemblerVisitor visitor);
}
