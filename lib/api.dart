import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class API {
  static Future<String> getTopicsToLearn(String email) {
    debugPrint("started api call");
    var url = "https://us-central1-nexgenmath.cloudfunctions.net/getTopicsToLearn?email=" + email;
    debugPrint(url);
    return http.post(url).then((response) {
      debugPrint("finished api call");
      return response.body;
    });
  }
  static Future<String> getTopicsToPractice(String email) {
    debugPrint("started api call");
    var url = "https://us-central1-nexgenmath.cloudfunctions.net/getTopicsToPractice?email=" + email;
    debugPrint(url);
    return http.post(url).then((response) {
      debugPrint("finished api call");
      return response.body;
    });
  }
  static Future<String> getLessonDetails(String id) {
    debugPrint("started api call");
    var url = "https://us-central1-nexgenmath.cloudfunctions.net/getLesson?lessonID=" + id;
    debugPrint(url);
    return http.post(url).then((response) {
      debugPrint("finished api call");
      return response.body;
    });
  }

}