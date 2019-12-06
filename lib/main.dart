import 'package:flame/util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:one_earth/game.dart';
import 'package:flame/flame.dart';


void main() async {
  Util flameUtil = Util();
  await flameUtil.fullScreen();
  await flameUtil.setOrientation(DeviceOrientation.portraitUp);


  Flame.images.loadAll(<String>[
    'tree.png',
    'bg.png',
    'zombie.jpg',
    'zombie2.jpg',
    'zombie3.jpg',
    'zombie5.jpg',
  ]);

  Flame.audio.loadAll([
    'beep.mp3'
  ]);
  MainGame game = MainGame();
  TapGestureRecognizer tapper = TapGestureRecognizer();
  tapper.onTapDown = game.onTapDown;
  runApp(game.widget);
  flameUtil.addGestureRecognizer(tapper);
}