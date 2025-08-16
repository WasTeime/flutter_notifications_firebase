import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/notification_service.dart';
import '../widgets/info_card.dart';
import '../widgets/status_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final _notificationService = NotificationService();

  String _token = '';
  bool _isLoadingToken = true;

  late final AnimationController _animationController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _notificationService.hasPermission.addListener(_onPermissionChanged);
    _notificationService.lastMessage.addListener(_onMessageChanged);

    _initializeApp();
  }

  @override
  void dispose() {
    _notificationService.hasPermission.removeListener(_onPermissionChanged);
    _notificationService.lastMessage.removeListener(_onMessageChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _onPermissionChanged() => setState(() {});
  void _onMessageChanged() => setState(() {});

  Future<void> _initializeApp() async {
    await _loadToken();
    _animationController.forward();
  }

  Future<void> _loadToken() async {
    setState(() => _isLoadingToken = true);
    String? token = await _notificationService.getToken();
    setState(() {
      _token = token ?? 'Не удалось получить токен';
      _isLoadingToken = false;
    });
  }

  void _copyToken() {
    Clipboard.setData(ClipboardData(text: _token));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check, color: Colors.white),
            SizedBox(width: 8),
            Text('Токен скопирован!'),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                backgroundColor: colorScheme.primaryContainer,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Push Notifications',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  centerTitle: true,
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    StatusCard(
                      hasPermission: _notificationService.hasPermission.value,
                    ),
                    const SizedBox(height: 20),
                    InfoCard(
                      title: 'FCM Токен',
                      content: _token,
                      icon: Icons.key,
                      isLoading: _isLoadingToken,
                      onCopy: _copyToken,
                    ),
                    const SizedBox(height: 20),
                    InfoCard(
                      title: 'Последнее сообщение',
                      content: _notificationService.lastMessage.value,
                      icon: Icons.message,
                    ),
                    const SizedBox(height: 30),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
