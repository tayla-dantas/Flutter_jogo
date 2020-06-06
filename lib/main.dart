import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/time.dart';
import 'package:flame/flame.dart';

import 'dart:math';

void main() async{
  Size size = await Flame.util.initialDimensions();
  runApp(GameWidget(size));
}

class GameWidget extends StatelessWidget{

  final Size size;
  GameWidget(this.size);

  @override
  Widget build(BuildContext context) {
    final game = SpaceShooterGame(size);
    return GestureDetector(
      onPanStart: (_){
        game.beginFire();
      },
      onPanEnd: (_){
        game.stopFire();
      },
      onPanCancel: (){
        game.stopFire();
      },
      onPanUpdate: (DragUpdateDetails details)
    {
        game.OnPlayerMove(details.delta);
    },
      child: Container(
        color: Color(0xFFFFFFFF),
        child: game.widget,

      ),
    );
  }
}

Paint _paint = Paint()..color = Color(0xFFFFFFFF);

class GameObject {
  Rect position;


  void render(Canvas canvas){
    canvas.drawRect(position, _paint);
  }
}

class SpaceShooterGame extends Game{

  final Size screenSize;

  GameObject player;

  Timer enemyCreator;
  Timer shootCreator;

  static const enemy_speed = 200;
  static const shoot_speed = -500;
  List<GameObject> enemies = [];
  List<GameObject> shoots = [];

  Random random = Random();


  SpaceShooterGame(this.screenSize){
    player = GameObject()
        ..position = Rect.fromLTWH(200, 200, 100, 100);

    enemyCreator = Timer(1.0, repeat: true, callback: (){

      enemies.add(
        GameObject()
            ..position = Rect.fromLTWH((screenSize.width - 50) * random.nextDouble(), 0, 50, 50)

      );

    });
    enemyCreator.start();

    shootCreator = Timer(0.5, repeat: true, callback: (){
      shoots.add(
          GameObject()
            ..position = Rect.fromLTWH(player.position.left + 20, player.position.top - 20, 20, 20)

      );

    });


  }

  void OnPlayerMove(Offset delta){

    player.position = player.position.translate(delta.dx, delta.dy);

  }

  void beginFire(){
      shootCreator.start();
  }

  void stopFire(){
      shootCreator.stop();
  }

  
  @override
  void update(double dt){
    enemies.forEach((enemy) {

      enemy.position = enemy.position.translate(0, enemy_speed * dt);

    });

    shoots.forEach((shoot) {

      shoot.position = shoot.position.translate(0, shoot_speed * dt);

    });

    enemyCreator.update(dt);
    shootCreator.update(dt);

    enemies.removeWhere((enemy) => enemy.position.top >= screenSize.height);
    shoots.removeWhere((shoot) => shoot.position.bottom <= 0);
  }

  @override
  void render(Canvas canvas){
    
    player.render(canvas);

    enemies.forEach((enemy) {

      enemy.render(canvas);

    });

    shoots.forEach((shoot) {

      shoot.render(canvas);

    });

  }


}

