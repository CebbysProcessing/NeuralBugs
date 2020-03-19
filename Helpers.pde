/* Method for mapping value from 0 - 1;
** Contains 3 functions
** 1. uses if > 0 = 1 else = 0;
** 2. cebbys sigmoid
** 3. circular method
*/
double neuronFunction(int methodIndex, double value, double bias) {
  switch(methodIndex) {
    case 1:
      if(value < bias) return 0;
      else if(value > bias + 1) return 1;
      else {
        double val = (Math.sin(PI * (value - bias) + 3 * PI/2) + 1) / 2;
        return val;
      }
    case 2:
      if(value < bias) return 0;
      else if(value > bias && value < bias + 0.5) return Math.sqrt(0.5 * 0.5 - (value - bias) * (value - bias)) + 0.5;
      else if(value > bias + 0.5 && value < bias + 1) return Math.sqrt(0.5 * 0.5 - (value - bias - 1) * (value - bias)) + 0.5;
      else return 1;
    default:
      if(value + bias > 0) return 1;
      else return 0;
  }
}
