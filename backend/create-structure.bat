@echo off

mkdir controllers
mkdir services
mkdir routes
mkdir middleware
mkdir utils
mkdir config

type nul > controllers\authController.js
type nul > controllers\journalController.js
type nul > controllers\moodController.js
type nul > controllers\escalationController.js

type nul > services\authService.js
type nul > services\journalService.js
type nul > services\moodService.js
type nul > services\riskService.js
type nul > services\escalationService.js
type nul > services\interventionService.js
type nul > services\analyticsService.js

type nul > routes\authRoutes.js
type nul > routes\journalRoutes.js
type nul > routes\moodRoutes.js
type nul > routes\escalationRoutes.js
type nul > routes\counselorRoutes.js

type nul > middleware\authMiddleware.js
type nul > middleware\errorHandler.js

type nul > utils\hashing.js
type nul > utils\validators.js
type nul > utils\responses.js

type nul > config\db.js

echo Structure Created!
pause