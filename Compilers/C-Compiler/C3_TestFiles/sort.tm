* C-Minus Compilation to TM Code
* File: C3_TestFiles/sort.tm
* Standard prelude:
  0:     LD  6,0(0) 	load gp with maxaddress
  1:    LDA  5,0(6) 	copy to gp to fp
  2:     ST  0,0(0) 	clear location 0
* Jump around i/o routines here
* code for input routine
  4:     ST  0,-1(5) 	store return
  5:     IN  0,0,0 	input
  6:     LD  7,-1(5) 	return to caller
* code for output routine
  7:     ST  0,-1(5) 	store return
  8:     LD  0,-2(5) 	load output value
  9:    OUT  0,0,0 	output
 10:     LD  7,-1(5) 	return to caller
  3:    LDA  7,7(7) 	jump around i/o code
* End of standard prelude.
 11:    LDC  3,10(0) 	Load array sive into reg 3
 12:     ST  3,-11(5) 	Storing array size
* processing function: minloc
 14:    LDC  3,0(0) 	Load array sive into reg 3
 15:     ST  3,-1(5) 	Storing array size
* Assign Exp
* Simple Var Exp
 16:    LDA  4,0(5) 	Loading FP
 17:    LDA  4,-2(4) 	Loading Variable Address To Reg 4
 18:     LD  3,0(4) 	Loading varialble value
 19:     ST  3,-7(5) 	Saving  rhs result to stack
* Simple Var Exp
 20:    LDA  4,0(5) 	Loading FP
 21:    LDA  4,-6(4) 	Loading Variable Address To Reg 4
 22:     LD  3,0(4) 	Loading varialble value
 23:     LD  0,-7(5) 	Saving rhs back to reg 0
 24:     ST  0,0(4) 	Assigning rhs to lhs
* Assign Exp
* Index Var Exp
* Simple Var Exp
 25:    LDA  4,0(5) 	Loading FP
 26:    LDA  4,-2(4) 	Loading Variable Address To Reg 4
 27:     LD  3,0(4) 	Loading varialble value
 28:    LDA  0,0(3) 	Moving rhs
 29:    LDA  4,0(5) 	Loading FP
 30:    LDA  4,0(4) 	Loading Address of array size to Reg 4
 31:     LD  3,-1(4) 	Loading array size to reg 3
 32:    SUB  1,3,0 	Sub reg 3 by reg 0
 33:    JGT  1,1(7) 	Jump past halt if index < array size
 34:     ST  5,-7(5) 	Store the fp
 35:    LDA  5,-7(5) 	Create new fp
 36:    LDC  3,69420(0) 	Loading Error value
 37:     ST  3,-2(5) 	Storing outputn value
 38:    LDA  0,1(7) 	Store Pc with offset
 39:    LDA  7,-33(7) 	move return add to reg 0
 40:     LD  5,0(5) 	Reload the fp
 41:   HALT  0,0,0 	Kill
 42:    ADD  4,0,4 	add index to array address
 43:     LD  3,0(4) 	load value at array index to reg 3
 44:     ST  3,-8(5) 	Saving  rhs result to stack
* Simple Var Exp
 45:    LDA  4,0(5) 	Loading FP
 46:    LDA  4,-5(4) 	Loading Variable Address To Reg 4
 47:     LD  3,0(4) 	Loading varialble value
 48:     LD  0,-8(5) 	Saving rhs back to reg 0
 49:     ST  0,0(4) 	Assigning rhs to lhs
* Assign Exp
* Op Exp
* Simple Var Exp
 50:    LDA  4,0(5) 	Loading FP
 51:    LDA  4,-2(4) 	Loading Variable Address To Reg 4
 52:     LD  3,0(4) 	Loading varialble value
 53:     ST  3,-8(5) 	saving reg 0 to stack
* Int Exp
 54:    LDC  3,1(0) 	loading constant to reg 3
 55:     LD  0,-8(5) 	saving lhs back to reg 0
 56:    LDA  1,0(3) 	moving rhs
 57:    ADD  3,0,1 	adding rhs to lhs
* End Op Exp
 58:     ST  3,-8(5) 	Saving  rhs result to stack
* Simple Var Exp
 59:    LDA  4,0(5) 	Loading FP
 60:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
 61:     LD  3,0(4) 	Loading varialble value
 62:     LD  0,-8(5) 	Saving rhs back to reg 0
 63:     ST  0,0(4) 	Assigning rhs to lhs
