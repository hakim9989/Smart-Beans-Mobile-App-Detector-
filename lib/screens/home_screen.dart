import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/prediction_result.dart';
import '../models/scan_history.dart';
import '../models/disease_info.dart';
import '../models/notice.dart';
import '../services/model_service.dart';
import '../services/history_service.dart';
import '../services/notice_service.dart';
import '../providers/auth_provider.dart';
import '../screens/disease_detail_screen.dart';
import '../screens/about_screen.dart';
import '../screens/main_navigation.dart';
import '../widgets/image_picker_button.dart';
import '../widgets/notice_popup.dart';

/// Enhanced main screen for the bean disease classifier
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final ModelService _modelService = ModelService();
  final HistoryService _historyService = HistoryService();
  final NoticeService _noticeService = NoticeService();
  final ImagePicker _imagePicker = ImagePicker();
  
  File? _selectedImage;
  PredictionResult? _predictionResult;
  bool _isLoading = false;
  bool _isModelLoading = true;
  int _totalScans = 0;
  Notice? _latestNotice;
  bool _hasSeenNotice = true;
  
  late AnimationController _pulseController;
  late AnimationController _scanController;
  late AnimationController _floatController;
  late AnimationController _borderController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();
    _initializeModel();
    _loadStats();
    _checkForNotices();
    
    // Pulse animation for loading
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    // Scan controller for starting/stopping animation
    _scanController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Floating/hovering animation for bean plant image
    _floatController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    
    _floatAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    
    // Animated border for Quick Tips container
    _borderController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    
    _borderAnimation = Tween<double>(begin: 0.0, end: 6.28).animate(_borderController); // 2π for full rotation
  }
  
  Future<void> _checkForNotices() async {
    print('🔔 Checking for notices...');
    final hasSeenLatest = await _noticeService.hasSeenLatestNotice();
    final latestNotice = await _noticeService.getLatestNotice();
    
    print('🔔 Has seen latest: $hasSeenLatest');
    print('🔔 Latest notice: ${latestNotice?.title ?? "None"}');
    
    setState(() {
      _hasSeenNotice = hasSeenLatest;
      _latestNotice = latestNotice;
    });
    
    // Show popup if there's a new notice
    if (!hasSeenLatest && latestNotice != null && mounted) {
      print('🔔 Showing notice popup...');
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) {
          NoticePopup.show(context, latestNotice, () {
            _noticeService.markNoticeSeen();
            setState(() => _hasSeenNotice = true);
          });
        }
      });
    } else {
      print('🔔 Not showing popup - hasSeenLatest: $hasSeenLatest, latestNotice: ${latestNotice != null}');
    }
  }

  Future<void> _initializeModel() async {
    try {
      await _modelService.loadModel();
      setState(() => _isModelLoading = false);
    } catch (e) {
      setState(() => _isModelLoading = false);
      if (mounted) _showErrorSnackBar('Failed to load model: $e');
    }
  }
  
  Future<void> _loadStats() async {
    final history = await _historyService.getHistory();
    setState(() => _totalScans = history.length);
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      
      if (image != null) {
        // Start loading immediately, but DON'T set _selectedImage yet
        setState(() {
          _isLoading = true;
          _predictionResult = null;
        });
        _scanController.repeat(); // Start animation
        
        // Store image temporarily
        _selectedImage = File(image.path);
        
        // Run prediction
        await _runPrediction();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to capture image: $e');
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image != null) {
        // Start loading immediately, but DON'T set _selectedImage yet
        setState(() {
          _isLoading = true;
          _predictionResult = null;
        });
        _scanController.repeat(); // Start animation
        
        // Store image temporarily
        _selectedImage = File(image.path);
        
        // Run prediction
        await _runPrediction();
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: $e');
    }
  }
  
  // Show bottom sheet with camera/gallery options
  void _showImageSourceOptions() {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            
            // Title
            Row(
              children: [
                const Text('🌿', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Text(
                  'Scan Your Bean Plant',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Camera option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: theme.colorScheme.primary,
                  size: 28,
                ),
              ),
              title: const Text(
                'Take Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text('Use camera to capture bean leaf'),
              onTap: () {
                Navigator.pop(context);
                _pickFromCamera();
              },
            ),
            const SizedBox(height: 12),
            
            // Gallery option
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.photo_library,
                  color: theme.colorScheme.secondary,
                  size: 28,
                ),
              ),
              title: const Text(
                'Choose from Gallery',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: const Text('Select existing photo'),
              onTap: () {
                Navigator.pop(context);
                _pickFromGallery();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _runPrediction() async {
    if (_selectedImage == null) return;

    try {
      final result = await _modelService.predict(_selectedImage!);
      
      final scan = ScanHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        imagePath: _selectedImage!.path,
        diagnosis: result.label,
        confidence: result.confidence,
        timestamp: DateTime.now(),
      );
      await _historyService.saveScan(scan);
      await _loadStats();
      
      _scanController.stop(); // Stop animation when done
      
      setState(() {
        _predictionResult = result;
        _isLoading = false;
      });
    } catch (e) {
      _scanController.stop();
      setState(() => _isLoading = false);
      _showErrorSnackBar('Prediction failed: $e');
    }
  }

  void _newScan() {
    setState(() {
      _selectedImage = null;
      _predictionResult = null;
      _isLoading = false; // Reset loading state
    });
    _scanController.stop(); // Stop animation if running
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    _modelService.dispose();
    _pulseController.dispose();
    _scanController.dispose();
    _floatController.dispose();
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withValues(alpha: 0.1),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: _isModelLoading ? _buildLoadingScreen() : _buildMainContent(),
        ),
      ),
      floatingActionButton: _isModelLoading ? null : FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AboutScreen()),
          );
        },
        backgroundColor: theme.colorScheme.primary,
        icon: const Icon(Icons.info_outline, color: Colors.white),
        label: const Text(
          'About',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 6,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildLoadingScreen() {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.psychology, size: 64, color: theme.colorScheme.primary),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Loading AI Model...',
            style: TextStyle(
              fontSize: 20,
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 200,
            child: LinearProgressIndicator(
              color: theme.colorScheme.primary,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return CustomScrollView(
      slivers: [
        _buildAppBar(),
        
        // Notice banner (if there's an unread notice)
        if (_latestNotice != null && !_hasSeenNotice)
          SliverToBoxAdapter(
            child: _buildNoticeBanner(),
          ),
        
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              if (_isLoading || _predictionResult == null) ...[
                // Show initial screen with stats, tips, and image picker
                // During loading, the camera icon becomes a spinner
                _buildStatsCards(),
                const SizedBox(height: 24),
                _buildQuickTips(),
                const SizedBox(height: 24),
                _buildImagePickerSection(),
              ] else ...[
                // After loading completes, show image and results
                _buildImageDisplaySection(),
                const SizedBox(height: 24),
                _buildResultSection(),
              ],
            ]),
          ),
        ),
      ],
    );
  }
  
  Widget _buildNoticeBanner() {
    
    return GestureDetector(
      onTap: () {
        if (_latestNotice != null) {
          NoticePopup.show(context, _latestNotice!, () {
            _noticeService.markNoticeSeen();
            setState(() => _hasSeenNotice = true);
          });
        }
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.orange.shade400,
              Colors.orange.shade600,
            ],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.campaign,
                color: Colors.white,
                size: 24,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'New Notice',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    _latestNotice!.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    final theme = Theme.of(context);
    final authProvider = Provider.of<AuthProvider>(context);
    
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: theme.colorScheme.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hello, ${authProvider.userName}! 👋',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              children: [
                Text('🌿', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                const Text(
                  'Bean Disease Detection',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ],
        ),
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
      ),
    );
  }

  Widget _buildStatsCards() {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Expanded(
          child: _InteractiveStatCard(
            icon: Icons.analytics,
            title: 'Total Scans',
            value: '$_totalScans',
            color: theme.colorScheme.primary,
            onTap: () {
              // Navigate to history page (index 2 in bottom navigation)
              MainNavigation.of(context)?.changeTab(2);
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _InteractiveStatCard(
            icon: Icons.verified,
            title: 'Accuracy',
            value: '95%',
            color: Colors.green,
            onTap: null, // No action for accuracy card
          ),
        ),
      ],
    );
  }
  
  Widget _buildQuickTips() {
    final theme = Theme.of(context);
    
    return AnimatedBuilder(
      animation: _borderAnimation,
      builder: (context, child) {
        return Container(
          padding: const EdgeInsets.all(3), // Space for animated border
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: SweepGradient(
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.8),
                theme.colorScheme.secondary.withValues(alpha: 0.8),
                theme.colorScheme.primary.withValues(alpha: 0.3),
                theme.colorScheme.secondary.withValues(alpha: 0.3),
                theme.colorScheme.primary.withValues(alpha: 0.8),
              ],
              stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
              transform: GradientRotation(_borderAnimation.value),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Bean leaf emoji for visual context
                    const Text('🌿', style: TextStyle(fontSize: 24)),
                    const SizedBox(width: 12),
                    Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Quick Tips for Best Results',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTipItem('📸 Use good lighting'),
                _buildTipItem('🎯 Focus on the bean leaf'),
                _buildTipItem('📏 Get close to the plant'),
                _buildTipItem('✨ Avoid blurry images'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 14, color: Colors.grey.shade700)),
        ],
      ),
    );
  }

  Widget _buildImagePickerSection() {
    final theme = Theme.of(context);
    
    return Column(
      children: [
        // Tappable container with bean plant
        GestureDetector(
          onTap: _isLoading ? null : _showImageSourceOptions,
          child: Container(
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                // Show loading spinner OR bean plant image with floating animation
                _isLoading
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              strokeWidth: 8,
                              color: theme.colorScheme.primary,
                              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.15),
                            ),
                          ),
                          ScaleTransition(
                            scale: _pulseAnimation,
                            child: Icon(
                              Icons.psychology,
                              size: 48,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                        ],
                      )
                    : AnimatedBuilder(
                        animation: _floatAnimation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _floatAnimation.value),
                            child: Column(
                              children: [
                                // Bean leaf visual indicator with scale animation
                                ScaleTransition(
                                  scale: _pulseAnimation,
                                  child: const Text('🌱', style: TextStyle(fontSize: 48)),
                                ),
                                const SizedBox(height: 12),
                                // Bean plant image in circular frame with glow effect
                                Container(
                                  width: 140,
                                  height: 140,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: theme.colorScheme.primary,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: theme.colorScheme.primary.withValues(alpha: 0.4),
                                        blurRadius: 25,
                                        spreadRadius: 5,
                                        offset: const Offset(0, 8),
                                      ),
                                      BoxShadow(
                                        color: theme.colorScheme.primary.withValues(alpha: 0.2),
                                        blurRadius: 40,
                                        spreadRadius: 10,
                                        offset: const Offset(0, 12),
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Image.asset(
                                      'assets/images/bean_plant.jpg',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                const SizedBox(height: 20),
                Text(
                  _isLoading ? 'Analyzing Bean Leaf...' : 'Tap to Scan Your Bean Plant',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _isLoading ? theme.colorScheme.primary : Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLoading 
                      ? 'AI is detecting diseases 🔬'
                      : 'Tap the image to start scanning 🍃',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Alternative: Manual buttons (still available)
        Row(
          children: [
            Expanded(
              child: ImagePickerButton(
                icon: Icons.camera_alt,
                label: 'Camera',
                onPressed: _isLoading ? () {} : _pickFromCamera,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ImagePickerButton(
                icon: Icons.photo_library,
                label: 'Gallery',
                onPressed: _isLoading ? () {} : _pickFromGallery,
                color: theme.colorScheme.secondary,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageDisplaySection() {
    final theme = Theme.of(context);
    
    return Hero(
      tag: 'scanned_image',
      child: Container(
        height: 400,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Image with gradient overlay
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                  // Gradient overlay at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Scan complete badge
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Scan Complete',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultSection() {
    final theme = Theme.of(context);
    final statusColor = _getResultColor();
    
    return Column(
      children: [
        // Enhanced Result Card
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: statusColor.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              // Header with gradient
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      statusColor.withValues(alpha: 0.1),
                      statusColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getResultIcon(),
                        size: 32,
                        color: statusColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Diagnosis Result',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _predictionResult!.label,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Confidence meter
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Confidence Level',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          _predictionResult!.confidencePercentage,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: statusColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: _predictionResult!.confidence,
                        minHeight: 12,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                      ),
                    ),
                    
                    // Additional info for uncertain predictions
                    if (_predictionResult!.isUncertain) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.orange.shade200,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.orange.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Low confidence. Try a clearer image for better results.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.orange.shade900,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 24),
        
        // Action buttons with better design
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _newScan,
                icon: const Icon(Icons.refresh, size: 20),
                label: const Text('New Scan'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  side: BorderSide(color: theme.colorScheme.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  foregroundColor: theme.colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 12),
                          Text('Saved to history!'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.bookmark, size: 20),
                label: const Text('Save'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  elevation: 4,
                  shadowColor: theme.colorScheme.primary.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 16),
        
        // View details button
        TextButton.icon(
          onPressed: () {
            // Find the disease info based on prediction result
            final diseases = DiseaseInfo.getAllDiseases();
            final disease = diseases.firstWhere(
              (d) => d.name == _predictionResult!.label,
              orElse: () => diseases[0], // Default to first disease if not found
            );
            
            // Navigate to disease detail screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DiseaseDetailScreen(disease: disease),
              ),
            );
          },
          icon: const Icon(Icons.info_outline, size: 18),
          label: const Text('Learn more about this disease'),
          style: TextButton.styleFrom(
            foregroundColor: theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }
  
  Color _getResultColor() {
    switch (_predictionResult!.statusColor) {
      case 'green':
        return Colors.green;
      case 'red':
        return Colors.red.shade700;
      case 'grey':
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }
  
  IconData _getResultIcon() {
    switch (_predictionResult!.statusIcon) {
      case 'check_circle':
        return Icons.check_circle;
      case 'warning':
        return Icons.warning;
      case 'help':
        return Icons.help_outline;
      default:
        return Icons.info;
    }
  }
}

// Interactive stat card with hover effect
class _InteractiveStatCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const _InteractiveStatCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  State<_InteractiveStatCard> createState() => _InteractiveStatCardState();
}

class _InteractiveStatCardState extends State<_InteractiveStatCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    
    _elevationAnimation = Tween<double>(begin: 10.0, end: 20.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onEnter() {
    if (widget.onTap != null) {
      setState(() => _isHovered = true);
      _controller.forward();
    }
  }

  void _onExit() {
    if (widget.onTap != null) {
      setState(() => _isHovered = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onEnter(),
      onExit: (_) => _onExit(),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: widget.onTap != null ? (_) => _controller.reverse() : null,
        onTapUp: widget.onTap != null ? (_) => _controller.forward() : null,
        onTapCancel: widget.onTap != null ? () => _controller.forward() : null,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered 
                          ? widget.color.withValues(alpha: 0.3)
                          : Colors.grey.shade200,
                      blurRadius: _elevationAnimation.value,
                      offset: Offset(0, _elevationAnimation.value / 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(widget.icon, color: widget.color, size: 32),
                        if (widget.onTap != null && _isHovered)
                          Positioned(
                            right: -12,
                            top: -12,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: widget.color,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.color.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: widget.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        if (widget.onTap != null) ...[
                          const SizedBox(width: 4),
                          Icon(
                            Icons.touch_app,
                            size: 12,
                            color: _isHovered ? widget.color : Colors.grey.shade400,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
