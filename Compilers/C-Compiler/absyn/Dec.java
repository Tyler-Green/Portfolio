package absyn;

abstract public class Dec extends Absyn {
  public final static int INT = 0;
  public final static int VOID = 1;

  public String ID;
  public TypeSpec type;
  public int row, col;

  public Dec(int row, int col, String ID, TypeSpec type){
    this.row = row;
    this.col = col;
    this.ID = ID;
    this.type = type;
  }
}
