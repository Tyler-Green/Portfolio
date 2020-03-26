package absyn;

import symbol.*;
import Assembler.*;

public class DecList extends Absyn {
  public Dec head;
  public DecList tail;

  public DecList( Dec head, DecList tail ) {
    this.head = head;
    this.tail = tail;
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
