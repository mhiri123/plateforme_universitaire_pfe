import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../home/views/home_screen.dart';

class NewsScreen extends StatelessWidget {
  final List<Map<String, String>> newsArticles = [
    {
      'title': 'New Features for the Platform',
      'description': 'We have introduced several new features to make the platform even more user-friendly.',
      'date': 'March 21, 2025',
      'image': 'https://source.unsplash.com/800x400/?technology,education',
    },
    {
      'title': 'Upcoming Webinars on Academic Transfers',
      'description': 'Join our upcoming webinars to learn about the latest updates on academic transfers and reorientation.',
      'date': 'March 19, 2025',
      'image': 'https://source.unsplash.com/800x400/?webinar,conference',
    },
    {
      'title': 'Platform Updates and Maintenance',
      'description': 'We will be conducting scheduled maintenance to improve system performance on March 25, 2025.',
      'date': 'March 18, 2025',
      'image': 'https://source.unsplash.com/800x400/?maintenance,technology',
    },
    {
      'title': 'Student Support Services Expanded',
      'description': 'We are expanding our student support services to include new online counseling options.',
      'date': 'March 15, 2025',
      'image': 'https://source.unsplash.com/800x400/?students,support',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Text(
          "News & Updates",
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: newsArticles.length,
          itemBuilder: (context, index) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.only(bottom: 16.0),
              elevation: 4.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      newsArticles[index]['image']!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          newsArticles[index]['title']!,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          newsArticles[index]['description']!,
                          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              newsArticles[index]['date']!,
                              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 18, color: Colors.red),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
