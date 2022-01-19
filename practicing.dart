import 'dart:async';

void main(){


   animal().move();
  // fish().move();
}


class animal{

  void move(){
    print('change position');
  }
}

class fish extends animal{
   @override
  void move() {
     super.move();
     print('by swimming');
  }
}

class bird extends animal{
  @override
  void move() {
    super.move();
    print('by flying');
  }
}


mixin canfly{
  void fly(){
    print('change position by flying');
  }
}

mixin canswim{
  void swim(){
    print('change position by swimming');
  }
}

class duck extends animal with canfly,canswim{

}