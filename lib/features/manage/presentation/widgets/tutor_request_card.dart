import 'package:flutter/material.dart';
import 'package:perfect_super_admin/core/constants/colors.dart';
import 'package:perfect_super_admin/core/utils/responsive_config.dart';

class TutorRequestCard extends StatelessWidget {
  final String name;
  final String email;
  final String age;
  final String photoUrl;
  final String qualification;
  final List<Map<String, dynamic>> certificates;
  final List<Map<String,dynamic>> selectedCourses;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const TutorRequestCard({
    super.key,
    required this.name,
    required this.email,
    required this.age,
    required this.photoUrl,
    required this.qualification,
    required this.certificates,
    required this.selectedCourses,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final size = ResponsiveConfig(context);

    return GestureDetector(
      onTap: () => _showDetailsPopup(context, size),
      child: Card(
        color: PColors.backgrndPrimary,
        shadowColor: PColors.containerBackground,
        elevation: 2,
        margin: EdgeInsets.symmetric(
            horizontal: size.percentWidth(0.04), vertical: size.percentHeight(0.01)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(
              horizontal: size.percentWidth(0.04), vertical: size.percentHeight(0.015)),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(photoUrl),
            radius: size.percentWidth(0.06),
          ),
          title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(email),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: onReject,
              ),
              IconButton(
                icon: const Icon(Icons.check, color: Colors.green),
                onPressed: onAccept,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsPopup(BuildContext context, ResponsiveConfig size) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: PColors.backgrndPrimary,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(size.percentWidth(0.04)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _showImageFullScreen(context, photoUrl),
                    child: CircleAvatar(
                      radius: size.percentWidth(0.1),
                      backgroundImage: NetworkImage(photoUrl),
                    ),
                  ),
                  SizedBox(width: size.percentWidth(0.05)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text(email),
                        const SizedBox(height: 5),
                        Text("Age: $age"),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text("Qualification: $qualification",
                  style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Text("Certificates:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: certificates.map((cert) {
                  final url = cert['url'];
                  return GestureDetector(
                    onTap: () => _showImageFullScreen(context, url),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        url,
                        width: size.percentWidth(0.25),
                        height: size.percentWidth(0.25),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text("Selected Courses:", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 5),
              Wrap(
                spacing: 6,
                children: selectedCourses
                    .map((course) => Chip(
                      
                      label: Text(course['name'].toString())))
                    .toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                      onReject();
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      Navigator.pop(context);
                      onAccept();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showImageFullScreen(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
    
        insetPadding: EdgeInsets.zero,
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: InteractiveViewer(
            child: Container(
              color: Colors.black,
              child: Center(
                child: Image.network(imageUrl),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
