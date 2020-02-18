package Assembler;
public class APatchLine {
  public int lineNum;
  public Assembler.Operations instruction;
  public int param1;
  public int param3;
  public String waitingForString;
  public String comment;
  public APatchLine(int _lineNum, Assembler.Operations _instruction, int _param1, int _param3, String _waitingForString, String _comment) {
    lineNum = _lineNum;
    instruction = _instruction;
    param1 = _param1;
    param3 = _param3;
    waitingForString = _waitingForString;
    comment = _comment;
  }
}
