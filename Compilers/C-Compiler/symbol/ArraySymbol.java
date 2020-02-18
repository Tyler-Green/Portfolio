package symbol;

public class ArraySymbol extends Symbol {

  private int size;

  public ArraySymbol(int row, int col, String ID, int type, int size) {
    super(row, col, ID, type);
    this.size = size;
  }

  int getSize(){
    return size;
  }

  @Override
  public void printSymbol() {
    String sym = super.getID()+": "+ typeToStr(super.INT)+"["+getSize()+"]";
    System.out.println(sym);
  }
}
