import 'package:flutter/material.dart';
import 'package:kcarv_front/models/clubVertical.dart';

final verticals =  {
  Verticals.acting : const clubVertical(
    "Acting",
    Color.fromARGB(117, 0, 255, 128),
  ),
  Verticals.production_design : const clubVertical(
    "Production Design",
    Color.fromARGB(122, 255, 0, 221),
  ),
  Verticals.script : const clubVertical(
    "Script",
    Color.fromARGB(129, 255, 102, 0),
  ),
  Verticals.technical : const clubVertical(
    "Technical",
    Color.fromARGB(132, 0, 208, 255),
  ),
  Verticals.music : const clubVertical(
    "Music", 
    Colors.grey
  ),
  Verticals.media : const clubVertical(
    "Media", 
    Color.fromARGB(125, 255, 149, 0),
  ),
  Verticals.all : const clubVertical(
    "General", 
    Color.fromARGB(255, 255, 255, 255),
  )
};