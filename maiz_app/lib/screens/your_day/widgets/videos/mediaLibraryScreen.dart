import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mAIz/data/services/media_service.dart';

class MediaLibraryScreen extends StatefulWidget {
  const MediaLibraryScreen({super.key});

  @override
  _MediaLibraryScreenState createState() => _MediaLibraryScreenState();
}

class _MediaLibraryScreenState extends State<MediaLibraryScreen> {
  String selectedEmotion = 'Regular';
  late Future<List<Map<String, String>>> videoList;
  Map<String, bool> isPlaying = {}; // Controla qué video se está reproduciendo

  @override
  void initState() {
    super.initState();
    videoList = MediaService.getVideosByEmotion(selectedEmotion);
  }

  void _updateEmotion(String newEmotion) {
    setState(() {
      selectedEmotion = newEmotion;
      videoList = MediaService.getVideosByEmotion(selectedEmotion);
      isPlaying.clear(); // Restablece el estado de reproducción
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Videos & Podcasts"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          // Selector de emoción
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: DropdownButtonFormField<String>(
              value: selectedEmotion,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDarkMode?  Colors.black38 : Colors.deepPurple.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              ),
              items: ['Deprimente', 'Triste', 'Regular', 'Feliz', 'Euforico']
                  .map((emotion) => DropdownMenuItem(
                        value: emotion,
                        child: Text(
                          emotion,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) _updateEmotion(value);
              },
            ),
          ),

          // Lista de videos
          Expanded(
            child: FutureBuilder<List<Map<String, String>>>(
              future: videoList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No hay videos disponibles."));
                }

                final videos = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    final video = videos[index];
                    final String? videoId = YoutubePlayer.convertUrlToId(video["videoUrl"]!);
                    final bool playing = isPlaying[videoId] ?? false;

                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.only(bottom: 20),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Miniatura o reproductor de YouTube
                          if (videoId != null)
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                              child: playing
                                  ? YoutubePlayer(
                                      controller: YoutubePlayerController(
                                        initialVideoId: videoId,
                                        flags: const YoutubePlayerFlags(
                                          autoPlay: true,
                                          mute: false,
                                        ),
                                      ),
                                      showVideoProgressIndicator: true,
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isPlaying[videoId] = true;
                                        });
                                      },
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                         Image.network(
                                            "https://img.youtube.com/vi/$videoId/0.jpg",
                                            width: double.infinity,
                                            height: 200,
                                            fit: BoxFit.cover,
                                            loadingBuilder: (context, child, loadingProgress) {
                                              if (loadingProgress == null) return child;
                                              return const Center(child: CircularProgressIndicator());
                                            },
                                            errorBuilder: (context, error, stackTrace) {
                                              print("Error cargando la miniatura: $error");  // <-- Para depurar el error
                                              return const Center(child: Text("Imagen no disponible"));
                                            },
                                          ),

                                          const Icon(
                                            Icons.play_circle_fill,
                                            size: 60,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                            ),

                          // Información del video
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  video["title"]!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Emoción: $selectedEmotion",
                                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
