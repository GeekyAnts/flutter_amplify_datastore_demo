/*
* Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// ignore_for_file: public_member_api_docs

import 'package:amplify_datastore_plugin_interface/amplify_datastore_plugin_interface.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the Users type in your schema. */
@immutable
class Users extends Model {
  static const classType = const UsersType();
  final String id;
  final String username;
  final String email;
  final String bio;
  final String profileImage;
  final bool isVerified;
  final TemporalTimestamp createdAt;
  final List<String> chats;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const Users._internal(
      {@required this.id,
      this.username,
      this.email,
      this.bio,
      this.profileImage,
      this.isVerified,
      this.createdAt,
      this.chats});

  factory Users(
      {String id,
      String username,
      String email,
      String bio,
      String profileImage,
      bool isVerified,
      TemporalTimestamp createdAt,
      List<String> chats}) {
    return Users._internal(
        id: id == null ? UUID.getUUID() : id,
        username: username,
        email: email,
        bio: bio,
        profileImage: profileImage,
        isVerified: isVerified,
        createdAt: createdAt,
        chats: chats != null ? List.unmodifiable(chats) : chats);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Users &&
        id == other.id &&
        username == other.username &&
        email == other.email &&
        bio == other.bio &&
        profileImage == other.profileImage &&
        isVerified == other.isVerified &&
        createdAt == other.createdAt &&
        DeepCollectionEquality().equals(chats, other.chats);
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Users {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("username=" + "$username" + ", ");
    buffer.write("email=" + "$email" + ", ");
    buffer.write("bio=" + "$bio" + ", ");
    buffer.write("profileImage=" + "$profileImage" + ", ");
    buffer.write("isVerified=" +
        (isVerified != null ? isVerified.toString() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (createdAt != null ? createdAt.toString() : "null") +
        ", ");
    buffer.write("chats=" + (chats != null ? chats.toString() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Users copyWith(
      {String id,
      String username,
      String email,
      String bio,
      String profileImage,
      bool isVerified,
      TemporalTimestamp createdAt,
      List<String> chats}) {
    return Users(
        id: id ?? this.id,
        username: username ?? this.username,
        email: email ?? this.email,
        bio: bio ?? this.bio,
        profileImage: profileImage ?? this.profileImage,
        isVerified: isVerified ?? this.isVerified,
        createdAt: createdAt ?? this.createdAt,
        chats: chats ?? this.chats);
  }

  Users.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        email = json['email'],
        bio = json['bio'],
        profileImage = json['profileImage'],
        isVerified = json['isVerified'],
        createdAt = json['createdAt'] != null
            ? TemporalTimestamp.fromSeconds(json['createdAt'])
            : null,
        chats = json['chats']?.cast<String>();

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'bio': bio,
        'profileImage': profileImage,
        'isVerified': isVerified,
        'createdAt': createdAt?.toSeconds(),
        'chats': chats
      };

  static final QueryField ID = QueryField(fieldName: "users.id");
  static final QueryField USERNAME = QueryField(fieldName: "username");
  static final QueryField EMAIL = QueryField(fieldName: "email");
  static final QueryField BIO = QueryField(fieldName: "bio");
  static final QueryField PROFILEIMAGE = QueryField(fieldName: "profileImage");
  static final QueryField ISVERIFIED = QueryField(fieldName: "isVerified");
  static final QueryField CREATEDAT = QueryField(fieldName: "createdAt");
  static final QueryField CHATS = QueryField(fieldName: "chats");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Users";
    modelSchemaDefinition.pluralName = "Users";

    modelSchemaDefinition.authRules = [
      AuthRule(authStrategy: AuthStrategy.PUBLIC, operations: [
        ModelOperation.CREATE,
        ModelOperation.UPDATE,
        ModelOperation.DELETE,
        ModelOperation.READ
      ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Users.USERNAME,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Users.EMAIL,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Users.BIO,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Users.PROFILEIMAGE,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Users.ISVERIFIED,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Users.CREATEDAT,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.timestamp)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Users.CHATS,
        isRequired: false,
        isArray: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.collection,
            ofModelName: describeEnum(ModelFieldTypeEnum.string))));
  });
}

class UsersType extends ModelType<Users> {
  const UsersType();

  @override
  Users fromJson(Map<String, dynamic> jsonData) {
    return Users.fromJson(jsonData);
  }
}
