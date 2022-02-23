import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class CloudsState extends Equatable {
  const CloudsState(this.clouds, this.brightness);

  final List<Cloud> clouds;
  final double brightness;

  @override
  List<Object?> get props => [clouds.hashCode, brightness];
}


class CloudsBloc extends Cubit<CloudsState> {
  CloudsBloc() : super(CloudsState([], 0.3));

  late Timer _timer;
  final Random random = Random();
  var counter = 0;
  var counter2 = 0;
  final values = [0.2, 0.3, 0.5, 0.7, 0.8, 1.0, 0.8, 0.7, 0.5, 0.3, 0.2];
  void init() {
    _emitInitClouds();

    _timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      final List<Cloud> newList = [];
      List<Cloud> cloudsToRemove = [];

      for (final cloud in state.clouds) {
        final newCloud = Cloud(cloud.id, cloud.x - cloud.speed * 4, cloud.y, cloud.speed);
        newList.add(newCloud);
        if (cloud.x + 400 < 0) {
          cloudsToRemove.add(cloud);
        }
      }

      for (final cloud in cloudsToRemove) {
        newList.remove(cloud);
        final newCloud = createCloud(cloud.id);
        newList.add(newCloud);
      }

      var brightness = state.brightness;
      if (counter == 15) {
        brightness = values[counter2];
        counter = 0;
        counter2++;
        if (counter2 > values.length - 1) {
          counter2 = 0;
        }
      }
      counter++;

      final newState = CloudsState(List.of(newList), brightness);
      emit(newState);
    });
  }

  double getRandomSpeed() {
    return random.nextDouble() * 0.3 + 0.2;
  }

  Cloud createCloud(int id) {
    final randomHeight = random.nextInt(200);
    return Cloud(id, 1600, randomHeight.toDouble(), getRandomSpeed());
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }

  void _emitInitClouds() {
    final List<Cloud> clouds = [];

    clouds.add(Cloud(1, 270, 220, getRandomSpeed()));
    clouds.add(Cloud(2, 180, 70, getRandomSpeed()));
    clouds.add(Cloud(3, 600, 220, getRandomSpeed()));
    clouds.add(Cloud(4, 750, 50, getRandomSpeed()));
    clouds.add(Cloud(5, 1200, 150, getRandomSpeed()));
    clouds.add(Cloud(6, 1400, 100, getRandomSpeed()));

    emit(CloudsState(clouds, 0.3));
  }
}

class Cloud extends Equatable {
  Cloud(
    this.id,
    this.x,
    this.y,
    this.speed,
  );

  final int id; // id from 1 to 6
  double x;
  final double y;
  final double speed; // random value between 0.1 - 0.5

  @override
  List<Object?> get props => [speed];
}
