import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class AvatarPrivacyValidation {
  final bool isValid;
  final int facesDetected;
  final String? reason;

  AvatarPrivacyValidation({
    required this.isValid,
    required this.facesDetected,
    this.reason,
  });
}

class AvatarPrivacyService {
  AvatarPrivacyService._();
  static final AvatarPrivacyService instance = AvatarPrivacyService._();

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableContours: false,
      enableClassification: false,
      enableLandmarks: false,
      enableTracking: false,
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  Future<AvatarPrivacyValidation> validateAvatar(String imagePath) async {
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final List<Face> faces = await _faceDetector.processImage(inputImage);
      
      final facesDetected = faces.length;
      
      if (facesDetected > 0) {
        return AvatarPrivacyValidation(
          isValid: false,
          facesDetected: facesDetected,
          reason: 'For privacy reasons, profile pictures must not contain identifiable human faces.\n\nPlease choose an anonymous avatar.',
        );
      }
      
      return AvatarPrivacyValidation(
        isValid: true,
        facesDetected: 0,
      );
    } catch (e) {
      return AvatarPrivacyValidation(
        isValid: false,
        facesDetected: -1,
        reason: 'Error analyzing the image: $e',
      );
    }
  }

  void dispose() {
    _faceDetector.close();
  }
}
