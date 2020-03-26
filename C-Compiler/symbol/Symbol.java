package symbol;

import java.util.*;
import absyn.*;

public class Symbol {

  private String ID;
  private int type;
  private int row;
  private int col;
  private int addr;

  public static final int INT = 0;
  public static final int VOID = 1;
  public static final int ARRAY = 2;

  public Symbol(int row, int col, String ID, int type) {
    this.ID = ID;
    this.row = row;
    this.col=col;
    this.type = type;
    this.addr = 0;
  }

  public int getType() {
    return type;
  }

  public String getID() {
    return ID;
  }

  public int getRow() {
    return row;
  }

  public int getCol() {
    return col;
  }

  public int getAddr() {
    return addr;
  }

  protected void printSymbol() {
    String sym = ID+": "+ typeToStr(type);
    System.out.println(sym);
  }

  protected String typeToStr(int type) {
	  if (type == Symbol.INT)
		  return "INT";
		if (type == Symbol.VOID)
		  return "VOID";
    if (type == Symbol.ARRAY)
      return "INT[]";
    else
		  return "UNKNOWN";
  }

}
