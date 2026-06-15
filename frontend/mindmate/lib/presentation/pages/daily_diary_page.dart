import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/constants/colors.dart';
import '../widgets/diary_grid/models/diary_page_data.dart';
import '../widgets/diary_grid/models/diary_image_block.dart';
import '../widgets/diary_grid/scrapbook_diary_editor.dart';

class DailyDiaryPage extends StatefulWidget {
  const DailyDiaryPage({super.key});

  @override
  State<DailyDiaryPage> createState() => _DailyDiaryPageState();
}

class _DailyDiaryPageState extends State<DailyDiaryPage> {
  List<DiaryPageData> _pages = [DiaryPageData()];
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
    setState(() {
      _pages.add(DiaryPageData());
      Future.delayed(const Duration(milliseconds: 100), () {
        _pageController.animateToPage(
          _pages.length - 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  Future<void> _pickImageForCurrentPage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        final newImage = DiaryImageBlock(
          imagePath: image.path,
          x: 2,
          y: 2,
          width: 6,
          height: 6,
        );
        _pages[_currentPageIndex].images.add(newImage);
        _isLayoutMode = true;
        _selectedImageId = newImage.id;
      });
    }
  }

  int get _totalWordCount {
    return _pages.fold(0, (sum, page) {
      if (page.text.trim().isEmpty) return sum;
      return sum + page.text.trim().split(RegExp(r'\s+')).length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B39EF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Edit Page ${_currentPageIndex + 1}",
          style: GoogleFonts.poppins(
            color: const Color(0xFF4B39EF),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.image_outlined, color: Color(0xFF4B39EF)),
            onPressed: _pickImageForCurrentPage,
            tooltip: "Add Image",
          ),
          if (_isLayoutMode)
            TextButton(
              onPressed: () {
                setState(() {
                  _isLayoutMode = false;
                  _selectedImageId = null;
                });
              },
              child: Text(
                "Done",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF4B39EF),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.add_box_outlined, color: Color(0xFF4B39EF)),
            onPressed: _addNewPage,
            tooltip: "Add Page",
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
                  margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
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
                            setState(() {
                              _pages[index] = newPageData;
                            });
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    color: _currentPageIndex > 0 ? const Color(0xFF4B39EF) : Colors.grey,
                    onPressed: _currentPageIndex > 0 ? () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } : null,
                  ),
                  Text(
                    "Page ${_currentPageIndex + 1} of ${_pages.length}  •  $_totalWordCount words",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF4B39EF),
                      fontSize: 12,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    color: _currentPageIndex < _pages.length - 1 ? const Color(0xFF4B39EF) : Colors.grey,
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
