// To parse this JSON data, do
//
//     final store = storeFromJson(jsonString);

import 'dart:convert';

import 'package:australti_ecommerce_app/models/user.dart';
import 'package:flutter/material.dart';

Store storeFromJson(String str) => Store.fromJson(json.decode(str));

String storeToJson(Store data) => json.encode(data.toJson());

class Store {
  Store(
      {this.id = "",
      @required this.user,
      this.about = "",
      this.products = 0,
      this.name = "",
      this.lastName = "",
      this.imageAvatar = "",
      this.timeDelivery,
      this.percentOff,
      this.trophys = 0,
      this.isEco = false,
      this.service,
      this.address = "",
      this.city = "",
      this.number = "",
      this.latitude = 0,
      this.longitude = 0,
      this.createdAt,
      this.updatedAt,
      this.visibility = true,
      this.isFollowing,
      this.notLocation = false,
      this.followers = 0});

  final String id;
  final User user;
  String about;
  int products;
  String name;
  String lastName;
  String imageAvatar;

  String address;
  String city;
  String number;
  double latitude;
  double longitude;
  bool visibility;
  bool notLocation;
  bool isFollowing;

  int followers;

  final int service;
  String timeDelivery;
  int percentOff;
  int trophys;
  bool isEco;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
        id: json["id"],
        user: User.fromJson(json["user"]),
        about: json["about"],
        name: json["name"],
        lastName: json["lastName"],
        imageAvatar: json["imageAvatar"],
        service: json["service"],
        timeDelivery: json["time_delivery"],
        percentOff: json["percentOff"],
        trophys: json["trophys"],
        isEco: json["isEco"],
        address: json["address"],
        city: json["city"],
        isFollowing: json["isFollowing"],
        followers: json["followers"],
        visibility: json["visibility"],
        number: json["numberAddress"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        notLocation: json["notLocation"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user,
        "about": about,
        "name": name,
        "lastName": lastName,
        "imageAvatar": imageAvatar,
        "service": service,
        "timeDelivery": timeDelivery,
        "percentOff": percentOff,
        "trophys": trophys,
        "isEco": isEco,
        "address": address,
        "city": city,
        "isFollowing": isFollowing,
        "followers": followers,
        "visibility": visibility,
        "number": number,
        "notLocation": notLocation,
        "latitude": latitude,
        "longitude": longitude,
        "createdAt": updatedAt,
        "updatedAt": updatedAt,
      };
}