* While Exp
* Op Exp
* Simple Var Exp
 64:    LDA  4,0(5) 	Loading FP
 65:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
 66:     LD  3,0(4) 	Loading varialble value
 67:     ST  3,-8(5) 	saving reg 0 to stack
* Simple Var Exp
 68:    LDA  4,0(5) 	Loading FP
 69:    LDA  4,-3(4) 	Loading Variable Address To Reg 4
 70:     LD  3,0(4) 	Loading varialble value
 71:     LD  0,-8(5) 	saving lhs back to reg 0
 72:    LDA  1,0(3) 	moving rhs
 73:    SUB  3,1,0 	substracting lhs from rhs
* End Op Exp
 75:     ST  5,-8(5) 	Storing FP
 76:    LDA  5,-8(5) 	Storing FP
* If Exp
* If Part
* Op Exp
* Index Var Exp
* Simple Var Exp
 77:    LDA  4,0(5) 	Loading FP
 78:     LD  4,0(4) 	Loading Old FP
 79:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
 80:     LD  3,0(4) 	Loading varialble value
 81:    LDA  0,0(3) 	Moving rhs
 82:    LDA  4,0(5) 	Loading FP
 83:    LDA  4,0(4) 	Loading Old FP
 84:    LDA  4,0(4) 	Loading Address of array size to Reg 4
 85:     LD  3,-1(4) 	Loading array size to reg 3
 86:    SUB  1,3,0 	Sub reg 3 by reg 0
 87:    JGT  1,1(7) 	Jump past halt if index < array size
 88:     ST  5,-9(5) 	Store the fp
 89:    LDA  5,-9(5) 	Create new fp
 90:    LDC  3,69420(0) 	Loading Error value
 91:     ST  3,-2(5) 	Storing outputn value
 92:    LDA  0,1(7) 	Store Pc with offset
 93:    LDA  7,-87(7) 	move return add to reg 0
 94:     LD  5,0(5) 	Reload the fp
 95:   HALT  0,0,0 	Kill
 96:    ADD  4,0,4 	add index to array address
 97:     LD  3,0(4) 	load value at array index to reg 3
 98:     ST  3,-10(5) 	saving reg 0 to stack
* Simple Var Exp
 99:    LDA  4,0(5) 	Loading FP
