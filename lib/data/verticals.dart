import 'package:flutter/material.dart';
import 'package:kcarv_front/models/clubVertical.dart';

final verticals =  {
  Verticals.acting : const clubVertical(
    "Acting",
    Color.fromARGB(255, 0, 255, 128),
  ),
  Verticals.pd : const clubVertical(
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
  )
};