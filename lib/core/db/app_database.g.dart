// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class Recordings extends Table with TableInfo<Recordings, Recording> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Recordings(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _targetMsMeta = const VerificationMeta(
    'targetMs',
  );
  late final GeneratedColumn<int> targetMs = GeneratedColumn<int>(
    'target_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _audioPathMeta = const VerificationMeta(
    'audioPath',
  );
  late final GeneratedColumn<String> audioPath = GeneratedColumn<String>(
    'audio_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _promptIdMeta = const VerificationMeta(
    'promptId',
  );
  late final GeneratedColumn<String> promptId = GeneratedColumn<String>(
    'prompt_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _drillIdMeta = const VerificationMeta(
    'drillId',
  );
  late final GeneratedColumn<String> drillId = GeneratedColumn<String>(
    'drill_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _analysisVersionMeta = const VerificationMeta(
    'analysisVersion',
  );
  late final GeneratedColumn<int> analysisVersion = GeneratedColumn<int>(
    'analysis_version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _overallScoreMeta = const VerificationMeta(
    'overallScore',
  );
  late final GeneratedColumn<int> overallScore = GeneratedColumn<int>(
    'overall_score',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    createdAt,
    durationMs,
    targetMs,
    audioPath,
    kind,
    promptId,
    drillId,
    title,
    language,
    analysisVersion,
    overallScore,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recordings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recording> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('target_ms')) {
      context.handle(
        _targetMsMeta,
        targetMs.isAcceptableOrUnknown(data['target_ms']!, _targetMsMeta),
      );
    } else if (isInserting) {
      context.missing(_targetMsMeta);
    }
    if (data.containsKey('audio_path')) {
      context.handle(
        _audioPathMeta,
        audioPath.isAcceptableOrUnknown(data['audio_path']!, _audioPathMeta),
      );
    } else if (isInserting) {
      context.missing(_audioPathMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('prompt_id')) {
      context.handle(
        _promptIdMeta,
        promptId.isAcceptableOrUnknown(data['prompt_id']!, _promptIdMeta),
      );
    }
    if (data.containsKey('drill_id')) {
      context.handle(
        _drillIdMeta,
        drillId.isAcceptableOrUnknown(data['drill_id']!, _drillIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('analysis_version')) {
      context.handle(
        _analysisVersionMeta,
        analysisVersion.isAcceptableOrUnknown(
          data['analysis_version']!,
          _analysisVersionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_analysisVersionMeta);
    }
    if (data.containsKey('overall_score')) {
      context.handle(
        _overallScoreMeta,
        overallScore.isAcceptableOrUnknown(
          data['overall_score']!,
          _overallScoreMeta,
        ),
      );
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recording map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recording(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      targetMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_ms'],
      )!,
      audioPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}audio_path'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      promptId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prompt_id'],
      ),
      drillId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drill_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      ),
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      analysisVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}analysis_version'],
      )!,
      overallScore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}overall_score'],
      ),
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  Recordings createAlias(String alias) {
    return Recordings(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Recording extends DataClass implements Insertable<Recording> {
  final String? id;
  final int createdAt;
  final int durationMs;
  final int targetMs;
  final String audioPath;
  final String kind;
  final String? promptId;
  final String? drillId;
  final String? title;
  final String language;
  final int analysisVersion;
  final int? overallScore;
  final int? deletedAt;
  const Recording({
    this.id,
    required this.createdAt,
    required this.durationMs,
    required this.targetMs,
    required this.audioPath,
    required this.kind,
    this.promptId,
    this.drillId,
    this.title,
    required this.language,
    required this.analysisVersion,
    this.overallScore,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    map['created_at'] = Variable<int>(createdAt);
    map['duration_ms'] = Variable<int>(durationMs);
    map['target_ms'] = Variable<int>(targetMs);
    map['audio_path'] = Variable<String>(audioPath);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || promptId != null) {
      map['prompt_id'] = Variable<String>(promptId);
    }
    if (!nullToAbsent || drillId != null) {
      map['drill_id'] = Variable<String>(drillId);
    }
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['language'] = Variable<String>(language);
    map['analysis_version'] = Variable<int>(analysisVersion);
    if (!nullToAbsent || overallScore != null) {
      map['overall_score'] = Variable<int>(overallScore);
    }
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    return map;
  }

  RecordingsCompanion toCompanion(bool nullToAbsent) {
    return RecordingsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      createdAt: Value(createdAt),
      durationMs: Value(durationMs),
      targetMs: Value(targetMs),
      audioPath: Value(audioPath),
      kind: Value(kind),
      promptId: promptId == null && nullToAbsent
          ? const Value.absent()
          : Value(promptId),
      drillId: drillId == null && nullToAbsent
          ? const Value.absent()
          : Value(drillId),
      title: title == null && nullToAbsent
          ? const Value.absent()
          : Value(title),
      language: Value(language),
      analysisVersion: Value(analysisVersion),
      overallScore: overallScore == null && nullToAbsent
          ? const Value.absent()
          : Value(overallScore),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Recording.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recording(
      id: serializer.fromJson<String?>(json['id']),
      createdAt: serializer.fromJson<int>(json['created_at']),
      durationMs: serializer.fromJson<int>(json['duration_ms']),
      targetMs: serializer.fromJson<int>(json['target_ms']),
      audioPath: serializer.fromJson<String>(json['audio_path']),
      kind: serializer.fromJson<String>(json['kind']),
      promptId: serializer.fromJson<String?>(json['prompt_id']),
      drillId: serializer.fromJson<String?>(json['drill_id']),
      title: serializer.fromJson<String?>(json['title']),
      language: serializer.fromJson<String>(json['language']),
      analysisVersion: serializer.fromJson<int>(json['analysis_version']),
      overallScore: serializer.fromJson<int?>(json['overall_score']),
      deletedAt: serializer.fromJson<int?>(json['deleted_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String?>(id),
      'created_at': serializer.toJson<int>(createdAt),
      'duration_ms': serializer.toJson<int>(durationMs),
      'target_ms': serializer.toJson<int>(targetMs),
      'audio_path': serializer.toJson<String>(audioPath),
      'kind': serializer.toJson<String>(kind),
      'prompt_id': serializer.toJson<String?>(promptId),
      'drill_id': serializer.toJson<String?>(drillId),
      'title': serializer.toJson<String?>(title),
      'language': serializer.toJson<String>(language),
      'analysis_version': serializer.toJson<int>(analysisVersion),
      'overall_score': serializer.toJson<int?>(overallScore),
      'deleted_at': serializer.toJson<int?>(deletedAt),
    };
  }

  Recording copyWith({
    Value<String?> id = const Value.absent(),
    int? createdAt,
    int? durationMs,
    int? targetMs,
    String? audioPath,
    String? kind,
    Value<String?> promptId = const Value.absent(),
    Value<String?> drillId = const Value.absent(),
    Value<String?> title = const Value.absent(),
    String? language,
    int? analysisVersion,
    Value<int?> overallScore = const Value.absent(),
    Value<int?> deletedAt = const Value.absent(),
  }) => Recording(
    id: id.present ? id.value : this.id,
    createdAt: createdAt ?? this.createdAt,
    durationMs: durationMs ?? this.durationMs,
    targetMs: targetMs ?? this.targetMs,
    audioPath: audioPath ?? this.audioPath,
    kind: kind ?? this.kind,
    promptId: promptId.present ? promptId.value : this.promptId,
    drillId: drillId.present ? drillId.value : this.drillId,
    title: title.present ? title.value : this.title,
    language: language ?? this.language,
    analysisVersion: analysisVersion ?? this.analysisVersion,
    overallScore: overallScore.present ? overallScore.value : this.overallScore,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Recording copyWithCompanion(RecordingsCompanion data) {
    return Recording(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      targetMs: data.targetMs.present ? data.targetMs.value : this.targetMs,
      audioPath: data.audioPath.present ? data.audioPath.value : this.audioPath,
      kind: data.kind.present ? data.kind.value : this.kind,
      promptId: data.promptId.present ? data.promptId.value : this.promptId,
      drillId: data.drillId.present ? data.drillId.value : this.drillId,
      title: data.title.present ? data.title.value : this.title,
      language: data.language.present ? data.language.value : this.language,
      analysisVersion: data.analysisVersion.present
          ? data.analysisVersion.value
          : this.analysisVersion,
      overallScore: data.overallScore.present
          ? data.overallScore.value
          : this.overallScore,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recording(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('targetMs: $targetMs, ')
          ..write('audioPath: $audioPath, ')
          ..write('kind: $kind, ')
          ..write('promptId: $promptId, ')
          ..write('drillId: $drillId, ')
          ..write('title: $title, ')
          ..write('language: $language, ')
          ..write('analysisVersion: $analysisVersion, ')
          ..write('overallScore: $overallScore, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    createdAt,
    durationMs,
    targetMs,
    audioPath,
    kind,
    promptId,
    drillId,
    title,
    language,
    analysisVersion,
    overallScore,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recording &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.durationMs == this.durationMs &&
          other.targetMs == this.targetMs &&
          other.audioPath == this.audioPath &&
          other.kind == this.kind &&
          other.promptId == this.promptId &&
          other.drillId == this.drillId &&
          other.title == this.title &&
          other.language == this.language &&
          other.analysisVersion == this.analysisVersion &&
          other.overallScore == this.overallScore &&
          other.deletedAt == this.deletedAt);
}

class RecordingsCompanion extends UpdateCompanion<Recording> {
  final Value<String?> id;
  final Value<int> createdAt;
  final Value<int> durationMs;
  final Value<int> targetMs;
  final Value<String> audioPath;
  final Value<String> kind;
  final Value<String?> promptId;
  final Value<String?> drillId;
  final Value<String?> title;
  final Value<String> language;
  final Value<int> analysisVersion;
  final Value<int?> overallScore;
  final Value<int?> deletedAt;
  final Value<int> rowid;
  const RecordingsCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.targetMs = const Value.absent(),
    this.audioPath = const Value.absent(),
    this.kind = const Value.absent(),
    this.promptId = const Value.absent(),
    this.drillId = const Value.absent(),
    this.title = const Value.absent(),
    this.language = const Value.absent(),
    this.analysisVersion = const Value.absent(),
    this.overallScore = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecordingsCompanion.insert({
    this.id = const Value.absent(),
    required int createdAt,
    required int durationMs,
    required int targetMs,
    required String audioPath,
    required String kind,
    this.promptId = const Value.absent(),
    this.drillId = const Value.absent(),
    this.title = const Value.absent(),
    required String language,
    required int analysisVersion,
    this.overallScore = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : createdAt = Value(createdAt),
       durationMs = Value(durationMs),
       targetMs = Value(targetMs),
       audioPath = Value(audioPath),
       kind = Value(kind),
       language = Value(language),
       analysisVersion = Value(analysisVersion);
  static Insertable<Recording> custom({
    Expression<String>? id,
    Expression<int>? createdAt,
    Expression<int>? durationMs,
    Expression<int>? targetMs,
    Expression<String>? audioPath,
    Expression<String>? kind,
    Expression<String>? promptId,
    Expression<String>? drillId,
    Expression<String>? title,
    Expression<String>? language,
    Expression<int>? analysisVersion,
    Expression<int>? overallScore,
    Expression<int>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (durationMs != null) 'duration_ms': durationMs,
      if (targetMs != null) 'target_ms': targetMs,
      if (audioPath != null) 'audio_path': audioPath,
      if (kind != null) 'kind': kind,
      if (promptId != null) 'prompt_id': promptId,
      if (drillId != null) 'drill_id': drillId,
      if (title != null) 'title': title,
      if (language != null) 'language': language,
      if (analysisVersion != null) 'analysis_version': analysisVersion,
      if (overallScore != null) 'overall_score': overallScore,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecordingsCompanion copyWith({
    Value<String?>? id,
    Value<int>? createdAt,
    Value<int>? durationMs,
    Value<int>? targetMs,
    Value<String>? audioPath,
    Value<String>? kind,
    Value<String?>? promptId,
    Value<String?>? drillId,
    Value<String?>? title,
    Value<String>? language,
    Value<int>? analysisVersion,
    Value<int?>? overallScore,
    Value<int?>? deletedAt,
    Value<int>? rowid,
  }) {
    return RecordingsCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      durationMs: durationMs ?? this.durationMs,
      targetMs: targetMs ?? this.targetMs,
      audioPath: audioPath ?? this.audioPath,
      kind: kind ?? this.kind,
      promptId: promptId ?? this.promptId,
      drillId: drillId ?? this.drillId,
      title: title ?? this.title,
      language: language ?? this.language,
      analysisVersion: analysisVersion ?? this.analysisVersion,
      overallScore: overallScore ?? this.overallScore,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (targetMs.present) {
      map['target_ms'] = Variable<int>(targetMs.value);
    }
    if (audioPath.present) {
      map['audio_path'] = Variable<String>(audioPath.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (promptId.present) {
      map['prompt_id'] = Variable<String>(promptId.value);
    }
    if (drillId.present) {
      map['drill_id'] = Variable<String>(drillId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (analysisVersion.present) {
      map['analysis_version'] = Variable<int>(analysisVersion.value);
    }
    if (overallScore.present) {
      map['overall_score'] = Variable<int>(overallScore.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecordingsCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('targetMs: $targetMs, ')
          ..write('audioPath: $audioPath, ')
          ..write('kind: $kind, ')
          ..write('promptId: $promptId, ')
          ..write('drillId: $drillId, ')
          ..write('title: $title, ')
          ..write('language: $language, ')
          ..write('analysisVersion: $analysisVersion, ')
          ..write('overallScore: $overallScore, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class AnalysisResults extends Table
    with TableInfo<AnalysisResults, AnalysisResult> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AnalysisResults(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _recordingIdMeta = const VerificationMeta(
    'recordingId',
  );
  late final GeneratedColumn<String> recordingId = GeneratedColumn<String>(
    'recording_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints:
        'PRIMARY KEY REFERENCES recordings(id)ON DELETE CASCADE',
  );
  static const VerificationMeta _pitchMedianHzMeta = const VerificationMeta(
    'pitchMedianHz',
  );
  late final GeneratedColumn<double> pitchMedianHz = GeneratedColumn<double>(
    'pitch_median_hz',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _pitchRangeStMeta = const VerificationMeta(
    'pitchRangeSt',
  );
  late final GeneratedColumn<double> pitchRangeSt = GeneratedColumn<double>(
    'pitch_range_st',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _pitchStdStMeta = const VerificationMeta(
    'pitchStdSt',
  );
  late final GeneratedColumn<double> pitchStdSt = GeneratedColumn<double>(
    'pitch_std_st',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _pitchMovementStSMeta = const VerificationMeta(
    'pitchMovementStS',
  );
  late final GeneratedColumn<double> pitchMovementStS = GeneratedColumn<double>(
    'pitch_movement_st_s',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _articulationRateMeta = const VerificationMeta(
    'articulationRate',
  );
  late final GeneratedColumn<double> articulationRate = GeneratedColumn<double>(
    'articulation_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _speakingRateMeta = const VerificationMeta(
    'speakingRate',
  );
  late final GeneratedColumn<double> speakingRate = GeneratedColumn<double>(
    'speaking_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _paceCvMeta = const VerificationMeta('paceCv');
  late final GeneratedColumn<double> paceCv = GeneratedColumn<double>(
    'pace_cv',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _loudnessRangeDbMeta = const VerificationMeta(
    'loudnessRangeDb',
  );
  late final GeneratedColumn<double> loudnessRangeDb = GeneratedColumn<double>(
    'loudness_range_db',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _energyTrendDbMeta = const VerificationMeta(
    'energyTrendDb',
  );
  late final GeneratedColumn<double> energyTrendDb = GeneratedColumn<double>(
    'energy_trend_db',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _pausesPerMinMeta = const VerificationMeta(
    'pausesPerMin',
  );
  late final GeneratedColumn<double> pausesPerMin = GeneratedColumn<double>(
    'pauses_per_min',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _pauseRatioMeta = const VerificationMeta(
    'pauseRatio',
  );
  late final GeneratedColumn<double> pauseRatio = GeneratedColumn<double>(
    'pause_ratio',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _longPauseCountMeta = const VerificationMeta(
    'longPauseCount',
  );
  late final GeneratedColumn<int> longPauseCount = GeneratedColumn<int>(
    'long_pause_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _meanPauseMsMeta = const VerificationMeta(
    'meanPauseMs',
  );
  late final GeneratedColumn<int> meanPauseMs = GeneratedColumn<int>(
    'mean_pause_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _speechMsMeta = const VerificationMeta(
    'speechMs',
  );
  late final GeneratedColumn<int> speechMs = GeneratedColumn<int>(
    'speech_ms',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _snrDbMeta = const VerificationMeta('snrDb');
  late final GeneratedColumn<double> snrDb = GeneratedColumn<double>(
    'snr_db',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _clippingPctMeta = const VerificationMeta(
    'clippingPct',
  );
  late final GeneratedColumn<double> clippingPct = GeneratedColumn<double>(
    'clipping_pct',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _fillerCountMeta = const VerificationMeta(
    'fillerCount',
  );
  late final GeneratedColumn<int> fillerCount = GeneratedColumn<int>(
    'filler_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _scorePitchMeta = const VerificationMeta(
    'scorePitch',
  );
  late final GeneratedColumn<int> scorePitch = GeneratedColumn<int>(
    'score_pitch',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _scorePaceMeta = const VerificationMeta(
    'scorePace',
  );
  late final GeneratedColumn<int> scorePace = GeneratedColumn<int>(
    'score_pace',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _scorePaceVarMeta = const VerificationMeta(
    'scorePaceVar',
  );
  late final GeneratedColumn<int> scorePaceVar = GeneratedColumn<int>(
    'score_pace_var',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _scorePauseMeta = const VerificationMeta(
    'scorePause',
  );
  late final GeneratedColumn<int> scorePause = GeneratedColumn<int>(
    'score_pause',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _scoreVolumeMeta = const VerificationMeta(
    'scoreVolume',
  );
  late final GeneratedColumn<int> scoreVolume = GeneratedColumn<int>(
    'score_volume',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _scoreEnergyMeta = const VerificationMeta(
    'scoreEnergy',
  );
  late final GeneratedColumn<int> scoreEnergy = GeneratedColumn<int>(
    'score_energy',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _contourJsonMeta = const VerificationMeta(
    'contourJson',
  );
  late final GeneratedColumn<String> contourJson = GeneratedColumn<String>(
    'contour_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _pausesJsonMeta = const VerificationMeta(
    'pausesJson',
  );
  late final GeneratedColumn<String> pausesJson = GeneratedColumn<String>(
    'pauses_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _flagsJsonMeta = const VerificationMeta(
    'flagsJson',
  );
  late final GeneratedColumn<String> flagsJson = GeneratedColumn<String>(
    'flags_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    recordingId,
    pitchMedianHz,
    pitchRangeSt,
    pitchStdSt,
    pitchMovementStS,
    articulationRate,
    speakingRate,
    paceCv,
    loudnessRangeDb,
    energyTrendDb,
    pausesPerMin,
    pauseRatio,
    longPauseCount,
    meanPauseMs,
    speechMs,
    snrDb,
    clippingPct,
    fillerCount,
    scorePitch,
    scorePace,
    scorePaceVar,
    scorePause,
    scoreVolume,
    scoreEnergy,
    contourJson,
    pausesJson,
    flagsJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'analysis_results';
  @override
  VerificationContext validateIntegrity(
    Insertable<AnalysisResult> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('recording_id')) {
      context.handle(
        _recordingIdMeta,
        recordingId.isAcceptableOrUnknown(
          data['recording_id']!,
          _recordingIdMeta,
        ),
      );
    }
    if (data.containsKey('pitch_median_hz')) {
      context.handle(
        _pitchMedianHzMeta,
        pitchMedianHz.isAcceptableOrUnknown(
          data['pitch_median_hz']!,
          _pitchMedianHzMeta,
        ),
      );
    }
    if (data.containsKey('pitch_range_st')) {
      context.handle(
        _pitchRangeStMeta,
        pitchRangeSt.isAcceptableOrUnknown(
          data['pitch_range_st']!,
          _pitchRangeStMeta,
        ),
      );
    }
    if (data.containsKey('pitch_std_st')) {
      context.handle(
        _pitchStdStMeta,
        pitchStdSt.isAcceptableOrUnknown(
          data['pitch_std_st']!,
          _pitchStdStMeta,
        ),
      );
    }
    if (data.containsKey('pitch_movement_st_s')) {
      context.handle(
        _pitchMovementStSMeta,
        pitchMovementStS.isAcceptableOrUnknown(
          data['pitch_movement_st_s']!,
          _pitchMovementStSMeta,
        ),
      );
    }
    if (data.containsKey('articulation_rate')) {
      context.handle(
        _articulationRateMeta,
        articulationRate.isAcceptableOrUnknown(
          data['articulation_rate']!,
          _articulationRateMeta,
        ),
      );
    }
    if (data.containsKey('speaking_rate')) {
      context.handle(
        _speakingRateMeta,
        speakingRate.isAcceptableOrUnknown(
          data['speaking_rate']!,
          _speakingRateMeta,
        ),
      );
    }
    if (data.containsKey('pace_cv')) {
      context.handle(
        _paceCvMeta,
        paceCv.isAcceptableOrUnknown(data['pace_cv']!, _paceCvMeta),
      );
    }
    if (data.containsKey('loudness_range_db')) {
      context.handle(
        _loudnessRangeDbMeta,
        loudnessRangeDb.isAcceptableOrUnknown(
          data['loudness_range_db']!,
          _loudnessRangeDbMeta,
        ),
      );
    }
    if (data.containsKey('energy_trend_db')) {
      context.handle(
        _energyTrendDbMeta,
        energyTrendDb.isAcceptableOrUnknown(
          data['energy_trend_db']!,
          _energyTrendDbMeta,
        ),
      );
    }
    if (data.containsKey('pauses_per_min')) {
      context.handle(
        _pausesPerMinMeta,
        pausesPerMin.isAcceptableOrUnknown(
          data['pauses_per_min']!,
          _pausesPerMinMeta,
        ),
      );
    }
    if (data.containsKey('pause_ratio')) {
      context.handle(
        _pauseRatioMeta,
        pauseRatio.isAcceptableOrUnknown(data['pause_ratio']!, _pauseRatioMeta),
      );
    }
    if (data.containsKey('long_pause_count')) {
      context.handle(
        _longPauseCountMeta,
        longPauseCount.isAcceptableOrUnknown(
          data['long_pause_count']!,
          _longPauseCountMeta,
        ),
      );
    }
    if (data.containsKey('mean_pause_ms')) {
      context.handle(
        _meanPauseMsMeta,
        meanPauseMs.isAcceptableOrUnknown(
          data['mean_pause_ms']!,
          _meanPauseMsMeta,
        ),
      );
    }
    if (data.containsKey('speech_ms')) {
      context.handle(
        _speechMsMeta,
        speechMs.isAcceptableOrUnknown(data['speech_ms']!, _speechMsMeta),
      );
    }
    if (data.containsKey('snr_db')) {
      context.handle(
        _snrDbMeta,
        snrDb.isAcceptableOrUnknown(data['snr_db']!, _snrDbMeta),
      );
    }
    if (data.containsKey('clipping_pct')) {
      context.handle(
        _clippingPctMeta,
        clippingPct.isAcceptableOrUnknown(
          data['clipping_pct']!,
          _clippingPctMeta,
        ),
      );
    }
    if (data.containsKey('filler_count')) {
      context.handle(
        _fillerCountMeta,
        fillerCount.isAcceptableOrUnknown(
          data['filler_count']!,
          _fillerCountMeta,
        ),
      );
    }
    if (data.containsKey('score_pitch')) {
      context.handle(
        _scorePitchMeta,
        scorePitch.isAcceptableOrUnknown(data['score_pitch']!, _scorePitchMeta),
      );
    }
    if (data.containsKey('score_pace')) {
      context.handle(
        _scorePaceMeta,
        scorePace.isAcceptableOrUnknown(data['score_pace']!, _scorePaceMeta),
      );
    }
    if (data.containsKey('score_pace_var')) {
      context.handle(
        _scorePaceVarMeta,
        scorePaceVar.isAcceptableOrUnknown(
          data['score_pace_var']!,
          _scorePaceVarMeta,
        ),
      );
    }
    if (data.containsKey('score_pause')) {
      context.handle(
        _scorePauseMeta,
        scorePause.isAcceptableOrUnknown(data['score_pause']!, _scorePauseMeta),
      );
    }
    if (data.containsKey('score_volume')) {
      context.handle(
        _scoreVolumeMeta,
        scoreVolume.isAcceptableOrUnknown(
          data['score_volume']!,
          _scoreVolumeMeta,
        ),
      );
    }
    if (data.containsKey('score_energy')) {
      context.handle(
        _scoreEnergyMeta,
        scoreEnergy.isAcceptableOrUnknown(
          data['score_energy']!,
          _scoreEnergyMeta,
        ),
      );
    }
    if (data.containsKey('contour_json')) {
      context.handle(
        _contourJsonMeta,
        contourJson.isAcceptableOrUnknown(
          data['contour_json']!,
          _contourJsonMeta,
        ),
      );
    }
    if (data.containsKey('pauses_json')) {
      context.handle(
        _pausesJsonMeta,
        pausesJson.isAcceptableOrUnknown(data['pauses_json']!, _pausesJsonMeta),
      );
    }
    if (data.containsKey('flags_json')) {
      context.handle(
        _flagsJsonMeta,
        flagsJson.isAcceptableOrUnknown(data['flags_json']!, _flagsJsonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {recordingId};
  @override
  AnalysisResult map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AnalysisResult(
      recordingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recording_id'],
      ),
      pitchMedianHz: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pitch_median_hz'],
      ),
      pitchRangeSt: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pitch_range_st'],
      ),
      pitchStdSt: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pitch_std_st'],
      ),
      pitchMovementStS: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pitch_movement_st_s'],
      ),
      articulationRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}articulation_rate'],
      ),
      speakingRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speaking_rate'],
      ),
      paceCv: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pace_cv'],
      ),
      loudnessRangeDb: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}loudness_range_db'],
      ),
      energyTrendDb: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}energy_trend_db'],
      ),
      pausesPerMin: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pauses_per_min'],
      ),
      pauseRatio: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}pause_ratio'],
      ),
      longPauseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}long_pause_count'],
      ),
      meanPauseMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}mean_pause_ms'],
      ),
      speechMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}speech_ms'],
      ),
      snrDb: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}snr_db'],
      ),
      clippingPct: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}clipping_pct'],
      ),
      fillerCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}filler_count'],
      ),
      scorePitch: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score_pitch'],
      ),
      scorePace: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score_pace'],
      ),
      scorePaceVar: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score_pace_var'],
      ),
      scorePause: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score_pause'],
      ),
      scoreVolume: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score_volume'],
      ),
      scoreEnergy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}score_energy'],
      ),
      contourJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contour_json'],
      ),
      pausesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pauses_json'],
      ),
      flagsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flags_json'],
      ),
    );
  }

  @override
  AnalysisResults createAlias(String alias) {
    return AnalysisResults(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AnalysisResult extends DataClass implements Insertable<AnalysisResult> {
  final String? recordingId;
  final double? pitchMedianHz;
  final double? pitchRangeSt;
  final double? pitchStdSt;
  final double? pitchMovementStS;
  final double? articulationRate;
  final double? speakingRate;
  final double? paceCv;
  final double? loudnessRangeDb;
  final double? energyTrendDb;
  final double? pausesPerMin;
  final double? pauseRatio;
  final int? longPauseCount;
  final int? meanPauseMs;
  final int? speechMs;
  final double? snrDb;
  final double? clippingPct;
  final int? fillerCount;
  final int? scorePitch;
  final int? scorePace;
  final int? scorePaceVar;
  final int? scorePause;
  final int? scoreVolume;
  final int? scoreEnergy;
  final String? contourJson;
  final String? pausesJson;
  final String? flagsJson;
  const AnalysisResult({
    this.recordingId,
    this.pitchMedianHz,
    this.pitchRangeSt,
    this.pitchStdSt,
    this.pitchMovementStS,
    this.articulationRate,
    this.speakingRate,
    this.paceCv,
    this.loudnessRangeDb,
    this.energyTrendDb,
    this.pausesPerMin,
    this.pauseRatio,
    this.longPauseCount,
    this.meanPauseMs,
    this.speechMs,
    this.snrDb,
    this.clippingPct,
    this.fillerCount,
    this.scorePitch,
    this.scorePace,
    this.scorePaceVar,
    this.scorePause,
    this.scoreVolume,
    this.scoreEnergy,
    this.contourJson,
    this.pausesJson,
    this.flagsJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || recordingId != null) {
      map['recording_id'] = Variable<String>(recordingId);
    }
    if (!nullToAbsent || pitchMedianHz != null) {
      map['pitch_median_hz'] = Variable<double>(pitchMedianHz);
    }
    if (!nullToAbsent || pitchRangeSt != null) {
      map['pitch_range_st'] = Variable<double>(pitchRangeSt);
    }
    if (!nullToAbsent || pitchStdSt != null) {
      map['pitch_std_st'] = Variable<double>(pitchStdSt);
    }
    if (!nullToAbsent || pitchMovementStS != null) {
      map['pitch_movement_st_s'] = Variable<double>(pitchMovementStS);
    }
    if (!nullToAbsent || articulationRate != null) {
      map['articulation_rate'] = Variable<double>(articulationRate);
    }
    if (!nullToAbsent || speakingRate != null) {
      map['speaking_rate'] = Variable<double>(speakingRate);
    }
    if (!nullToAbsent || paceCv != null) {
      map['pace_cv'] = Variable<double>(paceCv);
    }
    if (!nullToAbsent || loudnessRangeDb != null) {
      map['loudness_range_db'] = Variable<double>(loudnessRangeDb);
    }
    if (!nullToAbsent || energyTrendDb != null) {
      map['energy_trend_db'] = Variable<double>(energyTrendDb);
    }
    if (!nullToAbsent || pausesPerMin != null) {
      map['pauses_per_min'] = Variable<double>(pausesPerMin);
    }
    if (!nullToAbsent || pauseRatio != null) {
      map['pause_ratio'] = Variable<double>(pauseRatio);
    }
    if (!nullToAbsent || longPauseCount != null) {
      map['long_pause_count'] = Variable<int>(longPauseCount);
    }
    if (!nullToAbsent || meanPauseMs != null) {
      map['mean_pause_ms'] = Variable<int>(meanPauseMs);
    }
    if (!nullToAbsent || speechMs != null) {
      map['speech_ms'] = Variable<int>(speechMs);
    }
    if (!nullToAbsent || snrDb != null) {
      map['snr_db'] = Variable<double>(snrDb);
    }
    if (!nullToAbsent || clippingPct != null) {
      map['clipping_pct'] = Variable<double>(clippingPct);
    }
    if (!nullToAbsent || fillerCount != null) {
      map['filler_count'] = Variable<int>(fillerCount);
    }
    if (!nullToAbsent || scorePitch != null) {
      map['score_pitch'] = Variable<int>(scorePitch);
    }
    if (!nullToAbsent || scorePace != null) {
      map['score_pace'] = Variable<int>(scorePace);
    }
    if (!nullToAbsent || scorePaceVar != null) {
      map['score_pace_var'] = Variable<int>(scorePaceVar);
    }
    if (!nullToAbsent || scorePause != null) {
      map['score_pause'] = Variable<int>(scorePause);
    }
    if (!nullToAbsent || scoreVolume != null) {
      map['score_volume'] = Variable<int>(scoreVolume);
    }
    if (!nullToAbsent || scoreEnergy != null) {
      map['score_energy'] = Variable<int>(scoreEnergy);
    }
    if (!nullToAbsent || contourJson != null) {
      map['contour_json'] = Variable<String>(contourJson);
    }
    if (!nullToAbsent || pausesJson != null) {
      map['pauses_json'] = Variable<String>(pausesJson);
    }
    if (!nullToAbsent || flagsJson != null) {
      map['flags_json'] = Variable<String>(flagsJson);
    }
    return map;
  }

  AnalysisResultsCompanion toCompanion(bool nullToAbsent) {
    return AnalysisResultsCompanion(
      recordingId: recordingId == null && nullToAbsent
          ? const Value.absent()
          : Value(recordingId),
      pitchMedianHz: pitchMedianHz == null && nullToAbsent
          ? const Value.absent()
          : Value(pitchMedianHz),
      pitchRangeSt: pitchRangeSt == null && nullToAbsent
          ? const Value.absent()
          : Value(pitchRangeSt),
      pitchStdSt: pitchStdSt == null && nullToAbsent
          ? const Value.absent()
          : Value(pitchStdSt),
      pitchMovementStS: pitchMovementStS == null && nullToAbsent
          ? const Value.absent()
          : Value(pitchMovementStS),
      articulationRate: articulationRate == null && nullToAbsent
          ? const Value.absent()
          : Value(articulationRate),
      speakingRate: speakingRate == null && nullToAbsent
          ? const Value.absent()
          : Value(speakingRate),
      paceCv: paceCv == null && nullToAbsent
          ? const Value.absent()
          : Value(paceCv),
      loudnessRangeDb: loudnessRangeDb == null && nullToAbsent
          ? const Value.absent()
          : Value(loudnessRangeDb),
      energyTrendDb: energyTrendDb == null && nullToAbsent
          ? const Value.absent()
          : Value(energyTrendDb),
      pausesPerMin: pausesPerMin == null && nullToAbsent
          ? const Value.absent()
          : Value(pausesPerMin),
      pauseRatio: pauseRatio == null && nullToAbsent
          ? const Value.absent()
          : Value(pauseRatio),
      longPauseCount: longPauseCount == null && nullToAbsent
          ? const Value.absent()
          : Value(longPauseCount),
      meanPauseMs: meanPauseMs == null && nullToAbsent
          ? const Value.absent()
          : Value(meanPauseMs),
      speechMs: speechMs == null && nullToAbsent
          ? const Value.absent()
          : Value(speechMs),
      snrDb: snrDb == null && nullToAbsent
          ? const Value.absent()
          : Value(snrDb),
      clippingPct: clippingPct == null && nullToAbsent
          ? const Value.absent()
          : Value(clippingPct),
      fillerCount: fillerCount == null && nullToAbsent
          ? const Value.absent()
          : Value(fillerCount),
      scorePitch: scorePitch == null && nullToAbsent
          ? const Value.absent()
          : Value(scorePitch),
      scorePace: scorePace == null && nullToAbsent
          ? const Value.absent()
          : Value(scorePace),
      scorePaceVar: scorePaceVar == null && nullToAbsent
          ? const Value.absent()
          : Value(scorePaceVar),
      scorePause: scorePause == null && nullToAbsent
          ? const Value.absent()
          : Value(scorePause),
      scoreVolume: scoreVolume == null && nullToAbsent
          ? const Value.absent()
          : Value(scoreVolume),
      scoreEnergy: scoreEnergy == null && nullToAbsent
          ? const Value.absent()
          : Value(scoreEnergy),
      contourJson: contourJson == null && nullToAbsent
          ? const Value.absent()
          : Value(contourJson),
      pausesJson: pausesJson == null && nullToAbsent
          ? const Value.absent()
          : Value(pausesJson),
      flagsJson: flagsJson == null && nullToAbsent
          ? const Value.absent()
          : Value(flagsJson),
    );
  }

  factory AnalysisResult.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AnalysisResult(
      recordingId: serializer.fromJson<String?>(json['recording_id']),
      pitchMedianHz: serializer.fromJson<double?>(json['pitch_median_hz']),
      pitchRangeSt: serializer.fromJson<double?>(json['pitch_range_st']),
      pitchStdSt: serializer.fromJson<double?>(json['pitch_std_st']),
      pitchMovementStS: serializer.fromJson<double?>(
        json['pitch_movement_st_s'],
      ),
      articulationRate: serializer.fromJson<double?>(json['articulation_rate']),
      speakingRate: serializer.fromJson<double?>(json['speaking_rate']),
      paceCv: serializer.fromJson<double?>(json['pace_cv']),
      loudnessRangeDb: serializer.fromJson<double?>(json['loudness_range_db']),
      energyTrendDb: serializer.fromJson<double?>(json['energy_trend_db']),
      pausesPerMin: serializer.fromJson<double?>(json['pauses_per_min']),
      pauseRatio: serializer.fromJson<double?>(json['pause_ratio']),
      longPauseCount: serializer.fromJson<int?>(json['long_pause_count']),
      meanPauseMs: serializer.fromJson<int?>(json['mean_pause_ms']),
      speechMs: serializer.fromJson<int?>(json['speech_ms']),
      snrDb: serializer.fromJson<double?>(json['snr_db']),
      clippingPct: serializer.fromJson<double?>(json['clipping_pct']),
      fillerCount: serializer.fromJson<int?>(json['filler_count']),
      scorePitch: serializer.fromJson<int?>(json['score_pitch']),
      scorePace: serializer.fromJson<int?>(json['score_pace']),
      scorePaceVar: serializer.fromJson<int?>(json['score_pace_var']),
      scorePause: serializer.fromJson<int?>(json['score_pause']),
      scoreVolume: serializer.fromJson<int?>(json['score_volume']),
      scoreEnergy: serializer.fromJson<int?>(json['score_energy']),
      contourJson: serializer.fromJson<String?>(json['contour_json']),
      pausesJson: serializer.fromJson<String?>(json['pauses_json']),
      flagsJson: serializer.fromJson<String?>(json['flags_json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'recording_id': serializer.toJson<String?>(recordingId),
      'pitch_median_hz': serializer.toJson<double?>(pitchMedianHz),
      'pitch_range_st': serializer.toJson<double?>(pitchRangeSt),
      'pitch_std_st': serializer.toJson<double?>(pitchStdSt),
      'pitch_movement_st_s': serializer.toJson<double?>(pitchMovementStS),
      'articulation_rate': serializer.toJson<double?>(articulationRate),
      'speaking_rate': serializer.toJson<double?>(speakingRate),
      'pace_cv': serializer.toJson<double?>(paceCv),
      'loudness_range_db': serializer.toJson<double?>(loudnessRangeDb),
      'energy_trend_db': serializer.toJson<double?>(energyTrendDb),
      'pauses_per_min': serializer.toJson<double?>(pausesPerMin),
      'pause_ratio': serializer.toJson<double?>(pauseRatio),
      'long_pause_count': serializer.toJson<int?>(longPauseCount),
      'mean_pause_ms': serializer.toJson<int?>(meanPauseMs),
      'speech_ms': serializer.toJson<int?>(speechMs),
      'snr_db': serializer.toJson<double?>(snrDb),
      'clipping_pct': serializer.toJson<double?>(clippingPct),
      'filler_count': serializer.toJson<int?>(fillerCount),
      'score_pitch': serializer.toJson<int?>(scorePitch),
      'score_pace': serializer.toJson<int?>(scorePace),
      'score_pace_var': serializer.toJson<int?>(scorePaceVar),
      'score_pause': serializer.toJson<int?>(scorePause),
      'score_volume': serializer.toJson<int?>(scoreVolume),
      'score_energy': serializer.toJson<int?>(scoreEnergy),
      'contour_json': serializer.toJson<String?>(contourJson),
      'pauses_json': serializer.toJson<String?>(pausesJson),
      'flags_json': serializer.toJson<String?>(flagsJson),
    };
  }

  AnalysisResult copyWith({
    Value<String?> recordingId = const Value.absent(),
    Value<double?> pitchMedianHz = const Value.absent(),
    Value<double?> pitchRangeSt = const Value.absent(),
    Value<double?> pitchStdSt = const Value.absent(),
    Value<double?> pitchMovementStS = const Value.absent(),
    Value<double?> articulationRate = const Value.absent(),
    Value<double?> speakingRate = const Value.absent(),
    Value<double?> paceCv = const Value.absent(),
    Value<double?> loudnessRangeDb = const Value.absent(),
    Value<double?> energyTrendDb = const Value.absent(),
    Value<double?> pausesPerMin = const Value.absent(),
    Value<double?> pauseRatio = const Value.absent(),
    Value<int?> longPauseCount = const Value.absent(),
    Value<int?> meanPauseMs = const Value.absent(),
    Value<int?> speechMs = const Value.absent(),
    Value<double?> snrDb = const Value.absent(),
    Value<double?> clippingPct = const Value.absent(),
    Value<int?> fillerCount = const Value.absent(),
    Value<int?> scorePitch = const Value.absent(),
    Value<int?> scorePace = const Value.absent(),
    Value<int?> scorePaceVar = const Value.absent(),
    Value<int?> scorePause = const Value.absent(),
    Value<int?> scoreVolume = const Value.absent(),
    Value<int?> scoreEnergy = const Value.absent(),
    Value<String?> contourJson = const Value.absent(),
    Value<String?> pausesJson = const Value.absent(),
    Value<String?> flagsJson = const Value.absent(),
  }) => AnalysisResult(
    recordingId: recordingId.present ? recordingId.value : this.recordingId,
    pitchMedianHz: pitchMedianHz.present
        ? pitchMedianHz.value
        : this.pitchMedianHz,
    pitchRangeSt: pitchRangeSt.present ? pitchRangeSt.value : this.pitchRangeSt,
    pitchStdSt: pitchStdSt.present ? pitchStdSt.value : this.pitchStdSt,
    pitchMovementStS: pitchMovementStS.present
        ? pitchMovementStS.value
        : this.pitchMovementStS,
    articulationRate: articulationRate.present
        ? articulationRate.value
        : this.articulationRate,
    speakingRate: speakingRate.present ? speakingRate.value : this.speakingRate,
    paceCv: paceCv.present ? paceCv.value : this.paceCv,
    loudnessRangeDb: loudnessRangeDb.present
        ? loudnessRangeDb.value
        : this.loudnessRangeDb,
    energyTrendDb: energyTrendDb.present
        ? energyTrendDb.value
        : this.energyTrendDb,
    pausesPerMin: pausesPerMin.present ? pausesPerMin.value : this.pausesPerMin,
    pauseRatio: pauseRatio.present ? pauseRatio.value : this.pauseRatio,
    longPauseCount: longPauseCount.present
        ? longPauseCount.value
        : this.longPauseCount,
    meanPauseMs: meanPauseMs.present ? meanPauseMs.value : this.meanPauseMs,
    speechMs: speechMs.present ? speechMs.value : this.speechMs,
    snrDb: snrDb.present ? snrDb.value : this.snrDb,
    clippingPct: clippingPct.present ? clippingPct.value : this.clippingPct,
    fillerCount: fillerCount.present ? fillerCount.value : this.fillerCount,
    scorePitch: scorePitch.present ? scorePitch.value : this.scorePitch,
    scorePace: scorePace.present ? scorePace.value : this.scorePace,
    scorePaceVar: scorePaceVar.present ? scorePaceVar.value : this.scorePaceVar,
    scorePause: scorePause.present ? scorePause.value : this.scorePause,
    scoreVolume: scoreVolume.present ? scoreVolume.value : this.scoreVolume,
    scoreEnergy: scoreEnergy.present ? scoreEnergy.value : this.scoreEnergy,
    contourJson: contourJson.present ? contourJson.value : this.contourJson,
    pausesJson: pausesJson.present ? pausesJson.value : this.pausesJson,
    flagsJson: flagsJson.present ? flagsJson.value : this.flagsJson,
  );
  AnalysisResult copyWithCompanion(AnalysisResultsCompanion data) {
    return AnalysisResult(
      recordingId: data.recordingId.present
          ? data.recordingId.value
          : this.recordingId,
      pitchMedianHz: data.pitchMedianHz.present
          ? data.pitchMedianHz.value
          : this.pitchMedianHz,
      pitchRangeSt: data.pitchRangeSt.present
          ? data.pitchRangeSt.value
          : this.pitchRangeSt,
      pitchStdSt: data.pitchStdSt.present
          ? data.pitchStdSt.value
          : this.pitchStdSt,
      pitchMovementStS: data.pitchMovementStS.present
          ? data.pitchMovementStS.value
          : this.pitchMovementStS,
      articulationRate: data.articulationRate.present
          ? data.articulationRate.value
          : this.articulationRate,
      speakingRate: data.speakingRate.present
          ? data.speakingRate.value
          : this.speakingRate,
      paceCv: data.paceCv.present ? data.paceCv.value : this.paceCv,
      loudnessRangeDb: data.loudnessRangeDb.present
          ? data.loudnessRangeDb.value
          : this.loudnessRangeDb,
      energyTrendDb: data.energyTrendDb.present
          ? data.energyTrendDb.value
          : this.energyTrendDb,
      pausesPerMin: data.pausesPerMin.present
          ? data.pausesPerMin.value
          : this.pausesPerMin,
      pauseRatio: data.pauseRatio.present
          ? data.pauseRatio.value
          : this.pauseRatio,
      longPauseCount: data.longPauseCount.present
          ? data.longPauseCount.value
          : this.longPauseCount,
      meanPauseMs: data.meanPauseMs.present
          ? data.meanPauseMs.value
          : this.meanPauseMs,
      speechMs: data.speechMs.present ? data.speechMs.value : this.speechMs,
      snrDb: data.snrDb.present ? data.snrDb.value : this.snrDb,
      clippingPct: data.clippingPct.present
          ? data.clippingPct.value
          : this.clippingPct,
      fillerCount: data.fillerCount.present
          ? data.fillerCount.value
          : this.fillerCount,
      scorePitch: data.scorePitch.present
          ? data.scorePitch.value
          : this.scorePitch,
      scorePace: data.scorePace.present ? data.scorePace.value : this.scorePace,
      scorePaceVar: data.scorePaceVar.present
          ? data.scorePaceVar.value
          : this.scorePaceVar,
      scorePause: data.scorePause.present
          ? data.scorePause.value
          : this.scorePause,
      scoreVolume: data.scoreVolume.present
          ? data.scoreVolume.value
          : this.scoreVolume,
      scoreEnergy: data.scoreEnergy.present
          ? data.scoreEnergy.value
          : this.scoreEnergy,
      contourJson: data.contourJson.present
          ? data.contourJson.value
          : this.contourJson,
      pausesJson: data.pausesJson.present
          ? data.pausesJson.value
          : this.pausesJson,
      flagsJson: data.flagsJson.present ? data.flagsJson.value : this.flagsJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisResult(')
          ..write('recordingId: $recordingId, ')
          ..write('pitchMedianHz: $pitchMedianHz, ')
          ..write('pitchRangeSt: $pitchRangeSt, ')
          ..write('pitchStdSt: $pitchStdSt, ')
          ..write('pitchMovementStS: $pitchMovementStS, ')
          ..write('articulationRate: $articulationRate, ')
          ..write('speakingRate: $speakingRate, ')
          ..write('paceCv: $paceCv, ')
          ..write('loudnessRangeDb: $loudnessRangeDb, ')
          ..write('energyTrendDb: $energyTrendDb, ')
          ..write('pausesPerMin: $pausesPerMin, ')
          ..write('pauseRatio: $pauseRatio, ')
          ..write('longPauseCount: $longPauseCount, ')
          ..write('meanPauseMs: $meanPauseMs, ')
          ..write('speechMs: $speechMs, ')
          ..write('snrDb: $snrDb, ')
          ..write('clippingPct: $clippingPct, ')
          ..write('fillerCount: $fillerCount, ')
          ..write('scorePitch: $scorePitch, ')
          ..write('scorePace: $scorePace, ')
          ..write('scorePaceVar: $scorePaceVar, ')
          ..write('scorePause: $scorePause, ')
          ..write('scoreVolume: $scoreVolume, ')
          ..write('scoreEnergy: $scoreEnergy, ')
          ..write('contourJson: $contourJson, ')
          ..write('pausesJson: $pausesJson, ')
          ..write('flagsJson: $flagsJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    recordingId,
    pitchMedianHz,
    pitchRangeSt,
    pitchStdSt,
    pitchMovementStS,
    articulationRate,
    speakingRate,
    paceCv,
    loudnessRangeDb,
    energyTrendDb,
    pausesPerMin,
    pauseRatio,
    longPauseCount,
    meanPauseMs,
    speechMs,
    snrDb,
    clippingPct,
    fillerCount,
    scorePitch,
    scorePace,
    scorePaceVar,
    scorePause,
    scoreVolume,
    scoreEnergy,
    contourJson,
    pausesJson,
    flagsJson,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnalysisResult &&
          other.recordingId == this.recordingId &&
          other.pitchMedianHz == this.pitchMedianHz &&
          other.pitchRangeSt == this.pitchRangeSt &&
          other.pitchStdSt == this.pitchStdSt &&
          other.pitchMovementStS == this.pitchMovementStS &&
          other.articulationRate == this.articulationRate &&
          other.speakingRate == this.speakingRate &&
          other.paceCv == this.paceCv &&
          other.loudnessRangeDb == this.loudnessRangeDb &&
          other.energyTrendDb == this.energyTrendDb &&
          other.pausesPerMin == this.pausesPerMin &&
          other.pauseRatio == this.pauseRatio &&
          other.longPauseCount == this.longPauseCount &&
          other.meanPauseMs == this.meanPauseMs &&
          other.speechMs == this.speechMs &&
          other.snrDb == this.snrDb &&
          other.clippingPct == this.clippingPct &&
          other.fillerCount == this.fillerCount &&
          other.scorePitch == this.scorePitch &&
          other.scorePace == this.scorePace &&
          other.scorePaceVar == this.scorePaceVar &&
          other.scorePause == this.scorePause &&
          other.scoreVolume == this.scoreVolume &&
          other.scoreEnergy == this.scoreEnergy &&
          other.contourJson == this.contourJson &&
          other.pausesJson == this.pausesJson &&
          other.flagsJson == this.flagsJson);
}

class AnalysisResultsCompanion extends UpdateCompanion<AnalysisResult> {
  final Value<String?> recordingId;
  final Value<double?> pitchMedianHz;
  final Value<double?> pitchRangeSt;
  final Value<double?> pitchStdSt;
  final Value<double?> pitchMovementStS;
  final Value<double?> articulationRate;
  final Value<double?> speakingRate;
  final Value<double?> paceCv;
  final Value<double?> loudnessRangeDb;
  final Value<double?> energyTrendDb;
  final Value<double?> pausesPerMin;
  final Value<double?> pauseRatio;
  final Value<int?> longPauseCount;
  final Value<int?> meanPauseMs;
  final Value<int?> speechMs;
  final Value<double?> snrDb;
  final Value<double?> clippingPct;
  final Value<int?> fillerCount;
  final Value<int?> scorePitch;
  final Value<int?> scorePace;
  final Value<int?> scorePaceVar;
  final Value<int?> scorePause;
  final Value<int?> scoreVolume;
  final Value<int?> scoreEnergy;
  final Value<String?> contourJson;
  final Value<String?> pausesJson;
  final Value<String?> flagsJson;
  final Value<int> rowid;
  const AnalysisResultsCompanion({
    this.recordingId = const Value.absent(),
    this.pitchMedianHz = const Value.absent(),
    this.pitchRangeSt = const Value.absent(),
    this.pitchStdSt = const Value.absent(),
    this.pitchMovementStS = const Value.absent(),
    this.articulationRate = const Value.absent(),
    this.speakingRate = const Value.absent(),
    this.paceCv = const Value.absent(),
    this.loudnessRangeDb = const Value.absent(),
    this.energyTrendDb = const Value.absent(),
    this.pausesPerMin = const Value.absent(),
    this.pauseRatio = const Value.absent(),
    this.longPauseCount = const Value.absent(),
    this.meanPauseMs = const Value.absent(),
    this.speechMs = const Value.absent(),
    this.snrDb = const Value.absent(),
    this.clippingPct = const Value.absent(),
    this.fillerCount = const Value.absent(),
    this.scorePitch = const Value.absent(),
    this.scorePace = const Value.absent(),
    this.scorePaceVar = const Value.absent(),
    this.scorePause = const Value.absent(),
    this.scoreVolume = const Value.absent(),
    this.scoreEnergy = const Value.absent(),
    this.contourJson = const Value.absent(),
    this.pausesJson = const Value.absent(),
    this.flagsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AnalysisResultsCompanion.insert({
    this.recordingId = const Value.absent(),
    this.pitchMedianHz = const Value.absent(),
    this.pitchRangeSt = const Value.absent(),
    this.pitchStdSt = const Value.absent(),
    this.pitchMovementStS = const Value.absent(),
    this.articulationRate = const Value.absent(),
    this.speakingRate = const Value.absent(),
    this.paceCv = const Value.absent(),
    this.loudnessRangeDb = const Value.absent(),
    this.energyTrendDb = const Value.absent(),
    this.pausesPerMin = const Value.absent(),
    this.pauseRatio = const Value.absent(),
    this.longPauseCount = const Value.absent(),
    this.meanPauseMs = const Value.absent(),
    this.speechMs = const Value.absent(),
    this.snrDb = const Value.absent(),
    this.clippingPct = const Value.absent(),
    this.fillerCount = const Value.absent(),
    this.scorePitch = const Value.absent(),
    this.scorePace = const Value.absent(),
    this.scorePaceVar = const Value.absent(),
    this.scorePause = const Value.absent(),
    this.scoreVolume = const Value.absent(),
    this.scoreEnergy = const Value.absent(),
    this.contourJson = const Value.absent(),
    this.pausesJson = const Value.absent(),
    this.flagsJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<AnalysisResult> custom({
    Expression<String>? recordingId,
    Expression<double>? pitchMedianHz,
    Expression<double>? pitchRangeSt,
    Expression<double>? pitchStdSt,
    Expression<double>? pitchMovementStS,
    Expression<double>? articulationRate,
    Expression<double>? speakingRate,
    Expression<double>? paceCv,
    Expression<double>? loudnessRangeDb,
    Expression<double>? energyTrendDb,
    Expression<double>? pausesPerMin,
    Expression<double>? pauseRatio,
    Expression<int>? longPauseCount,
    Expression<int>? meanPauseMs,
    Expression<int>? speechMs,
    Expression<double>? snrDb,
    Expression<double>? clippingPct,
    Expression<int>? fillerCount,
    Expression<int>? scorePitch,
    Expression<int>? scorePace,
    Expression<int>? scorePaceVar,
    Expression<int>? scorePause,
    Expression<int>? scoreVolume,
    Expression<int>? scoreEnergy,
    Expression<String>? contourJson,
    Expression<String>? pausesJson,
    Expression<String>? flagsJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (recordingId != null) 'recording_id': recordingId,
      if (pitchMedianHz != null) 'pitch_median_hz': pitchMedianHz,
      if (pitchRangeSt != null) 'pitch_range_st': pitchRangeSt,
      if (pitchStdSt != null) 'pitch_std_st': pitchStdSt,
      if (pitchMovementStS != null) 'pitch_movement_st_s': pitchMovementStS,
      if (articulationRate != null) 'articulation_rate': articulationRate,
      if (speakingRate != null) 'speaking_rate': speakingRate,
      if (paceCv != null) 'pace_cv': paceCv,
      if (loudnessRangeDb != null) 'loudness_range_db': loudnessRangeDb,
      if (energyTrendDb != null) 'energy_trend_db': energyTrendDb,
      if (pausesPerMin != null) 'pauses_per_min': pausesPerMin,
      if (pauseRatio != null) 'pause_ratio': pauseRatio,
      if (longPauseCount != null) 'long_pause_count': longPauseCount,
      if (meanPauseMs != null) 'mean_pause_ms': meanPauseMs,
      if (speechMs != null) 'speech_ms': speechMs,
      if (snrDb != null) 'snr_db': snrDb,
      if (clippingPct != null) 'clipping_pct': clippingPct,
      if (fillerCount != null) 'filler_count': fillerCount,
      if (scorePitch != null) 'score_pitch': scorePitch,
      if (scorePace != null) 'score_pace': scorePace,
      if (scorePaceVar != null) 'score_pace_var': scorePaceVar,
      if (scorePause != null) 'score_pause': scorePause,
      if (scoreVolume != null) 'score_volume': scoreVolume,
      if (scoreEnergy != null) 'score_energy': scoreEnergy,
      if (contourJson != null) 'contour_json': contourJson,
      if (pausesJson != null) 'pauses_json': pausesJson,
      if (flagsJson != null) 'flags_json': flagsJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AnalysisResultsCompanion copyWith({
    Value<String?>? recordingId,
    Value<double?>? pitchMedianHz,
    Value<double?>? pitchRangeSt,
    Value<double?>? pitchStdSt,
    Value<double?>? pitchMovementStS,
    Value<double?>? articulationRate,
    Value<double?>? speakingRate,
    Value<double?>? paceCv,
    Value<double?>? loudnessRangeDb,
    Value<double?>? energyTrendDb,
    Value<double?>? pausesPerMin,
    Value<double?>? pauseRatio,
    Value<int?>? longPauseCount,
    Value<int?>? meanPauseMs,
    Value<int?>? speechMs,
    Value<double?>? snrDb,
    Value<double?>? clippingPct,
    Value<int?>? fillerCount,
    Value<int?>? scorePitch,
    Value<int?>? scorePace,
    Value<int?>? scorePaceVar,
    Value<int?>? scorePause,
    Value<int?>? scoreVolume,
    Value<int?>? scoreEnergy,
    Value<String?>? contourJson,
    Value<String?>? pausesJson,
    Value<String?>? flagsJson,
    Value<int>? rowid,
  }) {
    return AnalysisResultsCompanion(
      recordingId: recordingId ?? this.recordingId,
      pitchMedianHz: pitchMedianHz ?? this.pitchMedianHz,
      pitchRangeSt: pitchRangeSt ?? this.pitchRangeSt,
      pitchStdSt: pitchStdSt ?? this.pitchStdSt,
      pitchMovementStS: pitchMovementStS ?? this.pitchMovementStS,
      articulationRate: articulationRate ?? this.articulationRate,
      speakingRate: speakingRate ?? this.speakingRate,
      paceCv: paceCv ?? this.paceCv,
      loudnessRangeDb: loudnessRangeDb ?? this.loudnessRangeDb,
      energyTrendDb: energyTrendDb ?? this.energyTrendDb,
      pausesPerMin: pausesPerMin ?? this.pausesPerMin,
      pauseRatio: pauseRatio ?? this.pauseRatio,
      longPauseCount: longPauseCount ?? this.longPauseCount,
      meanPauseMs: meanPauseMs ?? this.meanPauseMs,
      speechMs: speechMs ?? this.speechMs,
      snrDb: snrDb ?? this.snrDb,
      clippingPct: clippingPct ?? this.clippingPct,
      fillerCount: fillerCount ?? this.fillerCount,
      scorePitch: scorePitch ?? this.scorePitch,
      scorePace: scorePace ?? this.scorePace,
      scorePaceVar: scorePaceVar ?? this.scorePaceVar,
      scorePause: scorePause ?? this.scorePause,
      scoreVolume: scoreVolume ?? this.scoreVolume,
      scoreEnergy: scoreEnergy ?? this.scoreEnergy,
      contourJson: contourJson ?? this.contourJson,
      pausesJson: pausesJson ?? this.pausesJson,
      flagsJson: flagsJson ?? this.flagsJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (recordingId.present) {
      map['recording_id'] = Variable<String>(recordingId.value);
    }
    if (pitchMedianHz.present) {
      map['pitch_median_hz'] = Variable<double>(pitchMedianHz.value);
    }
    if (pitchRangeSt.present) {
      map['pitch_range_st'] = Variable<double>(pitchRangeSt.value);
    }
    if (pitchStdSt.present) {
      map['pitch_std_st'] = Variable<double>(pitchStdSt.value);
    }
    if (pitchMovementStS.present) {
      map['pitch_movement_st_s'] = Variable<double>(pitchMovementStS.value);
    }
    if (articulationRate.present) {
      map['articulation_rate'] = Variable<double>(articulationRate.value);
    }
    if (speakingRate.present) {
      map['speaking_rate'] = Variable<double>(speakingRate.value);
    }
    if (paceCv.present) {
      map['pace_cv'] = Variable<double>(paceCv.value);
    }
    if (loudnessRangeDb.present) {
      map['loudness_range_db'] = Variable<double>(loudnessRangeDb.value);
    }
    if (energyTrendDb.present) {
      map['energy_trend_db'] = Variable<double>(energyTrendDb.value);
    }
    if (pausesPerMin.present) {
      map['pauses_per_min'] = Variable<double>(pausesPerMin.value);
    }
    if (pauseRatio.present) {
      map['pause_ratio'] = Variable<double>(pauseRatio.value);
    }
    if (longPauseCount.present) {
      map['long_pause_count'] = Variable<int>(longPauseCount.value);
    }
    if (meanPauseMs.present) {
      map['mean_pause_ms'] = Variable<int>(meanPauseMs.value);
    }
    if (speechMs.present) {
      map['speech_ms'] = Variable<int>(speechMs.value);
    }
    if (snrDb.present) {
      map['snr_db'] = Variable<double>(snrDb.value);
    }
    if (clippingPct.present) {
      map['clipping_pct'] = Variable<double>(clippingPct.value);
    }
    if (fillerCount.present) {
      map['filler_count'] = Variable<int>(fillerCount.value);
    }
    if (scorePitch.present) {
      map['score_pitch'] = Variable<int>(scorePitch.value);
    }
    if (scorePace.present) {
      map['score_pace'] = Variable<int>(scorePace.value);
    }
    if (scorePaceVar.present) {
      map['score_pace_var'] = Variable<int>(scorePaceVar.value);
    }
    if (scorePause.present) {
      map['score_pause'] = Variable<int>(scorePause.value);
    }
    if (scoreVolume.present) {
      map['score_volume'] = Variable<int>(scoreVolume.value);
    }
    if (scoreEnergy.present) {
      map['score_energy'] = Variable<int>(scoreEnergy.value);
    }
    if (contourJson.present) {
      map['contour_json'] = Variable<String>(contourJson.value);
    }
    if (pausesJson.present) {
      map['pauses_json'] = Variable<String>(pausesJson.value);
    }
    if (flagsJson.present) {
      map['flags_json'] = Variable<String>(flagsJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AnalysisResultsCompanion(')
          ..write('recordingId: $recordingId, ')
          ..write('pitchMedianHz: $pitchMedianHz, ')
          ..write('pitchRangeSt: $pitchRangeSt, ')
          ..write('pitchStdSt: $pitchStdSt, ')
          ..write('pitchMovementStS: $pitchMovementStS, ')
          ..write('articulationRate: $articulationRate, ')
          ..write('speakingRate: $speakingRate, ')
          ..write('paceCv: $paceCv, ')
          ..write('loudnessRangeDb: $loudnessRangeDb, ')
          ..write('energyTrendDb: $energyTrendDb, ')
          ..write('pausesPerMin: $pausesPerMin, ')
          ..write('pauseRatio: $pauseRatio, ')
          ..write('longPauseCount: $longPauseCount, ')
          ..write('meanPauseMs: $meanPauseMs, ')
          ..write('speechMs: $speechMs, ')
          ..write('snrDb: $snrDb, ')
          ..write('clippingPct: $clippingPct, ')
          ..write('fillerCount: $fillerCount, ')
          ..write('scorePitch: $scorePitch, ')
          ..write('scorePace: $scorePace, ')
          ..write('scorePaceVar: $scorePaceVar, ')
          ..write('scorePause: $scorePause, ')
          ..write('scoreVolume: $scoreVolume, ')
          ..write('scoreEnergy: $scoreEnergy, ')
          ..write('contourJson: $contourJson, ')
          ..write('pausesJson: $pausesJson, ')
          ..write('flagsJson: $flagsJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class TipLog extends Table with TableInfo<TipLog, TipLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  TipLog(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _recordingIdMeta = const VerificationMeta(
    'recordingId',
  );
  late final GeneratedColumn<String> recordingId = GeneratedColumn<String>(
    'recording_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES recordings(id)ON DELETE CASCADE',
  );
  static const VerificationMeta _ruleIdMeta = const VerificationMeta('ruleId');
  late final GeneratedColumn<String> ruleId = GeneratedColumn<String>(
    'rule_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _variantIdMeta = const VerificationMeta(
    'variantId',
  );
  late final GeneratedColumn<String> variantId = GeneratedColumn<String>(
    'variant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _shownAtMeta = const VerificationMeta(
    'shownAt',
  );
  late final GeneratedColumn<int> shownAt = GeneratedColumn<int>(
    'shown_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _helpfulMeta = const VerificationMeta(
    'helpful',
  );
  late final GeneratedColumn<int> helpful = GeneratedColumn<int>(
    'helpful',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recordingId,
    ruleId,
    variantId,
    kind,
    shownAt,
    helpful,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tip_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<TipLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recording_id')) {
      context.handle(
        _recordingIdMeta,
        recordingId.isAcceptableOrUnknown(
          data['recording_id']!,
          _recordingIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordingIdMeta);
    }
    if (data.containsKey('rule_id')) {
      context.handle(
        _ruleIdMeta,
        ruleId.isAcceptableOrUnknown(data['rule_id']!, _ruleIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ruleIdMeta);
    }
    if (data.containsKey('variant_id')) {
      context.handle(
        _variantIdMeta,
        variantId.isAcceptableOrUnknown(data['variant_id']!, _variantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_variantIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('shown_at')) {
      context.handle(
        _shownAtMeta,
        shownAt.isAcceptableOrUnknown(data['shown_at']!, _shownAtMeta),
      );
    } else if (isInserting) {
      context.missing(_shownAtMeta);
    }
    if (data.containsKey('helpful')) {
      context.handle(
        _helpfulMeta,
        helpful.isAcceptableOrUnknown(data['helpful']!, _helpfulMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TipLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TipLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recordingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recording_id'],
      )!,
      ruleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_id'],
      )!,
      variantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}variant_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      shownAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shown_at'],
      )!,
      helpful: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}helpful'],
      ),
    );
  }

  @override
  TipLog createAlias(String alias) {
    return TipLog(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class TipLogData extends DataClass implements Insertable<TipLogData> {
  final int id;
  final String recordingId;
  final String ruleId;
  final String variantId;
  final String kind;
  final int shownAt;
  final int? helpful;
  const TipLogData({
    required this.id,
    required this.recordingId,
    required this.ruleId,
    required this.variantId,
    required this.kind,
    required this.shownAt,
    this.helpful,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recording_id'] = Variable<String>(recordingId);
    map['rule_id'] = Variable<String>(ruleId);
    map['variant_id'] = Variable<String>(variantId);
    map['kind'] = Variable<String>(kind);
    map['shown_at'] = Variable<int>(shownAt);
    if (!nullToAbsent || helpful != null) {
      map['helpful'] = Variable<int>(helpful);
    }
    return map;
  }

  TipLogCompanion toCompanion(bool nullToAbsent) {
    return TipLogCompanion(
      id: Value(id),
      recordingId: Value(recordingId),
      ruleId: Value(ruleId),
      variantId: Value(variantId),
      kind: Value(kind),
      shownAt: Value(shownAt),
      helpful: helpful == null && nullToAbsent
          ? const Value.absent()
          : Value(helpful),
    );
  }

  factory TipLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TipLogData(
      id: serializer.fromJson<int>(json['id']),
      recordingId: serializer.fromJson<String>(json['recording_id']),
      ruleId: serializer.fromJson<String>(json['rule_id']),
      variantId: serializer.fromJson<String>(json['variant_id']),
      kind: serializer.fromJson<String>(json['kind']),
      shownAt: serializer.fromJson<int>(json['shown_at']),
      helpful: serializer.fromJson<int?>(json['helpful']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recording_id': serializer.toJson<String>(recordingId),
      'rule_id': serializer.toJson<String>(ruleId),
      'variant_id': serializer.toJson<String>(variantId),
      'kind': serializer.toJson<String>(kind),
      'shown_at': serializer.toJson<int>(shownAt),
      'helpful': serializer.toJson<int?>(helpful),
    };
  }

  TipLogData copyWith({
    int? id,
    String? recordingId,
    String? ruleId,
    String? variantId,
    String? kind,
    int? shownAt,
    Value<int?> helpful = const Value.absent(),
  }) => TipLogData(
    id: id ?? this.id,
    recordingId: recordingId ?? this.recordingId,
    ruleId: ruleId ?? this.ruleId,
    variantId: variantId ?? this.variantId,
    kind: kind ?? this.kind,
    shownAt: shownAt ?? this.shownAt,
    helpful: helpful.present ? helpful.value : this.helpful,
  );
  TipLogData copyWithCompanion(TipLogCompanion data) {
    return TipLogData(
      id: data.id.present ? data.id.value : this.id,
      recordingId: data.recordingId.present
          ? data.recordingId.value
          : this.recordingId,
      ruleId: data.ruleId.present ? data.ruleId.value : this.ruleId,
      variantId: data.variantId.present ? data.variantId.value : this.variantId,
      kind: data.kind.present ? data.kind.value : this.kind,
      shownAt: data.shownAt.present ? data.shownAt.value : this.shownAt,
      helpful: data.helpful.present ? data.helpful.value : this.helpful,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TipLogData(')
          ..write('id: $id, ')
          ..write('recordingId: $recordingId, ')
          ..write('ruleId: $ruleId, ')
          ..write('variantId: $variantId, ')
          ..write('kind: $kind, ')
          ..write('shownAt: $shownAt, ')
          ..write('helpful: $helpful')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recordingId, ruleId, variantId, kind, shownAt, helpful);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TipLogData &&
          other.id == this.id &&
          other.recordingId == this.recordingId &&
          other.ruleId == this.ruleId &&
          other.variantId == this.variantId &&
          other.kind == this.kind &&
          other.shownAt == this.shownAt &&
          other.helpful == this.helpful);
}

class TipLogCompanion extends UpdateCompanion<TipLogData> {
  final Value<int> id;
  final Value<String> recordingId;
  final Value<String> ruleId;
  final Value<String> variantId;
  final Value<String> kind;
  final Value<int> shownAt;
  final Value<int?> helpful;
  const TipLogCompanion({
    this.id = const Value.absent(),
    this.recordingId = const Value.absent(),
    this.ruleId = const Value.absent(),
    this.variantId = const Value.absent(),
    this.kind = const Value.absent(),
    this.shownAt = const Value.absent(),
    this.helpful = const Value.absent(),
  });
  TipLogCompanion.insert({
    this.id = const Value.absent(),
    required String recordingId,
    required String ruleId,
    required String variantId,
    required String kind,
    required int shownAt,
    this.helpful = const Value.absent(),
  }) : recordingId = Value(recordingId),
       ruleId = Value(ruleId),
       variantId = Value(variantId),
       kind = Value(kind),
       shownAt = Value(shownAt);
  static Insertable<TipLogData> custom({
    Expression<int>? id,
    Expression<String>? recordingId,
    Expression<String>? ruleId,
    Expression<String>? variantId,
    Expression<String>? kind,
    Expression<int>? shownAt,
    Expression<int>? helpful,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordingId != null) 'recording_id': recordingId,
      if (ruleId != null) 'rule_id': ruleId,
      if (variantId != null) 'variant_id': variantId,
      if (kind != null) 'kind': kind,
      if (shownAt != null) 'shown_at': shownAt,
      if (helpful != null) 'helpful': helpful,
    });
  }

  TipLogCompanion copyWith({
    Value<int>? id,
    Value<String>? recordingId,
    Value<String>? ruleId,
    Value<String>? variantId,
    Value<String>? kind,
    Value<int>? shownAt,
    Value<int?>? helpful,
  }) {
    return TipLogCompanion(
      id: id ?? this.id,
      recordingId: recordingId ?? this.recordingId,
      ruleId: ruleId ?? this.ruleId,
      variantId: variantId ?? this.variantId,
      kind: kind ?? this.kind,
      shownAt: shownAt ?? this.shownAt,
      helpful: helpful ?? this.helpful,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordingId.present) {
      map['recording_id'] = Variable<String>(recordingId.value);
    }
    if (ruleId.present) {
      map['rule_id'] = Variable<String>(ruleId.value);
    }
    if (variantId.present) {
      map['variant_id'] = Variable<String>(variantId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (shownAt.present) {
      map['shown_at'] = Variable<int>(shownAt.value);
    }
    if (helpful.present) {
      map['helpful'] = Variable<int>(helpful.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TipLogCompanion(')
          ..write('id: $id, ')
          ..write('recordingId: $recordingId, ')
          ..write('ruleId: $ruleId, ')
          ..write('variantId: $variantId, ')
          ..write('kind: $kind, ')
          ..write('shownAt: $shownAt, ')
          ..write('helpful: $helpful')
          ..write(')'))
        .toString();
  }
}

class DrillSessions extends Table with TableInfo<DrillSessions, DrillSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DrillSessions(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY',
  );
  static const VerificationMeta _drillIdMeta = const VerificationMeta(
    'drillId',
  );
  late final GeneratedColumn<String> drillId = GeneratedColumn<String>(
    'drill_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  late final GeneratedColumn<int> completedAt = GeneratedColumn<int>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _recordingIdMeta = const VerificationMeta(
    'recordingId',
  );
  late final GeneratedColumn<String> recordingId = GeneratedColumn<String>(
    'recording_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'REFERENCES recordings(id)ON DELETE SET NULL',
  );
  static const VerificationMeta _passedMeta = const VerificationMeta('passed');
  late final GeneratedColumn<int> passed = GeneratedColumn<int>(
    'passed',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    drillId,
    startedAt,
    completedAt,
    recordingId,
    passed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'drill_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<DrillSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('drill_id')) {
      context.handle(
        _drillIdMeta,
        drillId.isAcceptableOrUnknown(data['drill_id']!, _drillIdMeta),
      );
    } else if (isInserting) {
      context.missing(_drillIdMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('recording_id')) {
      context.handle(
        _recordingIdMeta,
        recordingId.isAcceptableOrUnknown(
          data['recording_id']!,
          _recordingIdMeta,
        ),
      );
    }
    if (data.containsKey('passed')) {
      context.handle(
        _passedMeta,
        passed.isAcceptableOrUnknown(data['passed']!, _passedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DrillSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DrillSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      ),
      drillId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}drill_id'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_at'],
      ),
      recordingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recording_id'],
      ),
      passed: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}passed'],
      ),
    );
  }

  @override
  DrillSessions createAlias(String alias) {
    return DrillSessions(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class DrillSession extends DataClass implements Insertable<DrillSession> {
  final String? id;
  final String drillId;
  final int startedAt;
  final int? completedAt;
  final String? recordingId;
  final int? passed;
  const DrillSession({
    this.id,
    required this.drillId,
    required this.startedAt,
    this.completedAt,
    this.recordingId,
    this.passed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || id != null) {
      map['id'] = Variable<String>(id);
    }
    map['drill_id'] = Variable<String>(drillId);
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<int>(completedAt);
    }
    if (!nullToAbsent || recordingId != null) {
      map['recording_id'] = Variable<String>(recordingId);
    }
    if (!nullToAbsent || passed != null) {
      map['passed'] = Variable<int>(passed);
    }
    return map;
  }

  DrillSessionsCompanion toCompanion(bool nullToAbsent) {
    return DrillSessionsCompanion(
      id: id == null && nullToAbsent ? const Value.absent() : Value(id),
      drillId: Value(drillId),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      recordingId: recordingId == null && nullToAbsent
          ? const Value.absent()
          : Value(recordingId),
      passed: passed == null && nullToAbsent
          ? const Value.absent()
          : Value(passed),
    );
  }

  factory DrillSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DrillSession(
      id: serializer.fromJson<String?>(json['id']),
      drillId: serializer.fromJson<String>(json['drill_id']),
      startedAt: serializer.fromJson<int>(json['started_at']),
      completedAt: serializer.fromJson<int?>(json['completed_at']),
      recordingId: serializer.fromJson<String?>(json['recording_id']),
      passed: serializer.fromJson<int?>(json['passed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String?>(id),
      'drill_id': serializer.toJson<String>(drillId),
      'started_at': serializer.toJson<int>(startedAt),
      'completed_at': serializer.toJson<int?>(completedAt),
      'recording_id': serializer.toJson<String?>(recordingId),
      'passed': serializer.toJson<int?>(passed),
    };
  }

  DrillSession copyWith({
    Value<String?> id = const Value.absent(),
    String? drillId,
    int? startedAt,
    Value<int?> completedAt = const Value.absent(),
    Value<String?> recordingId = const Value.absent(),
    Value<int?> passed = const Value.absent(),
  }) => DrillSession(
    id: id.present ? id.value : this.id,
    drillId: drillId ?? this.drillId,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    recordingId: recordingId.present ? recordingId.value : this.recordingId,
    passed: passed.present ? passed.value : this.passed,
  );
  DrillSession copyWithCompanion(DrillSessionsCompanion data) {
    return DrillSession(
      id: data.id.present ? data.id.value : this.id,
      drillId: data.drillId.present ? data.drillId.value : this.drillId,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      recordingId: data.recordingId.present
          ? data.recordingId.value
          : this.recordingId,
      passed: data.passed.present ? data.passed.value : this.passed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DrillSession(')
          ..write('id: $id, ')
          ..write('drillId: $drillId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('recordingId: $recordingId, ')
          ..write('passed: $passed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, drillId, startedAt, completedAt, recordingId, passed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DrillSession &&
          other.id == this.id &&
          other.drillId == this.drillId &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.recordingId == this.recordingId &&
          other.passed == this.passed);
}

class DrillSessionsCompanion extends UpdateCompanion<DrillSession> {
  final Value<String?> id;
  final Value<String> drillId;
  final Value<int> startedAt;
  final Value<int?> completedAt;
  final Value<String?> recordingId;
  final Value<int?> passed;
  final Value<int> rowid;
  const DrillSessionsCompanion({
    this.id = const Value.absent(),
    this.drillId = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.recordingId = const Value.absent(),
    this.passed = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DrillSessionsCompanion.insert({
    this.id = const Value.absent(),
    required String drillId,
    required int startedAt,
    this.completedAt = const Value.absent(),
    this.recordingId = const Value.absent(),
    this.passed = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : drillId = Value(drillId),
       startedAt = Value(startedAt);
  static Insertable<DrillSession> custom({
    Expression<String>? id,
    Expression<String>? drillId,
    Expression<int>? startedAt,
    Expression<int>? completedAt,
    Expression<String>? recordingId,
    Expression<int>? passed,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (drillId != null) 'drill_id': drillId,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (recordingId != null) 'recording_id': recordingId,
      if (passed != null) 'passed': passed,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DrillSessionsCompanion copyWith({
    Value<String?>? id,
    Value<String>? drillId,
    Value<int>? startedAt,
    Value<int?>? completedAt,
    Value<String?>? recordingId,
    Value<int?>? passed,
    Value<int>? rowid,
  }) {
    return DrillSessionsCompanion(
      id: id ?? this.id,
      drillId: drillId ?? this.drillId,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      recordingId: recordingId ?? this.recordingId,
      passed: passed ?? this.passed,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (drillId.present) {
      map['drill_id'] = Variable<String>(drillId.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<int>(completedAt.value);
    }
    if (recordingId.present) {
      map['recording_id'] = Variable<String>(recordingId.value);
    }
    if (passed.present) {
      map['passed'] = Variable<int>(passed.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DrillSessionsCompanion(')
          ..write('id: $id, ')
          ..write('drillId: $drillId, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('recordingId: $recordingId, ')
          ..write('passed: $passed, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class DailyActivity extends Table
    with TableInfo<DailyActivity, DailyActivityData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  DailyActivity(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY',
  );
  static const VerificationMeta _practiceMsMeta = const VerificationMeta(
    'practiceMs',
  );
  late final GeneratedColumn<int> practiceMs = GeneratedColumn<int>(
    'practice_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _recordingsMeta = const VerificationMeta(
    'recordings',
  );
  late final GeneratedColumn<int> recordings = GeneratedColumn<int>(
    'recordings',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  static const VerificationMeta _drillsMeta = const VerificationMeta('drills');
  late final GeneratedColumn<int> drills = GeneratedColumn<int>(
    'drills',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT 0',
    defaultValue: const CustomExpression('0'),
  );
  @override
  List<GeneratedColumn> get $columns => [day, practiceMs, recordings, drills];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_activity';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyActivityData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    }
    if (data.containsKey('practice_ms')) {
      context.handle(
        _practiceMsMeta,
        practiceMs.isAcceptableOrUnknown(data['practice_ms']!, _practiceMsMeta),
      );
    }
    if (data.containsKey('recordings')) {
      context.handle(
        _recordingsMeta,
        recordings.isAcceptableOrUnknown(data['recordings']!, _recordingsMeta),
      );
    }
    if (data.containsKey('drills')) {
      context.handle(
        _drillsMeta,
        drills.isAcceptableOrUnknown(data['drills']!, _drillsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {day};
  @override
  DailyActivityData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyActivityData(
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      ),
      practiceMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}practice_ms'],
      )!,
      recordings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recordings'],
      )!,
      drills: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}drills'],
      )!,
    );
  }

  @override
  DailyActivity createAlias(String alias) {
    return DailyActivity(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class DailyActivityData extends DataClass
    implements Insertable<DailyActivityData> {
  final String? day;
  final int practiceMs;
  final int recordings;
  final int drills;
  const DailyActivityData({
    this.day,
    required this.practiceMs,
    required this.recordings,
    required this.drills,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || day != null) {
      map['day'] = Variable<String>(day);
    }
    map['practice_ms'] = Variable<int>(practiceMs);
    map['recordings'] = Variable<int>(recordings);
    map['drills'] = Variable<int>(drills);
    return map;
  }

  DailyActivityCompanion toCompanion(bool nullToAbsent) {
    return DailyActivityCompanion(
      day: day == null && nullToAbsent ? const Value.absent() : Value(day),
      practiceMs: Value(practiceMs),
      recordings: Value(recordings),
      drills: Value(drills),
    );
  }

  factory DailyActivityData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyActivityData(
      day: serializer.fromJson<String?>(json['day']),
      practiceMs: serializer.fromJson<int>(json['practice_ms']),
      recordings: serializer.fromJson<int>(json['recordings']),
      drills: serializer.fromJson<int>(json['drills']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'day': serializer.toJson<String?>(day),
      'practice_ms': serializer.toJson<int>(practiceMs),
      'recordings': serializer.toJson<int>(recordings),
      'drills': serializer.toJson<int>(drills),
    };
  }

  DailyActivityData copyWith({
    Value<String?> day = const Value.absent(),
    int? practiceMs,
    int? recordings,
    int? drills,
  }) => DailyActivityData(
    day: day.present ? day.value : this.day,
    practiceMs: practiceMs ?? this.practiceMs,
    recordings: recordings ?? this.recordings,
    drills: drills ?? this.drills,
  );
  DailyActivityData copyWithCompanion(DailyActivityCompanion data) {
    return DailyActivityData(
      day: data.day.present ? data.day.value : this.day,
      practiceMs: data.practiceMs.present
          ? data.practiceMs.value
          : this.practiceMs,
      recordings: data.recordings.present
          ? data.recordings.value
          : this.recordings,
      drills: data.drills.present ? data.drills.value : this.drills,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivityData(')
          ..write('day: $day, ')
          ..write('practiceMs: $practiceMs, ')
          ..write('recordings: $recordings, ')
          ..write('drills: $drills')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(day, practiceMs, recordings, drills);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyActivityData &&
          other.day == this.day &&
          other.practiceMs == this.practiceMs &&
          other.recordings == this.recordings &&
          other.drills == this.drills);
}

class DailyActivityCompanion extends UpdateCompanion<DailyActivityData> {
  final Value<String?> day;
  final Value<int> practiceMs;
  final Value<int> recordings;
  final Value<int> drills;
  final Value<int> rowid;
  const DailyActivityCompanion({
    this.day = const Value.absent(),
    this.practiceMs = const Value.absent(),
    this.recordings = const Value.absent(),
    this.drills = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyActivityCompanion.insert({
    this.day = const Value.absent(),
    this.practiceMs = const Value.absent(),
    this.recordings = const Value.absent(),
    this.drills = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  static Insertable<DailyActivityData> custom({
    Expression<String>? day,
    Expression<int>? practiceMs,
    Expression<int>? recordings,
    Expression<int>? drills,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (day != null) 'day': day,
      if (practiceMs != null) 'practice_ms': practiceMs,
      if (recordings != null) 'recordings': recordings,
      if (drills != null) 'drills': drills,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyActivityCompanion copyWith({
    Value<String?>? day,
    Value<int>? practiceMs,
    Value<int>? recordings,
    Value<int>? drills,
    Value<int>? rowid,
  }) {
    return DailyActivityCompanion(
      day: day ?? this.day,
      practiceMs: practiceMs ?? this.practiceMs,
      recordings: recordings ?? this.recordings,
      drills: drills ?? this.drills,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (practiceMs.present) {
      map['practice_ms'] = Variable<int>(practiceMs.value);
    }
    if (recordings.present) {
      map['recordings'] = Variable<int>(recordings.value);
    }
    if (drills.present) {
      map['drills'] = Variable<int>(drills.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyActivityCompanion(')
          ..write('day: $day, ')
          ..write('practiceMs: $practiceMs, ')
          ..write('recordings: $recordings, ')
          ..write('drills: $drills, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Settings extends Table with TableInfo<Settings, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Settings(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY',
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      ),
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  Settings createAlias(String alias) {
    return Settings(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Setting extends DataClass implements Insertable<Setting> {
  final String? key;
  final String value;
  const Setting({this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (!nullToAbsent || key != null) {
      map['key'] = Variable<String>(key);
    }
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      key: key == null && nullToAbsent ? const Value.absent() : Value(key),
      value: Value(value),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      key: serializer.fromJson<String?>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String?>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  Setting copyWith({
    Value<String?> key = const Value.absent(),
    String? value,
  }) => Setting(
    key: key.present ? key.value : this.key,
    value: value ?? this.value,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting && other.key == this.key && other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String?> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.key = const Value.absent(),
    required String value,
    this.rowid = const Value.absent(),
  }) : value = Value(value);
  static Insertable<Setting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String?>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class Entitlements extends Table with TableInfo<Entitlements, Entitlement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  Entitlements(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY CHECK (id = 1)',
  );
  static const VerificationMeta _tierMeta = const VerificationMeta('tier');
  late final GeneratedColumn<String> tier = GeneratedColumn<String>(
    'tier',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: 'NOT NULL DEFAULT \'free\'',
    defaultValue: const CustomExpression('\'free\''),
  );
  static const VerificationMeta _expiresAtMeta = const VerificationMeta(
    'expiresAt',
  );
  late final GeneratedColumn<int> expiresAt = GeneratedColumn<int>(
    'expires_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    tier,
    expiresAt,
    source,
    token,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'entitlements';
  @override
  VerificationContext validateIntegrity(
    Insertable<Entitlement> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('tier')) {
      context.handle(
        _tierMeta,
        tier.isAcceptableOrUnknown(data['tier']!, _tierMeta),
      );
    }
    if (data.containsKey('expires_at')) {
      context.handle(
        _expiresAtMeta,
        expiresAt.isAcceptableOrUnknown(data['expires_at']!, _expiresAtMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Entitlement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Entitlement(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      tier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tier'],
      )!,
      expiresAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}expires_at'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      token: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  Entitlements createAlias(String alias) {
    return Entitlements(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class Entitlement extends DataClass implements Insertable<Entitlement> {
  final int id;
  final String tier;
  final int? expiresAt;
  final String? source;
  final String? token;
  final int updatedAt;
  const Entitlement({
    required this.id,
    required this.tier,
    this.expiresAt,
    this.source,
    this.token,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['tier'] = Variable<String>(tier);
    if (!nullToAbsent || expiresAt != null) {
      map['expires_at'] = Variable<int>(expiresAt);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    if (!nullToAbsent || token != null) {
      map['token'] = Variable<String>(token);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  EntitlementsCompanion toCompanion(bool nullToAbsent) {
    return EntitlementsCompanion(
      id: Value(id),
      tier: Value(tier),
      expiresAt: expiresAt == null && nullToAbsent
          ? const Value.absent()
          : Value(expiresAt),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      token: token == null && nullToAbsent
          ? const Value.absent()
          : Value(token),
      updatedAt: Value(updatedAt),
    );
  }

  factory Entitlement.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Entitlement(
      id: serializer.fromJson<int>(json['id']),
      tier: serializer.fromJson<String>(json['tier']),
      expiresAt: serializer.fromJson<int?>(json['expires_at']),
      source: serializer.fromJson<String?>(json['source']),
      token: serializer.fromJson<String?>(json['token']),
      updatedAt: serializer.fromJson<int>(json['updated_at']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'tier': serializer.toJson<String>(tier),
      'expires_at': serializer.toJson<int?>(expiresAt),
      'source': serializer.toJson<String?>(source),
      'token': serializer.toJson<String?>(token),
      'updated_at': serializer.toJson<int>(updatedAt),
    };
  }

  Entitlement copyWith({
    int? id,
    String? tier,
    Value<int?> expiresAt = const Value.absent(),
    Value<String?> source = const Value.absent(),
    Value<String?> token = const Value.absent(),
    int? updatedAt,
  }) => Entitlement(
    id: id ?? this.id,
    tier: tier ?? this.tier,
    expiresAt: expiresAt.present ? expiresAt.value : this.expiresAt,
    source: source.present ? source.value : this.source,
    token: token.present ? token.value : this.token,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Entitlement copyWithCompanion(EntitlementsCompanion data) {
    return Entitlement(
      id: data.id.present ? data.id.value : this.id,
      tier: data.tier.present ? data.tier.value : this.tier,
      expiresAt: data.expiresAt.present ? data.expiresAt.value : this.expiresAt,
      source: data.source.present ? data.source.value : this.source,
      token: data.token.present ? data.token.value : this.token,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Entitlement(')
          ..write('id: $id, ')
          ..write('tier: $tier, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('source: $source, ')
          ..write('token: $token, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, tier, expiresAt, source, token, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Entitlement &&
          other.id == this.id &&
          other.tier == this.tier &&
          other.expiresAt == this.expiresAt &&
          other.source == this.source &&
          other.token == this.token &&
          other.updatedAt == this.updatedAt);
}

class EntitlementsCompanion extends UpdateCompanion<Entitlement> {
  final Value<int> id;
  final Value<String> tier;
  final Value<int?> expiresAt;
  final Value<String?> source;
  final Value<String?> token;
  final Value<int> updatedAt;
  const EntitlementsCompanion({
    this.id = const Value.absent(),
    this.tier = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.source = const Value.absent(),
    this.token = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  EntitlementsCompanion.insert({
    this.id = const Value.absent(),
    this.tier = const Value.absent(),
    this.expiresAt = const Value.absent(),
    this.source = const Value.absent(),
    this.token = const Value.absent(),
    required int updatedAt,
  }) : updatedAt = Value(updatedAt);
  static Insertable<Entitlement> custom({
    Expression<int>? id,
    Expression<String>? tier,
    Expression<int>? expiresAt,
    Expression<String>? source,
    Expression<String>? token,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (tier != null) 'tier': tier,
      if (expiresAt != null) 'expires_at': expiresAt,
      if (source != null) 'source': source,
      if (token != null) 'token': token,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  EntitlementsCompanion copyWith({
    Value<int>? id,
    Value<String>? tier,
    Value<int?>? expiresAt,
    Value<String?>? source,
    Value<String?>? token,
    Value<int>? updatedAt,
  }) {
    return EntitlementsCompanion(
      id: id ?? this.id,
      tier: tier ?? this.tier,
      expiresAt: expiresAt ?? this.expiresAt,
      source: source ?? this.source,
      token: token ?? this.token,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (tier.present) {
      map['tier'] = Variable<String>(tier.value);
    }
    if (expiresAt.present) {
      map['expires_at'] = Variable<int>(expiresAt.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EntitlementsCompanion(')
          ..write('id: $id, ')
          ..write('tier: $tier, ')
          ..write('expiresAt: $expiresAt, ')
          ..write('source: $source, ')
          ..write('token: $token, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class AiFeedback extends Table with TableInfo<AiFeedback, AiFeedbackData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  AiFeedback(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: 'PRIMARY KEY AUTOINCREMENT',
  );
  static const VerificationMeta _recordingIdMeta = const VerificationMeta(
    'recordingId',
  );
  late final GeneratedColumn<String> recordingId = GeneratedColumn<String>(
    'recording_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL REFERENCES recordings(id)ON DELETE CASCADE',
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _modelMeta = const VerificationMeta('model');
  late final GeneratedColumn<String> model = GeneratedColumn<String>(
    'model',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _promptVersionMeta = const VerificationMeta(
    'promptVersion',
  );
  late final GeneratedColumn<int> promptVersion = GeneratedColumn<int>(
    'prompt_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _bodyJsonMeta = const VerificationMeta(
    'bodyJson',
  );
  late final GeneratedColumn<String> bodyJson = GeneratedColumn<String>(
    'body_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    $customConstraints: 'NOT NULL',
  );
  static const VerificationMeta _tokensInMeta = const VerificationMeta(
    'tokensIn',
  );
  late final GeneratedColumn<int> tokensIn = GeneratedColumn<int>(
    'tokens_in',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  static const VerificationMeta _tokensOutMeta = const VerificationMeta(
    'tokensOut',
  );
  late final GeneratedColumn<int> tokensOut = GeneratedColumn<int>(
    'tokens_out',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    $customConstraints: '',
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recordingId,
    createdAt,
    model,
    promptVersion,
    bodyJson,
    tokensIn,
    tokensOut,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ai_feedback';
  @override
  VerificationContext validateIntegrity(
    Insertable<AiFeedbackData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recording_id')) {
      context.handle(
        _recordingIdMeta,
        recordingId.isAcceptableOrUnknown(
          data['recording_id']!,
          _recordingIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recordingIdMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('model')) {
      context.handle(
        _modelMeta,
        model.isAcceptableOrUnknown(data['model']!, _modelMeta),
      );
    }
    if (data.containsKey('prompt_version')) {
      context.handle(
        _promptVersionMeta,
        promptVersion.isAcceptableOrUnknown(
          data['prompt_version']!,
          _promptVersionMeta,
        ),
      );
    }
    if (data.containsKey('body_json')) {
      context.handle(
        _bodyJsonMeta,
        bodyJson.isAcceptableOrUnknown(data['body_json']!, _bodyJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyJsonMeta);
    }
    if (data.containsKey('tokens_in')) {
      context.handle(
        _tokensInMeta,
        tokensIn.isAcceptableOrUnknown(data['tokens_in']!, _tokensInMeta),
      );
    }
    if (data.containsKey('tokens_out')) {
      context.handle(
        _tokensOutMeta,
        tokensOut.isAcceptableOrUnknown(data['tokens_out']!, _tokensOutMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AiFeedbackData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AiFeedbackData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recordingId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recording_id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      model: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}model'],
      ),
      promptVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prompt_version'],
      ),
      bodyJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_json'],
      )!,
      tokensIn: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tokens_in'],
      ),
      tokensOut: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tokens_out'],
      ),
    );
  }

  @override
  AiFeedback createAlias(String alias) {
    return AiFeedback(attachedDatabase, alias);
  }

  @override
  bool get dontWriteConstraints => true;
}

class AiFeedbackData extends DataClass implements Insertable<AiFeedbackData> {
  final int id;
  final String recordingId;
  final int createdAt;
  final String? model;
  final int? promptVersion;
  final String bodyJson;
  final int? tokensIn;
  final int? tokensOut;
  const AiFeedbackData({
    required this.id,
    required this.recordingId,
    required this.createdAt,
    this.model,
    this.promptVersion,
    required this.bodyJson,
    this.tokensIn,
    this.tokensOut,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recording_id'] = Variable<String>(recordingId);
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || model != null) {
      map['model'] = Variable<String>(model);
    }
    if (!nullToAbsent || promptVersion != null) {
      map['prompt_version'] = Variable<int>(promptVersion);
    }
    map['body_json'] = Variable<String>(bodyJson);
    if (!nullToAbsent || tokensIn != null) {
      map['tokens_in'] = Variable<int>(tokensIn);
    }
    if (!nullToAbsent || tokensOut != null) {
      map['tokens_out'] = Variable<int>(tokensOut);
    }
    return map;
  }

  AiFeedbackCompanion toCompanion(bool nullToAbsent) {
    return AiFeedbackCompanion(
      id: Value(id),
      recordingId: Value(recordingId),
      createdAt: Value(createdAt),
      model: model == null && nullToAbsent
          ? const Value.absent()
          : Value(model),
      promptVersion: promptVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(promptVersion),
      bodyJson: Value(bodyJson),
      tokensIn: tokensIn == null && nullToAbsent
          ? const Value.absent()
          : Value(tokensIn),
      tokensOut: tokensOut == null && nullToAbsent
          ? const Value.absent()
          : Value(tokensOut),
    );
  }

  factory AiFeedbackData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AiFeedbackData(
      id: serializer.fromJson<int>(json['id']),
      recordingId: serializer.fromJson<String>(json['recording_id']),
      createdAt: serializer.fromJson<int>(json['created_at']),
      model: serializer.fromJson<String?>(json['model']),
      promptVersion: serializer.fromJson<int?>(json['prompt_version']),
      bodyJson: serializer.fromJson<String>(json['body_json']),
      tokensIn: serializer.fromJson<int?>(json['tokens_in']),
      tokensOut: serializer.fromJson<int?>(json['tokens_out']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recording_id': serializer.toJson<String>(recordingId),
      'created_at': serializer.toJson<int>(createdAt),
      'model': serializer.toJson<String?>(model),
      'prompt_version': serializer.toJson<int?>(promptVersion),
      'body_json': serializer.toJson<String>(bodyJson),
      'tokens_in': serializer.toJson<int?>(tokensIn),
      'tokens_out': serializer.toJson<int?>(tokensOut),
    };
  }

  AiFeedbackData copyWith({
    int? id,
    String? recordingId,
    int? createdAt,
    Value<String?> model = const Value.absent(),
    Value<int?> promptVersion = const Value.absent(),
    String? bodyJson,
    Value<int?> tokensIn = const Value.absent(),
    Value<int?> tokensOut = const Value.absent(),
  }) => AiFeedbackData(
    id: id ?? this.id,
    recordingId: recordingId ?? this.recordingId,
    createdAt: createdAt ?? this.createdAt,
    model: model.present ? model.value : this.model,
    promptVersion: promptVersion.present
        ? promptVersion.value
        : this.promptVersion,
    bodyJson: bodyJson ?? this.bodyJson,
    tokensIn: tokensIn.present ? tokensIn.value : this.tokensIn,
    tokensOut: tokensOut.present ? tokensOut.value : this.tokensOut,
  );
  AiFeedbackData copyWithCompanion(AiFeedbackCompanion data) {
    return AiFeedbackData(
      id: data.id.present ? data.id.value : this.id,
      recordingId: data.recordingId.present
          ? data.recordingId.value
          : this.recordingId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      model: data.model.present ? data.model.value : this.model,
      promptVersion: data.promptVersion.present
          ? data.promptVersion.value
          : this.promptVersion,
      bodyJson: data.bodyJson.present ? data.bodyJson.value : this.bodyJson,
      tokensIn: data.tokensIn.present ? data.tokensIn.value : this.tokensIn,
      tokensOut: data.tokensOut.present ? data.tokensOut.value : this.tokensOut,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AiFeedbackData(')
          ..write('id: $id, ')
          ..write('recordingId: $recordingId, ')
          ..write('createdAt: $createdAt, ')
          ..write('model: $model, ')
          ..write('promptVersion: $promptVersion, ')
          ..write('bodyJson: $bodyJson, ')
          ..write('tokensIn: $tokensIn, ')
          ..write('tokensOut: $tokensOut')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    recordingId,
    createdAt,
    model,
    promptVersion,
    bodyJson,
    tokensIn,
    tokensOut,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AiFeedbackData &&
          other.id == this.id &&
          other.recordingId == this.recordingId &&
          other.createdAt == this.createdAt &&
          other.model == this.model &&
          other.promptVersion == this.promptVersion &&
          other.bodyJson == this.bodyJson &&
          other.tokensIn == this.tokensIn &&
          other.tokensOut == this.tokensOut);
}

class AiFeedbackCompanion extends UpdateCompanion<AiFeedbackData> {
  final Value<int> id;
  final Value<String> recordingId;
  final Value<int> createdAt;
  final Value<String?> model;
  final Value<int?> promptVersion;
  final Value<String> bodyJson;
  final Value<int?> tokensIn;
  final Value<int?> tokensOut;
  const AiFeedbackCompanion({
    this.id = const Value.absent(),
    this.recordingId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.model = const Value.absent(),
    this.promptVersion = const Value.absent(),
    this.bodyJson = const Value.absent(),
    this.tokensIn = const Value.absent(),
    this.tokensOut = const Value.absent(),
  });
  AiFeedbackCompanion.insert({
    this.id = const Value.absent(),
    required String recordingId,
    required int createdAt,
    this.model = const Value.absent(),
    this.promptVersion = const Value.absent(),
    required String bodyJson,
    this.tokensIn = const Value.absent(),
    this.tokensOut = const Value.absent(),
  }) : recordingId = Value(recordingId),
       createdAt = Value(createdAt),
       bodyJson = Value(bodyJson);
  static Insertable<AiFeedbackData> custom({
    Expression<int>? id,
    Expression<String>? recordingId,
    Expression<int>? createdAt,
    Expression<String>? model,
    Expression<int>? promptVersion,
    Expression<String>? bodyJson,
    Expression<int>? tokensIn,
    Expression<int>? tokensOut,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recordingId != null) 'recording_id': recordingId,
      if (createdAt != null) 'created_at': createdAt,
      if (model != null) 'model': model,
      if (promptVersion != null) 'prompt_version': promptVersion,
      if (bodyJson != null) 'body_json': bodyJson,
      if (tokensIn != null) 'tokens_in': tokensIn,
      if (tokensOut != null) 'tokens_out': tokensOut,
    });
  }

  AiFeedbackCompanion copyWith({
    Value<int>? id,
    Value<String>? recordingId,
    Value<int>? createdAt,
    Value<String?>? model,
    Value<int?>? promptVersion,
    Value<String>? bodyJson,
    Value<int?>? tokensIn,
    Value<int?>? tokensOut,
  }) {
    return AiFeedbackCompanion(
      id: id ?? this.id,
      recordingId: recordingId ?? this.recordingId,
      createdAt: createdAt ?? this.createdAt,
      model: model ?? this.model,
      promptVersion: promptVersion ?? this.promptVersion,
      bodyJson: bodyJson ?? this.bodyJson,
      tokensIn: tokensIn ?? this.tokensIn,
      tokensOut: tokensOut ?? this.tokensOut,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recordingId.present) {
      map['recording_id'] = Variable<String>(recordingId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (model.present) {
      map['model'] = Variable<String>(model.value);
    }
    if (promptVersion.present) {
      map['prompt_version'] = Variable<int>(promptVersion.value);
    }
    if (bodyJson.present) {
      map['body_json'] = Variable<String>(bodyJson.value);
    }
    if (tokensIn.present) {
      map['tokens_in'] = Variable<int>(tokensIn.value);
    }
    if (tokensOut.present) {
      map['tokens_out'] = Variable<int>(tokensOut.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AiFeedbackCompanion(')
          ..write('id: $id, ')
          ..write('recordingId: $recordingId, ')
          ..write('createdAt: $createdAt, ')
          ..write('model: $model, ')
          ..write('promptVersion: $promptVersion, ')
          ..write('bodyJson: $bodyJson, ')
          ..write('tokensIn: $tokensIn, ')
          ..write('tokensOut: $tokensOut')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final Recordings recordings = Recordings(this);
  late final AnalysisResults analysisResults = AnalysisResults(this);
  late final TipLog tipLog = TipLog(this);
  late final Index idxTipLogRule = Index(
    'idx_tip_log_rule',
    'CREATE INDEX idx_tip_log_rule ON tip_log (rule_id, shown_at DESC)',
  );
  late final DrillSessions drillSessions = DrillSessions(this);
  late final DailyActivity dailyActivity = DailyActivity(this);
  late final Settings settings = Settings(this);
  late final Entitlements entitlements = Entitlements(this);
  late final AiFeedback aiFeedback = AiFeedback(this);
  Selectable<Setting> allSettings() {
    return customSelect(
      'SELECT * FROM settings',
      variables: [],
      readsFrom: {this.settings},
    ).asyncMap(this.settings.mapFromRow);
  }

  Future<int> writeSetting(String? settingKey, String value) {
    return customInsert(
      'INSERT INTO settings ("key", value) VALUES (?1, ?2) ON CONFLICT ("key") DO UPDATE SET value = excluded.value',
      variables: [Variable<String>(settingKey), Variable<String>(value)],
      updates: {this.settings},
    );
  }

  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    recordings,
    analysisResults,
    tipLog,
    idxTipLogRule,
    drillSessions,
    dailyActivity,
    settings,
    entitlements,
    aiFeedback,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recordings',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('analysis_results', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recordings',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('tip_log', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recordings',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('drill_sessions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recordings',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ai_feedback', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $RecordingsCreateCompanionBuilder = RecordingsCompanion Function({
  Value<String?> id,
  required int createdAt,
  required int durationMs,
  required int targetMs,
  required String audioPath,
  required String kind,
  Value<String?> promptId,
  Value<String?> drillId,
  Value<String?> title,
  required String language,
  required int analysisVersion,
  Value<int?> overallScore,
  Value<int?> deletedAt,
  Value<int> rowid,
});
typedef $RecordingsUpdateCompanionBuilder = RecordingsCompanion Function({
  Value<String?> id,
  Value<int> createdAt,
  Value<int> durationMs,
  Value<int> targetMs,
  Value<String> audioPath,
  Value<String> kind,
  Value<String?> promptId,
  Value<String?> drillId,
  Value<String?> title,
  Value<String> language,
  Value<int> analysisVersion,
  Value<int?> overallScore,
  Value<int?> deletedAt,
  Value<int> rowid,
});

final class $RecordingsReferences
    extends BaseReferences<_$AppDatabase, Recordings, Recording> {
  $RecordingsReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<AnalysisResults, List<AnalysisResult>>
  _analysisResultsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.analysisResults,
    aliasName: 'recordings__id__analysis_results__recording_id',
  );

  $AnalysisResultsProcessedTableManager get analysisResultsRefs {
    final manager = $AnalysisResultsTableManager(
      $_db,
      $_db.analysisResults,
    ).filter((f) => f.recordingId.id.sqlEquals($_itemColumn<String>('id')));

    final cache = $_typedResult.readTableOrNull(
      _analysisResultsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<TipLog, List<TipLogData>> _tipLogRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tipLog,
    aliasName: 'recordings__id__tip_log__recording_id',
  );

  $TipLogProcessedTableManager get tipLogRefs {
    final manager = $TipLogTableManager(
      $_db,
      $_db.tipLog,
    ).filter((f) => f.recordingId.id.sqlEquals($_itemColumn<String>('id')));

    final cache = $_typedResult.readTableOrNull(_tipLogRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<DrillSessions, List<DrillSession>>
  _drillSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.drillSessions,
    aliasName: 'recordings__id__drill_sessions__recording_id',
  );

  $DrillSessionsProcessedTableManager get drillSessionsRefs {
    final manager = $DrillSessionsTableManager(
      $_db,
      $_db.drillSessions,
    ).filter((f) => f.recordingId.id.sqlEquals($_itemColumn<String>('id')));

    final cache = $_typedResult.readTableOrNull(_drillSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<AiFeedback, List<AiFeedbackData>>
  _aiFeedbackRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.aiFeedback,
    aliasName: 'recordings__id__ai_feedback__recording_id',
  );

  $AiFeedbackProcessedTableManager get aiFeedbackRefs {
    final manager = $AiFeedbackTableManager(
      $_db,
      $_db.aiFeedback,
    ).filter((f) => f.recordingId.id.sqlEquals($_itemColumn<String>('id')));

    final cache = $_typedResult.readTableOrNull(_aiFeedbackRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $RecordingsFilterComposer extends Composer<_$AppDatabase, Recordings> {
  $RecordingsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetMs => $composableBuilder(
    column: $table.targetMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get promptId => $composableBuilder(
    column: $table.promptId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get drillId => $composableBuilder(
    column: $table.drillId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get analysisVersion => $composableBuilder(
    column: $table.analysisVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get overallScore => $composableBuilder(
    column: $table.overallScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> analysisResultsRefs(
    Expression<bool> Function($AnalysisResultsFilterComposer f) f,
  ) {
    final $AnalysisResultsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.analysisResults,
      getReferencedColumn: (t) => t.recordingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AnalysisResultsFilterComposer(
            $db: $db,
            $table: $db.analysisResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tipLogRefs(
    Expression<bool> Function($TipLogFilterComposer f) f,
  ) {
    final $TipLogFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tipLog,
      getReferencedColumn: (t) => t.recordingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipLogFilterComposer(
            $db: $db,
            $table: $db.tipLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> drillSessionsRefs(
    Expression<bool> Function($DrillSessionsFilterComposer f) f,
  ) {
    final $DrillSessionsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.drillSessions,
      getReferencedColumn: (t) => t.recordingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DrillSessionsFilterComposer(
            $db: $db,
            $table: $db.drillSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> aiFeedbackRefs(
    Expression<bool> Function($AiFeedbackFilterComposer f) f,
  ) {
    final $AiFeedbackFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiFeedback,
      getReferencedColumn: (t) => t.recordingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AiFeedbackFilterComposer(
            $db: $db,
            $table: $db.aiFeedback,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $RecordingsOrderingComposer extends Composer<_$AppDatabase, Recordings> {
  $RecordingsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetMs => $composableBuilder(
    column: $table.targetMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get audioPath => $composableBuilder(
    column: $table.audioPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get promptId => $composableBuilder(
    column: $table.promptId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get drillId => $composableBuilder(
    column: $table.drillId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get analysisVersion => $composableBuilder(
    column: $table.analysisVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get overallScore => $composableBuilder(
    column: $table.overallScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $RecordingsAnnotationComposer
    extends Composer<_$AppDatabase, Recordings> {
  $RecordingsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get targetMs =>
      $composableBuilder(column: $table.targetMs, builder: (column) => column);

  GeneratedColumn<String> get audioPath =>
      $composableBuilder(column: $table.audioPath, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get promptId =>
      $composableBuilder(column: $table.promptId, builder: (column) => column);

  GeneratedColumn<String> get drillId =>
      $composableBuilder(column: $table.drillId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<int> get analysisVersion => $composableBuilder(
    column: $table.analysisVersion,
    builder: (column) => column,
  );

  GeneratedColumn<int> get overallScore => $composableBuilder(
    column: $table.overallScore,
    builder: (column) => column,
  );

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  Expression<T> analysisResultsRefs<T extends Object>(
    Expression<T> Function($AnalysisResultsAnnotationComposer a) f,
  ) {
    final $AnalysisResultsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.analysisResults,
      getReferencedColumn: (t) => t.recordingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AnalysisResultsAnnotationComposer(
            $db: $db,
            $table: $db.analysisResults,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tipLogRefs<T extends Object>(
    Expression<T> Function($TipLogAnnotationComposer a) f,
  ) {
    final $TipLogAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tipLog,
      getReferencedColumn: (t) => t.recordingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $TipLogAnnotationComposer(
            $db: $db,
            $table: $db.tipLog,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> drillSessionsRefs<T extends Object>(
    Expression<T> Function($DrillSessionsAnnotationComposer a) f,
  ) {
    final $DrillSessionsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.drillSessions,
      getReferencedColumn: (t) => t.recordingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $DrillSessionsAnnotationComposer(
            $db: $db,
            $table: $db.drillSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> aiFeedbackRefs<T extends Object>(
    Expression<T> Function($AiFeedbackAnnotationComposer a) f,
  ) {
    final $AiFeedbackAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.aiFeedback,
      getReferencedColumn: (t) => t.recordingId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $AiFeedbackAnnotationComposer(
            $db: $db,
            $table: $db.aiFeedback,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $RecordingsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Recordings,
          Recording,
          $RecordingsFilterComposer,
          $RecordingsOrderingComposer,
          $RecordingsAnnotationComposer,
          $RecordingsCreateCompanionBuilder,
          $RecordingsUpdateCompanionBuilder,
          (Recording, $RecordingsReferences),
          Recording,
          PrefetchHooks Function({
            bool analysisResultsRefs,
            bool tipLogRefs,
            bool drillSessionsRefs,
            bool aiFeedbackRefs,
          })
        > {
  $RecordingsTableManager(_$AppDatabase db, Recordings table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $RecordingsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $RecordingsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $RecordingsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String?> id = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<int> targetMs = const Value.absent(),
                Value<String> audioPath = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> promptId = const Value.absent(),
                Value<String?> drillId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> analysisVersion = const Value.absent(),
                Value<int?> overallScore = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordingsCompanion(
                id: id,
                createdAt: createdAt,
                durationMs: durationMs,
                targetMs: targetMs,
                audioPath: audioPath,
                kind: kind,
                promptId: promptId,
                drillId: drillId,
                title: title,
                language: language,
                analysisVersion: analysisVersion,
                overallScore: overallScore,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String?> id = const Value.absent(),
                required int createdAt,
                required int durationMs,
                required int targetMs,
                required String audioPath,
                required String kind,
                Value<String?> promptId = const Value.absent(),
                Value<String?> drillId = const Value.absent(),
                Value<String?> title = const Value.absent(),
                required String language,
                required int analysisVersion,
                Value<int?> overallScore = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecordingsCompanion.insert(
                id: id,
                createdAt: createdAt,
                durationMs: durationMs,
                targetMs: targetMs,
                audioPath: audioPath,
                kind: kind,
                promptId: promptId,
                drillId: drillId,
                title: title,
                language: language,
                analysisVersion: analysisVersion,
                overallScore: overallScore,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Recordings, Recording>(table),
                  $RecordingsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                analysisResultsRefs = false,
                tipLogRefs = false,
                drillSessionsRefs = false,
                aiFeedbackRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (analysisResultsRefs) db.analysisResults,
                    if (tipLogRefs) db.tipLog,
                    if (drillSessionsRefs) db.drillSessions,
                    if (aiFeedbackRefs) db.aiFeedback,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (analysisResultsRefs)
                        await $_getPrefetchedData<
                          Recording,
                          Recordings,
                          AnalysisResult
                        >(
                          currentTable: table,
                          referencedTable: $RecordingsReferences
                              ._analysisResultsRefsTable(db),
                          managerFromTypedResult: (p0) => $RecordingsReferences(
                            db,
                            table,
                            p0,
                          ).analysisResultsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recordingId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tipLogRefs)
                        await $_getPrefetchedData<
                          Recording,
                          Recordings,
                          TipLogData
                        >(
                          currentTable: table,
                          referencedTable: $RecordingsReferences
                              ._tipLogRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $RecordingsReferences(db, table, p0).tipLogRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recordingId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (drillSessionsRefs)
                        await $_getPrefetchedData<
                          Recording,
                          Recordings,
                          DrillSession
                        >(
                          currentTable: table,
                          referencedTable: $RecordingsReferences
                              ._drillSessionsRefsTable(db),
                          managerFromTypedResult: (p0) => $RecordingsReferences(
                            db,
                            table,
                            p0,
                          ).drillSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recordingId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (aiFeedbackRefs)
                        await $_getPrefetchedData<
                          Recording,
                          Recordings,
                          AiFeedbackData
                        >(
                          currentTable: table,
                          referencedTable: $RecordingsReferences
                              ._aiFeedbackRefsTable(db),
                          managerFromTypedResult: (p0) => $RecordingsReferences(
                            db,
                            table,
                            p0,
                          ).aiFeedbackRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recordingId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $RecordingsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Recordings,
      Recording,
      $RecordingsFilterComposer,
      $RecordingsOrderingComposer,
      $RecordingsAnnotationComposer,
      $RecordingsCreateCompanionBuilder,
      $RecordingsUpdateCompanionBuilder,
      (Recording, $RecordingsReferences),
      Recording,
      PrefetchHooks Function({
        bool analysisResultsRefs,
        bool tipLogRefs,
        bool drillSessionsRefs,
        bool aiFeedbackRefs,
      })
    >;
typedef $AnalysisResultsCreateCompanionBuilder =
    AnalysisResultsCompanion Function({
      Value<String?> recordingId,
      Value<double?> pitchMedianHz,
      Value<double?> pitchRangeSt,
      Value<double?> pitchStdSt,
      Value<double?> pitchMovementStS,
      Value<double?> articulationRate,
      Value<double?> speakingRate,
      Value<double?> paceCv,
      Value<double?> loudnessRangeDb,
      Value<double?> energyTrendDb,
      Value<double?> pausesPerMin,
      Value<double?> pauseRatio,
      Value<int?> longPauseCount,
      Value<int?> meanPauseMs,
      Value<int?> speechMs,
      Value<double?> snrDb,
      Value<double?> clippingPct,
      Value<int?> fillerCount,
      Value<int?> scorePitch,
      Value<int?> scorePace,
      Value<int?> scorePaceVar,
      Value<int?> scorePause,
      Value<int?> scoreVolume,
      Value<int?> scoreEnergy,
      Value<String?> contourJson,
      Value<String?> pausesJson,
      Value<String?> flagsJson,
      Value<int> rowid,
    });
typedef $AnalysisResultsUpdateCompanionBuilder =
    AnalysisResultsCompanion Function({
      Value<String?> recordingId,
      Value<double?> pitchMedianHz,
      Value<double?> pitchRangeSt,
      Value<double?> pitchStdSt,
      Value<double?> pitchMovementStS,
      Value<double?> articulationRate,
      Value<double?> speakingRate,
      Value<double?> paceCv,
      Value<double?> loudnessRangeDb,
      Value<double?> energyTrendDb,
      Value<double?> pausesPerMin,
      Value<double?> pauseRatio,
      Value<int?> longPauseCount,
      Value<int?> meanPauseMs,
      Value<int?> speechMs,
      Value<double?> snrDb,
      Value<double?> clippingPct,
      Value<int?> fillerCount,
      Value<int?> scorePitch,
      Value<int?> scorePace,
      Value<int?> scorePaceVar,
      Value<int?> scorePause,
      Value<int?> scoreVolume,
      Value<int?> scoreEnergy,
      Value<String?> contourJson,
      Value<String?> pausesJson,
      Value<String?> flagsJson,
      Value<int> rowid,
    });

final class $AnalysisResultsReferences
    extends BaseReferences<_$AppDatabase, AnalysisResults, AnalysisResult> {
  $AnalysisResultsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Recordings _recordingIdTable(_$AppDatabase db) => db.recordings
      .createAlias('analysis_results__recording_id__recordings__id');

  $RecordingsProcessedTableManager? get recordingId {
    final $_column = $_itemColumn<String>('recording_id');
    if ($_column == null) return null;
    final manager = $RecordingsTableManager(
      $_db,
      $_db.recordings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $AnalysisResultsFilterComposer
    extends Composer<_$AppDatabase, AnalysisResults> {
  $AnalysisResultsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<double> get pitchMedianHz => $composableBuilder(
    column: $table.pitchMedianHz,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pitchRangeSt => $composableBuilder(
    column: $table.pitchRangeSt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pitchStdSt => $composableBuilder(
    column: $table.pitchStdSt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pitchMovementStS => $composableBuilder(
    column: $table.pitchMovementStS,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get articulationRate => $composableBuilder(
    column: $table.articulationRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speakingRate => $composableBuilder(
    column: $table.speakingRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get paceCv => $composableBuilder(
    column: $table.paceCv,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get loudnessRangeDb => $composableBuilder(
    column: $table.loudnessRangeDb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get energyTrendDb => $composableBuilder(
    column: $table.energyTrendDb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pausesPerMin => $composableBuilder(
    column: $table.pausesPerMin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get pauseRatio => $composableBuilder(
    column: $table.pauseRatio,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get longPauseCount => $composableBuilder(
    column: $table.longPauseCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get meanPauseMs => $composableBuilder(
    column: $table.meanPauseMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get speechMs => $composableBuilder(
    column: $table.speechMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get snrDb => $composableBuilder(
    column: $table.snrDb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get clippingPct => $composableBuilder(
    column: $table.clippingPct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get fillerCount => $composableBuilder(
    column: $table.fillerCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scorePitch => $composableBuilder(
    column: $table.scorePitch,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scorePace => $composableBuilder(
    column: $table.scorePace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scorePaceVar => $composableBuilder(
    column: $table.scorePaceVar,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scorePause => $composableBuilder(
    column: $table.scorePause,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scoreVolume => $composableBuilder(
    column: $table.scoreVolume,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scoreEnergy => $composableBuilder(
    column: $table.scoreEnergy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contourJson => $composableBuilder(
    column: $table.contourJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pausesJson => $composableBuilder(
    column: $table.pausesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flagsJson => $composableBuilder(
    column: $table.flagsJson,
    builder: (column) => ColumnFilters(column),
  );

  $RecordingsFilterComposer get recordingId {
    final $RecordingsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordingId,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RecordingsFilterComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AnalysisResultsOrderingComposer
    extends Composer<_$AppDatabase, AnalysisResults> {
  $AnalysisResultsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<double> get pitchMedianHz => $composableBuilder(
    column: $table.pitchMedianHz,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pitchRangeSt => $composableBuilder(
    column: $table.pitchRangeSt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pitchStdSt => $composableBuilder(
    column: $table.pitchStdSt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pitchMovementStS => $composableBuilder(
    column: $table.pitchMovementStS,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get articulationRate => $composableBuilder(
    column: $table.articulationRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speakingRate => $composableBuilder(
    column: $table.speakingRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get paceCv => $composableBuilder(
    column: $table.paceCv,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get loudnessRangeDb => $composableBuilder(
    column: $table.loudnessRangeDb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get energyTrendDb => $composableBuilder(
    column: $table.energyTrendDb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pausesPerMin => $composableBuilder(
    column: $table.pausesPerMin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get pauseRatio => $composableBuilder(
    column: $table.pauseRatio,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get longPauseCount => $composableBuilder(
    column: $table.longPauseCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get meanPauseMs => $composableBuilder(
    column: $table.meanPauseMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get speechMs => $composableBuilder(
    column: $table.speechMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get snrDb => $composableBuilder(
    column: $table.snrDb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get clippingPct => $composableBuilder(
    column: $table.clippingPct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get fillerCount => $composableBuilder(
    column: $table.fillerCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scorePitch => $composableBuilder(
    column: $table.scorePitch,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scorePace => $composableBuilder(
    column: $table.scorePace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scorePaceVar => $composableBuilder(
    column: $table.scorePaceVar,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scorePause => $composableBuilder(
    column: $table.scorePause,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scoreVolume => $composableBuilder(
    column: $table.scoreVolume,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scoreEnergy => $composableBuilder(
    column: $table.scoreEnergy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contourJson => $composableBuilder(
    column: $table.contourJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pausesJson => $composableBuilder(
    column: $table.pausesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flagsJson => $composableBuilder(
    column: $table.flagsJson,
    builder: (column) => ColumnOrderings(column),
  );

  $RecordingsOrderingComposer get recordingId {
    final $RecordingsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordingId,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RecordingsOrderingComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AnalysisResultsAnnotationComposer
    extends Composer<_$AppDatabase, AnalysisResults> {
  $AnalysisResultsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<double> get pitchMedianHz => $composableBuilder(
    column: $table.pitchMedianHz,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pitchRangeSt => $composableBuilder(
    column: $table.pitchRangeSt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pitchStdSt => $composableBuilder(
    column: $table.pitchStdSt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pitchMovementStS => $composableBuilder(
    column: $table.pitchMovementStS,
    builder: (column) => column,
  );

  GeneratedColumn<double> get articulationRate => $composableBuilder(
    column: $table.articulationRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speakingRate => $composableBuilder(
    column: $table.speakingRate,
    builder: (column) => column,
  );

  GeneratedColumn<double> get paceCv =>
      $composableBuilder(column: $table.paceCv, builder: (column) => column);

  GeneratedColumn<double> get loudnessRangeDb => $composableBuilder(
    column: $table.loudnessRangeDb,
    builder: (column) => column,
  );

  GeneratedColumn<double> get energyTrendDb => $composableBuilder(
    column: $table.energyTrendDb,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pausesPerMin => $composableBuilder(
    column: $table.pausesPerMin,
    builder: (column) => column,
  );

  GeneratedColumn<double> get pauseRatio => $composableBuilder(
    column: $table.pauseRatio,
    builder: (column) => column,
  );

  GeneratedColumn<int> get longPauseCount => $composableBuilder(
    column: $table.longPauseCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get meanPauseMs => $composableBuilder(
    column: $table.meanPauseMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get speechMs =>
      $composableBuilder(column: $table.speechMs, builder: (column) => column);

  GeneratedColumn<double> get snrDb =>
      $composableBuilder(column: $table.snrDb, builder: (column) => column);

  GeneratedColumn<double> get clippingPct => $composableBuilder(
    column: $table.clippingPct,
    builder: (column) => column,
  );

  GeneratedColumn<int> get fillerCount => $composableBuilder(
    column: $table.fillerCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scorePitch => $composableBuilder(
    column: $table.scorePitch,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scorePace =>
      $composableBuilder(column: $table.scorePace, builder: (column) => column);

  GeneratedColumn<int> get scorePaceVar => $composableBuilder(
    column: $table.scorePaceVar,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scorePause => $composableBuilder(
    column: $table.scorePause,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scoreVolume => $composableBuilder(
    column: $table.scoreVolume,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scoreEnergy => $composableBuilder(
    column: $table.scoreEnergy,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contourJson => $composableBuilder(
    column: $table.contourJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pausesJson => $composableBuilder(
    column: $table.pausesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get flagsJson =>
      $composableBuilder(column: $table.flagsJson, builder: (column) => column);

  $RecordingsAnnotationComposer get recordingId {
    final $RecordingsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordingId,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RecordingsAnnotationComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AnalysisResultsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          AnalysisResults,
          AnalysisResult,
          $AnalysisResultsFilterComposer,
          $AnalysisResultsOrderingComposer,
          $AnalysisResultsAnnotationComposer,
          $AnalysisResultsCreateCompanionBuilder,
          $AnalysisResultsUpdateCompanionBuilder,
          (AnalysisResult, $AnalysisResultsReferences),
          AnalysisResult,
          PrefetchHooks Function({bool recordingId})
        > {
  $AnalysisResultsTableManager(_$AppDatabase db, AnalysisResults table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AnalysisResultsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AnalysisResultsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AnalysisResultsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String?> recordingId = const Value.absent(),
                Value<double?> pitchMedianHz = const Value.absent(),
                Value<double?> pitchRangeSt = const Value.absent(),
                Value<double?> pitchStdSt = const Value.absent(),
                Value<double?> pitchMovementStS = const Value.absent(),
                Value<double?> articulationRate = const Value.absent(),
                Value<double?> speakingRate = const Value.absent(),
                Value<double?> paceCv = const Value.absent(),
                Value<double?> loudnessRangeDb = const Value.absent(),
                Value<double?> energyTrendDb = const Value.absent(),
                Value<double?> pausesPerMin = const Value.absent(),
                Value<double?> pauseRatio = const Value.absent(),
                Value<int?> longPauseCount = const Value.absent(),
                Value<int?> meanPauseMs = const Value.absent(),
                Value<int?> speechMs = const Value.absent(),
                Value<double?> snrDb = const Value.absent(),
                Value<double?> clippingPct = const Value.absent(),
                Value<int?> fillerCount = const Value.absent(),
                Value<int?> scorePitch = const Value.absent(),
                Value<int?> scorePace = const Value.absent(),
                Value<int?> scorePaceVar = const Value.absent(),
                Value<int?> scorePause = const Value.absent(),
                Value<int?> scoreVolume = const Value.absent(),
                Value<int?> scoreEnergy = const Value.absent(),
                Value<String?> contourJson = const Value.absent(),
                Value<String?> pausesJson = const Value.absent(),
                Value<String?> flagsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisResultsCompanion(
                recordingId: recordingId,
                pitchMedianHz: pitchMedianHz,
                pitchRangeSt: pitchRangeSt,
                pitchStdSt: pitchStdSt,
                pitchMovementStS: pitchMovementStS,
                articulationRate: articulationRate,
                speakingRate: speakingRate,
                paceCv: paceCv,
                loudnessRangeDb: loudnessRangeDb,
                energyTrendDb: energyTrendDb,
                pausesPerMin: pausesPerMin,
                pauseRatio: pauseRatio,
                longPauseCount: longPauseCount,
                meanPauseMs: meanPauseMs,
                speechMs: speechMs,
                snrDb: snrDb,
                clippingPct: clippingPct,
                fillerCount: fillerCount,
                scorePitch: scorePitch,
                scorePace: scorePace,
                scorePaceVar: scorePaceVar,
                scorePause: scorePause,
                scoreVolume: scoreVolume,
                scoreEnergy: scoreEnergy,
                contourJson: contourJson,
                pausesJson: pausesJson,
                flagsJson: flagsJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String?> recordingId = const Value.absent(),
                Value<double?> pitchMedianHz = const Value.absent(),
                Value<double?> pitchRangeSt = const Value.absent(),
                Value<double?> pitchStdSt = const Value.absent(),
                Value<double?> pitchMovementStS = const Value.absent(),
                Value<double?> articulationRate = const Value.absent(),
                Value<double?> speakingRate = const Value.absent(),
                Value<double?> paceCv = const Value.absent(),
                Value<double?> loudnessRangeDb = const Value.absent(),
                Value<double?> energyTrendDb = const Value.absent(),
                Value<double?> pausesPerMin = const Value.absent(),
                Value<double?> pauseRatio = const Value.absent(),
                Value<int?> longPauseCount = const Value.absent(),
                Value<int?> meanPauseMs = const Value.absent(),
                Value<int?> speechMs = const Value.absent(),
                Value<double?> snrDb = const Value.absent(),
                Value<double?> clippingPct = const Value.absent(),
                Value<int?> fillerCount = const Value.absent(),
                Value<int?> scorePitch = const Value.absent(),
                Value<int?> scorePace = const Value.absent(),
                Value<int?> scorePaceVar = const Value.absent(),
                Value<int?> scorePause = const Value.absent(),
                Value<int?> scoreVolume = const Value.absent(),
                Value<int?> scoreEnergy = const Value.absent(),
                Value<String?> contourJson = const Value.absent(),
                Value<String?> pausesJson = const Value.absent(),
                Value<String?> flagsJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AnalysisResultsCompanion.insert(
                recordingId: recordingId,
                pitchMedianHz: pitchMedianHz,
                pitchRangeSt: pitchRangeSt,
                pitchStdSt: pitchStdSt,
                pitchMovementStS: pitchMovementStS,
                articulationRate: articulationRate,
                speakingRate: speakingRate,
                paceCv: paceCv,
                loudnessRangeDb: loudnessRangeDb,
                energyTrendDb: energyTrendDb,
                pausesPerMin: pausesPerMin,
                pauseRatio: pauseRatio,
                longPauseCount: longPauseCount,
                meanPauseMs: meanPauseMs,
                speechMs: speechMs,
                snrDb: snrDb,
                clippingPct: clippingPct,
                fillerCount: fillerCount,
                scorePitch: scorePitch,
                scorePace: scorePace,
                scorePaceVar: scorePaceVar,
                scorePause: scorePause,
                scoreVolume: scoreVolume,
                scoreEnergy: scoreEnergy,
                contourJson: contourJson,
                pausesJson: pausesJson,
                flagsJson: flagsJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<AnalysisResults, AnalysisResult>(table),
                  $AnalysisResultsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recordingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recordingId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recordingId,
                        referencedTable: $AnalysisResultsReferences
                            ._recordingIdTable(db),
                        referencedColumn: $AnalysisResultsReferences
                            ._recordingIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $AnalysisResultsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      AnalysisResults,
      AnalysisResult,
      $AnalysisResultsFilterComposer,
      $AnalysisResultsOrderingComposer,
      $AnalysisResultsAnnotationComposer,
      $AnalysisResultsCreateCompanionBuilder,
      $AnalysisResultsUpdateCompanionBuilder,
      (AnalysisResult, $AnalysisResultsReferences),
      AnalysisResult,
      PrefetchHooks Function({bool recordingId})
    >;
typedef $TipLogCreateCompanionBuilder = TipLogCompanion Function({
  Value<int> id,
  required String recordingId,
  required String ruleId,
  required String variantId,
  required String kind,
  required int shownAt,
  Value<int?> helpful,
});
typedef $TipLogUpdateCompanionBuilder = TipLogCompanion Function({
  Value<int> id,
  Value<String> recordingId,
  Value<String> ruleId,
  Value<String> variantId,
  Value<String> kind,
  Value<int> shownAt,
  Value<int?> helpful,
});

final class $TipLogReferences
    extends BaseReferences<_$AppDatabase, TipLog, TipLogData> {
  $TipLogReferences(super.$_db, super.$_table, super.$_typedResult);

  static Recordings _recordingIdTable(_$AppDatabase db) =>
      db.recordings.createAlias('tip_log__recording_id__recordings__id');

  $RecordingsProcessedTableManager get recordingId {
    final $_column = $_itemColumn<String>('recording_id')!;

    final manager = $RecordingsTableManager(
      $_db,
      $_db.recordings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $TipLogFilterComposer extends Composer<_$AppDatabase, TipLog> {
  $TipLogFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get variantId => $composableBuilder(
    column: $table.variantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shownAt => $composableBuilder(
    column: $table.shownAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get helpful => $composableBuilder(
    column: $table.helpful,
    builder: (column) => ColumnFilters(column),
  );

  $RecordingsFilterComposer get recordingId {
    final $RecordingsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordingId,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RecordingsFilterComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $TipLogOrderingComposer extends Composer<_$AppDatabase, TipLog> {
  $TipLogOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleId => $composableBuilder(
    column: $table.ruleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get variantId => $composableBuilder(
    column: $table.variantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shownAt => $composableBuilder(
    column: $table.shownAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get helpful => $composableBuilder(
    column: $table.helpful,
    builder: (column) => ColumnOrderings(column),
  );

  $RecordingsOrderingComposer get recordingId {
    final $RecordingsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordingId,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RecordingsOrderingComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $TipLogAnnotationComposer extends Composer<_$AppDatabase, TipLog> {
  $TipLogAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ruleId =>
      $composableBuilder(column: $table.ruleId, builder: (column) => column);

  GeneratedColumn<String> get variantId =>
      $composableBuilder(column: $table.variantId, builder: (column) => column);

  GeneratedColumn<String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<int> get shownAt =>
      $composableBuilder(column: $table.shownAt, builder: (column) => column);

  GeneratedColumn<int> get helpful =>
      $composableBuilder(column: $table.helpful, builder: (column) => column);

  $RecordingsAnnotationComposer get recordingId {
    final $RecordingsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordingId,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RecordingsAnnotationComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $TipLogTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          TipLog,
          TipLogData,
          $TipLogFilterComposer,
          $TipLogOrderingComposer,
          $TipLogAnnotationComposer,
          $TipLogCreateCompanionBuilder,
          $TipLogUpdateCompanionBuilder,
          (TipLogData, $TipLogReferences),
          TipLogData,
          PrefetchHooks Function({bool recordingId})
        > {
  $TipLogTableManager(_$AppDatabase db, TipLog table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $TipLogFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $TipLogOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $TipLogAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> recordingId = const Value.absent(),
                Value<String> ruleId = const Value.absent(),
                Value<String> variantId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<int> shownAt = const Value.absent(),
                Value<int?> helpful = const Value.absent(),
              }) => TipLogCompanion(
                id: id,
                recordingId: recordingId,
                ruleId: ruleId,
                variantId: variantId,
                kind: kind,
                shownAt: shownAt,
                helpful: helpful,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String recordingId,
                required String ruleId,
                required String variantId,
                required String kind,
                required int shownAt,
                Value<int?> helpful = const Value.absent(),
              }) => TipLogCompanion.insert(
                id: id,
                recordingId: recordingId,
                ruleId: ruleId,
                variantId: variantId,
                kind: kind,
                shownAt: shownAt,
                helpful: helpful,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<TipLog, TipLogData>(table),
                  $TipLogReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recordingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recordingId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recordingId,
                        referencedTable: $TipLogReferences._recordingIdTable(
                          db,
                        ),
                        referencedColumn: $TipLogReferences
                            ._recordingIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $TipLogProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      TipLog,
      TipLogData,
      $TipLogFilterComposer,
      $TipLogOrderingComposer,
      $TipLogAnnotationComposer,
      $TipLogCreateCompanionBuilder,
      $TipLogUpdateCompanionBuilder,
      (TipLogData, $TipLogReferences),
      TipLogData,
      PrefetchHooks Function({bool recordingId})
    >;
typedef $DrillSessionsCreateCompanionBuilder = DrillSessionsCompanion Function({
  Value<String?> id,
  required String drillId,
  required int startedAt,
  Value<int?> completedAt,
  Value<String?> recordingId,
  Value<int?> passed,
  Value<int> rowid,
});
typedef $DrillSessionsUpdateCompanionBuilder = DrillSessionsCompanion Function({
  Value<String?> id,
  Value<String> drillId,
  Value<int> startedAt,
  Value<int?> completedAt,
  Value<String?> recordingId,
  Value<int?> passed,
  Value<int> rowid,
});

final class $DrillSessionsReferences
    extends BaseReferences<_$AppDatabase, DrillSessions, DrillSession> {
  $DrillSessionsReferences(super.$_db, super.$_table, super.$_typedResult);

  static Recordings _recordingIdTable(_$AppDatabase db) =>
      db.recordings.createAlias('drill_sessions__recording_id__recordings__id');

  $RecordingsProcessedTableManager? get recordingId {
    final $_column = $_itemColumn<String>('recording_id');
    if ($_column == null) return null;
    final manager = $RecordingsTableManager(
      $_db,
      $_db.recordings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $DrillSessionsFilterComposer
    extends Composer<_$AppDatabase, DrillSessions> {
  $DrillSessionsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get drillId => $composableBuilder(
    column: $table.drillId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get passed => $composableBuilder(
    column: $table.passed,
    builder: (column) => ColumnFilters(column),
  );

  $RecordingsFilterComposer get recordingId {
    final $RecordingsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordingId,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RecordingsFilterComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DrillSessionsOrderingComposer
    extends Composer<_$AppDatabase, DrillSessions> {
  $DrillSessionsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get drillId => $composableBuilder(
    column: $table.drillId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get passed => $composableBuilder(
    column: $table.passed,
    builder: (column) => ColumnOrderings(column),
  );

  $RecordingsOrderingComposer get recordingId {
    final $RecordingsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordingId,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RecordingsOrderingComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DrillSessionsAnnotationComposer
    extends Composer<_$AppDatabase, DrillSessions> {
  $DrillSessionsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get drillId =>
      $composableBuilder(column: $table.drillId, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get passed =>
      $composableBuilder(column: $table.passed, builder: (column) => column);

  $RecordingsAnnotationComposer get recordingId {
    final $RecordingsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordingId,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RecordingsAnnotationComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $DrillSessionsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          DrillSessions,
          DrillSession,
          $DrillSessionsFilterComposer,
          $DrillSessionsOrderingComposer,
          $DrillSessionsAnnotationComposer,
          $DrillSessionsCreateCompanionBuilder,
          $DrillSessionsUpdateCompanionBuilder,
          (DrillSession, $DrillSessionsReferences),
          DrillSession,
          PrefetchHooks Function({bool recordingId})
        > {
  $DrillSessionsTableManager(_$AppDatabase db, DrillSessions table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DrillSessionsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DrillSessionsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DrillSessionsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String?> id = const Value.absent(),
                Value<String> drillId = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int?> completedAt = const Value.absent(),
                Value<String?> recordingId = const Value.absent(),
                Value<int?> passed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DrillSessionsCompanion(
                id: id,
                drillId: drillId,
                startedAt: startedAt,
                completedAt: completedAt,
                recordingId: recordingId,
                passed: passed,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String?> id = const Value.absent(),
                required String drillId,
                required int startedAt,
                Value<int?> completedAt = const Value.absent(),
                Value<String?> recordingId = const Value.absent(),
                Value<int?> passed = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DrillSessionsCompanion.insert(
                id: id,
                drillId: drillId,
                startedAt: startedAt,
                completedAt: completedAt,
                recordingId: recordingId,
                passed: passed,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<DrillSessions, DrillSession>(table),
                  $DrillSessionsReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recordingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recordingId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recordingId,
                        referencedTable: $DrillSessionsReferences
                            ._recordingIdTable(db),
                        referencedColumn: $DrillSessionsReferences
                            ._recordingIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $DrillSessionsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      DrillSessions,
      DrillSession,
      $DrillSessionsFilterComposer,
      $DrillSessionsOrderingComposer,
      $DrillSessionsAnnotationComposer,
      $DrillSessionsCreateCompanionBuilder,
      $DrillSessionsUpdateCompanionBuilder,
      (DrillSession, $DrillSessionsReferences),
      DrillSession,
      PrefetchHooks Function({bool recordingId})
    >;
typedef $DailyActivityCreateCompanionBuilder = DailyActivityCompanion Function({
  Value<String?> day,
  Value<int> practiceMs,
  Value<int> recordings,
  Value<int> drills,
  Value<int> rowid,
});
typedef $DailyActivityUpdateCompanionBuilder = DailyActivityCompanion Function({
  Value<String?> day,
  Value<int> practiceMs,
  Value<int> recordings,
  Value<int> drills,
  Value<int> rowid,
});

class $DailyActivityFilterComposer
    extends Composer<_$AppDatabase, DailyActivity> {
  $DailyActivityFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get practiceMs => $composableBuilder(
    column: $table.practiceMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recordings => $composableBuilder(
    column: $table.recordings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get drills => $composableBuilder(
    column: $table.drills,
    builder: (column) => ColumnFilters(column),
  );
}

class $DailyActivityOrderingComposer
    extends Composer<_$AppDatabase, DailyActivity> {
  $DailyActivityOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get practiceMs => $composableBuilder(
    column: $table.practiceMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recordings => $composableBuilder(
    column: $table.recordings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get drills => $composableBuilder(
    column: $table.drills,
    builder: (column) => ColumnOrderings(column),
  );
}

class $DailyActivityAnnotationComposer
    extends Composer<_$AppDatabase, DailyActivity> {
  $DailyActivityAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<int> get practiceMs => $composableBuilder(
    column: $table.practiceMs,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recordings => $composableBuilder(
    column: $table.recordings,
    builder: (column) => column,
  );

  GeneratedColumn<int> get drills =>
      $composableBuilder(column: $table.drills, builder: (column) => column);
}

class $DailyActivityTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          DailyActivity,
          DailyActivityData,
          $DailyActivityFilterComposer,
          $DailyActivityOrderingComposer,
          $DailyActivityAnnotationComposer,
          $DailyActivityCreateCompanionBuilder,
          $DailyActivityUpdateCompanionBuilder,
          (
            DailyActivityData,
            BaseReferences<_$AppDatabase, DailyActivity, DailyActivityData>,
          ),
          DailyActivityData,
          PrefetchHooks Function()
        > {
  $DailyActivityTableManager(_$AppDatabase db, DailyActivity table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $DailyActivityFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $DailyActivityOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $DailyActivityAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String?> day = const Value.absent(),
                Value<int> practiceMs = const Value.absent(),
                Value<int> recordings = const Value.absent(),
                Value<int> drills = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyActivityCompanion(
                day: day,
                practiceMs: practiceMs,
                recordings: recordings,
                drills: drills,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String?> day = const Value.absent(),
                Value<int> practiceMs = const Value.absent(),
                Value<int> recordings = const Value.absent(),
                Value<int> drills = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyActivityCompanion.insert(
                day: day,
                practiceMs: practiceMs,
                recordings: recordings,
                drills: drills,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<DailyActivity, DailyActivityData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    DailyActivity,
                    DailyActivityData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $DailyActivityProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      DailyActivity,
      DailyActivityData,
      $DailyActivityFilterComposer,
      $DailyActivityOrderingComposer,
      $DailyActivityAnnotationComposer,
      $DailyActivityCreateCompanionBuilder,
      $DailyActivityUpdateCompanionBuilder,
      (
        DailyActivityData,
        BaseReferences<_$AppDatabase, DailyActivity, DailyActivityData>,
      ),
      DailyActivityData,
      PrefetchHooks Function()
    >;
typedef $SettingsCreateCompanionBuilder = SettingsCompanion Function({
  Value<String?> key,
  required String value,
  Value<int> rowid,
});
typedef $SettingsUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String?> key,
  Value<String> value,
  Value<int> rowid,
});

class $SettingsFilterComposer extends Composer<_$AppDatabase, Settings> {
  $SettingsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $SettingsOrderingComposer extends Composer<_$AppDatabase, Settings> {
  $SettingsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $SettingsAnnotationComposer extends Composer<_$AppDatabase, Settings> {
  $SettingsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $SettingsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Settings,
          Setting,
          $SettingsFilterComposer,
          $SettingsOrderingComposer,
          $SettingsAnnotationComposer,
          $SettingsCreateCompanionBuilder,
          $SettingsUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, Settings, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $SettingsTableManager(_$AppDatabase db, Settings table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $SettingsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $SettingsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $SettingsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String?> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            Value<String?> key = const Value.absent(),
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => SettingsCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Settings, Setting>(table),
                  BaseReferences<_$AppDatabase, Settings, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $SettingsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Settings,
      Setting,
      $SettingsFilterComposer,
      $SettingsOrderingComposer,
      $SettingsAnnotationComposer,
      $SettingsCreateCompanionBuilder,
      $SettingsUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, Settings, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $EntitlementsCreateCompanionBuilder = EntitlementsCompanion Function({
  Value<int> id,
  Value<String> tier,
  Value<int?> expiresAt,
  Value<String?> source,
  Value<String?> token,
  required int updatedAt,
});
typedef $EntitlementsUpdateCompanionBuilder = EntitlementsCompanion Function({
  Value<int> id,
  Value<String> tier,
  Value<int?> expiresAt,
  Value<String?> source,
  Value<String?> token,
  Value<int> updatedAt,
});

class $EntitlementsFilterComposer
    extends Composer<_$AppDatabase, Entitlements> {
  $EntitlementsFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $EntitlementsOrderingComposer
    extends Composer<_$AppDatabase, Entitlements> {
  $EntitlementsOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tier => $composableBuilder(
    column: $table.tier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get expiresAt => $composableBuilder(
    column: $table.expiresAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $EntitlementsAnnotationComposer
    extends Composer<_$AppDatabase, Entitlements> {
  $EntitlementsAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get tier =>
      $composableBuilder(column: $table.tier, builder: (column) => column);

  GeneratedColumn<int> get expiresAt =>
      $composableBuilder(column: $table.expiresAt, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $EntitlementsTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          Entitlements,
          Entitlement,
          $EntitlementsFilterComposer,
          $EntitlementsOrderingComposer,
          $EntitlementsAnnotationComposer,
          $EntitlementsCreateCompanionBuilder,
          $EntitlementsUpdateCompanionBuilder,
          (
            Entitlement,
            BaseReferences<_$AppDatabase, Entitlements, Entitlement>,
          ),
          Entitlement,
          PrefetchHooks Function()
        > {
  $EntitlementsTableManager(_$AppDatabase db, Entitlements table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $EntitlementsFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $EntitlementsOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $EntitlementsAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tier = const Value.absent(),
                Value<int?> expiresAt = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> token = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => EntitlementsCompanion(
                id: id,
                tier: tier,
                expiresAt: expiresAt,
                source: source,
                token: token,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> tier = const Value.absent(),
                Value<int?> expiresAt = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String?> token = const Value.absent(),
                required int updatedAt,
              }) => EntitlementsCompanion.insert(
                id: id,
                tier: tier,
                expiresAt: expiresAt,
                source: source,
                token: token,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<Entitlements, Entitlement>(table),
                  BaseReferences<_$AppDatabase, Entitlements, Entitlement>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $EntitlementsProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      Entitlements,
      Entitlement,
      $EntitlementsFilterComposer,
      $EntitlementsOrderingComposer,
      $EntitlementsAnnotationComposer,
      $EntitlementsCreateCompanionBuilder,
      $EntitlementsUpdateCompanionBuilder,
      (Entitlement, BaseReferences<_$AppDatabase, Entitlements, Entitlement>),
      Entitlement,
      PrefetchHooks Function()
    >;
typedef $AiFeedbackCreateCompanionBuilder = AiFeedbackCompanion Function({
  Value<int> id,
  required String recordingId,
  required int createdAt,
  Value<String?> model,
  Value<int?> promptVersion,
  required String bodyJson,
  Value<int?> tokensIn,
  Value<int?> tokensOut,
});
typedef $AiFeedbackUpdateCompanionBuilder = AiFeedbackCompanion Function({
  Value<int> id,
  Value<String> recordingId,
  Value<int> createdAt,
  Value<String?> model,
  Value<int?> promptVersion,
  Value<String> bodyJson,
  Value<int?> tokensIn,
  Value<int?> tokensOut,
});

final class $AiFeedbackReferences
    extends BaseReferences<_$AppDatabase, AiFeedback, AiFeedbackData> {
  $AiFeedbackReferences(super.$_db, super.$_table, super.$_typedResult);

  static Recordings _recordingIdTable(_$AppDatabase db) =>
      db.recordings.createAlias('ai_feedback__recording_id__recordings__id');

  $RecordingsProcessedTableManager get recordingId {
    final $_column = $_itemColumn<String>('recording_id')!;

    final manager = $RecordingsTableManager(
      $_db,
      $_db.recordings,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recordingIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $AiFeedbackFilterComposer extends Composer<_$AppDatabase, AiFeedback> {
  $AiFeedbackFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get promptVersion => $composableBuilder(
    column: $table.promptVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyJson => $composableBuilder(
    column: $table.bodyJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tokensIn => $composableBuilder(
    column: $table.tokensIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tokensOut => $composableBuilder(
    column: $table.tokensOut,
    builder: (column) => ColumnFilters(column),
  );

  $RecordingsFilterComposer get recordingId {
    final $RecordingsFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordingId,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RecordingsFilterComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AiFeedbackOrderingComposer extends Composer<_$AppDatabase, AiFeedback> {
  $AiFeedbackOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get model => $composableBuilder(
    column: $table.model,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get promptVersion => $composableBuilder(
    column: $table.promptVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyJson => $composableBuilder(
    column: $table.bodyJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tokensIn => $composableBuilder(
    column: $table.tokensIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tokensOut => $composableBuilder(
    column: $table.tokensOut,
    builder: (column) => ColumnOrderings(column),
  );

  $RecordingsOrderingComposer get recordingId {
    final $RecordingsOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordingId,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RecordingsOrderingComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AiFeedbackAnnotationComposer
    extends Composer<_$AppDatabase, AiFeedback> {
  $AiFeedbackAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get model =>
      $composableBuilder(column: $table.model, builder: (column) => column);

  GeneratedColumn<int> get promptVersion => $composableBuilder(
    column: $table.promptVersion,
    builder: (column) => column,
  );

  GeneratedColumn<String> get bodyJson =>
      $composableBuilder(column: $table.bodyJson, builder: (column) => column);

  GeneratedColumn<int> get tokensIn =>
      $composableBuilder(column: $table.tokensIn, builder: (column) => column);

  GeneratedColumn<int> get tokensOut =>
      $composableBuilder(column: $table.tokensOut, builder: (column) => column);

  $RecordingsAnnotationComposer get recordingId {
    final $RecordingsAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recordingId,
      referencedTable: $db.recordings,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $RecordingsAnnotationComposer(
            $db: $db,
            $table: $db.recordings,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $AiFeedbackTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          AiFeedback,
          AiFeedbackData,
          $AiFeedbackFilterComposer,
          $AiFeedbackOrderingComposer,
          $AiFeedbackAnnotationComposer,
          $AiFeedbackCreateCompanionBuilder,
          $AiFeedbackUpdateCompanionBuilder,
          (AiFeedbackData, $AiFeedbackReferences),
          AiFeedbackData,
          PrefetchHooks Function({bool recordingId})
        > {
  $AiFeedbackTableManager(_$AppDatabase db, AiFeedback table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $AiFeedbackFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $AiFeedbackOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $AiFeedbackAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> recordingId = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<String?> model = const Value.absent(),
                Value<int?> promptVersion = const Value.absent(),
                Value<String> bodyJson = const Value.absent(),
                Value<int?> tokensIn = const Value.absent(),
                Value<int?> tokensOut = const Value.absent(),
              }) => AiFeedbackCompanion(
                id: id,
                recordingId: recordingId,
                createdAt: createdAt,
                model: model,
                promptVersion: promptVersion,
                bodyJson: bodyJson,
                tokensIn: tokensIn,
                tokensOut: tokensOut,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String recordingId,
                required int createdAt,
                Value<String?> model = const Value.absent(),
                Value<int?> promptVersion = const Value.absent(),
                required String bodyJson,
                Value<int?> tokensIn = const Value.absent(),
                Value<int?> tokensOut = const Value.absent(),
              }) => AiFeedbackCompanion.insert(
                id: id,
                recordingId: recordingId,
                createdAt: createdAt,
                model: model,
                promptVersion: promptVersion,
                bodyJson: bodyJson,
                tokensIn: tokensIn,
                tokensOut: tokensOut,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<AiFeedback, AiFeedbackData>(table),
                  $AiFeedbackReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recordingId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recordingId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.recordingId,
                        referencedTable: $AiFeedbackReferences
                            ._recordingIdTable(db),
                        referencedColumn: $AiFeedbackReferences
                            ._recordingIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $AiFeedbackProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      AiFeedback,
      AiFeedbackData,
      $AiFeedbackFilterComposer,
      $AiFeedbackOrderingComposer,
      $AiFeedbackAnnotationComposer,
      $AiFeedbackCreateCompanionBuilder,
      $AiFeedbackUpdateCompanionBuilder,
      (AiFeedbackData, $AiFeedbackReferences),
      AiFeedbackData,
      PrefetchHooks Function({bool recordingId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $RecordingsTableManager get recordings =>
      $RecordingsTableManager(_db, _db.recordings);
  $AnalysisResultsTableManager get analysisResults =>
      $AnalysisResultsTableManager(_db, _db.analysisResults);
  $TipLogTableManager get tipLog => $TipLogTableManager(_db, _db.tipLog);
  $DrillSessionsTableManager get drillSessions =>
      $DrillSessionsTableManager(_db, _db.drillSessions);
  $DailyActivityTableManager get dailyActivity =>
      $DailyActivityTableManager(_db, _db.dailyActivity);
  $SettingsTableManager get settings =>
      $SettingsTableManager(_db, _db.settings);
  $EntitlementsTableManager get entitlements =>
      $EntitlementsTableManager(_db, _db.entitlements);
  $AiFeedbackTableManager get aiFeedback =>
      $AiFeedbackTableManager(_db, _db.aiFeedback);
}
