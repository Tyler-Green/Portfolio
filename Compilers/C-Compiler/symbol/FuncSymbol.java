package symbol;

import java.util.*;
import absyn.*;

public class FuncSymbol extends Symbol {

  private List<Integer> paramTypes;

  public FuncSymbol(int row, int col, String ID, int type, DecList params) {
    super(row, col, ID, type);

    if (params != null) {
      this.paramTypes = new ArrayList<>();
      do {
        if (params.head instanceof ArrayDec) {
          this.paramTypes.add(Symbol.ARRAY);
        } else {
          this.paramTypes.add(params.head.type.type);
        }
        params = params.tail;
      } while (params != null);
    } else {
      this.paramTypes = null;
    }
  }

  public FuncSymbol(int row, int col, String ID, int type, List<Integer> params) {
    super(row, col, ID, type);
    this.paramTypes = params;
  }

  public List<Integer> getParamTypes() {
    return paramTypes;
  }

  @Override
  public void printSymbol() {
    String sym;
    if (paramTypes != null || paramTypes.size() == 0) {
      sym = super.getID()+": ( ";
      for (Integer type: paramTypes) {
        sym+=typeToStr(type)+" ";
      }
      sym+=") -> "+ typeToStr(super.getType());
      }
    else {sym = super.getID()+": () -> "+ typeToStr(super.getType());}
    System.out.println(sym);
  }
}
