public final float pointPrecission = 1;
public final float linePrecission = 0.05;



//-----------------------------------//
//              METHODS              //
//-----------------------------------//



// Point colides Point
public boolean pointPoint2d(Point _p0, Point _p1) {
  return pointPoint2d(_p0, _p1, pointPrecission);
}
public boolean pointPoint2d(Point _p0, Point _p1, float _p) {
  float dx = _p0.getX() - _p1.getX();
  float dy = _p0.getY() - _p1.getY();
  float d = sqrt((dx * dx) + (dy * dy));
  return d <= _p;
}

// Point colides Circle
public boolean circlePoint2d(Circle _c, Point _p) {
  return pointCircle2d(_p, _c);
}
public boolean pointCircle2d(Point _p, Circle _c) {
  return pointPoint2d(_p, _c.getCenterPoint(), _c.getRadius());
}

// Point colides Line
public boolean pointLine2d(Point _p, Line _l) {
  return linePoint2d(_l, _p);
}
public boolean linePoint2d(Line _l, Point _p) {
  return linePoint2d(_l, _p, linePrecission);
}
public boolean pointLine2d(Point _p, Line _l, float _a) {
  return linePoint2d(_l, _p, _a);
}
public boolean linePoint2d(Line _l, Point _p, float _a) {
  return linePoint2d(_l, _p.getX(), _p.getY(), _a);
}
public boolean pointLine2d(float _px, float _py, Line _l) {
  return linePoint2d(_l, _px, _py);
}
public boolean linePoint2d(Line _l, float _px, float _py) {
  return linePoint2d(_l, _px, _py, linePrecission);
}
public boolean pointLine2d(float _px, float _py, Line _l, float _a) {
  return linePoint2d(_l, _px, _py, _a);
}
public boolean linePoint2d(Line _l, float _px, float _py, float _a) {
  float d0 = dist(_px, _py, _l.getStartX(), _l.getStartY());
  float d1 = dist(_px, _py, _l.getEndX(), _l.getEndY());
  float l = _l.getLength();
  return d0 + d1 >= l - _a && d0 + d1 <= l + _a;
}

// Circle colides Circle
public boolean circleCircle2d(Circle _c1, Circle _c2) {
  return pointPoint2d(_c1.getCenterPoint(), _c2.getCenterPoint(), _c1.getRadius() + _c2.getRadius());
}

// Circle colides Line
public boolean circleLine2d(Circle _c, Line _l) {
  boolean inStart = pointCircle2d(_l.getStartPoint(), _c);
  boolean inEnd = pointCircle2d(_l.getEndPoint(), _c);
  if(inStart || inEnd) return true;
  
  float v0 = (_c.getX() - _l.getStartX()) * (_l.getEndX() - _l.getStartX());
  float v1 = (_c.getY() - _l.getStartY()) * (_l.getEndY() - _l.getStartY());
  float dot = (v0 + v1) / pow(_l.getLength(), 2);
  float closeX = _l.getStartX() + (dot * (_l.getEndX() - _l.getStartX()));
  float closeY = _l.getStartY() + (dot * (_l.getEndY() - _l.getStartY()));
  
  boolean onLine = pointLine2d(new Point(closeX, closeY), _l);
  if(!onLine) return false;
  
  float dx = closeX - _c.getX();
  float dy = closeY - _c.getY();
  float d = sqrt((dx * dx) + (dy * dy));
  return d <= _c.getRadius();
}

// Line colides Line
public boolean lineLine2d(Line _l0, Line _l1) {
  float x1 = _l0.getStartX();
  float x2 = _l0.getEndX();
  float y1 = _l0.getStartY();
  float y2 = _l0.getEndY();
  
  float x3 = _l1.getStartX();
  float x4 = _l1.getEndX();
  float y3 = _l1.getStartY();
  float y4 = _l1.getEndY();
  
  float a = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  float b = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
  
  return a >= 0 && a <= 1 && b >= 0 && b <= 1;
}

// Point colides Rectangle
public boolean rectanglePoint2d(Rectangle _r, Point _p) {
  return pointRectangle2d(_p, _r);
}
public boolean pointRectangle2d(Point _p, Rectangle _r) {
  Point b = _r.getCenterPoint();
  return _p.getX() >= b.getX() - _r.getWidth()/2 &&
         _p.getX() <= b.getX() + _r.getWidth()/2 &&
         _p.getY() >= b.getY() - _r.getHeight()/2 &&
         _p.getY() <= b.getY() + _r.getHeight()/2;
}

