import 'package:flutter/material.dart';
import 'package:kcarv_front/models/clubVertical.dart';

final verticals =  {
  Verticals.acting : const clubVertical(
    "Acting",
    Color.fromARGB(255, 0, 255, 128),
  ),
  Verticals.production_design : const clubVertical(
    "Production Design",
    Color.fromARGB(255, 145, 255, 0),
  ),
  Verticals.script : const clubVertical(
    "Script",
    Color.fromARGB(255, 255, 102, 0),
  ),
  Verticals.technical : const clubVertical(
    "Technical",
    Color.fromARGB(255, 0, 208, 255),
  ),
  Verticals.music : const clubVertical(
    "Music", 
    Color.fromARGB(255, 0, 60, 255)
  ),
  Verticals.media : const clubVertical(
    "Media", 
    Color.fromARGB(255, 255, 149, 0),
  ),
  Verticals.all : const clubVertical(
    "General", 
    Color.fromARGB(255, 255, 255, 255),
  )
};