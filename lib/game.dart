import 'dart:async';

import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'dart:ui';
import 'dart:math';
import 'package:flame/flame.dart';



class MainGame extends Game{
  int count = 0;
  bool isGameOn = true;
  List<Asteroid> currentAsteroids = [];
  Size screenSize;
  double width = 370;
  double height = 650;
  double y= 0;
  double increment = 35.0;


  // Background Image
  Sprite backgroundSprite = Sprite("bg.png");


  // Effect variable
  double effectBoardX = 0;
  double effectBoardY = 0;
  double effectBoardWidth = 0;
  double effectBoardHeight = 0;
  String effectString = "";


  // Effect variable
  double scoreBoardX = 370/3.0;
  double scoreBoardY = 650-50.0;
  double scoreBoardWidth = 0;
  double scoreBoardHeight = 0;
  int scoreString = 0;




  TextPainter textPainter = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    maxLines: 5,

  );

  TextStyle textStyle = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    shadows: <Shadow>[
    ],
  );


  TextPainter textPainterScore = TextPainter(
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
    maxLines: 5,

  );

  TextStyle textStyleScore = TextStyle(
    color: Colors.white,
    fontSize: 28,
    shadows: <Shadow>[
    ],
  );







  Map<String, dynamic> imageMap = {
    "0":{
    "url":"tree.png",
    "isFriendly":true,
      "effect":"Cutting down trees causes soil erosion and is harmful"
  },
    "1":{
      "url":"zombie.jpg",
      "isFriendly":false,
      "effect":""
    },
    "2":{
      "url":"zombie3.jpg",
      "isFriendly":false,
      "effect":""
    },
    "3":{
      "url":"zombie2.jpg",
      "isFriendly":false,
      "effect":""
    },
    "4":{
      "url":"tree.png",
      "isFriendly":true,
      "effect":"Cutting down trees causes soil erosion and is harmful"
    },
    "5":{
      "url":"zombie5.jpg",
      "isFriendly":false,
      "effect":""
    },

  };


  void startGame(canvas){

    this.count += 1;
//    print(count);

   if(isGameOn){
     List<int> randomImagesIndex = generateRandomSix();

     populateCurrentAsteroids(randomImagesIndex);
   }

    displayAsteroids(this.currentAsteroids, canvas);


    isGameOn = false;


    fallAsteroids();

  }


  displayEffect(){
    this.effectBoardX = 0;
    this.effectBoardY = 0;
    this.effectBoardWidth = 370;
    this.effectBoardHeight = 50;

    print("bfore timer");
    var timer = Timer(Duration(seconds: 3), () {
      print("timmer done");
      this.effectBoardX = 0;
      this.effectBoardY = 0;
      this.effectBoardWidth = 0;
      this.effectBoardHeight = 0;
      this.effectString = "";
    });

    timer.cancel();
  }


  displayAsteroids(List<Asteroid> list, canvas){
    for(int i=0; i < list.length; i++){
      Rect spRect = Rect.fromLTWH(list[i].x, list[i].y, list[i].width, list[i].height);
      list[i].sprite.renderRect(canvas, spRect);
    }
  }

  List<int> generateRandomSix(){

    List<int> randomImagesIndex = [];

    for(int i=0; i < 6; i++){
      var rng = new Random();
        randomImagesIndex.add(
            rng.nextInt(5)
        );
    }

    return randomImagesIndex;
  }

  fallAsteroids(){

    for(int i =0; i < this.currentAsteroids.length; i++){
      this.currentAsteroids[i].y += this.currentAsteroids[i].speed;

      if(this.currentAsteroids[i].y + this.currentAsteroids[i].height >= this.height - 100){

        if(!this.currentAsteroids[i].isFriendly){
          this.scoreString -= 5;
        }


        this.currentAsteroids[i].y = 0;


        var rng = new Random();

        String ind = rng.nextInt(5).toString();

        this.currentAsteroids[i].sprite = Sprite(this.imageMap["$ind"]['url']);
        this.currentAsteroids[i].isFriendly = this.imageMap["$ind"]['isFriendly'];
        this.currentAsteroids[i].effectText = this.imageMap["$ind"]['effect'];

      }
    }

  }
  void populateCurrentAsteroids(List<int> indices){
      for(int i = 0; i < indices.length; i++){
        String ind = i.toString();

        Sprite sp = Sprite(this.imageMap["$ind"]['url']);

        bool asteroidType = this.imageMap["$ind"]['isFriendly'];

        String effectStr = this.imageMap["$ind"]['effect'];
        var rng = new Random();


        Asteroid asteroid = Asteroid((this.width/6)*i, 0.0, 60.0, 60.0, ((rng.nextInt(100)/this.increment)+1), sp, asteroidType, effectStr);

        this.currentAsteroids.add(asteroid);
      }

  }

  void onTapDown(TapDownDetails d) async{
    print(d.globalPosition.dx);
    print(d.globalPosition.dy);


    for(int i =0; i < this.currentAsteroids.length; i++){

      Asteroid asteroid = this.currentAsteroids[i];
      if(d.globalPosition.dx >= asteroid.x && d.globalPosition.dx <= asteroid.x+asteroid.width
          && d.globalPosition.dy >= asteroid.y && d.globalPosition.dy <= asteroid.y+asteroid.height ){

        if(asteroid.isFriendly){
          await Flame.audio.play('beep.mp3');
          this.effectString = asteroid.effectText;
          displayEffect();
          this.scoreString -= 10;
        }
        else{
          this.scoreString += 2;
        }

        asteroid.y = 0;

        var rng = new Random();

        String ind = rng.nextInt(5).toString();

        asteroid.sprite = Sprite(this.imageMap["$ind"]['url']);
        asteroid.isFriendly = this.imageMap["$ind"]['isFriendly'];
        asteroid.effectText = this.imageMap["$ind"]['effect'];
      }
    }


  }



  @override
  void render(Canvas canvas) {
    // TODO: implement render

    // draw a black background on the whole screen
    Rect bgRect = Rect.fromLTWH(0, 0, this.width, this.height);
    Paint bgPaint = Paint();
    bgPaint.color = Colors.red;
//    canvas.drawRect(bgRect, bgPaint);


    this.backgroundSprite.renderRect(canvas, bgRect);





    startGame(canvas);

    Rect rectMessage = Rect.fromLTWH(this.effectBoardX, effectBoardY, effectBoardWidth, effectBoardHeight);
    Paint rectMessagePaint = Paint();
    rectMessagePaint.color = Colors.yellow;
    canvas.drawRect(rectMessage, rectMessagePaint);




//    [ handling effect text  ]
    Offset position = Offset(10, 20);


    textPainter.text = TextSpan(
      text: this.effectString,
      style: textStyle,
    );

    textPainter.layout();

    textPainter.paint(canvas, position);



//   [ handling score text ]

    Offset positionScore = Offset(this.scoreBoardX, this.scoreBoardY);


    textPainterScore.text = TextSpan(
      text: "Score ${this.scoreString}",
      style: textStyleScore,
    );

    textPainterScore.layout();

    textPainterScore.paint(canvas, positionScore);





  }

  @override
  void update(double t) {
    // TODO: implement update
//    print("updatings");


  }

}

class Asteroid {
  double x;
  double y;
  double width;
  double height;
  double speed;
  Sprite sprite;
  bool isFriendly;
  String effectText;

  Asteroid(x, y, width, height, speed, sprite, isFriendly, effectText){
    this.x = x;
    this.y = y;
    this.width = width;
    this.height = height;
    this.speed = speed;
    this.sprite = sprite;
    this.isFriendly = isFriendly;
    this.effectText = effectText;
  }
}
