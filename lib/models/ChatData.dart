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
import 'package:flutter/foundation.dart';

@immutable
class Chatdata extends Model {
  static const classType = const ChatdataType();
  final String id;
  final String message;
  final TemporalTimestamp createdAt;
  final TemporalTimestamp updatedAt;
  final String chatId;
  final String senderId;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  const Chatdata._internal(
      {@required this.id,
      this.message,
      this.createdAt,
      this.updatedAt,
      this.chatId,
      this.senderId});

  factory Chatdata(
      {String id,
      String message,
      TemporalTimestamp createdAt,
      TemporalTimestamp updatedAt,
      String chatId,
      String senderId}) {
    return Chatdata._internal(
        id: id == null ? UUID.getUUID() : id,
        message: message,
        createdAt: createdAt,
        updatedAt: updatedAt,
        chatId: chatId,
        senderId: senderId);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Chatdata &&
        id == other.id &&
        message == other.message &&
        createdAt == other.createdAt &&
        updatedAt == other.updatedAt &&
        chatId == other.chatId &&
        senderId == other.senderId;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Chatdata {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("message=" + "$message" + ", ");
    buffer.write("createdAt=" +
        (createdAt != null ? createdAt.toString() : "null") +
        ", ");
    buffer.write("updatedAt=" +
        (updatedAt != null ? updatedAt.toString() : "null") +
        ", ");
    buffer.write("chatId=" + "$chatId" + ", ");
    buffer.write("senderId=" + "$senderId");
    buffer.write("}");

    return buffer.toString();
  }

  Chatdata copyWith(
      {String id,
      String message,
      TemporalTimestamp createdAt,
      TemporalTimestamp updatedAt,
      String chatId,
      String senderId}) {
    return Chatdata(
        id: id ?? this.id,
        message: message ?? this.message,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        chatId: chatId ?? this.chatId,
        senderId: senderId ?? this.senderId);
  }

  Chatdata.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        message = json['message'],
        createdAt = json['createdAt'] != null
            ? TemporalTimestamp.fromSeconds(json['createdAt'])
            : null,
        updatedAt = json['updatedAt'] != null
            ? TemporalTimestamp.fromSeconds(json['updatedAt'])
            : null,
        chatId = json['chatId'],
        senderId = json['senderId'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'message': message,
        'createdAt': createdAt?.toSeconds(),
        'updatedAt': updatedAt?.toSeconds(),
        'chatId': chatId,
        'senderId': senderId
      };

  static final QueryField ID = QueryField(fieldName: "chatdata.id");
  static final QueryField MESSAGE = QueryField(fieldName: "message");
  static final QueryField CREATEDAT = QueryField(fieldName: "createdAt");
  static final QueryField UPDATEDAT = QueryField(fieldName: "updatedAt");
  static final QueryField CHATID = QueryField(fieldName: "chatId");
  static final QueryField SENDERID = QueryField(fieldName: "senderId");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Chatdata";
    modelSchemaDefinition.pluralName = "Chatdata";

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
        key: Chatdata.MESSAGE,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Chatdata.CREATEDAT,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.timestamp)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Chatdata.UPDATEDAT,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.timestamp)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Chatdata.CHATID,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Chatdata.SENDERID,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));
  });
}

class ChatdataType extends ModelType<Chatdata> {
  const ChatdataType();

  @override
  Chatdata fromJson(Map<String, dynamic> jsonData) {
    return Chatdata.fromJson(jsonData);
  }
}
