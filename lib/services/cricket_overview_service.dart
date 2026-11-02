import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CricketMatchDetail {
  final String id;
  final String tournament;
  final String format; // 'T20', 'ODI', 'Test'
  final String teamA;
  final String teamB;
  final String? scoreA;
  final String? scoreB;
  final String? oversA;
  final String? oversB;
  final bool isLive;
  final String status;
  final String timeIST;
  final String date; // 'Today', 'Tomorrow', 'Yesterday'
  final String venue;
  final String summary;
  final List<String> lineupA;
  final List<String> lineupB;
  final Map<String, dynamic> stats;

  const CricketMatchDetail({
    required this.id,
    required this.tournament,
    required this.format,
    required this.teamA,
    required this.teamB,
    this.scoreA,
    this.scoreB,
    this.oversA,
    this.oversB,
    this.isLive = false,
    required this.status,
    required this.timeIST,
    required this.date,
    required this.venue,
    required this.summary,
    this.lineupA = const [],
    this.lineupB = const [],
    this.stats = const {},
  });
}

class CricketOverviewService with ChangeNotifier {
  static final CricketOverviewService _instance = CricketOverviewService._internal();
  factory CricketOverviewService() => _instance;
  CricketOverviewService._internal();

  final Set<String> _favMatchIds = {'m_ipl_1'};
  final Set<String> _favTeams = {'India', 'Mumbai Indians', 'Chennai Super Kings'};
  DateTime _lastUpdated = DateTime.now();

  Set<String> get favMatchIds => Set.unmodifiable(_favMatchIds);
  Set<String> get favTeams => Set.unmodifiable(_favTeams);
  DateTime get lastUpdated => _lastUpdated;

  final List<String> allTeams = const [
    'India',
    'Mumbai Indians',
    'Chennai Super Kings',
    'Royal Challengers Bengaluru',
    'Kolkata Knight Riders',
    'Sunrisers Hyderabad',
    'Gujarat Titans',
    'Australia',
    'England',
    'South Africa',
  ];

