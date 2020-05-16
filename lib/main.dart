import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame/time.dart';

void main() {
  runApp(GameWidget());
}

class SpaceShooterGame extends Game {
  GameObject player;
  List<GameObject> enemies =[];
  static const enemy_speed = 400;
  Timer enemyCreator;

  SpaceShooterGame()
  {
    player = GameObject()..position = Rect.fromLTWH(100, 100, 50, 50);
    enemyCreator = Timer(1.0,repeat:true,callback:() {
      enemies.add(
          GameObject()
            ..position = Rect.fromLTWH(0, 0, 50, 50)
      );
    });
    enemyCreator.start();

  }
  void onPlayerMove(Offset delta)
  {
    player.position = player.position.translate(delta.dx,delta.dy);
  }
  @override  void update(double dt) {

    enemies.forEach((enemy) {
      enemy.position = enemy.position.translate(0, enemy_speed * dt);
    });
    enemyCreator.update(dt);

  }
  @override  void render(Canvas canvas){
    enemies.forEach((enemy) {
       enemy.render(canvas);
    });
    player.render(canvas);  }
  }
class GameWidget extends StatelessWidget {
  @override  Widget build(BuildContext context){
    final game = SpaceShooterGame();
    return GestureDetector( onPanUpdate: (DragUpdateDetails details)
    {      game.onPlayerMove(details.delta);    },
      child: Container( color: Color(0xFF0000000),   child: game.widget),  );
  }

}

class GameObject {
  Paint _white = Paint()..color = Color(0xFFFFFFFF);
  Rect position;

  void render(Canvas canvas) {
    canvas.drawRect(position, _white);
  }
}
