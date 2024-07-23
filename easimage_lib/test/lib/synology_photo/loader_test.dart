import 'dart:convert';
import 'dart:io';

import 'package:http/io_client.dart';
import 'package:test/test.dart';

import 'package:http/http.dart';
import 'package:xml/xml.dart';

void main() {
  // Fonction pour récupérer la liste des chemins d'images
  Future<List<String>> getImagesFromSynologyPhotos() async {
    // Remplacer par les informations de votre NAS Synology
    const String nasAddress = "https://192.168.31.4:5001/";
    const String username = "your-username";
    const String password = "your-password";

    final context = SecurityContext.defaultContext;
    final HttpClient httpClient = HttpClient(context: context)
      ..badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
    final client = IOClient(httpClient);

    final Uri photosUrl =
        Uri.parse("$nasAddress/webdav/homes/$username/Photos/");
    final Response response = await client.get(photosUrl, headers: {
      'Authorization': 'Basic ${base64Encode('$username:$password'.codeUnits)}'
    });

    if (response.statusCode == 200) {
      final xmlDocument = XmlDocument.parse(response.body);
      final List<String> imagePaths = [];

      for (final xmlElement in xmlDocument.findElements('D:entry')) {
        final resourceElement = xmlElement.findElements('D:resource').first;
        String href = resourceElement.attributes
            .firstWhere((p0) => p0.name.local == 'href')
            .value;
        if (href.endsWith('.jpg') || href.endsWith('.png')) {
          imagePaths.add(href);
        }
      }

      return imagePaths;
    } else {
      throw Exception('Erreur : ${response.statusCode}');
    }
  }

  test('Load Synology Photo', () async {
    //const ulr = "smb://cubalibre.local/photo/";
    //const ip = "";
    //const curl =
    //    "webapi/entry.cgi?api=SYNO.Foto.Browse.Album&version=1&device_name=test&method=list&offset=0&limit=100";

    final List<String> imagePaths = await getImagesFromSynologyPhotos();
    print(imagePaths);
  });
}