// Rectangle colides Rectangle
public boolean rectangleRectangle2d(Rectangle _r0, Rectangle _r1) {
  Point b0 = _r0.getCenterPoint();
  Point b1 = _r1.getCenterPoint();
  //print("rect test\n");
  //print("b0 ? b1 = " + (b0.getX() + _r0.getWidth()/2) + " >= " + (b1.getX() - _r1.getWidth()/2) + "\n");
  //print("b0 ? b1 = " + (b0.getX() - _r0.getWidth()/2) + " <= " + (b1.getX() + _r1.getWidth()/2) + "\n");
  //print("b0 ? b1 = " + (b0.getY() + _r0.getHeight()/2) + " >= " + (b1.getY() - _r1.getHeight()/2) + "\n");
  //print("b0 ? b1 = " + (b0.getY() - _r0.getHeight()/2) + " <= " + (b1.getY() + _r1.getHeight()/2) + "\n");
  
  return b0.getX() + _r0.getWidth()/2 >= b1.getX() - _r1.getWidth()/2 &&
         b0.getX() - _r0.getWidth()/2 <= b1.getX() + _r1.getWidth()/2 &&
         b0.getY() + _r0.getHeight()/2 >= b1.getY() - _r1.getHeight()/2 &&
         b0.getY() - _r0.getHeight()/2 <= b1.getY() + _r1.getHeight()/2;
}

// Rectangle colides Circle
boolean rectangleCircle2d(Rectangle _r, Circle _c) {
  return circleRectangle2d(_c, _r);
}
boolean circleRectangle2d(Circle _c, Rectangle _r) {
  float x = _c.getX();
  float y = _c.getY();
  if (_c.getX() < _r.getX() - _r.getWidth()/2)          x = _r.getX() - _r.getWidth()/2;
  else if (_c.getX() > _r.getX() + _r.getWidth()/2)     x = _r.getX() + _r.getWidth()/2;
  if (_c.getY() < _r.getY() - _r.getHeight()/2)         y = _r.getY() - _r.getHeight()/2;
  else if (_c.getY() > _r.getY() + _r.getHeight()/2)    y = _r.getY() + _r.getHeight()/2;
  float dx = _c.getX() - x;
  float dy = _c.getY() - y;
  float d = sqrt((dx * dx) + (dy * dy));
  return d <= _c.getRadius();
}



//-----------------------------------//
//              OBJECTS              //
//-----------------------------------//



class Point {
  
  private float pointX, pointY, pointZ;
  
  Point() {
    this(0);
  }
  Point(Point _p) {
    this(_p.getX(), _p.getY(), _p.getZ());
  }
  Point(float _x) {
    this(_x, 0);
  }
  Point(float _x, float _y) {
    this(_x, _y, 0);
  }
  Point(float _x, float _y, float _z) {
    pointX = _x;
    pointY = _y;
    pointZ = _z; 
  }
  
  float getX() {
    return pointX;
  }
  float getY() {
    return pointY;
  }
  float getZ() {
    return pointZ;
  }
  
  void setX(float _x) {
    pointX = _x;
  }
  void setY(float _y) {
    pointY = _y;
  }
  void setZ(float _z) {
    pointZ = _z;
  }
  
  Point getPointCopy() {
    return new Point(pointX, pointY, pointZ);
  }
  void setFromPoint(Point _p) {
    pointX = _p.getX();
    pointY = _p.getY();
    pointZ = _p.getZ();
  }
}

class Circle {
  
  private Point circlePos;
  private float circleR;
  
  Circle(Circle _c) {
    this(_c.getX(), _c.getY(), _c.getZ(), _c.getRadius());
  }
  Circle(float _r) {
    circlePos = new Point();
    circleR = _r;
  }
  Circle(Point _p, float _r) {
    circlePos = new Point(_p);
    circleR = _r;
  }
  Circle(float _x, float _y, float _r) {
    this(_x, _y, 0, _r);
  }
  Circle(float _x, float _y, float _z, float _r) {
    circlePos = new Point(_x, _y, _z);
    circleR = _r;
  }
  
  float getX() {
    return circlePos.getX();
  }
  float getY() {
    return circlePos.getY();
  }
  float getZ() {
    return circlePos.getZ();
  }
  float getRadius() {
    return circleR;
  }
  float getDiameter() {
    return circleR * 2;
  }
  
  void setX(float _x) {
    circlePos.setX(_x);
  }
  void setY(float _y) {
    circlePos.setY(_y);
  }
  void setZ(float _z) {
    circlePos.setZ(_z);
  }
  void setRadius(float _r) {
    circleR = _r;
  }
  void setDiameter(float _d) {
    circleR = _d / 2;
  }
  
