import 'package:battalion_chai/users/widget/app_footer_screen.dart';
import 'package:battalion_chai/users/widget/app_header_screen.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  static const Color bgGreen = Color(0xFF0D2B1B);
  static const Color cardGreen = Color(0xFF163C29);
  static const Color cream = Color(0xFFF2E5C8);
  static const Color saffron = Color(0xFFE68B22);
  static const Color textDark = Color(0xFF172D20);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreen,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 700;
            final horizontalPadding = isMobile
                ? 18.0
                : constraints.maxWidth * 0.07;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: AppHeader(),
                  ),

                  const SizedBox(height: 24),

                  _buildHero(isMobile),

                  _buildStory(isMobile, horizontalPadding),

                  _buildVisionMission(isMobile, horizontalPadding),

                  _buildBrandValues(isMobile, horizontalPadding),

                  _buildFounderSection(isMobile, horizontalPadding),

                  _buildClosingSection(isMobile),

                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 35, 16, 16),
                    child: AppFooter(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // HERO SECTION
  Widget _buildHero(bool isMobile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 22 : 45,
        vertical: isMobile ? 35 : 42,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [cardGreen, bgGreen],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _heroText(true),
                const SizedBox(height: 25),
                _stats(true),
              ],
            )
          : Row(
              children: [
                Expanded(flex: 6, child: _heroText(false)),
                Container(
                  width: 1,
                  height: 150,
                  color: cream.withValues(alpha: 0.22),
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                ),
                Expanded(flex: 4, child: _stats(false)),
              ],
            ),
    );
  }

  Widget _heroText(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.horizontal_rule, color: saffron, size: 23),
            SizedBox(width: 8),
            Text(
              'ABOUT BATTALION CHAI',
              style: TextStyle(
                color: cream,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.horizontal_rule, color: saffron, size: 23),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'MORE THAN JUST A CUP',
          style: TextStyle(
            color: cream,
            fontSize: isMobile ? 29 : 34,
            fontWeight: FontWeight.w900,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 15),
        Text(
          'Battalion Chai sirf chai nahi, ek soch hai. '
          'Ek aisa brand jo desi chai ke swaad, apnapan '
          'aur jawano ke jazbe se inspired hai.',
          style: TextStyle(
            color: cream.withValues(alpha: 0.9),
            fontSize: 14,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 22),
        ElevatedButton.icon(
          onPressed: () {
            _showFounderStory(context);
          },
          icon: const Icon(Icons.arrow_forward, size: 18),
          label: const Text('Our Story'),
          style: ElevatedButton.styleFrom(
            backgroundColor: saffron,
            foregroundColor: bgGreen,
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(9),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stats(bool isMobile) {
    final items = [
      _statItem(Icons.local_cafe, 'OUR DREAM', 'A Brand with Purpose'),
      _statItem(Icons.flag, 'OUR ROOTS', 'Indian Chai Culture'),
      _statItem(Icons.star, 'OUR PROMISE', 'Taste & Togetherness'),
    ];

    if (isMobile) {
      return Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            items[i],
            if (i != items.length - 1) const SizedBox(height: 20),
          ],
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < items.length; i++) ...[
          items[i],
          if (i != items.length - 1) const SizedBox(height: 22),
        ],
      ],
    );
  }

  Widget _statItem(IconData icon, String title, String subtitle) {
    return Row(
      children: [
        Icon(icon, color: cream, size: 35),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: cream,
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: cream.withValues(alpha: 0.85),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // OUR STORY
  Widget _buildStory(bool isMobile, double horizontalPadding) {
    return Container(
      color: cream,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isMobile ? 38 : 65,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('THE BEGINNING'),
          const SizedBox(height: 12),
          Text(
            'A Childhood Dream. A Brand for Tomorrow.',
            style: TextStyle(
              color: textDark,
              fontSize: isMobile ? 28 : 37,
              fontWeight: FontWeight.w900,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Bachpan se hi Shubham Gupta ka sapna tha ki '
            'ek din apna khud ka brand banayein — ek aisa brand '
            'jiski apni pehchaan ho, apni kahaani ho aur jise '
            'log dil se pasand karein.',
            style: const TextStyle(color: textDark, fontSize: 16, height: 1.9),
          ),
          const SizedBox(height: 16),
          Text(
            'Isi sapne se Battalion Chai ka idea janma. Chai, '
            'jo India mein sirf ek drink nahi, balki dosti, '
            'family, breaks aur dil se hone wali conversations '
            'ka hissa hai. Hum isi apnapan ko ek alag brand '
            'identity ke saath pesh karna chahte hain.',
            style: TextStyle(
              color: textDark.withValues(alpha: 0.85),
              fontSize: 15,
              height: 1.9,
            ),
          ),
          const SizedBox(height: 22),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: bgGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '“Sapna sirf chai bechne ka nahi, '
              'ek aisa brand banane ka hai jo logon ke '
              'dilon mein apni jagah bana sake.”',
              style: TextStyle(
                color: cream,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                height: 1.7,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // VISION & MISSION
  Widget _buildVisionMission(bool isMobile, double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isMobile ? 38 : 60,
      ),
      child: Column(
        children: [
          const Text(
            'OUR PURPOSE',
            style: TextStyle(
              color: saffron,
              fontSize: 12,
              letterSpacing: 3,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'What We Believe In',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: cream,
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 28),
          if (isMobile)
            Column(
              children: [
                _purposeCard(
                  Icons.visibility_outlined,
                  'OUR VISION',
                  'Battalion Chai ko ek aisi pehchaan banana '
                      'jahan Indian chai culture, quality aur '
                      'apnapan ek saath aayein.',
                ),
                const SizedBox(height: 18),
                _purposeCard(
                  Icons.flag_outlined,
                  'OUR MISSION',
                  'Har cup ke saath ek yaadgaar experience dena '
                      'aur apne customers ke saath trust aur '
                      'connection banana.',
                ),
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _purposeCard(
                    Icons.visibility_outlined,
                    'OUR VISION',
                    'Battalion Chai ko ek aisi pehchaan banana '
                        'jahan Indian chai culture, quality aur '
                        'apnapan ek saath aayein.',
                  ),
                ),
                const SizedBox(width: 22),
                Expanded(
                  child: _purposeCard(
                    Icons.flag_outlined,
                    'OUR MISSION',
                    'Har cup ke saath ek yaadgaar experience dena '
                        'aur apne customers ke saath trust aur '
                        'connection banana.',
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _purposeCard(IconData icon, String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: cardGreen,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cream.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: saffron, size: 38),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              color: cream,
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              color: cream.withValues(alpha: 0.86),
              fontSize: 14,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  // BRAND VALUES
  Widget _buildBrandValues(bool isMobile, double horizontalPadding) {
    final values = [
      _valueItem(
        Icons.favorite_outline,
        'Made with Passion',
        'Har idea ke peeche apne sapne ko sach karne ka jazba.',
      ),
      _valueItem(
        Icons.groups_outlined,
        'Made for Togetherness',
        'Chai ke har cup ke saath apnapan aur connection.',
      ),
      _valueItem(
        Icons.emoji_events_outlined,
        'Built on Ambition',
        'Roz kuch behtar karne aur ek strong brand banane ki soch.',
      ),
    ];

    return Container(
      color: cream,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isMobile ? 38 : 55,
      ),
      child: Column(
        children: [
          const Text(
            'THE BATTALION SPIRIT',
            style: TextStyle(
              color: bgGreen,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'More Than a Brand',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: bgGreen,
              fontSize: isMobile ? 28 : 36,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 28),
          if (isMobile)
            Column(
              children: [
                for (int i = 0; i < values.length; i++) ...[
                  values[i],
                  if (i != values.length - 1) const SizedBox(height: 18),
                ],
              ],
            )
          else
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < values.length; i++) ...[
                  Expanded(child: values[i]),
                  if (i != values.length - 1) const SizedBox(width: 18),
                ],
              ],
            ),
        ],
      ),
    );
  }

  Widget _valueItem(IconData icon, String title, String description) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: bgGreen.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: bgGreen, size: 32),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              color: bgGreen,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            description,
            style: TextStyle(
              color: textDark.withValues(alpha: 0.85),
              fontSize: 13,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  // FOUNDER
  Widget _buildFounderSection(bool isMobile, double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isMobile ? 38 : 60,
      ),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 23 : 38),
        decoration: BoxDecoration(
          color: cardGreen,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: saffron.withValues(alpha: 0.45)),
        ),
        child: isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _founderBadge(),
                  const SizedBox(height: 24),
                  _founderText(),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(width: 170, height: 170, child: _founderBadge()),
                  const SizedBox(width: 35),
                  Expanded(child: _founderText()),
                ],
              ),
      ),
    );
  }

  Widget _founderBadge() {
    return Container(
      width: double.infinity,
      height: 170,
      decoration: BoxDecoration(
        color: bgGreen,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person_outline, color: saffron, size: 65),
          SizedBox(height: 12),
          Text(
            'THE FOUNDER',
            style: TextStyle(
              color: cream,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _founderText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'MEET THE FOUNDER',
          style: TextStyle(
            color: saffron,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Shubham Gupta',
          style: TextStyle(
            color: cream,
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Bachpan se apna ek brand banane ka sapna dekhne '
          'wale Shubham Gupta ke liye Battalion Chai usi '
          'sapne ki ek shuruaat hai. Ek aisa idea jise apni '
          'mehnat, creativity aur determination ke saath '
          'ek pehchaan dene ki soch hai.',
          style: TextStyle(
            color: cream.withValues(alpha: 0.9),
            fontSize: 14,
            height: 1.9,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          'Unka maanna hai ki bade sapne ek din mein nahi '
          'bante — unhe roz ke chhote steps, seekhne ki '
          'ichchha aur kabhi haar na maanne wala jazba '
          'aage badhata hai.',
          style: TextStyle(
            color: cream.withValues(alpha: 0.9),
            fontSize: 14,
            height: 1.9,
          ),
        ),
      ],
    );
  }

  // CLOSING CTA
  Widget _buildClosingSection(bool isMobile) {
    return Container(
      color: cream,
      padding: EdgeInsets.symmetric(
        horizontal: 22,
        vertical: isMobile ? 38 : 50,
      ),
      child: Column(
        children: [
          const Icon(Icons.local_cafe, color: bgGreen, size: 42),
          const SizedBox(height: 15),
          Text(
            'HAR CUP KI APNI KAHANI',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: bgGreen,
              fontSize: isMobile ? 23 : 32,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Battalion Chai ki journey ka hissa baniye. '
            'Ek cup chai ke saath ek nayi kahaani shuru karein.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textDark.withValues(alpha: 0.85),
              fontSize: 14,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Row(
      children: [
        Container(width: 25, height: 2, color: saffron),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: bgGreen,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  void _showFounderStory(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: cream,
          title: const Text(
            'The Story Behind the Dream',
            style: TextStyle(color: bgGreen, fontWeight: FontWeight.w900),
          ),
          content: const Text(
            'Bachpan se apna brand banane ka sapna. '
            'Indian chai culture se inspiration. Aur ek '
            'aisi pehchaan banane ki journey jo apne '
            'customers ke saath dil se judi ho. '
            'Yahi soch Battalion Chai ki shuruaat hai.',
            style: TextStyle(color: textDark, height: 1.7),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                'Close',
                style: TextStyle(color: bgGreen, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
