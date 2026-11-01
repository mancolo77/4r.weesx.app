import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/cricket_overview_service.dart';

void showCricketMatchDetails(BuildContext context, CricketMatchDetail match) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppTheme.surfaceCard,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _MatchDetailsModal(match: match),
  );
}

class _MatchDetailsModal extends StatefulWidget {
  final CricketMatchDetail match;
  const _MatchDetailsModal({required this.match});

  @override
  State<_MatchDetailsModal> createState() => _MatchDetailsModalState();
}

class _MatchDetailsModalState extends State<_MatchDetailsModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final match = widget.match;
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      expand: false,
      builder: (_, controller) {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${match.format} • ${match.tournament}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13, fontWeight: FontWeight.bold)),
                      if (match.isLive)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.red.shade700, borderRadius: BorderRadius.circular(6)),
                          child: const Text('LIVE', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${match.teamA} vs ${match.teamB}', style: const TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('${match.venue} • ${match.timeIST}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  const SizedBox(height: 12),
                  TabBar(
                    controller: _tabController,
                    indicatorColor: AppTheme.primary,
                    indicatorWeight: 3,
                    labelColor: Colors.white,
                    unselectedLabelColor: AppTheme.textSecondary,
                    tabs: const [
                      Tab(text: 'Overview'),
                      Tab(text: 'Lineups'),
                      Tab(text: 'Stats'),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Overview
                  ListView(
                    controller: controller,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: AppTheme.darkNav, borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(match.teamA, style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(match.scoreA != null ? '${match.scoreA} ${match.oversA ?? ""}' : 'Upcoming', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(match.teamB, style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(match.scoreB != null ? '${match.scoreB} ${match.oversB ?? ""}' : 'Upcoming', style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: AppTheme.filterBg, borderRadius: BorderRadius.circular(8)),
                              child: Text(match.summary, style: const TextStyle(color: AppTheme.accentYellow, fontSize: 13, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Match Details', style: const TextStyle(color: AppTheme.textMain, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text('Format: ${match.format}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('Status: ${match.status}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('Scheduled: ${match.date} at ${match.timeIST}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                      const SizedBox(height: 4),
                      Text('Stadium: ${match.venue}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                    ],
                  ),

                  // Tab 2: Lineups
                  ListView(
                    controller: controller,
                    padding: const EdgeInsets.all(20),
                    children: [
                      Text('${match.teamA} Playing XI', style: const TextStyle(color: AppTheme.textMain, fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (match.lineupA.isEmpty)
                        const Text('Lineup to be announced at toss.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13))
                      else
                        ...match.lineupA.map((p) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text('• $p', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                            )),
                      const SizedBox(height: 20),
                      Text('${match.teamB} Playing XI', style: const TextStyle(color: AppTheme.textMain, fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (match.lineupB.isEmpty)
                        const Text('Lineup to be announced at toss.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13))
                      else
                        ...match.lineupB.map((p) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 3),
                              child: Text('• $p', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                            )),
                    ],
                  ),

                  // Tab 3: Stats
                  ListView(
                    controller: controller,
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Text('Team & Player Metrics', style: TextStyle(color: AppTheme.textMain, fontSize: 15, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      if (match.stats.isEmpty)
                        const Text('Detailed match metrics will update as play progresses.', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13))
                      else
                        ...match.stats.entries.map((e) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: AppTheme.darkNav, borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e.key.toUpperCase(), style: const TextStyle(color: AppTheme.accentYellow, fontSize: 12, fontWeight: FontWeight.bold)),
                                  Text('${e.value}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                                ],
                              ),
                            )),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
