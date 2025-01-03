import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:parkmycar_shared/parkmycar_shared.dart';
import '../repositories/db_repository.dart';

Future<Response> createItemHandler<T extends Identifiable,
        R extends DbRepository<T>, S extends Serializer<T>>(
    Request request, R repository, S serializer) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    T parsedItem = serializer.fromJson(json);
    if (parsedItem.isValid()) {
      T? newItem = await repository.create(parsedItem);

      if (newItem != null) {
        return Response.ok(
          jsonEncode(serializer.toJson(newItem)),
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        return Response.badRequest(body: objectNotCreated);
      }
    } else {
      return Response.badRequest(body: invalidInputData);
    }
  } catch (e) {
    return Response.badRequest();
  }
}

/// Get all
Future<Response> getAllItemsHandler<T extends Identifiable,
        R extends DbRepository<T>, S extends Serializer<T>>(
    Request request, R repository, S serializer) async {
  try {
    final persons = await repository.getAll();
    final body = persons.map((e) => serializer.toJson(e)).toList();
    return Response.ok(
      jsonEncode(body),
      headers: {'Content-Type': 'application/json'},
    );
  } catch (e) {
    return Response.badRequest();
  }
}

/// Get by id
Future<Response> getItemHandler<T extends Identifiable,
        R extends DbRepository<T>, S extends Serializer<T>>(
    Request request, String id, R repository, S serializer) async {
  try {
    final parsedId = int.tryParse(id);
    final item = await repository.getById(parsedId!);

    if (item != null) {
      return Response.ok(
        jsonEncode(serializer.toJson(item)),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      return Response.badRequest(body: objectNotFound);
    }
  } catch (e) {
    return Response.badRequest();
  }
}

/// Update
Future<Response> updateItemHandler<T extends Identifiable,
        R extends DbRepository<T>, S extends Serializer<T>>(
    Request request, R repository, S serializer) async {
  try {
    final data = await request.readAsString();
    final json = jsonDecode(data);
    T parsedItem = serializer.fromJson(json);
    if (parsedItem.isValid()) {
      T? updatedItem = await repository.update(parsedItem);

      if (updatedItem != null) {
        return Response.ok(
          jsonEncode(serializer.toJson(updatedItem)),
          headers: {'Content-Type': 'application/json'},
        );
      } else {
        return Response.badRequest(body: objectNotFound);
      }
    } else {
      return Response.badRequest(body: invalidInputData);
    }
  } catch (e) {
    return Response.badRequest();
  }
}

/// Delete by id
Future<Response> deleteItemHandler<T extends Identifiable,
        R extends DbRepository<T>, S extends Serializer<T>>(
    Request request, String id, R repository, S serializer) async {
  try {
    final parsedId = int.tryParse(id);
    bool deleted = await repository.delete(parsedId!);
    return (deleted)
        ? Response.ok('Item deleted.')
        : Response.badRequest(body: objectNotFound);
  } catch (e) {
    return Response.badRequest();
  }
}
