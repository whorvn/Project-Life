import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/hackathon_provider.dart';
import '../providers/auth_provider.dart';
import '../models/hackathon.dart';
import '../widgets/loading_overlay.dart';
import 'dart:math' as math;

class HackathonLandingPageScreen extends StatefulWidget {
  final String hackathonId;
  
  const HackathonLandingPageScreen({
    Key? key,
    required this.hackathonId,
  }) : super(key: key);

  @override
  State<HackathonLandingPageScreen> createState() => _HackathonLandingPageScreenState();
}

class _HackathonLandingPageScreenState extends State<HackathonLandingPageScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  Hackathon? _hackathon;
  String? _error;
  
  late AnimationController _heroAnimationController;
  late AnimationController _particleController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  
  final ScrollController _scrollController = ScrollController();
  bool _showAppBar = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _loadHackathon();
    _scrollController.addListener(_onScroll);
  }

  void _initAnimations() {
    _heroAnimationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
    
    _fadeInAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _heroAnimationController,
      curve: const Interval(0.2, 0.8, curve: Curves.easeOutBack),
    ));
  }

  void _onScroll() {
    setState(() {
      _showAppBar = _scrollController.offset > 200;
    });
  }

  @override
  void dispose() {
    _heroAnimationController.dispose();
    _particleController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadHackathon() async {
    try {
      final hackathonProvider = Provider.of<HackathonProvider>(context, listen: false);
      final hackathon = await hackathonProvider.getHackathon(widget.hackathonId);
      
      setState(() {
        _hackathon = hackathon;
        _isLoading = false;
      });
      
      _heroAnimationController.forward();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getPrimaryColor().withOpacity(0.8),
                _getSecondaryColor().withOpacity(0.8),
              ],
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.white),
                SizedBox(height: 16),
                Text(
                  'Loading amazing content...',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_error != null || _hackathon == null) {
      return _buildErrorPage();
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _showAppBar ? _buildAppBar() : null,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildHeroSection(),
          _buildAboutSection(),
          _buildStatsSection(),
          _buildDetailsSection(),
          _buildPrizesSection(),
          _buildTimelineSection(),
          _buildSponsorsSection(),
          _buildFAQSection(),
          _buildContactSection(),
          _buildFooter(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _getPrimaryColor().withOpacity(0.95),
      elevation: 0,
      title: Text(
        _hackathon!.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actions: [
        TextButton.icon(
          onPressed: _scrollToRegistration,
          icon: const Icon(Icons.how_to_reg, color: Colors.white),
          label: const Text(
            'Register',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildHeroSection() {
    return SliverToBoxAdapter(
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getPrimaryColor(),
              _getPrimaryColor().withOpacity(0.8),
              _getSecondaryColor(),
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            _buildAnimatedBackground(),
            
            // Geometric shapes
            _buildGeometricShapes(),
            
            // Main content
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with glow effect
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: _buildLogoWithGlow(),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Main title with animation
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeInAnimation,
                        child: _buildMainTitle(),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Description with typewriter effect
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: _buildDescription(),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Event info cards
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: _buildEventInfoCards(),
                    ),
                    
                    const SizedBox(height: 48),
                    
                    // CTA Buttons with hover effects
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: _buildCTAButtons(),
                    ),
                  ],
                ),
              ),
            ),
            
            // Scroll indicator
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: _buildScrollIndicator(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlesPainter(_particleController.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildGeometricShapes() {
    return Stack(
      children: [
        // Floating circles
        Positioned(
          top: 100,
          right: -50,
          child: AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _particleController.value * 2 * math.pi,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        
        // Triangle
        Positioned(
          bottom: 150,
          left: -30,
          child: AnimatedBuilder(
            animation: _particleController,
            builder: (context, child) {
              return Transform.rotate(
                angle: -_particleController.value * 2 * math.pi,
                child: CustomPaint(
                  painter: TrianglePainter(),
                  size: const Size(100, 100),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLogoWithGlow() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: _getAccentColor().withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: _hackathon!.landingLogoUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.network(
                  _hackathon!.landingLogoUrl!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.code, size: 80, color: Colors.white),
                ),
              )
            : const Icon(Icons.code, size: 80, color: Colors.white),
      ),
    );
  }

  Widget _buildMainTitle() {
    return ShaderMask(
      shaderCallback: (bounds) => LinearGradient(
        colors: [Colors.white, _getAccentColor()],
      ).createShader(bounds),
      child: Text(
        _hackathon!.name,
        style: const TextStyle(
          fontSize: 56,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: -1,
          height: 1.1,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      constraints: const BoxConstraints(maxWidth: 600),
      child: Text(
        _hackathon!.description,
        style: const TextStyle(
          fontSize: 20,
          color: Colors.white70,
          height: 1.6,
          fontWeight: FontWeight.w300,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildEventInfoCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildInfoCard(
          icon: Icons.calendar_today,
          title: 'Duration',
          value: _getDuration(),
        ),
        const SizedBox(width: 20),
        _buildInfoCard(
          icon: Icons.location_on,
          title: 'Location',
          value: _hackathon!.location ?? 'Online',
        ),
        const SizedBox(width: 20),
        _buildInfoCard(
          icon: Icons.group,
          title: 'Team Size',
          value: '${_hackathon!.maxTeamSize} max',
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
        ),
        backdropFilter: null,
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCTAButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildPrimaryButton(
          'Register Now',
          Icons.how_to_reg,
          _scrollToRegistration,
        ),
        const SizedBox(width: 20),
        _buildSecondaryButton(
          'Learn More',
          Icons.keyboard_arrow_down,
          () => _scrollToSection(1),
        ),
      ],
    );
  }

  Widget _buildPrimaryButton(String text, IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_getAccentColor(), _getAccentColor().withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: _getAccentColor().withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton(String text, IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(30),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white),
                const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollIndicator() {
    return AnimatedBuilder(
      animation: _particleController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, math.sin(_particleController.value * 2 * math.pi) * 5),
          child: Column(
            children: [
              const Text(
                'Scroll to explore',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 8),
              Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white70,
                size: 32,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getPrimaryColor(),
            _getSecondaryColor(),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage('https://via.placeholder.com/1920x1080?text=Tech+Pattern'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          // Content
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo placeholder
                  if (_hackathon!.landingLogoUrl != null)
                    Image.network(
                      _hackathon!.landingLogoUrl!,
                      height: 80,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.code, size: 80, color: Colors.white),
                    )
                  else
                    const Icon(Icons.code, size: 80, color: Colors.white),
                  
                  const SizedBox(height: 32),
                  
                  // Hackathon name
                  Text(
                    _hackathon!.name,
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Description
                  Container(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: Text(
                      _hackathon!.description,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Event dates
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              '${_formatDate(_hackathon!.startDate)} - ${_formatDate(_hackathon!.endDate)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        if (_hackathon!.location != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.location_on, color: Colors.white),
                              const SizedBox(width: 8),
                              Text(
                                _hackathon!.location!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  // CTA Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to registration
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _getAccentColor(),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        child: const Text('Register Now'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () {
                          // Scroll to about section
                          Scrollable.ensureVisible(
                            context,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Learn More'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey[50]!,
            ],
          ),
        ),
        child: Column(
          children: [
            _buildSectionTitle('About the Event', 'Discover what makes this hackathon special'),
            const SizedBox(height: 60),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_getPrimaryColor(), _getAccentColor()],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.lightbulb, color: Colors.white, size: 40),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Innovation',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _getPrimaryColor(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Push the boundaries of technology and create groundbreaking solutions.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'About the Event',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: _getPrimaryColor(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          _hackathon!.description,
                          style: const TextStyle(fontSize: 18, height: 1.7),
                        ),
                        if (_hackathon!.theme != null) ...[
                          const SizedBox(height: 32),
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getPrimaryColor().withOpacity(0.1),
                                  _getAccentColor().withOpacity(0.1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.palette, color: _getPrimaryColor(), size: 32),
                                const SizedBox(width: 16),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Theme',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: _getPrimaryColor(),
                                      ),
                                    ),
                                    Text(
                                      _hackathon!.theme!,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [_getAccentColor(), _getPrimaryColor()],
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.group, color: Colors.white, size: 40),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Collaboration',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _getPrimaryColor(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Work with talented individuals and build lasting connections.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 32),
        color: _getPrimaryColor(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildStatCard('24+', 'Hours of\nCoding', Icons.schedule),
            _buildStatCard('500+', 'Expected\nParticipants', Icons.people),
            _buildStatCard('\$10K+', 'Prize\nPool', Icons.emoji_events),
            _buildStatCard('50+', 'Mentors &\nJudges', Icons.school),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String number, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 48),
        const SizedBox(height: 16),
        Text(
          number,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDetailsSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 32),
        color: Colors.grey[50],
        child: Column(
          children: [
            _buildSectionTitle('Event Details', 'Everything you need to know'),
            const SizedBox(height: 60),
            
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 32,
              crossAxisSpacing: 32,
              children: [
                _buildDetailCard(
                  icon: Icons.group,
                  title: 'Team Formation',
                  description: 'Form teams of up to ${_hackathon!.maxTeamSize} members. Solo participation is also welcome!',
                  color: Colors.blue,
                ),
                _buildDetailCard(
                  icon: Icons.schedule,
                  title: 'Duration',
                  description: 'A ${_getDuration()} intensive coding experience with mentorship and fun activities.',
                  color: Colors.green,
                ),
                _buildDetailCard(
                  icon: Icons.language,
                  title: 'Format',
                  description: 'This is a ${_hackathon!.type?.toUpperCase() ?? 'HYBRID'} event with both virtual and in-person elements.',
                  color: Colors.purple,
                ),
                _buildDetailCard(
                  icon: Icons.code,
                  title: 'Technologies',
                  description: 'Use any programming language, framework, or technology stack you prefer.',
                  color: Colors.orange,
                ),
                _buildDetailCard(
                  icon: Icons.mentor,
                  title: 'Mentorship',
                  description: 'Get guidance from industry experts and experienced developers throughout the event.',
                  color: Colors.teal,
                ),
                _buildDetailCard(
                  icon: Icons.wine_bar,
                  title: 'Amenities',
                  description: 'Free meals, snacks, beverages, and swag for all participants.',
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 40, color: color),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: _getPrimaryColor(),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            description,
            style: const TextStyle(fontSize: 14, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPrizesSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _getPrimaryColor().withOpacity(0.05),
              _getAccentColor().withOpacity(0.05),
            ],
          ),
        ),
        child: Column(
          children: [
            _buildSectionTitle('Prizes & Rewards', 'Amazing prizes await the winners'),
            const SizedBox(height: 60),
            
            Container(
              padding: const EdgeInsets.all(60),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: _getAccentColor().withOpacity(0.2),
                    blurRadius: 40,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [_getAccentColor(), Colors.amber],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: _getAccentColor().withOpacity(0.4),
                          blurRadius: 30,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.emoji_events, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Total Prize Pool',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _getPrimaryColor(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _hackathon!.prizePool ?? '\$10,000+',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      color: _getAccentColor(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: const Text(
                      'Winners will receive cash prizes, tech gadgets, job opportunities, and exclusive mentorship sessions with industry leaders.',
                      style: TextStyle(fontSize: 18, height: 1.6),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Prize breakdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildPrizeCategory('🥇', '1st Place', '\$5,000'),
                      _buildPrizeCategory('🥈', '2nd Place', '\$3,000'),
                      _buildPrizeCategory('🥉', '3rd Place', '\$2,000'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrizeCategory(String emoji, String place, String amount) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        Text(
          place,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: _getPrimaryColor(),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          amount,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _getAccentColor(),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 32),
        color: Colors.white,
        child: Column(
          children: [
            _buildSectionTitle('Event Timeline', 'Mark your calendar'),
            const SizedBox(height: 60),
            
            _buildTimelineItem(
              'Registration Opens',
              _hackathon!.applicationStartDate ?? _hackathon!.startDate,
              Icons.how_to_reg,
              Colors.green,
              true,
            ),
            _buildTimelineItem(
              'Registration Closes',
              _hackathon!.applicationEndDate ?? _hackathon!.startDate,
              Icons.close,
              Colors.orange,
              false,
            ),
            _buildTimelineItem(
              'Hackathon Begins',
              _hackathon!.startDate,
              Icons.play_arrow,
              _getPrimaryColor(),
              false,
            ),
            _buildTimelineItem(
              'Hackathon Ends',
              _hackathon!.endDate,
              Icons.flag,
              _getAccentColor(),
              false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(String title, DateTime date, IconData icon, Color color, bool isFirst) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color, color.withOpacity(0.7)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 36),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isFirst ? color.withOpacity(0.1) : Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isFirst ? color.withOpacity(0.3) : Colors.grey.withOpacity(0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isFirst ? color : _getPrimaryColor(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatDateTime(date),
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSponsorsSection() {
    if (!_hackathon!.hasSponsors) return const SliverToBoxAdapter(child: SizedBox());
    
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 32),
        color: Colors.grey[50],
        child: Column(
          children: [
            _buildSectionTitle('Our Amazing Sponsors', 'Thank you for making this possible'),
            const SizedBox(height: 60),
            
            Wrap(
              spacing: 40,
              runSpacing: 40,
              children: [
                _buildSponsorCard('TechCorp', 'Platinum', Colors.purple),
                _buildSponsorCard('DevTools', 'Gold', Colors.amber),
                _buildSponsorCard('CloudServ', 'Gold', Colors.amber),
                _buildSponsorCard('StartupX', 'Silver', Colors.grey),
                _buildSponsorCard('CodeAcad', 'Silver', Colors.grey),
                _buildSponsorCard('InnoLab', 'Bronze', Colors.brown),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSponsorCard(String name, String tier, Color tierColor) {
    return Container(
      width: 200,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: tierColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              tier,
              style: TextStyle(
                color: tierColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 32),
        color: Colors.white,
        child: Column(
          children: [
            _buildSectionTitle('Frequently Asked Questions', 'Get your questions answered'),
            const SizedBox(height: 60),
            
            Container(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Column(
                children: [
                  _buildFAQItem(
                    'Who can participate in this hackathon?',
                    'This hackathon is open to developers, designers, entrepreneurs, and innovators of all skill levels. Whether you\'re a student, professional, or hobbyist, you\'re welcome to participate!',
                  ),
                  _buildFAQItem(
                    'Do I need to have a team?',
                    'You can participate solo or form teams of up to ${_hackathon!.maxTeamSize} members. We also have team formation activities if you\'re looking for teammates.',
                  ),
                  _buildFAQItem(
                    'What should I bring to the event?',
                    'Bring your laptop, chargers, and any hardware you might need. We\'ll provide meals, snacks, beverages, and workspace. Don\'t forget your creativity and enthusiasm!',
                  ),
                  _buildFAQItem(
                    'Is there a registration fee?',
                    'No! This hackathon is completely free to participate. Just register and show up ready to build something amazing.',
                  ),
                  _buildFAQItem(
                    'What if I\'m a beginner?',
                    'Perfect! We welcome participants of all skill levels. We have mentors available to help beginners, and it\'s a great learning opportunity.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Text(
              answer,
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_getPrimaryColor(), _getSecondaryColor()],
          ),
        ),
        child: Column(
          children: [
            const Text(
              'Get in Touch',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Have questions? We\'d love to hear from you!',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 60),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildContactCard(
                  Icons.email,
                  'Email Us',
                  'hello@hackathon.com',
                  'Send us an email anytime',
                ),
                _buildContactCard(
                  Icons.phone,
                  'Call Us',
                  '+1 (555) 123-4567',
                  'Available 9 AM - 6 PM',
                ),
                _buildContactCard(
                  Icons.location_on,
                  'Visit Us',
                  'Tech Hub, Silicon Valley',
                  'Come say hi in person',
                ),
              ],
            ),
            
            const SizedBox(height: 60),
            
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Follow Us on Social Media',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(Icons.language, 'Website'),
                      _buildSocialButton(Icons.facebook, 'Facebook'),
                      _buildSocialButton(Icons.email, 'Twitter'),
                      _buildSocialButton(Icons.work, 'LinkedIn'),
                      _buildSocialButton(Icons.code, 'GitHub'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, String platform) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () {},
          icon: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 32),
        color: Colors.grey[900],
        child: Column(
          children: [
            Text(
              _hackathon!.name,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Building the future, one line of code at a time.',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '© 2025 Hackathon Platform. All rights reserved.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_getAccentColor(), _getAccentColor().withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: _getAccentColor().withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: FloatingActionButton.extended(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Registration system coming soon!'),
              backgroundColor: _getPrimaryColor(),
            ),
          );
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        label: const Text(
          'Register Now',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        icon: const Icon(Icons.how_to_reg, size: 24),
      ),
    );
  }

  Widget _buildErrorPage() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_getPrimaryColor(), _getSecondaryColor()],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.white),
              const SizedBox(height: 24),
              const Text(
                'Oops! Something went wrong',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _error ?? 'Hackathon not found',
                style: const TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _loadHackathon,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: _getPrimaryColor(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 42,
            fontWeight: FontWeight.bold,
            color: _getPrimaryColor(),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // Utility methods
  void _scrollToSection(int section) {
    final screenHeight = MediaQuery.of(context).size.height;
    _scrollController.animateTo(
      screenHeight * section,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToRegistration() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Registration system is coming soon! 🚀'),
        backgroundColor: _getPrimaryColor(),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );
  }

  Color _getPrimaryColor() {
    if (_hackathon?.landingPrimaryColor != null) {
      try {
        return Color(int.parse(_hackathon!.landingPrimaryColor!.replaceFirst('#', '0xFF')));
      } catch (e) {
        return const Color(0xFF1976D2);
      }
    }
    return const Color(0xFF1976D2);
  }

  Color _getSecondaryColor() {
    if (_hackathon?.landingSecondaryColor != null) {
      try {
        return Color(int.parse(_hackathon!.landingSecondaryColor!.replaceFirst('#', '0xFF')));
      } catch (e) {
        return const Color(0xFF424242);
      }
    }
    return const Color(0xFF424242);
  }

  Color _getAccentColor() {
    if (_hackathon?.landingAccentColor != null) {
      try {
        return Color(int.parse(_hackathon!.landingAccentColor!.replaceFirst('#', '0xFF')));
      } catch (e) {
        return const Color(0xFFFF4081);
      }
    }
    return const Color(0xFFFF4081);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _formatDateTime(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    final hour = date.hour > 12 ? date.hour - 12 : date.hour;
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '${months[date.month - 1]} ${date.day}, ${date.year} at ${hour == 0 ? 12 : hour}:${date.minute.toString().padLeft(2, '0')} $period';
  }

  String _getDuration() {
    final duration = _hackathon!.endDate.difference(_hackathon!.startDate);
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
    } else {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    }
  }
}

// Custom Painters for animations
class ParticlesPainter extends CustomPainter {
  final double animationValue;

  ParticlesPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < 50; i++) {
      final x = (size.width * 0.1 * i + animationValue * 100) % size.width;
      final y = (size.height * 0.1 * i + animationValue * 50) % size.height;
      final radius = 2 + math.sin(animationValue * 2 * math.pi + i) * 2;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