100:     LD  4,0(4) 	Loading Old FP
101:    LDA  4,-5(4) 	Loading Variable Address To Reg 4
102:     LD  3,0(4) 	Loading varialble value
103:     LD  0,-10(5) 	saving lhs back to reg 0
104:    LDA  1,0(3) 	moving rhs
105:    SUB  3,1,0 	substracting lhs from rhs
* End Op Exp
107:     ST  5,-10(5) 	Storing FP
108:    LDA  5,-10(5) 	Loading new FP
* Assign Exp
* Index Var Exp
* Simple Var Exp
109:    LDA  4,0(5) 	Loading FP
110:     LD  4,0(4) 	Loading Old FP
111:     LD  4,0(4) 	Loading Old FP
112:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
113:     LD  3,0(4) 	Loading varialble value
114:    LDA  0,0(3) 	Moving rhs
115:    LDA  4,0(5) 	Loading FP
116:    LDA  4,0(4) 	Loading Old FP
117:    LDA  4,0(4) 	Loading Old FP
118:    LDA  4,0(4) 	Loading Address of array size to Reg 4
119:     LD  3,-1(4) 	Loading array size to reg 3
120:    SUB  1,3,0 	Sub reg 3 by reg 0
121:    JGT  1,1(7) 	Jump past halt if index < array size
122:     ST  5,-11(5) 	Store the fp
123:    LDA  5,-11(5) 	Create new fp
124:    LDC  3,69420(0) 	Loading Error value
125:     ST  3,-2(5) 	Storing outputn value
126:    LDA  0,1(7) 	Store Pc with offset
127:    LDA  7,-121(7) 	move return add to reg 0
128:     LD  5,0(5) 	Reload the fp
129:   HALT  0,0,0 	Kill
130:    ADD  4,0,4 	add index to array address
131:     LD  3,0(4) 	load value at array index to reg 3
132:     ST  3,-12(5) 	Saving  rhs result to stack
* Simple Var Exp
133:    LDA  4,0(5) 	Loading FP
134:     LD  4,0(4) 	Loading Old FP
135:     LD  4,0(4) 	Loading Old FP
136:    LDA  4,-5(4) 	Loading Variable Address To Reg 4
137:     LD  3,0(4) 	Loading varialble value
138:     LD  0,-12(5) 	Saving rhs back to reg 0
139:     ST  0,0(4) 	Assigning rhs to lhs
* Assign Exp
* Simple Var Exp
140:    LDA  4,0(5) 	Loading FP
141:     LD  4,0(4) 	Loading Old FP
142:     LD  4,0(4) 	Loading Old FP
143:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
144:     LD  3,0(4) 	Loading varialble value
145:     ST  3,-12(5) 	Saving  rhs result to stack
* Simple Var Exp
146:    LDA  4,0(5) 	Loading FP
147:     LD  4,0(4) 	Loading Old FP
148:     LD  4,0(4) 	Loading Old FP
149:    LDA  4,-6(4) 	Loading Variable Address To Reg 4
150:     LD  3,0(4) 	Loading varialble value
151:     LD  0,-12(5) 	Saving rhs back to reg 0
152:     ST  0,0(4) 	Assigning rhs to lhs
153:     LD  5,0(5) 	reloading FP
106:    JLE  3,47(7) 	Jump to end if
* Assign Exp
* Op Exp
* Simple Var Exp
154:    LDA  4,0(5) 	Loading FP
155:     LD  4,0(4) 	Loading Old FP
156:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
157:     LD  3,0(4) 	Loading varialble value
158:     ST  3,-11(5) 	saving reg 0 to stack
* Int Exp
159:    LDC  3,1(0) 	loading constant to reg 3
160:     LD  0,-11(5) 	saving lhs back to reg 0
161:    LDA  1,0(3) 	moving rhs
162:    ADD  3,0,1 	adding rhs to lhs
* End Op Exp
163:     ST  3,-11(5) 	Saving  rhs result to stack
* Simple Var Exp
164:    LDA  4,0(5) 	Loading FP
165:     LD  4,0(4) 	Loading Old FP
166:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
167:     LD  3,0(4) 	Loading varialble value
168:     LD  0,-11(5) 	Saving rhs back to reg 0
169:     ST  0,0(4) 	Assigning rhs to lhs
170:     LD  5,0(5) 	Storing FP
171:    LDA  7,-71(7) 	While end
 74:    JLE  3,97(7) 	while condition
* Return exp
* Simple Var Exp
172:    LDA  4,0(5) 	Loading FP
173:    LDA  4,-6(4) 	Loading Variable Address To Reg 4
174:     LD  3,0(4) 	Loading varialble value
175:    LDA  4,0(5) 	loading fp to reg 4
176:     ST  3,1(4) 	Storing the return value
177:    LDA  5,0(4) 	load old fp
178:     LD  2,2(5) 	Load return address
179:    LDA  7,0(2) 	Loading return add
180:     LD  7,2(5) 	Loading PC
 13:    LDA  7,167(7) 	jump around fn body
