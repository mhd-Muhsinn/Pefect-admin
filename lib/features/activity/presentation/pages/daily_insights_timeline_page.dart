import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/daily_insight_model.dart';
import 'create_edit_daily_insight_page.dart.dart';
import 'daily_insight_detail_page.dart';

class DailyInsightsTimelinePage extends StatelessWidget {
  final String courseId;

  const DailyInsightsTimelinePage({
    super.key,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Insights'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('activity')
            .doc('daily_insights')
            .collection(courseId)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No insights yet'));
          }

          final insights = snapshot.data!.docs
              .map((doc) => DailyInsightModel.fromFirestore(doc))
              .toList();

          final grouped = _groupByDate(insights);

          return ListView(
            padding: const EdgeInsets.all(12),
            children: grouped.entries.map((entry) {
              return _DateGroupCard(
                date: entry.key,
                insights: entry.value,
                courseId: courseId,
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CreateEditDailyInsightPage(
                courseId: courseId,
                createdBy: 'admin',
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Groups insights by yyyy-MM-dd
  Map<String, List<DailyInsightModel>> _groupByDate(
    List<DailyInsightModel> insights,
  ) {
    final Map<String, List<DailyInsightModel>> map = {};

    for (final insight in insights) {
      final dateKey = DateFormat('yyyy-MM-dd').format(insight.createdAt);

      map.putIfAbsent(dateKey, () => []);
      map[dateKey]!.add(insight);
    }

    return map;
  }
}

class _DateGroupCard extends StatelessWidget {
  final String date;
  final List<DailyInsightModel> insights;
  final String courseId;

  const _DateGroupCard({
    required this.date,
    required this.insights,
    required this.courseId,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd MMM yyyy').format(DateTime.parse(date));

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          formattedDate,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('${insights.length} insight(s)'),
        children: insights.map((insight) {
          return ListTile(
            title: Text(insight.title),
            subtitle: Text(
              insight.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: _MediaIcons(insight: insight),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DailyInsightDetailPage(insight: insight),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}

class _MediaIcons extends StatelessWidget {
  final DailyInsightModel insight;

  const _MediaIcons({required this.insight});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (insight.pdf != null) const Icon(Icons.picture_as_pdf, size: 18),
        if (insight.audioNote != null) const Icon(Icons.audiotrack, size: 18),
        if (insight.youtubeUrl != null)
          const Icon(Icons.play_circle_outline, size: 18),
      ],
    );
  }
}
