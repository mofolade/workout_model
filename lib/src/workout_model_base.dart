import 'dart:io';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';


//Status can be implemented later
enum Status { started, paused, closed, undefined }

@immutable
class Training {
  final String id;
  final String name;
  final String description;
  final TrainingData? trainingData;
  

  Training({
    required this.id,
    required this.name,
    required this.description,
    this.trainingData,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      trainingData: json['trainingData'] == null
          ? null
          : TrainingData.fromJson(json['trainingData']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'trainingData': trainingData?.toJson(),
  };

  String serialize() {
    final json = toJson();
    final string = jsonEncode(json);
    return string;
  }

  factory Training.deserialize(String serialized) {
    return Training.fromJson(jsonDecode(serialized));
  }
}


class TrainingData {
  final int repeats;
  final int restSec;
  final int antalSets;
  final double weight;
  final double length;

  TrainingData({
   required this.repeats,
    required this.restSec,
    required this.antalSets,
    required this.weight,
    required this.length,
  });

  factory TrainingData.fromJson(Map<String, dynamic> json) {
    return TrainingData(
      repeats: json['reapeats'],
      restSec: json['restSec'],
      antalSets: json['antalSets'],
      weight: json['weight'],
      length: json['length'],
    );
  }

  Map<String, dynamic> toJson() => {
    'reapeats': repeats,
    'restSec': restSec,
    'antalSets': antalSets,
    'weight': weight,
    'length': length,
  };
}


@immutable
class Trainingpass {
  final String id;
  final String name;
  final String description;
  final Map<Training, TrainingData> trainings;


  Trainingpass({
    required this.id,
    required this.name,
    required this.description,
    required this.trainings,
  });

  factory Trainingpass.fromJson(Map<String, dynamic> json) {
    Map<Training, TrainingData> trainings = {};

    (json['trainings'] as Map<String, dynamic>).forEach((key, value) {
      trainings[Training.fromJson(jsonDecode(key))] = 
          TrainingData.fromJson(value);
    });

    return Trainingpass(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      trainings: trainings,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'trainings': trainings.map((key, value) => MapEntry(
            jsonEncode(key.toJson()),
            value.toJson())),
      };

  String serialize() => jsonEncode(toJson());
  factory Trainingpass.deserialize(String serialized) {
    return Trainingpass.fromJson(jsonDecode(serialized));
  }

  addTraining(Training training, TrainingData amount) {
    trainings[training] = amount;
  }

}


class TrainingpassRepository {
  late Box<String> _trainingpassBox;

  TrainingpassRepository() {
    // nit (petig) : användaren kanske själv vill konfigurera var datat ska sparas
    Directory directory = Directory.current;
    Hive.init(directory.path);
  }

  Future<void> initialize() async {
    // asynkron operation, tar obestämd (men snabb) tid att öppna vår datalagring.
    _trainingpassBox = await Hive.openBox('trainingpasss');
  }

  bool create(Trainingpass trainingpass) {
    if (!Hive.isBoxOpen("trainingpasss")) {
      throw StateError("Please await TrainingpassRepository initialize method");
    }
    var existingTrainingpass = _trainingpassBox.get(trainingpass.id);
    if (existingTrainingpass != null) {
      return false;
    }
    _trainingpassBox.put(trainingpass.id, trainingpass.serialize());
    return true;
  }

  Trainingpass? read(String id) {
    var serialized = _trainingpassBox.get(id);
    return serialized != null ? Trainingpass.deserialize(serialized) : null;
  }

  Trainingpass update(Trainingpass trainingpass) {
    var existingTrainingpass = _trainingpassBox.get(trainingpass.id);
    if (existingTrainingpass == null) {
      throw Exception('Trainingpass not found');
    }
    _trainingpassBox.put(trainingpass.id, trainingpass.serialize());
    return trainingpass;
  }

  bool delete(String id) {
    var existingTrainingpass = _trainingpassBox.get(id);
    if (existingTrainingpass != null) {
      _trainingpassBox.delete(id);
      return true;
    }
    return false;
  }

  List<Trainingpass> list() => _trainingpassBox.values
      .map((serialized) => Trainingpass.deserialize(serialized))
      .toList();
}