* processing function: sort
182:    LDC  3,0(0) 	Load array sive into reg 3
183:     ST  3,-1(5) 	Storing array size
* Assign Exp
* Simple Var Exp
184:    LDA  4,0(5) 	Loading FP
185:    LDA  4,-2(4) 	Loading Variable Address To Reg 4
186:     LD  3,0(4) 	Loading varialble value
187:     ST  3,-6(5) 	Saving  rhs result to stack
* Simple Var Exp
188:    LDA  4,0(5) 	Loading FP
189:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
190:     LD  3,0(4) 	Loading varialble value
191:     LD  0,-6(5) 	Saving rhs back to reg 0
192:     ST  0,0(4) 	Assigning rhs to lhs
* While Exp
* Op Exp
* Simple Var Exp
193:    LDA  4,0(5) 	Loading FP
194:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
195:     LD  3,0(4) 	Loading varialble value
196:     ST  3,-6(5) 	saving reg 0 to stack
* Op Exp
* Simple Var Exp
197:    LDA  4,0(5) 	Loading FP
198:    LDA  4,-3(4) 	Loading Variable Address To Reg 4
199:     LD  3,0(4) 	Loading varialble value
200:     ST  3,-7(5) 	saving reg 0 to stack
* Int Exp
201:    LDC  3,1(0) 	loading constant to reg 3
202:     LD  0,-7(5) 	saving lhs back to reg 0
203:    LDA  1,0(3) 	moving rhs
204:    SUB  3,0,1 	substracting rsh from lhs
* End Op Exp
205:     LD  0,-6(5) 	saving lhs back to reg 0
206:    LDA  1,0(3) 	moving rhs
207:    SUB  3,1,0 	substracting lhs from rhs
* End Op Exp
209:     ST  5,-6(5) 	Storing FP
210:    LDA  5,-6(5) 	Storing FP
* Assign Exp
* Call Exp
211:     ST  0,-8(5) 	Store reg 0
212:     ST  1,-9(5) 	Store reg 1
213:    LDA  0,0(7) 	PC stuff
215:    ADD  0,0,1 	More PC Stuff
216:     ST  0,-10(5) 	Storing Pc
217:     ST  5,-12(5) 	Storing FP
218:    LDA  5,-12(5) 	UPdating FP
* Simple Var Exp
219:    LDA  4,0(5) 	Loading FP
220:     LD  4,0(4) 	Loading Old FP
221:     LD  4,0(4) 	Loading Old FP
222:    LDA  4,0(4) 	Loading Variable Address To Reg 4
223:     LD  3,0(4) 	Loading varialble value
224:     ST  3,-1(5) 	add params
* Simple Var Exp
225:    LDA  4,0(5) 	Loading FP
226:     LD  4,0(4) 	Loading Old FP
227:     LD  4,0(4) 	Loading Old FP
228:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
229:     LD  3,0(4) 	Loading varialble value
230:     ST  3,-2(5) 	add params
* Simple Var Exp
231:    LDA  4,0(5) 	Loading FP
232:     LD  4,0(4) 	Loading Old FP
233:     LD  4,0(4) 	Loading Old FP
234:    LDA  4,-3(4) 	Loading Variable Address To Reg 4
235:     LD  3,0(4) 	Loading varialble value
236:     ST  3,-3(5) 	add params
237:    LDA  7,-224(7) 	jumping to function
214:    LDC  1,24(0) 	Creating Offset
238:     LD  2,2(5) 	Load returna
239:     LD  5,0(5) 	load old fp
240:     LD  1,-9(5) 	restore reg 1
241:     LD  0,-8(5) 	restore reg 0
242:     ST  3,-8(5) 	Saving  rhs result to stack
* Simple Var Exp
243:    LDA  4,0(5) 	Loading FP
244:     LD  4,0(4) 	Loading Old FP
245:     LD  4,0(4) 	Loading Old FP
246:    LDA  4,-5(4) 	Loading Variable Address To Reg 4
247:     LD  3,0(4) 	Loading varialble value
248:     LD  0,-8(5) 	Saving rhs back to reg 0
249:     ST  0,0(4) 	Assigning rhs to lhs
* Assign Exp
* Index Var Exp
* Simple Var Exp
250:    LDA  4,0(5) 	Loading FP
251:     LD  4,0(4) 	Loading Old FP
252:     LD  4,0(4) 	Loading Old FP
253:    LDA  4,-5(4) 	Loading Variable Address To Reg 4
254:     LD  3,0(4) 	Loading varialble value
255:    LDA  0,0(3) 	Moving rhs
256:    LDA  4,0(5) 	Loading FP
257:    LDA  4,0(4) 	Loading Old FP
258:    LDA  4,0(4) 	Loading Old FP
259:    LDA  4,0(4) 	Loading Address of array size to Reg 4
260:     LD  3,-1(4) 	Loading array size to reg 3
261:    SUB  1,3,0 	Sub reg 3 by reg 0
262:    JGT  1,1(7) 	Jump past halt if index < array size
263:     ST  5,-8(5) 	Store the fp
264:    LDA  5,-8(5) 	Create new fp
265:    LDC  3,69420(0) 	Loading Error value
266:     ST  3,-2(5) 	Storing outputn value
267:    LDA  0,1(7) 	Store Pc with offset
268:    LDA  7,-262(7) 	move return add to reg 0
269:     LD  5,0(5) 	Reload the fp
270:   HALT  0,0,0 	Kill
271:    ADD  4,0,4 	add index to array address
272:     LD  3,0(4) 	load value at array index to reg 3
273:     ST  3,-9(5) 	Saving  rhs result to stack
* Simple Var Exp
274:    LDA  4,0(5) 	Loading FP
275:     LD  4,0(4) 	Loading Old FP
276:    LDA  4,-7(4) 	Loading Variable Address To Reg 4
277:     LD  3,0(4) 	Loading varialble value
278:     LD  0,-9(5) 	Saving rhs back to reg 0
279:     ST  0,0(4) 	Assigning rhs to lhs
* Assign Exp
* Index Var Exp
* Simple Var Exp
280:    LDA  4,0(5) 	Loading FP
281:     LD  4,0(4) 	Loading Old FP
282:     LD  4,0(4) 	Loading Old FP
283:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
284:     LD  3,0(4) 	Loading varialble value
285:    LDA  0,0(3) 	Moving rhs
286:    LDA  4,0(5) 	Loading FP
287:    LDA  4,0(4) 	Loading Old FP
288:    LDA  4,0(4) 	Loading Old FP
289:    LDA  4,0(4) 	Loading Address of array size to Reg 4
290:     LD  3,-1(4) 	Loading array size to reg 3
291:    SUB  1,3,0 	Sub reg 3 by reg 0
292:    JGT  1,1(7) 	Jump past halt if index < array size
293:     ST  5,-9(5) 	Store the fp
294:    LDA  5,-9(5) 	Create new fp
295:    LDC  3,69420(0) 	Loading Error value
296:     ST  3,-2(5) 	Storing outputn value
297:    LDA  0,1(7) 	Store Pc with offset
298:    LDA  7,-292(7) 	move return add to reg 0
299:     LD  5,0(5) 	Reload the fp
300:   HALT  0,0,0 	Kill
301:    ADD  4,0,4 	add index to array address
302:     LD  3,0(4) 	load value at array index to reg 3
303:     ST  3,-10(5) 	Saving  rhs result to stack
* Index Var Exp
* Simple Var Exp
304:    LDA  4,0(5) 	Loading FP
305:     LD  4,0(4) 	Loading Old FP
306:     LD  4,0(4) 	Loading Old FP
307:    LDA  4,-5(4) 	Loading Variable Address To Reg 4
308:     LD  3,0(4) 	Loading varialble value
309:    LDA  0,0(3) 	Moving rhs
310:    LDA  4,0(5) 	Loading FP
311:    LDA  4,0(4) 	Loading Old FP
312:    LDA  4,0(4) 	Loading Old FP
313:    LDA  4,0(4) 	Loading Address of array size to Reg 4
314:     LD  3,-1(4) 	Loading array size to reg 3
315:    SUB  1,3,0 	Sub reg 3 by reg 0
316:    JGT  1,1(7) 	Jump past halt if index < array size
317:     ST  5,-11(5) 	Store the fp
318:    LDA  5,-11(5) 	Create new fp
319:    LDC  3,69420(0) 	Loading Error value
320:     ST  3,-2(5) 	Storing outputn value
321:    LDA  0,1(7) 	Store Pc with offset
322:    LDA  7,-316(7) 	move return add to reg 0
323:     LD  5,0(5) 	Reload the fp
324:   HALT  0,0,0 	Kill
325:    ADD  4,0,4 	add index to array address
326:     LD  3,0(4) 	load value at array index to reg 3
327:     LD  0,-11(5) 	Saving rhs back to reg 0
328:     ST  0,0(4) 	Assigning rhs to lhs
* Assign Exp
* Simple Var Exp
329:    LDA  4,0(5) 	Loading FP
330:     LD  4,0(4) 	Loading Old FP
331:    LDA  4,-7(4) 	Loading Variable Address To Reg 4
332:     LD  3,0(4) 	Loading varialble value
333:     ST  3,-11(5) 	Saving  rhs result to stack
* Index Var Exp
* Simple Var Exp
334:    LDA  4,0(5) 	Loading FP
335:     LD  4,0(4) 	Loading Old FP
336:     LD  4,0(4) 	Loading Old FP
337:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
338:     LD  3,0(4) 	Loading varialble value
339:    LDA  0,0(3) 	Moving rhs
340:    LDA  4,0(5) 	Loading FP
341:    LDA  4,0(4) 	Loading Old FP
342:    LDA  4,0(4) 	Loading Old FP
343:    LDA  4,0(4) 	Loading Address of array size to Reg 4
344:     LD  3,-1(4) 	Loading array size to reg 3
345:    SUB  1,3,0 	Sub reg 3 by reg 0
346:    JGT  1,1(7) 	Jump past halt if index < array size
347:     ST  5,-12(5) 	Store the fp
348:    LDA  5,-12(5) 	Create new fp
349:    LDC  3,69420(0) 	Loading Error value
350:     ST  3,-2(5) 	Storing outputn value
351:    LDA  0,1(7) 	Store Pc with offset
352:    LDA  7,-346(7) 	move return add to reg 0
353:     LD  5,0(5) 	Reload the fp
354:   HALT  0,0,0 	Kill
355:    ADD  4,0,4 	add index to array address
356:     LD  3,0(4) 	load value at array index to reg 3
357:     LD  0,-12(5) 	Saving rhs back to reg 0
358:     ST  0,0(4) 	Assigning rhs to lhs
* Assign Exp
* Op Exp
* Simple Var Exp
359:    LDA  4,0(5) 	Loading FP
360:     LD  4,0(4) 	Loading Old FP
361:     LD  4,0(4) 	Loading Old FP
362:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
363:     LD  3,0(4) 	Loading varialble value
364:     ST  3,-12(5) 	saving reg 0 to stack
* Int Exp
365:    LDC  3,1(0) 	loading constant to reg 3
366:     LD  0,-12(5) 	saving lhs back to reg 0
367:    LDA  1,0(3) 	moving rhs
368:    ADD  3,0,1 	adding rhs to lhs
* End Op Exp
369:     ST  3,-12(5) 	Saving  rhs result to stack
* Simple Var Exp
370:    LDA  4,0(5) 	Loading FP
371:     LD  4,0(4) 	Loading Old FP
372:     LD  4,0(4) 	Loading Old FP
373:    LDA  4,-4(4) 	Loading Variable Address To Reg 4
374:     LD  3,0(4) 	Loading varialble value
375:     LD  0,-12(5) 	Saving rhs back to reg 0
376:     ST  0,0(4) 	Assigning rhs to lhs
377:     LD  5,0(5) 	Storing FP
378:    LDA  7,-156(7) 	While end
208:    JLE  3,170(7) 	while condition
379:     LD  7,2(5) 	Loading PC
181:    LDA  7,198(7) 	jump around fn body
* processing function: main
* Assign Exp
* Int Exp
381:    LDC  3,0(0) 	loading constant to reg 3
382:     ST  3,-2(5) 	Saving  rhs result to stack
* Simple Var Exp
383:    LDA  4,0(5) 	Loading FP
384:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
385:     LD  3,0(4) 	Loading varialble value
386:     LD  0,-2(5) 	Saving rhs back to reg 0
387:     ST  0,0(4) 	Assigning rhs to lhs
* While Exp
* Op Exp
* Simple Var Exp
388:    LDA  4,0(5) 	Loading FP
389:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
390:     LD  3,0(4) 	Loading varialble value
391:     ST  3,-2(5) 	saving reg 0 to stack
* Int Exp
392:    LDC  3,10(0) 	loading constant to reg 3
393:     LD  0,-2(5) 	saving lhs back to reg 0
394:    LDA  1,0(3) 	moving rhs
395:    SUB  3,1,0 	substracting lhs from rhs
* End Op Exp
397:     ST  5,-2(5) 	Storing FP
398:    LDA  5,-2(5) 	Storing FP
* Assign Exp
* Call Exp
399:     ST  0,-3(5) 	Store reg 0
400:     ST  5,-4(5) 	Store the fp
401:    LDA  5,-4(5) 	Create new fp
402:    LDA  0,1(7) 	Store Pc with offset
403:    LDA  7,-400(7) 	move return add to reg 0
404:     LD  5,0(5) 	Reload the fp
405:    LDA  3,0(0) 	Store results
406:     LD  0,-3(5) 	Restore reg 0
407:     ST  3,-4(5) 	Saving  rhs result to stack
* Index Var Exp
* Simple Var Exp
408:    LDA  4,0(5) 	Loading FP
409:     LD  4,0(4) 	Loading Old FP
410:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
411:     LD  3,0(4) 	Loading varialble value
412:    LDA  0,0(3) 	Moving rhs
413:    LDA  4,0(5) 	Loading FP
414:    LDA  4,0(4) 	Loading Old FP
415:    LDA  4,0(4) 	Loading Old FP
416:    LDA  4,0(4) 	Loading Old FP
417:    LDA  4,-10(4) 	Loading Address of array size to Reg 4
418:     LD  3,-1(4) 	Loading array size to reg 3
419:    SUB  1,3,0 	Sub reg 3 by reg 0
420:    JGT  1,1(7) 	Jump past halt if index < array size
421:     ST  5,-5(5) 	Store the fp
422:    LDA  5,-5(5) 	Create new fp
423:    LDC  3,69420(0) 	Loading Error value
424:     ST  3,-2(5) 	Storing outputn value
425:    LDA  0,1(7) 	Store Pc with offset
426:    LDA  7,-420(7) 	move return add to reg 0
427:     LD  5,0(5) 	Reload the fp
428:   HALT  0,0,0 	Kill
429:    ADD  4,0,4 	add index to array address
430:     LD  3,0(4) 	load value at array index to reg 3
431:     LD  0,-5(5) 	Saving rhs back to reg 0
432:     ST  0,0(4) 	Assigning rhs to lhs
* Assign Exp
* Op Exp
* Simple Var Exp
433:    LDA  4,0(5) 	Loading FP
434:     LD  4,0(4) 	Loading Old FP
435:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
436:     LD  3,0(4) 	Loading varialble value
437:     ST  3,-5(5) 	saving reg 0 to stack
* Int Exp
438:    LDC  3,1(0) 	loading constant to reg 3
439:     LD  0,-5(5) 	saving lhs back to reg 0
440:    LDA  1,0(3) 	moving rhs
441:    ADD  3,0,1 	adding rhs to lhs
* End Op Exp
442:     ST  3,-5(5) 	Saving  rhs result to stack
* Simple Var Exp
443:    LDA  4,0(5) 	Loading FP
444:     LD  4,0(4) 	Loading Old FP
445:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
446:     LD  3,0(4) 	Loading varialble value
447:     LD  0,-5(5) 	Saving rhs back to reg 0
448:     ST  0,0(4) 	Assigning rhs to lhs
449:     LD  5,0(5) 	Storing FP
450:    LDA  7,-48(7) 	While end
396:    JLE  3,54(7) 	while condition
* Call Exp
451:     ST  0,-4(5) 	Store reg 0
452:     ST  1,-5(5) 	Store reg 1
453:    LDA  0,0(7) 	PC stuff
455:    ADD  0,0,1 	More PC Stuff
456:     ST  0,-6(5) 	Storing Pc
457:     ST  5,-8(5) 	Storing FP
458:    LDA  5,-8(5) 	UPdating FP
* Simple Var Exp
459:    LDA  4,0(5) 	Loading FP
460:     LD  4,0(4) 	Loading Old FP
461:     LD  4,0(4) 	Loading Old FP
462:     LD  4,0(4) 	Loading Old FP
463:    LDA  4,-10(4) 	Loading Variable Address To Reg 4
464:     LD  3,0(4) 	Loading varialble value
465:     ST  3,-1(5) 	add params
* Int Exp
466:    LDC  3,0(0) 	loading constant to reg 3
467:     ST  3,-2(5) 	add params
* Int Exp
468:    LDC  3,10(0) 	loading constant to reg 3
469:     ST  3,-3(5) 	add params
470:    LDA  7,-289(7) 	jumping to function
454:    LDC  1,17(0) 	Creating Offset
471:     LD  2,2(5) 	Load returna
472:     LD  5,0(5) 	load old fp
473:     LD  1,-5(5) 	restore reg 1
474:     LD  0,-4(5) 	restore reg 0
* Assign Exp
* Int Exp
475:    LDC  3,0(0) 	loading constant to reg 3
476:     ST  3,-4(5) 	Saving  rhs result to stack
* Simple Var Exp
477:    LDA  4,0(5) 	Loading FP
478:     LD  4,0(4) 	Loading Old FP
479:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
480:     LD  3,0(4) 	Loading varialble value
481:     LD  0,-4(5) 	Saving rhs back to reg 0
482:     ST  0,0(4) 	Assigning rhs to lhs
* While Exp
* Op Exp
* Simple Var Exp
483:    LDA  4,0(5) 	Loading FP
484:     LD  4,0(4) 	Loading Old FP
485:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
486:     LD  3,0(4) 	Loading varialble value
487:     ST  3,-4(5) 	saving reg 0 to stack
* Int Exp
488:    LDC  3,10(0) 	loading constant to reg 3
489:     LD  0,-4(5) 	saving lhs back to reg 0
490:    LDA  1,0(3) 	moving rhs
491:    SUB  3,1,0 	substracting lhs from rhs
* End Op Exp
493:     ST  5,-4(5) 	Storing FP
494:    LDA  5,-4(5) 	Storing FP
* Call Exp
* Index Var Exp
* Simple Var Exp
495:    LDA  4,0(5) 	Loading FP
496:     LD  4,0(4) 	Loading Old FP
497:     LD  4,0(4) 	Loading Old FP
498:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
499:     LD  3,0(4) 	Loading varialble value
500:    LDA  0,0(3) 	Moving rhs
501:    LDA  4,0(5) 	Loading FP
502:    LDA  4,0(4) 	Loading Old FP
503:    LDA  4,0(4) 	Loading Old FP
504:    LDA  4,0(4) 	Loading Old FP
505:    LDA  4,0(4) 	Loading Old FP
506:    LDA  4,-10(4) 	Loading Address of array size to Reg 4
507:     LD  3,-1(4) 	Loading array size to reg 3
508:    SUB  1,3,0 	Sub reg 3 by reg 0
509:    JGT  1,1(7) 	Jump past halt if index < array size
510:     ST  5,-5(5) 	Store the fp
511:    LDA  5,-5(5) 	Create new fp
512:    LDC  3,69420(0) 	Loading Error value
513:     ST  3,-2(5) 	Storing outputn value
514:    LDA  0,1(7) 	Store Pc with offset
515:    LDA  7,-509(7) 	move return add to reg 0
516:     LD  5,0(5) 	Reload the fp
517:   HALT  0,0,0 	Kill
518:    ADD  4,0,4 	add index to array address
519:     LD  3,0(4) 	load value at array index to reg 3
520:     ST  0,-6(5) 	Store reg 0
521:     ST  5,-7(5) 	Store the fp
522:    LDA  5,-7(5) 	Create new fp
523:     ST  3,-2(5) 	Storing outputn value
524:    LDA  0,1(7) 	Store Pc with offset
525:    LDA  7,-519(7) 	move return add to reg 0
526:     LD  5,0(5) 	Reload the fp
527:     LD  0,-6(5) 	Restore reg 0
* Assign Exp
* Op Exp
* Simple Var Exp
528:    LDA  4,0(5) 	Loading FP
529:     LD  4,0(4) 	Loading Old FP
530:     LD  4,0(4) 	Loading Old FP
531:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
532:     LD  3,0(4) 	Loading varialble value
533:     ST  3,-7(5) 	saving reg 0 to stack
* Int Exp
534:    LDC  3,1(0) 	loading constant to reg 3
535:     LD  0,-7(5) 	saving lhs back to reg 0
536:    LDA  1,0(3) 	moving rhs
537:    ADD  3,0,1 	adding rhs to lhs
* End Op Exp
538:     ST  3,-7(5) 	Saving  rhs result to stack
* Simple Var Exp
539:    LDA  4,0(5) 	Loading FP
540:     LD  4,0(4) 	Loading Old FP
541:     LD  4,0(4) 	Loading Old FP
542:    LDA  4,-1(4) 	Loading Variable Address To Reg 4
543:     LD  3,0(4) 	Loading varialble value
544:     LD  0,-7(5) 	Saving rhs back to reg 0
545:     ST  0,0(4) 	Assigning rhs to lhs
546:     LD  5,0(5) 	Storing FP
547:    LDA  7,-32(7) 	While end
492:    JLE  3,55(7) 	while condition
548:     LD  7,2(5) 	Loading PC
380:    LDA  7,168(7) 	jump around fn body
549:    LDA  0,0(7) 	PC stuff
551:    ADD  0,0,1 	More PC Stuff
552:     ST  0,-6(5) 	Storing Pc
553:     ST  5,-8(5) 	Storing FP
554:    LDA  5,-8(5) 	Updating FP
555:    LDA  7,-175(7) 	jumping to function
550:    LDC  1,6(0) 	Creating Offset
556:     LD  5,1(5) 	load old fp
557:   HALT  0,0,0 	HALLTTTT
