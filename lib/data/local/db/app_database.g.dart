// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AccountsTable extends Accounts
    with TableInfo<$AccountsTable, AccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _passwordHashMeta = const VerificationMeta(
    'passwordHash',
  );
  @override
  late final GeneratedColumn<String> passwordHash = GeneratedColumn<String>(
    'password_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _saltMeta = const VerificationMeta('salt');
  @override
  late final GeneratedColumn<String> salt = GeneratedColumn<String>(
    'salt',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAnonymousMeta = const VerificationMeta(
    'isAnonymous',
  );
  @override
  late final GeneratedColumn<bool> isAnonymous = GeneratedColumn<bool>(
    'is_anonymous',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_anonymous" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    uid,
    email,
    passwordHash,
    salt,
    isAnonymous,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('password_hash')) {
      context.handle(
        _passwordHashMeta,
        passwordHash.isAcceptableOrUnknown(
          data['password_hash']!,
          _passwordHashMeta,
        ),
      );
    }
    if (data.containsKey('salt')) {
      context.handle(
        _saltMeta,
        salt.isAcceptableOrUnknown(data['salt']!, _saltMeta),
      );
    }
    if (data.containsKey('is_anonymous')) {
      context.handle(
        _isAnonymousMeta,
        isAnonymous.isAcceptableOrUnknown(
          data['is_anonymous']!,
          _isAnonymousMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uid};
  @override
  AccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountRow(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      passwordHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}password_hash'],
      ),
      salt: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}salt'],
      ),
      isAnonymous: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_anonymous'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class AccountRow extends DataClass implements Insertable<AccountRow> {
  final String uid;
  final String? email;
  final String? passwordHash;
  final String? salt;
  final bool isAnonymous;
  final int createdAt;
  const AccountRow({
    required this.uid,
    this.email,
    this.passwordHash,
    this.salt,
    required this.isAnonymous,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    if (!nullToAbsent || passwordHash != null) {
      map['password_hash'] = Variable<String>(passwordHash);
    }
    if (!nullToAbsent || salt != null) {
      map['salt'] = Variable<String>(salt);
    }
    map['is_anonymous'] = Variable<bool>(isAnonymous);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      uid: Value(uid),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      passwordHash: passwordHash == null && nullToAbsent
          ? const Value.absent()
          : Value(passwordHash),
      salt: salt == null && nullToAbsent ? const Value.absent() : Value(salt),
      isAnonymous: Value(isAnonymous),
      createdAt: Value(createdAt),
    );
  }

  factory AccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountRow(
      uid: serializer.fromJson<String>(json['uid']),
      email: serializer.fromJson<String?>(json['email']),
      passwordHash: serializer.fromJson<String?>(json['passwordHash']),
      salt: serializer.fromJson<String?>(json['salt']),
      isAnonymous: serializer.fromJson<bool>(json['isAnonymous']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'email': serializer.toJson<String?>(email),
      'passwordHash': serializer.toJson<String?>(passwordHash),
      'salt': serializer.toJson<String?>(salt),
      'isAnonymous': serializer.toJson<bool>(isAnonymous),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  AccountRow copyWith({
    String? uid,
    Value<String?> email = const Value.absent(),
    Value<String?> passwordHash = const Value.absent(),
    Value<String?> salt = const Value.absent(),
    bool? isAnonymous,
    int? createdAt,
  }) => AccountRow(
    uid: uid ?? this.uid,
    email: email.present ? email.value : this.email,
    passwordHash: passwordHash.present ? passwordHash.value : this.passwordHash,
    salt: salt.present ? salt.value : this.salt,
    isAnonymous: isAnonymous ?? this.isAnonymous,
    createdAt: createdAt ?? this.createdAt,
  );
  AccountRow copyWithCompanion(AccountsCompanion data) {
    return AccountRow(
      uid: data.uid.present ? data.uid.value : this.uid,
      email: data.email.present ? data.email.value : this.email,
      passwordHash: data.passwordHash.present
          ? data.passwordHash.value
          : this.passwordHash,
      salt: data.salt.present ? data.salt.value : this.salt,
      isAnonymous: data.isAnonymous.present
          ? data.isAnonymous.value
          : this.isAnonymous,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountRow(')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('salt: $salt, ')
          ..write('isAnonymous: $isAnonymous, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(uid, email, passwordHash, salt, isAnonymous, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountRow &&
          other.uid == this.uid &&
          other.email == this.email &&
          other.passwordHash == this.passwordHash &&
          other.salt == this.salt &&
          other.isAnonymous == this.isAnonymous &&
          other.createdAt == this.createdAt);
}

class AccountsCompanion extends UpdateCompanion<AccountRow> {
  final Value<String> uid;
  final Value<String?> email;
  final Value<String?> passwordHash;
  final Value<String?> salt;
  final Value<bool> isAnonymous;
  final Value<int> createdAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.uid = const Value.absent(),
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.salt = const Value.absent(),
    this.isAnonymous = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String uid,
    this.email = const Value.absent(),
    this.passwordHash = const Value.absent(),
    this.salt = const Value.absent(),
    this.isAnonymous = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : uid = Value(uid),
       createdAt = Value(createdAt);
  static Insertable<AccountRow> custom({
    Expression<String>? uid,
    Expression<String>? email,
    Expression<String>? passwordHash,
    Expression<String>? salt,
    Expression<bool>? isAnonymous,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (email != null) 'email': email,
      if (passwordHash != null) 'password_hash': passwordHash,
      if (salt != null) 'salt': salt,
      if (isAnonymous != null) 'is_anonymous': isAnonymous,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? uid,
    Value<String?>? email,
    Value<String?>? passwordHash,
    Value<String?>? salt,
    Value<bool>? isAnonymous,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (passwordHash.present) {
      map['password_hash'] = Variable<String>(passwordHash.value);
    }
    if (salt.present) {
      map['salt'] = Variable<String>(salt.value);
    }
    if (isAnonymous.present) {
      map['is_anonymous'] = Variable<bool>(isAnonymous.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('uid: $uid, ')
          ..write('email: $email, ')
          ..write('passwordHash: $passwordHash, ')
          ..write('salt: $salt, ')
          ..write('isAnonymous: $isAnonymous, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SessionRowsTable extends SessionRows
    with TableInfo<$SessionRowsTable, SessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentUidMeta = const VerificationMeta(
    'currentUid',
  );
  @override
  late final GeneratedColumn<String> currentUid = GeneratedColumn<String>(
    'current_uid',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, currentUid];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<SessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('current_uid')) {
      context.handle(
        _currentUidMeta,
        currentUid.isAcceptableOrUnknown(data['current_uid']!, _currentUidMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      currentUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}current_uid'],
      ),
    );
  }

  @override
  $SessionRowsTable createAlias(String alias) {
    return $SessionRowsTable(attachedDatabase, alias);
  }
}

class SessionRow extends DataClass implements Insertable<SessionRow> {
  final int id;
  final String? currentUid;
  const SessionRow({required this.id, this.currentUid});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || currentUid != null) {
      map['current_uid'] = Variable<String>(currentUid);
    }
    return map;
  }

  SessionRowsCompanion toCompanion(bool nullToAbsent) {
    return SessionRowsCompanion(
      id: Value(id),
      currentUid: currentUid == null && nullToAbsent
          ? const Value.absent()
          : Value(currentUid),
    );
  }

  factory SessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionRow(
      id: serializer.fromJson<int>(json['id']),
      currentUid: serializer.fromJson<String?>(json['currentUid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'currentUid': serializer.toJson<String?>(currentUid),
    };
  }

  SessionRow copyWith({
    int? id,
    Value<String?> currentUid = const Value.absent(),
  }) => SessionRow(
    id: id ?? this.id,
    currentUid: currentUid.present ? currentUid.value : this.currentUid,
  );
  SessionRow copyWithCompanion(SessionRowsCompanion data) {
    return SessionRow(
      id: data.id.present ? data.id.value : this.id,
      currentUid: data.currentUid.present
          ? data.currentUid.value
          : this.currentUid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionRow(')
          ..write('id: $id, ')
          ..write('currentUid: $currentUid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, currentUid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionRow &&
          other.id == this.id &&
          other.currentUid == this.currentUid);
}

class SessionRowsCompanion extends UpdateCompanion<SessionRow> {
  final Value<int> id;
  final Value<String?> currentUid;
  const SessionRowsCompanion({
    this.id = const Value.absent(),
    this.currentUid = const Value.absent(),
  });
  SessionRowsCompanion.insert({
    this.id = const Value.absent(),
    this.currentUid = const Value.absent(),
  });
  static Insertable<SessionRow> custom({
    Expression<int>? id,
    Expression<String>? currentUid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (currentUid != null) 'current_uid': currentUid,
    });
  }

  SessionRowsCompanion copyWith({Value<int>? id, Value<String?>? currentUid}) {
    return SessionRowsCompanion(
      id: id ?? this.id,
      currentUid: currentUid ?? this.currentUid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (currentUid.present) {
      map['current_uid'] = Variable<String>(currentUid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionRowsCompanion(')
          ..write('id: $id, ')
          ..write('currentUid: $currentUid')
          ..write(')'))
        .toString();
  }
}

class $SerialCountersTable extends SerialCounters
    with TableInfo<$SerialCountersTable, SerialCounterRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SerialCountersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _uidMeta = const VerificationMeta('uid');
  @override
  late final GeneratedColumn<String> uid = GeneratedColumn<String>(
    'uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shipmentNextMeta = const VerificationMeta(
    'shipmentNext',
  );
  @override
  late final GeneratedColumn<int> shipmentNext = GeneratedColumn<int>(
    'shipment_next',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _labourNextMeta = const VerificationMeta(
    'labourNext',
  );
  @override
  late final GeneratedColumn<int> labourNext = GeneratedColumn<int>(
    'labour_next',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [uid, shipmentNext, labourNext];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'serial_counters';
  @override
  VerificationContext validateIntegrity(
    Insertable<SerialCounterRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('uid')) {
      context.handle(
        _uidMeta,
        uid.isAcceptableOrUnknown(data['uid']!, _uidMeta),
      );
    } else if (isInserting) {
      context.missing(_uidMeta);
    }
    if (data.containsKey('shipment_next')) {
      context.handle(
        _shipmentNextMeta,
        shipmentNext.isAcceptableOrUnknown(
          data['shipment_next']!,
          _shipmentNextMeta,
        ),
      );
    }
    if (data.containsKey('labour_next')) {
      context.handle(
        _labourNextMeta,
        labourNext.isAcceptableOrUnknown(data['labour_next']!, _labourNextMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {uid};
  @override
  SerialCounterRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SerialCounterRow(
      uid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uid'],
      )!,
      shipmentNext: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shipment_next'],
      )!,
      labourNext: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}labour_next'],
      )!,
    );
  }

  @override
  $SerialCountersTable createAlias(String alias) {
    return $SerialCountersTable(attachedDatabase, alias);
  }
}

class SerialCounterRow extends DataClass
    implements Insertable<SerialCounterRow> {
  final String uid;
  final int shipmentNext;
  final int labourNext;
  const SerialCounterRow({
    required this.uid,
    required this.shipmentNext,
    required this.labourNext,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['uid'] = Variable<String>(uid);
    map['shipment_next'] = Variable<int>(shipmentNext);
    map['labour_next'] = Variable<int>(labourNext);
    return map;
  }

  SerialCountersCompanion toCompanion(bool nullToAbsent) {
    return SerialCountersCompanion(
      uid: Value(uid),
      shipmentNext: Value(shipmentNext),
      labourNext: Value(labourNext),
    );
  }

  factory SerialCounterRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SerialCounterRow(
      uid: serializer.fromJson<String>(json['uid']),
      shipmentNext: serializer.fromJson<int>(json['shipmentNext']),
      labourNext: serializer.fromJson<int>(json['labourNext']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'uid': serializer.toJson<String>(uid),
      'shipmentNext': serializer.toJson<int>(shipmentNext),
      'labourNext': serializer.toJson<int>(labourNext),
    };
  }

  SerialCounterRow copyWith({
    String? uid,
    int? shipmentNext,
    int? labourNext,
  }) => SerialCounterRow(
    uid: uid ?? this.uid,
    shipmentNext: shipmentNext ?? this.shipmentNext,
    labourNext: labourNext ?? this.labourNext,
  );
  SerialCounterRow copyWithCompanion(SerialCountersCompanion data) {
    return SerialCounterRow(
      uid: data.uid.present ? data.uid.value : this.uid,
      shipmentNext: data.shipmentNext.present
          ? data.shipmentNext.value
          : this.shipmentNext,
      labourNext: data.labourNext.present
          ? data.labourNext.value
          : this.labourNext,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SerialCounterRow(')
          ..write('uid: $uid, ')
          ..write('shipmentNext: $shipmentNext, ')
          ..write('labourNext: $labourNext')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(uid, shipmentNext, labourNext);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SerialCounterRow &&
          other.uid == this.uid &&
          other.shipmentNext == this.shipmentNext &&
          other.labourNext == this.labourNext);
}

class SerialCountersCompanion extends UpdateCompanion<SerialCounterRow> {
  final Value<String> uid;
  final Value<int> shipmentNext;
  final Value<int> labourNext;
  final Value<int> rowid;
  const SerialCountersCompanion({
    this.uid = const Value.absent(),
    this.shipmentNext = const Value.absent(),
    this.labourNext = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SerialCountersCompanion.insert({
    required String uid,
    this.shipmentNext = const Value.absent(),
    this.labourNext = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : uid = Value(uid);
  static Insertable<SerialCounterRow> custom({
    Expression<String>? uid,
    Expression<int>? shipmentNext,
    Expression<int>? labourNext,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (uid != null) 'uid': uid,
      if (shipmentNext != null) 'shipment_next': shipmentNext,
      if (labourNext != null) 'labour_next': labourNext,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SerialCountersCompanion copyWith({
    Value<String>? uid,
    Value<int>? shipmentNext,
    Value<int>? labourNext,
    Value<int>? rowid,
  }) {
    return SerialCountersCompanion(
      uid: uid ?? this.uid,
      shipmentNext: shipmentNext ?? this.shipmentNext,
      labourNext: labourNext ?? this.labourNext,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (uid.present) {
      map['uid'] = Variable<String>(uid.value);
    }
    if (shipmentNext.present) {
      map['shipment_next'] = Variable<int>(shipmentNext.value);
    }
    if (labourNext.present) {
      map['labour_next'] = Variable<int>(labourNext.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SerialCountersCompanion(')
          ..write('uid: $uid, ')
          ..write('shipmentNext: $shipmentNext, ')
          ..write('labourNext: $labourNext, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MarketsTable extends Markets with TableInfo<$MarketsTable, MarketRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MarketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<String> ownerUid = GeneratedColumn<String>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashSerialNextMeta = const VerificationMeta(
    'cashSerialNext',
  );
  @override
  late final GeneratedColumn<int> cashSerialNext = GeneratedColumn<int>(
    'cash_serial_next',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUid,
    name,
    cashSerialNext,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'markets';
  @override
  VerificationContext validateIntegrity(
    Insertable<MarketRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cash_serial_next')) {
      context.handle(
        _cashSerialNextMeta,
        cashSerialNext.isAcceptableOrUnknown(
          data['cash_serial_next']!,
          _cashSerialNextMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MarketRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MarketRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_uid'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      cashSerialNext: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cash_serial_next'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $MarketsTable createAlias(String alias) {
    return $MarketsTable(attachedDatabase, alias);
  }
}

class MarketRow extends DataClass implements Insertable<MarketRow> {
  final String id;
  final String ownerUid;
  final String name;
  final int cashSerialNext;
  final int? createdAt;
  final int? updatedAt;
  const MarketRow({
    required this.id,
    required this.ownerUid,
    required this.name,
    required this.cashSerialNext,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_uid'] = Variable<String>(ownerUid);
    map['name'] = Variable<String>(name);
    map['cash_serial_next'] = Variable<int>(cashSerialNext);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  MarketsCompanion toCompanion(bool nullToAbsent) {
    return MarketsCompanion(
      id: Value(id),
      ownerUid: Value(ownerUid),
      name: Value(name),
      cashSerialNext: Value(cashSerialNext),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory MarketRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MarketRow(
      id: serializer.fromJson<String>(json['id']),
      ownerUid: serializer.fromJson<String>(json['ownerUid']),
      name: serializer.fromJson<String>(json['name']),
      cashSerialNext: serializer.fromJson<int>(json['cashSerialNext']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerUid': serializer.toJson<String>(ownerUid),
      'name': serializer.toJson<String>(name),
      'cashSerialNext': serializer.toJson<int>(cashSerialNext),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  MarketRow copyWith({
    String? id,
    String? ownerUid,
    String? name,
    int? cashSerialNext,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => MarketRow(
    id: id ?? this.id,
    ownerUid: ownerUid ?? this.ownerUid,
    name: name ?? this.name,
    cashSerialNext: cashSerialNext ?? this.cashSerialNext,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  MarketRow copyWithCompanion(MarketsCompanion data) {
    return MarketRow(
      id: data.id.present ? data.id.value : this.id,
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      name: data.name.present ? data.name.value : this.name,
      cashSerialNext: data.cashSerialNext.present
          ? data.cashSerialNext.value
          : this.cashSerialNext,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MarketRow(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('name: $name, ')
          ..write('cashSerialNext: $cashSerialNext, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, ownerUid, name, cashSerialNext, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MarketRow &&
          other.id == this.id &&
          other.ownerUid == this.ownerUid &&
          other.name == this.name &&
          other.cashSerialNext == this.cashSerialNext &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class MarketsCompanion extends UpdateCompanion<MarketRow> {
  final Value<String> id;
  final Value<String> ownerUid;
  final Value<String> name;
  final Value<int> cashSerialNext;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  final Value<int> rowid;
  const MarketsCompanion({
    this.id = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.name = const Value.absent(),
    this.cashSerialNext = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MarketsCompanion.insert({
    required String id,
    required String ownerUid,
    required String name,
    this.cashSerialNext = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerUid = Value(ownerUid),
       name = Value(name);
  static Insertable<MarketRow> custom({
    Expression<String>? id,
    Expression<String>? ownerUid,
    Expression<String>? name,
    Expression<int>? cashSerialNext,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (name != null) 'name': name,
      if (cashSerialNext != null) 'cash_serial_next': cashSerialNext,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MarketsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerUid,
    Value<String>? name,
    Value<int>? cashSerialNext,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
    Value<int>? rowid,
  }) {
    return MarketsCompanion(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      name: name ?? this.name,
      cashSerialNext: cashSerialNext ?? this.cashSerialNext,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerUid.present) {
      map['owner_uid'] = Variable<String>(ownerUid.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (cashSerialNext.present) {
      map['cash_serial_next'] = Variable<int>(cashSerialNext.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MarketsCompanion(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('name: $name, ')
          ..write('cashSerialNext: $cashSerialNext, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShipmentsTable extends Shipments
    with TableInfo<$ShipmentsTable, ShipmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShipmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<String> ownerUid = GeneratedColumn<String>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serialMeta = const VerificationMeta('serial');
  @override
  late final GeneratedColumn<int> serial = GeneratedColumn<int>(
    'serial',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marketIdMeta = const VerificationMeta(
    'marketId',
  );
  @override
  late final GeneratedColumn<String> marketId = GeneratedColumn<String>(
    'market_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marketNameMeta = const VerificationMeta(
    'marketName',
  );
  @override
  late final GeneratedColumn<String> marketName = GeneratedColumn<String>(
    'market_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _buyerNameMeta = const VerificationMeta(
    'buyerName',
  );
  @override
  late final GeneratedColumn<String> buyerName = GeneratedColumn<String>(
    'buyer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountReceivedMeta = const VerificationMeta(
    'amountReceived',
  );
  @override
  late final GeneratedColumn<double> amountReceived = GeneratedColumn<double>(
    'amount_received',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUid,
    serial,
    date,
    marketId,
    marketName,
    buyerName,
    quantity,
    totalAmount,
    amountReceived,
    balance,
    status,
    remarks,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shipments';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShipmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('serial')) {
      context.handle(
        _serialMeta,
        serial.isAcceptableOrUnknown(data['serial']!, _serialMeta),
      );
    } else if (isInserting) {
      context.missing(_serialMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('market_id')) {
      context.handle(
        _marketIdMeta,
        marketId.isAcceptableOrUnknown(data['market_id']!, _marketIdMeta),
      );
    } else if (isInserting) {
      context.missing(_marketIdMeta);
    }
    if (data.containsKey('market_name')) {
      context.handle(
        _marketNameMeta,
        marketName.isAcceptableOrUnknown(data['market_name']!, _marketNameMeta),
      );
    } else if (isInserting) {
      context.missing(_marketNameMeta);
    }
    if (data.containsKey('buyer_name')) {
      context.handle(
        _buyerNameMeta,
        buyerName.isAcceptableOrUnknown(data['buyer_name']!, _buyerNameMeta),
      );
    } else if (isInserting) {
      context.missing(_buyerNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('amount_received')) {
      context.handle(
        _amountReceivedMeta,
        amountReceived.isAcceptableOrUnknown(
          data['amount_received']!,
          _amountReceivedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountReceivedMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    } else if (isInserting) {
      context.missing(_remarksMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShipmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShipmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_uid'],
      )!,
      serial: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}serial'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      marketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}market_id'],
      )!,
      marketName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}market_name'],
      )!,
      buyerName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}buyer_name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      totalAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_amount'],
      )!,
      amountReceived: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_received'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $ShipmentsTable createAlias(String alias) {
    return $ShipmentsTable(attachedDatabase, alias);
  }
}

class ShipmentRow extends DataClass implements Insertable<ShipmentRow> {
  final String id;
  final String ownerUid;
  final int serial;
  final int date;
  final String marketId;
  final String marketName;
  final String buyerName;
  final double quantity;
  final double totalAmount;
  final double amountReceived;
  final double balance;
  final String status;
  final String remarks;
  final int? createdAt;
  final int? updatedAt;
  const ShipmentRow({
    required this.id,
    required this.ownerUid,
    required this.serial,
    required this.date,
    required this.marketId,
    required this.marketName,
    required this.buyerName,
    required this.quantity,
    required this.totalAmount,
    required this.amountReceived,
    required this.balance,
    required this.status,
    required this.remarks,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_uid'] = Variable<String>(ownerUid);
    map['serial'] = Variable<int>(serial);
    map['date'] = Variable<int>(date);
    map['market_id'] = Variable<String>(marketId);
    map['market_name'] = Variable<String>(marketName);
    map['buyer_name'] = Variable<String>(buyerName);
    map['quantity'] = Variable<double>(quantity);
    map['total_amount'] = Variable<double>(totalAmount);
    map['amount_received'] = Variable<double>(amountReceived);
    map['balance'] = Variable<double>(balance);
    map['status'] = Variable<String>(status);
    map['remarks'] = Variable<String>(remarks);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  ShipmentsCompanion toCompanion(bool nullToAbsent) {
    return ShipmentsCompanion(
      id: Value(id),
      ownerUid: Value(ownerUid),
      serial: Value(serial),
      date: Value(date),
      marketId: Value(marketId),
      marketName: Value(marketName),
      buyerName: Value(buyerName),
      quantity: Value(quantity),
      totalAmount: Value(totalAmount),
      amountReceived: Value(amountReceived),
      balance: Value(balance),
      status: Value(status),
      remarks: Value(remarks),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory ShipmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShipmentRow(
      id: serializer.fromJson<String>(json['id']),
      ownerUid: serializer.fromJson<String>(json['ownerUid']),
      serial: serializer.fromJson<int>(json['serial']),
      date: serializer.fromJson<int>(json['date']),
      marketId: serializer.fromJson<String>(json['marketId']),
      marketName: serializer.fromJson<String>(json['marketName']),
      buyerName: serializer.fromJson<String>(json['buyerName']),
      quantity: serializer.fromJson<double>(json['quantity']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      amountReceived: serializer.fromJson<double>(json['amountReceived']),
      balance: serializer.fromJson<double>(json['balance']),
      status: serializer.fromJson<String>(json['status']),
      remarks: serializer.fromJson<String>(json['remarks']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerUid': serializer.toJson<String>(ownerUid),
      'serial': serializer.toJson<int>(serial),
      'date': serializer.toJson<int>(date),
      'marketId': serializer.toJson<String>(marketId),
      'marketName': serializer.toJson<String>(marketName),
      'buyerName': serializer.toJson<String>(buyerName),
      'quantity': serializer.toJson<double>(quantity),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'amountReceived': serializer.toJson<double>(amountReceived),
      'balance': serializer.toJson<double>(balance),
      'status': serializer.toJson<String>(status),
      'remarks': serializer.toJson<String>(remarks),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  ShipmentRow copyWith({
    String? id,
    String? ownerUid,
    int? serial,
    int? date,
    String? marketId,
    String? marketName,
    String? buyerName,
    double? quantity,
    double? totalAmount,
    double? amountReceived,
    double? balance,
    String? status,
    String? remarks,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => ShipmentRow(
    id: id ?? this.id,
    ownerUid: ownerUid ?? this.ownerUid,
    serial: serial ?? this.serial,
    date: date ?? this.date,
    marketId: marketId ?? this.marketId,
    marketName: marketName ?? this.marketName,
    buyerName: buyerName ?? this.buyerName,
    quantity: quantity ?? this.quantity,
    totalAmount: totalAmount ?? this.totalAmount,
    amountReceived: amountReceived ?? this.amountReceived,
    balance: balance ?? this.balance,
    status: status ?? this.status,
    remarks: remarks ?? this.remarks,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  ShipmentRow copyWithCompanion(ShipmentsCompanion data) {
    return ShipmentRow(
      id: data.id.present ? data.id.value : this.id,
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      serial: data.serial.present ? data.serial.value : this.serial,
      date: data.date.present ? data.date.value : this.date,
      marketId: data.marketId.present ? data.marketId.value : this.marketId,
      marketName: data.marketName.present
          ? data.marketName.value
          : this.marketName,
      buyerName: data.buyerName.present ? data.buyerName.value : this.buyerName,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      totalAmount: data.totalAmount.present
          ? data.totalAmount.value
          : this.totalAmount,
      amountReceived: data.amountReceived.present
          ? data.amountReceived.value
          : this.amountReceived,
      balance: data.balance.present ? data.balance.value : this.balance,
      status: data.status.present ? data.status.value : this.status,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShipmentRow(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('serial: $serial, ')
          ..write('date: $date, ')
          ..write('marketId: $marketId, ')
          ..write('marketName: $marketName, ')
          ..write('buyerName: $buyerName, ')
          ..write('quantity: $quantity, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('amountReceived: $amountReceived, ')
          ..write('balance: $balance, ')
          ..write('status: $status, ')
          ..write('remarks: $remarks, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUid,
    serial,
    date,
    marketId,
    marketName,
    buyerName,
    quantity,
    totalAmount,
    amountReceived,
    balance,
    status,
    remarks,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShipmentRow &&
          other.id == this.id &&
          other.ownerUid == this.ownerUid &&
          other.serial == this.serial &&
          other.date == this.date &&
          other.marketId == this.marketId &&
          other.marketName == this.marketName &&
          other.buyerName == this.buyerName &&
          other.quantity == this.quantity &&
          other.totalAmount == this.totalAmount &&
          other.amountReceived == this.amountReceived &&
          other.balance == this.balance &&
          other.status == this.status &&
          other.remarks == this.remarks &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ShipmentsCompanion extends UpdateCompanion<ShipmentRow> {
  final Value<String> id;
  final Value<String> ownerUid;
  final Value<int> serial;
  final Value<int> date;
  final Value<String> marketId;
  final Value<String> marketName;
  final Value<String> buyerName;
  final Value<double> quantity;
  final Value<double> totalAmount;
  final Value<double> amountReceived;
  final Value<double> balance;
  final Value<String> status;
  final Value<String> remarks;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  final Value<int> rowid;
  const ShipmentsCompanion({
    this.id = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.serial = const Value.absent(),
    this.date = const Value.absent(),
    this.marketId = const Value.absent(),
    this.marketName = const Value.absent(),
    this.buyerName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.amountReceived = const Value.absent(),
    this.balance = const Value.absent(),
    this.status = const Value.absent(),
    this.remarks = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShipmentsCompanion.insert({
    required String id,
    required String ownerUid,
    required int serial,
    required int date,
    required String marketId,
    required String marketName,
    required String buyerName,
    required double quantity,
    required double totalAmount,
    required double amountReceived,
    required double balance,
    required String status,
    required String remarks,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerUid = Value(ownerUid),
       serial = Value(serial),
       date = Value(date),
       marketId = Value(marketId),
       marketName = Value(marketName),
       buyerName = Value(buyerName),
       quantity = Value(quantity),
       totalAmount = Value(totalAmount),
       amountReceived = Value(amountReceived),
       balance = Value(balance),
       status = Value(status),
       remarks = Value(remarks);
  static Insertable<ShipmentRow> custom({
    Expression<String>? id,
    Expression<String>? ownerUid,
    Expression<int>? serial,
    Expression<int>? date,
    Expression<String>? marketId,
    Expression<String>? marketName,
    Expression<String>? buyerName,
    Expression<double>? quantity,
    Expression<double>? totalAmount,
    Expression<double>? amountReceived,
    Expression<double>? balance,
    Expression<String>? status,
    Expression<String>? remarks,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (serial != null) 'serial': serial,
      if (date != null) 'date': date,
      if (marketId != null) 'market_id': marketId,
      if (marketName != null) 'market_name': marketName,
      if (buyerName != null) 'buyer_name': buyerName,
      if (quantity != null) 'quantity': quantity,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (amountReceived != null) 'amount_received': amountReceived,
      if (balance != null) 'balance': balance,
      if (status != null) 'status': status,
      if (remarks != null) 'remarks': remarks,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShipmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerUid,
    Value<int>? serial,
    Value<int>? date,
    Value<String>? marketId,
    Value<String>? marketName,
    Value<String>? buyerName,
    Value<double>? quantity,
    Value<double>? totalAmount,
    Value<double>? amountReceived,
    Value<double>? balance,
    Value<String>? status,
    Value<String>? remarks,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
    Value<int>? rowid,
  }) {
    return ShipmentsCompanion(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      serial: serial ?? this.serial,
      date: date ?? this.date,
      marketId: marketId ?? this.marketId,
      marketName: marketName ?? this.marketName,
      buyerName: buyerName ?? this.buyerName,
      quantity: quantity ?? this.quantity,
      totalAmount: totalAmount ?? this.totalAmount,
      amountReceived: amountReceived ?? this.amountReceived,
      balance: balance ?? this.balance,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerUid.present) {
      map['owner_uid'] = Variable<String>(ownerUid.value);
    }
    if (serial.present) {
      map['serial'] = Variable<int>(serial.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (marketId.present) {
      map['market_id'] = Variable<String>(marketId.value);
    }
    if (marketName.present) {
      map['market_name'] = Variable<String>(marketName.value);
    }
    if (buyerName.present) {
      map['buyer_name'] = Variable<String>(buyerName.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (amountReceived.present) {
      map['amount_received'] = Variable<double>(amountReceived.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShipmentsCompanion(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('serial: $serial, ')
          ..write('date: $date, ')
          ..write('marketId: $marketId, ')
          ..write('marketName: $marketName, ')
          ..write('buyerName: $buyerName, ')
          ..write('quantity: $quantity, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('amountReceived: $amountReceived, ')
          ..write('balance: $balance, ')
          ..write('status: $status, ')
          ..write('remarks: $remarks, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CashEntriesTable extends CashEntries
    with TableInfo<$CashEntriesTable, CashEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CashEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<String> ownerUid = GeneratedColumn<String>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _marketIdMeta = const VerificationMeta(
    'marketId',
  );
  @override
  late final GeneratedColumn<String> marketId = GeneratedColumn<String>(
    'market_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serialMeta = const VerificationMeta('serial');
  @override
  late final GeneratedColumn<int> serial = GeneratedColumn<int>(
    'serial',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountReceivedMeta = const VerificationMeta(
    'amountReceived',
  );
  @override
  late final GeneratedColumn<double> amountReceived = GeneratedColumn<double>(
    'amount_received',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentsMeta = const VerificationMeta(
    'payments',
  );
  @override
  late final GeneratedColumn<double> payments = GeneratedColumn<double>(
    'payments',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _previousCashMeta = const VerificationMeta(
    'previousCash',
  );
  @override
  late final GeneratedColumn<double> previousCash = GeneratedColumn<double>(
    'previous_cash',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cashAvailableMeta = const VerificationMeta(
    'cashAvailable',
  );
  @override
  late final GeneratedColumn<double> cashAvailable = GeneratedColumn<double>(
    'cash_available',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _balanceMeta = const VerificationMeta(
    'balance',
  );
  @override
  late final GeneratedColumn<double> balance = GeneratedColumn<double>(
    'balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUid,
    marketId,
    serial,
    date,
    amountReceived,
    payments,
    previousCash,
    cashAvailable,
    balance,
    remarks,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cash_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CashEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('market_id')) {
      context.handle(
        _marketIdMeta,
        marketId.isAcceptableOrUnknown(data['market_id']!, _marketIdMeta),
      );
    } else if (isInserting) {
      context.missing(_marketIdMeta);
    }
    if (data.containsKey('serial')) {
      context.handle(
        _serialMeta,
        serial.isAcceptableOrUnknown(data['serial']!, _serialMeta),
      );
    } else if (isInserting) {
      context.missing(_serialMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('amount_received')) {
      context.handle(
        _amountReceivedMeta,
        amountReceived.isAcceptableOrUnknown(
          data['amount_received']!,
          _amountReceivedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountReceivedMeta);
    }
    if (data.containsKey('payments')) {
      context.handle(
        _paymentsMeta,
        payments.isAcceptableOrUnknown(data['payments']!, _paymentsMeta),
      );
    } else if (isInserting) {
      context.missing(_paymentsMeta);
    }
    if (data.containsKey('previous_cash')) {
      context.handle(
        _previousCashMeta,
        previousCash.isAcceptableOrUnknown(
          data['previous_cash']!,
          _previousCashMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_previousCashMeta);
    }
    if (data.containsKey('cash_available')) {
      context.handle(
        _cashAvailableMeta,
        cashAvailable.isAcceptableOrUnknown(
          data['cash_available']!,
          _cashAvailableMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cashAvailableMeta);
    }
    if (data.containsKey('balance')) {
      context.handle(
        _balanceMeta,
        balance.isAcceptableOrUnknown(data['balance']!, _balanceMeta),
      );
    } else if (isInserting) {
      context.missing(_balanceMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    } else if (isInserting) {
      context.missing(_remarksMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CashEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CashEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_uid'],
      )!,
      marketId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}market_id'],
      )!,
      serial: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}serial'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      amountReceived: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_received'],
      )!,
      payments: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}payments'],
      )!,
      previousCash: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}previous_cash'],
      )!,
      cashAvailable: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cash_available'],
      )!,
      balance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}balance'],
      )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $CashEntriesTable createAlias(String alias) {
    return $CashEntriesTable(attachedDatabase, alias);
  }
}

class CashEntryRow extends DataClass implements Insertable<CashEntryRow> {
  final String id;
  final String ownerUid;
  final String marketId;
  final int serial;
  final int date;
  final double amountReceived;
  final double payments;
  final double previousCash;
  final double cashAvailable;
  final double balance;
  final String remarks;
  final int? createdAt;
  final int? updatedAt;
  const CashEntryRow({
    required this.id,
    required this.ownerUid,
    required this.marketId,
    required this.serial,
    required this.date,
    required this.amountReceived,
    required this.payments,
    required this.previousCash,
    required this.cashAvailable,
    required this.balance,
    required this.remarks,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_uid'] = Variable<String>(ownerUid);
    map['market_id'] = Variable<String>(marketId);
    map['serial'] = Variable<int>(serial);
    map['date'] = Variable<int>(date);
    map['amount_received'] = Variable<double>(amountReceived);
    map['payments'] = Variable<double>(payments);
    map['previous_cash'] = Variable<double>(previousCash);
    map['cash_available'] = Variable<double>(cashAvailable);
    map['balance'] = Variable<double>(balance);
    map['remarks'] = Variable<String>(remarks);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  CashEntriesCompanion toCompanion(bool nullToAbsent) {
    return CashEntriesCompanion(
      id: Value(id),
      ownerUid: Value(ownerUid),
      marketId: Value(marketId),
      serial: Value(serial),
      date: Value(date),
      amountReceived: Value(amountReceived),
      payments: Value(payments),
      previousCash: Value(previousCash),
      cashAvailable: Value(cashAvailable),
      balance: Value(balance),
      remarks: Value(remarks),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory CashEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CashEntryRow(
      id: serializer.fromJson<String>(json['id']),
      ownerUid: serializer.fromJson<String>(json['ownerUid']),
      marketId: serializer.fromJson<String>(json['marketId']),
      serial: serializer.fromJson<int>(json['serial']),
      date: serializer.fromJson<int>(json['date']),
      amountReceived: serializer.fromJson<double>(json['amountReceived']),
      payments: serializer.fromJson<double>(json['payments']),
      previousCash: serializer.fromJson<double>(json['previousCash']),
      cashAvailable: serializer.fromJson<double>(json['cashAvailable']),
      balance: serializer.fromJson<double>(json['balance']),
      remarks: serializer.fromJson<String>(json['remarks']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerUid': serializer.toJson<String>(ownerUid),
      'marketId': serializer.toJson<String>(marketId),
      'serial': serializer.toJson<int>(serial),
      'date': serializer.toJson<int>(date),
      'amountReceived': serializer.toJson<double>(amountReceived),
      'payments': serializer.toJson<double>(payments),
      'previousCash': serializer.toJson<double>(previousCash),
      'cashAvailable': serializer.toJson<double>(cashAvailable),
      'balance': serializer.toJson<double>(balance),
      'remarks': serializer.toJson<String>(remarks),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  CashEntryRow copyWith({
    String? id,
    String? ownerUid,
    String? marketId,
    int? serial,
    int? date,
    double? amountReceived,
    double? payments,
    double? previousCash,
    double? cashAvailable,
    double? balance,
    String? remarks,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => CashEntryRow(
    id: id ?? this.id,
    ownerUid: ownerUid ?? this.ownerUid,
    marketId: marketId ?? this.marketId,
    serial: serial ?? this.serial,
    date: date ?? this.date,
    amountReceived: amountReceived ?? this.amountReceived,
    payments: payments ?? this.payments,
    previousCash: previousCash ?? this.previousCash,
    cashAvailable: cashAvailable ?? this.cashAvailable,
    balance: balance ?? this.balance,
    remarks: remarks ?? this.remarks,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  CashEntryRow copyWithCompanion(CashEntriesCompanion data) {
    return CashEntryRow(
      id: data.id.present ? data.id.value : this.id,
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      marketId: data.marketId.present ? data.marketId.value : this.marketId,
      serial: data.serial.present ? data.serial.value : this.serial,
      date: data.date.present ? data.date.value : this.date,
      amountReceived: data.amountReceived.present
          ? data.amountReceived.value
          : this.amountReceived,
      payments: data.payments.present ? data.payments.value : this.payments,
      previousCash: data.previousCash.present
          ? data.previousCash.value
          : this.previousCash,
      cashAvailable: data.cashAvailable.present
          ? data.cashAvailable.value
          : this.cashAvailable,
      balance: data.balance.present ? data.balance.value : this.balance,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CashEntryRow(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('marketId: $marketId, ')
          ..write('serial: $serial, ')
          ..write('date: $date, ')
          ..write('amountReceived: $amountReceived, ')
          ..write('payments: $payments, ')
          ..write('previousCash: $previousCash, ')
          ..write('cashAvailable: $cashAvailable, ')
          ..write('balance: $balance, ')
          ..write('remarks: $remarks, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUid,
    marketId,
    serial,
    date,
    amountReceived,
    payments,
    previousCash,
    cashAvailable,
    balance,
    remarks,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CashEntryRow &&
          other.id == this.id &&
          other.ownerUid == this.ownerUid &&
          other.marketId == this.marketId &&
          other.serial == this.serial &&
          other.date == this.date &&
          other.amountReceived == this.amountReceived &&
          other.payments == this.payments &&
          other.previousCash == this.previousCash &&
          other.cashAvailable == this.cashAvailable &&
          other.balance == this.balance &&
          other.remarks == this.remarks &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CashEntriesCompanion extends UpdateCompanion<CashEntryRow> {
  final Value<String> id;
  final Value<String> ownerUid;
  final Value<String> marketId;
  final Value<int> serial;
  final Value<int> date;
  final Value<double> amountReceived;
  final Value<double> payments;
  final Value<double> previousCash;
  final Value<double> cashAvailable;
  final Value<double> balance;
  final Value<String> remarks;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  final Value<int> rowid;
  const CashEntriesCompanion({
    this.id = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.marketId = const Value.absent(),
    this.serial = const Value.absent(),
    this.date = const Value.absent(),
    this.amountReceived = const Value.absent(),
    this.payments = const Value.absent(),
    this.previousCash = const Value.absent(),
    this.cashAvailable = const Value.absent(),
    this.balance = const Value.absent(),
    this.remarks = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CashEntriesCompanion.insert({
    required String id,
    required String ownerUid,
    required String marketId,
    required int serial,
    required int date,
    required double amountReceived,
    required double payments,
    required double previousCash,
    required double cashAvailable,
    required double balance,
    required String remarks,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerUid = Value(ownerUid),
       marketId = Value(marketId),
       serial = Value(serial),
       date = Value(date),
       amountReceived = Value(amountReceived),
       payments = Value(payments),
       previousCash = Value(previousCash),
       cashAvailable = Value(cashAvailable),
       balance = Value(balance),
       remarks = Value(remarks);
  static Insertable<CashEntryRow> custom({
    Expression<String>? id,
    Expression<String>? ownerUid,
    Expression<String>? marketId,
    Expression<int>? serial,
    Expression<int>? date,
    Expression<double>? amountReceived,
    Expression<double>? payments,
    Expression<double>? previousCash,
    Expression<double>? cashAvailable,
    Expression<double>? balance,
    Expression<String>? remarks,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (marketId != null) 'market_id': marketId,
      if (serial != null) 'serial': serial,
      if (date != null) 'date': date,
      if (amountReceived != null) 'amount_received': amountReceived,
      if (payments != null) 'payments': payments,
      if (previousCash != null) 'previous_cash': previousCash,
      if (cashAvailable != null) 'cash_available': cashAvailable,
      if (balance != null) 'balance': balance,
      if (remarks != null) 'remarks': remarks,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CashEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerUid,
    Value<String>? marketId,
    Value<int>? serial,
    Value<int>? date,
    Value<double>? amountReceived,
    Value<double>? payments,
    Value<double>? previousCash,
    Value<double>? cashAvailable,
    Value<double>? balance,
    Value<String>? remarks,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
    Value<int>? rowid,
  }) {
    return CashEntriesCompanion(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      marketId: marketId ?? this.marketId,
      serial: serial ?? this.serial,
      date: date ?? this.date,
      amountReceived: amountReceived ?? this.amountReceived,
      payments: payments ?? this.payments,
      previousCash: previousCash ?? this.previousCash,
      cashAvailable: cashAvailable ?? this.cashAvailable,
      balance: balance ?? this.balance,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerUid.present) {
      map['owner_uid'] = Variable<String>(ownerUid.value);
    }
    if (marketId.present) {
      map['market_id'] = Variable<String>(marketId.value);
    }
    if (serial.present) {
      map['serial'] = Variable<int>(serial.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (amountReceived.present) {
      map['amount_received'] = Variable<double>(amountReceived.value);
    }
    if (payments.present) {
      map['payments'] = Variable<double>(payments.value);
    }
    if (previousCash.present) {
      map['previous_cash'] = Variable<double>(previousCash.value);
    }
    if (cashAvailable.present) {
      map['cash_available'] = Variable<double>(cashAvailable.value);
    }
    if (balance.present) {
      map['balance'] = Variable<double>(balance.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CashEntriesCompanion(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('marketId: $marketId, ')
          ..write('serial: $serial, ')
          ..write('date: $date, ')
          ..write('amountReceived: $amountReceived, ')
          ..write('payments: $payments, ')
          ..write('previousCash: $previousCash, ')
          ..write('cashAvailable: $cashAvailable, ')
          ..write('balance: $balance, ')
          ..write('remarks: $remarks, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LabourJobsTable extends LabourJobs
    with TableInfo<$LabourJobsTable, LabourJobRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LabourJobsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerUidMeta = const VerificationMeta(
    'ownerUid',
  );
  @override
  late final GeneratedColumn<String> ownerUid = GeneratedColumn<String>(
    'owner_uid',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serialMeta = const VerificationMeta('serial');
  @override
  late final GeneratedColumn<int> serial = GeneratedColumn<int>(
    'serial',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateStartMeta = const VerificationMeta(
    'dateStart',
  );
  @override
  late final GeneratedColumn<int> dateStart = GeneratedColumn<int>(
    'date_start',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateEndMeta = const VerificationMeta(
    'dateEnd',
  );
  @override
  late final GeneratedColumn<int> dateEnd = GeneratedColumn<int>(
    'date_end',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalCostMeta = const VerificationMeta(
    'totalCost',
  );
  @override
  late final GeneratedColumn<double> totalCost = GeneratedColumn<double>(
    'total_cost',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedPaymentMeta = const VerificationMeta(
    'receivedPayment',
  );
  @override
  late final GeneratedColumn<double> receivedPayment = GeneratedColumn<double>(
    'received_payment',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remainingBalanceMeta = const VerificationMeta(
    'remainingBalance',
  );
  @override
  late final GeneratedColumn<double> remainingBalance = GeneratedColumn<double>(
    'remaining_balance',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _remarksMeta = const VerificationMeta(
    'remarks',
  );
  @override
  late final GeneratedColumn<String> remarks = GeneratedColumn<String>(
    'remarks',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerUid,
    serial,
    dateStart,
    dateEnd,
    totalCost,
    receivedPayment,
    remainingBalance,
    status,
    remarks,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'labour_jobs';
  @override
  VerificationContext validateIntegrity(
    Insertable<LabourJobRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_uid')) {
      context.handle(
        _ownerUidMeta,
        ownerUid.isAcceptableOrUnknown(data['owner_uid']!, _ownerUidMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerUidMeta);
    }
    if (data.containsKey('serial')) {
      context.handle(
        _serialMeta,
        serial.isAcceptableOrUnknown(data['serial']!, _serialMeta),
      );
    } else if (isInserting) {
      context.missing(_serialMeta);
    }
    if (data.containsKey('date_start')) {
      context.handle(
        _dateStartMeta,
        dateStart.isAcceptableOrUnknown(data['date_start']!, _dateStartMeta),
      );
    } else if (isInserting) {
      context.missing(_dateStartMeta);
    }
    if (data.containsKey('date_end')) {
      context.handle(
        _dateEndMeta,
        dateEnd.isAcceptableOrUnknown(data['date_end']!, _dateEndMeta),
      );
    } else if (isInserting) {
      context.missing(_dateEndMeta);
    }
    if (data.containsKey('total_cost')) {
      context.handle(
        _totalCostMeta,
        totalCost.isAcceptableOrUnknown(data['total_cost']!, _totalCostMeta),
      );
    } else if (isInserting) {
      context.missing(_totalCostMeta);
    }
    if (data.containsKey('received_payment')) {
      context.handle(
        _receivedPaymentMeta,
        receivedPayment.isAcceptableOrUnknown(
          data['received_payment']!,
          _receivedPaymentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_receivedPaymentMeta);
    }
    if (data.containsKey('remaining_balance')) {
      context.handle(
        _remainingBalanceMeta,
        remainingBalance.isAcceptableOrUnknown(
          data['remaining_balance']!,
          _remainingBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_remainingBalanceMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('remarks')) {
      context.handle(
        _remarksMeta,
        remarks.isAcceptableOrUnknown(data['remarks']!, _remarksMeta),
      );
    } else if (isInserting) {
      context.missing(_remarksMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LabourJobRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LabourJobRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerUid: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_uid'],
      )!,
      serial: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}serial'],
      )!,
      dateStart: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_start'],
      )!,
      dateEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date_end'],
      )!,
      totalCost: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}total_cost'],
      )!,
      receivedPayment: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}received_payment'],
      )!,
      remainingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}remaining_balance'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      remarks: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}remarks'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      ),
    );
  }

  @override
  $LabourJobsTable createAlias(String alias) {
    return $LabourJobsTable(attachedDatabase, alias);
  }
}

class LabourJobRow extends DataClass implements Insertable<LabourJobRow> {
  final String id;
  final String ownerUid;
  final int serial;
  final int dateStart;
  final int dateEnd;
  final double totalCost;
  final double receivedPayment;
  final double remainingBalance;
  final String status;
  final String remarks;
  final int? createdAt;
  final int? updatedAt;
  const LabourJobRow({
    required this.id,
    required this.ownerUid,
    required this.serial,
    required this.dateStart,
    required this.dateEnd,
    required this.totalCost,
    required this.receivedPayment,
    required this.remainingBalance,
    required this.status,
    required this.remarks,
    this.createdAt,
    this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_uid'] = Variable<String>(ownerUid);
    map['serial'] = Variable<int>(serial);
    map['date_start'] = Variable<int>(dateStart);
    map['date_end'] = Variable<int>(dateEnd);
    map['total_cost'] = Variable<double>(totalCost);
    map['received_payment'] = Variable<double>(receivedPayment);
    map['remaining_balance'] = Variable<double>(remainingBalance);
    map['status'] = Variable<String>(status);
    map['remarks'] = Variable<String>(remarks);
    if (!nullToAbsent || createdAt != null) {
      map['created_at'] = Variable<int>(createdAt);
    }
    if (!nullToAbsent || updatedAt != null) {
      map['updated_at'] = Variable<int>(updatedAt);
    }
    return map;
  }

  LabourJobsCompanion toCompanion(bool nullToAbsent) {
    return LabourJobsCompanion(
      id: Value(id),
      ownerUid: Value(ownerUid),
      serial: Value(serial),
      dateStart: Value(dateStart),
      dateEnd: Value(dateEnd),
      totalCost: Value(totalCost),
      receivedPayment: Value(receivedPayment),
      remainingBalance: Value(remainingBalance),
      status: Value(status),
      remarks: Value(remarks),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      updatedAt: updatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(updatedAt),
    );
  }

  factory LabourJobRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LabourJobRow(
      id: serializer.fromJson<String>(json['id']),
      ownerUid: serializer.fromJson<String>(json['ownerUid']),
      serial: serializer.fromJson<int>(json['serial']),
      dateStart: serializer.fromJson<int>(json['dateStart']),
      dateEnd: serializer.fromJson<int>(json['dateEnd']),
      totalCost: serializer.fromJson<double>(json['totalCost']),
      receivedPayment: serializer.fromJson<double>(json['receivedPayment']),
      remainingBalance: serializer.fromJson<double>(json['remainingBalance']),
      status: serializer.fromJson<String>(json['status']),
      remarks: serializer.fromJson<String>(json['remarks']),
      createdAt: serializer.fromJson<int?>(json['createdAt']),
      updatedAt: serializer.fromJson<int?>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerUid': serializer.toJson<String>(ownerUid),
      'serial': serializer.toJson<int>(serial),
      'dateStart': serializer.toJson<int>(dateStart),
      'dateEnd': serializer.toJson<int>(dateEnd),
      'totalCost': serializer.toJson<double>(totalCost),
      'receivedPayment': serializer.toJson<double>(receivedPayment),
      'remainingBalance': serializer.toJson<double>(remainingBalance),
      'status': serializer.toJson<String>(status),
      'remarks': serializer.toJson<String>(remarks),
      'createdAt': serializer.toJson<int?>(createdAt),
      'updatedAt': serializer.toJson<int?>(updatedAt),
    };
  }

  LabourJobRow copyWith({
    String? id,
    String? ownerUid,
    int? serial,
    int? dateStart,
    int? dateEnd,
    double? totalCost,
    double? receivedPayment,
    double? remainingBalance,
    String? status,
    String? remarks,
    Value<int?> createdAt = const Value.absent(),
    Value<int?> updatedAt = const Value.absent(),
  }) => LabourJobRow(
    id: id ?? this.id,
    ownerUid: ownerUid ?? this.ownerUid,
    serial: serial ?? this.serial,
    dateStart: dateStart ?? this.dateStart,
    dateEnd: dateEnd ?? this.dateEnd,
    totalCost: totalCost ?? this.totalCost,
    receivedPayment: receivedPayment ?? this.receivedPayment,
    remainingBalance: remainingBalance ?? this.remainingBalance,
    status: status ?? this.status,
    remarks: remarks ?? this.remarks,
    createdAt: createdAt.present ? createdAt.value : this.createdAt,
    updatedAt: updatedAt.present ? updatedAt.value : this.updatedAt,
  );
  LabourJobRow copyWithCompanion(LabourJobsCompanion data) {
    return LabourJobRow(
      id: data.id.present ? data.id.value : this.id,
      ownerUid: data.ownerUid.present ? data.ownerUid.value : this.ownerUid,
      serial: data.serial.present ? data.serial.value : this.serial,
      dateStart: data.dateStart.present ? data.dateStart.value : this.dateStart,
      dateEnd: data.dateEnd.present ? data.dateEnd.value : this.dateEnd,
      totalCost: data.totalCost.present ? data.totalCost.value : this.totalCost,
      receivedPayment: data.receivedPayment.present
          ? data.receivedPayment.value
          : this.receivedPayment,
      remainingBalance: data.remainingBalance.present
          ? data.remainingBalance.value
          : this.remainingBalance,
      status: data.status.present ? data.status.value : this.status,
      remarks: data.remarks.present ? data.remarks.value : this.remarks,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LabourJobRow(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('serial: $serial, ')
          ..write('dateStart: $dateStart, ')
          ..write('dateEnd: $dateEnd, ')
          ..write('totalCost: $totalCost, ')
          ..write('receivedPayment: $receivedPayment, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('status: $status, ')
          ..write('remarks: $remarks, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerUid,
    serial,
    dateStart,
    dateEnd,
    totalCost,
    receivedPayment,
    remainingBalance,
    status,
    remarks,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LabourJobRow &&
          other.id == this.id &&
          other.ownerUid == this.ownerUid &&
          other.serial == this.serial &&
          other.dateStart == this.dateStart &&
          other.dateEnd == this.dateEnd &&
          other.totalCost == this.totalCost &&
          other.receivedPayment == this.receivedPayment &&
          other.remainingBalance == this.remainingBalance &&
          other.status == this.status &&
          other.remarks == this.remarks &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class LabourJobsCompanion extends UpdateCompanion<LabourJobRow> {
  final Value<String> id;
  final Value<String> ownerUid;
  final Value<int> serial;
  final Value<int> dateStart;
  final Value<int> dateEnd;
  final Value<double> totalCost;
  final Value<double> receivedPayment;
  final Value<double> remainingBalance;
  final Value<String> status;
  final Value<String> remarks;
  final Value<int?> createdAt;
  final Value<int?> updatedAt;
  final Value<int> rowid;
  const LabourJobsCompanion({
    this.id = const Value.absent(),
    this.ownerUid = const Value.absent(),
    this.serial = const Value.absent(),
    this.dateStart = const Value.absent(),
    this.dateEnd = const Value.absent(),
    this.totalCost = const Value.absent(),
    this.receivedPayment = const Value.absent(),
    this.remainingBalance = const Value.absent(),
    this.status = const Value.absent(),
    this.remarks = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LabourJobsCompanion.insert({
    required String id,
    required String ownerUid,
    required int serial,
    required int dateStart,
    required int dateEnd,
    required double totalCost,
    required double receivedPayment,
    required double remainingBalance,
    required String status,
    required String remarks,
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerUid = Value(ownerUid),
       serial = Value(serial),
       dateStart = Value(dateStart),
       dateEnd = Value(dateEnd),
       totalCost = Value(totalCost),
       receivedPayment = Value(receivedPayment),
       remainingBalance = Value(remainingBalance),
       status = Value(status),
       remarks = Value(remarks);
  static Insertable<LabourJobRow> custom({
    Expression<String>? id,
    Expression<String>? ownerUid,
    Expression<int>? serial,
    Expression<int>? dateStart,
    Expression<int>? dateEnd,
    Expression<double>? totalCost,
    Expression<double>? receivedPayment,
    Expression<double>? remainingBalance,
    Expression<String>? status,
    Expression<String>? remarks,
    Expression<int>? createdAt,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerUid != null) 'owner_uid': ownerUid,
      if (serial != null) 'serial': serial,
      if (dateStart != null) 'date_start': dateStart,
      if (dateEnd != null) 'date_end': dateEnd,
      if (totalCost != null) 'total_cost': totalCost,
      if (receivedPayment != null) 'received_payment': receivedPayment,
      if (remainingBalance != null) 'remaining_balance': remainingBalance,
      if (status != null) 'status': status,
      if (remarks != null) 'remarks': remarks,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LabourJobsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerUid,
    Value<int>? serial,
    Value<int>? dateStart,
    Value<int>? dateEnd,
    Value<double>? totalCost,
    Value<double>? receivedPayment,
    Value<double>? remainingBalance,
    Value<String>? status,
    Value<String>? remarks,
    Value<int?>? createdAt,
    Value<int?>? updatedAt,
    Value<int>? rowid,
  }) {
    return LabourJobsCompanion(
      id: id ?? this.id,
      ownerUid: ownerUid ?? this.ownerUid,
      serial: serial ?? this.serial,
      dateStart: dateStart ?? this.dateStart,
      dateEnd: dateEnd ?? this.dateEnd,
      totalCost: totalCost ?? this.totalCost,
      receivedPayment: receivedPayment ?? this.receivedPayment,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      status: status ?? this.status,
      remarks: remarks ?? this.remarks,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerUid.present) {
      map['owner_uid'] = Variable<String>(ownerUid.value);
    }
    if (serial.present) {
      map['serial'] = Variable<int>(serial.value);
    }
    if (dateStart.present) {
      map['date_start'] = Variable<int>(dateStart.value);
    }
    if (dateEnd.present) {
      map['date_end'] = Variable<int>(dateEnd.value);
    }
    if (totalCost.present) {
      map['total_cost'] = Variable<double>(totalCost.value);
    }
    if (receivedPayment.present) {
      map['received_payment'] = Variable<double>(receivedPayment.value);
    }
    if (remainingBalance.present) {
      map['remaining_balance'] = Variable<double>(remainingBalance.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (remarks.present) {
      map['remarks'] = Variable<String>(remarks.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LabourJobsCompanion(')
          ..write('id: $id, ')
          ..write('ownerUid: $ownerUid, ')
          ..write('serial: $serial, ')
          ..write('dateStart: $dateStart, ')
          ..write('dateEnd: $dateEnd, ')
          ..write('totalCost: $totalCost, ')
          ..write('receivedPayment: $receivedPayment, ')
          ..write('remainingBalance: $remainingBalance, ')
          ..write('status: $status, ')
          ..write('remarks: $remarks, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $SessionRowsTable sessionRows = $SessionRowsTable(this);
  late final $SerialCountersTable serialCounters = $SerialCountersTable(this);
  late final $MarketsTable markets = $MarketsTable(this);
  late final $ShipmentsTable shipments = $ShipmentsTable(this);
  late final $CashEntriesTable cashEntries = $CashEntriesTable(this);
  late final $LabourJobsTable labourJobs = $LabourJobsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    accounts,
    sessionRows,
    serialCounters,
    markets,
    shipments,
    cashEntries,
    labourJobs,
  ];
}

typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      required String uid,
      Value<String?> email,
      Value<String?> passwordHash,
      Value<String?> salt,
      Value<bool> isAnonymous,
      required int createdAt,
      Value<int> rowid,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<String> uid,
      Value<String?> email,
      Value<String?> passwordHash,
      Value<String?> salt,
      Value<bool> isAnonymous,
      Value<int> createdAt,
      Value<int> rowid,
    });

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAnonymous => $composableBuilder(
    column: $table.isAnonymous,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get salt => $composableBuilder(
    column: $table.salt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAnonymous => $composableBuilder(
    column: $table.isAnonymous,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get passwordHash => $composableBuilder(
    column: $table.passwordHash,
    builder: (column) => column,
  );

  GeneratedColumn<String> get salt =>
      $composableBuilder(column: $table.salt, builder: (column) => column);

  GeneratedColumn<bool> get isAnonymous => $composableBuilder(
    column: $table.isAnonymous,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          AccountRow,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (
            AccountRow,
            BaseReferences<_$AppDatabase, $AccountsTable, AccountRow>,
          ),
          AccountRow,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String?> passwordHash = const Value.absent(),
                Value<String?> salt = const Value.absent(),
                Value<bool> isAnonymous = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                uid: uid,
                email: email,
                passwordHash: passwordHash,
                salt: salt,
                isAnonymous: isAnonymous,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uid,
                Value<String?> email = const Value.absent(),
                Value<String?> passwordHash = const Value.absent(),
                Value<String?> salt = const Value.absent(),
                Value<bool> isAnonymous = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                uid: uid,
                email: email,
                passwordHash: passwordHash,
                salt: salt,
                isAnonymous: isAnonymous,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      AccountRow,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (AccountRow, BaseReferences<_$AppDatabase, $AccountsTable, AccountRow>),
      AccountRow,
      PrefetchHooks Function()
    >;
typedef $$SessionRowsTableCreateCompanionBuilder =
    SessionRowsCompanion Function({Value<int> id, Value<String?> currentUid});
typedef $$SessionRowsTableUpdateCompanionBuilder =
    SessionRowsCompanion Function({Value<int> id, Value<String?> currentUid});

class $$SessionRowsTableFilterComposer
    extends Composer<_$AppDatabase, $SessionRowsTable> {
  $$SessionRowsTableFilterComposer({
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

  ColumnFilters<String> get currentUid => $composableBuilder(
    column: $table.currentUid,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SessionRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionRowsTable> {
  $$SessionRowsTableOrderingComposer({
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

  ColumnOrderings<String> get currentUid => $composableBuilder(
    column: $table.currentUid,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SessionRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionRowsTable> {
  $$SessionRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get currentUid => $composableBuilder(
    column: $table.currentUid,
    builder: (column) => column,
  );
}

class $$SessionRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SessionRowsTable,
          SessionRow,
          $$SessionRowsTableFilterComposer,
          $$SessionRowsTableOrderingComposer,
          $$SessionRowsTableAnnotationComposer,
          $$SessionRowsTableCreateCompanionBuilder,
          $$SessionRowsTableUpdateCompanionBuilder,
          (
            SessionRow,
            BaseReferences<_$AppDatabase, $SessionRowsTable, SessionRow>,
          ),
          SessionRow,
          PrefetchHooks Function()
        > {
  $$SessionRowsTableTableManager(_$AppDatabase db, $SessionRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> currentUid = const Value.absent(),
              }) => SessionRowsCompanion(id: id, currentUid: currentUid),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> currentUid = const Value.absent(),
              }) => SessionRowsCompanion.insert(id: id, currentUid: currentUid),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SessionRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SessionRowsTable,
      SessionRow,
      $$SessionRowsTableFilterComposer,
      $$SessionRowsTableOrderingComposer,
      $$SessionRowsTableAnnotationComposer,
      $$SessionRowsTableCreateCompanionBuilder,
      $$SessionRowsTableUpdateCompanionBuilder,
      (
        SessionRow,
        BaseReferences<_$AppDatabase, $SessionRowsTable, SessionRow>,
      ),
      SessionRow,
      PrefetchHooks Function()
    >;
typedef $$SerialCountersTableCreateCompanionBuilder =
    SerialCountersCompanion Function({
      required String uid,
      Value<int> shipmentNext,
      Value<int> labourNext,
      Value<int> rowid,
    });
typedef $$SerialCountersTableUpdateCompanionBuilder =
    SerialCountersCompanion Function({
      Value<String> uid,
      Value<int> shipmentNext,
      Value<int> labourNext,
      Value<int> rowid,
    });

class $$SerialCountersTableFilterComposer
    extends Composer<_$AppDatabase, $SerialCountersTable> {
  $$SerialCountersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shipmentNext => $composableBuilder(
    column: $table.shipmentNext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get labourNext => $composableBuilder(
    column: $table.labourNext,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SerialCountersTableOrderingComposer
    extends Composer<_$AppDatabase, $SerialCountersTable> {
  $$SerialCountersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get uid => $composableBuilder(
    column: $table.uid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shipmentNext => $composableBuilder(
    column: $table.shipmentNext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get labourNext => $composableBuilder(
    column: $table.labourNext,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SerialCountersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SerialCountersTable> {
  $$SerialCountersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get uid =>
      $composableBuilder(column: $table.uid, builder: (column) => column);

  GeneratedColumn<int> get shipmentNext => $composableBuilder(
    column: $table.shipmentNext,
    builder: (column) => column,
  );

  GeneratedColumn<int> get labourNext => $composableBuilder(
    column: $table.labourNext,
    builder: (column) => column,
  );
}

class $$SerialCountersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SerialCountersTable,
          SerialCounterRow,
          $$SerialCountersTableFilterComposer,
          $$SerialCountersTableOrderingComposer,
          $$SerialCountersTableAnnotationComposer,
          $$SerialCountersTableCreateCompanionBuilder,
          $$SerialCountersTableUpdateCompanionBuilder,
          (
            SerialCounterRow,
            BaseReferences<
              _$AppDatabase,
              $SerialCountersTable,
              SerialCounterRow
            >,
          ),
          SerialCounterRow,
          PrefetchHooks Function()
        > {
  $$SerialCountersTableTableManager(
    _$AppDatabase db,
    $SerialCountersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SerialCountersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SerialCountersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SerialCountersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> uid = const Value.absent(),
                Value<int> shipmentNext = const Value.absent(),
                Value<int> labourNext = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SerialCountersCompanion(
                uid: uid,
                shipmentNext: shipmentNext,
                labourNext: labourNext,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String uid,
                Value<int> shipmentNext = const Value.absent(),
                Value<int> labourNext = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SerialCountersCompanion.insert(
                uid: uid,
                shipmentNext: shipmentNext,
                labourNext: labourNext,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SerialCountersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SerialCountersTable,
      SerialCounterRow,
      $$SerialCountersTableFilterComposer,
      $$SerialCountersTableOrderingComposer,
      $$SerialCountersTableAnnotationComposer,
      $$SerialCountersTableCreateCompanionBuilder,
      $$SerialCountersTableUpdateCompanionBuilder,
      (
        SerialCounterRow,
        BaseReferences<_$AppDatabase, $SerialCountersTable, SerialCounterRow>,
      ),
      SerialCounterRow,
      PrefetchHooks Function()
    >;
typedef $$MarketsTableCreateCompanionBuilder =
    MarketsCompanion Function({
      required String id,
      required String ownerUid,
      required String name,
      Value<int> cashSerialNext,
      Value<int?> createdAt,
      Value<int?> updatedAt,
      Value<int> rowid,
    });
typedef $$MarketsTableUpdateCompanionBuilder =
    MarketsCompanion Function({
      Value<String> id,
      Value<String> ownerUid,
      Value<String> name,
      Value<int> cashSerialNext,
      Value<int?> createdAt,
      Value<int?> updatedAt,
      Value<int> rowid,
    });

class $$MarketsTableFilterComposer
    extends Composer<_$AppDatabase, $MarketsTable> {
  $$MarketsTableFilterComposer({
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

  ColumnFilters<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cashSerialNext => $composableBuilder(
    column: $table.cashSerialNext,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MarketsTableOrderingComposer
    extends Composer<_$AppDatabase, $MarketsTable> {
  $$MarketsTableOrderingComposer({
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

  ColumnOrderings<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cashSerialNext => $composableBuilder(
    column: $table.cashSerialNext,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MarketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MarketsTable> {
  $$MarketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get cashSerialNext => $composableBuilder(
    column: $table.cashSerialNext,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$MarketsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MarketsTable,
          MarketRow,
          $$MarketsTableFilterComposer,
          $$MarketsTableOrderingComposer,
          $$MarketsTableAnnotationComposer,
          $$MarketsTableCreateCompanionBuilder,
          $$MarketsTableUpdateCompanionBuilder,
          (MarketRow, BaseReferences<_$AppDatabase, $MarketsTable, MarketRow>),
          MarketRow,
          PrefetchHooks Function()
        > {
  $$MarketsTableTableManager(_$AppDatabase db, $MarketsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MarketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MarketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MarketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerUid = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> cashSerialNext = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MarketsCompanion(
                id: id,
                ownerUid: ownerUid,
                name: name,
                cashSerialNext: cashSerialNext,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerUid,
                required String name,
                Value<int> cashSerialNext = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MarketsCompanion.insert(
                id: id,
                ownerUid: ownerUid,
                name: name,
                cashSerialNext: cashSerialNext,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MarketsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MarketsTable,
      MarketRow,
      $$MarketsTableFilterComposer,
      $$MarketsTableOrderingComposer,
      $$MarketsTableAnnotationComposer,
      $$MarketsTableCreateCompanionBuilder,
      $$MarketsTableUpdateCompanionBuilder,
      (MarketRow, BaseReferences<_$AppDatabase, $MarketsTable, MarketRow>),
      MarketRow,
      PrefetchHooks Function()
    >;
typedef $$ShipmentsTableCreateCompanionBuilder =
    ShipmentsCompanion Function({
      required String id,
      required String ownerUid,
      required int serial,
      required int date,
      required String marketId,
      required String marketName,
      required String buyerName,
      required double quantity,
      required double totalAmount,
      required double amountReceived,
      required double balance,
      required String status,
      required String remarks,
      Value<int?> createdAt,
      Value<int?> updatedAt,
      Value<int> rowid,
    });
typedef $$ShipmentsTableUpdateCompanionBuilder =
    ShipmentsCompanion Function({
      Value<String> id,
      Value<String> ownerUid,
      Value<int> serial,
      Value<int> date,
      Value<String> marketId,
      Value<String> marketName,
      Value<String> buyerName,
      Value<double> quantity,
      Value<double> totalAmount,
      Value<double> amountReceived,
      Value<double> balance,
      Value<String> status,
      Value<String> remarks,
      Value<int?> createdAt,
      Value<int?> updatedAt,
      Value<int> rowid,
    });

class $$ShipmentsTableFilterComposer
    extends Composer<_$AppDatabase, $ShipmentsTable> {
  $$ShipmentsTableFilterComposer({
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

  ColumnFilters<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marketId => $composableBuilder(
    column: $table.marketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marketName => $composableBuilder(
    column: $table.marketName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get buyerName => $composableBuilder(
    column: $table.buyerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountReceived => $composableBuilder(
    column: $table.amountReceived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShipmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShipmentsTable> {
  $$ShipmentsTableOrderingComposer({
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

  ColumnOrderings<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marketId => $composableBuilder(
    column: $table.marketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marketName => $composableBuilder(
    column: $table.marketName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get buyerName => $composableBuilder(
    column: $table.buyerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountReceived => $composableBuilder(
    column: $table.amountReceived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShipmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShipmentsTable> {
  $$ShipmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<int> get serial =>
      $composableBuilder(column: $table.serial, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get marketId =>
      $composableBuilder(column: $table.marketId, builder: (column) => column);

  GeneratedColumn<String> get marketName => $composableBuilder(
    column: $table.marketName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get buyerName =>
      $composableBuilder(column: $table.buyerName, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountReceived => $composableBuilder(
    column: $table.amountReceived,
    builder: (column) => column,
  );

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ShipmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShipmentsTable,
          ShipmentRow,
          $$ShipmentsTableFilterComposer,
          $$ShipmentsTableOrderingComposer,
          $$ShipmentsTableAnnotationComposer,
          $$ShipmentsTableCreateCompanionBuilder,
          $$ShipmentsTableUpdateCompanionBuilder,
          (
            ShipmentRow,
            BaseReferences<_$AppDatabase, $ShipmentsTable, ShipmentRow>,
          ),
          ShipmentRow,
          PrefetchHooks Function()
        > {
  $$ShipmentsTableTableManager(_$AppDatabase db, $ShipmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShipmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShipmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShipmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerUid = const Value.absent(),
                Value<int> serial = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<String> marketId = const Value.absent(),
                Value<String> marketName = const Value.absent(),
                Value<String> buyerName = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> amountReceived = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> remarks = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShipmentsCompanion(
                id: id,
                ownerUid: ownerUid,
                serial: serial,
                date: date,
                marketId: marketId,
                marketName: marketName,
                buyerName: buyerName,
                quantity: quantity,
                totalAmount: totalAmount,
                amountReceived: amountReceived,
                balance: balance,
                status: status,
                remarks: remarks,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerUid,
                required int serial,
                required int date,
                required String marketId,
                required String marketName,
                required String buyerName,
                required double quantity,
                required double totalAmount,
                required double amountReceived,
                required double balance,
                required String status,
                required String remarks,
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShipmentsCompanion.insert(
                id: id,
                ownerUid: ownerUid,
                serial: serial,
                date: date,
                marketId: marketId,
                marketName: marketName,
                buyerName: buyerName,
                quantity: quantity,
                totalAmount: totalAmount,
                amountReceived: amountReceived,
                balance: balance,
                status: status,
                remarks: remarks,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShipmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShipmentsTable,
      ShipmentRow,
      $$ShipmentsTableFilterComposer,
      $$ShipmentsTableOrderingComposer,
      $$ShipmentsTableAnnotationComposer,
      $$ShipmentsTableCreateCompanionBuilder,
      $$ShipmentsTableUpdateCompanionBuilder,
      (
        ShipmentRow,
        BaseReferences<_$AppDatabase, $ShipmentsTable, ShipmentRow>,
      ),
      ShipmentRow,
      PrefetchHooks Function()
    >;
typedef $$CashEntriesTableCreateCompanionBuilder =
    CashEntriesCompanion Function({
      required String id,
      required String ownerUid,
      required String marketId,
      required int serial,
      required int date,
      required double amountReceived,
      required double payments,
      required double previousCash,
      required double cashAvailable,
      required double balance,
      required String remarks,
      Value<int?> createdAt,
      Value<int?> updatedAt,
      Value<int> rowid,
    });
typedef $$CashEntriesTableUpdateCompanionBuilder =
    CashEntriesCompanion Function({
      Value<String> id,
      Value<String> ownerUid,
      Value<String> marketId,
      Value<int> serial,
      Value<int> date,
      Value<double> amountReceived,
      Value<double> payments,
      Value<double> previousCash,
      Value<double> cashAvailable,
      Value<double> balance,
      Value<String> remarks,
      Value<int?> createdAt,
      Value<int?> updatedAt,
      Value<int> rowid,
    });

class $$CashEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CashEntriesTable> {
  $$CashEntriesTableFilterComposer({
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

  ColumnFilters<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get marketId => $composableBuilder(
    column: $table.marketId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountReceived => $composableBuilder(
    column: $table.amountReceived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get payments => $composableBuilder(
    column: $table.payments,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get previousCash => $composableBuilder(
    column: $table.previousCash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cashAvailable => $composableBuilder(
    column: $table.cashAvailable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CashEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CashEntriesTable> {
  $$CashEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get marketId => $composableBuilder(
    column: $table.marketId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountReceived => $composableBuilder(
    column: $table.amountReceived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get payments => $composableBuilder(
    column: $table.payments,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get previousCash => $composableBuilder(
    column: $table.previousCash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cashAvailable => $composableBuilder(
    column: $table.cashAvailable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get balance => $composableBuilder(
    column: $table.balance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CashEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CashEntriesTable> {
  $$CashEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<String> get marketId =>
      $composableBuilder(column: $table.marketId, builder: (column) => column);

  GeneratedColumn<int> get serial =>
      $composableBuilder(column: $table.serial, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get amountReceived => $composableBuilder(
    column: $table.amountReceived,
    builder: (column) => column,
  );

  GeneratedColumn<double> get payments =>
      $composableBuilder(column: $table.payments, builder: (column) => column);

  GeneratedColumn<double> get previousCash => $composableBuilder(
    column: $table.previousCash,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cashAvailable => $composableBuilder(
    column: $table.cashAvailable,
    builder: (column) => column,
  );

  GeneratedColumn<double> get balance =>
      $composableBuilder(column: $table.balance, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CashEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CashEntriesTable,
          CashEntryRow,
          $$CashEntriesTableFilterComposer,
          $$CashEntriesTableOrderingComposer,
          $$CashEntriesTableAnnotationComposer,
          $$CashEntriesTableCreateCompanionBuilder,
          $$CashEntriesTableUpdateCompanionBuilder,
          (
            CashEntryRow,
            BaseReferences<_$AppDatabase, $CashEntriesTable, CashEntryRow>,
          ),
          CashEntryRow,
          PrefetchHooks Function()
        > {
  $$CashEntriesTableTableManager(_$AppDatabase db, $CashEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CashEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CashEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CashEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerUid = const Value.absent(),
                Value<String> marketId = const Value.absent(),
                Value<int> serial = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<double> amountReceived = const Value.absent(),
                Value<double> payments = const Value.absent(),
                Value<double> previousCash = const Value.absent(),
                Value<double> cashAvailable = const Value.absent(),
                Value<double> balance = const Value.absent(),
                Value<String> remarks = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashEntriesCompanion(
                id: id,
                ownerUid: ownerUid,
                marketId: marketId,
                serial: serial,
                date: date,
                amountReceived: amountReceived,
                payments: payments,
                previousCash: previousCash,
                cashAvailable: cashAvailable,
                balance: balance,
                remarks: remarks,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerUid,
                required String marketId,
                required int serial,
                required int date,
                required double amountReceived,
                required double payments,
                required double previousCash,
                required double cashAvailable,
                required double balance,
                required String remarks,
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CashEntriesCompanion.insert(
                id: id,
                ownerUid: ownerUid,
                marketId: marketId,
                serial: serial,
                date: date,
                amountReceived: amountReceived,
                payments: payments,
                previousCash: previousCash,
                cashAvailable: cashAvailable,
                balance: balance,
                remarks: remarks,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CashEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CashEntriesTable,
      CashEntryRow,
      $$CashEntriesTableFilterComposer,
      $$CashEntriesTableOrderingComposer,
      $$CashEntriesTableAnnotationComposer,
      $$CashEntriesTableCreateCompanionBuilder,
      $$CashEntriesTableUpdateCompanionBuilder,
      (
        CashEntryRow,
        BaseReferences<_$AppDatabase, $CashEntriesTable, CashEntryRow>,
      ),
      CashEntryRow,
      PrefetchHooks Function()
    >;
typedef $$LabourJobsTableCreateCompanionBuilder =
    LabourJobsCompanion Function({
      required String id,
      required String ownerUid,
      required int serial,
      required int dateStart,
      required int dateEnd,
      required double totalCost,
      required double receivedPayment,
      required double remainingBalance,
      required String status,
      required String remarks,
      Value<int?> createdAt,
      Value<int?> updatedAt,
      Value<int> rowid,
    });
typedef $$LabourJobsTableUpdateCompanionBuilder =
    LabourJobsCompanion Function({
      Value<String> id,
      Value<String> ownerUid,
      Value<int> serial,
      Value<int> dateStart,
      Value<int> dateEnd,
      Value<double> totalCost,
      Value<double> receivedPayment,
      Value<double> remainingBalance,
      Value<String> status,
      Value<String> remarks,
      Value<int?> createdAt,
      Value<int?> updatedAt,
      Value<int> rowid,
    });

class $$LabourJobsTableFilterComposer
    extends Composer<_$AppDatabase, $LabourJobsTable> {
  $$LabourJobsTableFilterComposer({
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

  ColumnFilters<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dateStart => $composableBuilder(
    column: $table.dateStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dateEnd => $composableBuilder(
    column: $table.dateEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get receivedPayment => $composableBuilder(
    column: $table.receivedPayment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LabourJobsTableOrderingComposer
    extends Composer<_$AppDatabase, $LabourJobsTable> {
  $$LabourJobsTableOrderingComposer({
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

  ColumnOrderings<String> get ownerUid => $composableBuilder(
    column: $table.ownerUid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get serial => $composableBuilder(
    column: $table.serial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dateStart => $composableBuilder(
    column: $table.dateStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dateEnd => $composableBuilder(
    column: $table.dateEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalCost => $composableBuilder(
    column: $table.totalCost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get receivedPayment => $composableBuilder(
    column: $table.receivedPayment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get remarks => $composableBuilder(
    column: $table.remarks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LabourJobsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LabourJobsTable> {
  $$LabourJobsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerUid =>
      $composableBuilder(column: $table.ownerUid, builder: (column) => column);

  GeneratedColumn<int> get serial =>
      $composableBuilder(column: $table.serial, builder: (column) => column);

  GeneratedColumn<int> get dateStart =>
      $composableBuilder(column: $table.dateStart, builder: (column) => column);

  GeneratedColumn<int> get dateEnd =>
      $composableBuilder(column: $table.dateEnd, builder: (column) => column);

  GeneratedColumn<double> get totalCost =>
      $composableBuilder(column: $table.totalCost, builder: (column) => column);

  GeneratedColumn<double> get receivedPayment => $composableBuilder(
    column: $table.receivedPayment,
    builder: (column) => column,
  );

  GeneratedColumn<double> get remainingBalance => $composableBuilder(
    column: $table.remainingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get remarks =>
      $composableBuilder(column: $table.remarks, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LabourJobsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LabourJobsTable,
          LabourJobRow,
          $$LabourJobsTableFilterComposer,
          $$LabourJobsTableOrderingComposer,
          $$LabourJobsTableAnnotationComposer,
          $$LabourJobsTableCreateCompanionBuilder,
          $$LabourJobsTableUpdateCompanionBuilder,
          (
            LabourJobRow,
            BaseReferences<_$AppDatabase, $LabourJobsTable, LabourJobRow>,
          ),
          LabourJobRow,
          PrefetchHooks Function()
        > {
  $$LabourJobsTableTableManager(_$AppDatabase db, $LabourJobsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LabourJobsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LabourJobsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LabourJobsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerUid = const Value.absent(),
                Value<int> serial = const Value.absent(),
                Value<int> dateStart = const Value.absent(),
                Value<int> dateEnd = const Value.absent(),
                Value<double> totalCost = const Value.absent(),
                Value<double> receivedPayment = const Value.absent(),
                Value<double> remainingBalance = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> remarks = const Value.absent(),
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabourJobsCompanion(
                id: id,
                ownerUid: ownerUid,
                serial: serial,
                dateStart: dateStart,
                dateEnd: dateEnd,
                totalCost: totalCost,
                receivedPayment: receivedPayment,
                remainingBalance: remainingBalance,
                status: status,
                remarks: remarks,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerUid,
                required int serial,
                required int dateStart,
                required int dateEnd,
                required double totalCost,
                required double receivedPayment,
                required double remainingBalance,
                required String status,
                required String remarks,
                Value<int?> createdAt = const Value.absent(),
                Value<int?> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LabourJobsCompanion.insert(
                id: id,
                ownerUid: ownerUid,
                serial: serial,
                dateStart: dateStart,
                dateEnd: dateEnd,
                totalCost: totalCost,
                receivedPayment: receivedPayment,
                remainingBalance: remainingBalance,
                status: status,
                remarks: remarks,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LabourJobsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LabourJobsTable,
      LabourJobRow,
      $$LabourJobsTableFilterComposer,
      $$LabourJobsTableOrderingComposer,
      $$LabourJobsTableAnnotationComposer,
      $$LabourJobsTableCreateCompanionBuilder,
      $$LabourJobsTableUpdateCompanionBuilder,
      (
        LabourJobRow,
        BaseReferences<_$AppDatabase, $LabourJobsTable, LabourJobRow>,
      ),
      LabourJobRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$SessionRowsTableTableManager get sessionRows =>
      $$SessionRowsTableTableManager(_db, _db.sessionRows);
  $$SerialCountersTableTableManager get serialCounters =>
      $$SerialCountersTableTableManager(_db, _db.serialCounters);
  $$MarketsTableTableManager get markets =>
      $$MarketsTableTableManager(_db, _db.markets);
  $$ShipmentsTableTableManager get shipments =>
      $$ShipmentsTableTableManager(_db, _db.shipments);
  $$CashEntriesTableTableManager get cashEntries =>
      $$CashEntriesTableTableManager(_db, _db.cashEntries);
  $$LabourJobsTableTableManager get labourJobs =>
      $$LabourJobsTableTableManager(_db, _db.labourJobs);
}
