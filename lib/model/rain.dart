import 'package:json_annotation/json_annotation.dart';

part 'rain.g.dart';

@JsonSerializable()
class Rain {
  @JsonKey(name: '1h')
  final double oneHour;

  Rain({required this.oneHour});

  factory Rain.fromJson(Map<String, dynamic> json) =>
      _$RainFromJson(json);
  Map<String, dynamic> toJson() => _$RainToJson(this);
}