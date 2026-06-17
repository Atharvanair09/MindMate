import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/colors.dart';
import '../widgets/diary_grid/models/diary_page_data.dart';
import '../widgets/diary_grid/models/diary_image_block.dart';
import '../widgets/diary_grid/scrapbook_diary_editor.dart';
import 'package:provider/provider.dart';
import '../../core/state/diary_provider.dart';

class DailyDiaryPage extends StatefulWidget {
  const DailyDiaryPage({super.key});

  @override
  State<DailyDiaryPage> createState() => _DailyDiaryPageState();
}

class _DailyDiaryPageState extends State<DailyDiaryPage> {
  int _currentPageIndex = 0;
  late PageController _pageController;

  bool _isLayoutMode = false;
  String? _selectedImageId;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
      viewportFraction: 1.0,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _addNewPage() {
    final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
    diaryProvider.addPage();
    Future.delayed(const Duration(milliseconds: 100), () {
      _pageController.animateToPage(
        diaryProvider.pages.length - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> _pickImageForCurrentPage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
      final newImage = await diaryProvider.addImageToPage(_currentPageIndex, image.path);
      
      if (newImage != null) {
        setState(() {
          _isLayoutMode = true;
          _selectedImageId = newImage.id;
        });
      }
    }
  }

  int _getTotalWordCount(List<DiaryPageData> pages) {
    return pages.fold(0, (sum, page) {
      if (page.text.trim().isEmpty) return sum;
      return sum + page.text.trim().split(RegExp(r'\s+')).length;
    });
  }

  void _showFontSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final diaryProvider = Provider.of<DiaryProvider>(context, listen: false);
            final pageData = diaryProvider.pages[_currentPageIndex];
            final fontFamilies = ['Poppins', 'Roboto', 'Lora', 'Caveat', 'Dancing Script'];
            
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Font Style", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: fontFamilies.map((font) {
                      final isSelected = pageData.fontFamily == font;
                      return ChoiceChip(
                        label: Text(font, style: GoogleFonts.getFont(font)),
                        selected: isSelected,
                        selectedColor: const Color(0xFF4B39EF).withOpacity(0.2),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              pageData.fontFamily = font;
                            });
                            diaryProvider.notifyPageChanged();
                            setModalState(() {});
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Text("Font Size", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold)),
                  Slider(
                    value: pageData.fontSize,
                    min: 12.0,
                    max: 32.0,
                    divisions: 10,
                    activeColor: const Color(0xFF4B39EF),
                    label: pageData.fontSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        pageData.fontSize = value;
                      });
                      diaryProvider.notifyPageChanged();
                      setModalState(() {});
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
        );
      },
    );
  }

  Widget _buildRetroButton({
    Widget? child,
    IconData? icon,
    required VoidCallback onPressed,
    Color color = Colors.white,
    Color iconColor = Colors.black,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: child ?? Icon(icon, color: iconColor, size: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final diaryProvider = Provider.of<DiaryProvider>(context);
    final _pages = diaryProvider.pages;
    final totalWordCount = _getTotalWordCount(_pages);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F1E3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F1E3),
        elevation: 0,
        toolbarHeight: 60,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(color: Colors.black, height: 2.0),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Center(
            child: _buildRetroButton(
              icon: Icons.arrow_back,
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          "EDIT PAGE ${_currentPageIndex + 1}",
          style: GoogleFonts.vt323(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Center(
              child: _buildRetroButton(
                child: const Text('Tt', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                onPressed: () => _showFontSettings(context),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Center(
              child: _buildRetroButton(
                icon: Icons.image_outlined,
                onPressed: _pickImageForCurrentPage,
              ),
            ),
          ),
          if (_isLayoutMode)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Center(
                child: _buildRetroButton(
                  icon: Icons.check,
                  onPressed: () {
                    setState(() {
                      _isLayoutMode = false;
                      _selectedImageId = null;
                    });
                  },
                  color: const Color(0xFF7D7017),
                  iconColor: Colors.white,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 4.0),
            child: Center(
              child: _buildRetroButton(
                icon: Icons.add,
                onPressed: _addNewPage,
                color: const Color(0xFF7D7017),
                iconColor: Colors.white,
              ),
            ),
          ),
        ],
        centerTitle: false,
      ),
      body: Column(
        children: [
          // Pages Area
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                  _isLayoutMode = false;
                  _selectedImageId = null;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F1E3),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(4, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Scrapbook Editor
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ScrapbookDiaryEditor(
                          pageData: _pages[index],
                          isLayoutMode: _isLayoutMode,
                          onLayoutModeChanged: (mode) {
                            setState(() {
                              _isLayoutMode = mode;
                            });
                          },
                          selectedImageId: _selectedImageId,
                          onImageSelected: (id) {
                            setState(() {
                              _selectedImageId = id;
                            });
                          },
                          onPageChanged: (newPageData) {
                            diaryProvider.updatePage(index, newPageData);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Bar for Page Navigation
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            decoration: const BoxDecoration(
              color: Color(0xFFB92A28),
              border: Border(
                top: BorderSide(color: Colors.black, width: 2),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, color: Colors.white),
                    onPressed: _currentPageIndex > 0 ? () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } : null,
                  ),
                  Text(
                    "PAGE ${_currentPageIndex + 1} OF ${_pages.length} - $totalWordCount WORDS",
                    style: GoogleFonts.vt323(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right, color: Colors.white),
                    onPressed: _currentPageIndex < _pages.length - 1 ? () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
