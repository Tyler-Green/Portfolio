package absyn;

import symbol.*;
import Assembler.*;

public class ExpList extends Absyn {
  public Exp head;
  public ExpList tail;

  public ExpList( Exp head, ExpList tail ) {
    this.head = head;
    this.tail = tail;
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

  public int accept( AssemblerVisitor visitor, int blah) {
    return visitor.visit( this ,blah);
  }
}
