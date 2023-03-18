import 'dart:html';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:get/get.dart';
import '../SongsController/SongModel.dart';
import '../main.dart';

class Databasehelper {
  Databasehelper._privateConstructor();
  static final Databasehelper _instance = Databasehelper._privateConstructor();
  static Databasehelper get instance => _instance;

  static Databases? databases;
  static Storage? storages;

  init() {
    databases = Databases(client as Client);
    storages = Storage(client as Client);
  }

  Future<void> createsong(
      {required List title,
      required Uint8List image,
      required List<Uint8List> song,
      required List singer,
      required String category,
      required List songData,
      required imageData,
      required String album}) async {
    databases ??= Databases(client as Client);

    try {
      List song = songData.map((e) async {
       await  uploadSong(e, title.map((f) => f).toList()); 
   
      }).toList();

      File image = await uploadImage(imageData, title.map((f) => f).toList());
      await databases!.createDocument(
          databaseId: '6405d62f38aea554bf4b',
          collectionId: '6405d642c8e5331fadb7',
          documentId: ID.unique(),
          data: {
            'Singer': singer.toList(),
            'category': category,
            'image':
                'http://139.59.85.104/v1/storage/buckets/6406d520472e86d75e96/files/${image.$id}/view?project=6405d4c4e20b265a259d&mode=admin',
            'album': album,
            'song': song
                .map((e) =>
                    'http://139.59.85.104/v1/storage/buckets/6406d520472e86d75e96/files//view?project=6405d4c4e20b265a259d&mode=admin')
                .toList(),
            'title': title.toList()
          });
      Get.snackbar('Song added', '', duration: Duration(seconds: 3));
    } catch (e) {
      print(e);
      Get.snackbar('Something went wrong', e.toString(),
          duration: Duration(seconds: 5));
    }
  }

  Future<List<SongsModel>> getsong() async {
    databases ??= Databases(client as Client);
    try {
      final response = await databases!.listDocuments(
        databaseId: '6405d62f38aea554bf4b',
        collectionId: '6405d642c8e5331fadb7',
      );
      return response.documents
          .map((e) => SongsModel.fromJson(e.data))
          .toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<File> uploadSong(Uint8List songData, filename) async {
    storages ??= Storage(client as Client);
    try {
      final fileId = ID.unique();
      final file = InputFile(
        filename: filename,
        bytes: songData,
      );
      File uploadedFile = await storages!.createFile(
        bucketId: '6406d520472e86d75e96',
        fileId: fileId,
        file: file,
      );
      return uploadedFile;
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<File> uploadImage(Uint8List imageData, filename) async {
    storages ??= Storage(client as Client);
    try {
      final fileId = ID.unique();
      final file = InputFile(
        filename: filename,
        bytes: imageData,
      );
      File uploadedFile = await storages!.createFile(
        bucketId: '6406d520472e86d75e96',
        fileId: fileId,
        file: file,
      );
      return uploadedFile;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
}