  final List<CricketMatchDetail> matches = const [
    CricketMatchDetail(
      id: 'm_ipl_1',
      tournament: 'Indian Premier League',
      format: 'T20',
      teamA: 'India',
      teamB: 'Australia',
      scoreA: '186/5',
      scoreB: '145/4',
      oversA: '20.0 ov',
      oversB: '16.2 ov',
      isLive: true,
      status: 'Live • 2nd Innings (Australia need 42 off 22)',
      timeIST: '19:30 IST',
      date: 'Today',
      venue: 'Eden Gardens, Kolkata',
      summary: 'Australia need 42 runs in 22 balls at 11.45 RPO',
      lineupA: ['Rohit Sharma (C)', 'Virat Kohli', 'Suryakumar Yadav', 'Hardik Pandya', 'Rishabh Pant (WK)', 'Axar Patel', 'Ravindra Jadeja', 'Jasprit Bumrah', 'Arshdeep Singh', 'Kuldeep Yadav', 'Mohammed Siraj'],
      lineupB: ['Travis Head', 'David Warner', 'Mitchell Marsh (C)', 'Glenn Maxwell', 'Marcus Stoinis', 'Tim David', 'Matthew Wade (WK)', 'Pat Cummins', 'Mitchell Starc', 'Adam Zampa', 'Josh Hazlewood'],
      stats: {
        'boundariesA': 'Fours: 18 • Sixes: 8',
        'boundariesB': 'Fours: 14 • Sixes: 6',
        'topScorer': 'Virat Kohli (74 off 48 balls)',
        'bestBowler': 'Jasprit Bumrah (2/18 in 3.0 ov)',
      },
    ),
    CricketMatchDetail(
      id: 'm_ipl_2',
      tournament: 'Indian Premier League',
      format: 'T20',
      teamA: 'Mumbai Indians',
      teamB: 'Chennai Super Kings',
      scoreA: '192/4',
      scoreB: '175/7',
      oversA: '20.0 ov',
      oversB: '20.0 ov',
      isLive: false,
      status: 'Finished',
      timeIST: '19:30 IST',
      date: 'Yesterday',
      venue: 'Wankhede Stadium, Mumbai',
      summary: 'Mumbai Indians won by 17 runs',
      lineupA: ['Ishan Kishan', 'Rohit Sharma', 'Suryakumar Yadav', 'Hardik Pandya (C)', 'Tilak Varma', 'Tim David', 'Mohammad Nabi', 'Gerald Coetzee', 'Piyush Chawla', 'Jasprit Bumrah', 'Nuwan Thushara'],
      lineupB: ['Ruturaj Gaikwad (C)', 'Rachin Ravindra', 'Ajinkya Rahane', 'Shivam Dube', 'Daryl Mitchell', 'Ravindra Jadeja', 'MS Dhoni (WK)', 'Shardul Thakur', 'Tushar Deshpande', 'Mustafizur Rahman', 'Matheesha Pathirana'],
      stats: {
        'boundariesA': 'Fours: 19 • Sixes: 9',
        'boundariesB': 'Fours: 16 • Sixes: 7',
        'topScorer': 'Suryakumar Yadav (68 off 34 balls)',
        'bestBowler': 'Jasprit Bumrah (3/21 in 4.0 ov)',
      },
    ),
    CricketMatchDetail(
      id: 'm_ipl_3',
      tournament: 'Indian Premier League',
      format: 'T20',
      teamA: 'Royal Challengers Bengaluru',
      teamB: 'Kolkata Knight Riders',
      scoreA: null,
      scoreB: null,
      oversA: null,
      oversB: null,
      isLive: false,
      status: 'Upcoming',
      timeIST: '19:30 IST',
      date: 'Tomorrow',
      venue: 'M. Chinnaswamy Stadium, Bengaluru',
      summary: 'Clash begins at 19:30 IST in Bengaluru',
      lineupA: ['Virat Kohli', 'Faf du Plessis (C)', 'Rajat Patidar', 'Glenn Maxwell', 'Cameron Green', 'Dinesh Karthik (WK)', 'Mahipal Lomror', 'Karn Sharma', 'Lockie Ferguson', 'Yash Dayal', 'Mohammed Siraj'],
      lineupB: ['Philip Salt (WK)', 'Sunil Narine', 'Venkatesh Iyer', 'Shreyas Iyer (C)', 'Rinku Singh', 'Andre Russell', 'Ramandeep Singh', 'Mitchell Starc', 'Harshit Rana', 'Varun Chakaravarthy', 'Vaibhav Arora'],
      stats: {},
    ),
    CricketMatchDetail(
      id: 'm_bgt_1',
      tournament: 'Border-Gavaskar Trophy',
      format: 'Test',
      teamA: 'India',
      teamB: 'England',
      scoreA: '396 & 255',
      scoreB: '253 & 292',
      oversA: '112.0 & 69.1 ov',
      oversB: '55.5 & 67.3 ov',
      isLive: false,
      status: 'Finished',
      timeIST: '09:30 IST',
      date: 'Yesterday',
      venue: 'ACA-VDCA Cricket Stadium, Visakhapatnam',
      summary: 'India won by 106 runs',
      lineupA: ['Yashasvi Jaiswal', 'Rohit Sharma (C)', 'Shubman Gill', 'Shreyas Iyer', 'Rajat Patidar', 'Axar Patel', 'Srikar Bharat (WK)', 'Ravichandran Ashwin', 'Kuldeep Yadav', 'Jasprit Bumrah', 'Mukesh Kumar'],
      lineupB: ['Zak Crawley', 'Ben Duckett', 'Ollie Pope', 'Joe Root', 'Jonny Bairstow', 'Ben Stokes (C)', 'Ben Foakes (WK)', 'Rehan Ahmed', 'Tom Hartley', 'Shoaib Bashir', 'James Anderson'],
      stats: {
        'doubleTon': 'Yashasvi Jaiswal (209 in 1st Innings)',
        'playerOfMatch': 'Jasprit Bumrah (9 wickets in match)',
      },
    ),
    CricketMatchDetail(
      id: 'm_ipl_4',
      tournament: 'Indian Premier League',
      format: 'T20',
      teamA: 'Sunrisers Hyderabad',
      teamB: 'Gujarat Titans',
      scoreA: null,
      scoreB: null,
      oversA: null,
      oversB: null,
      isLive: false,
      status: 'Upcoming',
      timeIST: '15:30 IST',
      date: 'Tomorrow',
      venue: 'Rajiv Gandhi International Cricket Stadium, Hyderabad',
      summary: 'Day clash starting at 15:30 IST',
      lineupA: ['Travis Head', 'Abhishek Sharma', 'Nitish Kumar Reddy', 'Heinrich Klaasen (WK)', 'Abdul Samad', 'Shahbaz Ahmed', 'Pat Cummins (C)', 'Sanvir Singh', 'Bhuvneshwar Kumar', 'Jaydev Unadkat', 'T. Natarajan'],
      lineupB: ['Shubman Gill (C)', 'Sai Sudharsan', 'David Miller', 'Azmatullah Omarzai', 'Rahul Tewatia', 'Shahrukh Khan', 'Rashid Khan', 'R. Sai Kishore', 'Noor Ahmad', 'Mohit Sharma', 'Sandeep Warrier'],
      stats: {},
    ),
  ];

  CricketMatchDetail? getHeroMatch() {
    // Find live or closest upcoming match containing a favorite team
    final favList = matches.where((m) => _favTeams.contains(m.teamA) || _favTeams.contains(m.teamB)).toList();
    final live = favList.where((m) => m.isLive).toList();
    if (live.isNotEmpty) return live.first;
    final today = favList.where((m) => m.date == 'Today').toList();
    if (today.isNotEmpty) return today.first;
    final tomorrow = favList.where((m) => m.date == 'Tomorrow').toList();
    if (tomorrow.isNotEmpty) return tomorrow.first;
    return matches.isNotEmpty ? matches.first : null;
  }

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favM = prefs.getStringList('fav_matches_weesx');
      if (favM != null) {
        _favMatchIds.clear();
        _favMatchIds.addAll(favM);
      }
      final favT = prefs.getStringList('fav_teams_weesx');
      if (favT != null) {
        _favTeams.clear();
        _favTeams.addAll(favT);
      }
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('fav_matches_weesx', _favMatchIds.toList());
      await prefs.setStringList('fav_teams_weesx', _favTeams.toList());
    } catch (_) {}
  }

  void toggleFavoriteMatch(String id) {
    if (_favMatchIds.contains(id)) {
      _favMatchIds.remove(id);
    } else {
      _favMatchIds.add(id);
    }
    _save();
    notifyListeners();
  }

  void toggleFavoriteTeam(String team) {
    if (_favTeams.contains(team)) {
      _favTeams.remove(team);
    } else {
      _favTeams.add(team);
    }
    _save();
    notifyListeners();
  }

  Future<void> refresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _lastUpdated = DateTime.now();
    notifyListeners();
  }
}

