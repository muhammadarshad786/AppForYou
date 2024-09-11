import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Images'),
      ),
      body: ImageList(),
    );
  }
}

class ImageList extends StatefulWidget {
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  List<String> _imageUrls = [];
  List<String> _folderNames = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllImagesAndFolders();
  }

  Future<void> _fetchAllImagesAndFolders() async {
    try {
      List<String> urls = [];
      List<String> folders = [];

      // Set initial prefix to start listing
      final String prefix = '';

      // Fetch all folders and images
      await _fetchImagesAndFoldersFromPrefix(prefix, urls, folders);

      setState(() {
        _imageUrls = urls;
        _folderNames = folders;
        _isLoading = false;
      });

      // Print folder names to console
      print('Folders: ${_folderNames.join(', ')}');
    } catch (e) {
      print('Error fetching images and folders: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchImagesAndFoldersFromPrefix(String prefix, List<String> urls, List<String> folders) async {
    try {
      final ListResult result = await _storage.ref(prefix).listAll();

      for (var ref in result.items) {
        String url = await ref.getDownloadURL();
        urls.add(url);
      }

      for (var prefixRef in result.prefixes) {
        // Add folder name to the list
        folders.add(prefixRef.fullPath);
        // Recursively fetch images and folders from sub-folders
        await _fetchImagesAndFoldersFromPrefix(prefixRef.fullPath, urls, folders);
      }
    } catch (e) {
      print('Error fetching images and folders from prefix $prefix: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: _folderNames.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Folder: ${_folderNames[index]}'),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 2,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4.0,
                    mainAxisSpacing: 4.0,
                  ),
                  itemCount: _imageUrls.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FullScreenImage(url: _imageUrls[index]),
                          ),
                        );
                      },
                      child: CachedNetworkImage(
                        imageUrl: _imageUrls[index],
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}

class FullScreenImage extends StatelessWidget {
  final String url;

  FullScreenImage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Full Screen Image'),
      ),
      body: Center(
        child: CachedNetworkImage(
          imageUrl: url,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }
}