  Point getCenterPoint() {
    return circlePos.getPointCopy();
  }
  void setCenterPoint(Point _p) {
    circlePos.setFromPoint(_p);
  }
  
  Circle getCircleCopy() {
    return new Circle(circlePos, circleR);
  }
  void setFromCircle(Circle _c) {
    setCenterPoint(_c.getCenterPoint());
    setRadius(_c.getRadius());
  }
}

class Line {
  
  private Point startPoint, endPoint;
  
  Line(Line _l) {
    this(_l.getStartX(), _l.getStartY(), _l.getEndX(), _l.getEndY());
  }
  Line(Point _s, Point _e) {
    this(_s.getX(), _s.getY(), _e.getX(), _e.getY());
  }
  Line(float _x0, float _y0, float _x1, float _y1) {
    startPoint = new Point(_x0, _y0);
    endPoint = new Point(_x1, _y1);
  }
  
  float getStartX() {
    return startPoint.getX();
  }
  float getEndX() {
    return endPoint.getX();
  }
  float getStartY() {
    return startPoint.getY();
  }
  float getEndY() {
    return endPoint.getY();
  }
  float getStartZ() {
    return startPoint.getZ();
  }
  float getEndZ() {
    return endPoint.getZ();
  }
  float getLength() {
    return dist(startPoint.getX(), startPoint.getY(), endPoint.getX(), endPoint.getY());
  }
  
  void setStartX(float _n) {
    startPoint.setX(_n);
  }
  void setEndX(float _n) {
    endPoint.setX(_n);
  }
  void setStartY(float _n) {
    startPoint.setY(_n);
  }
  void setEndY(float _n) {
    endPoint.setY(_n);
  }
  void setStartZ(float _n) {
    startPoint.setZ(_n);
  }
  void setEndZ(float _n) {
    endPoint.setZ(_n);
  }
  
  Point getStartPoint() {
    return startPoint;
  }
  Point getEndPoint() {
    return endPoint;
  }
  void setStartPoint(Point _p) {
    startPoint.setFromPoint(_p);
  }
  void setEndPoint(Point _p) {
    endPoint.setFromPoint(_p);
  }
  
  Line getLineCopy() {
    return new Line(startPoint, endPoint);
  }
  void setFromLine(Line _l) {
    setStartPoint(_l.getStartPoint());
    setEndPoint(_l.getEndPoint());
  }
}

class Rectangle {
  
  private Point rectCenter;
  private float rectWidth, rectHeight;
   
  Rectangle(Rectangle r) {
    this(r.getCenterPoint(), r.getWidth(), r.getHeight());
  }
  Rectangle(float _w) {
    this(_w, _w);
  }
  Rectangle(float _w, float _h) {
    this(new Point(), _w, _h);
  }
  Rectangle(Point _c, float _w) {
    this(_c, _w, _w);
  }
  Rectangle(Point _c, float _w, float _h) {
    rectCenter = _c;
    rectWidth = _w;
    rectHeight = _h;
  }
  
  Point getCenterPoint() {
    return rectCenter;
  }
  void setCenterPoint(Point _p) {
    rectCenter.setFromPoint(_p);
  }
  
  
  float getX() {
    return rectCenter.getX();
  }
  float getY() {
    return rectCenter.getY();
  }
  float getZ() {
    return rectCenter.getZ();
  }
  float getWidth() {
    return rectWidth;
  }
  float getHeight() {
    return rectHeight;
  }
  float getDiagonal() {
    return sqrt(rectWidth * rectWidth + rectHeight * rectHeight);
  }
  
  void setX(float _n) {
    rectCenter.setX(_n);
  }
  void setY(float _n) {
    rectCenter.setY(_n);
  }
  void setZ(float _n) {
    rectCenter.setZ(_n);
  }
  void setWidth(float _w) {
    rectWidth = _w;
  }
  void setHeight(float _h) {
    rectHeight = _h;
  }
  
  void rescale(float _f) {
    this.rectWidth = this.rectWidth + this.rectWidth * _f;
    this.rectHeight = this.rectHeight + this.rectHeight * _f;
  }
  
  Rectangle getRectangleCopy() {
    return new Rectangle(rectCenter, rectWidth, rectHeight);
  }
  void setFromRectangle(Rectangle _r) {
    rectCenter.setFromPoint(_r.getCenterPoint());
    rectWidth = _r.getWidth();
    rectHeight = _r.getHeight();
  }
}
