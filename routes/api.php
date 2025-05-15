<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\FacultyController; // à inclure si tu veux accéder aux facultés
use App\Http\Controllers\MessageController;

use App\Http\Controllers\ReferenceController;
use App\Http\Controllers\DemandeReorientationController;
use App\Http\Controllers\NotificationController;


// Soumettre une demande de réorientation
Route::post('/demande-reorientation', [DemandeReorientationController::class, 'store']);

// Lister les demandes de réorientation
Route::get('/demandes-reorientation', [DemandeReorientationController::class, 'index']);

Route::post('/send-message', [MessageController::class, 'send']);


// Authentification
Route::post('/login', [AuthController::class, 'login']);
Route::post('/register', [AuthController::class, 'register']);

// Réinitialisation du mot de passe
Route::post('/password/email', [AuthController::class, 'sendPasswordResetLink']); // Envoi du lien
Route::get('/password/reset/{token}', [AuthController::class, 'showResetForm'])->name('password.reset'); // Formulaire
Route::post('/password/reset', [AuthController::class, 'resetPassword'])->name('password.update'); // Mise à jour

// Routes protégées par JWT
Route::middleware('auth:api')->group(function () {
    // Authentification
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::post('/token/refresh', [AuthController::class, 'refreshToken']);

    // Notifications
    // Routes de notification
    Route::get('/notifications', [NotificationController::class, 'index']);
    Route::get('/notifications/unread', [NotificationController::class, 'unread']);
    Route::get('/notifications/user/{userId}', [NotificationController::class, 'userNotifications']);
    Route::put('/notifications/{id}/read', [NotificationController::class, 'markAsRead']);
    Route::put('/notifications/read-all', [NotificationController::class, 'markAllAsRead']);
    Route::post('/notifications', [NotificationController::class, 'store']);
    Route::post('/notifications/reorientation', [NotificationController::class, 'notifierDemandeReorientation']);
    Route::delete('/notifications/{id}', [NotificationController::class, 'destroy']);
    
    // Messages
    Route::post('/send-message', [MessageController::class, 'send']);
    

    // Réorientation
    Route::prefix('reorientation')->group(function () {
        Route::post('/demandes', [DemandeReorientationController::class, 'soumettreDemande']);
        Route::get('/demandes/en-attente', [DemandeReorientationController::class, 'listerDemandesEnAttente']);
        Route::get('/demandes/etudiant/{id}', [DemandeReorientationController::class, 'listerDemandesEtudiant']);
        Route::put('/demandes/{id}/traiter', [DemandeReorientationController::class, 'traiterDemande']);
        
        // Nouvelle route pour récupérer l'ID étudiant d'une demande
        Route::get('/demandes/{id}/student', [DemandeReorientationController::class, 'getStudentId']);
        
        // Route pour les détails complets d'une demande
        Route::get('/demandes/{id}', [DemandeReorientationController::class, 'getDemandeDetails']);
    });

    // Références
    Route::prefix('register')->group(function () {
        Route::get('/roles', [ReferenceController::class, 'getRoles']);
        Route::get('/faculties', [ReferenceController::class, 'getFaculties']);
        Route::get('/filieres', [ReferenceController::class, 'getFilieresByFacultyName']);
        Route::get('/levels', [ReferenceController::class, 'getLevels']);
    });
});